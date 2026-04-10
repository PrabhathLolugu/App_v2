import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myitihas/features/social/domain/entities/comment.dart';

part 'comment_model.freezed.dart';
part 'comment_model.g.dart';

@freezed
abstract class CommentModel with _$CommentModel {
  const CommentModel._();

  const factory CommentModel({
    required String id,
    required String contentId, // ID of the story/post being commented on
    @Default('story') String contentType, // 'story' or 'post'
    required String userId,
    required String userName,
    required String userAvatar,
    required String text,
    required DateTime createdAt,
    @Default(0) int likeCount,
    String? parentCommentId,
    @Default([]) List<CommentModel> replies,
    @Default(0) int depth,
    @Default(false) bool isCollapsed,
    @Default(false) bool isLikedByCurrentUser,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Comment toEntity() {
    return Comment(
      id: id,
      contentId: contentId,
      contentType: contentType,
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      text: text,
      createdAt: createdAt,
      likeCount: likeCount,
      parentCommentId: parentCommentId,
      replies: replies.map((r) => r.toEntity()).toList(),
      depth: depth,
      isCollapsed: isCollapsed,
      isLikedByCurrentUser: isLikedByCurrentUser,
    );
  }

  factory CommentModel.fromEntity(Comment comment) {
    return CommentModel(
      id: comment.id,
      contentId: comment.contentId,
      contentType: comment.contentType,
      userId: comment.userId,
      userName: comment.userName,
      userAvatar: comment.userAvatar,
      text: comment.text,
      createdAt: comment.createdAt,
      likeCount: comment.likeCount,
      parentCommentId: comment.parentCommentId,
      replies: comment.replies.map((r) => CommentModel.fromEntity(r)).toList(),
      depth: comment.depth,
      isCollapsed: comment.isCollapsed,
      isLikedByCurrentUser: comment.isLikedByCurrentUser,
    );
  }

}
