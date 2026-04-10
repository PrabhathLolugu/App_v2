import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/core/cache/managers/image_cache_manager.dart';
import 'package:myitihas/core/widgets/image_loading_placeholder/image_loading_placeholder.dart';
import 'package:myitihas/features/social/domain/entities/image_post.dart';
import 'package:myitihas/features/social/presentation/widgets/author_info_bar.dart';
import 'package:myitihas/features/social/presentation/widgets/interactive_post_caption.dart';
import 'package:myitihas/features/social/presentation/widgets/engagement_bar.dart';
import 'package:myitihas/features/social/presentation/widgets/multi_image_carousel.dart';
import 'package:myitihas/features/social/presentation/widgets/repost_source_toast.dart';
import 'package:myitihas/i18n/strings.g.dart';

/// A full-screen card for displaying image posts in the social feed
class ImagePostCard extends StatefulWidget {
  final ImagePost post;
  final bool isVisible;
  final BoxFit mediaFit;
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

  const ImagePostCard({
    super.key,
    required this.post,
    this.isVisible = true,
    this.mediaFit = BoxFit.cover,
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
  State<ImagePostCard> createState() => _ImagePostCardState();
}

class _ImagePostCardState extends State<ImagePostCard>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _authorFade;
  late Animation<double> _captionFade;
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
    _captionFade = _createStaggeredFade(0.2, 0.6);
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
  void didUpdateWidget(ImagePostCard oldWidget) {
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
    final t = Translations.of(context);
    final post = widget.post;
    final screenSize = MediaQuery.of(context).size;
    final isTabletUp = screenSize.width >= 600;
    final topGradientHeight = isTabletUp ? 148.0 : 120.0;
    final bottomGradientHeight = isTabletUp
        ? screenSize.height * 0.38
        : screenSize.height * 0.45;
    final contentRightInset = isTabletUp ? 84.0 : 40.0;
    final contentPadding = isTabletUp
        ? const EdgeInsets.fromLTRB(20, 0, 12, 12)
        : const EdgeInsets.fromLTRB(16, 0, 8, 8);
    final engagementRight = isTabletUp ? 18.0 : 12.0;
    final engagementBottom = isTabletUp ? 12.0 : 8.0;
    final isRepost = post.repostedPostId != null;

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
              // Full-bleed image
              _HeroImageSection(post: post, mediaFit: widget.mediaFit),

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
                        Colors.black.withValues(alpha: 0.6),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

              // Content overlay
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
                                  postType: post.repostedPostType ?? 'image',
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

                        // Location badge
                        if (post.location != null && post.location!.isNotEmpty)
                          FadeTransition(
                            opacity: _captionFade,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    post.location!,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.white.withValues(
                                        alpha: 0.8,
                                      ),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (post.location != null && post.location!.isNotEmpty)
                          const SizedBox(height: 5),

                        // Caption
                        if (post.caption != null && post.caption!.isNotEmpty)
                          FadeTransition(
                            opacity: _captionFade,
                            child: InteractivePostCaption(
                              data: post.caption!,
                              maxCollapsedLength: 100,
                              mentions: post.mentions,
                              baseStyle: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                height: 1.4,
                              ),
                              hashtagStyle: theme.textTheme.bodyMedium
                                  ?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                    height: 1.4,
                                  ),
                              mentionStyle: theme.textTheme.bodyMedium
                                  ?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    height: 1.4,
                                  ),
                              toggleStyle: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
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
                        const SizedBox(height: 5),
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
}

class _HeroImageSection extends StatelessWidget {
  final ImagePost post;
  final BoxFit mediaFit;

  const _HeroImageSection({required this.post, required this.mediaFit});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final urls = post.displayUrls;

    if (urls.isEmpty) {
      return _ImagePlaceholder(colorScheme: colorScheme);
    }

    if (urls.length == 1) {
      return CachedNetworkImage(
        imageUrl: urls.first,
        cacheManager: ImageCacheManager.instance,
        memCacheWidth: 1200,
        memCacheHeight: 1200,
        fit: mediaFit,
        placeholder: (context, url) => const ImageLoadingPlaceholder(),
        errorWidget: (context, url, error) =>
            _ImagePlaceholder(colorScheme: colorScheme),
      );
    }

    return MultiImageCarousel(
      urls: urls,
      fit: mediaFit,
      errorWidget: (context, url, error) =>
          _ImagePlaceholder(colorScheme: colorScheme),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final ColorScheme colorScheme;

  const _ImagePlaceholder({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.image_outlined,
            size: 64,
            color: colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 8),
          Text(
            t.feed.tabs.images,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
