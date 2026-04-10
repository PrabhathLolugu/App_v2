import 'dart:math';

import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/errors/failures.dart';
import 'package:myitihas/core/logging/talker_setup.dart';
import 'package:myitihas/repository/my_itihas_repository.dart';
import 'package:myitihas/services/supabase_service.dart';

import '../../domain/entities/story.dart';
import '../../domain/repositories/story_repository.dart';
import '../models/story.model.dart';

@LazySingleton(as: StoryRepository)
class StoryRepositoryImpl implements StoryRepository {
  final MyItihasRepository repository;

  StoryRepositoryImpl({required this.repository});

  List<StoryModel> _dedupeStoryModels(List<StoryModel> models) {
    final uniqueById = <String, StoryModel>{};

    DateTime _storyRankTime(StoryModel story) =>
        story.updatedAt ??
        story.publishedAt ??
        story.createdAt ??
        DateTime.fromMillisecondsSinceEpoch(0);

    for (final story in models) {
      final existing = uniqueById[story.id];
      if (existing == null) {
        uniqueById[story.id] = story;
        continue;
      }

      final existingHasImage =
          existing.imageUrl != null && existing.imageUrl!.trim().isNotEmpty;
      final storyHasImage =
          story.imageUrl != null && story.imageUrl!.trim().isNotEmpty;

      // Prefer richer records (with image), otherwise prefer the latest one.
      if (!existingHasImage && storyHasImage) {
        uniqueById[story.id] = story;
        continue;
      }

      if (existingHasImage == storyHasImage &&
          _storyRankTime(story).isAfter(_storyRankTime(existing))) {
        uniqueById[story.id] = story;
      }
    }

    return uniqueById.values.toList();
  }

  @override
  Future<Either<Failure, List<Story>>> getStories({
    String? searchQuery,
    String? sortBy,
    String? filterByType,
    String? filterByTheme,
    int? limit,
    int? offset,
  }) async {
    try {
      // Brick query: SQLite-first with background sync
      final models = await repository.get<StoryModel>(
        policy: OfflineFirstGetPolicy.alwaysHydrate,
      );

      var filteredStories = _dedupeStoryModels(models);

      if (searchQuery != null && searchQuery.isNotEmpty) {
        filteredStories = filteredStories.where((story) {
          return story.title.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ||
              story.content.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();
      }

      if (sortBy != null) {
        switch (sortBy) {
          case 'newest':
            filteredStories.sort((a, b) {
              final aDate = a.publishedAt ?? DateTime(2000);
              final bDate = b.publishedAt ?? DateTime(2000);
              return bDate.compareTo(aDate);
            });
            break;
          case 'oldest':
            filteredStories.sort((a, b) {
              final aDate = a.publishedAt ?? DateTime(2000);
              final bDate = b.publishedAt ?? DateTime(2000);
              return aDate.compareTo(bDate);
            });
            break;
          case 'popular':
            filteredStories.sort((a, b) => b.likes.compareTo(a.likes));
            break;
        }
      }

      if (offset != null && limit != null) {
        final startIndex = offset;
        final endIndex = (offset + limit).clamp(0, filteredStories.length);
        filteredStories = filteredStories.sublist(
          startIndex.clamp(0, filteredStories.length),
          endIndex,
        );
      } else if (limit != null) {
        filteredStories = filteredStories.take(limit).toList();
      }

      return Right(filteredStories.map((model) => model.toDomain()).toList());
    } on OfflineFirstException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Story>> getStoryById(String id) async {
    try {
      // For single story view, we want the full data including imageUrl.
      // Since imageUrl is not cached in SQLite (due to size), we need to
      // fetch directly from Supabase when possible.
      try {
        // Fetch directly from Supabase to get imageUrl
        final models = await repository.getFromRemote<StoryModel>(
          query: Query.where('id', id),
        );

        if (models.isEmpty) {
          return const Left(NotFoundFailure('Story not found'));
        }

        return Right(models.first.toDomain());
      } catch (e) {
        // Remote fetch failed, fall back to local cache
        final localModels = await repository.get<StoryModel>(
          policy: OfflineFirstGetPolicy.localOnly,
          query: Query.where('id', id),
        );

        if (localModels.isEmpty) {
          return const Left(NotFoundFailure('Story not found'));
        }

        // Return cached version (imageUrl will be null but content is available)
        return Right(localModels.first.toDomain());
      }
    } on OfflineFirstException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Story>>> getFavoriteStories() async {
    try {
      // Query favorites from local cache only
      final models = await repository.get<StoryModel>(
        policy: OfflineFirstGetPolicy.localOnly,
        query: Query.where('isFavorite', true),
      );
      return Right(models.map((model) => model.toDomain()).toList());
    } on OfflineFirstException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(String storyId) async {
    try {
      final user = SupabaseService.client.auth.currentUser;
      if (user == null) {
        return Left(AuthFailure('Not authenticated', 'NOT_AUTH'));
      }

      final existingBookmark = await SupabaseService.client
          .from('bookmarks')
          .select('id')
          .eq('user_id', user.id)
          .eq('bookmarkable_type', 'story')
          .eq('bookmarkable_id', storyId)
          .maybeSingle();

      final shouldBookmark = existingBookmark == null;

      if (shouldBookmark) {
        await SupabaseService.client.from('bookmarks').upsert({
          'user_id': user.id,
          'bookmarkable_type': 'story',
          'bookmarkable_id': storyId,
        }, onConflict: 'user_id,bookmarkable_type,bookmarkable_id');
      } else {
        await SupabaseService.client
            .from('bookmarks')
            .delete()
            .eq('user_id', user.id)
            .eq('bookmarkable_type', 'story')
            .eq('bookmarkable_id', storyId);
      }

      // Best-effort local cache update for immediate UI consistency.
      final models = await repository.get<StoryModel>(
        policy: OfflineFirstGetPolicy.localOnly,
        query: Query.where('id', storyId),
      );

      if (models.isNotEmpty) {
        final story = models.first;
        final updated = StoryModel(
          id: story.id,
          userId: story.userId,
          title: story.title,
          content: story.content,
          attributesJson: story.attributesJson,
          metadata: story.metadata,
          imageUrl: story.imageUrl,
          author: story.author,
          authorId: story.authorId,
          publishedAt: story.publishedAt,
          createdAt: story.createdAt,
          updatedAt: story.updatedAt,
          likes: story.likes,
          views: story.views,
          isFavorite: shouldBookmark,
          isFeatured: story.isFeatured,
          commentCount: story.commentCount,
          shareCount: story.shareCount,
        );

        await repository.sqliteProvider.upsert<StoryModel>(
          updated,
          repository: repository,
        );
      }

      return const Right(null);
    } on OfflineFirstException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Story>>> getTrendingStories({
    int limit = 10,
  }) async {
    try {
      final models = await repository.get<StoryModel>(
        policy: OfflineFirstGetPolicy.alwaysHydrate,
      );
      final trending = _dedupeStoryModels(models)
        ..sort((a, b) => b.likes.compareTo(a.likes));
      return Right(
        trending.take(limit).map((model) => model.toDomain()).toList(),
      );
    } on OfflineFirstException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Story>>> getFeaturedStories({
    int limit = 5,
  }) async {
    try {
      // Remote-first: always fetch from network for varied selection
      final result = await _fetchFeaturedStoriesFromRemote(limit);
      return await result.fold(
        (failure) async {
          // Fallback to cache when remote fails (e.g. offline)
          final cached = await _getFeaturedStoriesFromCache(limit);
          return cached.isNotEmpty ? Right(cached) : Left(failure);
        },
        (stories) async {
          if (stories.isNotEmpty) await cacheStories(stories);
          return Right(stories);
        },
      );
    } on OfflineFirstException catch (e) {
      final cached = await _getFeaturedStoriesFromCache(limit);
      if (cached.isNotEmpty) return Right(cached);
      return Left(CacheFailure(e.message));
    } catch (e, st) {
      talker.error('Failed to load featured stories', e, st);
      final cached = await _getFeaturedStoriesFromCache(limit);
      if (cached.isNotEmpty) return Right(cached);
      return getTrendingStories(limit: limit);
    }
  }

  /// Gets featured stories from local cache (offline fallback).
  Future<List<Story>> _getFeaturedStoriesFromCache(int limit) async {
    try {
      final localModels = await repository.get<StoryModel>(
        policy: OfflineFirstGetPolicy.localOnly,
        query: Query.where('isFeatured', true),
      );
      final localList = localModels.toList()..shuffle(Random.secure());
      final uniqueStories = <String, StoryModel>{};
      for (final model in localList) {
        if (model.imageUrl == null || model.imageUrl!.trim().isEmpty) {
          continue;
        }
        uniqueStories[model.id] = model;
        if (uniqueStories.length >= limit) break;
      }
      return uniqueStories.values.map((m) => m.toDomain()).toList();
    } catch (_) {
      return [];
    }
  }

  Future<Either<Failure, List<Story>>> _fetchFeaturedStoriesFromRemote(
    int limit,
  ) async {
    try {
      // 1. Fetch Featured Stories with a larger limit for variety
      final featuredResponse = await SupabaseService.client
          .from('stories')
          .select()
          .eq('is_featured', true)
          .not('image_url', 'is', null)
          .neq('title', 'Untitled Story')
          .order('created_at', ascending: false)
          .limit(100);

      var poolModels = (featuredResponse as List)
          .map((json) => _mapJsonToStoryModel(json))
          .where(
            (model) =>
                model.imageUrl != null && model.imageUrl!.trim().isNotEmpty,
          )
          .toList();
      talker.info('Fetched ${poolModels.length} featured stories from remote');

      // 2. If pool is small, blend in Trending Stories to ensure diversity
      if (poolModels.length < 20) {
        final trendingResponse = await SupabaseService.client
            .from('stories')
            .select()
            .not('image_url', 'is', null)
            .neq('title', 'Untitled Story')
            .order('likes', ascending: false)
            .limit(50);

        final trendingModels = (trendingResponse as List)
            .map((json) => _mapJsonToStoryModel(json))
            .where(
              (model) =>
                  model.imageUrl != null && model.imageUrl!.trim().isNotEmpty,
            )
            .toList();
        final featuredIds = poolModels.map((m) => m.id).toSet();
        poolModels
            .addAll(trendingModels.where((m) => !featuredIds.contains(m.id)));
      }

      // 3. If still small, add Latest Public Stories
      if (poolModels.length < 20) {
        final latestResponse = await SupabaseService.client
            .from('stories')
            .select()
            .not('image_url', 'is', null)
            .neq('title', 'Untitled Story')
            .order('created_at', ascending: false)
            .limit(50);

        final latestModels = (latestResponse as List)
            .map((json) => _mapJsonToStoryModel(json))
            .where(
              (model) =>
                  model.imageUrl != null && model.imageUrl!.trim().isNotEmpty,
            )
            .toList();
        final existingIds = poolModels.map((m) => m.id).toSet();
        poolModels
            .addAll(latestModels.where((m) => !existingIds.contains(m.id)));
      }

      if (poolModels.isEmpty) {
        talker.warning('No stories found in remote pool, falling back to trending');
        return getTrendingStories(limit: limit);
      }

      // Shuffle for true randomness and ensure uniqueness by id
      poolModels.shuffle(Random.secure());
      
      final selectedStories = poolModels
          .take(limit * 3) // Take a slightly larger subset to filter further if needed
          .map((model) => model.toDomain())
          .toList();

      // Final shuffle and take requested limit
      selectedStories.shuffle(Random.secure());
      return Right(selectedStories.take(limit).toList());
    } catch (e, st) {
      talker.error('Error fetching featured stories from remote', e, st);
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  StoryModel _mapJsonToStoryModel(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] as String,
      userId: json['user_id'] as String? ?? '',
      title: json['title'] as String,
      content: json['content'] as String? ?? '',
      attributesJson: json['attributes'] as Map<String, dynamic>? ?? {},
      metadata: json['metadata'] as Map<String, dynamic>?,
      imageUrl: json['image_url'] as String?,
      author: json['author'] as String?,
      authorId: json['author_id'] as String?,
      publishedAt: json['published_at'] != null
          ? DateTime.tryParse(json['published_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
      likes: json['likes'] as int? ?? 0,
      views: json['views'] as int? ?? 0,
      isFavorite: json['is_favourite'] as bool? ?? false,
      isFeatured: json['is_featured'] as bool? ?? false,
      commentCount: json['comment_count'] as int?,
      shareCount: json['share_count'] as int?,
    );
  }

  @override
  Future<Either<Failure, List<Story>>> getStoriesByScripture(
    String scripture,
  ) async {
    try {
      final models = await repository.get<StoryModel>(
        policy: OfflineFirstGetPolicy.alwaysHydrate,
      );
      // Scripture is now stored in metadata
      final filtered = models.where((story) {
        final storyScripture = story.metadata?['scripture'] as String? ?? '';
        return storyScripture.toLowerCase() == scripture.toLowerCase();
      }).toList();
      return Right(filtered.map((model) => model.toDomain()).toList());
    } on OfflineFirstException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Story>>> searchStories(String query) async {
    try {
      final models = await repository.get<StoryModel>(
        policy: OfflineFirstGetPolicy.alwaysHydrate,
      );
      final filtered = _dedupeStoryModels(models)
          .where(
            (story) =>
                story.title.toLowerCase().contains(query.toLowerCase()) ||
                story.content.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
      return Right(filtered.map((model) => model.toDomain()).toList());
    } on OfflineFirstException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cacheStories(List<Story> stories) async {
    try {
      // Upsert each story to cache
      for (final story in stories) {
        final model = StoryModel.fromDomain(story);
        await repository.sqliteProvider.upsert<StoryModel>(
          model,
          repository: repository,
        );
      }
      return const Right(null);
    } on OfflineFirstException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Story>>> getCachedStories() async {
    try {
      final models = await repository.get<StoryModel>(
        policy: OfflineFirstGetPolicy.localOnly,
      );
      final uniqueModels = _dedupeStoryModels(models);
      return Right(uniqueModels.map((model) => model.toDomain()).toList());
    } on OfflineFirstException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
