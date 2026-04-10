import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_event.freezed.dart';

@freezed
sealed class CommentEvent with _$CommentEvent {
  const factory CommentEvent.loadComments(String storyId) = LoadCommentsEvent;
  const factory CommentEvent.addComment({
    required String storyId,
    required String text,
    String? parentCommentId,
  }) = AddCommentEvent;
  const factory CommentEvent.toggleLike({
    required String storyId,
    required String commentId,
  }) = ToggleCommentLikeEvent;
  const factory CommentEvent.toggleCollapse(String commentId) =
      ToggleCollapseEvent;
  const factory CommentEvent.deleteComment({
    required String storyId,
    required String commentId,
  }) = DeleteCommentEvent;
}
