import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myitihas/features/story_generator/domain/entities/quick_prompt.dart';

/// Carousel widget for displaying quick prompt presets
class QuickPromptsCarousel extends StatefulWidget {
  final List<QuickPrompt> prompts;
  final ValueChanged<QuickPrompt> onPromptSelected;
  final int currentIndex;

  const QuickPromptsCarousel({
    super.key,
    required this.prompts,
    required this.onPromptSelected,
    this.currentIndex = 0,
  });

  @override
  State<QuickPromptsCarousel> createState() => _QuickPromptsCarouselState();
}

class _QuickPromptsCarouselState extends State<QuickPromptsCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.currentIndex;
    _pageController = PageController(
      viewportFraction: 0.85,
      initialPage: _currentPage,
    );
  }

  @override
  void didUpdateWidget(QuickPromptsCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.prompts != widget.prompts) {
      _pageController.jumpToPage(0);
      _currentPage = 0;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Icon(
                Icons.flash_on_rounded,
                size: 18.sp,
                color: colorScheme.primary,
              ),
              SizedBox(width: 6.w),
              Text(
                'Select Story Theme',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                  letterSpacing: -0.3,
                ),
              ),
              const Spacer(),
              Text(
                '${_currentPage + 1}/${widget.prompts.length}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        SizedBox(
          height: 120.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.prompts.length,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              HapticFeedback.selectionClick();
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              final prompt = widget.prompts[index];
              final isSelected = index == _currentPage;

              return TweenAnimationBuilder<double>(
                key: ValueKey('$index-$isSelected'),
                tween: Tween(
                  begin: isSelected ? 1.0 : 1.02,
                  end: isSelected ? 1.02 : 1.0,
                ),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  margin: EdgeInsets.symmetric(
                    horizontal: 6.w,
                    vertical: isSelected ? 0 : 8.h,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      widget.onPromptSelected(prompt);
                    },
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: isSelected ? 1.0 : 0.8,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: prompt.gradientColors,
                          ),
                          borderRadius: BorderRadius.circular(18.r),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: prompt.gradientColors.first
                                        .withValues(alpha: 0.4),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                  BoxShadow(
                                    color: prompt.gradientColors.last
                                        .withValues(alpha: 0.2),
                                    blurRadius: 24,
                                    offset: const Offset(0, 10),
                                    spreadRadius: -4,
                                  ),
                                ]
                              : null,
                        ),
                        child: Stack(
                          children: [
                            // Frosted glass pattern overlay
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18.r),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white.withValues(alpha: 0.1),
                                        Colors.white.withValues(alpha: 0.0),
                                        Colors.white.withValues(alpha: 0.05),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(12.w),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.2),
                                      borderRadius:
                                          BorderRadius.circular(14.r),
                                      border: Border.all(
                                        color: Colors.white
                                            .withValues(alpha: 0.15),
                                      ),
                                    ),
                                    child: Icon(
                                      prompt.icon,
                                      color: Colors.white,
                                      size: 28.sp,
                                    ),
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          prompt.title,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w800,
                                            height: 1.2,
                                            letterSpacing: -0.2,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4.h),
                                        Flexible(
                                          child: Text(
                                            prompt.subtitle,
                                            style: TextStyle(
                                              color: Colors.white
                                                  .withValues(alpha: 0.85),
                                              fontSize: 11.sp,
                                              height: 1.3,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(6.w),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.15),
                                      borderRadius:
                                          BorderRadius.circular(8.r),
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color:
                                          Colors.white.withValues(alpha: 0.8),
                                      size: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12.h),
        // Premium capsule-style dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.prompts.length,
            (index) {
              final isActive = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                width: isActive ? 28.w : 8.w,
                height: 6.h,
                decoration: BoxDecoration(
                  gradient: isActive
                      ? LinearGradient(
                          colors: [
                            colorScheme.primary,
                            colorScheme.secondary.withValues(alpha: 0.8),
                          ],
                        )
                      : null,
                  color: isActive
                      ? null
                      : colorScheme.onSurface.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(3.r),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color:
                                colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 4,
                          ),
                        ]
                      : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
