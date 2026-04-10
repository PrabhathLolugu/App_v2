import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myitihas/features/social/domain/entities/content_type.dart';
import 'package:myitihas/features/social/domain/entities/image_post.dart';
import 'package:myitihas/features/social/domain/entities/text_post.dart';
import 'package:myitihas/features/social/domain/entities/user.dart';
import 'package:myitihas/features/social/domain/entities/video_post.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';

part 'feed_item.freezed.dart';

@freezed
sealed class FeedItem with _$FeedItem {
  const factory FeedItem.story(Story story) = StoryFeedItem;
  const factory FeedItem.imagePost(ImagePost imagePost) = ImagePostFeedItem;
  const factory FeedItem.textPost(TextPost textPost) = TextPostFeedItem;
  const factory FeedItem.videoPost(VideoPost videoPost) = VideoPostFeedItem;

  const FeedItem._();
}

/// Extension to provide common accessors for all feed item types
extension FeedItemExtension on FeedItem {
  String get id => when(
    story: (story) => story.id,
    imagePost: (post) => post.id,
    textPost: (post) => post.id,
    videoPost: (post) => post.id,
  );

  ContentType get contentType => when(
    story: (_) => ContentType.story,
    imagePost: (_) => ContentType.imagePost,
    textPost: (_) => ContentType.textPost,
    videoPost: (_) => ContentType.videoPost,
  );

  User? get authorUser => when(
    story: (story) => story.authorUser,
    imagePost: (post) => post.authorUser,
    textPost: (post) => post.authorUser,
    videoPost: (post) => post.authorUser,
  );

  String? get authorId => when(
    story: (story) => story.authorId,
    imagePost: (post) => post.authorId,
    textPost: (post) => post.authorId,
    videoPost: (post) => post.authorId,
  );

  int get likes => when(
    story: (story) => story.likes,
    imagePost: (post) => post.likes,
    textPost: (post) => post.likes,
    videoPost: (post) => post.likes,
  );

  int get commentCount => when(
    story: (story) => story.commentCount,
    imagePost: (post) => post.commentCount,
    textPost: (post) => post.commentCount,
    videoPost: (post) => post.commentCount,
  );

  int get shareCount => when(
    story: (story) => story.shareCount,
    imagePost: (post) => post.shareCount,
    textPost: (post) => post.shareCount,
    videoPost: (post) => post.shareCount,
  );

  bool get isLikedByCurrentUser => when(
    story: (story) => story.isLikedByCurrentUser,
    imagePost: (post) => post.isLikedByCurrentUser,
    textPost: (post) => post.isLikedByCurrentUser,
    videoPost: (post) => post.isLikedByCurrentUser,
  );

  bool get isFavorite => when(
    story: (story) => story.isFavorite,
    imagePost: (post) => post.isFavorite,
    textPost: (post) => post.isFavorite,
    videoPost: (post) => post.isFavorite,
  );

  DateTime? get createdAt => when(
    story: (story) => story.publishedAt,
    imagePost: (post) => post.createdAt,
    textPost: (post) => post.createdAt,
    videoPost: (post) => post.createdAt,
  );

  String? get title => when(
    story: (story) => story.title,
    imagePost: (post) => post.title,
    textPost: (post) => post.title,
    videoPost: (post) => post.title,
  );

  String? get repostedPostId => when(
    story: (_) => null,
    imagePost: (post) => post.repostedPostId,
    textPost: (post) => post.repostedPostId,
    videoPost: (post) => post.repostedPostId,
  );

  /// Scheduled time (UTC) when this post will go live. Null if not scheduled.
  DateTime? get scheduledAt => when(
    story: (_) => null,
    imagePost: (post) => post.scheduledAt,
    textPost: (post) => post.scheduledAt,
    videoPost: (post) => post.scheduledAt,
  );

  /// Post status: 'scheduled', 'published', etc. Null for stories.
  String? get status => when(
    story: (_) => null,
    imagePost: (post) => post.status,
    textPost: (post) => post.status,
    videoPost: (post) => post.status,
  );

  FeedItem toggleLike() => when(
    story: (story) => FeedItem.story(
      story.copyWith(
        isLikedByCurrentUser: !story.isLikedByCurrentUser,
        likes: story.isLikedByCurrentUser ? story.likes - 1 : story.likes + 1,
      ),
    ),
    imagePost: (post) => FeedItem.imagePost(
      post.copyWith(
        isLikedByCurrentUser: !post.isLikedByCurrentUser,
        likes: post.isLikedByCurrentUser ? post.likes - 1 : post.likes + 1,
      ),
    ),
    textPost: (post) => FeedItem.textPost(
      post.copyWith(
        isLikedByCurrentUser: !post.isLikedByCurrentUser,
        likes: post.isLikedByCurrentUser ? post.likes - 1 : post.likes + 1,
      ),
    ),
    videoPost: (post) => FeedItem.videoPost(
      post.copyWith(
        isLikedByCurrentUser: !post.isLikedByCurrentUser,
        likes: post.isLikedByCurrentUser ? post.likes - 1 : post.likes + 1,
      ),
    ),
  );

  FeedItem toggleBookmark() => when(
    story: (story) =>
        FeedItem.story(story.copyWith(isFavorite: !story.isFavorite)),
    imagePost: (post) =>
        FeedItem.imagePost(post.copyWith(isFavorite: !post.isFavorite)),
    textPost: (post) =>
        FeedItem.textPost(post.copyWith(isFavorite: !post.isFavorite)),
    videoPost: (post) =>
        FeedItem.videoPost(post.copyWith(isFavorite: !post.isFavorite)),
  );

  FeedItem incrementShareCount() => when(
    story: (story) =>
        FeedItem.story(story.copyWith(shareCount: story.shareCount + 1)),
    imagePost: (post) =>
        FeedItem.imagePost(post.copyWith(shareCount: post.shareCount + 1)),
    textPost: (post) =>
        FeedItem.textPost(post.copyWith(shareCount: post.shareCount + 1)),
    videoPost: (post) =>
        FeedItem.videoPost(post.copyWith(shareCount: post.shareCount + 1)),
  );

  FeedItem incrementCommentCount() => when(
    story: (story) =>
        FeedItem.story(story.copyWith(commentCount: story.commentCount + 1)),
    imagePost: (post) =>
        FeedItem.imagePost(post.copyWith(commentCount: post.commentCount + 1)),
    textPost: (post) =>
        FeedItem.textPost(post.copyWith(commentCount: post.commentCount + 1)),
    videoPost: (post) =>
        FeedItem.videoPost(post.copyWith(commentCount: post.commentCount + 1)),
  );

  FeedItem decrementCommentCount() => when(
    story: (story) => FeedItem.story(
        story.copyWith(commentCount: (story.commentCount - 1).clamp(0, 999999))),
    imagePost: (post) => FeedItem.imagePost(
        post.copyWith(commentCount: (post.commentCount - 1).clamp(0, 999999))),
    textPost: (post) => FeedItem.textPost(
        post.copyWith(commentCount: (post.commentCount - 1).clamp(0, 999999))),
    videoPost: (post) => FeedItem.videoPost(
        post.copyWith(commentCount: (post.commentCount - 1).clamp(0, 999999))),
  );

  FeedItem setCommentCount(int count) => when(
    story: (story) => FeedItem.story(story.copyWith(commentCount: count)),
    imagePost: (post) => FeedItem.imagePost(post.copyWith(commentCount: count)),
    textPost: (post) => FeedItem.textPost(post.copyWith(commentCount: count)),
    videoPost: (post) => FeedItem.videoPost(post.copyWith(commentCount: count)),
  );

  FeedItem incrementLikeCount() => when(
    story: (story) =>
        FeedItem.story(story.copyWith(likes: story.likes + 1)),
    imagePost: (post) =>
        FeedItem.imagePost(post.copyWith(likes: post.likes + 1)),
    textPost: (post) =>
        FeedItem.textPost(post.copyWith(likes: post.likes + 1)),
    videoPost: (post) =>
        FeedItem.videoPost(post.copyWith(likes: post.likes + 1)),
  );

  FeedItem decrementLikeCount() => when(
    story: (story) =>
        FeedItem.story(story.copyWith(likes: (story.likes - 1).clamp(0, 999999))),
    imagePost: (post) =>
        FeedItem.imagePost(post.copyWith(likes: (post.likes - 1).clamp(0, 999999))),
    textPost: (post) =>
        FeedItem.textPost(post.copyWith(likes: (post.likes - 1).clamp(0, 999999))),
    videoPost: (post) =>
        FeedItem.videoPost(post.copyWith(likes: (post.likes - 1).clamp(0, 999999))),
  );
}
