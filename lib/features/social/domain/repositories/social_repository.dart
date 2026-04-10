import 'package:fpdart/fpdart.dart';
import 'package:myitihas/core/errors/failures.dart';
import 'package:myitihas/features/social/domain/entities/content_type.dart';
import '../entities/comment.dart';
import '../entities/share.dart';

abstract class SocialRepository {
  Future<Either<Failure, void>> likeStory(String storyId);

  Future<Either<Failure, void>> unlikeStory(String storyId);

  Future<Either<Failure, bool>> isStoryLiked(String storyId);

  Future<Either<Failure, int>> getStoryLikeCount(String storyId);

  Future<Either<Failure, Comment>> addComment({
    required String storyId,
    required String text,
    String? parentCommentId,
  });

  /// Adds a comment to any content type (story, imagePost, textPost, videoPost).
  Future<Either<Failure, Comment>> addContentComment({
    required String contentId,
    required ContentType contentType,
    required String text,
    String? parentCommentId,
  });

  Future<Either<Failure, void>> deleteComment(String commentId);

  Future<Either<Failure, void>> likeComment(String commentId);

  Future<Either<Failure, void>> unlikeComment(String commentId);

  Future<Either<Failure, void>> toggleCommentCollapse(String commentId);

  Future<Either<Failure, List<Comment>>> getCommentsTree(String storyId);

  /// Gets comments for any content type (story, imagePost, textPost, videoPost).
  Future<Either<Failure, List<Comment>>> getContentComments({
    required String contentId,
    required ContentType contentType,
    int limit = 20,
    int offset = 0,
  });

  Future<Either<Failure, void>> shareStory({
    required String storyId,
    required ShareType shareType,
    String? recipientId,
  });

  /// Shares any content type (story, post).
  Future<Either<Failure, void>> shareContent({
    required String contentId,
    required ContentType contentType,
    required ShareType shareType,
    String? recipientId,
  });

  Future<Either<Failure, int>> getStoryShareCount(String storyId);

  /// Gets share count for any content type.
  Future<Either<Failure, int>> getContentShareCount({
    required String contentId,
    required ContentType contentType,
  });

  Future<Either<Failure, List<Share>>> getStoryShares(String storyId);
}
