import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:myitihas/features/social/data/models/user.model.dart';
import 'package:myitihas/features/social/domain/entities/post_mention.dart';
import 'package:myitihas/features/social/domain/entities/post_poll.dart';
import 'package:myitihas/features/social/domain/entities/text_post.dart';

Map<String, dynamic>? _asStringDynamicMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return value.cast<String, dynamic>();
  return null;
}

int _pollToInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return 0;
}

/// Parses [metadata.poll] the same way as [PostRepositoryImpl._extractPostPoll].
PostPoll? _postPollFromMetadata(Map<String, dynamic>? metadata) {
  if (metadata == null) return null;
  final pollData = _asStringDynamicMap(metadata['poll']);
  if (pollData == null) return null;

  final rawOptions = pollData['options'];
  if (rawOptions is! List) return null;

  final options = rawOptions
      .map((option) => option.toString().trim())
      .where((option) => option.isNotEmpty)
      .toList();

  if (options.length < 2 || options.length > 4) {
    return null;
  }

  final countsRaw = pollData['counts'];
  final counts = <int>[];
  if (countsRaw is List) {
    for (final value in countsRaw.take(4)) {
      counts.add(_pollToInt(value));
    }
  }
  while (counts.length < 4) {
    counts.add(0);
  }

  final totalVotes = _pollToInt(pollData['total_votes']);
  final myOptionRaw = pollData['my_option'];
  final myOption = myOptionRaw is int
      ? myOptionRaw
      : myOptionRaw is num
      ? myOptionRaw.toInt()
      : null;

  return PostPoll(
    options: options,
    voteCounts: counts,
    totalVotes: totalVotes,
    mySelectedIndex: myOption,
  );
}

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'posts'),
  sqliteConfig: SqliteSerializable(),
)
class TextPostModel extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  final String id;

  @Supabase(name: 'post_type')
  @Sqlite()
  final String postType;

  @Supabase(name: 'content')
  final String body;

  @Supabase(name: 'thumbnail_url')
  final String? imageUrl;

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

  @Supabase(name: 'metadata')
  final Map<String, dynamic>? metadata;

  TextPostModel({
    required this.id,
    this.postType = 'text',
    required this.body,
    this.imageUrl,
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

  factory TextPostModel.fromDomain(TextPost entity) {
    return TextPostModel(
      id: entity.id,
      postType: 'text',
      body: entity.body,
      imageUrl: entity.imageUrl,
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
        'background_color': entity.backgroundColor,
        'text_color': entity.textColor,
        'font_size': entity.fontSize,
        if (entity.fontFamily != null) 'font_family': entity.fontFamily,
        if (entity.tags.isNotEmpty) 'tags': entity.tags,
        if (entity.mentions.isNotEmpty)
          'mentions': entity.mentions
              .map((m) => {'username': m.username, 'user_id': m.userId})
              .toList(),
        if (entity.poll != null)
          'poll': {
            'options': entity.poll!.options,
            'counts': entity.poll!.voteCounts,
            'total_votes': entity.poll!.totalVotes,
            if (entity.poll!.mySelectedIndex != null)
              'my_option': entity.poll!.mySelectedIndex,
          },
      },
    );
  }

  TextPost toDomain() {
    // Extract styling and tags from metadata
    int backgroundColor = 0xFF1E3A5F;
    int textColor = 0xFFFFFFFF;
    double fontSize = 18.0;
    String? fontFamily;
    List<String> tags = [];
    List<PostMention> mentions = [];

    if (metadata != null) {
      if (metadata!['background_color'] is int) {
        backgroundColor = metadata!['background_color'] as int;
      }
      if (metadata!['text_color'] is int) {
        textColor = metadata!['text_color'] as int;
      }
      if (metadata!['font_size'] is double) {
        fontSize = metadata!['font_size'] as double;
      } else if (metadata!['font_size'] is int) {
        fontSize = (metadata!['font_size'] as int).toDouble();
      }
      if (metadata!['font_family'] is String) {
        fontFamily = metadata!['font_family'] as String;
      }
      if (metadata!['tags'] is List) {
        tags = (metadata!['tags'] as List).cast<String>();
      }
      final rawMentions = metadata!['mentions'];
      if (rawMentions is List) {
        for (final e in rawMentions) {
          if (e is Map) {
            final u = e['username']?.toString();
            final id = e['user_id']?.toString();
            if (u != null && id != null && id.isNotEmpty) {
              mentions.add(PostMention(username: u, userId: id));
            }
          }
        }
      }
    }

    final poll = _postPollFromMetadata(metadata);

    return TextPost(
      id: id,
      body: body,
      imageUrl: imageUrl,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
      fontFamily: fontFamily,
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
      poll: poll,
    );
  }
}
