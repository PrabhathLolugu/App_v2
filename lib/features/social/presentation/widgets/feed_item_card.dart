import 'package:flutter/material.dart';
import 'package:myitihas/features/social/domain/entities/content_type.dart';
import 'package:myitihas/features/social/domain/entities/feed_item.dart';
import 'package:myitihas/features/social/presentation/widgets/enhanced_story_card.dart';
import 'package:myitihas/features/social/presentation/widgets/feed_interaction_overlay.dart';
import 'package:myitihas/features/social/presentation/widgets/image_post_card.dart';
import 'package:myitihas/features/social/presentation/widgets/text_post_card.dart';
import 'package:myitihas/features/social/presentation/widgets/video_post_card.dart';

class FeedItemCard extends StatelessWidget {
  final FeedItem feedItem;
  final bool isVisible;
  final BoxFit imageMediaFit;
  final bool videoStartMuted;
  final bool videoShowPersistentMuteBadge;
  final void Function(String contentId, ContentType contentType)? onLike;
  final void Function(String contentId, ContentType contentType)? onComment;
  final void Function(String contentId, ContentType contentType)? onShare;
  final void Function(String contentId, ContentType contentType)? onBookmark;
  final VoidCallback? onProfileTap;
  final VoidCallback? onFollowTap;
  final VoidCallback? onMoreTap;
  final VoidCallback? onContinueReading;
  final bool isFollowLoading;
  final void Function(String normalizedTagWithoutHash)? onHashtagTap;
  final void Function(String userId)? onMentionTap;

  const FeedItemCard({
    super.key,
    required this.feedItem,
    this.isVisible = true,
    this.imageMediaFit = BoxFit.cover,
    this.videoStartMuted = false,
    this.videoShowPersistentMuteBadge = false,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onBookmark,
    this.onProfileTap,
    this.onFollowTap,
    this.onMoreTap,
    this.onContinueReading,
    this.isFollowLoading = false,
    this.onHashtagTap,
    this.onMentionTap,
  });

  @override
  Widget build(BuildContext context) {
    return feedItem.when(
      story: (story) {
        return FeedInteractionOverlay(
          isLikedByCurrentUser: story.isLikedByCurrentUser,
          onLike: onLike != null
              ? () => onLike!(story.id, ContentType.story)
              : null,
          child: EnhancedStoryCard(
            story: story,
            isVisible: isVisible,
            onLike: onLike != null
                ? () => onLike!(story.id, ContentType.story)
                : null,
            onComment: onComment != null
                ? () => onComment!(story.id, ContentType.story)
                : null,
            onShare: onShare != null
                ? () => onShare!(story.id, ContentType.story)
                : null,
            onBookmark: onBookmark != null
                ? () => onBookmark!(story.id, ContentType.story)
                : null,
            onProfileTap: onProfileTap,
            onFollowTap: onFollowTap,
            onContinueReading: onContinueReading,
            isFollowLoading: isFollowLoading,
          ),
        );
      },
      imagePost: (post) => FeedInteractionOverlay(
        isLikedByCurrentUser: post.isLikedByCurrentUser,
        onLike: onLike != null
            ? () => onLike!(post.id, ContentType.imagePost)
            : null,
        child: ImagePostCard(
          post: post,
          isVisible: isVisible,
          mediaFit: imageMediaFit,
          onLike: onLike != null
              ? () => onLike!(post.id, ContentType.imagePost)
              : null,
          onComment: onComment != null
              ? () => onComment!(post.id, ContentType.imagePost)
              : null,
          onShare: onShare != null
              ? () => onShare!(post.id, ContentType.imagePost)
              : null,
          onBookmark: onBookmark != null
              ? () => onBookmark!(post.id, ContentType.imagePost)
              : null,
          onProfileTap: onProfileTap,
          onFollowTap: onFollowTap,
          onMoreTap: onMoreTap,
          isFollowLoading: isFollowLoading,
          onHashtagTap: onHashtagTap,
          onMentionTap: onMentionTap,
        ),
      ),
      textPost: (post) => FeedInteractionOverlay(
        isLikedByCurrentUser: post.isLikedByCurrentUser,
        onLike: onLike != null
            ? () => onLike!(post.id, ContentType.textPost)
            : null,
        child: TextPostCard(
          post: post,
          isVisible: isVisible,
          onLike: onLike != null
              ? () => onLike!(post.id, ContentType.textPost)
              : null,
          onComment: onComment != null
              ? () => onComment!(post.id, ContentType.textPost)
              : null,
          onShare: onShare != null
              ? () => onShare!(post.id, ContentType.textPost)
              : null,
          onBookmark: onBookmark != null
              ? () => onBookmark!(post.id, ContentType.textPost)
              : null,
          onProfileTap: onProfileTap,
          onFollowTap: onFollowTap,
          onMoreTap: onMoreTap,
          isFollowLoading: isFollowLoading,
          onHashtagTap: onHashtagTap,
          onMentionTap: onMentionTap,
        ),
      ),
      videoPost: (post) => VideoPostCard(
        post: post,
        isVisible: isVisible,
        startMuted: videoStartMuted,
        showPersistentMuteBadge: videoShowPersistentMuteBadge,
        onLike: onLike != null
            ? () => onLike!(post.id, ContentType.videoPost)
            : null,
        onComment: onComment != null
            ? () => onComment!(post.id, ContentType.videoPost)
            : null,
        onShare: onShare != null
            ? () => onShare!(post.id, ContentType.videoPost)
            : null,
        onBookmark: onBookmark != null
            ? () => onBookmark!(post.id, ContentType.videoPost)
            : null,
        onProfileTap: onProfileTap,
        onFollowTap: onFollowTap,
        onMoreTap: onMoreTap,
        isFollowLoading: isFollowLoading,
        onHashtagTap: onHashtagTap,
        onMentionTap: onMentionTap,
      ),
    );
  }
}
