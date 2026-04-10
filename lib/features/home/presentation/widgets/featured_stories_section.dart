import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myitihas/core/cache/widgets/story_image.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// Featured stories carousel with page indicator and animations
class FeaturedStoriesSection extends StatefulWidget {
  final List<Story> stories;
  final bool isLoading;
  final void Function(Story story)? onStoryTap;

  const FeaturedStoriesSection({
    super.key,
    required this.stories,
    this.isLoading = false,
    this.onStoryTap,
  });

  @override
  State<FeaturedStoriesSection> createState() => _FeaturedStoriesSectionState();
}

class _FeaturedStoriesSectionState extends State<FeaturedStoriesSection>
    with WidgetsBindingObserver {
  int _currentPage = 0;
  Timer? _timer;
  bool _isAutoScrolling = true;
  late final PageController _pageController;
  bool _appInForeground = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pageController = PageController(viewportFraction: 0.9);
    _startTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appInForeground = state == AppLifecycleState.resumed;
    if (!_appInForeground) {
      _timer?.cancel();
      return;
    }

    // Resume auto-scroll only when widget is active.
    if (mounted && _isAutoScrolling) _startTimer();
  }

  bool _isWidgetActive(BuildContext context) {
    // If this widget is in an inactive tab (TabBarView etc), Flutter disables
    // tickers via TickerMode. We use it as a proxy for "visible/active".
    if (!TickerMode.valuesOf(context).enabled) return false;
    if (!_appInForeground) return false;

    // If this widget's route isn't current, it's not the active screen.
    final route = ModalRoute.of(context);
    if (route != null && !route.isCurrent) return false;

    return true;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted || !_isAutoScrolling || widget.stories.isEmpty) return;
      if (!_isWidgetActive(context)) return;

      final nextPage = (_currentPage + 1) % widget.stories.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  void _onUserInteraction() {
    if (_isAutoScrolling) {
      setState(() => _isAutoScrolling = false);
      _timer?.cancel();
      // Resume auto-scroll after 10 seconds of inactivity
      Future.delayed(const Duration(seconds: 10), () {
        if (mounted) {
          setState(() => _isAutoScrolling = true);
          _startTimer();
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final t = Translations.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (widget.isLoading) {
      return _buildShimmer(context, isDark);
    }

    if (widget.stories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFff9a44), Color(0xFFfc6076)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFfc6076).withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.fireFlameCurved,
                        size: 15.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        t.homeScreen.featuredStories,
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
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // Stories carousel
        SizedBox(
          height: 200.h,
          child: GestureDetector(
            onLongPressStart: (_) => _onUserInteraction(),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemCount: widget.stories.length,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 1.0;
                    if (_pageController.position.haveDimensions) {
                      value = (_pageController.page! - index).abs();
                      value = (1 - (value * 0.15)).clamp(0.85, 1.0);
                    }
                    return Center(
                      child: Transform.scale(
                        scale: value,
                        child: Opacity(
                          opacity: value.clamp(0.55, 1.0),
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: _FeaturedStoryCard(
                    story: widget.stories[index],
                    onTap: () => widget.onStoryTap?.call(widget.stories[index]),
                    cardIndex: index,
                  ),
                );
              },
            ),
          ),
        ),

        SizedBox(height: 12.h),

        // Page indicator
        Center(
          child: SmoothPageIndicator(
            controller: _pageController,
            count: widget.stories.length,
            effect: WormEffect(
              activeDotColor: colorScheme.primary,
              dotColor: colorScheme.outlineVariant.withValues(alpha: 0.35),
              dotHeight: 6.h,
              dotWidth: 6.w,
              spacing: 6.w,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmer(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final baseColor = isDark
        ? colorScheme.surfaceContainerHigh
        : colorScheme.surfaceContainerLow;
    final highlightColor = isDark
        ? colorScheme.surfaceContainerLow
        : colorScheme.surfaceContainerHighest;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            period: const Duration(milliseconds: 1400),
            child: Container(
              width: 150.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 200.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  period: const Duration(milliseconds: 1400),
                  child: Container(
                    width: 280.w,
                    height: 200.h,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 120.h,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          width: 180.w,
                          height: 14.h,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          width: 120.w,
                          height: 12.h,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 16.h),
        Center(
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            period: const Duration(milliseconds: 1400),
            child: Container(
              width: 40.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}



/// Individual featured story card
class _FeaturedStoryCard extends StatefulWidget {
  final Story story;
  final VoidCallback? onTap;
  final int cardIndex;

  const _FeaturedStoryCard({required this.story, this.onTap, this.cardIndex = 0});

  @override
  State<_FeaturedStoryCard> createState() => _FeaturedStoryCardState();
}

class _FeaturedStoryCardState extends State<_FeaturedStoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
      },
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 6.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.15),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image
                StoryImage(
                  imageUrl: widget.story.imageUrl,
                  fit: BoxFit.cover,
                  memCacheWidth: 800,
                  memCacheHeight: 800,
                  fallbackIndex: widget.cardIndex,
                  placeholder: (context) => Container(
                    color: colorScheme.surfaceContainerHighest,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),


                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.8),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),

                // Content
                Positioned(
                  left: 16.w,
                  right: 16.w,
                  bottom: 16.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Scripture chip
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          widget.story.scripture,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      SizedBox(height: 8.h),

                      // Title
                      Text(
                        widget.story.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),

                      SizedBox(height: 8.h),

                      // Meta info row
                      Row(
                        children: [
                          Icon(
                            Icons.auto_stories_rounded,
                            size: 14.sp,
                            color: Colors.white70,
                          ),
                          SizedBox(width: 4.w),

                          // Constrain this text
                          Expanded(
                            child: Text(
                              widget.story.attributes.storyType,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ),

                          SizedBox(width: 12.w),

                          Icon(
                            Icons.schedule_rounded,
                            size: 14.sp,
                            color: Colors.white70,
                          ),
                          SizedBox(width: 4.w),

                          // Constrain this text too
                          Flexible(
                            child: Text(
                              widget.story.attributes.storyLength
                                  .split(' ')
                                  .first,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Play/Read indicator
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 18.sp,
                      color: Colors.white,
                    ),
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
