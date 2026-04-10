import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment.freezed.dart';

@freezed
abstract class Comment with _$Comment {
  const factory Comment({
    required String id,
    required String contentId, // ID of the story/post being commented on
    @Default('story') String contentType, // 'story', 'post'
    required String userId,
    required String userName,
    required String userAvatar,
    required String text,
    required DateTime createdAt,
    @Default(0) int likeCount,
    String? parentCommentId, // null for top-level comments
    @Default([]) List<Comment> replies,
    @Default(0) int depth, // 0 for top-level, max 3
    @Default(false) bool isCollapsed,
    @Default(false) bool isLikedByCurrentUser,
  }) = _Comment;

  const Comment._();

  /// Backwards compatibility getter
  String get storyId => contentId;

  /// Backwards compatibility getter
  DateTime get timestamp => createdAt;
}
