import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myitihas/features/social/domain/entities/content_type.dart';
import 'package:myitihas/features/social/domain/entities/feed_item.dart';

part 'feed_event.freezed.dart';

/// Enum for filtering feed by content type
enum FeedType {
  stories,
  videos,
  posts;

  ContentType? get toContentType {
    switch (this) {
      case FeedType.stories:
        return ContentType.story;
      case FeedType.videos:
        return ContentType.videoPost;
      case FeedType.posts:
        return null; // Posts include both text and image posts
    }
  }
}

@freezed
sealed class FeedEvent with _$FeedEvent {
  const factory FeedEvent.loadFeed() = LoadFeedEvent;
  const factory FeedEvent.loadMore() = LoadMoreFeedEvent;
  const factory FeedEvent.refreshFeed() = RefreshFeedEvent;
  const factory FeedEvent.changeFeedType(FeedType feedType) =
      ChangeFeedTypeEvent;
  const factory FeedEvent.checkConnectivity() = CheckConnectivityEvent;
  const factory FeedEvent.realtimePostReceived(FeedItem post) = RealtimePostReceivedEvent;
  const factory FeedEvent.toggleLike({
    required String contentId,
    required ContentType contentType,
  }) = ToggleLikeEvent;
  const factory FeedEvent.toggleBookmark({
    required String contentId,
    required ContentType contentType,
  }) = ToggleBookmarkEvent;
  const factory FeedEvent.addComment({
    required String contentId,
    required ContentType contentType,
    required String text,
    String? parentCommentId,
  }) = AddCommentEvent;
  /// Notifies the feed that a comment was added (e.g. from CommentSheet) so the card count updates.
  const factory FeedEvent.commentCountIncremented({
    required String contentId,
    required ContentType contentType,
  }) = CommentCountIncrementedEvent;
  const factory FeedEvent.setCommentCount({
    required String contentId,
    required ContentType contentType,
    required int count,
  }) = SetCommentCountEvent;
  const factory FeedEvent.shareContent({
    required String contentId,
    required ContentType contentType,
    required bool isDirect,
    String? recipientId,
  }) = ShareContentEvent;
  const factory FeedEvent.repostPost({
    required String originalPostId,
    String? quoteCaption,
  }) = RepostPostEvent;
  const factory FeedEvent.followUser(String userId) = FollowUserEvent;
  const factory FeedEvent.unfollowUser(String userId) = UnfollowUserEvent;

  /// Filter posts/videos feed by normalized hashtag (no `#`, lowercase).
  const factory FeedEvent.setHashtagFilter(String normalizedTag) =
      SetHashtagFilterEvent;

  const factory FeedEvent.clearHashtagFilter() = ClearHashtagFilterEvent;
}
