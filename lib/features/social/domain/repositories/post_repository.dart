import 'package:fpdart/fpdart.dart';
import 'package:myitihas/core/errors/failures.dart';
import 'package:myitihas/features/social/domain/entities/content_type.dart';
import 'package:myitihas/features/social/domain/entities/feed_item.dart';
import 'package:myitihas/features/social/domain/entities/image_post.dart';
import 'package:myitihas/features/social/domain/entities/text_post.dart';
import 'package:myitihas/features/social/domain/entities/video_post.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';

abstract class PostRepository {
  Future<Either<Failure, List<ImagePost>>> getImagePosts({
    int limit = 10,
    int offset = 0,
  });

  Future<Either<Failure, List<TextPost>>> getTextPosts({
    int limit = 10,
    int offset = 0,
  });

  Future<Either<Failure, List<VideoPost>>> getVideoPosts({
    int limit = 10,
    int offset = 0,
    String? hashtagNormalized,
  });

  Future<Either<Failure, List<FeedItem>>> getPosts({
    int limit = 10,
    int offset = 0,
    /// Normalized hashtag without `#` (lowercase). Null = no filter.
    String? hashtagNormalized,
  });

  Future<Either<Failure, List<FeedItem>>> getAllFeedItems({
    int limit = 10,
    int offset = 0,
  });

  Future<Either<Failure, List<Story>>> getSharedStories({
    int limit = 10,
    int offset = 0,
  });

  Future<Either<Failure, void>> likeContent({
    required String contentId,
    required ContentType contentType,
  });

  Future<Either<Failure, void>> unlikeContent({
    required String contentId,
    required ContentType contentType,
  });

  Future<Either<Failure, bool>> isContentLiked({
    required String contentId,
    required ContentType contentType,
  });

  Future<Either<Failure, void>> updatePostContent({
    required String postId,
    required String content,
  });

  /// Update a post's schedule: publish now, cancel, or reschedule.
  Future<Either<Failure, void>> updatePostSchedule({
    required String postId,
    String? status,
    DateTime? scheduledAtUtc,
  });

  /// Scheduled posts for the current user (own profile).
  Future<Either<Failure, List<FeedItem>>> getScheduledPostsForCurrentUser({
    int limit = 20,
    int offset = 0,
  });

  Future<Either<Failure, int>> getUserPostCount(String userId);

  Future<Either<Failure, List<FeedItem>>> getUserPostsByType({
    required String userId,
    required String postType,
    int limit = 20,
    int offset = 0,
  });

  Future<Either<Failure, List<FeedItem>>> getSavedPosts({
    int limit = 20,
    int offset = 0,
  });

  Future<Either<Failure, void>> toggleBookmark({
    required String contentId,
    required ContentType contentType,
  });

  Future<Either<Failure, ImagePost>> getImagePostById(String id);

  Future<Either<Failure, TextPost>> getTextPostById(String id);

  Future<Either<Failure, VideoPost>> getVideoPostById(String id);

  Future<Either<Failure, void>> deletePost(String postId);

  Future<Either<Failure, void>> reportPost({
    required String postId,
    required String reason,
    String? details,
  });

  Future<Either<Failure, FeedItem>> repostPost({
    required String originalPostId,
    String? quoteCaption,
  });

  /// Enriches a FeedItem with complete user profile data for the author.
  /// Fetches real followerCount, followingCount, and isFollowing status.
  Future<Either<Failure, FeedItem>> enrichFeedItemWithUserData(FeedItem item);

  /// Enriches feed items with like/bookmark status for the current user.
  Future<List<FeedItem>> enrichFeedItemsWithSocialData(List<FeedItem> items);
}
