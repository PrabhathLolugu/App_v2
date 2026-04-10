import 'dart:io';

import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/errors/exceptions.dart';
import 'package:myitihas/core/errors/failures.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/repository/my_itihas_repository.dart';
import 'package:myitihas/services/follow_service.dart';
import 'package:myitihas/services/profile_storage_service.dart';
import 'package:myitihas/services/supabase_service.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';
import '../models/user.model.dart' as brick;
import '../models/user_model.dart';

/// Implementation of UserRepository
@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource dataSource;
  final ProfileStorageService storageService;
  final FollowService followService;
  final MyItihasRepository repository;

  UserRepositoryImpl({
    required this.dataSource,
    required this.storageService,
    required this.followService,
    required this.repository,
  });

  Future<Set<String>> _getFollowedIdsForCurrentUser(
    List<String> targetUserIds,
  ) async {
    final ids = targetUserIds.where((id) => id.isNotEmpty).toSet().toList();
    if (ids.isEmpty) return <String>{};

    try {
      return await followService.getFollowingIdsForCurrentUser(
        targetUserIds: ids,
      );
    } catch (_) {
      return <String>{};
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      // Get authenticated user ID from Supabase Auth
      final authUser = SupabaseService.authService.getCurrentUser();
      if (authUser == null) {
        return Left(AuthFailure('Not authenticated', 'NOT_AUTH'));
      }

      // Try Brick offline-first approach first
      // Use alwaysHydrate to always fetch fresh data from remote (important for profile updates)
      try {
        final models = await repository.get<brick.UserModel>(
          policy: OfflineFirstGetPolicy.alwaysHydrate,
          query: Query.where('id', authUser.id),
        );

        if (models.isNotEmpty) {
          final brickUser = models.first;
          return Right(
            User(
              id: brickUser.id,
              username: brickUser.username,
              displayName: brickUser.displayName ?? brickUser.username,
              avatarUrl: brickUser.avatarUrl ?? '',
              bio: brickUser.bio ?? '',
              followerCount: 0,
              followingCount: 0,
              isFollowing: false,
              isCurrentUser: true,
              savedStories: const [],
              isVerified: brickUser.isVerified,
              acceptsDirectMessages: brickUser.acceptsDirectMessages,
              isOfficialMyitihas: brickUser.isOfficialMyitihas,
            ),
          );
        }
      } catch (e) {
        // Brick failed, try local-only as fallback
        final logger = getIt<Talker>();
        logger.warning('Brick fetch failed, trying local cache: $e');

        try {
          final localModels = await repository.get<brick.UserModel>(
            policy: OfflineFirstGetPolicy.localOnly,
            query: Query.where('id', authUser.id),
          );

          if (localModels.isNotEmpty) {
            final brickUser = localModels.first;
            return Right(
              User(
                id: brickUser.id,
                username: brickUser.username,
                displayName: brickUser.displayName ?? brickUser.username,
                avatarUrl: brickUser.avatarUrl ?? '',
                bio: brickUser.bio ?? '',
                followerCount: 0,
                followingCount: 0,
                isFollowing: false,
                isCurrentUser: true,
                savedStories: const [],
                isVerified: brickUser.isVerified,
                acceptsDirectMessages: brickUser.acceptsDirectMessages,
                isOfficialMyitihas: brickUser.isOfficialMyitihas,
              ),
            );
          }
        } catch (_) {
          // Local cache also failed, continue to remote fallback
        }
      }

      // Fallback to direct Supabase call if Brick didn't have the user
      final userModel = await dataSource.getUserById(authUser.id);
      return Right(userModel.copyWith(isCurrentUser: true).toEntity());
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message, e.code));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setCurrentUser(String userId) async {
    try {
      // Verify user exists in profiles table
      await dataSource.getUserById(userId);
      // Note: Current user is managed by Supabase Auth, not manually set
      return const Right(null);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message, e.code));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getUserProfile(String userId) async {
    try {
      final currentUserResult = await getCurrentUser();
      String? currentUserId;
      currentUserResult.fold((l) => null, (user) => currentUserId = user.id);

      // Try Brick offline-first approach first
      // Use alwaysHydrate to always fetch fresh data from remote (important for profile updates)
      User? user;
      try {
        final models = await repository.get<brick.UserModel>(
          policy: OfflineFirstGetPolicy.alwaysHydrate,
          query: Query.where('id', userId),
        );

        if (models.isNotEmpty) {
          final brickUser = models.first;
          user = User(
            id: brickUser.id,
            username: brickUser.username,
            displayName: brickUser.displayName ?? brickUser.username,
            avatarUrl: brickUser.avatarUrl ?? '',
            bio: brickUser.bio ?? '',
            followerCount: 0,
            followingCount: 0,
            isFollowing: false,
            isCurrentUser: currentUserId == userId,
            savedStories: const [],
            isVerified: brickUser.isVerified,
            acceptsDirectMessages: brickUser.acceptsDirectMessages,
            isOfficialMyitihas: brickUser.isOfficialMyitihas,
          );
        }
      } catch (e) {
        // Brick failed, try local cache
        final logger = getIt<Talker>();
        logger.warning('Brick getUserProfile failed, trying local cache: $e');

        try {
          final localModels = await repository.get<brick.UserModel>(
            policy: OfflineFirstGetPolicy.localOnly,
            query: Query.where('id', userId),
          );

          if (localModels.isNotEmpty) {
            final brickUser = localModels.first;
            user = User(
              id: brickUser.id,
              username: brickUser.username,
              displayName: brickUser.displayName ?? brickUser.username,
              avatarUrl: brickUser.avatarUrl ?? '',
              bio: brickUser.bio ?? '',
              followerCount: 0,
              followingCount: 0,
              isFollowing: false,
              isCurrentUser: currentUserId == userId,
              savedStories: const [],
              isVerified: brickUser.isVerified,
              acceptsDirectMessages: brickUser.acceptsDirectMessages,
              isOfficialMyitihas: brickUser.isOfficialMyitihas,
            );
          }
        } catch (_) {
          // Local cache also failed
        }
      }

      // Fallback to direct Supabase call if Brick didn't have the user
      if (user == null) {
        final userModel = await dataSource.getUserById(userId);
        user = userModel
            .copyWith(isCurrentUser: currentUserId == userId)
            .toEntity();
      }

      // Fetch social counts independently (failures in one don't affect others)
      int followersCount = 0;
      int followingCount = 0;
      bool isFollowing = false;
      final logger = getIt<Talker>();

      // Fetch followers count based on the same visibility rules as the followers list.
      // This keeps the numeric count aligned with what the user actually sees.
      try {
        final followers = await followService.getFollowers(userId);
        followersCount = followers.length;
      } catch (e) {
        logger.warning('Failed to fetch followers count: $e');
      }

      // Fetch following count based on the same visibility rules as the following list.
      try {
        final following = await followService.getFollowing(userId);
        followingCount = following.length;
      } catch (e) {
        logger.warning('Failed to fetch following count: $e');
      }

      // Fetch isFollowing status (only if not viewing own profile)
      if (currentUserId != null && currentUserId != userId) {
        try {
          isFollowing = await followService.isFollowing(userId);
          logger.debug(
            '[UserRepositoryImpl] isFollowing check for $userId: $isFollowing',
          );
        } catch (e) {
          logger.warning('Failed to fetch isFollowing status: $e');
        }
      }

      return Right(
        User(
          id: user.id,
          username: user.username,
          displayName: user.displayName,
          avatarUrl: user.avatarUrl,
          bio: user.bio,
          followerCount: followersCount,
          followingCount: followingCount,
          isFollowing: isFollowing,
          isCurrentUser: user.isCurrentUser,
          savedStories: user.savedStories,
          isVerified: user.isVerified,
          acceptsDirectMessages: user.acceptsDirectMessages,
          isOfficialMyitihas: user.isOfficialMyitihas,
        ),
      );
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message, e.code));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<User>>> searchUsers(String query) async {
    try {
      // Search in profiles table - canonical source for profile data
      final users = await dataSource.searchUsers(query);
      return Right(users.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> followUser(String userId) async {
    try {
      await followService.followUser(userId);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unfollowUser(String userId) async {
    try {
      await followService.unfollowUser(userId);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getFollowers(
    String userId, {
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      // Fetch followers with profile data from FollowService
      final followers = await followService.getFollowers(userId);

      final followedIds = await _getFollowedIdsForCurrentUser(
        followers.map((profile) => profile['id'] as String? ?? '').toList(),
      );

      // Convert to User entities
      final users = followers.map((profile) {
        final profileId = profile['id'] as String;
        return UserModel(
          id: profileId,
          username: profile['username'] as String? ?? '',
          displayName: profile['full_name'] as String? ?? 'Unknown',
          avatarUrl: profile['avatar_url'] as String? ?? '',
          bio: '', // Bio not included in follower list query
          followerCount: 0,
          followingCount: 0,
          isFollowing: followedIds.contains(profileId),
          isCurrentUser: false,
        ).toEntity();
      }).toList();

      return Right(users);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getFollowing(
    String userId, {
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      // Fetch following with profile data from FollowService
      final following = await followService.getFollowing(userId);

      final followedIds = await _getFollowedIdsForCurrentUser(
        following.map((profile) => profile['id'] as String? ?? '').toList(),
      );

      // Convert to User entities
      final users = following.map((profile) {
        final profileId = profile['id'] as String;
        return UserModel(
          id: profileId,
          username: profile['username'] as String? ?? '',
          displayName: profile['full_name'] as String? ?? 'Unknown',
          avatarUrl: profile['avatar_url'] as String? ?? '',
          bio: '', // Bio not included in following list query
          followerCount: 0,
          followingCount: 0,
          isFollowing: followedIds.contains(profileId),
          isCurrentUser: false,
        ).toEntity();
      }).toList();

      return Right(users);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getAllUsers() async {
    try {
      List<User> users;

      // Try Brick offline-first approach first
      try {
        final models = await repository.get<brick.UserModel>(
          policy: OfflineFirstGetPolicy.alwaysHydrate,
        );

        if (models.isNotEmpty) {
          users = models
              .map(
                (brickUser) => User(
                  id: brickUser.id,
                  username: brickUser.username,
                  displayName: brickUser.displayName ?? brickUser.username,
                  avatarUrl: brickUser.avatarUrl ?? '',
                  bio: brickUser.bio ?? '',
                  followerCount: 0,
                  followingCount: 0,
                  isFollowing: false,
                  isCurrentUser: false,
                  savedStories: const [],
                  isVerified: brickUser.isVerified,
                  acceptsDirectMessages: brickUser.acceptsDirectMessages,
                  isOfficialMyitihas: brickUser.isOfficialMyitihas,
                ),
              )
              .toList();
          final followedIds = await _getFollowedIdsForCurrentUser(
            users.map((u) => u.id).toList(),
          );
          return Right(
            users
                .map((u) => u.copyWith(isFollowing: followedIds.contains(u.id)))
                .toList(),
          );
        }
      } catch (e) {
        // Brick failed, try local cache
        final logger = getIt<Talker>();
        logger.warning('Brick getAllUsers failed, trying local cache: $e');

        try {
          final localModels = await repository.get<brick.UserModel>(
            policy: OfflineFirstGetPolicy.localOnly,
          );

          if (localModels.isNotEmpty) {
            users = localModels
                .map(
                  (brickUser) => User(
                    id: brickUser.id,
                    username: brickUser.username,
                    displayName: brickUser.displayName ?? brickUser.username,
                    avatarUrl: brickUser.avatarUrl ?? '',
                    bio: brickUser.bio ?? '',
                    followerCount: 0,
                    followingCount: 0,
                    isFollowing: false,
                    isCurrentUser: false,
                    savedStories: const [],
                    isVerified: brickUser.isVerified,
                    acceptsDirectMessages: brickUser.acceptsDirectMessages,
                    isOfficialMyitihas: brickUser.isOfficialMyitihas,
                  ),
                )
                .toList();
            final followedIds = await _getFollowedIdsForCurrentUser(
              users.map((u) => u.id).toList(),
            );
            return Right(
              users
                  .map(
                    (u) => u.copyWith(isFollowing: followedIds.contains(u.id)),
                  )
                  .toList(),
            );
          }
        } catch (_) {
          // Local cache also failed
        }
      }

      // Fallback to direct Supabase call
      final userModels = await dataSource.getAllUsers();
      users = userModels.map((model) => model.toEntity()).toList();
      final followedIds = await _getFollowedIdsForCurrentUser(
        users.map((u) => u.id).toList(),
      );

      return Right(
        users
            .map((u) => u.copyWith(isFollowing: followedIds.contains(u.id)))
            .toList(),
      );
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserProfile({
    required String userId,
    String? displayName,
    String? bio,
    String? avatarUrl,
  }) async {
    try {
      // Update profiles table ONLY - canonical source for profile data
      // Do NOT update users table anymore
      await dataSource.updateUser(
        userId: userId,
        displayName: displayName,
        bio: bio,
        avatarUrl: avatarUrl,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePhoto({
    required String userId,
    required File imageFile,
  }) async {
    final logger = getIt<Talker>();
    logger.info(
      '🗂️ [Repository] Starting uploadProfilePhoto for user: $userId',
    );

    try {
      // Upload image to Supabase Storage and get public URL
      logger.info('📤 [Repository] Calling storage service...');
      final String publicUrl = await storageService.uploadProfilePhoto(
        userId: userId,
        imageFile: imageFile,
      );
      logger.info('✅ [Repository] Storage upload successful. URL: $publicUrl');

      // Update user's avatar_url in profiles table - canonical source for profile data
      logger.info('💾 [Repository] Updating profile record in database...');
      await dataSource.updateUser(userId: userId, avatarUrl: publicUrl);
      logger.info('✅ [Repository] Database updated successfully');

      return Right(publicUrl);
    } on ServerException catch (e) {
      logger.error('❌ [Repository] ServerException: ${e.message}', e);
      return Left(ServerFailure(e.message));
    } catch (e) {
      logger.error('❌ [Repository] Unexpected error', e);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Story>>> getSavedStories() async {
    try {
      final user = SupabaseService.client.auth.currentUser;

      if (user == null) {
        return Left(AuthFailure('Not authenticated', 'NOT_AUTH'));
      }

      final logger = getIt<Talker>();
      final orderedStoryIds = <String>[];
      final seenStoryIds = <String>{};

      // Canonical source: bookmarks table (supports full history; not capped at 20).
      try {
        const pageSize = 200;
        var offset = 0;
        while (true) {
          final bookmarkRows = await SupabaseService.client
              .from('bookmarks')
              .select('bookmarkable_id')
              .eq('user_id', user.id)
              .eq('bookmarkable_type', 'story')
              .order('created_at', ascending: false)
              .range(offset, offset + pageSize - 1);

          if (bookmarkRows.isEmpty) break;

          for (final row in bookmarkRows) {
            final id = row['bookmarkable_id']?.toString() ?? '';
            if (id.isEmpty) continue;
            if (seenStoryIds.add(id)) {
              orderedStoryIds.add(id);
            }
          }

          if (bookmarkRows.length < pageSize) break;
          offset += pageSize;
        }
      } catch (e) {
        logger.warning(
          'Failed loading story bookmarks; falling back to legacy saved_stories: $e',
        );
      }

      // Legacy compatibility: profiles.saved_stories
      final userModel = await dataSource.getUserById(user.id);
      for (final id in userModel.savedStories) {
        if (id.isEmpty) continue;
        if (seenStoryIds.add(id)) {
          orderedStoryIds.add(id);
        }
      }

      final stories = <Story>[];
      for (final storyId in orderedStoryIds) {
        final storyResult = await dataSource.getStoryById(storyId);
        storyResult.fold((failure) {
          logger.warning(
            'Saved story $storyId not found for user: ${failure.message}',
          );
        }, (story) => stories.add(story.copyWith(isFavorite: true)));
      }

      return Right(stories);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
