import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/core/cache/services/prefetch_service.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/features/home/presentation/bloc/home_bloc.dart';
import 'package:myitihas/features/home/presentation/bloc/home_event.dart';
import 'package:myitihas/features/home/presentation/bloc/home_state.dart';
import 'package:myitihas/features/home/presentation/pages/my_generated_stories_page.dart';
import 'package:myitihas/features/home/presentation/widgets/animated_greeting.dart';
import 'package:myitihas/features/home/presentation/widgets/continue_reading_section.dart';
import 'package:myitihas/features/home/presentation/widgets/create_post_card.dart';
import 'package:myitihas/features/home/presentation/widgets/discover_myitihas_card.dart';
import 'package:myitihas/features/home/presentation/widgets/featured_stories_section.dart';
import 'package:myitihas/features/home/presentation/widgets/home_feature_hero_carousel.dart';
import 'package:myitihas/features/home/presentation/widgets/indian_festivals_section.dart';
import 'package:myitihas/features/home/presentation/widgets/my_generated_stories_section.dart';
import 'package:myitihas/features/home/presentation/widgets/saved_stories_section.dart';
import 'package:myitihas/features/home/presentation/widgets/scriptures_section.dart';
import 'package:myitihas/features/home/presentation/widgets/stories_in_your_language_section.dart';
import 'package:myitihas/features/notifications/presentation/cubit/notification_count_cubit.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Main HomeScreen page - the primary landing experience
class HomeScreenPage extends StatelessWidget {
  const HomeScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeBloc>()..add(const HomeEvent.loadHome()),
      child: const _HomeScreenView(),
    );
  }
}

class _HomeScreenView extends StatefulWidget {
  const _HomeScreenView();

  @override
  State<_HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<_HomeScreenView>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _heroAnimationController;
  late Animation<double> _heroOpacity;

  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    _heroAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _heroOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _heroAnimationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _heroAnimationController.forward();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  /// Reload list sections that show story thumbnails (covers async image updates).
  void _reloadHomeStorySections(BuildContext context) {
    if (!context.mounted) return;
    context.read<HomeBloc>().add(const HomeEvent.reloadStorySectionsQuietly());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _heroAnimationController.dispose();
    super.dispose();
  }

  String _getGreeting(BuildContext context, String greetingKey) {
    final t = Translations.of(context);
    switch (greetingKey) {
      case 'morning':
        return t.home.greetingMorning;
      case 'afternoon':
        return t.home.greetingAfternoon;
      case 'evening':
        return t.home.greetingEvening;
      case 'night':
        return t.home.greetingNight;
      default:
        return t.home.greetingMorning;
    }
  }

  static List<String> _collectStoryImageUrls(HomeState state) {
    final urls = <String>[];
    for (final list in [
      state.featuredStories,
      state.continueReading,
      state.savedStories,
      state.myGeneratedStories,
    ]) {
      for (final story in list) {
        if (story.imageUrl != null &&
            story.imageUrl!.isNotEmpty &&
            !urls.contains(story.imageUrl)) {
          urls.add(story.imageUrl!);
        }
      }
    }
    for (final loc in state.sacredLocations) {
      if (loc.image != null &&
          loc.image!.isNotEmpty &&
          loc.image!.startsWith('http') &&
          !urls.contains(loc.image)) {
        urls.add(loc.image!);
      }
    }
    return urls;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (prev, curr) {
        final refreshDone = prev.isRefreshing && !curr.isRefreshing;
        final loadDone = prev.isLoading && !curr.isLoading;
        return refreshDone || loadDone;
      },
      listener: (context, state) {
        // Prefetch story images when home has finished loading and has content
        if (!state.isLoading && state.hasContent) {
          final urls = _collectStoryImageUrls(state);
          if (urls.isNotEmpty && context.mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;
              getIt<PrefetchService>().prefetchImages(
                context,
                urls,
                maxPrefetch: 12,
              );
            });
          }
        }
      },
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            HapticFeedback.heavyImpact();
            final bloc = context.read<HomeBloc>();
            bloc.add(const HomeEvent.refresh());
            await bloc.stream
                .where((s) => !s.isRefreshing)
                .first
                .timeout(const Duration(seconds: 15));
          },
          color: colorScheme.primary,
          backgroundColor: colorScheme.surfaceContainerHighest,
          strokeWidth: 2.5,
          displacement: 50,
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          child: Stack(
            children: [
              // Animated gradient background
              _AnimatedGradientBackground(
                scrollOffset: _scrollOffset,
                isDark: isDark,
              ),

              // Main content
              CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  // Hero Header Section (Greeting + Notification)
                  SliverToBoxAdapter(child: _buildHeroHeader(context, state)),

                  // 1. Create Post Card
                  SliverToBoxAdapter(
                    child: _StaggeredSection(
                      delay: const Duration(milliseconds: 100),
                      child: Padding(
                        padding: EdgeInsets.only(top: 24.h),
                        child: const CreatePostCard(),
                      ),
                    ),
                  ),

                  // 2. Generate Story Card
                  SliverToBoxAdapter(
                    child: _StaggeredSection(
                      delay: const Duration(milliseconds: 200),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 24.h,
                          left: 20.w,
                          right: 20.w,
                        ),
                        child: _GenerateStoryCard(
                          onTap: () => context.push('/story-generator'),
                          isDark: isDark,
                        ),
                      ),
                    ),
                  ),

                  // 3. Featured Stories
                  SliverToBoxAdapter(
                    child: _StaggeredSection(
                      delay: const Duration(milliseconds: 400),
                      child: Padding(
                        padding: EdgeInsets.only(top: 24.h),
                        child: FeaturedStoriesSection(
                          stories: state.featuredStories,
                          isLoading: state.isFeaturedLoading,
                          onStoryTap: (story) {
                            StoryDetailRoute(id: story.id).push(context);
                          },
                        ),
                      ),
                    ),
                  ),

                  // Remaining existing sections start here
                  // Discover card for first-time users
                  SliverToBoxAdapter(
                    child: _StaggeredSection(
                      delay: const Duration(milliseconds: 550),
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: DiscoverMyItihasCard(
                          hasSeenDiscover: () async {
                            final prefs = await SharedPreferences.getInstance();
                            return prefs.getBool(
                                  DiscoverMyItihasCard.hasSeenKey,
                                ) ??
                                false;
                          },
                          markDiscoverSeen: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool(
                              DiscoverMyItihasCard.hasSeenKey,
                              true,
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // 4. Continue Reading
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 28.h),
                      child: ContinueReadingSection(
                        stories: state.continueReading,
                        isLoading: state.isContinueReadingLoading,
                        onStoryTap: (story) {
                          StoryDetailRoute(id: story.id).push(context).then((
                            _,
                          ) {
                            if (context.mounted) {
                              _reloadHomeStorySections(context);
                            }
                          });
                        },
                        onSeeAll: () => context.push('/activity'),
                        onExplore: () => StoriesRoute().push(context),
                      ),
                    ),
                  ),

                  // 5. Scriptures Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 28.h),
                      child: const ScripturesSection(),
                    ),
                  ),

                  // 6. My Generated Stories
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 28.h),
                      child: MyGeneratedStoriesSection(
                        stories: state.myGeneratedStories.take(10).toList(),
                        isLoading: state.isMyGeneratedStoriesLoading,
                        onStoryTap: (story) {
                          GeneratedStoryByIdRoute(
                            storyId: story.id,
                          ).push(context).then((_) {
                            if (context.mounted) {
                              _reloadHomeStorySections(context);
                            }
                          });
                        },
                        onSeeAll: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => MyGeneratedStoriesPage(
                                stories: state.myGeneratedStories,
                              ),
                            ),
                          );
                        },
                        onCreateNew: () => context.push('/story-generator'),
                      ),
                    ),
                  ),

                  // 7. Stories in your language
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 28.h),
                      child: const StoriesInYourLanguageSection(),
                    ),
                  ),

                  // 8. Festival Stories
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 28.h),
                      child: IndianFestivalsSection(
                        festivals: state.festivals,
                        isLoading: state.isFestivalsLoading,
                        onFestivalTap: (festival) {
                          FestivalDetailRoute($extra: festival).push(context);
                        },
                        onViewAll: () => FestivalsListRoute().push(context),
                      ),
                    ),
                  ),

                  // 9. Saved Stories (bookmarks)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 28.h),
                      child: SavedStoriesSection(
                        stories: state.savedStories,
                        isLoading: state.isSavedStoriesLoading,
                        onSeeAll: () {
                          SavedStoriesRoute(
                            $extra: state.savedStories,
                          ).push(context).then((_) {
                            if (context.mounted) {
                              _reloadHomeStorySections(context);
                            }
                          });
                        },
                        onAfterStoryClosed: () {
                          if (context.mounted) {
                            _reloadHomeStorySections(context);
                          }
                        },
                      ),
                    ),
                  ),

                  // 10. Hero carousel (last section)
                  SliverToBoxAdapter(child: _buildHeroCarouselSection(context)),

                  // Bottom padding: account for app bottom nav + system nav (safe area)
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 100.h + MediaQuery.paddingOf(context).bottom,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeroHeader(BuildContext context, HomeState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final t = Translations.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Parallax effect based on scroll (reduced for subtlety)
    final parallaxOffset = (_scrollOffset * 0.2).clamp(0.0, 100.0);
    final headerOpacity = (1 - (_scrollOffset / 200)).clamp(0.0, 1.0);

    return AnimatedBuilder(
      animation: _heroAnimationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -parallaxOffset),
          child: Opacity(
            opacity: headerOpacity,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Greeting and Notification Row (unboxed)
                    FadeTransition(
                      opacity: _heroOpacity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedGreeting(
                                greeting: _getGreeting(
                                  context,
                                  state.greetingKey,
                                ),
                                userName: state.userName ?? t.app.name,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                state.userName ?? t.app.name,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              BlocBuilder<NotificationCountCubit, int>(
                                builder: (context, count) {
                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      _GlassIconButton(
                                        icon: Icons.notifications_outlined,
                                        onTap: () =>
                                            context.push('/notifications'),
                                        isDark: isDark,
                                      ),
                                      if (count > 0)
                                        Positioned(
                                          top: -4,
                                          right: -4,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 5.w,
                                              vertical: 2.h,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFFEF4444),
                                                  Color(0xFFDC2626),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              border: Border.all(
                                                color: isDark
                                                    ? const Color(0xFF1E293B)
                                                    : Colors.white,
                                                width: 1.5,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(
                                                    0xFFEF4444,
                                                  ).withValues(alpha: 0.4),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            constraints: BoxConstraints(
                                              minWidth: 18.w,
                                              minHeight: 18.h,
                                            ),
                                            child: Center(
                                              child: Text(
                                                count > 99 ? '99+' : '$count',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.bold,
                                                  height: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroCarouselSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final t = Translations.of(context);

    return Padding(
      padding: EdgeInsets.only(top: 28.h, left: 20.w, right: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF38ef7d).withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: FaIcon(
                  FontAwesomeIcons.compass,
                  size: 15.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  t.homeScreen.exploreMyitihas,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          HomeFeatureHeroCarousel(
            onGenerateStoryTap: () => context.push('/story-generator'),
            onCompanionChatTap: () => context.push('/chatbot'),
            onExploreMapTap: () => context.go('/home?tab=3&map=explore'),
            onCommunityTap: () => context.go('/home?tab=2'),
            onTravelPlanTap: () => context.go('/home?tab=3&map=plan'),
            onDiscussionForumTap: () => context.go('/home?tab=3&map=discussions'),
          ),
        ],
      ),
    );
  }
}

/// Staggered entrance animation for sections - improves perceived
/// performance and delight for user retention
class _StaggeredSection extends StatefulWidget {
  final Duration delay;
  final Widget child;

  const _StaggeredSection({required this.delay, required this.child});

  @override
  State<_StaggeredSection> createState() => _StaggeredSectionState();
}

class _StaggeredSectionState extends State<_StaggeredSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );
    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

/// Animated gradient background that responds to scroll
/// Updated background with your specific accent colors
class _AnimatedGradientBackground extends StatelessWidget {
  final double scrollOffset;
  final bool isDark;

  const _AnimatedGradientBackground({
    required this.scrollOffset,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradients = theme.extension<GradientExtension>();
    final colorScheme = theme.colorScheme;
    final gradientShift = (scrollOffset / 500).clamp(0.0, 0.15);

    final gradient =
        gradients?.screenBackgroundGradient ??
        LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  colorScheme.primary.withValues(alpha: 0.08 + gradientShift),
                  colorScheme.secondary.withValues(alpha: 0.05),
                  colorScheme.surface,
                ]
              : [
                  colorScheme.primary.withValues(alpha: 0.04 + gradientShift),
                  colorScheme.secondary.withValues(alpha: 0.03),
                  colorScheme.surface,
                ],
          stops: const [0.0, 0.5, 1.0],
        );

    return Positioned.fill(
      child: Container(decoration: BoxDecoration(gradient: gradient)),
    );
  }
}

/// Glass-morphic icon button
class _GlassIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  const _GlassIconButton({
    required this.icon,
    required this.onTap,
    required this.isDark,
  });

  @override
  State<_GlassIconButton> createState() => _GlassIconButtonState();
}

class _GlassIconButtonState extends State<_GlassIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
        HapticFeedback.lightImpact();
      },
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: widget.isDark
                    ? Colors.white.withValues(alpha: 0.10)
                    : Colors.white.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: widget.isDark
                      ? Colors.white.withValues(alpha: 0.16)
                      : Colors.white.withValues(alpha: 0.22),
                ),
              ),
              child: Icon(
                widget.icon,
                color: colorScheme.onSurface.withValues(alpha: 0.88),
                size: 24.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact Generate Story Card
class _GenerateStoryCard extends StatefulWidget {
  final VoidCallback onTap;
  final bool isDark;

  const _GenerateStoryCard({required this.onTap, required this.isDark});

  @override
  State<_GenerateStoryCard> createState() => _GenerateStoryCardState();
}

class _GenerateStoryCardState extends State<_GenerateStoryCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _orbController;
  late AnimationController _particleController;
  late Animation<double> _scale;
  late Animation<double> _orbPulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _orbController = AnimationController(
      duration: const Duration(milliseconds: 3600),
      vsync: this,
    )..repeat(reverse: true);
    _orbPulse = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _orbController, curve: Curves.easeInOut));

    _particleController = AnimationController(
      duration: const Duration(milliseconds: 5200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _orbController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  List<Color> _buildDarkGradient(Color accent) {
    final hsl = HSLColor.fromColor(accent);
    final base = hsl.withLightness(0.04).withSaturation(0.86).toColor();
    final mid = hsl.withLightness(0.09).withSaturation(0.82).toColor();
    final edge = hsl.withLightness(0.14).withSaturation(0.80).toColor();
    return [base, mid, edge];
  }

  List<Color> _buildLightGradient(Color accent) {
    final hsl = HSLColor.fromColor(accent);
    final base = hsl.withLightness(0.95).withSaturation(0.62).toColor();
    final edge = hsl.withLightness(0.87).withSaturation(0.70).toColor();
    return [base, edge];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);
    final accent = const Color(0xFFFFAB40);
    final accent2 = const Color(0xFFE65100);
    final isDark = widget.isDark;
    final gradient = isDark
        ? _buildDarkGradient(accent)
        : _buildLightGradient(accent);
    final textColor = isDark
        ? Colors.white.withValues(alpha: 0.96)
        : HSLColor.fromColor(accent).withLightness(0.11).toColor();

    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
        HapticFeedback.mediumImpact();
      },
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          height: 106.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: isDark ? 0.30 : 0.22),
                blurRadius: 22,
                spreadRadius: -3,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradient,
                      ),
                    ),
                  ),
                ),
                if (!isDark)
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.topLeft,
                          radius: 1.7,
                          colors: [
                            Colors.white.withValues(alpha: 0.42),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _particleController,
                    builder: (_, __) => CustomPaint(
                      painter: _CompactCardParticlePainter(
                        progress: _particleController.value,
                        accent: accent,
                        seed: 31,
                        isDark: isDark,
                        count: 9,
                      ),
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: _orbPulse,
                  builder: (_, __) {
                    final size = 90.w + (_orbPulse.value * 14.w);
                    final alpha =
                        (isDark ? 0.22 : 0.18) + (_orbPulse.value * 0.08);
                    return Positioned(
                      top: -size * 0.38,
                      right: -size * 0.26,
                      child: Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              accent.withValues(alpha: alpha),
                              accent2.withValues(alpha: alpha * 0.35),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.56, 1.0],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 40.h,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: isDark ? 0.08 : 0.35),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: accent.withValues(alpha: isDark ? 0.30 : 0.36),
                        width: 0.9,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: isDark ? 0.16 : 0.14),
                          borderRadius: BorderRadius.circular(13.r),
                          border: Border.all(
                            color: accent.withValues(
                              alpha: isDark ? 0.34 : 0.40,
                            ),
                            width: 0.8,
                          ),
                        ),
                        child: Icon(
                          Icons.auto_awesome_sharp,
                          size: 17.sp,
                          color: isDark
                              ? accent
                              : HSLColor.fromColor(
                                  accent,
                                ).withLightness(0.16).toColor(),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              t.homeScreen.generateStory,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: textColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 15.5.sp,
                                letterSpacing: -0.2,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Create your scriptural tale',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.82)
                                    : textColor.withValues(alpha: 0.72),
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: isDark ? accent : textColor,
                        size: 20.sp,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CompactCardParticlePainter extends CustomPainter {
  final double progress;
  final Color accent;
  final bool isDark;
  final int seed;
  final int count;

  const _CompactCardParticlePainter({
    required this.progress,
    required this.accent,
    required this.isDark,
    required this.seed,
    this.count = 8,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(seed);
    final maxOpacity = isDark ? 0.42 : 0.28;

    for (var i = 0; i < count; i++) {
      final baseX = rng.nextDouble() * size.width;
      final baseY = rng.nextDouble() * size.height;
      final speed = 0.18 + rng.nextDouble() * 0.45;
      final phase = rng.nextDouble();
      final t = (progress * speed + phase) % 1.0;
      final y = baseY - t * size.height * 0.58;
      final opacity =
          (math.sin(t * math.pi) *
                  maxOpacity *
                  (0.45 + rng.nextDouble() * 0.55))
              .clamp(0.0, maxOpacity);
      final radius = 0.8 + rng.nextDouble() * 1.6;

      canvas.drawCircle(
        Offset(baseX + math.sin(t * 2 * math.pi + phase) * 6, y),
        radius,
        Paint()..color = accent.withValues(alpha: opacity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CompactCardParticlePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}
