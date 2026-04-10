import 'dart:io';

import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart'
    show MarkdownStyleSheet;
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/core/cache/managers/image_cache_manager.dart';
import 'package:myitihas/core/cache/widgets/story_image.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/errors/exceptions.dart';
import 'package:myitihas/core/navigation/home_back_stack.dart';
import 'package:myitihas/core/utils/app_error_message.dart';
import 'package:myitihas/core/widgets/glass/glass_background.dart';
import 'package:myitihas/core/widgets/image_loading_placeholder/image_loading_placeholder.dart';
import 'package:myitihas/core/widgets/markdown/markdown.dart';
import 'package:myitihas/core/widgets/voice_input/voice_input_button.dart';
import 'package:myitihas/features/social/data/models/user.model.dart' as brick;
import 'package:myitihas/features/social/domain/entities/content_type.dart';
import 'package:myitihas/features/social/domain/entities/feed_item.dart';
import 'package:myitihas/features/social/domain/entities/text_post.dart';
import 'package:myitihas/features/social/domain/repositories/post_repository.dart';
import 'package:myitihas/features/social/domain/repositories/user_repository.dart';
import 'package:myitihas/features/social/presentation/bloc/profile_bloc.dart';
import 'package:myitihas/features/social/presentation/bloc/profile_event.dart';
import 'package:myitihas/features/social/presentation/bloc/profile_state.dart';
import 'package:myitihas/features/social/presentation/pages/profile_post_viewer_page.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/repository/my_itihas_repository.dart';
import 'package:myitihas/services/chat_service.dart';
import 'package:myitihas/services/user_block_service.dart';
import 'package:myitihas/services/user_report_service.dart';
import 'package:myitihas/utils/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:video_player/video_player.dart';

class ProfilePage extends StatelessWidget {
  final String? userId;

  const ProfilePage({super.key, this.userId});

  /// Returns true if this is viewing another user's profile (not my profile)
  bool get isOtherUserProfile => userId != null;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _resolveUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text('This account is no longer available.')),
          );
        }

        final resolvedUserId = snapshot.data!;

        // Check if user is blocked before showing profile
        if (isOtherUserProfile) {
          return FutureBuilder<bool>(
            future: _checkIfBlocked(resolvedUserId),
            builder: (context, blockSnapshot) {
              if (blockSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (blockSnapshot.data == true) {
                return _buildBlockedProfileView(context);
              }

              return BlocProvider(
                create: (context) =>
                    getIt<ProfileBloc>()
                      ..add(ProfileEvent.loadProfile(resolvedUserId)),
                child: _ProfileView(showAppBar: true),
              );
            },
          );
        }

        return BlocProvider(
          create: (context) =>
              getIt<ProfileBloc>()
                ..add(ProfileEvent.loadProfile(resolvedUserId)),
          child: _ProfileView(showAppBar: false),
        );
      },
    );
  }

  Future<bool> _checkIfBlocked(String targetUserId) async {
    try {
      final blockService = getIt<UserBlockService>();
      final isBlocked = await blockService.isUserBlocked(targetUserId);
      final blockedMe = await blockService.getUsersWhoBlockedMe();
      return isBlocked || blockedMe.contains(targetUserId);
    } catch (e) {
      return false; // If check fails, allow access
    }
  }

  Widget _buildBlockedProfileView(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDark ? DarkColors.textPrimary : LightColors.textPrimary;
    Color subTextColor = isDark
        ? DarkColors.textSecondary
        : LightColors.textSecondary;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.block,
                size: 80,
                color: isDark ? Colors.red.shade300 : Colors.red.shade700,
              ),
              SizedBox(height: 3.h),
              Text(
                'Profile Unavailable',
                style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'You cannot view this profile due to blocking restrictions.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 14.sp, color: subTextColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _resolveUserId() async {
    // If userId is provided, use it (other user's profile)
    if (userId != null) {
      return userId!;
    }

    // If userId is null, get current authenticated user (my profile)
    final userRepository = getIt<UserRepository>();
    final result = await userRepository.getCurrentUser();

    return result.fold(
      (failure) =>
          throw Exception('Failed to get current user: ${failure.message}'),
      (user) => user.id,
    );
  }
}

class _ProfileView extends StatefulWidget {
  final bool showAppBar;

  const _ProfileView({this.showAppBar = false});

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _hasLoadedInitialPosts = false;
  bool _isRefreshing = false;
  final Set<String> _usersFollowingMe = <String>{};
  BuildContext? _gridPreviewDialogContext;
  bool _isGridPreviewOpen = false;
  late AnimationController _introController;
  late Animation<Offset> _cardSlideAnimation;
  late Animation<double> _cardFadeAnimation;

  int get _tabCount => 5;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabCount, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadUsersFollowingMe();

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _cardSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(parent: _introController, curve: Curves.easeOutCubic),
        );

    _cardFadeAnimation = CurvedAnimation(
      parent: _introController,
      curve: Curves.easeOut,
    );

    _introController.forward();
  }

  @override
  void dispose() {
    _closeGridHoldPreview();
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _introController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      context.read<ProfileBloc>().add(
        ProfileEvent.changeTab(_tabController.index),
      );
      _loadPostsForCurrentTab();
      setState(() {}); // Rebuild tabs
    }
  }

  Future<void> _loadUsersFollowingMe() async {
    final userRepository = getIt<UserRepository>();
    final currentUserResult = await userRepository.getCurrentUser();
    final currentUserId = currentUserResult.fold(
      (_) => null,
      (user) => user.id,
    );
    if (currentUserId == null) return;

    final followersResult = await userRepository.getFollowers(
      currentUserId,
      limit: 200,
    );
    if (!mounted) return;
    followersResult.fold((_) => null, (followers) {
      setState(() {
        _usersFollowingMe
          ..clear()
          ..addAll(followers.map((f) => f.id));
      });
    });
  }

  void _loadPostsForCurrentTab() {
    final state = context.read<ProfileBloc>().state;
    if (state is! ProfileLoaded) return;

    String postType;
    switch (_tabController.index) {
      case 0:
        postType = 'image';
        break;
      case 1:
        postType = 'video';
        break;
      case 2:
        postType = 'text';
        break;
      case 3:
        postType = 'story_share';
        break;
      case 4:
        if (!state.user.isCurrentUser) {
          return;
        }
        postType = 'saved';
        break;
      default:
        return;
    }

    context.read<ProfileBloc>().add(
      ProfileEvent.loadUserPosts(
        userId: state.user.id,
        postType: postType,
        refresh: true,
      ),
    );
  }

  String? _postTypeForTabIndex(int tabIndex, bool isCurrentUser) {
    switch (tabIndex) {
      case 0:
        return 'image';
      case 1:
        return 'video';
      case 2:
        return 'text';
      case 3:
        return 'story_share';
      case 4:
        return isCurrentUser ? 'saved' : null;
      default:
        return null;
    }
  }

  Future<void> _openProfileViewerAndRefresh(
    BuildContext context, {
    required List<FeedItem> feedItems,
    required int initialIndex,
    String? refreshPostType,
  }) async {
    if (feedItems.isEmpty) return;

    final safeInitialIndex = initialIndex.clamp(0, feedItems.length - 1);
    final initialItem = feedItems[safeInitialIndex];

    final bool? wasDeleted;
    if (initialItem.contentType == ContentType.textPost) {
      wasDeleted = await context.push<bool>(
        PostDetailRoute(postId: initialItem.id, postType: 'text').location,
        extra: initialItem,
      );
    } else {
      wasDeleted = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => ProfilePostViewerPage(
            feedItems: feedItems,
            initialIndex: safeInitialIndex,
          ),
        ),
      );
    }
    if (!context.mounted) return;

    final bloc = context.read<ProfileBloc>();
    final state = bloc.state;
    if (state is! ProfileLoaded) return;

    final typeToRefresh =
        refreshPostType ??
        _postTypeForTabIndex(state.currentTab, state.user.isCurrentUser);
    if (typeToRefresh == null) return;

    if (wasDeleted == true) {
      bloc.add(ProfileEvent.changeTab(state.currentTab));
    }

    bloc
      ..add(ProfileEvent.loadProfile(state.user.id))
      ..add(
        ProfileEvent.loadUserPosts(
          userId: state.user.id,
          postType: typeToRefresh,
          refresh: true,
        ),
      );
  }

  Future<void> _handleRefresh() async {
    final state = context.read<ProfileBloc>().state;
    if (state is ProfileLoaded) {
      final logger = getIt<Talker>();
      logger.info('🔄 [ProfilePage] Pull to refresh - clearing caches');

      // Clear Brick cache for user data to fetch fresh bio and other profile info
      try {
        final models = await getIt<MyItihasRepository>().get<brick.UserModel>(
          policy: OfflineFirstGetPolicy.localOnly,
          query: Query.where('id', state.user.id),
        );
        for (final model in models) {
          await getIt<MyItihasRepository>().delete<brick.UserModel>(model);
        }
        logger.info('✅ [ProfilePage] Brick cache cleared for user on refresh');
      } catch (e) {
        logger.warning('⚠️ [ProfilePage] Failed to clear Brick cache: $e');
      }

      // Clear image cache for avatar before refresh
      if (state.user.avatarUrl.isNotEmpty) {
        await ImageCacheManager.instance.removeFile(state.user.avatarUrl);
        await CachedNetworkImage.evictFromCache(state.user.avatarUrl);
      }
      if (!mounted) return;
      setState(() => _isRefreshing = true);
      context.read<ProfileBloc>().add(ProfileEvent.loadProfile(state.user.id));
    }
  }

  /// Handles the 3-dot menu actions for other users' profiles
  Future<void> _handleMenuAction(
    BuildContext context,
    String action,
    String userId,
  ) async {
    switch (action) {
      case 'settings':
        // Navigate to settings
        const SettingsRoute().push(context);
        break;

      case 'block':
        // Show confirmation dialog before blocking
        _showBlockConfirmation(context, userId);
        break;

      case 'report':
        // Show report dialog
        _showReportDialog(context, userId);
        break;
    }
  }

  /// Shows a confirmation dialog before blocking a user
  void _showBlockConfirmation(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Block User'),
          content: const Text(
            'Are you sure you want to block this user? You won\'t see their content and they won\'t be able to interact with you.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _blockUser(context, userId);
              },
              child: const Text('Block', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  /// Blocks the user and navigates back
  Future<void> _blockUser(BuildContext context, String userId) async {
    final logger = getIt<Talker>();

    try {
      // Show loading indicator
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Blocking user...')));
      }

      final blockService = getIt<UserBlockService>();
      await blockService.blockUser(userId);

      logger.info('[ProfilePage] User blocked successfully');

      // Navigate back to previous screen
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User blocked successfully')),
        );
        context.pop();
      }
    } catch (e) {
      logger.error('[ProfilePage] Error blocking user', e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              toUserFriendlyErrorMessage(
                e,
                fallback: 'Failed to block user. Please try again.',
              ),
            ),
          ),
        );
      }
    }
  }

  /// Shows the report dialog with reason input
  void _showReportDialog(BuildContext context, String userId) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Report Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Please provide a reason for reporting this profile:'),
              const SizedBox(height: 16),
              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter reason...',
                  suffixIcon: VoiceInputButton(controller: reasonController),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final reason = reasonController.text.trim();
                if (reason.isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Please enter a reason')),
                  );
                  return;
                }
                Navigator.of(dialogContext).pop();
                await _reportUser(context, userId, reason);
              },
              child: const Text('Report', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  /// Reports the user
  Future<void> _reportUser(
    BuildContext context,
    String userId,
    String reason,
  ) async {
    final logger = getIt<Talker>();

    try {
      // Show loading indicator
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Reporting user...')));
      }

      final reportService = getIt<UserReportService>();
      await reportService.reportUser(userId, reason);

      logger.info('[ProfilePage] User reported successfully');

      // Navigate back to previous screen
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User reported successfully')),
        );
        context.pop();
      }
    } catch (e) {
      logger.error('[ProfilePage] Error reporting user', e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              toUserFriendlyErrorMessage(
                e,
                fallback: 'Failed to report user. Please try again.',
              ),
            ),
          ),
        );
      }
    }
  }

  Widget _buildHeroHeader(BuildContext context, ProfileLoaded state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gradients = theme.extension<GradientExtension>();
    final t = Translations.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 7.h),
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.showAppBar)
                    GestureDetector(
                      onTap: () => HomeBackStack.goBackOrHome(context),
                      child: Icon(
                        Icons.arrow_back,
                        color: colorScheme.onSurface,
                        size: 24,
                      ),
                    ),
                  SizedBox(height: 0.5.h),
                  Text(
                    t.navigation.profile,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                      letterSpacing: -0.5,
                      fontSize: 22.sp,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.person_search_rounded),
                onPressed: () {
                  const DiscoverRoute().push(context);
                },
                tooltip: 'Search Users',
              ),
              if (state.user.isCurrentUser)
                IconButton(
                  icon: const Icon(Icons.add_box_rounded),
                  onPressed: () {
                    const CreatePostRoute().push(context);
                  },
                  tooltip: 'Create Post',
                ),
              // Show 3-dot menu for other users, settings for own profile
              if (!state.user.isCurrentUser)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  tooltip: 'More options',
                  onSelected: (value) =>
                      _handleMenuAction(context, value, state.user.id),
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'settings',
                      child: Row(
                        children: [
                          Icon(Icons.settings_rounded),
                          SizedBox(width: 8),
                          Text('Settings'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'block',
                      child: Row(
                        children: [
                          Icon(Icons.block, color: Colors.red),
                          SizedBox(width: 8),
                          Text(
                            'Block User',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'report',
                      child: Row(
                        children: [
                          Icon(Icons.flag, color: Colors.red),
                          SizedBox(width: 8),
                          Text(
                            'Report Profile',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              else
                IconButton(
                  icon: const Icon(Icons.settings_rounded),
                  onPressed: () {
                    const SettingsRoute().push(context);
                  },
                  tooltip: 'Settings',
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded && state.followError != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.followError!)));
            context.read<ProfileBloc>().add(
              const ProfileEvent.clearFollowError(),
            );
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            // Load initial posts when profile is first loaded
            if (state is ProfileLoaded && !_hasLoadedInitialPosts) {
              _hasLoadedInitialPosts = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _loadPostsForCurrentTab();
              });
            }
            // After refresh, reload posts for current tab so they stay in sync
            if (state is ProfileLoaded && _isRefreshing) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                setState(() => _isRefreshing = false);
                _loadPostsForCurrentTab();
              });
            }

            return state.when(
              initial: () => const Center(child: CircularProgressIndicator()),
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded:
                  (
                    user,
                    followers,
                    following,
                    isLoadingFollowers,
                    isLoadingFollowing,
                    currentTab,
                    posts,
                    scheduledPosts,
                    isLoadingPosts,
                    hasMorePosts,
                    cachedPostsByType,
                    hasMorePostsByType,
                    followError,
                  ) {
                    final loadedState = ProfileLoaded(
                      user: user,
                      followers: followers,
                      following: following,
                      isLoadingFollowers: isLoadingFollowers,
                      isLoadingFollowing: isLoadingFollowing,
                      currentTab: currentTab,
                      posts: posts,
                      scheduledPosts: scheduledPosts,
                      isLoadingPosts: isLoadingPosts,
                      hasMorePosts: hasMorePosts,
                      cachedPostsByType: cachedPostsByType,
                      hasMorePostsByType: hasMorePostsByType,
                      followError: followError,
                    );

                    return Column(
                      children: [
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: _handleRefresh,
                            child: CustomScrollView(
                              slivers: [
                                SliverToBoxAdapter(
                                  child: _buildHeroHeader(context, loadedState),
                                ),
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 2.h,
                                      horizontal: 4.w,
                                    ),
                                    child: FadeTransition(
                                      opacity: _cardFadeAnimation,
                                      child: SlideTransition(
                                        position: _cardSlideAnimation,
                                        child: GlassOverlay(
                                          borderRadius: 20,
                                          blurSigma: 18,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 3.h,
                                              horizontal: 4.w,
                                            ),
                                            child: Column(
                                              children: [
                                                _buildProfileHeader(
                                                  context,
                                                  user,
                                                  isDark,
                                                ),
                                                SizedBox(height: 2.h),
                                                _buildProfileStats(
                                                  context,
                                                  user,
                                                  isDark,
                                                ),
                                                SizedBox(height: 2.h),
                                                if (user.bio.isNotEmpty)
                                                  _buildProfileBio(
                                                    context,
                                                    user,
                                                    isDark,
                                                  ),
                                                SizedBox(height: 2.h),
                                                _buildActionButtons(
                                                  context,
                                                  user,
                                                  isDark,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SliverPersistentHeader(
                                  pinned: true,
                                  delegate: _SliverTabBarDelegate(
                                    TabBar(
                                      controller: _tabController,
                                      isScrollable: false,
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      indicatorColor: theme.colorScheme.onSurface,
                                      indicatorWeight: 3.0,
                                      labelColor: theme.colorScheme.onSurface,
                                      unselectedLabelColor: isDark
                                          ? Colors.white.withValues(alpha: 0.6)
                                          : Colors.black.withValues(alpha: 0.6),
                                      labelStyle: GoogleFonts.inter(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      unselectedLabelStyle: GoogleFonts.inter(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      onTap: (index) => setState(() {}),
                                      tabs: [
                                        Tab(
                                          icon: const Icon(
                                            Icons.grid_on,
                                            size: 24,
                                          ),
                                          text: t.feed.tabs.images,
                                        ),
                                        Tab(
                                          icon: const Icon(
                                            Icons.videocam,
                                            size: 24,
                                          ),
                                          text: t.feed.tabs.videos,
                                        ),
                                        Tab(
                                          icon: const Icon(
                                            Icons.text_fields,
                                            size: 24,
                                          ),
                                          text: t.feed.tabs.text,
                                        ),
                                        Tab(
                                          icon: const Icon(
                                            Icons.auto_stories,
                                            size: 24,
                                          ),
                                          text: t.feed.tabs.stories,
                                        ),
                                        Tab(
                                          icon: const Icon(
                                            Icons.bookmark_outline,
                                            size: 24,
                                          ),
                                          text: t.storyGenerator.saved,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SliverPadding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                    vertical: 2.h,
                                  ),
                                  sliver: SliverMainAxisGroup(
                                    slivers: [
                                      if (loadedState.user.isCurrentUser &&
                                          loadedState.scheduledPosts.isNotEmpty)
                                        _buildScheduledPostsSliver(
                                          context,
                                          loadedState,
                                        ),
                                      _buildTabContent(context, loadedState),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
              error: (message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${t.notification.errorPrefix} $message',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Retry loading
                      },
                      child: Text(t.notification.retry),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, dynamic user, bool isDark) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (user.isCurrentUser) {
              _showChangePhotoOptions(context, user);
            } else {
              ProfileImageViewerRoute(
                imageUrl: user.avatarUrl.isNotEmpty ? user.avatarUrl : null,
                username: user.username,
              ).push(context);
            }
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient:
                      Theme.of(
                        context,
                      ).extension<GradientExtension>()?.primaryButtonGradient ??
                      const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF44009F), Color(0xFF0088FF)],
                      ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? const Color(0xFF0F172A) : Colors.white,
                      width: 2,
                    ),
                  ),
                  child: _buildImage(
                    key: ValueKey('avatar_${user.id}_${user.avatarUrl}'),
                    imageUrl: user.avatarUrl,
                    radius: 50,
                    fallbackText: user.displayName,
                  ),
                ),
              ),
              if (user.isCurrentUser)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (isDark
                          ? DarkColors.accentPrimary
                          : LightColors.accentPrimary),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 1.5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user.displayName,
              style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? DarkColors.textPrimary
                    : LightColors.textPrimary,
              ),
            ),
            // if (user.isCurrentUser) ...[
            //   SizedBox(width: 1.w),
            //   Icon(
            //     Icons.verified,
            //     color: isDark
            //         ? DarkColors.accentPrimary
            //         : LightColors.accentPrimary,
            //     size: 20.sp,
            //   ),
            // ],
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          '@${user.username}',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: isDark
                ? DarkColors.textSecondary
                : LightColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildImage({
    Key? key,
    required String imageUrl,
    required double radius,
    String? fallbackText,
  }) {
    if (imageUrl.isEmpty) {
      return _buildFallbackAvatar(context, radius, fallbackText);
    }

    // Show image from URL with caching
    final child = Container(
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          cacheManager: ImageCacheManager.instance,
          memCacheWidth: 200,
          memCacheHeight: 200,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          placeholder: (context, url) => ImageLoadingPlaceholder(
            width: radius * 2,
            height: radius * 2,
            borderRadius: BorderRadius.circular(radius),
          ),
          errorWidget: (context, url, error) =>
              _buildFallbackAvatar(context, radius, fallbackText),
        ),
      ),
    );

    if (key != null) {
      return KeyedSubtree(key: key, child: child);
    }
    return child;
  }

  Future<void> _showChangePhotoOptions(
    BuildContext context,
    dynamic user,
  ) async {
    final t = Translations.of(context);
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: Text(t.social.createPost.camera),
              onTap: () => Navigator.pop(ctx, 'camera'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(t.social.createPost.gallery),
              onTap: () => Navigator.pop(ctx, 'gallery'),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(t.social.editProfile.title),
              onTap: () {
                Navigator.pop(ctx);
                EditProfileRoute(
                  userId: user.id,
                  displayName: user.displayName,
                  bio: user.bio,
                  avatarUrl: user.avatarUrl,
                ).push(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: Text(t.common.cancel),
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );

    if (result == null) return;

    final source = result == 'camera'
        ? ImageSource.camera
        : ImageSource.gallery;

    try {
      final image = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null || !context.mounted) return;

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(content: Text(t.common.loading)),
        );
      }

      final userRepository = getIt<UserRepository>();
      final uploadResult = await userRepository.uploadProfilePhoto(
        userId: user.id,
        imageFile: File(image.path),
      );

      if (!context.mounted) return;

      await uploadResult.fold(
        (failure) async {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                t.social.editProfile.failedUploadPhoto(error: failure.message),
              ),
              backgroundColor: Colors.red,
            ),
          );
        },
        (avatarUrl) async {
          final updateResult = await userRepository.updateUserProfile(
            userId: user.id,
            avatarUrl: avatarUrl,
          );

          if (!context.mounted) return;

          updateResult.fold(
            (failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    t.social.editProfile.failedUpdateProfile(
                      error: failure.message,
                    ),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            },
            (_) {
              if (user.avatarUrl.isNotEmpty) {
                ImageCacheManager.instance.removeFile(user.avatarUrl);
                CachedNetworkImage.evictFromCache(user.avatarUrl);
              }
              ImageCacheManager.instance.removeFile(avatarUrl);
              CachedNetworkImage.evictFromCache(avatarUrl);

              context.read<ProfileBloc>().add(
                ProfileEvent.loadProfile(user.id),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(t.social.editProfile.profileAndPhotoUpdated),
                  backgroundColor: Colors.green,
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              toUserFriendlyErrorMessage(
                e,
                fallback: 'Something went wrong. Please try again.',
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildFallbackAvatar(
    BuildContext context,
    double radius,
    String? fallbackText,
  ) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Icon(Icons.person_rounded, size: radius),
      ),
    );
  }

  Widget _buildProfileStats(BuildContext context, dynamic user, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            context,
            t.community.posts,
            user.postCount,
            isDark,
            onTap: () {},
          ),
          Container(
            width: 1,
            height: 4.h,
            color: isDark
                ? Colors.white.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.1),
          ),
          _buildStatItem(
            context,
            t.profile.followers,
            user.followerCount,
            isDark,
            onTap: () => FollowersRoute(userId: user.id).push(context),
          ),
          Container(
            width: 1,
            height: 4.h,
            color: isDark
                ? Colors.white.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.1),
          ),
          _buildStatItem(
            context,
            t.profile.following,
            user.followingCount,
            isDark,
            onTap: () => FollowingRoute(userId: user.id).push(context),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    int count,
    bool isDark, {
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            _formatCount(count),
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 0.3.h),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? DarkColors.textSecondary
                  : LightColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  Widget _buildProfileBio(BuildContext context, dynamic user, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(12),
        ),
        child: SanitizedMarkdown(
          data: user.bio,
          styleSheetOverride: MarkdownStyleSheet(
            p: GoogleFonts.inter(
              fontSize: 14.sp,
              height: 1.5,
              color: isDark
                  ? DarkColors.textSecondary
                  : LightColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, dynamic user, bool isDark) {
    if (user.isCurrentUser) {
      final editButtonBackground = isDark
          ? const Color(0xFF121212)
          : Colors.white;
      final editButtonForeground = isDark
          ? Colors.white
          : Colors.black87;

      // Edit Profile button for current user
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: SizedBox(
          width: double.infinity,
          height: 5.5.h,
          child: Container(
            decoration: BoxDecoration(
              color: editButtonBackground,
              border: Border.all(
                color: isDark ? Colors.white24 : Colors.black12,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () async {
                final result = await EditProfileRoute(
                  userId: user.id,
                  displayName: user.displayName,
                  bio: user.bio,
                  avatarUrl: user.avatarUrl,
                ).push<bool>(context);

                // Reload profile if changes were saved
                if (result == true && context.mounted) {
                  final logger = getIt<Talker>();
                  logger.info(
                    '🔄 [ProfilePage] Clearing caches and reloading profile',
                  );

                  // Clear Brick cache for user data (bio, displayName, etc.)
                  try {
                    final models = await getIt<MyItihasRepository>()
                        .get<brick.UserModel>(
                          policy: OfflineFirstGetPolicy.localOnly,
                          query: Query.where('id', user.id),
                        );
                    for (final model in models) {
                      await getIt<MyItihasRepository>().delete<brick.UserModel>(
                        model,
                      );
                    }
                    logger.info('✅ [ProfilePage] Brick cache cleared for user');
                  } catch (e) {
                    logger.warning(
                      '⚠️ [ProfilePage] Failed to clear Brick cache: $e',
                    );
                  }

                  // Clear image caches for avatar
                  if (user.avatarUrl.isNotEmpty) {
                    await ImageCacheManager.instance.removeFile(user.avatarUrl);
                    await CachedNetworkImage.evictFromCache(user.avatarUrl);
                  }

                  // Force reload profile
                  if (!context.mounted) return;
                  context.read<ProfileBloc>().add(
                    ProfileEvent.loadProfile(user.id),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              icon: Icon(
                Icons.edit_rounded,
                color: editButtonForeground,
                size: 18.sp,
              ),
              label: Text(
                t.social.editProfile.title,
                style: TextStyle(
                  color: editButtonForeground,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      final shouldShowFollowBack =
          !user.isFollowing && _usersFollowingMe.contains(user.id);
      final followLabel = shouldShowFollowBack
          ? 'Follow back'
          : t.profile.follow;
      final followIcon = shouldShowFollowBack
          ? Icons.person_add_alt_1_rounded
          : Icons.person_add_alt_1_outlined;

      // Follow/Unfollow and Message buttons for other users
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: user.isFollowing
                      ? null
                      : (isDark
                            ? DarkColors.messageUserGradient
                            : LightColors.messageUserGradient),
                  color: user.isFollowing
                      ? (isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.grey.shade200)
                      : null,
                  borderRadius: BorderRadius.circular(12),
                  border: user.isFollowing
                      ? Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.3)
                              : Colors.grey.shade400,
                        )
                      : null,
                  boxShadow: user.isFollowing
                      ? null
                      : [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).primaryColor.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: ElevatedButton(
                  onPressed: user.id.isEmpty
                      ? null
                      : () {
                          context.read<ProfileBloc>().add(
                            ProfileEvent.toggleFollow(user.id),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.5.h,
                    ),
                    minimumSize: Size.fromHeight(6.h),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        user.isFollowing
                            ? Icons.person_remove_alt_1_outlined
                            : followIcon,
                        color: user.isFollowing
                            ? (isDark ? Colors.white : Colors.black87)
                            : Colors.white,
                        size: 18.sp,
                      ),
                      SizedBox(width: 1.5.w),
                      Flexible(
                        child: Text(
                          user.isFollowing ? t.profile.unfollow : followLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: user.isFollowing
                                ? (isDark ? Colors.white : Colors.black87)
                                : Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.3)
                        : Colors.grey.shade400,
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.5.h,
                    ),
                    minimumSize: Size.fromHeight(6.h),
                  ),
                  onPressed: () async {
                    try {
                      final chatService = getIt<ChatService>();
                      final directConvId = await chatService
                          .getOrCreateDirectDMIfAllowed(user.id);
                      if (directConvId != null) {
                        if (context.mounted) {
                          context.push(
                            '/chat_detail',
                            extra: {
                              'conversationId': directConvId,
                              'userId': user.id,
                              'name': user.displayName,
                              'avatarUrl': user.avatarUrl,
                              'isGroup': false,
                            },
                          );
                        }
                        return;
                      }
                      final incoming = await chatService
                          .getIncomingMessageRequest(user.id);
                      if (incoming != null) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'You have a request from this user. Open Requests to accept.',
                              ),
                            ),
                          );
                          context.push('/chat-requests');
                        }
                        return;
                      }
                      final sent = await chatService.getSentMessageRequest(
                        user.id,
                      );
                      if (sent != null) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Request sent. Waiting for them to accept.',
                              ),
                            ),
                          );
                        }
                        return;
                      }
                      final requestResult = await chatService
                          .sendMessageRequest(user.id);
                      if (requestResult != null) {
                        if (context.mounted) {
                          context.push(
                            '/chat_detail',
                            extra: {
                              'conversationId': requestResult,
                              'userId': user.id,
                              'name': user.displayName,
                              'avatarUrl': user.avatarUrl,
                              'isGroup': false,
                            },
                          );
                        }
                        return;
                      }
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Request sent. Waiting for them to accept.',
                            ),
                          ),
                        );
                      }
                    } on AuthException catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.message)));
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              toUserFriendlyErrorMessage(
                                e,
                                fallback:
                                    'Failed to open chat. Please try again.',
                              ),
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        color: isDark ? Colors.white : Colors.black87,
                        size: 18.sp,
                      ),
                      SizedBox(width: 1.5.w),
                      Flexible(
                        child: Text(
                          'Message',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
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
  }

  /// Formats a UTC [scheduledAt] as "15 Mar, 6:30 AM IST".
  String _formatScheduledAtIst(DateTime scheduledAtUtc) {
    const istOffset = Duration(hours: 5, minutes: 30);
    final ist = scheduledAtUtc.add(istOffset);
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final m = ist.month >= 1 && ist.month <= 12 ? months[ist.month - 1] : '';
    final d = ist.day.toString().padLeft(2, '0');
    final h = ((ist.hour + 11) % 12) + 1;
    final min = ist.minute.toString().padLeft(2, '0');
    final am = ist.hour < 12 ? 'AM' : 'PM';
    return '$d $m, $h:$min $am IST';
  }

  Widget _buildScheduledPostsSliver(BuildContext context, ProfileLoaded state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 2.h),
            child: Row(
              children: [
                Icon(
                  Icons.schedule_send_rounded,
                  size: 18.sp,
                  color: colorScheme.primary,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Scheduled',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 22.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.scheduledPosts.length,
              itemBuilder: (context, index) {
                final item = state.scheduledPosts[index];
                final scheduledAt = item.scheduledAt;
                final postId = item.id;
                final postType = item.when(
                  story: (_) => 'text',
                  imagePost: (_) => 'image',
                  textPost: (_) => 'text',
                  videoPost: (_) => 'video',
                );

                return Container(
                  width: 75.w,
                  margin: EdgeInsets.only(right: 4.w),
                  child: Material(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.6,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _openProfileViewerAndRefresh(
                        context,
                        feedItems: state.scheduledPosts,
                        initialIndex: index,
                        refreshPostType: postType,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 1.5.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 3.w,
                                    vertical: 0.8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Scheduled',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                PopupMenuButton<String>(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    Icons.more_vert,
                                    size: 18.sp,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  onSelected: (value) =>
                                      _handleScheduledPostAction(
                                        context,
                                        postId: postId,
                                        action: value,
                                        state: state,
                                        scheduledAt: scheduledAt,
                                      ),
                                  itemBuilder: (context) => const [
                                    PopupMenuItem(
                                      value: 'post_now',
                                      child: Text('Post now'),
                                    ),
                                    PopupMenuItem(
                                      value: 'edit_schedule',
                                      child: Text('Edit schedule'),
                                    ),
                                    PopupMenuItem(
                                      value: 'cancel',
                                      child: Text('Cancel schedule'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (scheduledAt != null)
                              Padding(
                                padding: EdgeInsets.only(top: 1.2.h),
                                child: Text(
                                  'Goes live ${_formatScheduledAtIst(scheduledAt)}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: 10.sp,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 3.h),
        ],
      ),
    );
  }

  Future<void> _handleScheduledPostAction(
    BuildContext context, {
    required String postId,
    required String action,
    required ProfileLoaded state,
    DateTime? scheduledAt,
  }) async {
    final postRepository = getIt<PostRepository>();

    switch (action) {
      case 'post_now':
        final result = await postRepository.updatePostSchedule(
          postId: postId,
          status: 'published',
        );
        result.fold((_) => _showScheduleError(context), (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Post published')));
            context.read<ProfileBloc>().add(
              ProfileEvent.loadProfile(state.user.id),
            );
          }
        });
        break;
      case 'cancel':
        final result = await postRepository.updatePostSchedule(
          postId: postId,
          status: 'cancelled',
        );
        result.fold((_) => _showScheduleError(context), (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Schedule cancelled')));
            context.read<ProfileBloc>().add(
              ProfileEvent.loadProfile(state.user.id),
            );
          }
        });
        break;
      case 'edit_schedule':
        final now = DateTime.now();
        final initial = scheduledAt ?? now.add(const Duration(minutes: 10));
        final date = await showDatePicker(
          context: context,
          initialDate: initial,
          firstDate: now,
          lastDate: now.add(const Duration(days: 30)),
        );
        if (date == null || !context.mounted) return;
        final timeOfDay = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(initial),
        );
        if (timeOfDay == null || !context.mounted) return;
        final combined = DateTime(
          date.year,
          date.month,
          date.day,
          timeOfDay.hour,
          timeOfDay.minute,
        );
        if (combined.isBefore(now.add(const Duration(minutes: 5)))) {
          if (context.mounted) _showScheduleError(context);
          return;
        }
        if (combined.isAfter(now.add(const Duration(days: 30)))) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'You can schedule posts up to 1 month in advance only.',
                ),
              ),
            );
          }
          return;
        }
        // Treat picked date/time as IST and convert to UTC (IST = UTC + 5:30).
        final istAsUtc = DateTime.utc(
          combined.year,
          combined.month,
          combined.day,
          combined.hour,
          combined.minute,
        );
        final scheduledAtUtc = istAsUtc.subtract(
          const Duration(hours: 5, minutes: 30),
        );
        final result = await postRepository.updatePostSchedule(
          postId: postId,
          status: 'scheduled',
          scheduledAtUtc: scheduledAtUtc,
        );
        result.fold((_) => _showScheduleError(context), (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Schedule updated')));
            context.read<ProfileBloc>().add(
              ProfileEvent.loadProfile(state.user.id),
            );
          }
        });
        break;
    }
  }

  void _showScheduleError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Something went wrong'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  Widget _buildTabContent(BuildContext context, ProfileLoaded state) {
    if (state.isLoadingPosts && state.posts.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      );
    }

    // For Saved tab (current user), we still show saved stories even when posts are empty
    if (state.posts.isEmpty &&
        !(state.currentTab == 4 && state.user.isCurrentUser)) {
      final isStoriesTab = state.currentTab == 3;
      final isMyProfile = state.user.isCurrentUser;

      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inbox_rounded,
                size: 64,
                color: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                isStoriesTab ? 'No stories yet' : 'No posts yet',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              if (isMyProfile) ...[
                SizedBox(height: 3.h),
                Container(
                  decoration: BoxDecoration(
                    gradient: Theme.of(
                      context,
                    ).extension<GradientExtension>()?.primaryButtonGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (isStoriesTab) {
                        const StoryGeneratorRoute().push(context);
                      } else {
                        const CreatePostRoute().push(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 1.5.h,
                      ),
                    ),
                    child: Text(
                      isStoriesTab ? 'Generate a story' : 'Create a post',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    // Build content based on current tab
    switch (state.currentTab) {
      case 0: // Images
        return _buildGridView(context, state);
      case 1: // Videos
        return _buildGridView(context, state);
      case 2: // Text posts
        return _buildTextPostsList(context, state);
      case 3: // Shares
        return _buildGridView(context, state);
      case 4: // Saved posts
        if (!state.user.isCurrentUser) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 54,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Saved posts are private',
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return SliverMainAxisGroup(
          slivers: [
            _buildSavedStoriesSliver(context),
            _buildSavedPostsList(context, state),
          ],
        );
      default:
        return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
  }

  Widget _buildSavedStoriesSliver(BuildContext context) {
    final userRepository = getIt<UserRepository>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SliverToBoxAdapter(
      child: FutureBuilder<List<Story>>(
        future: userRepository.getSavedStories().then(
          (either) => either.fold((_) => <Story>[], (list) => list),
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }
          final stories = snapshot.data!;
          if (stories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  Icon(
                    Icons.bookmark_border_rounded,
                    size: 64,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No saved stories',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the bookmark icon on any story to save it here',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.7,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 3.h),
                  Container(
                    decoration: BoxDecoration(
                      gradient: theme
                          .extension<GradientExtension>()
                          ?.primaryButtonGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        const StoryGeneratorRoute().push(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 1.5.h,
                        ),
                      ),
                      child: Text(
                        'Generate a Story',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Saved Stories',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: stories.length,
                  itemBuilder: (context, index) {
                    final story = stories[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _buildSavedStoryCard(context, story, colorScheme),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSavedStoryCard(
    BuildContext context,
    Story story,
    ColorScheme colorScheme,
  ) {
    return GestureDetector(
      onTap: () => GeneratedStoryResultRoute($extra: story).push(context),
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (story.imageUrl != null && story.imageUrl!.isNotEmpty)
                StoryImage(
                  imageUrl: story.imageUrl!,
                  fit: BoxFit.cover,
                  memCacheWidth: 200,
                  memCacheHeight: 200,
                  errorWidget: (context, error) =>
                      _savedStoryPlaceholder(colorScheme),
                )
              else
                _savedStoryPlaceholder(colorScheme),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.85),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),
              Positioned(
                left: 6,
                right: 6,
                bottom: 6,
                child: Text(
                  story.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _savedStoryPlaceholder(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.primaryContainer.withValues(alpha: 0.5),
      child: Center(
        child: Icon(
          Icons.auto_stories_rounded,
          size: 32,
          color: colorScheme.onSurface.withValues(alpha: 0.4),
        ),
      ),
    );
  }

  Widget _buildSavedPostsList(BuildContext context, ProfileLoaded state) {
    return SliverPadding(
      padding: EdgeInsets.only(
        bottom: 100.0 + MediaQuery.paddingOf(context).bottom,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final feedItem = state.posts[index];

          return feedItem.when(
            story: (_) => const SizedBox.shrink(),
            imagePost: (imagePost) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildSavedMediaTile(
                context,
                allItems: state.posts,
                itemIndex: index,
                imageUrl: imagePost.imageUrl,
                title: imagePost.caption?.isNotEmpty == true
                    ? imagePost.caption!
                    : 'Image post',
                likes: imagePost.likes,
                commentCount: imagePost.commentCount,
                shareCount: imagePost.shareCount,
                createdAt: imagePost.createdAt,
                isVideo: false,
              ),
            ),
            textPost: (textPost) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildTextPostTile(
                context,
                textPost,
                allItems: state.posts,
                itemIndex: index,
              ),
            ),
            videoPost: (videoPost) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildSavedMediaTile(
                context,
                allItems: state.posts,
                itemIndex: index,
                imageUrl: videoPost.thumbnailUrl ?? '',
                title: videoPost.caption?.isNotEmpty == true
                    ? videoPost.caption!
                    : 'Video post',
                likes: videoPost.likes,
                commentCount: videoPost.commentCount,
                shareCount: videoPost.shareCount,
                createdAt: videoPost.createdAt,
                isVideo: true,
              ),
            ),
          );
        }, childCount: state.posts.length),
      ),
    );
  }

  Widget _buildSavedMediaTile(
    BuildContext context, {
    required List<FeedItem> allItems,
    required int itemIndex,
    required String imageUrl,
    required String title,
    required int likes,
    required int commentCount,
    required int shareCount,
    required DateTime? createdAt,
    required bool isVideo,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => _openProfileViewerAndRefresh(
        context,
        feedItems: allItems,
        initialIndex: itemIndex,
        refreshPostType: 'saved',
      ),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.35,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 72,
                height: 72,
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return ImageLoadingPlaceholder(
                            width: 72,
                            height: 72,
                            borderRadius: BorderRadius.circular(10),
                          );
                        },
                        errorBuilder: (_, _, _) => _buildGridPlaceholder(
                          context,
                          isVideo
                              ? Icons.videocam_rounded
                              : Icons.image_rounded,
                        ),
                      )
                    : _buildGridPlaceholder(
                        context,
                        isVideo ? Icons.videocam_rounded : Icons.image_rounded,
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatPostDate(createdAt ?? DateTime.now()),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildGridStatsRow(
                    context,
                    likes: likes,
                    commentCount: commentCount,
                    shareCount: shareCount,
                  ),
                ],
              ),
            ),
            Icon(
              isVideo ? Icons.play_circle_outline : Icons.image_outlined,
              color: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextPostsList(BuildContext context, ProfileLoaded state) {
    return SliverPadding(
      padding: EdgeInsets.only(
        bottom: 100.0 + MediaQuery.paddingOf(context).bottom,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final feedItem = state.posts[index];

          return feedItem.when(
            story: (_) => const SizedBox.shrink(),
            imagePost: (_) => const SizedBox.shrink(),
            textPost: (textPost) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildTextPostTile(
                context,
                textPost,
                allItems: state.posts,
                itemIndex: index,
              ),
            ),
            videoPost: (_) => const SizedBox.shrink(),
          );
        }, childCount: state.posts.length),
      ),
    );
  }

  Widget _buildTextPostTile(
    BuildContext context,
    TextPost textPost, {
    required List<FeedItem> allItems,
    required int itemIndex,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => _openProfileViewerAndRefresh(
        context,
        feedItems: allItems,
        initialIndex: itemIndex,
      ),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.35,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.9),
                    theme.colorScheme.secondaryContainer.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.text_snippet_rounded,
                color: theme.colorScheme.primary,
                size: 30,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    textPost.body,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (textPost.tags.isNotEmpty)
                    Text(
                      textPost.tags.take(2).map((tag) => '#$tag').join('  '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildStatChip(
                        context,
                        Icons.favorite_rounded,
                        textPost.likes,
                        theme.colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      _buildStatChip(
                        context,
                        Icons.chat_bubble_rounded,
                        textPost.commentCount,
                        theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      _buildStatChip(
                        context,
                        Icons.share_rounded,
                        textPost.shareCount,
                        theme.colorScheme.tertiary,
                      ),
                      const Spacer(),
                      Text(
                        _formatPostDate(textPost.createdAt ?? DateTime.now()),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(
    BuildContext context,
    IconData icon,
    int count,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color.withValues(alpha: 0.85)),
          const SizedBox(width: 3),
          Text(
            count > 0 ? '$count' : '0',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPostDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  Future<void> _showGridHoldPreview(BuildContext context, FeedItem item) async {
    if (_isGridPreviewOpen) return;

    _isGridPreviewOpen = true;
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Post preview',
      transitionDuration: const Duration(milliseconds: 110),
      pageBuilder: (_, __, ___) {
        return StatefulBuilder(
          builder: (dialogContext, __) {
            _gridPreviewDialogContext = dialogContext;
            return Listener(
              behavior: HitTestBehavior.opaque,
              onPointerUp: (_) => _closeGridHoldPreview(),
              onPointerCancel: (_) => _closeGridHoldPreview(),
              child: Material(
                color: Colors.black.withValues(alpha: 0.92),
                child: SafeArea(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 9 / 16,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: _buildGridHoldPreviewMedia(item),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    _gridPreviewDialogContext = null;
    _isGridPreviewOpen = false;
  }

  void _closeGridHoldPreview() {
    final dialogContext = _gridPreviewDialogContext;
    if (_isGridPreviewOpen && dialogContext != null) {
      Navigator.of(dialogContext).pop();
    }
  }

  Widget _buildGridHoldPreviewMedia(FeedItem item) {
    return item.when(
      story: (story) => _buildPreviewImage(story.imageUrl ?? ''),
      imagePost: (post) {
        final urls = post.displayUrls;
        return _buildPreviewImage(urls.isNotEmpty ? urls.first : post.imageUrl);
      },
      textPost: (post) {
        if ((post.imageUrl ?? '').isNotEmpty) {
          return _buildPreviewImage(post.imageUrl!);
        }
        return Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: Text(
            post.body,
            maxLines: 8,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        );
      },
      videoPost: (post) => _buildPreviewVideo(
        videoUrl: post.videoUrl,
        thumbnailUrl: post.thumbnailUrl ?? '',
      ),
    );
  }

  Widget _buildPreviewVideo({
    required String videoUrl,
    required String thumbnailUrl,
  }) {
    if (videoUrl.isEmpty) {
      return _buildPreviewImage(thumbnailUrl);
    }

    return _GridHoldPreviewVideoSurface(
      videoUrl: videoUrl,
      thumbnailUrl: thumbnailUrl,
    );
  }

  Widget _buildPreviewImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Center(
          child: Icon(
            Icons.image_outlined,
            size: 52,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return InteractiveViewer(
      minScale: 1,
      maxScale: 4,
      child: Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) {
            return Icon(
              Icons.broken_image_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            );
          },
        ),
      ),
    );
  }

  Widget _buildGridView(BuildContext context, ProfileLoaded state) {
    return SliverPadding(
      padding: EdgeInsets.only(
        bottom: 100.0 + MediaQuery.paddingOf(context).bottom,
      ),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.0,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final feedItem = state.posts[index];

          return feedItem.when(
            story: (story) => InkWell(
              onTap: () => StoryDetailRoute(id: story.id).push(context),
              child: _buildImageGridItem(
                context,
                story.imageUrl ?? '',
                mediaUrls: const [],
                likes: story.likes,
                commentCount: story.commentCount,
                shareCount: story.shareCount,
              ),
            ),
            imagePost: (imagePost) => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _openProfileViewerAndRefresh(
                context,
                feedItems: state.posts,
                initialIndex: index,
              ),
              onLongPressStart: (_) => _showGridHoldPreview(context, feedItem),
              onLongPressEnd: (_) => _closeGridHoldPreview(),
              onLongPressCancel: _closeGridHoldPreview,
              child: _buildImageGridItem(
                context,
                imagePost.imageUrl,
                mediaUrls: imagePost.mediaUrls,
                likes: imagePost.likes,
                commentCount: imagePost.commentCount,
                shareCount: imagePost.shareCount,
              ),
            ),
            textPost: (_) =>
                _buildGridPlaceholder(context, Icons.text_fields_rounded),
            videoPost: (videoPost) => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _openProfileViewerAndRefresh(
                context,
                feedItems: state.posts,
                initialIndex: index,
              ),
              onLongPressStart: (_) => _showGridHoldPreview(context, feedItem),
              onLongPressEnd: (_) => _closeGridHoldPreview(),
              onLongPressCancel: _closeGridHoldPreview,
              child: _buildVideoGridItem(
                context,
                videoPost.thumbnailUrl ?? '',
                videoPost.videoUrl,
                likes: videoPost.likes,
                commentCount: videoPost.commentCount,
                shareCount: videoPost.shareCount,
              ),
            ),
          );
        }, childCount: state.posts.length),
      ),
    );
  }

  Widget _buildImageGridItem(
    BuildContext context,
    String imageUrl, {
    List<String> mediaUrls = const [],
    required int likes,
    required int commentCount,
    required int shareCount,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imageUrl.isNotEmpty)
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return _buildGridPlaceholder(context, Icons.image_rounded);
              },
            )
          else
            _buildGridPlaceholder(context, Icons.image_rounded),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.32),
                ],
              ),
            ),
          ),
          // Show image count badge for multi-image posts
          if (mediaUrls.length > 1)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.collections,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+${mediaUrls.length - 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            left: 4,
            right: 4,
            bottom: 4,
            child: _buildGridStatsRow(
              context,
              likes: likes,
              commentCount: commentCount,
              shareCount: shareCount,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoGridItem(
    BuildContext context,
    String thumbnailUrl,
    String videoUrl, {
    required int likes,
    required int commentCount,
    required int shareCount,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (thumbnailUrl.isNotEmpty)
            Image.network(
              thumbnailUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return _buildGridPlaceholder(context, Icons.videocam_rounded);
              },
            )
          else
            _buildGridPlaceholder(context, Icons.videocam_rounded),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.3),
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          Positioned(
            left: 4,
            right: 4,
            bottom: 4,
            child: _buildGridStatsRow(
              context,
              likes: likes,
              commentCount: commentCount,
              shareCount: shareCount,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridStatsRow(
    BuildContext context, {
    required int likes,
    required int commentCount,
    required int shareCount,
  }) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          _buildStatChip(
            context,
            Icons.favorite_rounded,
            likes,
            Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 4),
          _buildStatChip(
            context,
            Icons.chat_bubble_rounded,
            commentCount,
            Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 4),
          _buildStatChip(
            context,
            Icons.share_rounded,
            shareCount,
            Theme.of(context).colorScheme.tertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildGridPlaceholder(BuildContext context, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surfaceContainerHighest,
            Theme.of(context).colorScheme.surfaceContainer,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 32,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    // Rebuild when the underlying TabBar changes (e.g. theme, labels, or controller)
    return oldDelegate._tabBar != _tabBar;
  }
}

class _GridHoldPreviewVideoSurface extends StatefulWidget {
  final String videoUrl;
  final String thumbnailUrl;

  const _GridHoldPreviewVideoSurface({
    required this.videoUrl,
    required this.thumbnailUrl,
  });

  @override
  State<_GridHoldPreviewVideoSurface> createState() =>
      _GridHoldPreviewVideoSurfaceState();
}

class _GridHoldPreviewVideoSurfaceState
    extends State<_GridHoldPreviewVideoSurface> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );
      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(0);
      await controller.play();
      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _controller = controller;
        _isInitialized = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError || !_isInitialized || _controller == null) {
      if (widget.thumbnailUrl.isNotEmpty) {
        return Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: Image.network(
            widget.thumbnailUrl,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Icon(
              Icons.broken_image_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        );
      }

      return Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (_controller!.value.isPlaying) {
          _controller!.pause();
        } else {
          _controller!.play();
        }
        setState(() {});
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: _controller!.value.size.width,
              height: _controller!.value.size.height,
              child: VideoPlayer(_controller!),
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.volume_off_rounded, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'Muted',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!_controller!.value.isPlaying)
            const Center(
              child: Icon(
                Icons.play_circle_fill_rounded,
                color: Colors.white,
                size: 62,
              ),
            ),
        ],
      ),
    );
  }
}
