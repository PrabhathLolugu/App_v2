import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/core/cache/services/prefetch_service.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/errors/exceptions.dart';
import 'package:myitihas/core/logging/talker_setup.dart';
import 'package:myitihas/core/presentation/bloc/connectivity_bloc.dart';
import 'package:myitihas/core/presentation/bloc/connectivity_state.dart';
import 'package:myitihas/core/presentation/widgets/require_online_or_notify.dart';
import 'package:myitihas/core/presentation/widgets/app_snackbar.dart';
import 'package:myitihas/core/utils/app_error_mapper.dart';
import 'package:myitihas/features/social/domain/entities/content_type.dart';
import 'package:myitihas/features/social/domain/entities/feed_item.dart';
import 'package:myitihas/features/social/domain/entities/image_post.dart';
import 'package:myitihas/features/social/domain/entities/text_post.dart';
import 'package:myitihas/features/social/domain/entities/video_post.dart';
import 'package:myitihas/features/social/domain/repositories/post_repository.dart';
import 'package:myitihas/features/social/domain/utils/share_url_builder.dart';
import 'package:myitihas/features/social/presentation/bloc/feed_bloc.dart';
import 'package:myitihas/features/social/presentation/bloc/feed_event.dart';
import 'package:myitihas/features/social/presentation/bloc/feed_state.dart';
import 'package:myitihas/features/social/presentation/utils/share_preview_generator.dart';
import 'package:myitihas/features/social/presentation/widgets/comment_sheet.dart';
import 'package:myitihas/features/social/presentation/widgets/edit_caption_sheet.dart';
import 'package:myitihas/features/social/presentation/widgets/feed_item_card.dart';
import 'package:myitihas/features/social/presentation/widgets/post_action_sheets.dart';
import 'package:myitihas/features/social/presentation/widgets/share_preview_card.dart';
import 'package:myitihas/features/social/presentation/widgets/timeline_post_card.dart';
import 'package:myitihas/features/social/presentation/widgets/user_selector_sheet.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/services/chat_service.dart';

class SocialFeedPage extends StatelessWidget {
  const SocialFeedPage({super.key, this.isScreenSelected = true});

  final bool isScreenSelected;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<FeedBloc>()..add(const FeedEvent.loadFeed()),
      child: _SocialFeedView(isScreenSelected: isScreenSelected),
    );
  }
}

class _SocialFeedView extends StatefulWidget {
  const _SocialFeedView({this.isScreenSelected = true});

  final bool isScreenSelected;

  @override
  State<_SocialFeedView> createState() => _SocialFeedViewState();
}

class _SocialFeedViewState extends State<_SocialFeedView>
    with SingleTickerProviderStateMixin {
  final PageController _videosPageController = PageController();
  final PageController _storiesPageController = PageController();
  final ScrollController _postsTimelineScrollController = ScrollController();
  late TabController _tabController;
  FeedType _activeFeedType = FeedType.posts;
  int _currentPage = 0;
  bool _isRouteActive = true;

  static const _feedTypes = [FeedType.posts, FeedType.videos, FeedType.stories];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _feedTypes.length, vsync: this);
    _activeFeedType = _feedTypes[_tabController.index];
    _tabController.addListener(_onTabChanged);
  }

  int _readPageForFeedType(FeedType feedType) {
    switch (feedType) {
      case FeedType.videos:
        return _videosPageController.hasClients
            ? (_videosPageController.page?.round().clamp(0, 999999) ?? 0)
            : 0;
      case FeedType.stories:
        return _storiesPageController.hasClients
            ? (_storiesPageController.page?.round().clamp(0, 999999) ?? 0)
            : 0;
      case FeedType.posts:
        return 0;
    }
  }

  void _onTabChanged() {
    final newFeedType = _feedTypes[_tabController.index];
    if (newFeedType == _activeFeedType) {
      return;
    }

    context.read<FeedBloc>().add(FeedEvent.changeFeedType(newFeedType));

    // Sync _currentPage with the visible tab's page controller so isVisible is correct
    setState(() {
      _activeFeedType = newFeedType;
      _currentPage = _readPageForFeedType(newFeedType);
    });
  }

  @override
  void didUpdateWidget(covariant _SocialFeedView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isScreenSelected == widget.isScreenSelected) {
      return;
    }

    setState(() {
      _isRouteActive = widget.isScreenSelected;
      if (widget.isScreenSelected) {
        _currentPage = _readPageForFeedType(_activeFeedType);
      }
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _videosPageController.dispose();
    _storiesPageController.dispose();
    _postsTimelineScrollController.dispose();
    super.dispose();
  }

  void _scrollFeedsToTopForHashtagChange() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_postsTimelineScrollController.hasClients) {
        _postsTimelineScrollController.jumpTo(0);
      }
      if (_videosPageController.hasClients) {
        _videosPageController.jumpToPage(0);
      }
    });
  }

  Future<void> _navigateToProfile(String userId) async {
    HapticFeedback.selectionClick();
    if (mounted) {
      setState(() {
        _isRouteActive = false;
      });
    }

    await WidgetsBinding.instance.endOfFrame;

    try {
      await ProfileRoute(userId: userId).push(context);
    } finally {
      if (mounted) {
        setState(() {
          _isRouteActive = widget.isScreenSelected;
          if (widget.isScreenSelected) {
            _currentPage = _readPageForFeedType(_activeFeedType);
          }
        });
      }
    }
  }

  static List<String> _feedImageUrls(List<FeedItem> items) {
    final urls = <String>[];
    for (final item in items) {
      final url = item.when(
        story: (s) => s.imageUrl,
        imagePost: (p) => p.imageUrl,
        textPost: (p) => p.imageUrl,
        videoPost: (p) => p.thumbnailUrl,
      );
      if (url != null && url.isNotEmpty && !urls.contains(url)) {
        urls.add(url);
      }
    }
    return urls;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;
    final t = Translations.of(context);

    final gradients = theme.extension<GradientExtension>();
    final gradient =
        gradients?.screenBackgroundGradient ??
        LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  theme.colorScheme.primary.withValues(alpha: 0.06),
                  theme.colorScheme.secondary.withValues(alpha: 0.04),
                  theme.colorScheme.surface,
                ]
              : [
                  theme.colorScheme.surface,
                  theme.colorScheme.surfaceContainerHighest,
                  theme.colorScheme.surfaceContainer,
                ],
          stops: const [0.0, 0.5, 1.0],
        );

    return Container(
      decoration: BoxDecoration(gradient: gradient),
      child: Stack(
        children: [
          // Main content (behind tab bar)
          Positioned.fill(
            child: BlocListener<FeedBloc, FeedState>(
              listenWhen: (prev, curr) {
                if (curr is! FeedLoaded) return false;
                if (prev is FeedRefreshing) {
                  // Finishing a reload while a tag filter is involved (including clearing).
                  return prev.activeHashtag != null ||
                      curr.activeHashtag != null;
                }
                if (prev is FeedLoaded) {
                  return prev.activeHashtag != curr.activeHashtag;
                }
                return false;
              },
              listener: (context, state) {
                _scrollFeedsToTopForHashtagChange();
              },
              child: BlocListener<FeedBloc, FeedState>(
                listenWhen: (prev, curr) =>
                    curr is FeedLoaded && curr.feedItems.isNotEmpty,
                listener: (context, state) {
                  final loaded = state as FeedLoaded;
                  if (loaded.error != null && loaded.isOfflineError) {
                    final friendly = AppErrorMapper.getUserMessage(
                      loaded.error!,
                      fallbackMessage:
                          'You appear to be offline. Please check your connection and try again.',
                    );
                    AppSnackBar.showError(context, friendly);
                  }
                  final urls = _feedImageUrls(loaded.feedItems);
                  if (urls.isNotEmpty && context.mounted) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!context.mounted) return;
                      getIt<PrefetchService>().prefetchImages(
                        context,
                        urls,
                        maxPrefetch: 15,
                      );
                    });
                  }
                },
                child: TabBarView(
                  controller: _tabController,
                  physics: const CustomTabBarViewScrollPhysics(),
                  children: [
                  _FeedTabBody(
                    key: const ValueKey('feed_tab_posts'),
                    feedType: FeedType.posts,
                    pageController: _videosPageController,
                    buildFeed: _buildFeed,
                    buildLoadingState: _buildLoadingState,
                    buildErrorState: _buildErrorState,
                  ),
                  _FeedTabBody(
                    key: const ValueKey('feed_tab_videos'),
                    feedType: FeedType.videos,
                    pageController: _videosPageController,
                    buildFeed: _buildFeed,
                    buildLoadingState: _buildLoadingState,
                    buildErrorState: _buildErrorState,
                  ),
                  _FeedTabBody(
                    key: const ValueKey('feed_tab_stories'),
                    feedType: FeedType.stories,
                    pageController: _storiesPageController,
                    buildFeed: _buildFeed,
                    buildLoadingState: _buildLoadingState,
                    buildErrorState: _buildErrorState,
                  ),
                  ],
                ),
              ),
            ),
          ),

          // Top tab bar overlay - glass effect
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.surface.withValues(alpha: 0.85),
                    theme.colorScheme.surface.withValues(alpha: 0.5),
                    theme.colorScheme.surface.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: theme.colorScheme.surface.withValues(
                                  alpha: 0.6,
                                ),
                                border: Border.all(
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.15,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: TabBar(
                                controller: _tabController,

                                indicatorSize: TabBarIndicatorSize.tab,

                                indicatorPadding: const EdgeInsets.all(5),
                                indicator: BoxDecoration(
                                  color: colorScheme.surface,
                                  borderRadius: BorderRadius.circular(21),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorScheme.shadow.withValues(
                                        alpha: 0.12,
                                      ),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),

                                labelColor: colorScheme.onSurface,
                                unselectedLabelColor:
                                    colorScheme.onSurfaceVariant,
                                labelStyle: theme.textTheme.labelLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                unselectedLabelStyle:
                                    theme.textTheme.labelLarge,
                                dividerColor: Colors.transparent,
                                tabs: [
                                  Tab(text: t.feed.tabs.posts),
                                  Tab(text: t.feed.tabs.videos),
                                  Tab(text: t.feed.tabs.stories),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),
                          IconButton(
                            onPressed: () async {
                              HapticFeedback.selectionClick();
                              if (mounted) {
                                setState(() {
                                  _isRouteActive = false;
                                });
                              }
                              await const CreatePostRoute().push(context);
                              if (!mounted) return;
                              setState(() {
                                _isRouteActive = true;
                              });
                            },
                            icon: Icon(Icons.add, color: colorScheme.onSurface),
                            style: IconButton.styleFrom(
                              backgroundColor: colorScheme.surface.withValues(
                                alpha: 0.6,
                              ),
                              padding: const EdgeInsets.all(8),
                              minimumSize: const Size(46, 46),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    BlocBuilder<FeedBloc, FeedState>(
                      buildWhen: (prev, curr) =>
                          prev is! FeedRefreshing != curr is! FeedRefreshing,
                      builder: (context, state) {
                        if (state is FeedRefreshing) {
                          return const SizedBox(
                            height: 2,
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    ListenableBuilder(
                      listenable: _tabController,
                      builder: (context, _) {
                        return BlocBuilder<FeedBloc, FeedState>(
                          buildWhen: (prev, curr) {
                            String? tag(FeedState s) =>
                                s is FeedLoaded ? s.activeHashtag : null;
                            return tag(prev) != tag(curr);
                          },
                          builder: (context, state) {
                            final tag = state is FeedLoaded
                                ? state.activeHashtag
                                : null;
                            final idx = _tabController.index;
                            final show =
                                tag != null &&
                                tag.isNotEmpty &&
                                (idx == 0 || idx == 1);
                            if (!show) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(
                                4,
                                0,
                                12,
                                4,
                              ),
                              child: Material(
                                color: colorScheme.surfaceContainerHighest
                                    .withValues(alpha: 0.95),
                                borderRadius: BorderRadius.circular(12),
                                child: Row(
                                  children: [
                                    IconButton(
                                      tooltip: t.feed.clearHashtagFilter,
                                      icon: const Icon(Icons.close),
                                      onPressed: () => context
                                          .read<FeedBloc>()
                                          .add(
                                            const FeedEvent
                                                .clearHashtagFilter(),
                                          ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '#$tag',
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(ColorScheme colorScheme, FeedType feedType) {
    final width = MediaQuery.of(context).size.width;
    final t = Translations.of(context);
    final loadingText = switch (feedType) {
      FeedType.posts => t.feed.loadingPosts,
      FeedType.videos => t.feed.loadingVideos,
      FeedType.stories => t.feed.loadingStories,
    };
    return Center(
      child: Container(
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Theme.of(context).primaryColor.withAlpha(5),
              Theme.of(context).brightness == Brightness.dark
                  ? Color(0xFF1E293B)
                  : Color(0xFFF1F5F9),
            ],
            transform: GradientRotation(3.14 / 1.5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: colorScheme.onSurface),
            const SizedBox(height: 16),
            Text(
              loadingText,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    String message,
    ColorScheme colorScheme,
  ) {
    final t = Translations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              t.feed.errorTitle,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<FeedBloc>().add(const FeedEvent.loadFeed());
              },
              icon: const Icon(Icons.refresh),
              label: Text(t.feed.tryAgain),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeed(
    BuildContext context, {
    required List<FeedItem> feedItems,
    required bool hasMore,
    required FeedType feedType,
    required String currentUserId,
    bool isLoadingMore = false,
    required PageController pageController,
    String? activeHashtag,
  }) {
    if (feedItems.isEmpty) {
      return _buildEmptyState(context, feedType);
    }

    // Use timeline-style ListView for Posts tab
    if (feedType == FeedType.posts) {
      return _buildTimelineFeed(
        context,
        feedItems,
        hasMore,
        isLoadingMore,
        currentUserId,
        activeHashtag,
      );
    }

    // Use PageView for Stories and Videos tabs (each tab has its own controller)
    return _buildPageViewFeed(
      context,
      feedItems,
      hasMore,
      isLoadingMore,
      currentUserId,
      pageController,
      feedType,
      widget.isScreenSelected,
    );
  }

  Widget _buildPageViewFeed(
    BuildContext context,
    List<FeedItem> feedItems,
    bool hasMore,
    bool isLoadingMore,
    String currentUserId,
    PageController pageController,
    FeedType feedType,
    bool isScreenSelected,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: () async {
        final bloc = context.read<FeedBloc>();
        final t = Translations.of(context);
        if (context.read<ConnectivityBloc>().state is! ConnectivityOnline) {
          requireOnlineOrNotify(
            context,
            () => bloc.add(const FeedEvent.refreshFeed()),
            message: t.chat.connectToInternet,
          );
          return;
        }
        bloc.add(const FeedEvent.refreshFeed());
        talker.info('Manual sync triggered for feed');
        await bloc.stream.firstWhere((state) => state is! FeedRefreshing);
      },
      child: PageView.builder(
        controller: pageController,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemCount: feedItems.length + (isLoadingMore ? 1 : 0),
        onPageChanged: (index) {
          setState(() => _currentPage = index);
          // Only haptic when this tab is actually active & visible.
          if (widget.isScreenSelected &&
              _isRouteActive &&
              _activeFeedType == feedType) {
            HapticFeedback.selectionClick();
          }

          if (index >= feedItems.length - 2 && hasMore && !isLoadingMore) {
            context.read<FeedBloc>().add(const FeedEvent.loadMore());
          }
        },
        itemBuilder: (context, index) {
          if (index >= feedItems.length) {
            return _buildLoadingState(colorScheme, _activeFeedType);
          }

          final feedItem = feedItems[index];
          final safePage = feedItems.isEmpty
              ? 0
              : _currentPage.clamp(0, feedItems.length - 1);
          final isThisTabActive = _activeFeedType == feedType;
          final isVisible =
              isScreenSelected &&
              _isRouteActive &&
              isThisTabActive &&
              index == safePage;

          return FeedItemCard(
            feedItem: feedItem,
            isVisible: isVisible,
            onLike: (contentId, contentType) {
              context.read<FeedBloc>().add(
                FeedEvent.toggleLike(
                  contentId: contentId,
                  contentType: contentType,
                ),
              );
            },
            onComment: (contentId, contentType) {
              feedItem.when(
                story: (story) => _showCommentSheet(
                  context,
                  story.id,
                  story.commentCount,
                  ContentType.story,
                ),
                imagePost: (post) => _showCommentSheet(
                  context,
                  post.id,
                  post.commentCount,
                  ContentType.imagePost,
                ),
                textPost: (post) => _showCommentSheet(
                  context,
                  post.id,
                  post.commentCount,
                  ContentType.textPost,
                ),
                videoPost: (post) => _showCommentSheet(
                  context,
                  post.id,
                  post.commentCount,
                  ContentType.videoPost,
                ),
              );
            },
            onShare: (contentId, contentType) {
              feedItem.whenOrNull(
                story: (story) => _showEnhancedShareDialog(context, story),
                imagePost: (post) => _showImagePostShareDialog(context, post),
                textPost: (post) => _showTextPostShareDialog(context, post),
                videoPost: (post) => _showVideoPostShareDialog(context, post),
              );
            },
            onBookmark: (contentId, contentType) {
              context.read<FeedBloc>().add(
                FeedEvent.toggleBookmark(
                  contentId: contentId,
                  contentType: contentType,
                ),
              );
              _announceBookmark(context, feedItem);
            },
            onProfileTap: () {
              final authorUser = feedItem.authorUser;
              if (authorUser != null) {
                _navigateToProfile(authorUser.id);
              }
            },
            onFollowTap: () {
              final authorUser = feedItem.authorUser;
              if (authorUser != null && !authorUser.isCurrentUser) {
                if (authorUser.isFollowing) {
                  context.read<FeedBloc>().add(
                    FeedEvent.unfollowUser(authorUser.id),
                  );
                } else {
                  context.read<FeedBloc>().add(
                    FeedEvent.followUser(authorUser.id),
                  );
                }
              }
            },
            onMoreTap: feedItem.contentType == ContentType.story
                ? null
                : () => _showPostOptionsSheet(
                      this.context,
                      feedItem,
                      currentUserId,
                    ),
            onHashtagTap: (tag) =>
                context.read<FeedBloc>().add(FeedEvent.setHashtagFilter(tag)),
            onMentionTap: _navigateToProfile,
            onContinueReading: () {
              feedItem.whenOrNull(
                story: (story) => StoryDetailRoute(id: story.id).push(context),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTimelineFeed(
    BuildContext context,
    List<FeedItem> feedItems,
    bool hasMore,
    bool isLoadingMore,
    String currentUserId,
    String? activeHashtag,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final hashtagExtra =
        activeHashtag != null && activeHashtag.isNotEmpty ? 52.0 : 0.0;

    return BlocBuilder<FeedBloc, FeedState>(
      buildWhen: (prev, curr) {
        bool hashtagOverlay(FeedState s) =>
            s is FeedRefreshing &&
            (s.activeHashtag != null && s.activeHashtag!.isNotEmpty);
        return hashtagOverlay(prev) != hashtagOverlay(curr);
      },
      builder: (context, blocState) {
        final showHashtagLoadingOverlay = blocState is FeedRefreshing &&
            blocState.activeHashtag != null &&
            blocState.activeHashtag!.isNotEmpty;

        Widget scrollable = NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification) {
              final metrics = notification.metrics;
              // Avoid firing load-more when the list is shorter than the viewport
              // (would treat "top" as "near bottom" and load extra pages).
              if (metrics.maxScrollExtent <= 0) return false;
              // Trigger load more when within 200px of bottom
              if (metrics.pixels >= metrics.maxScrollExtent - 200 &&
                  hasMore &&
                  !isLoadingMore) {
                context.read<FeedBloc>().add(const FeedEvent.loadMore());
              }
            }
            return false;
          },
          child: RefreshIndicator(
            onRefresh: () async {
              final bloc = context.read<FeedBloc>();
              final t = Translations.of(context);
              if (context.read<ConnectivityBloc>().state is! ConnectivityOnline) {
                requireOnlineOrNotify(
                  context,
                  () => bloc.add(const FeedEvent.refreshFeed()),
                  message: t.chat.connectToInternet,
                );
                return;
              }
              bloc.add(const FeedEvent.refreshFeed());
              talker.info('Manual sync triggered for posts feed');
              await bloc.stream.firstWhere((state) => state is! FeedRefreshing);
            },
            child: ListView.builder(
              controller: _postsTimelineScrollController,
              primary: false,
              padding: EdgeInsets.only(
                top:
                    MediaQuery.of(context).padding.top + 65 + hashtagExtra,
                bottom:
                    kBottomNavigationBarHeight +
                    MediaQuery.of(context).padding.bottom +
                    16,
              ),
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: feedItems.length + (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
            // Loading indicator at bottom
            if (index >= feedItems.length) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.onSurface,
                  ),
                ),
              );
            }

            // Note: Load more is handled via NotificationListener, not here
            // to avoid multiple triggers during rebuilds

            final feedItem = feedItems[index];

            return TimelinePostCard(
              key: ValueKey(feedItem.id),
              feedItem: feedItem,
              onLike: () {
                final contentType = feedItem.when(
                  imagePost: (_) => ContentType.imagePost,
                  textPost: (_) => ContentType.textPost,
                  story: (_) => ContentType.story,
                  videoPost: (_) => ContentType.videoPost,
                );
                context.read<FeedBloc>().add(
                  FeedEvent.toggleLike(
                    contentId: feedItem.id,
                    contentType: contentType,
                  ),
                );
              },
              onComment: () {
                feedItem.when(
                  imagePost: (post) => _showCommentSheet(
                    context,
                    post.id,
                    post.commentCount,
                    ContentType.imagePost,
                  ),
                  textPost: (post) => _showCommentSheet(
                    context,
                    post.id,
                    post.commentCount,
                    ContentType.textPost,
                  ),
                  story: (story) => _showCommentSheet(
                    context,
                    story.id,
                    story.commentCount,
                    ContentType.story,
                  ),
                  videoPost: (post) => _showCommentSheet(
                    context,
                    post.id,
                    post.commentCount,
                    ContentType.videoPost,
                  ),
                );
              },
              onShare: () {
                feedItem.whenOrNull(
                  imagePost: (post) => _showImagePostShareDialog(context, post),
                  textPost: (post) => _showTextPostShareDialog(context, post),
                );
              },
              onBookmark: () {
                final contentType = feedItem.when(
                  imagePost: (_) => ContentType.imagePost,
                  textPost: (_) => ContentType.textPost,
                  story: (_) => ContentType.story,
                  videoPost: (_) => ContentType.videoPost,
                );
                context.read<FeedBloc>().add(
                  FeedEvent.toggleBookmark(
                    contentId: feedItem.id,
                    contentType: contentType,
                  ),
                );
                _announceBookmark(context, feedItem);
              },
              onProfileTap: () {
                final authorUser = feedItem.authorUser;
                if (authorUser != null) {
                  _navigateToProfile(authorUser.id);
                }
              },
              onFollowTap: () {
                final authorUser = feedItem.authorUser;
                if (authorUser != null && !authorUser.isCurrentUser) {
                  if (authorUser.isFollowing) {
                    context.read<FeedBloc>().add(
                      FeedEvent.unfollowUser(authorUser.id),
                    );
                  } else {
                    context.read<FeedBloc>().add(
                      FeedEvent.followUser(authorUser.id),
                    );
                  }
                }
              },
              onMoreTap: feedItem.contentType == ContentType.story
                  ? null
                  : () => _showPostOptionsSheet(
                      this.context,
                      feedItem,
                      currentUserId,
                    ),
              onHashtagTap: (tag) => context.read<FeedBloc>().add(
                FeedEvent.setHashtagFilter(tag),
              ),
              onMentionTap: _navigateToProfile,
            );
              },
            ),
          ),
        );

        return Stack(
          clipBehavior: Clip.none,
          children: [
            scrollable,
            if (showHashtagLoadingOverlay)
              Positioned.fill(
                child: AbsorbPointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.scrim.withValues(
                        alpha: 0.35,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '#${blocState.maybeWhen(
                              refreshing: (_, __, ___, ____, tag) => tag ?? '',
                              orElse: () => '',
                            )}',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, FeedType feedType) {
    final t = Translations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    IconData icon;
    String message;

    switch (feedType) {
      case FeedType.stories:
        icon = Icons.auto_stories_outlined;
        message = t.feed.noStoriesAvailable;
        break;
      case FeedType.videos:
        icon = Icons.videocam_outlined;
        message = t.feed.noVideosAvailable;
        break;
      case FeedType.posts:
        icon = Icons.article_outlined;
        message = t.feed.noImagesAvailable;
        break;
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: colorScheme.onSurfaceVariant),
          const SizedBox(height: 16),
          Text(message, style: TextStyle(color: colorScheme.onSurfaceVariant)),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () {
              requireOnlineOrNotify(
                context,
                () => context.read<FeedBloc>().add(const FeedEvent.refreshFeed()),
                message: Translations.of(context).chat.connectToInternet,
              );
            },
            icon: Icon(Icons.refresh, color: colorScheme.primary),
            label: Text(
              t.feed.refresh,
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _announceBookmark(BuildContext context, FeedItem feedItem) {
    final t = Translations.of(context);
    final message = feedItem.isFavorite
        ? t.feed.removedFromBookmarks
        : t.feed.bookmarked;
    AppSnackBar.showSuccess(
      context,
      message,
      duration: const Duration(seconds: 1),
    );
  }

  bool _canManagePost(FeedItem feedItem, String currentUserId) {
    final authorId = feedItem.authorId;
    return authorId != null && authorId == currentUserId;
  }

  void _showPostOptionsSheet(
    BuildContext context,
    FeedItem feedItem,
    String currentUserId,
  ) async {
    final isOwnPost = _canManagePost(feedItem, currentUserId);
    final action = await showPostOverflowActionsSheet(
      context: context,
      isOwnPost: isOwnPost,
      isSaved: feedItem.isFavorite,
    );

    if (!mounted || action == null) return;

    switch (action) {
      case PostOverflowAction.edit:
        await _editPostCaption(feedItem);
        break;
      case PostOverflowAction.delete:
        _confirmDeletePost(feedItem);
        break;
      case PostOverflowAction.save:
        context.read<FeedBloc>().add(
          FeedEvent.toggleBookmark(
            contentId: feedItem.id,
            contentType: feedItem.contentType,
          ),
        );
        _announceBookmark(context, feedItem);
        break;
      case PostOverflowAction.repost:
        await _handleRepost(feedItem);
        break;
      case PostOverflowAction.report:
        final selection = await showPostReportReasonSheet(context);
        if (selection == null) return;
        _submitPostReport(
          feedItem,
          reason: selection.reason,
          details: selection.details,
        );
        break;
    }
  }

  Future<void> _editPostCaption(FeedItem feedItem) async {
    final updated = await showEditCaptionSheet(
      context: context,
      feedItem: feedItem,
    );

    if (!mounted || updated == null) return;

    final bloc = context.read<FeedBloc>();
    bloc.add(const FeedEvent.refreshFeed());
  }

  Future<void> _handleRepost(FeedItem feedItem) async {
    if (feedItem.contentType == ContentType.story) return;
    final repostAction = await showRepostActionSheet(context);
    if (!mounted || repostAction == null) return;

    String? quoteCaption;
    if (repostAction == RepostAction.repostWithThoughts) {
      quoteCaption = await showRepostQuoteDialog(context);
      if (!mounted || quoteCaption == null) return;
    }

    context.read<FeedBloc>().add(
      FeedEvent.repostPost(
        originalPostId: feedItem.id,
        quoteCaption: quoteCaption,
      ),
    );
    AppSnackBar.showSuccess(context, Translations.of(context).social.repostedToFeed);
  }

  Future<void> _submitPostReport(
    FeedItem feedItem, {
    required String reason,
    String? details,
  }) async {
    final result = await getIt<PostRepository>().reportPost(
      postId: feedItem.id,
      reason: reason,
      details: details,
    );

    if (!mounted) return;
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    final t = Translations.of(context);
    result.fold(
      (failure) {
        final friendly = AppErrorMapper.getUserMessage(
          failure,
          fallbackMessage:
              'We couldn\'t send your report. Please try again in a moment.',
        );
        AppSnackBar.showError(
          context,
          t.social.failedToReportPost(error: friendly),
        );
      },
      (_) {
        AppSnackBar.showSuccess(context, t.social.reportSubmitted);
      },
    );
  }

  Future<void> _confirmDeletePost(FeedItem feedItem) async {
    final t = Translations.of(context);
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.social.deletePost),
        content: Text(t.social.deletePostConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(t.common.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(t.common.delete),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    final result = await getIt<PostRepository>().deletePost(feedItem.id);

    if (!mounted) return;
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    result.fold(
      (failure) {
        final friendly = AppErrorMapper.getUserMessage(
          failure,
          fallbackMessage: 'We couldn\'t delete this post. Please try again.',
        );
        AppSnackBar.showError(
          context,
          t.social.failedToDeletePost(error: friendly),
        );
      },
      (_) {
        context.read<FeedBloc>().add(const FeedEvent.refreshFeed());
        AppSnackBar.showSuccess(
          context,
          Translations.of(context).social.postDeleted,
        );
      },
    );
  }

  /// Returns true if the message was sent (existing DM). False if request flow was used.
  Future<bool> _shareContentToUser(
    BuildContext context,
    dynamic selectedUser,
    String content,
    String type,
    String sharedContentId,
  ) async {
    final chatService = getIt<ChatService>();
    final userId = selectedUser.id as String;
    try {
      final directConvId = await chatService.getOrCreateDirectDMIfAllowed(
        userId,
      );
      if (directConvId != null) {
        await chatService.sendMessage(
          conversationId: directConvId,
          content: content,
          type: type,
          sharedContentId: sharedContentId,
        );
        return true;
      }
      final incoming = await chatService.getIncomingMessageRequest(userId);
      if (incoming != null) {
        if (context.mounted) {
          AppSnackBar.showError(
            context,
            'You have a request from this user. Open Requests to accept.',
          );
          context.push('/chat-requests');
        }
        return false;
      }
      final sent = await chatService.getSentMessageRequest(userId);
      if (sent != null) {
        if (context.mounted) {
          AppSnackBar.showError(
            context,
            'Request sent. Waiting for them to accept.',
          );
        }
        return false;
      }
      final requestResult = await chatService.sendMessageRequest(userId);
      if (requestResult != null) {
        await chatService.sendMessage(
          conversationId: requestResult,
          content: content,
          type: type,
          sharedContentId: sharedContentId,
        );
        return true;
      }
      if (context.mounted) {
        AppSnackBar.showSuccess(
          context,
          'Request sent. Waiting for them to accept.',
        );
      }
      return false;
    } on AuthException catch (e) {
      if (context.mounted) {
        final friendly = AppErrorMapper.getUserMessage(
          e,
          fallbackMessage: 'We couldn\'t send this message. Please try again.',
        );
        AppSnackBar.showError(context, friendly);
      }
      return false;
    } catch (e) {
      if (context.mounted) {
        final friendly = AppErrorMapper.getUserMessage(
          e,
          fallbackMessage:
              'We couldn\'t share this right now. Please try again.',
        );
        AppSnackBar.showError(
          context,
          Translations.of(context).social.failedToShare(error: friendly),
        );
      }
      return false;
    }
  }

  void _showImagePostShareDialog(BuildContext context, ImagePost post) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gradients = theme.extension<GradientExtension>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                t.feed.sharePost,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (post.caption != null)
                Text(
                  post.caption!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 24),

              // Share with image
              _ShareOption(
                icon: Icons.image_outlined,
                title: t.feed.shareWithImage,
                subtitle: t.feed.shareWithImageSubtitle,
                gradients: gradients,
                colorScheme: colorScheme,
                onTap: () async {
                  Navigator.pop(sheetContext);
                  await SharePreviewGenerator.shareImagePostImage(post: post);
                  if (context.mounted) {
                    context.read<FeedBloc>().add(
                      FeedEvent.shareContent(
                        contentId: post.id,
                        contentType: ContentType.imagePost,
                        isDirect: false,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),

              // Share link
              _ShareOption(
                icon: Icons.link,
                title: t.feed.shareLink,
                subtitle: t.feed.shareImageLinkSubtitle,
                gradients: gradients,
                colorScheme: colorScheme,
                onTap: () async {
                  Navigator.pop(sheetContext);
                  await SharePreviewGenerator.shareImagePostLink(
                    post: post,
                    baseUrl: 'https://myitihas.com',
                  );
                  if (context.mounted) {
                    context.read<FeedBloc>().add(
                      FeedEvent.shareContent(
                        contentId: post.id,
                        contentType: ContentType.imagePost,
                        isDirect: false,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),

              // Copy link
              _ShareOption(
                icon: Icons.copy,
                title: t.feed.copyLink,
                subtitle: t.feed.copyLinkSubtitle,
                gradients: gradients,
                colorScheme: colorScheme,
                onTap: () async {
                  Navigator.pop(sheetContext);
                  await SharePreviewGenerator.copyImagePostLink(
                    post: post,
                    baseUrl: 'https://myitihas.com',
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(t.feed.linkCopied),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),

              // Send to user (in-app chat)
              _ShareOption(
                icon: Icons.send,
                title: t.feed.sendToUser,
                subtitle: t.feed.sendToUserSubtitle,
                gradients: gradients,
                colorScheme: colorScheme,
                onTap: () async {
                  Navigator.pop(sheetContext);
                  final selectedUser = await UserSelectorSheet.show(context);
                  if (selectedUser != null && context.mounted) {
                    final sent = await _shareContentToUser(
                      context,
                      selectedUser,
                      'Shared an image post',
                      'imagePost',
                      post.id,
                    );
                    if (sent && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            t.feed.sentTo(username: selectedUser.displayName),
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  }
                },
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }

  void _showTextPostShareDialog(BuildContext context, TextPost post) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gradients = theme.extension<GradientExtension>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                t.feed.shareThought,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '"${post.body.length > 50 ? '${post.body.substring(0, 50)}...' : post.body}"',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 24),

              // Share as quote
              _ShareOption(
                icon: Icons.format_quote,
                title: t.feed.shareQuote,
                subtitle: t.feed.shareQuoteSubtitle,
                gradients: gradients,
                colorScheme: colorScheme,
                onTap: () async {
                  Navigator.pop(sheetContext);
                  await SharePreviewGenerator.shareTextPost(post: post);
                  if (context.mounted) {
                    context.read<FeedBloc>().add(
                      FeedEvent.shareContent(
                        contentId: post.id,
                        contentType: ContentType.textPost,
                        isDirect: false,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),

              // Share link
              _ShareOption(
                icon: Icons.link,
                title: t.feed.shareLink,
                subtitle: t.feed.shareTextLinkSubtitle,
                gradients: gradients,
                colorScheme: colorScheme,
                onTap: () async {
                  Navigator.pop(sheetContext);
                  await SharePreviewGenerator.shareTextPostLink(
                    post: post,
                    baseUrl: 'https://myitihas.com',
                  );
                  if (context.mounted) {
                    context.read<FeedBloc>().add(
                      FeedEvent.shareContent(
                        contentId: post.id,
                        contentType: ContentType.textPost,
                        isDirect: false,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),

              // Copy text
              _ShareOption(
                icon: Icons.copy,
                title: t.feed.copyText,
                subtitle: t.feed.copyTextSubtitle,
                gradients: gradients,
                colorScheme: colorScheme,
                onTap: () async {
                  Navigator.pop(sheetContext);
                  await SharePreviewGenerator.copyTextPostContent(post: post);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(t.feed.textCopied),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),

              // Copy link
              _ShareOption(
                icon: Icons.link,
                title: t.feed.copyLink,
                subtitle: t.feed.copyLinkSubtitle,
                gradients: gradients,
                colorScheme: colorScheme,
                onTap: () async {
                  Navigator.pop(sheetContext);
                  await SharePreviewGenerator.copyTextPostLink(
                    post: post,
                    baseUrl: 'https://myitihas.com',
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(t.feed.linkCopied),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),

              // Send to user
              _ShareOption(
                icon: Icons.send,
                title: t.feed.sendToUser,
                subtitle: t.feed.sendToUserSubtitle,
                gradients: gradients,
                colorScheme: colorScheme,
                onTap: () async {
                  Navigator.pop(sheetContext);
                  final selectedUser = await UserSelectorSheet.show(context);
                  if (selectedUser != null && context.mounted) {
                    final sent = await _shareContentToUser(
                      context,
                      selectedUser,
                      'Shared a thought',
                      'textPost',
                      post.id,
                    );
                    if (!context.mounted) return;
                    if (sent) {
                      context.read<FeedBloc>().add(
                        FeedEvent.shareContent(
                          contentId: post.id,
                          contentType: ContentType.textPost,
                          isDirect: true,
                          recipientId: selectedUser.id,
                        ),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              t.feed.sentTo(username: selectedUser.displayName),
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  }
                },
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }

  void _showVideoPostShareDialog(BuildContext context, VideoPost post) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gradients = theme.extension<GradientExtension>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                t.feed.sharePost,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (post.caption != null && post.caption!.isNotEmpty)
                Text(
                  '"${post.caption!.length > 50 ? '${post.caption!.substring(0, 50)}...' : post.caption!}"',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 24),

              // Share link
              _ShareOption(
                icon: Icons.link,
                title: t.feed.shareLink,
                subtitle: t.feed.shareLinkSubtitle,
                gradients: gradients,
                colorScheme: colorScheme,
                onTap: () async {
                  Navigator.pop(sheetContext);
                  final link = ShareUrlBuilder.buildVideoUrl(post.id);
                  await Clipboard.setData(ClipboardData(text: link));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(t.feed.linkCopied),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    context.read<FeedBloc>().add(
                      FeedEvent.shareContent(
                        contentId: post.id,
                        contentType: ContentType.videoPost,
                        isDirect: false,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),

              // Copy link
              _ShareOption(
                icon: Icons.copy,
                title: t.feed.copyLink,
                subtitle: t.feed.copyLinkSubtitle,
                gradients: gradients,
                colorScheme: colorScheme,
                onTap: () async {
                  Navigator.pop(sheetContext);
                  final link = ShareUrlBuilder.buildVideoUrl(post.id);
                  await Clipboard.setData(ClipboardData(text: link));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(t.feed.linkCopied),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),

              // Send to user (video)
              _ShareOption(
                icon: Icons.send,
                title: t.feed.sendToUser,
                subtitle: t.feed.sendToUserSubtitle,
                gradients: gradients,
                colorScheme: colorScheme,
                onTap: () async {
                  Navigator.pop(sheetContext);
                  final selectedUser = await UserSelectorSheet.show(context);
                  if (selectedUser != null && context.mounted) {
                    final sent = await _shareContentToUser(
                      context,
                      selectedUser,
                      'Shared a video',
                      'videoPost',
                      post.id,
                    );
                    if (!context.mounted) return;
                    if (sent) {
                      context.read<FeedBloc>().add(
                        FeedEvent.shareContent(
                          contentId: post.id,
                          contentType: ContentType.videoPost,
                          isDirect: true,
                          recipientId: selectedUser.id,
                        ),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              t.feed.sentTo(username: selectedUser.displayName),
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  }
                },
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }

  void _showCommentSheet(
    BuildContext context,
    String contentId,
    int commentCount,
    ContentType contentType,
  ) {
    final connectivityBloc = context.read<ConnectivityBloc>();
    final feedBloc = context.read<FeedBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BlocProvider<ConnectivityBloc>.value(
        value: connectivityBloc,
        child: CommentSheet(
          contentId: contentId,
          contentType: contentType,
          initialCommentCount: commentCount,
          onCommentAdded: () {
            feedBloc.add(
              FeedEvent.commentCountIncremented(
                contentId: contentId,
                contentType: contentType,
              ),
            );
          },
          onCommentCountChanged: (newCount) {
            feedBloc.add(
              FeedEvent.setCommentCount(
                contentId: contentId,
                contentType: contentType,
                count: newCount,
              ),
            );
          },
        ),
      ),
    );
  }

  void _showEnhancedShareDialog(BuildContext context, Story story) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gradients = theme.extension<GradientExtension>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      scrollControlDisabledMaxHeightRatio: 0.9,
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                t.feed.shareStory,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                story.title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 24),

              _ShareOption(
                icon: Icons.image_outlined,
                title: t.feed.shareAsImage,
                subtitle: t.feed.shareAsImageSubtitle,
                gradients: gradients,
                colorScheme: colorScheme,
                onTap: () async {
                  Navigator.pop(sheetContext);
                  _showShareFormatPicker(context, story);
                },
              ),
              const SizedBox(height: 12),
              _ShareOption(
                icon: Icons.link,
                title: t.feed.shareLink,
                subtitle: t.feed.shareLinkSubtitle,
                gradients: gradients,
                colorScheme: colorScheme,
                onTap: () {
                  Navigator.pop(sheetContext);
                  SharePreviewGenerator.shareLink(
                    story: story,
                    baseUrl: 'https://myitihas.com',
                  );
                  context.read<FeedBloc>().add(
                    FeedEvent.shareContent(
                      contentId: story.id,
                      contentType: ContentType.story,
                      isDirect: false,
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _ShareOption(
                icon: Icons.text_fields,
                title: t.feed.shareAsText,
                subtitle: t.feed.shareAsTextSubtitle,
                gradients: gradients,
                colorScheme: colorScheme,
                onTap: () {
                  Navigator.pop(sheetContext);
                  SharePreviewGenerator.shareAsText(story: story);
                  context.read<FeedBloc>().add(
                    FeedEvent.shareContent(
                      contentId: story.id,
                      contentType: ContentType.story,
                      isDirect: false,
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _ShareOption(
                icon: Icons.send,
                title: t.feed.sendToUser,
                subtitle: t.feed.sendToUserSubtitle,
                gradients: gradients,
                colorScheme: colorScheme,
                onTap: () async {
                  Navigator.pop(sheetContext);
                  final selectedUser = await UserSelectorSheet.show(context);
                  if (selectedUser != null && context.mounted) {
                    final sent = await _shareContentToUser(
                      context,
                      selectedUser,
                      'Shared a story',
                      'story',
                      story.id,
                    );
                    if (!context.mounted) return;
                    if (sent) {
                      context.read<FeedBloc>().add(
                        FeedEvent.shareContent(
                          contentId: story.id,
                          contentType: ContentType.story,
                          isDirect: true,
                          recipientId: selectedUser.id,
                        ),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              t.feed.sentTo(username: selectedUser.displayName),
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  }
                },
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }

  void _showShareFormatPicker(BuildContext context, Story story) {
    final t = Translations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.feed.chooseFormat),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.web),
              title: Text(t.feed.linkPreview),
              subtitle: Text(t.feed.linkPreviewSize),
              onTap: () async {
                Navigator.pop(dialogContext);
                _generateAndShare(context, story, SharePreviewFormat.openGraph);
              },
            ),
            ListTile(
              leading: const Icon(Icons.smartphone),
              title: Text(t.feed.storyFormat),
              subtitle: Text(t.feed.storyFormatSize),
              onTap: () async {
                Navigator.pop(dialogContext);
                _generateAndShare(context, story, SharePreviewFormat.story);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateAndShare(
    BuildContext context,
    Story story,
    SharePreviewFormat format,
  ) async {
    final t = Translations.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(t.feed.generatingPreview),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      await SharePreviewGenerator.shareWithPreview(
        context: context,
        story: story,
        format: format,
      );
    } finally {
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
    if (context.mounted) {
      context.read<FeedBloc>().add(
        FeedEvent.shareContent(
          contentId: story.id,
          contentType: ContentType.story,
          isDirect: false,
        ),
      );
    }
  }
}

// A custom physics to allow TabBarView to scroll without conflicting with inner gestures
class CustomTabBarViewScrollPhysics extends ScrollPhysics {
  const CustomTabBarViewScrollPhysics({super.parent});

  @override
  CustomTabBarViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomTabBarViewScrollPhysics(parent: buildParent(ancestor));
  }
}

/// Caches the feed items for a specific tab so it doesn't blink out when FeedBloc
/// switches types behind the scenes.
class _FeedTabBody extends StatefulWidget {
  final FeedType feedType;
  final PageController pageController;
  final Widget Function(
    BuildContext context, {
    required List<FeedItem> feedItems,
    required bool hasMore,
    required FeedType feedType,
    required String currentUserId,
    bool isLoadingMore,
    required PageController pageController,
    String? activeHashtag,
  })
  buildFeed;
  final Widget Function(ColorScheme colorScheme, FeedType feedType)
  buildLoadingState;
  final Widget Function(
    BuildContext context,
    String message,
    ColorScheme colorScheme,
  )
  buildErrorState;

  const _FeedTabBody({
    super.key,
    required this.feedType,
    required this.pageController,
    required this.buildFeed,
    required this.buildLoadingState,
    required this.buildErrorState,
  });

  @override
  State<_FeedTabBody> createState() => _FeedTabBodyState();
}

class _FeedTabBodyState extends State<_FeedTabBody> {
  FeedState? _cachedState;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<FeedBloc, FeedState>(
      builder: (context, state) {
        final isTargetType = state.maybeWhen(
          refreshing: (_, __, ___, type, ____) => type == widget.feedType,
          loaded:
              (
                _,
                __,
                ___,
                type,
                ____,
                _____,
                ______,
                _______,
                ________,
              ) =>
                  type == widget.feedType,
          orElse: () => false,
        );

        if (isTargetType) {
          _cachedState = state;
        }

        FeedState? stateToRender;
        if (isTargetType) {
          stateToRender = state;
        } else {
          stateToRender = _cachedState;
        }

        if (stateToRender == null) {
          if (state is FeedError) {
            return widget.buildErrorState(context, state.message, colorScheme);
          }
          return widget.buildLoadingState(colorScheme, widget.feedType);
        }

        return stateToRender.when(
          initial: () => widget.buildLoadingState(colorScheme, widget.feedType),
          loading: () => widget.buildLoadingState(colorScheme, widget.feedType),
          refreshing: (feedItems, currentUser, hasMore, _, activeHashtag) =>
              widget.buildFeed(
                context,
                feedItems: feedItems,
                hasMore: hasMore,
                feedType: widget.feedType,
                currentUserId: currentUser.id,
                pageController: widget.pageController,
                activeHashtag: activeHashtag,
              ),
          loaded:
              (
                feedItems,
                currentUser,
                hasMore,
                _,
                isLoadingMore,
                __,
                error,
                ___,
                activeHashtag,
              ) =>
                  widget.buildFeed(
                    context,
                    feedItems: feedItems,
                    hasMore: hasMore,
                    feedType: widget.feedType,
                    currentUserId: currentUser.id,
                    isLoadingMore: isLoadingMore,
                    pageController: widget.pageController,
                    activeHashtag: activeHashtag,
                  ),
          error: (message) =>
              widget.buildErrorState(context, message, colorScheme),
        );
      },
    );
  }
}

class _ShareOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final GradientExtension? gradients;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const _ShareOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.gradients,
    required this.colorScheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: gradients?.glassBorder ?? colorScheme.outlineVariant,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: gradients?.primaryButtonGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: colorScheme.onPrimary, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
