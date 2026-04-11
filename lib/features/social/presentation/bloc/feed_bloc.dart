import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:myitihas/core/cache/services/prefetch_service.dart';
import 'package:myitihas/core/logging/talker_setup.dart';
import 'package:myitihas/features/social/data/models/image_post.model.dart';
import 'package:myitihas/features/social/data/models/text_post.model.dart';
import 'package:myitihas/features/social/data/models/video_post.model.dart';
import 'package:myitihas/features/social/domain/entities/content_type.dart';
import 'package:myitihas/features/social/domain/entities/feed_item.dart';
import 'package:myitihas/features/social/domain/utils/post_caption_metadata.dart';
import 'package:myitihas/features/social/domain/entities/share.dart';
import 'package:myitihas/features/social/domain/entities/user.dart';
import 'package:myitihas/features/social/domain/repositories/post_repository.dart';
import 'package:myitihas/features/social/domain/repositories/social_repository.dart';
import 'package:myitihas/features/social/domain/repositories/user_repository.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/features/stories/domain/repositories/story_repository.dart';
import 'package:myitihas/repository/my_itihas_repository.dart';
import 'package:myitihas/services/realtime_service.dart';
import 'package:myitihas/services/user_block_service.dart';

import 'feed_event.dart';
import 'feed_state.dart';

@injectable
class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final StoryRepository storyRepository;
  final SocialRepository socialRepository;
  final UserRepository userRepository;
  final PostRepository postRepository;
  final RealtimeService realtimeService;
  final PrefetchService prefetchService;
  final UserBlockService userBlockService;
  final MyItihasRepository _repository;
  final InternetConnection _internetConnection;

  StreamSubscription<SocialCountUpdate>? _realtimeSubscription;
  StreamSubscription<InternetStatus>? _connectivitySubscription;
  StreamSubscription<List<ImagePostModel>>? _imagePostSubscription;
  StreamSubscription<List<TextPostModel>>? _textPostSubscription;
  StreamSubscription<List<VideoPostModel>>? _videoPostSubscription;

  static const int _pageSize = 10;
  int _currentOffset = 0;
  FeedType _currentFeedType = FeedType.posts;
  int _feedRequestToken = 0;

  /// In-memory cache of last loaded feed for instant display when revisiting.
  static FeedState? _cachedFeed;

  /// Normalized hashtag (no `#`, lowercase). Null = full feed.
  String? _activeHashtag;

  int _nextFeedRequestToken() => ++_feedRequestToken;

  bool _isStaleFeedRequest({
    required int requestToken,
    required FeedType expectedFeedType,
    required String source,
  }) {
    final isStale =
        requestToken != _feedRequestToken ||
        _currentFeedType != expectedFeedType;
    if (isStale) {
      talker.debug(
        '[FeedBloc] Dropped stale $source result '
        '(token=$requestToken latest=$_feedRequestToken expected=$expectedFeedType current=$_currentFeedType)',
      );
    }
    return isStale;
  }

  FeedBloc({
    required this.storyRepository,
    required this.socialRepository,
    required this.userRepository,
    required this.postRepository,
    required this.realtimeService,
    required this.prefetchService,
    required this.userBlockService,
    required MyItihasRepository repository,
    required InternetConnection internetConnection,
  }) : _repository = repository,
       _internetConnection = internetConnection,
       super(const FeedState.initial()) {
    on<LoadFeedEvent>(_onLoadFeed);
    on<LoadMoreFeedEvent>(_onLoadMore);
    on<RefreshFeedEvent>(_onRefresh);
    on<ChangeFeedTypeEvent>(_onChangeFeedType);
    on<CheckConnectivityEvent>(_onCheckConnectivity);
    on<RealtimePostReceivedEvent>(_onRealtimePostReceived);
    on<ToggleLikeEvent>(_onToggleLike);
    on<ToggleBookmarkEvent>(_onToggleBookmark);
    on<AddCommentEvent>(_onAddComment);
    on<CommentCountIncrementedEvent>(_onCommentCountIncremented);
    on<SetCommentCountEvent>(_onSetCommentCount);
    on<ShareContentEvent>(_onShareContent);
    on<RepostPostEvent>(_onRepostPost);
    on<FollowUserEvent>(_onFollowUser);
    on<UnfollowUserEvent>(_onUnfollowUser);
    on<SetHashtagFilterEvent>(_onSetHashtagFilter);
    on<ClearHashtagFilterEvent>(_onClearHashtagFilter);

    _realtimeSubscription = realtimeService.countUpdates.listen(
      _onRealtimeUpdate,
    );

    // Subscribe to connectivity changes
    _connectivitySubscription = _internetConnection.onStatusChange.listen((_) {
      add(const FeedEvent.checkConnectivity());
    });

    // Check connectivity immediately
    add(const FeedEvent.checkConnectivity());

    // Start realtime subscriptions for new posts
    _startRealtimeSubscriptions();
  }

  void _onRealtimeUpdate(SocialCountUpdate update) {
    final currentState = state;
    if (currentState is! FeedLoaded) return;

    final updatedItems = currentState.feedItems.map((item) {
      if (item.id != update.contentId) return item;

      switch (update.countType) {
        case SocialCountType.like:
          return update.delta > 0
              ? item.incrementLikeCount()
              : item.decrementLikeCount();
        case SocialCountType.comment:
          return update.delta > 0
              ? item.incrementCommentCount()
              : item.decrementCommentCount();
        case SocialCountType.share:
          return update.delta > 0 ? item.incrementShareCount() : item;
        case SocialCountType.bookmark:
          return item; // Bookmark count not tracked per-item
      }
    }).toList();

    // ignore: invalid_use_of_visible_for_testing_member
    emit(currentState.copyWith(feedItems: updatedItems));
  }

  @override
  Future<void> close() {
    _realtimeSubscription?.cancel();
    _connectivitySubscription?.cancel();
    _imagePostSubscription?.cancel();
    _textPostSubscription?.cancel();
    _videoPostSubscription?.cancel();
    return super.close();
  }

  Future<void> _onCheckConnectivity(
    CheckConnectivityEvent event,
    Emitter<FeedState> emit,
  ) async {
    final isOnline = await _internetConnection.hasInternetAccess;
    final currentState = state;
    if (currentState is FeedLoaded) {
      emit(currentState.copyWith(isOnline: isOnline));
    }
  }

  Future<void> _onRealtimePostReceived(
    RealtimePostReceivedEvent event,
    Emitter<FeedState> emit,
  ) async {
    final currentState = state;
    if (currentState is! FeedLoaded) return;

    final activeFeedType = currentState.currentFeedType;

    // Only add posts that match the current feed type
    final postMatchesFeedType = event.post.when(
      story: (_) => activeFeedType == FeedType.stories,
      imagePost: (_) => activeFeedType == FeedType.posts,
      textPost: (_) => activeFeedType == FeedType.posts,
      videoPost: (_) => activeFeedType == FeedType.videos,
    );
    if (!postMatchesFeedType) return;

    if (_activeHashtag != null &&
        _activeHashtag!.isNotEmpty &&
        !_feedItemMatchesHashtag(event.post, _activeHashtag!)) {
      return;
    }

    // Skip if post already exists (prevent duplicates from realtime updates)
    // Use composite key (type:id) to handle different post types with same ID
    final existingKeys = currentState.feedItems
        .map((item) => '${item.contentType.name}:${item.id}')
        .toSet();
    final postKey = '${event.post.contentType.name}:${event.post.id}';
    if (existingKeys.contains(postKey)) {
      return;
    }

    // Insert new post at top of feed
    final updatedItems = [event.post, ...currentState.feedItems];
    emit(currentState.copyWith(feedItems: updatedItems));
  }

  Future<void> _onLoadFeed(LoadFeedEvent event, Emitter<FeedState> emit) async {
    final expectedFeedType = _currentFeedType;
    final requestToken = _nextFeedRequestToken();
    final cached = _cachedFeed;
    final hasCache =
        cached is FeedLoaded &&
        cached.currentFeedType == expectedFeedType &&
        cached.feedItems.isNotEmpty &&
        cached.activeHashtag == _activeHashtag;

    if (_isStaleFeedRequest(
      requestToken: requestToken,
      expectedFeedType: expectedFeedType,
      source: 'loadFeed:pre-emit',
    )) {
      return;
    }

    if (hasCache) {
      emit(cached);
    } else {
      final currentState = state;
      final canRefreshInPlace = currentState is FeedLoaded &&
          currentState.currentFeedType == expectedFeedType &&
          currentState.feedItems.isNotEmpty;
      if (canRefreshInPlace) {
        emit(
          FeedState.refreshing(
            feedItems: currentState.feedItems,
            currentUser: currentState.currentUser,
            hasMore: currentState.hasMore,
            currentFeedType: expectedFeedType,
            activeHashtag: _activeHashtag,
          ),
        );
      } else {
        emit(const FeedState.loading());
      }
    }

    final currentUserResult = await userRepository.getCurrentUser();

    await currentUserResult.fold(
      (failure) async {
        if (_isStaleFeedRequest(
          requestToken: requestToken,
          expectedFeedType: expectedFeedType,
          source: 'loadFeed:user',
        )) {
          return;
        }
        if (!emit.isDone && !hasCache) {
          emit(FeedState.error(failure.message));
        }
      },
      (currentUser) async {
        final feedItems = await _loadFeedItems(
          feedType: expectedFeedType,
          limit: _pageSize,
          offset: 0,
        );

        if (_isStaleFeedRequest(
          requestToken: requestToken,
          expectedFeedType: expectedFeedType,
          source: 'loadFeed:items',
        )) {
          return;
        }

        _currentOffset = feedItems.length;

        if (!emit.isDone) {
          final newState = FeedState.loaded(
            feedItems: feedItems,
            currentUser: currentUser,
            hasMore: feedItems.length >= _pageSize,
            currentFeedType: expectedFeedType,
            activeHashtag: _activeHashtag,
          );
          emit(newState);
          _cachedFeed = newState;
        }
      },
    );
  }

  Future<void> _onSetHashtagFilter(
    SetHashtagFilterEvent event,
    Emitter<FeedState> emit,
  ) async {
    var tag = event.normalizedTag.trim();
    if (tag.startsWith('#')) {
      tag = tag.substring(1);
    }
    tag = tag.toLowerCase();
    if (tag.isEmpty) return;
    _activeHashtag = tag;
    _currentOffset = 0;
    add(const FeedEvent.loadFeed());
  }

  Future<void> _onClearHashtagFilter(
    ClearHashtagFilterEvent event,
    Emitter<FeedState> emit,
  ) async {
    if (_activeHashtag == null) return;
    _activeHashtag = null;
    _currentOffset = 0;
    add(const FeedEvent.loadFeed());
  }

  Future<void> _onLoadMore(
    LoadMoreFeedEvent event,
    Emitter<FeedState> emit,
  ) async {
    final currentState = state;
    if (currentState is! FeedLoaded ||
        !currentState.hasMore ||
        currentState.isLoadingMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    final expectedFeedType = _currentFeedType;

    final newItems = await _loadFeedItems(
      feedType: expectedFeedType,
      limit: _pageSize,
      offset: _currentOffset,
    );

    if (_currentFeedType != expectedFeedType || emit.isDone) {
      talker.debug(
        '[FeedBloc] Dropped stale loadMore result '
        '(expected=$expectedFeedType current=$_currentFeedType)',
      );
      return;
    }

    if (newItems.isEmpty) {
      if (!emit.isDone) {
        emit(currentState.copyWith(isLoadingMore: false, hasMore: false));
      }
      return;
    }

    _currentOffset += newItems.length;

    // Deduplicate items by composite key (type:id) to handle different post types with same ID
    final existingKeys = currentState.feedItems
        .map((item) => '${item.contentType.name}:${item.id}')
        .toSet();
    final uniqueNewItems = newItems
        .where(
          (item) =>
              !existingKeys.contains('${item.contentType.name}:${item.id}'),
        )
        .toList();

    if (!emit.isDone) {
      emit(
        currentState.copyWith(
          feedItems: [...currentState.feedItems, ...uniqueNewItems],
          isLoadingMore: false,
          hasMore: newItems.length >= _pageSize,
        ),
      );
    }
  }

  Future<void> _onRefresh(
    RefreshFeedEvent event,
    Emitter<FeedState> emit,
  ) async {
    final currentState = state;
    if (currentState is! FeedLoaded) {
      add(const FeedEvent.loadFeed());
      return;
    }

    final expectedFeedType = _currentFeedType;
    final requestToken = _nextFeedRequestToken();

    if (_isStaleFeedRequest(
      requestToken: requestToken,
      expectedFeedType: expectedFeedType,
      source: 'refresh:pre-emit',
    )) {
      return;
    }

    emit(
      FeedState.refreshing(
        feedItems: currentState.feedItems,
        currentUser: currentState.currentUser,
        hasMore: currentState.hasMore,
        currentFeedType: expectedFeedType,
        activeHashtag: _activeHashtag,
      ),
    );

    final feedItems = await _loadFeedItems(
      feedType: expectedFeedType,
      limit: _pageSize,
      offset: 0,
    );

    if (_isStaleFeedRequest(
      requestToken: requestToken,
      expectedFeedType: expectedFeedType,
      source: 'refresh:items',
    )) {
      return;
    }

    _currentOffset = feedItems.length;

    if (!emit.isDone) {
      final newState = FeedState.loaded(
        feedItems: feedItems,
        currentUser: currentState.currentUser,
        hasMore: feedItems.length >= _pageSize,
        currentFeedType: expectedFeedType,
        activeHashtag: _activeHashtag,
      );
      emit(newState);
      _cachedFeed = newState;
    }
  }

  Future<void> _onChangeFeedType(
    ChangeFeedTypeEvent event,
    Emitter<FeedState> emit,
  ) async {
    if (_currentFeedType == event.feedType) return;

    final expectedFeedType = event.feedType;
    if (expectedFeedType == FeedType.stories) {
      _activeHashtag = null;
    }
    _currentFeedType = expectedFeedType;
    _currentOffset = 0;
    final requestToken = _nextFeedRequestToken();

    final currentState = state;
    if (currentState is FeedLoaded) {
      emit(const FeedState.loading());

      final feedItems = await _loadFeedItems(
        feedType: expectedFeedType,
        limit: _pageSize,
        offset: 0,
      );

      if (_isStaleFeedRequest(
        requestToken: requestToken,
        expectedFeedType: expectedFeedType,
        source: 'changeFeedType:items',
      )) {
        return;
      }

      _currentOffset = feedItems.length;

      if (!emit.isDone) {
        final newState = FeedState.loaded(
          feedItems: feedItems,
          currentUser: currentState.currentUser,
          hasMore: feedItems.length >= _pageSize,
          currentFeedType: expectedFeedType,
          activeHashtag: _activeHashtag,
        );
        emit(newState);
        _cachedFeed = newState;
      }
    } else {
      add(const FeedEvent.loadFeed());
    }
  }

  Future<void> _onToggleLike(
    ToggleLikeEvent event,
    Emitter<FeedState> emit,
  ) async {
    final currentState = state;
    if (currentState is! FeedLoaded) return;

    // Check connectivity before attempting write action
    final isOnline = await _internetConnection.hasInternetAccess;
    if (!isOnline) {
      emit(
        currentState.copyWith(
          error: 'No internet connection. Try again later.',
          isOfflineError: true,
        ),
      );
      return;
    }

    final updatedItems = currentState.feedItems.map((item) {
      if (item.id == event.contentId) {
        return item.toggleLike();
      }
      return item;
    }).toList();

    if (!emit.isDone) {
      emit(currentState.copyWith(feedItems: updatedItems));
    }

    // Find the item to check current like state. The feed may change
    // between tap and event handling (e.g. realtime updates/deletes).
    final itemIndex = currentState.feedItems.indexWhere(
      (i) => i.id == event.contentId,
    );
    if (itemIndex == -1) {
      talker.warning(
        '[FeedBloc] Toggle like skipped: item not found for ${event.contentId}',
      );
      return;
    }
    final item = currentState.feedItems[itemIndex];

    if (event.contentType == ContentType.story) {
      // Use existing social repository for stories
      if (item.isLikedByCurrentUser) {
        await socialRepository.unlikeStory(event.contentId);
      } else {
        await socialRepository.likeStory(event.contentId);
      }
    } else {
      // Use post repository for image/text posts
      if (item.isLikedByCurrentUser) {
        await postRepository.unlikeContent(
          contentId: event.contentId,
          contentType: event.contentType,
        );
      } else {
        await postRepository.likeContent(
          contentId: event.contentId,
          contentType: event.contentType,
        );
      }
    }
  }

  Future<void> _onToggleBookmark(
    ToggleBookmarkEvent event,
    Emitter<FeedState> emit,
  ) async {
    final currentState = state;
    if (currentState is! FeedLoaded) return;

    final updatedItems = currentState.feedItems.map((item) {
      if (item.id == event.contentId) {
        return item.toggleBookmark();
      }
      return item;
    }).toList();

    if (!emit.isDone) {
      emit(currentState.copyWith(feedItems: updatedItems));
    }

    if (event.contentType == ContentType.story) {
      await storyRepository.toggleFavorite(event.contentId);
    } else {
      await postRepository.toggleBookmark(
        contentId: event.contentId,
        contentType: event.contentType,
      );
    }
  }

  Future<void> _onAddComment(
    AddCommentEvent event,
    Emitter<FeedState> emit,
  ) async {
    // Use polymorphic method that works for all content types
    final result = await socialRepository.addContentComment(
      contentId: event.contentId,
      contentType: event.contentType,
      text: event.text,
      parentCommentId: event.parentCommentId,
    );

    final currentState = state;
    if (currentState is FeedLoaded) {
      await result.fold((failure) async {}, (comment) async {
        final updatedItems = currentState.feedItems.map((item) {
          if (item.id == event.contentId) {
            return item.incrementCommentCount();
          }
          return item;
        }).toList();

        if (!emit.isDone) {
          emit(currentState.copyWith(feedItems: updatedItems));
        }
      });
    }
  }

  void _onCommentCountIncremented(
    CommentCountIncrementedEvent event,
    Emitter<FeedState> emit,
  ) {
    final currentState = state;
    if (currentState is! FeedLoaded) return;

    final updatedItems = currentState.feedItems.map((item) {
      if (item.id == event.contentId) {
        return item.incrementCommentCount();
      }
      return item;
    }).toList();

    emit(currentState.copyWith(feedItems: updatedItems));
  }

  void _onSetCommentCount(SetCommentCountEvent event, Emitter<FeedState> emit) {
    final currentState = state;
    if (currentState is! FeedLoaded) return;

    final updatedItems = currentState.feedItems.map((item) {
      if (item.id == event.contentId) {
        return item.setCommentCount(event.count);
      }
      return item;
    }).toList();

    emit(currentState.copyWith(feedItems: updatedItems));
  }

  Future<void> _onShareContent(
    ShareContentEvent event,
    Emitter<FeedState> emit,
  ) async {
    final shareType = event.isDirect
        ? ShareType.directMessage
        : ShareType.external;

    // Use polymorphic share method that works for all content types
    await socialRepository.shareContent(
      contentId: event.contentId,
      contentType: event.contentType,
      shareType: shareType,
      recipientId: event.recipientId,
    );

    final currentState = state;
    if (currentState is FeedLoaded) {
      final updatedItems = currentState.feedItems.map((item) {
        if (item.id == event.contentId) {
          return item.incrementShareCount();
        }
        return item;
      }).toList();

      if (!emit.isDone) {
        emit(currentState.copyWith(feedItems: updatedItems));
      }
    }
  }

  Future<void> _onRepostPost(
    RepostPostEvent event,
    Emitter<FeedState> emit,
  ) async {
    final result = await postRepository.repostPost(
      originalPostId: event.originalPostId,
      quoteCaption: event.quoteCaption,
    );

    final currentState = state;
    if (currentState is! FeedLoaded || emit.isDone) return;

    result.fold(
      (failure) {
        if (!emit.isDone) {
          emit(
            currentState.copyWith(
              error: failure.message,
              isOfflineError: failure.message.toLowerCase().contains('internet'),
            ),
          );
        }
      },
      (repostedItem) {
        final isInCurrentFeed = switch (_currentFeedType) {
          FeedType.posts =>
            repostedItem.contentType == ContentType.imagePost ||
                repostedItem.contentType == ContentType.textPost,
          FeedType.videos => repostedItem.contentType == ContentType.videoPost,
          FeedType.stories => false,
        };

        if (!isInCurrentFeed) return;
        if (_activeHashtag != null &&
            _activeHashtag!.isNotEmpty &&
            !_feedItemMatchesHashtag(repostedItem, _activeHashtag!)) {
          return;
        }
        if (!emit.isDone) {
          emit(
            currentState.copyWith(
              feedItems: [repostedItem, ...currentState.feedItems],
            ),
          );
        }
      },
    );
  }

  bool _feedItemMatchesHashtag(FeedItem item, String normalized) {
    return item.when(
      story: (_) => false,
      imagePost: (p) =>
          feedItemTagsContain(p.tags, normalized) ||
          captionHashtagMatches(p.caption, p.title, normalized),
      textPost: (p) =>
          feedItemTagsContain(p.tags, normalized) ||
          captionHashtagMatches(p.body, p.title, normalized),
      videoPost: (p) =>
          feedItemTagsContain(p.tags, normalized) ||
          captionHashtagMatches(p.caption, p.title, normalized),
    );
  }

  Future<List<FeedItem>> _loadFeedItems({
    required FeedType feedType,
    required int limit,
    required int offset,
  }) async {
    switch (feedType) {
      case FeedType.stories:
        return await _loadStories(limit: limit, offset: offset);
      case FeedType.posts:
        return await _loadPosts(limit: limit, offset: offset);
      case FeedType.videos:
        return await _loadVideoPosts(limit: limit, offset: offset);
    }
  }

  Future<List<FeedItem>> _loadStories({
    required int limit,
    required int offset,
  }) async {
    final result = await storyRepository.getStories(
      limit: limit,
      offset: offset,
    );

    return await result.fold((failure) => <FeedItem>[], (stories) async {
      final currentUserResult = await userRepository.getCurrentUser();
      final currentUserId = currentUserResult.fold(
        (f) => 'anonymous',
        (u) => u.id,
      );

      // Get blocked users list (both ways)
      final blockedUsers = await userBlockService.getBlockedUsers();
      final usersWhoBlockedMe = await userBlockService.getUsersWhoBlockedMe();
      final allBlockedUserIds = {...blockedUsers, ...usersWhoBlockedMe};

      // Fetch story-share posts mapped to Story entities
      final sharedStoriesResult = await postRepository.getSharedStories(
        limit: limit,
        offset: offset,
      );
      final sharedStories = sharedStoriesResult.fold(
        (failure) => <Story>[],
        (list) => list,
      );

      // Filter out stories from blocked users
      final filteredCoreStories = stories.where((story) {
        return story.authorId == null ||
            !allBlockedUserIds.contains(story.authorId);
      }).toList();

      final filteredSharedStories = sharedStories.where((story) {
        return story.authorId == null ||
            !allBlockedUserIds.contains(story.authorId);
      }).toList();

      final allStories = <Story>[
        ...filteredCoreStories,
        ...filteredSharedStories,
      ];

      final enrichedStories = await Future.wait(
        allStories.map((s) => _enrichStoryWithSocialData(s, currentUserId)),
      );

      enrichedStories.sort(
        (a, b) =>
            (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)),
      );

      return enrichedStories.map((s) => FeedItem.story(s)).toList();
    });
  }

  Future<List<FeedItem>> _loadPosts({
    required int limit,
    required int offset,
  }) async {
    final result = await postRepository.getPosts(
      limit: limit,
      offset: offset,
      hashtagNormalized: _activeHashtag,
    );

    return await result.fold((failure) => <FeedItem>[], (posts) async {
      // Get blocked users list (both ways)
      final blockedUsers = await userBlockService.getBlockedUsers();
      final usersWhoBlockedMe = await userBlockService.getUsersWhoBlockedMe();
      final allBlockedUserIds = {...blockedUsers, ...usersWhoBlockedMe};

      // Filter out posts from blocked users
      final filteredPosts = posts.where((post) {
        return post.authorId == null ||
            !allBlockedUserIds.contains(post.authorId);
      }).toList();

      // Enrich each post with complete user data
      final enrichedPosts = await Future.wait(
        filteredPosts.map((post) async {
          final enrichResult = await postRepository.enrichFeedItemWithUserData(
            post,
          );
          return enrichResult.fold(
            (failure) => post, // Keep original if enrichment fails
            (enrichedPost) => enrichedPost,
          );
        }),
      );

      // Enrich with social data (like/bookmark status)
      final socialEnrichedPosts = await postRepository
          .enrichFeedItemsWithSocialData(enrichedPosts);

      // Final deduplication by composite key (type:id) to ensure no duplicates
      // Using just ID would cause collisions between different post types with same ID
      final uniquePosts = <String, FeedItem>{};
      for (final post in socialEnrichedPosts) {
        final key = '${post.contentType.name}:${post.id}';
        uniquePosts[key] = post;
      }

      final mergedList = uniquePosts.values.toList();
      mergedList.sort(
        (a, b) =>
            (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)),
      );

      return mergedList;
    });
  }

  Future<List<FeedItem>> _loadVideoPosts({
    required int limit,
    required int offset,
  }) async {
    final result = await postRepository.getVideoPosts(
      limit: limit,
      offset: offset,
      hashtagNormalized: _activeHashtag,
    );

    return await result.fold((failure) => <FeedItem>[], (posts) async {
      // Get blocked users list (both ways)
      final blockedUsers = await userBlockService.getBlockedUsers();
      final usersWhoBlockedMe = await userBlockService.getUsersWhoBlockedMe();
      final allBlockedUserIds = {...blockedUsers, ...usersWhoBlockedMe};

      // Filter out video posts from blocked users
      final filteredPosts = posts.where((post) {
        return post.authorId == null ||
            !allBlockedUserIds.contains(post.authorId);
      }).toList();

      final items = filteredPosts.map((p) => FeedItem.videoPost(p)).toList();
      final enrichedItems = await Future.wait(
        items.map((item) async {
          final enrichResult = await postRepository.enrichFeedItemWithUserData(
            item,
          );
          return enrichResult.fold(
            (failure) => item,
            (enrichedItem) => enrichedItem,
          );
        }),
      );
      final socialItems = await postRepository.enrichFeedItemsWithSocialData(
        enrichedItems,
      );
      socialItems.sort(
        (a, b) =>
            (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)),
      );
      return socialItems;
    });
  }

  Future<Story> _enrichStoryWithSocialData(
    Story story,
    String currentUserId,
  ) async {
    // Fetch the actual author if authorId exists, otherwise use story defaults
    User? author;
    if (story.authorId != null && story.authorId!.isNotEmpty) {
      final authorResult = await userRepository.getUserProfile(story.authorId!);
      author = authorResult.fold((failure) => null, (user) => user);
    }

    // Batch fetch social data - use actual values, not random fallbacks
    final results = await Future.wait([
      socialRepository.isStoryLiked(story.id),
      socialRepository.getStoryLikeCount(story.id),
      socialRepository.getCommentsTree(story.id),
      socialRepository.getStoryShareCount(story.id),
    ]);

    final isLiked = (results[0] as dynamic).fold(
      (l) => false,
      (r) => r as bool,
    );
    final likeCount = (results[1] as dynamic).fold(
      (l) => story.likes,
      (r) => r as int,
    );
    final commentCount = (results[2] as dynamic).fold(
      (l) => story.commentCount,
      (r) => (r as List).length,
    );
    final shareCount = (results[3] as dynamic).fold(
      (l) => story.shareCount,
      (r) => r as int,
    );

    return story.copyWith(
      authorUser: author,
      likes: likeCount,
      commentCount: commentCount,
      shareCount: shareCount,
      isLikedByCurrentUser: isLiked,
    );
  }

  // Track known post IDs to detect truly new posts from realtime
  final Set<String> _knownImagePostIds = {};
  final Set<String> _knownTextPostIds = {};
  final Set<String> _knownVideoPostIds = {};

  void _startRealtimeSubscriptions() {
    // Subscribe to image posts
    _imagePostSubscription = _repository.subscribe<ImagePostModel>().listen((
      posts,
    ) {
      for (final post in posts) {
        if (!_knownImagePostIds.contains(post.id)) {
          _knownImagePostIds.add(post.id);
          // Only emit if we're in a loaded state (not during initial load)
          if (state is FeedLoaded && _knownImagePostIds.length > 1) {
            add(
              FeedEvent.realtimePostReceived(
                FeedItem.imagePost(post.toDomain()),
              ),
            );
          }
        }
      }
      // Update known IDs
      _knownImagePostIds.addAll(posts.map((p) => p.id));
    });

    // Subscribe to text posts
    _textPostSubscription = _repository.subscribe<TextPostModel>().listen((
      posts,
    ) {
      for (final post in posts) {
        if (!_knownTextPostIds.contains(post.id)) {
          _knownTextPostIds.add(post.id);
          // Only emit if we're in a loaded state (not during initial load)
          if (state is FeedLoaded && _knownTextPostIds.length > 1) {
            add(
              FeedEvent.realtimePostReceived(
                FeedItem.textPost(post.toDomain()),
              ),
            );
          }
        }
      }
      // Update known IDs
      _knownTextPostIds.addAll(posts.map((p) => p.id));
    });

    // Subscribe to video posts
    _videoPostSubscription = _repository.subscribe<VideoPostModel>().listen((
      posts,
    ) {
      for (final post in posts) {
        if (!_knownVideoPostIds.contains(post.id)) {
          _knownVideoPostIds.add(post.id);
          // Only emit if we're in a loaded state (not during initial load)
          if (state is FeedLoaded && _knownVideoPostIds.length > 1) {
            add(
              FeedEvent.realtimePostReceived(
                FeedItem.videoPost(post.toDomain()),
              ),
            );
          }
        }
      }
      // Update known IDs
      _knownVideoPostIds.addAll(posts.map((p) => p.id));
    });

    talker.info('[FeedBloc] Realtime subscriptions started');
  }

  Future<void> _onFollowUser(
    FollowUserEvent event,
    Emitter<FeedState> emit,
  ) async {
    await _handleFollowAction(
      event.userId,
      emit,
      isFollowing: true,
      apiCall: () => userRepository.followUser(event.userId),
    );
  }

  Future<void> _onUnfollowUser(
    UnfollowUserEvent event,
    Emitter<FeedState> emit,
  ) async {
    await _handleFollowAction(
      event.userId,
      emit,
      isFollowing: false,
      apiCall: () => userRepository.unfollowUser(event.userId),
    );
  }

  /// Helper method to handle follow/unfollow with optimistic updates and rollback
  Future<void> _handleFollowAction(
    String userId,
    Emitter<FeedState> emit, {
    required bool isFollowing,
    required Future<dynamic> Function() apiCall,
  }) async {
    final currentState = state;
    if (currentState is! FeedLoaded) return;

    // Optimistically update UI
    final updatedItems = _updateFollowStatus(
      currentState.feedItems,
      userId,
      isFollowing: isFollowing,
      followerDelta: isFollowing ? 1 : -1,
    );

    if (!emit.isDone) {
      emit(currentState.copyWith(feedItems: updatedItems));
    }

    // Make the actual API call
    final result = await apiCall();

    // If failed, revert the optimistic update
    result.fold(
      (failure) {
        if (!emit.isDone && state is FeedLoaded) {
          final revertedItems = _updateFollowStatus(
            (state as FeedLoaded).feedItems,
            userId,
            isFollowing: !isFollowing,
            followerDelta: isFollowing ? -1 : 1,
          );
          emit((state as FeedLoaded).copyWith(feedItems: revertedItems));
        }
      },
      (_) {
        // Success - keep the optimistic update
      },
    );
  }

  /// Updates follow status for all feed items by a specific user
  List<FeedItem> _updateFollowStatus(
    List<FeedItem> items,
    String userId, {
    required bool isFollowing,
    required int followerDelta,
  }) {
    return items.map((item) {
      final authorId = item.authorId;
      if (authorId == null || authorId != userId) return item;

      return item.when(
        imagePost: (post) {
          if (post.authorUser == null) return item;
          return FeedItem.imagePost(
            post.copyWith(
              authorUser: post.authorUser!.copyWith(
                isFollowing: isFollowing,
                followerCount: post.authorUser!.followerCount + followerDelta,
              ),
            ),
          );
        },
        textPost: (post) {
          if (post.authorUser == null) return item;
          return FeedItem.textPost(
            post.copyWith(
              authorUser: post.authorUser!.copyWith(
                isFollowing: isFollowing,
                followerCount: post.authorUser!.followerCount + followerDelta,
              ),
            ),
          );
        },
        videoPost: (post) {
          if (post.authorUser == null) return item;
          return FeedItem.videoPost(
            post.copyWith(
              authorUser: post.authorUser!.copyWith(
                isFollowing: isFollowing,
                followerCount: post.authorUser!.followerCount + followerDelta,
              ),
            ),
          );
        },
        story: (story) {
          if (story.authorUser == null) return item;
          return FeedItem.story(
            story.copyWith(
              authorUser: story.authorUser!.copyWith(
                isFollowing: isFollowing,
                followerCount: story.authorUser!.followerCount + followerDelta,
              ),
            ),
          );
        },
      );
    }).toList();
  }
}
