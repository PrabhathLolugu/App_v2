import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:myitihas/features/social/domain/entities/post_mention.dart';
import 'package:myitihas/features/social/domain/entities/video_post.dart';
import 'package:myitihas/features/social/data/models/user.model.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'posts'),
  sqliteConfig: SqliteSerializable(),
)
class VideoPostModel extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  final String id;

  @Supabase(name: 'post_type')
  @Sqlite()
  final String postType;

  /// Videos stored in media_urls array
  @Supabase(name: 'media_urls')
  final List<String> mediaUrls;

  @Supabase(name: 'thumbnail_url')
  final String? thumbnailUrl;

  /// Caption stored in content column
  @Supabase(name: 'content')
  final String? content;

  @Supabase(name: 'video_duration_seconds')
  final int? videoDurationSeconds;

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

  @Supabase(name: 'view_count')
  final int viewCount;

  @Supabase(ignore: true)
  @Sqlite(ignore: true)
  final bool isLikedByCurrentUser;

  @Supabase(ignore: true)
  @Sqlite(ignore: true)
  final bool isFavorite;

  /// Metadata JSONB stores aspect_ratio, location, tags
  @Supabase(name: 'metadata')
  final Map<String, dynamic>? metadata;

  VideoPostModel({
    required this.id,
    this.postType = 'video',
    this.mediaUrls = const <String>[],
    this.thumbnailUrl,
    this.content,
    this.videoDurationSeconds,
    this.createdAt,
    this.authorId,
    this.author,
    this.likes = 0,
    this.commentCount = 0,
    this.shareCount = 0,
    this.viewCount = 0,
    this.isLikedByCurrentUser = false,
    this.isFavorite = false,
    this.metadata,
  });

  factory VideoPostModel.fromDomain(VideoPost entity) {
    return VideoPostModel(
      id: entity.id,
      postType: 'video',
      mediaUrls: entity.videoUrl.isNotEmpty ? [entity.videoUrl] : const [],
      thumbnailUrl: entity.thumbnailUrl,
      content: entity.caption,
      videoDurationSeconds: entity.durationSeconds,
      createdAt: entity.createdAt,
      authorId: entity.authorId,
      author: entity.authorUser != null
          ? UserModel.fromDomain(entity.authorUser!)
          : null,
      likes: entity.likes,
      commentCount: entity.commentCount,
      shareCount: entity.shareCount,
      viewCount: entity.viewCount,
      isLikedByCurrentUser: entity.isLikedByCurrentUser,
      isFavorite: entity.isFavorite,
      metadata: {
        if (entity.location != null) 'location': entity.location,
        if (entity.aspectRatio != 0.5625) 'aspect_ratio': entity.aspectRatio,
        if (entity.tags.isNotEmpty) 'tags': entity.tags,
        if (entity.mentions.isNotEmpty)
          'mentions': entity.mentions
              .map((m) => {'username': m.username, 'user_id': m.userId})
              .toList(),
      },
    );
  }

  VideoPost toDomain() {
    // Extract video-specific metadata
    String? location;
    double aspectRatio = 0.5625; // Default 9:16 aspect ratio
    List<String> tags = [];
    List<PostMention> mentions = [];

    if (metadata != null) {
      if (metadata!['location'] is String) {
        location = metadata!['location'] as String;
      }
      if (metadata!['aspect_ratio'] is num) {
        aspectRatio = (metadata!['aspect_ratio'] as num).toDouble();
      }
      if (metadata!['tags'] is List) {
        tags = (metadata!['tags'] as List).cast<String>();
      }
      final rawMentions = metadata!['mentions'];
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
    }

    // Helper: get first video URL
    final videoUrl = mediaUrls.isNotEmpty ? mediaUrls.first : '';

    return VideoPost(
      id: id,
      videoUrl: videoUrl,
      thumbnailUrl: thumbnailUrl,
      caption: content,
      location: location,
      aspectRatio: aspectRatio,
      durationSeconds: videoDurationSeconds ?? 0,
      createdAt: createdAt,
      authorId: authorId,
      authorUser: author?.toDomain(),
      likes: likes,
      commentCount: commentCount,
      shareCount: shareCount,
      viewCount: viewCount,
      isLikedByCurrentUser: isLikedByCurrentUser,
      isFavorite: isFavorite,
      tags: tags,
      mentions: mentions,
    );
  }
}
