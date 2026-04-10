import 'dart:math';

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/errors/exceptions.dart';
import 'package:myitihas/services/follow_service.dart';
import 'package:myitihas/services/profile_ranking.dart';
import 'package:myitihas/services/user_block_service.dart';

/// Service for managing user profile data in the profiles table.
/// 
/// IMPORTANT: The profiles table is the canonical source of truth for all profile data.
/// The users table remains for private/internal data only and is NOT queried or updated here.
/// 
/// Profile fields managed:
/// - username
/// - full_name
/// - avatar_url
/// - bio
/// - is_private
@lazySingleton
class ProfileService {
  final SupabaseClient _supabase;

  ProfileService(this._supabase);

  /// Fetches the current authenticated user's profile from the profiles table.
  /// 
  /// Uses auth.uid() to identify the logged-in user.
  /// Returns null if the profile row doesn't exist yet (graceful handling).
  /// 
  /// Data source: profiles table (NOT users table)
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    final logger = getIt<Talker>();
    
    try {
      // Get authenticated user ID
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return null;
      }

      // Query profiles table using auth.uid()
      // profiles table is the canonical source for profile data
      final response = await _supabase
          .from('profiles')
          .select('id, username, full_name, avatar_url, bio, is_private')
          .eq('id', userId)
          .maybeSingle(); // Returns null if no row found instead of throwing

      if (response == null) {
        return null; // Gracefully handle missing profile
      }
      
      return response;
    } catch (e) {
      logger.error('[ProfileService] Error fetching profile: $e');
      throw ServerException(
        'Failed to fetch user profile: ${e.toString()}',
        'FETCH_PROFILE_ERROR',
      );
    }
  }

  /// Fetches any user's profile by their user ID from the profiles table.
  /// 
  /// Data source: profiles table (NOT users table)
  /// Throws NotFoundException if profile doesn't exist.
  Future<Map<String, dynamic>> getProfileById(String userId) async {
    final logger = getIt<Talker>();
    
    try {
      // Query profiles table - canonical source for profile data
      final response = await _supabase
          .from('profiles')
          .select('id, username, full_name, avatar_url, bio, is_private')
          .eq('id', userId)
          .single(); // Throws if not found
      
      return response;
    } catch (e) {
      logger.error('[ProfileService] Error fetching profile: $e');
      if (e.toString().contains('406') || e.toString().contains('not found')) {
        throw NotFoundException(
          'Profile not found',
          'PROFILE_NOT_FOUND',
        );
      }
      throw ServerException(
        'Failed to fetch profile: ${e.toString()}',
        'FETCH_PROFILE_ERROR',
      );
    }
  }

  /// Updates the current authenticated user's profile in the profiles table.
  /// 
  /// Only updates provided (non-null) fields.
  /// Uses auth.uid() to ensure users can only update their own profile.
  /// 
  /// Data destination: profiles table ONLY (users table is NOT updated)
  Future<void> updateCurrentUserProfile({
    String? username,
    String? fullName,
    String? avatarUrl,
    String? bio,
    bool? isPrivate,
  }) async {
    final logger = getIt<Talker>();
    
    try {
      // Get authenticated user ID
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Not authenticated');
      }

      // Build update map with only provided fields
      final updates = <String, dynamic>{};
      
      if (username != null) {
        updates['username'] = username;
      }
      if (fullName != null) {
        updates['full_name'] = fullName;
      }
      if (bio != null) {
        updates['bio'] = bio;
      }
      if (avatarUrl != null) {
        updates['avatar_url'] = avatarUrl;
      }
      if (isPrivate != null) {
        updates['is_private'] = isPrivate;
      }

      if (updates.isEmpty) {
        return; // Nothing to update
      }

      updates['updated_at'] = DateTime.now().toIso8601String();

      // Update profiles table ONLY - canonical source for profile data
      // Do NOT update users table anymore
      await _supabase
          .from('profiles')
          .update(updates)
          .eq('id', userId);
    } catch (e) {
      logger.error('[ProfileService] Error updating profile: $e');
      throw ServerException(
        'Failed to update profile: ${e.toString()}',
        'UPDATE_PROFILE_ERROR',
      );
    }
  }

  /// Fetches public user profiles from the profiles table with pagination.
  /// 
  /// Excludes the current authenticated user.
  /// Returns a ranked list of profiles with basic information.
  /// 
  /// Parameters:
  /// - limit: Maximum number of profiles to fetch
  /// - offset: Number of profiles to skip (for pagination)
  /// 
  /// Data source: profiles table (NOT users table)
  Future<List<Map<String, dynamic>>> fetchPublicProfiles({
    required int limit,
    required int offset,
  }) async {
    final logger = getIt<Talker>();
    
    try {
      // Get authenticated user ID to exclude from results
      final userId = _supabase.auth.currentUser?.id;
      
      // Query profiles table - canonical source for profile data
      final query = _supabase
          .from('profiles')
          .select('id, username, full_name, avatar_url')
          .range(offset, offset + limit - 1);

      final response = await query;
      
      // Filter out current user if authenticated
      List<Map<String, dynamic>> profiles = List<Map<String, dynamic>>.from(response);
      if (userId != null) {
        profiles = profiles.where((profile) => profile['id'] != userId).toList();
      }
      
      return await _rankProfiles(profiles);
    } catch (e) {
      logger.error('[ProfileService] Error fetching public profiles: $e');
      throw ServerException(
        'Failed to fetch public profiles: ${e.toString()}',
        'FETCH_PUBLIC_PROFILES_ERROR',
      );
    }
  }

  /// Searches for profiles by username or full name in the profiles table.
  /// 
  /// Data source: profiles table (NOT users table)
  Future<List<Map<String, dynamic>>> searchProfiles(String query) async {
    final logger = getIt<Talker>();
    
    try {
      // Query profiles table - canonical source for profile data
      final response = await _supabase
          .from('profiles')
          .select('id, username, full_name, avatar_url, bio, is_private')
          .or('username.ilike.%$query%,full_name.ilike.%$query%')
          .limit(20);
      
      return await _rankProfiles(List<Map<String, dynamic>>.from(response));
    } catch (e) {
      logger.error('[ProfileService] Error searching profiles: $e');
      throw ServerException(
        'Failed to search profiles: ${e.toString()}',
        'SEARCH_PROFILES_ERROR',
      );
    }
  }

  Future<List<Map<String, dynamic>>> _rankProfiles(
    List<Map<String, dynamic>> profiles,
  ) async {
    if (profiles.isEmpty) {
      return profiles;
    }

    final currentUserId = _supabase.auth.currentUser?.id;
    final candidateIds = profiles
        .map((profile) => profile['id'] as String?)
        .whereType<String>()
        .toList(growable: false);

    final blockedIds = await _safeLoadUserIds(
      () => getIt<UserBlockService>().getBlockedUsers(),
    );
    final blockerIds = await _safeLoadUserIds(
      () => getIt<UserBlockService>().getUsersWhoBlockedMe(),
    );

    Set<String> currentFollowingIds = <String>{};
    Set<String> currentFollowerIds = <String>{};
    Map<String, Set<String>> candidateFollowingByUserId = <String, Set<String>>{};
    Map<String, Set<String>> candidateFollowerByUserId = <String, Set<String>>{};

    try {
      final followService = getIt<FollowService>();
      currentFollowingIds = await followService.getFollowingIdsForCurrentUser();
      currentFollowerIds = await followService.getFollowerIdsForCurrentUser();
      candidateFollowingByUserId = await _getCandidateConnectionMap(
        candidateIds: candidateIds,
        matchColumn: 'follower_id',
        relatedColumn: 'following_id',
      );
      candidateFollowerByUserId = await _getCandidateConnectionMap(
        candidateIds: candidateIds,
        matchColumn: 'following_id',
        relatedColumn: 'follower_id',
      );
    } catch (e) {
      // If ranking data cannot be loaded, fall back to randomized ordering.
      candidateFollowingByUserId = <String, Set<String>>{};
      candidateFollowerByUserId = <String, Set<String>>{};
      currentFollowingIds = <String>{};
      currentFollowerIds = <String>{};
      getIt<Talker>().warning('[ProfileService] Falling back to simple profile ranking: $e');
    }

    return ProfileRankingHelper.rankProfiles(
      profiles: profiles,
      currentFollowingIds: currentFollowingIds,
      currentFollowerIds: currentFollowerIds,
      candidateFollowingByUserId: candidateFollowingByUserId,
      candidateFollowerByUserId: candidateFollowerByUserId,
      blockedUserIds: blockedIds,
      blockerUserIds: blockerIds,
      currentUserId: currentUserId,
      random: Random(),
    );
  }

  Future<Set<String>> _safeLoadUserIds(
    Future<List<String>> Function() loader,
  ) async {
    try {
      return (await loader()).toSet();
    } catch (_) {
      return <String>{};
    }
  }

  Future<Map<String, Set<String>>> _getCandidateConnectionMap({
    required List<String> candidateIds,
    required String matchColumn,
    required String relatedColumn,
  }) async {
    final connections = <String, Set<String>>{};
    if (candidateIds.isEmpty) {
      return connections;
    }

    for (final chunk in _chunked(candidateIds, 200)) {
      final response = await _supabase
          .from('follows')
          .select('$matchColumn, $relatedColumn')
          .inFilter(matchColumn, chunk);

      for (final row in response as List) {
        final userId = row[matchColumn] as String?;
        final connectionId = row[relatedColumn] as String?;
        if (userId == null || connectionId == null) {
          continue;
        }
        connections.putIfAbsent(userId, () => <String>{}).add(connectionId);
      }
    }

    return connections;
  }

  List<List<T>> _chunked<T>(List<T> values, int chunkSize) {
    final chunks = <List<T>>[];
    for (var index = 0; index < values.length; index += chunkSize) {
      final endIndex = (index + chunkSize < values.length)
          ? index + chunkSize
          : values.length;
      chunks.add(values.sublist(index, endIndex));
    }
    return chunks;
  }

  /// Maps lowercase username → profile id for @mention resolution (batch).
  ///
  /// Uses case-insensitive username match per handle. Unknown usernames omitted.
  Future<Map<String, String>> getUserIdsByUsernames(
    List<String> usernames,
  ) async {
    final logger = getIt<Talker>();
    final unique = usernames
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
    if (unique.isEmpty) return {};

    final out = <String, String>{};
    try {
      for (final u in unique) {
        final row = await _supabase
            .from('profiles')
            .select('id, username')
            .ilike('username', u)
            .maybeSingle();
        if (row != null) {
          out[u.toLowerCase()] = row['id'] as String;
        }
      }
      return out;
    } catch (e) {
      logger.error('[ProfileService] Error resolving usernames: $e');
      throw ServerException(
        'Failed to resolve usernames: ${e.toString()}',
        'RESOLVE_USERNAMES_ERROR',
      );
    }
  }
}
