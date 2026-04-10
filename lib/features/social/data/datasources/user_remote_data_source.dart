import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/errors/failures.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/features/story_generator/domain/entities/story_translation.dart';
import 'package:myitihas/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:myitihas/core/errors/exceptions.dart';
import 'package:myitihas/core/di/injection_container.dart';
import '../models/user_model.dart';

/// Remote data source for user data using Supabase
abstract class UserRemoteDataSource {
  Future<UserModel> getUserById(String userId);
  Future<List<UserModel>> getAllUsers();
  Future<List<UserModel>> searchUsers(String query);
  Future<void> updateUser({
    required String userId,
    String? displayName,
    String? bio,
    String? avatarUrl,
  });
  Future<Either<Failure, Story>> getStoryById(String storyId);
}

/// Implementation of user remote data source with Supabase
@LazySingleton(as: UserRemoteDataSource)
class UserRemoteDataSourceSupabase implements UserRemoteDataSource {
  final SupabaseClient _supabase;

  UserRemoteDataSourceSupabase(this._supabase);

  @override
  Future<UserModel> getUserById(String userId) async {
    final logger = getIt<Talker>();
    logger.info('🔍 [DataSource] Fetching user by ID: $userId');

    try {
      // Query profiles table - canonical source for profile data
      final response = await _supabase
          .from('profiles')
          .select('id, username, full_name, avatar_url, bio, saved_stories')
          .eq('id', userId)
          .single();

      logger.debug('📦 [DataSource] Raw response: $response');
      logger.info('🖼️ [DataSource] avatar_url from DB: ${response['avatar_url']}');

      final userModel = UserModel(
        id: response['id'] as String,
        username: response['username'] as String,
        displayName: response['full_name'] as String,
        avatarUrl: response['avatar_url'] as String? ?? '',
        bio: response['bio'] as String? ?? '',
        savedStories:
            (response['saved_stories'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        followerCount: 0,
        followingCount: 0,
        isFollowing: false,
        isCurrentUser: false,
      );

      logger.info('✅ [DataSource] UserModel avatarUrl: ${userModel.avatarUrl}');
      return userModel;
    } catch (e) {
      logger.error('❌ [DataSource] Error fetching user: $e');
      if (e.toString().contains('406') || e.toString().contains('not found')) {
        throw NotFoundException(
          'User not found',
          'USER_NOT_FOUND',
        );
      }
      throw ServerException(
        'Failed to fetch user: ${e.toString()}',
        'FETCH_USER_ERROR',
      );
    }
  }

  @override
  Future<Either<Failure, Story>> getStoryById(String storyId) async {
    try {
      final response = await SupabaseService.client
          .from('stories')
          .select()
          .eq('id', storyId)
          .single();

      return Right(_mapSupabaseRowToStory(response));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch story: ${e.toString()}'));
    }
  }

  Story _mapSupabaseRowToStory(Map<String, dynamic> row) {
    final attr =
        (row['attributes'] as Map?)?.cast<String, dynamic>() ??
        <String, dynamic>{};
    final characterDetails =
        (attr['character_details'] as Map?)?.cast<String, dynamic>() ??
        <String, dynamic>{};

    return Story(
      id: row['id']!.toString(),
      authorId: row['user_id']?.toString(),
      title: row['title']?.toString() ?? 'Untitled Story',
      story: row['content']?.toString() ?? '',
      scripture: attr['scripture']?.toString() ?? 'Scripture',
      quotes: attr['quotes']?.toString() ?? '',
      trivia: attr['trivia']?.toString() ?? '',
      activity: attr['activity']?.toString() ?? '',
      lesson: attr['moral']?.toString() ?? '',
      attributes: StoryAttributes(
        storyType: attr['story_type']?.toString() ?? 'General',
        theme: attr['theme']?.toString() ?? 'Dharma (Duty)',
        mainCharacterType:
            attr['main_character_type']?.toString() ?? 'Protagonist',
        storySetting: attr['story_setting']?.toString() ?? 'Ancient India',
        timeEra: attr['time_era']?.toString() ?? 'Ancient',
        narrativePerspective:
            attr['narrative_perspective']?.toString() ?? 'Third Person',
        languageStyle:
            row['language']?.toString() ??
            attr['language_style']?.toString() ??
            'English',
        emotionalTone: attr['emotional_tone']?.toString() ?? 'Inspirational',
        narrativeStyle: attr['narrative_style']?.toString() ?? 'Narrative',
        plotStructure: attr['plot_structure']?.toString() ?? 'Linear',
        storyLength: attr['story_length']?.toString() ?? 'Medium ~1000 words',
        tags: (attr['tags'] as List<dynamic>? ?? const [])
            .map((tag) => tag.toString())
            .toList(),
        references: (attr['references'] is List)
            ? (attr['references'] as List<dynamic>)
                  .map((e) => e.toString())
                  .toList()
            : [attr['references']?.toString() ?? ''],
        characters: (attr['characters'] as List<dynamic>? ?? const [])
            .map((char) => char.toString())
            .toList(),
        characterDetails: characterDetails,
        translations: _parseTranslations(attr['translations']),
      ),
      imageUrl: row['image_url']?.toString(),
      createdAt: row['created_at'] != null
          ? DateTime.tryParse(row['created_at'].toString())
          : null,
      updatedAt: row['updated_at'] != null
          ? DateTime.tryParse(row['updated_at'].toString())
          : null,
      publishedAt: row['published_at'] != null
          ? DateTime.tryParse(row['published_at'].toString())
          : null,
      author: row['author']?.toString(),
      likes: (row['likes'] is int)
          ? row['likes'] as int
          : (row['likes'] as num?)?.toInt() ?? 0,
      views: (row['views'] is int)
          ? row['views'] as int
          : (row['views'] as num?)?.toInt() ?? 0,
      isFavorite: row['is_favourite'] as bool? ?? false,
      commentCount: (row['comment_count'] as num?)?.toInt() ?? 0,
      shareCount: (row['share_count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, TranslatedStory> _parseTranslations(dynamic raw) {
    if (raw == null) return <String, TranslatedStory>{};

    if (raw is Map) {
      final out = <String, TranslatedStory>{};

      for (final entry in raw.entries) {
        final lang = entry.key.toString();
        final val = entry.value;

        if (val == null) continue;

        if (val is Map<String, dynamic>) {
          out[lang] = TranslatedStory.fromJson(val);
          continue;
        }
        if (val is Map) {
          out[lang] = TranslatedStory.fromJson(Map<String, dynamic>.from(val));
          continue;
        }

        if (val is String) {
          try {
            final decoded = jsonDecode(val);
            if (decoded is Map) {
              out[lang] = TranslatedStory.fromJson(
                Map<String, dynamic>.from(decoded),
              );
            }
          } catch (_) {}
        }
      }

      return out;
    }

    return <String, TranslatedStory>{};
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      // Query profiles table - canonical source for profile data
      final response = await _supabase
          .from('profiles')
          .select('id, username, full_name, avatar_url, bio')
          .order('created_at', ascending: false);

      return (response as List).map((user) {
        return UserModel(
          id: user['id'] as String,
          username: user['username'] as String,
          displayName: user['full_name'] as String,
          avatarUrl: user['avatar_url'] as String? ?? '',
          bio: user['bio'] as String? ?? '',
          followerCount: 0,
          followingCount: 0,
          isFollowing: false,
          isCurrentUser: false,
        );
      }).toList();
    } catch (e) {
      throw ServerException(
        'Failed to fetch users: ${e.toString()}',
        'FETCH_USERS_ERROR',
      );
    }
  }

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      // Query profiles table - canonical source for profile data
      final response = await _supabase
          .from('profiles')
          .select('id, username, full_name, avatar_url, bio')
          .or('username.ilike.%$query%,full_name.ilike.%$query%')
          .limit(20);

      return (response as List).map((user) {
        return UserModel(
          id: user['id'] as String,
          username: user['username'] as String,
          displayName: user['full_name'] as String,
          avatarUrl: user['avatar_url'] as String? ?? '',
          bio: user['bio'] as String? ?? '',
          followerCount: 0,
          followingCount: 0,
          isFollowing: false,
          isCurrentUser: false,
        );
      }).toList();
    } catch (e) {
      throw ServerException(
        'Failed to search users: ${e.toString()}',
        'SEARCH_USERS_ERROR',
      );
    }
  }

  @override
  Future<void> updateUser({
    required String userId,
    String? displayName,
    String? bio,
    String? avatarUrl,
  }) async {
    try {
      final updates = <String, dynamic>{};

      if (displayName != null) {
        updates['full_name'] = displayName;
      }
      if (bio != null) {
        updates['bio'] = bio;
      }
      if (avatarUrl != null) {
        updates['avatar_url'] = avatarUrl;
      }

      if (updates.isEmpty) {
        return; // Nothing to update
      }

      updates['updated_at'] = DateTime.now().toIso8601String();

      // Update profiles table ONLY - canonical source for profile data
      // Do NOT update users table anymore
      await _supabase.from('profiles').update(updates).eq('id', userId);
    } catch (e) {
      throw ServerException(
        'Failed to update user: ${e.toString()}',
        'UPDATE_USER_ERROR',
      );
    }
  }
}
