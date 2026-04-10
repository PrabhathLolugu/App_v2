import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/core/widgets/image_loading_placeholder/image_loading_placeholder.dart';
import 'package:myitihas/core/cache/managers/image_cache_manager.dart';
import 'package:myitihas/features/social/domain/entities/feed_item.dart';
import 'package:myitihas/features/social/presentation/widgets/interactive_post_caption.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/features/social/domain/entities/image_post.dart';
import 'package:myitihas/features/social/domain/entities/text_post.dart';
import 'package:myitihas/features/social/presentation/widgets/author_info_bar.dart';
import 'package:myitihas/features/social/presentation/widgets/feed_interaction_overlay.dart';
import 'package:myitihas/features/social/presentation/widgets/multi_image_carousel.dart';
import 'package:myitihas/features/social/presentation/widgets/post_poll_block.dart';
import 'package:myitihas/features/social/presentation/widgets/post_media_aspect_frame.dart';
import 'package:myitihas/features/social/presentation/widgets/repost_source_toast.dart';
import 'package:myitihas/utils/constants.dart';

/// A compact card widget for displaying posts in a timeline-style feed.
/// Supports both ImagePost and TextPost entities.
class TimelinePostCard extends StatelessWidget {
  final FeedItem feedItem;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onBookmark;
  final VoidCallback? onProfileTap;
  final VoidCallback? onFollowTap;
  final VoidCallback? onMoreTap;
  final bool isFollowLoading;

  /// When false, hides the "View all N comments" link (e.g. when comments show inline).
  final bool showCommentPreviewLink;

  /// When false, omits the divider after the post body (e.g. before an inline thread).
  final bool showTrailingDivider;
  final void Function(String normalizedTagWithoutHash)? onHashtagTap;
  final void Function(String userId)? onMentionTap;

  const TimelinePostCard({
    super.key,
    required this.feedItem,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onBookmark,
    this.onProfileTap,
    this.onFollowTap,
    this.onMoreTap,
    this.isFollowLoading = false,
    this.showCommentPreviewLink = true,
    this.showTrailingDivider = true,
    this.onHashtagTap,
    this.onMentionTap,
  });

  @override
  Widget build(BuildContext context) {
    return feedItem.when(
      imagePost: (post) => _ImageTimelineCard(
        post: post,
        onLike: onLike,
        onComment: onComment,
        onShare: onShare,
        onBookmark: onBookmark,
        onProfileTap: onProfileTap,
        onFollowTap: onFollowTap,
        onMoreTap: onMoreTap,
        isFollowLoading: isFollowLoading,
        onHashtagTap: onHashtagTap,
        onMentionTap: onMentionTap,
      ),
      textPost: (post) => _TextTimelineCard(
        post: post,
        onLike: onLike,
        onComment: onComment,
        onShare: onShare,
        onBookmark: onBookmark,
        onProfileTap: onProfileTap,
        onFollowTap: onFollowTap,
        onMoreTap: onMoreTap,
        isFollowLoading: isFollowLoading,
        showCommentPreviewLink: showCommentPreviewLink,
        showTrailingDivider: showTrailingDivider,
        onHashtagTap: onHashtagTap,
        onMentionTap: onMentionTap,
      ),
      story: (_) => const SizedBox.shrink(),
      videoPost: (_) => const SizedBox.shrink(),
    );
  }
}

class _ImageTimelineCard extends StatelessWidget {
  final ImagePost post;
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

  const _ImageTimelineCard({
    required this.post,
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? DarkColors.textPrimary : LightColors.textPrimary;

    final colorScheme = theme.colorScheme;
    final urls = post.displayUrls;
    final firstUrl = urls.isNotEmpty ? urls.first : '';
    final lowerUrl = firstUrl.toLowerCase();
    final isVideoUrl =
        lowerUrl.endsWith('.mp4') ||
        lowerUrl.endsWith('.mov') ||
        lowerUrl.endsWith('.webm') ||
        lowerUrl.endsWith('.avi') ||
        lowerUrl.contains('.mp4?') ||
        lowerUrl.contains('.mov?') ||
        lowerUrl.contains('.webm?');
    final hasValidImage = firstUrl.isNotEmpty && !isVideoUrl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Author info bar
        if (post.authorUser != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: AuthorInfoBar(
              author: post.authorUser!,
              createdAt: post.createdAt,
              postTitle: post.title,
              onProfileTap: onProfileTap,
              onFollowTap: onFollowTap,
              onMoreTap: onMoreTap,
              isFollowLoading: isFollowLoading,
              compact: true,
              darkOverlay: false,
            ),
          ),

        if (post.repostedPostId != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
            child: Align(
              alignment: Alignment.centerRight,
              child: RepostSourceToast(
                authorName: post.repostedAuthorName,
                authorUsername: post.repostedAuthorUsername,
                darkOverlay: false,
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
          ),

        // Image(s) with constrained height
        if (hasValidImage)
          Padding(
            padding: EdgeInsets.only(top: post.repostedPostId != null ? 8 : 12),
            child: FeedInteractionOverlay(
              isLikedByCurrentUser: post.isLikedByCurrentUser,
              onLike: onLike,
              child: PostMediaAspectFrame(
                aspectRatio: post.aspectRatio,
                borderRadius: BorderRadius.circular(14),
                backgroundColor: colorScheme.surfaceContainerHighest,
                child: urls.length == 1
                    ? CachedNetworkImage(
                        imageUrl: urls.first,
                        cacheManager: ImageCacheManager.instance,
                        memCacheWidth: (MediaQuery.of(context).size.width *
                                MediaQuery.of(context).devicePixelRatio)
                            .round()
                            .clamp(800, 2400),
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const ImageLoadingPlaceholder(
                              height: 400,
                              width: double.infinity,
                            ),
                        errorWidget: (context, url, error) => Container(
                          color: colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: colorScheme.onSurfaceVariant,
                            size: 48,
                          ),
                        ),
                      )
                    : MultiImageCarousel(
                        urls: urls,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => const ImageLoadingPlaceholder(
                          height: 400,
                          width: double.infinity,
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: colorScheme.onSurfaceVariant,
                            size: 48,
                          ),
                        ),
                      ),
              ),
            ),
          ),

        // 3. Action Bar
        Padding(
          padding: const EdgeInsets.only(left: 4, right: 4, top: 2, bottom: 0),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  post.isLikedByCurrentUser
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: post.isLikedByCurrentUser ? Colors.red : textColor,
                  size: 26,
                ),
                onPressed: onLike,
              ),
              IconButton(
                icon: Icon(
                  Icons.chat_bubble_outline,
                  color: textColor,
                  size: 24,
                ),
                onPressed: onComment,
              ),
              IconButton(
                icon: Icon(Icons.send_outlined, color: textColor, size: 24),
                onPressed: onShare,
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  post.isFavorite ? Icons.bookmark : Icons.bookmark_border,
                  color: textColor,
                  size: 24,
                ),
                onPressed: onBookmark,
              ),
            ],
          ),
        ),
        //  Padding(
        //     padding: const EdgeInsets.all(12),
        //     child: EngagementBar(
        //       likeCount: post.likes,
        //       commentCount: post.commentCount,
        //       shareCount: post.shareCount,
        //       isLiked: post.isLikedByCurrentUser,
        //       isBookmarked: post.isFavorite,
        //       onLike: onLike,
        //       onComment: onComment,
        //       onShare: onShare,
        //       onBookmark: onBookmark,
        //       vertical: false,
        //     ),
        //   ),

        // Caption
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${post.likes} likes',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              if (post.caption != null && post.caption!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorUser?.displayName ?? '',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    InteractivePostCaption(
                      data: post.caption!,
                      maxCollapsedLength: 120,
                      mentions: post.mentions,
                      baseStyle: theme.textTheme.bodyMedium!.copyWith(
                        color: textColor,
                        height: 1.4,
                      ),
                      hashtagStyle: theme.textTheme.bodyMedium!.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                      mentionStyle: theme.textTheme.bodyMedium!.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                      toggleStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      readMoreText: t.stories.readMore,
                      readLessText: t.stories.readLess,
                      onHashtagTap: onHashtagTap,
                      onMentionTap:
                          onMentionTap ??
                          (uid) => ProfileRoute(userId: uid).push(context),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 6),
              GestureDetector(
                onTap: onComment,
                child: Text(
                  'View all ${post.commentCount} comments',
                  style: TextStyle(
                    color: textColor.withOpacity(0.5),
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Location
        if (post.location != null && post.location!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    post.location!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        const Divider(),
      ],
    );
  }
}

class _TextTimelineCard extends StatelessWidget {
  final TextPost post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onBookmark;
  final VoidCallback? onProfileTap;
  final VoidCallback? onFollowTap;
  final VoidCallback? onMoreTap;
  final bool isFollowLoading;
  final bool showCommentPreviewLink;
  final bool showTrailingDivider;
  final void Function(String normalizedTagWithoutHash)? onHashtagTap;
  final void Function(String userId)? onMentionTap;

  const _TextTimelineCard({
    required this.post,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onBookmark,
    this.onProfileTap,
    this.onFollowTap,
    this.onMoreTap,
    this.isFollowLoading = false,
    this.showCommentPreviewLink = true,
    this.showTrailingDivider = true,
    this.onHashtagTap,
    this.onMentionTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);
    final colorScheme = theme.colorScheme;
    final textColor = colorScheme.onSurface;
    // Check for valid image URL (not a video file)
    final imageUrl = post.imageUrl;
    final lowerUrl = imageUrl?.toLowerCase() ?? '';
    final isVideoUrl =
        imageUrl != null &&
        (lowerUrl.endsWith('.mp4') ||
            lowerUrl.endsWith('.mov') ||
            lowerUrl.endsWith('.webm') ||
            lowerUrl.endsWith('.avi') ||
            lowerUrl.contains('.mp4?') ||
            lowerUrl.contains('.mov?') ||
            lowerUrl.contains('.webm?'));
    final hasImage = imageUrl != null && imageUrl.isNotEmpty && !isVideoUrl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Author info bar
        if (post.authorUser != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: AuthorInfoBar(
              author: post.authorUser!,
              createdAt: post.createdAt,
              postTitle: post.title,
              onProfileTap: onProfileTap,
              onFollowTap: onFollowTap,
              onMoreTap: onMoreTap,
              isFollowLoading: isFollowLoading,
              compact: true,
              darkOverlay: false,
            ),
          ),

        if (post.repostedPostId != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
            child: Align(
              alignment: Alignment.centerRight,
              child: RepostSourceToast(
                authorName: post.repostedAuthorName,
                authorUsername: post.repostedAuthorUsername,
                darkOverlay: false,
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
          ),

        // Image background if present
        if (hasImage)
          Padding(
            padding: EdgeInsets.only(top: post.repostedPostId != null ? 8 : 12),
            child: SizedBox(
              height: 400,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: post.imageUrl!,
                cacheManager: ImageCacheManager.instance,
                memCacheWidth: 800,
                fit: BoxFit.cover,
                placeholder: (context, url) => const ImageLoadingPlaceholder(
                  height: 400,
                  width: double.infinity,
                ),
                errorWidget: (context, url, error) => Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: colorScheme.onSurfaceVariant,
                    size: 48,
                  ),
                ),
              ),
            ),
          ),

        // Text content
        FeedInteractionOverlay(
          isLikedByCurrentUser: post.isLikedByCurrentUser,
          onLike: onLike,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              14,
              hasImage ? 12 : (post.repostedPostId != null ? 8 : 12),
              12,
              0,
            ),
            child: InteractivePostCaption(
              data: post.body,
              maxCollapsedLength: 160,
              mentions: post.mentions,
              baseStyle: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                height: 1.5,
              ),
              hashtagStyle: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
              mentionStyle: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
              toggleStyle: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
              readMoreText: t.stories.readMore,
              readLessText: t.stories.readLess,
              onHashtagTap: onHashtagTap,
              onMentionTap:
                  onMentionTap ??
                  (uid) => ProfileRoute(userId: uid).push(context),
            ),
          ),
        ),

        if (post.poll != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 0),
            child: PostPollBlock(
              postId: post.id,
              poll: post.poll!,
              darkOverlay: false,
            ),
          ),
        // 3. Action Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  post.isLikedByCurrentUser
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: post.isLikedByCurrentUser ? Colors.red : textColor,
                  size: 26,
                ),
                onPressed: onLike,
              ),
              IconButton(
                icon: Icon(
                  Icons.chat_bubble_outline,
                  color: textColor,
                  size: 24,
                ),
                onPressed: onComment,
              ),
              IconButton(
                icon: Icon(Icons.send_outlined, color: textColor, size: 24),
                onPressed: onShare,
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  post.isFavorite ? Icons.bookmark : Icons.bookmark_border,
                  color: textColor,
                  size: 24,
                ),
                onPressed: onBookmark,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${post.likes} likes',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              if (showCommentPreviewLink) ...[
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: onComment,
                  child: Text(
                    'View all ${post.commentCount} comments',
                    style: TextStyle(
                      color: textColor.withOpacity(0.5),
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (showTrailingDivider) const Divider(),
      ],
    );
  }
}
