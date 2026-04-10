import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myitihas/features/social/domain/entities/post_mention.dart';
import 'package:myitihas/features/social/domain/entities/user.dart';

part 'image_post.freezed.dart';

@freezed
abstract class ImagePost with _$ImagePost {
  const factory ImagePost({
    required String id,
    required String imageUrl,
    /// All image URLs for this post (multi-photo). When empty, [imageUrl] is the single image.
    @Default([]) List<String> mediaUrls,
    String? caption,
    String? title,
    String? location,
    @Default(1.0) double aspectRatio,
    DateTime? createdAt,
    DateTime? scheduledAt,
    DateTime? publishedAt,
    String? status,
    String? authorId,
    User? authorUser,
    @Default(0) int likes,
    @Default(0) int commentCount,
    @Default(0) int shareCount,
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
  }) = _ImagePost;

  const ImagePost._();

  /// Effective list of image URLs: [mediaUrls] if non-empty, otherwise [imageUrl].
  List<String> get displayUrls =>
      mediaUrls.isNotEmpty ? mediaUrls : (imageUrl.isNotEmpty ? [imageUrl] : []);
}
