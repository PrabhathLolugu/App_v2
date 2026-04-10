import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/core/cache/managers/image_cache_manager.dart';
import 'package:myitihas/core/widgets/image_loading_placeholder/image_loading_placeholder.dart';
import 'package:myitihas/features/social/domain/entities/text_post.dart';
import 'package:myitihas/features/social/presentation/widgets/author_info_bar.dart';
import 'package:myitihas/features/social/presentation/widgets/interactive_post_caption.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/features/social/presentation/widgets/engagement_bar.dart';
import 'package:myitihas/features/social/presentation/widgets/post_poll_block.dart';
import 'package:myitihas/features/social/presentation/widgets/repost_source_toast.dart';

/// A full-screen card for displaying text posts in the social feed.
/// If the post has an imageUrl, it displays the text as a caption over the image.
class TextPostCard extends StatefulWidget {
  final TextPost post;
  final bool isVisible;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onBookmark;
  final VoidCallback? onProfileTap;
  final VoidCallback? onFollowTap;
  final VoidCallback? onMoreTap;
  final bool isFollowLoading;
  final void Function(String normalizedTagWithoutHash)? onHashtagTap;
  final void Function(String userId)? onMentionTap;

  const TextPostCard({
    super.key,
    required this.post,
    this.isVisible = true,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onBookmark,
    this.onProfileTap,
    this.onFollowTap,
    this.onMoreTap,
    this.isFollowLoading = false,
    this.onHashtagTap,
    this.onMentionTap,
  });

  @override
  State<TextPostCard> createState() => _TextPostCardState();
}

class _TextPostCardState extends State<TextPostCard>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _authorFade;
  late Animation<double> _textFade;
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
    _textFade = _createStaggeredFade(0.2, 0.7);
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
  void didUpdateWidget(TextPostCard oldWidget) {
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
    final post = widget.post;
    final screenSize = MediaQuery.of(context).size;
    final isTabletUp = screenSize.width >= 600;

    final hasImage = post.imageUrl != null && post.imageUrl!.isNotEmpty;
    final isRepost = post.repostedPostId != null;

    // If the post has an image, render with image background
    if (hasImage) {
      return _buildImageBackgroundLayout(
        context,
        theme,
        post,
        screenSize,
        isTabletUp,
        isRepost: isRepost,
      );
    }

    // Otherwise, render with solid color background
    return _buildColorBackgroundLayout(
      context,
      theme,
      post,
      screenSize,
      isTabletUp,
      isRepost: isRepost,
    );
  }

  Widget _buildImageBackgroundLayout(
    BuildContext context,
    ThemeData theme,
    TextPost post,
    Size screenSize,
    bool isTabletUp, {
    required bool isRepost,
  }) {
    final t = Translations.of(context);
    final topGradientHeight = isTabletUp ? 148.0 : 120.0;
    final bottomGradientHeight = isTabletUp
        ? screenSize.height * 0.46
        : screenSize.height * 0.55;
    final contentRightInset = isTabletUp ? 84.0 : 40.0;
    final contentPadding = isTabletUp
        ? const EdgeInsets.fromLTRB(20, 0, 12, 16)
        : const EdgeInsets.fromLTRB(16, 0, 8, 16);
    final engagementRight = isTabletUp ? 18.0 : 12.0;
    final engagementBottom = isTabletUp ? 12.0 : 48.0;

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
              // Full-bleed background image
              CachedNetworkImage(
                imageUrl: post.imageUrl!,
                cacheManager: ImageCacheManager.instance,
                memCacheWidth: 800,
                memCacheHeight: 800,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    ImageLoadingPlaceholder(width: null, height: null),
                errorWidget: (context, url, error) =>
                    Container(color: Color(post.backgroundColor)),
              ),

              // Top gradient for header
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

              // Bottom gradient for content
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
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

              // Content overlay - caption style
              Positioned(
                left: 0,
                right: contentRightInset,
                bottom: 0,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: contentPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isRepost) ...[
                          Align(
                            alignment: Alignment.centerRight,
                            child: RepostSourceToast(
                              authorName: post.repostedAuthorName,
                              authorUsername: post.repostedAuthorUsername,
                              darkOverlay: true,
                              onTap: () {
                                final repostedId = post.repostedPostId;
                                if (repostedId == null) return;
                                PostDetailRoute(
                                  postId: repostedId,
                                  postType: post.repostedPostType ?? 'text',
                                ).push(context);
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        // Author info
                        if (post.authorUser != null)
                          FadeTransition(
                            opacity: _authorFade,
                            child: AuthorInfoBar(
                              author: post.authorUser!,
                              createdAt: post.createdAt,
                              postTitle: post.title,
                              onProfileTap: widget.onProfileTap,
                              onFollowTap: widget.onFollowTap,
                              onMoreTap: widget.onMoreTap,
                              isFollowLoading: widget.isFollowLoading,
                              compact: false,
                              darkOverlay: true,
                            ),
                          ),
                        const SizedBox(height: 12),

                        // Caption text (the body)
                        FadeTransition(
                          opacity: _textFade,
                          child: InteractivePostCaption(
                            data: post.body,
                            maxCollapsedLength: 180,
                            mentions: post.mentions,
                            baseStyle: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              height: 1.5,
                              fontSize: 16,
                            ),
                            hashtagStyle: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              fontSize: 16,
                            ),
                            mentionStyle: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              height: 1.5,
                              fontSize: 16,
                            ),
                            toggleStyle: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            readMoreText: t.stories.readMore,
                            readLessText: t.stories.readLess,
                            onHashtagTap: widget.onHashtagTap,
                            onMentionTap:
                                widget.onMentionTap ??
                                (uid) =>
                                    ProfileRoute(userId: uid).push(context),
                          ),
                        ),
                        const SizedBox(height: 12),

                        if (post.poll != null) ...[
                          FadeTransition(
                            opacity: _authorFade,
                            child: PostPollBlock(
                              postId: post.id,
                              poll: post.poll!,
                              darkOverlay: true,
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              // Vertical engagement bar
              Positioned(
                right: engagementRight,
                bottom: engagementBottom,
                child: SafeArea(
                  top: false,
                  child: FadeTransition(
                    opacity: _actionsFade,
                    child: EngagementBar(
                      likeCount: post.likes,
                      commentCount: post.commentCount,
                      shareCount: post.shareCount,
                      isLiked: post.isLikedByCurrentUser,
                      isBookmarked: post.isFavorite,
                      onLike: widget.onLike,
                      onComment: widget.onComment,
                      onShare: widget.onShare,
                      onBookmark: widget.onBookmark,
                      vertical: true,
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

  Widget _buildColorBackgroundLayout(
    BuildContext context,
    ThemeData theme,
    TextPost post,
    Size screenSize,
    bool isTabletUp, {
    required bool isRepost,
  }) {
    final t = Translations.of(context);
    final backgroundColor = Color(post.backgroundColor);
    final textColor = Color(post.textColor);

    // Determine if we need light or dark overlays based on background luminance
    final isLightBackground = backgroundColor.computeLuminance() > 0.5;
    final overlayColor = isLightBackground ? Colors.black : Colors.white;
    final topGradientHeight = isTabletUp ? 148.0 : 120.0;
    final contentRightInset = isTabletUp ? 84.0 : 40.0;
    final contentPadding = isTabletUp
        ? const EdgeInsets.fromLTRB(20, 0, 12, 12)
        : const EdgeInsets.fromLTRB(16, 0, 8, 8);
    final engagementRight = isTabletUp ? 18.0 : 12.0;
    final engagementBottom = isTabletUp ? 12.0 : 8.0;
    final textMaxHeight = isTabletUp
        ? (screenSize.height * 0.58).clamp(360.0, 520.0).toDouble()
        : screenSize.height * 0.5;
    final textHorizontalPadding = isTabletUp ? 32.0 : 24.0;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          height: screenSize.height,
          width: screenSize.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [backgroundColor, _darken(backgroundColor, 0.15)],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Decorative pattern overlay
              Positioned.fill(
                child: CustomPaint(
                  painter: _PatternPainter(
                    color: overlayColor.withValues(alpha: 0.03),
                  ),
                ),
              ),

              // Top gradient for header
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
                        Colors.black.withValues(alpha: 0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom gradient for engagement
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: screenSize.height * 0.25,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Main content - centered text
              Positioned.fill(
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: textHorizontalPadding,
                    ),
                    child: Column(
                      children: [
                        const Spacer(flex: 1),

                        // Main text content
                        FadeTransition(
                          opacity: _textFade,
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight: textMaxHeight,
                            ),
                            child: SingleChildScrollView(
                              child: InteractivePostCaption(
                                data: post.body,
                                maxCollapsedLength: 180,
                                mentions: post.mentions,
                                baseStyle: TextStyle(
                                  color: textColor,
                                  fontSize: post.fontSize,
                                  fontFamily: post.fontFamily,
                                  height: 1.5,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.3,
                                ),
                                hashtagStyle: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontSize: post.fontSize,
                                  fontFamily: post.fontFamily,
                                  height: 1.5,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                                mentionStyle: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontSize: post.fontSize,
                                  fontFamily: post.fontFamily,
                                  height: 1.5,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ),
                                textAlign: TextAlign.center,
                                readMoreText: t.stories.readMore,
                                readLessText: t.stories.readLess,
                                onHashtagTap: widget.onHashtagTap,
                                onMentionTap:
                                    widget.onMentionTap ??
                                    (uid) =>
                                        ProfileRoute(userId: uid).push(context),
                              ),
                            ),
                          ),
                        ),

                        const Spacer(flex: 2),
                      ],
                    ),
                  ),
                ),
              ),

              // Author info at bottom
              Positioned(
                left: 0,
                right: contentRightInset,
                bottom: 0,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: contentPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isRepost) ...[
                          Align(
                            alignment: Alignment.centerRight,
                            child: RepostSourceToast(
                              authorName: post.repostedAuthorName,
                              authorUsername: post.repostedAuthorUsername,
                              darkOverlay: !isLightBackground,
                              onTap: () {
                                final repostedId = post.repostedPostId;
                                if (repostedId == null) return;
                                PostDetailRoute(
                                  postId: repostedId,
                                  postType: post.repostedPostType ?? 'text',
                                ).push(context);
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        // Author info
                        if (post.authorUser != null)
                          FadeTransition(
                            opacity: _authorFade,
                            child: AuthorInfoBar(
                              author: post.authorUser!,
                              createdAt: post.createdAt,
                              postTitle: post.title,
                              onProfileTap: widget.onProfileTap,
                              onFollowTap: widget.onFollowTap,
                              onMoreTap: widget.onMoreTap,
                              isFollowLoading: widget.isFollowLoading,
                              compact: false,
                              darkOverlay: true,
                            ),
                          ),
                        const SizedBox(height: 5),

                        if (post.poll != null) ...[
                          FadeTransition(
                            opacity: _authorFade,
                            child: PostPollBlock(
                              postId: post.id,
                              poll: post.poll!,
                              darkOverlay: !isLightBackground,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              // Vertical engagement bar
              Positioned(
                right: engagementRight,
                bottom: engagementBottom,
                child: SafeArea(
                  top: false,
                  child: FadeTransition(
                    opacity: _actionsFade,
                    child: EngagementBar(
                      likeCount: post.likes,
                      commentCount: post.commentCount,
                      shareCount: post.shareCount,
                      isLiked: post.isLikedByCurrentUser,
                      isBookmarked: post.isFavorite,
                      onLike: widget.onLike,
                      onComment: widget.onComment,
                      onShare: widget.onShare,
                      onBookmark: widget.onBookmark,
                      vertical: true,
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

  Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }
}

/// Custom painter for decorative background pattern
class _PatternPainter extends CustomPainter {
  final Color color;

  _PatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;

    // Draw subtle diagonal lines
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
