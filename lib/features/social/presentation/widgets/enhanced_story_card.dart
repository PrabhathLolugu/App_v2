import 'package:flutter/material.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/core/cache/widgets/story_image.dart';
import 'package:myitihas/features/social/presentation/widgets/author_info_bar.dart';
import 'package:myitihas/features/social/presentation/widgets/engagement_bar.dart';
import 'package:myitihas/features/social/presentation/widgets/quote_callout.dart';
import 'package:myitihas/features/social/presentation/widgets/story_attribute_chip.dart';
import 'package:myitihas/features/social/presentation/widgets/swipeable_content_section.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';

class EnhancedStoryCard extends StatefulWidget {
  final Story story;
  final bool isVisible;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onBookmark;
  final VoidCallback? onProfileTap;
  final VoidCallback? onFollowTap;
  final VoidCallback? onContinueReading;
  final bool isFollowLoading;

  const EnhancedStoryCard({
    super.key,
    required this.story,
    this.isVisible = true,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onBookmark,
    this.onProfileTap,
    this.onFollowTap,
    this.onContinueReading,
    this.isFollowLoading = false,
  });

  @override
  State<EnhancedStoryCard> createState() => _EnhancedStoryCardState();
}

class _EnhancedStoryCardState extends State<EnhancedStoryCard>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late Animation<double> _authorFade;
  late Animation<double> _titleFade;
  late Animation<double> _quoteFade;
  late Animation<double> _contentFade;
  late Animation<double> _actionsFade;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    if (widget.isVisible) {
      _entranceController.forward();
    }
  }

  void _setupAnimations() {
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
          CurvedAnimation(parent: _entranceController, curve: Curves.easeOut),
        );

    _authorFade = _createStaggeredFade(0.0, 0.4);
    _titleFade = _createStaggeredFade(0.1, 0.5);
    _quoteFade = _createStaggeredFade(0.2, 0.6);
    _contentFade = _createStaggeredFade(0.3, 0.7);
    _actionsFade = _createStaggeredFade(0.4, 0.8);
  }

  Animation<double> _createStaggeredFade(double begin, double end) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Interval(begin, end, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void didUpdateWidget(EnhancedStoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _entranceController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradients = theme.extension<GradientExtension>();
    final story = widget.story;
    final screenSize = MediaQuery.of(context).size;
    // SafeArea already accounts for the device bottom inset. We only need to
    // lift content enough to clear the bottom navigation bar, but not so much
    // that it creates an oversized empty gap under the story card.
    final bottomBarLift = (kBottomNavigationBarHeight - 16).clamp(0.0, 80.0);
    final isTabletUp = screenSize.width >= 600;
    final bottomGradientHeight = isTabletUp
        ? screenSize.height * 0.68
        : screenSize.height * 0.8;
    final topGradientHeight = isTabletUp
        ? screenSize.height * 0.24
        : screenSize.height * 0.3;
    final contentRightInset = isTabletUp ? 88.0 : 44.0;
    final contentPadding = isTabletUp
        ? const EdgeInsets.fromLTRB(24, 14, 14, 18)
        : const EdgeInsets.fromLTRB(20, 12, 12, 16);
    final contentSectionHeight = isTabletUp ? 240.0 : 200.0;
    final engagementRight = isTabletUp ? 18.0 : 12.0;
    final engagementBottom = isTabletUp ? 12.0 : 8.0;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          height: screenSize.height,
          width: screenSize.width,
          color: Colors.black,
          child: Stack(
            fit: StackFit.expand,
            children: [
              SizedBox(
                height: screenSize.height,
                child: _HeroImageSection(story: story, gradients: gradients),
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: bottomGradientHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.95),
                        Colors.black.withValues(alpha: 0.7),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Container(
                  height: topGradientHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 0,
                right: contentRightInset,
                bottom: 0,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: contentPadding.copyWith(
                      bottom: contentPadding.bottom + bottomBarLift,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (story.authorUser != null)
                          FadeTransition(
                            opacity: _authorFade,
                            child: AuthorInfoBar(
                              author: story.authorUser!,
                              createdAt: story.publishedAt,
                              onProfileTap: widget.onProfileTap,
                              onFollowTap: widget.onFollowTap,
                              isFollowLoading: widget.isFollowLoading,
                              compact: false,
                              darkOverlay: true,
                            ),
                          ),
                        const SizedBox(height: 8),

                        // Title
                        FadeTransition(
                          opacity: _titleFade,
                          child: Text(
                            story.title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 4,
                          ),
                        ),
                        const SizedBox(height: 15),

                        FadeTransition(
                          opacity: _titleFade,
                          child: Row(
                            children: [
                              Flexible(
                                child: StoryAttributeChip.scripture(
                                  story.scripture,
                                  darkOverlay: true,
                                ),
                              ),
                              if (story.attributes.theme.isNotEmpty) ...[
                                const SizedBox(width: 4),
                                Flexible(
                                  child: StoryAttributeChip.theme(
                                    story.attributes.theme,
                                    darkOverlay: true,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        if (story.quotes.isNotEmpty)
                          FadeTransition(
                            opacity: _quoteFade,
                            child: QuoteCallout(
                              quote: story.quotes,
                              attribution: story.scripture,
                              maxLines: 2,
                              darkOverlay: true,
                            ),
                          ),
                        if (story.quotes.isNotEmpty) const SizedBox(height: 15),

                        FadeTransition(
                          opacity: _contentFade,
                          child: SizedBox(
                            height: contentSectionHeight,
                            child: SwipeableContentSection(
                              storyExcerpt: story.story,
                              trivia: story.trivia,
                              lesson: story.lesson,
                              activity: story.activity,
                              maxLines: 8,
                              darkOverlay: true,
                              onContinueReadingTap: widget.onContinueReading,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Continue Reading button
                        // FadeTransition(
                        //   opacity: _actionsFade,
                        //   child: _ContinueReadingButton(
                        //     onTap: widget.onContinueReading,
                        //     gradients: gradients,
                        //     colorScheme: colorScheme,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                right: engagementRight,
                bottom: engagementBottom,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: bottomBarLift),
                  child: FadeTransition(
                    opacity: _actionsFade,
                    child: EngagementBar(
                      likeCount: story.likes,
                      commentCount: story.commentCount,
                      shareCount: story.shareCount,
                      isLiked: story.isLikedByCurrentUser,
                      isBookmarked: story.isFavorite,
                      onLike: widget.onLike,
                      onComment: widget.onComment,
                      onShare: widget.onShare,
                      onBookmark: widget.onBookmark,
                      vertical: true,
                    ),
                  ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroImageSection extends StatelessWidget {
  final Story story;
  final GradientExtension? gradients;

  const _HeroImageSection({required this.story, this.gradients});

  @override
  Widget build(BuildContext context) {
    return StoryImage(
      imageUrl: story.imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      fallbackIndex: story.id.hashCode,
    );
  }
}
