import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/features/social/domain/entities/video_post.dart';
import 'package:myitihas/features/social/presentation/widgets/author_info_bar.dart';
import 'package:myitihas/features/social/presentation/widgets/interactive_post_caption.dart';
import 'package:myitihas/features/social/presentation/widgets/engagement_bar.dart';
import 'package:myitihas/features/social/presentation/widgets/feed_video_player.dart';
import 'package:myitihas/features/social/presentation/widgets/repost_source_toast.dart';
import 'package:myitihas/i18n/strings.g.dart';

/// A full-screen card for displaying video posts in the social feed.
/// Features a tappable caption that shows/hides on tap.
class VideoPostCard extends StatefulWidget {
  final VideoPost post;
  final bool isVisible;
  final bool startMuted;
  final bool showPersistentMuteBadge;
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

  const VideoPostCard({
    super.key,
    required this.post,
    this.isVisible = true,
    this.startMuted = false,
    this.showPersistentMuteBadge = false,
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
  State<VideoPostCard> createState() => _VideoPostCardState();
}

class _VideoPostCardState extends State<VideoPostCard>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _captionController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _authorFade;
  late Animation<double> _captionFade;
  late Animation<double> _actionsFade;

  bool _isCaptionVisible = true;
  bool _showVideoControls = false;

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
      duration: const Duration(milliseconds: 380),
      vsync: this,
    );

    _captionController = AnimationController(
      duration: const Duration(milliseconds: 180),
      vsync: this,
      value: 1.0, // Start visible
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
  void didUpdateWidget(VideoPostCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _entranceController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _captionController.dispose();
    super.dispose();
  }

  void _toggleCaption() {
    setState(() {
      _isCaptionVisible = !_isCaptionVisible;
      if (_isCaptionVisible) {
        _captionController.forward();
      } else {
        _captionController.reverse();
      }
    });
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
        ? const EdgeInsets.fromLTRB(20, 0, 12, 16)
        : const EdgeInsets.fromLTRB(16, 0, 8, 16);
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
              FeedVideoPlayer(
                videoUrl: post.videoUrl,
                thumbnailUrl: post.thumbnailUrl,
                isVisible: widget.isVisible,
                startMuted: widget.startMuted,
                showPersistentMuteBadge: widget.showPersistentMuteBadge,
                onDoubleTap: widget.onLike,
                onControlsVisibilityChanged: (visible) =>
                    setState(() => _showVideoControls = visible),
              ),

              // Top gradient (ignore pointer so tap reaches video)
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: IgnorePointer(
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
              ),

              // Bottom gradient (ignore pointer so tap reaches video)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: IgnorePointer(
                  child: FadeTransition(
                    opacity: _captionController,
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
                ),
              ),

              // Content overlay (repost always visible; rest toggles with caption)
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
                                  postType: post.repostedPostType ?? 'video',
                                ).push(context);
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        FadeTransition(
                          opacity: _captionController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
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

                              // Location badge
                              if (post.location != null &&
                                  post.location!.isNotEmpty)
                                FadeTransition(
                                  opacity: _captionFade,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 16,
                                        color: Colors.white.withValues(
                                          alpha: 0.8,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          post.location!,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
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
                              if (post.location != null &&
                                  post.location!.isNotEmpty)
                                const SizedBox(height: 8),

                              // Caption
                              if (post.caption != null &&
                                  post.caption!.isNotEmpty)
                                FadeTransition(
                                  opacity: _captionFade,
                                  child: InteractivePostCaption(
                                    data: post.caption!,
                                    maxCollapsedLength: 140,
                                    mentions: post.mentions,
                                    baseStyle: theme.textTheme.bodyMedium
                                        ?.copyWith(
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
                                    toggleStyle: theme.textTheme.bodyMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                    readMoreText: t.stories.readMore,
                                    readLessText: t.stories.readLess,
                                    onHashtagTap: widget.onHashtagTap,
                                    onMentionTap:
                                        widget.onMentionTap ??
                                        (uid) => ProfileRoute(userId: uid)
                                            .push(context),
                                  ),
                                ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Caption toggle button (top-left, only when controls visible)
              if (_showVideoControls)
                Positioned(
                  top: 100.h,
                  left: 16.w,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _toggleCaption,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isCaptionVisible
                                  ? Icons.text_fields_rounded
                                  : Icons.text_fields_outlined,
                              size: 18,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _isCaptionVisible
                                  ? 'Hide caption'
                                  : t.feed.tapToShowCaption,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              // Vertical engagement bar (always visible)
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
