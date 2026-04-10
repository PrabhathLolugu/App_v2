import 'package:injectable/injectable.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/errors/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import 'package:talker_flutter/talker_flutter.dart';

/// Service for managing follow relationships between users.
///
/// Uses the follows table with schema:
/// - follower_id (uuid) - the user who is following
/// - following_id (uuid) - the user being followed
/// - created_at (timestamp)
///
/// All operations use auth.uid() for the follower_id to ensure
/// users can only manage their own follow relationships.
@lazySingleton
class FollowService {
  final SupabaseClient _supabase;

  FollowService(this._supabase);

  /// Follows a user by inserting a row into the follows table.
  ///
  /// [targetUserId] - The ID of the user to follow.
  ///
  /// Uses auth.uid() as follower_id.
  /// Handles duplicate follows safely by checking if already following first.
  /// Prevents following blocked users or users who blocked you.
  ///
  /// Throws [AuthException] if user is not authenticated.
  /// Throws [ServerException] on database errors.
  Future<void> followUser(String targetUserId) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw AuthException('User must be authenticated to follow');
      }

      // Prevent self-follow
      if (currentUserId == targetUserId) {
        logger.warning('[FollowService] User attempted to follow themselves');
        return;
      }

      // Check if there's any blocking between users
      final blockCheck = await _supabase
          .from('user_blocks')
          .select('id')
          .or(
            'and(blocker_id.eq.$currentUserId,blocked_id.eq.$targetUserId),and(blocker_id.eq.$targetUserId,blocked_id.eq.$currentUserId)',
          )
          .maybeSingle();

      if (blockCheck != null) {
        logger.warning('[FollowService] Cannot follow due to blocking');
        throw ServerException('Cannot follow this user', 'BLOCKED_USER_ERROR');
      }

      // Check if already following to avoid duplicate insert errors
      final alreadyFollowing = await isFollowing(targetUserId);
      if (alreadyFollowing) {
        logger.info(
          '[FollowService] User $currentUserId already follows $targetUserId',
        );
        return;
      }

      // Simple insert (not upsert) now that we checked for duplicates
      await _supabase.from('follows').insert({
        'follower_id': currentUserId,
        'following_id': targetUserId,
      });

      logger.info('[FollowService] User $currentUserId followed $targetUserId');
    } on AuthException {
      rethrow;
    } catch (e) {
      logger.error('[FollowService] Error following user: $e');
      throw ServerException(
        'Failed to follow user: ${e.toString()}',
        'FOLLOW_USER_ERROR',
      );
    }
  }

  /// Unfollows a user by deleting the row from the follows table.
  ///
  /// [targetUserId] - The ID of the user to unfollow.
  ///
  /// Uses auth.uid() as follower_id to match the row.
  /// Safe to call even if not currently following (no error on missing row).
  ///
  /// Throws [AuthException] if user is not authenticated.
  /// Throws [ServerException] on database errors.
  Future<void> unfollowUser(String targetUserId) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw AuthException('User must be authenticated to unfollow');
      }

      await _supabase
          .from('follows')
          .delete()
          .eq('follower_id', currentUserId)
          .eq('following_id', targetUserId);

      logger.info(
        '[FollowService] User $currentUserId unfollowed $targetUserId',
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      logger.error('[FollowService] Error unfollowing user: $e');
      throw ServerException(
        'Failed to unfollow user: ${e.toString()}',
        'UNFOLLOW_USER_ERROR',
      );
    }
  }

  /// Checks if the current user is following a target user.
  ///
  /// [targetUserId] - The ID of the user to check.
  ///
  /// Returns true if a follow relationship exists, false otherwise.
  ///
  /// Throws [AuthException] if user is not authenticated.
  /// Throws [ServerException] on database errors.
  Future<bool> isFollowing(String targetUserId) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw AuthException(
          'User must be authenticated to check follow status',
        );
      }

      // Check if self - user cannot follow themselves
      if (currentUserId == targetUserId) {
        return false;
      }

      final response = await _supabase
          .from('follows')
          .select('follower_id')
          .eq('follower_id', currentUserId)
          .eq('following_id', targetUserId)
          .maybeSingle();

      return response != null;
    } on AuthException {
      rethrow;
    } catch (e) {
      logger.error('[FollowService] Error checking follow status: $e');
      throw ServerException(
        'Failed to check follow status: ${e.toString()}',
        'CHECK_FOLLOW_ERROR',
      );
    }
  }

  /// Gets the count of followers for a user.
  ///
  /// [userId] - The ID of the user to get followers count for.
  ///
  /// Returns the number of users following this user.
  /// Uses efficient count-only query (no full row fetch).
  ///
  /// Throws [ServerException] on database errors.
  Future<int> getFollowersCount(String userId) async {
    final logger = getIt<Talker>();

    try {
      final response = await _supabase
          .from('follows')
          .select()
          .eq('following_id', userId)
          .count(CountOption.exact);

      return response.count;
    } catch (e) {
      logger.error('[FollowService] Error getting followers count: $e');
      throw ServerException(
        'Failed to get followers count: ${e.toString()}',
        'GET_FOLLOWERS_COUNT_ERROR',
      );
    }
  }

  /// Gets the count of users that a user is following.
  ///
  /// [userId] - The ID of the user to get following count for.
  ///
  /// Returns the number of users this user is following.
  /// Uses efficient count-only query (no full row fetch).
  ///
  /// Throws [ServerException] on database errors.
  Future<int> getFollowingCount(String userId) async {
    final logger = getIt<Talker>();

    try {
      final response = await _supabase
          .from('follows')
          .select()
          .eq('follower_id', userId)
          .count(CountOption.exact);

      return response.count;
    } catch (e) {
      logger.error('[FollowService] Error getting following count: $e');
      throw ServerException(
        'Failed to get following count: ${e.toString()}',
        'GET_FOLLOWING_COUNT_ERROR',
      );
    }
  }

  /// Gets the list of followers for a user with their profile data.
  ///
  /// [userId] - The ID of the user to get followers for.
  ///
  /// Returns a list of profile data (id, username, full_name, avatar_url)
  /// for users who are following this user.
  ///
  /// Joins follows table with profiles table to fetch complete profile data.
  ///
  /// Throws [ServerException] on database errors.
  Future<List<Map<String, dynamic>>> getFollowers(String userId) async {
    final logger = getIt<Talker>();

    try {
      // Query follows table and join with profiles table
      // Get users where following_id = userId (users who follow this user)
      final response = await _supabase
          .from('follows')
          .select(
            'follower:profiles!follows_follower_profile_fkey('
            'id, username, full_name, avatar_url)',
          )
          .eq('following_id', userId);

      // Transform the response to extract profile data
      final followers = (response as List)
          .map((item) {
            final profile = item['follower'];
            if (profile != null) {
              return {
                'id': profile['id'],
                'username': profile['username'],
                'full_name': profile['full_name'],
                'avatar_url': profile['avatar_url'],
              };
            }
            return null;
          })
          .whereType<Map<String, dynamic>>()
          .toList();

      logger.info(
        '[FollowService] Fetched ${followers.length} followers for user $userId',
      );
      return followers;
    } catch (e) {
      logger.error('[FollowService] Error getting followers: $e');
      throw ServerException(
        'Failed to get followers: ${e.toString()}',
        'GET_FOLLOWERS_ERROR',
      );
    }
  }

  /// Gets the list of users that a user is following with their profile data.
  ///
  /// [userId] - The ID of the user to get following list for.
  ///
  /// Returns a list of profile data (id, username, full_name, avatar_url)
  /// for users that this user is following.
  ///
  /// Joins follows table with profiles table to fetch complete profile data.
  ///
  /// Throws [ServerException] on database errors.
  Future<List<Map<String, dynamic>>> getFollowing(String userId) async {
    final logger = getIt<Talker>();

    try {
      // Query follows table and join with profiles table
      // Get users where follower_id = userId (users this user follows)
      final response = await _supabase
          .from('follows')
          .select(
            'following:profiles!follows_following_profile_fkey('
            'id, username, full_name, avatar_url)',
          )
          .eq('follower_id', userId);

      // Transform the response to extract profile data
      final following = (response as List)
          .map((item) {
            final profile = item['following'];
            if (profile != null) {
              return {
                'id': profile['id'],
                'username': profile['username'],
                'full_name': profile['full_name'],
                'avatar_url': profile['avatar_url'],
              };
            }
            return null;
          })
          .whereType<Map<String, dynamic>>()
          .toList();

      logger.info(
        '[FollowService] Fetched ${following.length} following for user $userId',
      );
      return following;
    } catch (e) {
      logger.error('[FollowService] Error getting following: $e');
      throw ServerException(
        'Failed to get following: ${e.toString()}',
        'GET_FOLLOWING_ERROR',
      );
    }
  }

  /// Checks if the current user is followed by the [targetUserId].
  ///
  /// Returns true if [targetUserId] follows the current user.
  Future<bool> isFollowedBy(String targetUserId) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) return false;

      final response = await _supabase
          .from('follows')
          .select('follower_id')
          .eq('follower_id', targetUserId)
          .eq('following_id', currentUserId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      logger.error('[FollowService] Error checking if user is followed: $e');
      return false;
    }
  }

  /// Checks if the current user and [targetUserId] are mutual followers.
  Future<bool> areMutualFollowers(String targetUserId) async {
    final results = await Future.wait([
      isFollowing(targetUserId),
      isFollowedBy(targetUserId),
    ]);
    return results[0] && results[1];
  }

  /// Returns the subset of [targetUserIds] followed by the current user.
  ///
  /// If [targetUserIds] is null, returns all user IDs followed by the current user.
  Future<Set<String>> getFollowingIdsForCurrentUser({
    List<String>? targetUserIds,
  }) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) return <String>{};

      var query = _supabase
          .from('follows')
          .select('following_id')
          .eq('follower_id', currentUserId);

      if (targetUserIds != null && targetUserIds.isNotEmpty) {
        query = query.inFilter('following_id', targetUserIds);
      }

      final response = await query;

      return (response as List)
          .map((row) => row['following_id'] as String?)
          .whereType<String>()
          .toSet();
    } catch (e) {
      logger.error('[FollowService] Error fetching followed IDs map: $e');
      throw ServerException(
        'Failed to fetch followed IDs: ${e.toString()}',
        'GET_FOLLOWED_IDS_ERROR',
      );
    }
  }

  /// Returns the subset of [sourceUserIds] that follow the current user.
  ///
  /// If [sourceUserIds] is null, returns all follower IDs for the current user.
  Future<Set<String>> getFollowerIdsForCurrentUser({
    List<String>? sourceUserIds,
  }) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) return <String>{};

      var query = _supabase
          .from('follows')
          .select('follower_id')
          .eq('following_id', currentUserId);

      if (sourceUserIds != null && sourceUserIds.isNotEmpty) {
        query = query.inFilter('follower_id', sourceUserIds);
      }

      final response = await query;

      return (response as List)
          .map((row) => row['follower_id'] as String?)
          .whereType<String>()
          .toSet();
    } catch (e) {
      logger.error('[FollowService] Error fetching follower IDs map: $e');
      throw ServerException(
        'Failed to fetch follower IDs: ${e.toString()}',
        'GET_FOLLOWER_IDS_ERROR',
      );
    }
  }
}
