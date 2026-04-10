import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myitihas/features/social/domain/entities/post_mention.dart';
import 'package:myitihas/features/social/domain/entities/user.dart';

part 'video_post.freezed.dart';

@freezed
abstract class VideoPost with _$VideoPost {
  const factory VideoPost({
    required String id,
    required String videoUrl,
    String? thumbnailUrl,
    String? caption,
    String? title,
    String? location,
    @Default(9 / 16) double aspectRatio,
    @Default(0) int durationSeconds,
    DateTime? createdAt,
    DateTime? scheduledAt,
    DateTime? publishedAt,
    String? status,
    String? authorId,
    User? authorUser,
    @Default(0) int likes,
    @Default(0) int commentCount,
    @Default(0) int shareCount,
    @Default(0) int viewCount,
    @Default(false) bool isLikedByCurrentUser,
    @Default(false) bool isFavorite,
    @Default([]) List<String> tags,
    @Default([]) List<PostMention> mentions,
    String? repostedPostId,
    String? repostedPostType,
    String? repostedMediaUrl,
    String? repostedThumbnailUrl,
    String? repostedCaption,
    String? repostedAuthorId,
    String? repostedAuthorName,
    String? repostedAuthorUsername,
    String? repostedAuthorAvatarUrl,
  }) = _VideoPost;

  const VideoPost._();

  /// Effective aspect ratio to use when laying out the video player.
  ///
  /// This is primarily populated from backend metadata (or falls back to the
  /// intrinsic video aspect ratio when available in the UI layer).
  double get displayAspectRatio => aspectRatio <= 0 ? (9 / 16) : aspectRatio;
}
