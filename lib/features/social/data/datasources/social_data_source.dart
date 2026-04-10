
import 'package:myitihas/features/social/domain/entities/share.dart';
import '../models/comment_model.dart';
import '../models/like_model.dart';
import '../models/share_model.dart';

abstract class SocialDataSource {
  Future<void> likeStory(String userId, String storyId);
  Future<void> unlikeStory(String userId, String storyId);
  Future<bool> isStoryLiked(String userId, String storyId);
  Future<int> getStoryLikeCount(String storyId);
  Future<List<LikeModel>> getStoryLikes(String storyId);

  Future<CommentModel> addComment({
    required String storyId,
    required String userId,
    required String text,
    String? parentCommentId,
  });
  Future<void> deleteComment(String commentId);
  Future<void> likeComment(String userId, String commentId);
  Future<void> unlikeComment(String userId, String commentId);
  Future<void> toggleCommentCollapse(String commentId);
  Future<List<CommentModel>> getComments(String storyId);

  Future<void> shareStory({
    required String userId,
    required String storyId,
    required ShareType shareType,
    String? recipientId,
  });
  Future<int> getStoryShareCount(String storyId);
  Future<List<ShareModel>> getStoryShares(String storyId);
}
