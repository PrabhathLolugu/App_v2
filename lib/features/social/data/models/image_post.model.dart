import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:myitihas/features/social/domain/entities/image_post.dart';
import 'package:myitihas/features/social/domain/entities/post_mention.dart';
import 'package:myitihas/features/social/data/models/user.model.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'posts'),
  sqliteConfig: SqliteSerializable(),
)
class ImagePostModel extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  final String id;

  @Supabase(name: 'post_type')
  @Sqlite()
  final String postType;

  /// Images stored in media_urls array, first element is the main image
  @Supabase(name: 'media_urls')
  final List<String> mediaUrls;

  /// Caption stored in content column
  @Supabase(name: 'content')
  final String? content;

  @Supabase(name: 'created_at')
  final DateTime? createdAt;

  @Supabase(name: 'author_id')
  final String? authorId;

  @Supabase(foreignKey: 'author_id')
  final UserModel? author;

  @Supabase(name: 'like_count')
  final int likes;

  @Supabase(name: 'comment_count')
  final int commentCount;

  @Supabase(name: 'share_count')
  final int shareCount;

  @Supabase(ignore: true)
  @Sqlite(ignore: true)
  final bool isLikedByCurrentUser;

  @Supabase(ignore: true)
  @Sqlite(ignore: true)
  final bool isFavorite;

  /// Metadata JSONB stores location, aspect_ratio, tags
  @Supabase(name: 'metadata')
  final Map<String, dynamic>? metadata;

  ImagePostModel({
    required this.id,
    this.postType = 'image',
    this.mediaUrls = const <String>[],
    this.content,
    this.createdAt,
    this.authorId,
    this.author,
    this.likes = 0,
    this.commentCount = 0,
    this.shareCount = 0,
    this.isLikedByCurrentUser = false,
    this.isFavorite = false,
    this.metadata,
  });

  factory ImagePostModel.fromDomain(ImagePost entity) {
    return ImagePostModel(
      id: entity.id,
      postType: 'image',
      mediaUrls: entity.mediaUrls.isNotEmpty ? entity.mediaUrls : (entity.imageUrl.isNotEmpty ? [entity.imageUrl] : const []),
      content: entity.caption,
      createdAt: entity.createdAt,
      authorId: entity.authorId,
      author: entity.authorUser != null
          ? UserModel.fromDomain(entity.authorUser!)
          : null,
      likes: entity.likes,
      commentCount: entity.commentCount,
      shareCount: entity.shareCount,
      isLikedByCurrentUser: entity.isLikedByCurrentUser,
      isFavorite: entity.isFavorite,
      metadata: {
        if (entity.location != null) 'location': entity.location,
        if (entity.aspectRatio != 1.0) 'aspect_ratio': entity.aspectRatio,
        if (entity.tags.isNotEmpty) 'tags': entity.tags,
        if (entity.mentions.isNotEmpty)
          'mentions': entity.mentions
              .map((m) => {'username': m.username, 'user_id': m.userId})
              .toList(),
      },
    );
  }

  ImagePost toDomain() {
    // Extract fields from metadata
    final location = metadata?['location'] as String?;
    final aspectRatio = (metadata?['aspect_ratio'] as num?)?.toDouble() ?? 1.0;
    List<String> tags = [];
    List<PostMention> mentions = [];
    if (metadata != null && metadata!['tags'] is List) {
      tags = (metadata!['tags'] as List).cast<String>();
    }
    final rawMentions = metadata?['mentions'];
    if (rawMentions is List) {
      for (final e in rawMentions) {
        if (e is Map) {
          final u = e['username']?.toString();
          final mid = e['user_id']?.toString();
          if (u != null && mid != null && mid.isNotEmpty) {
            mentions.add(PostMention(username: u, userId: mid));
          }
        }
      }
    }

    // Helper: get first image URL
    final imageUrl = mediaUrls.isNotEmpty ? mediaUrls.first : '';

    return ImagePost(
      id: id,
      imageUrl: imageUrl,
      mediaUrls: mediaUrls,
      caption: content,
      location: location,
      aspectRatio: aspectRatio,
      createdAt: createdAt,
      authorId: authorId,
      authorUser: author?.toDomain(),
      likes: likes,
      commentCount: commentCount,
      shareCount: shareCount,
      isLikedByCurrentUser: isLikedByCurrentUser,
      isFavorite: isFavorite,
      tags: tags,
      mentions: mentions,
    );
  }
}
