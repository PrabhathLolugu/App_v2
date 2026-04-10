// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<VideoPostModel> _$VideoPostModelFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return VideoPostModel(
    id: data['id'] as String,
    postType: data['post_type'] as String,
    mediaUrls: data['media_urls'].toList().cast<String>(),
    thumbnailUrl: data['thumbnail_url'] == null
        ? null
        : data['thumbnail_url'] as String?,
    content: data['content'] == null ? null : data['content'] as String?,
    videoDurationSeconds: data['video_duration_seconds'] == null
        ? null
        : data['video_duration_seconds'] as int?,
    createdAt: data['created_at'] == null
        ? null
        : data['created_at'] == null
        ? null
        : DateTime.tryParse(data['created_at'] as String),
    authorId: data['author_id'] == null ? null : data['author_id'] as String?,
    author: data['author'] == null
        ? null
        : await UserModelAdapter().fromSupabase(
            data['author'],
            provider: provider,
            repository: repository,
          ),
    likes: data['like_count'] as int,
    commentCount: data['comment_count'] as int,
    shareCount: data['share_count'] as int,
    viewCount: data['view_count'] as int,
    metadata: data['metadata'] == null ? null : data['metadata'],
  );
}

Future<Map<String, dynamic>> _$VideoPostModelToSupabase(
  VideoPostModel instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'post_type': instance.postType,
    'media_urls': instance.mediaUrls,
    'thumbnail_url': instance.thumbnailUrl,
    'content': instance.content,
    'video_duration_seconds': instance.videoDurationSeconds,
    'created_at': instance.createdAt?.toIso8601String(),
    'author_id': instance.authorId,
    'author': instance.author != null
        ? await UserModelAdapter().toSupabase(
            instance.author!,
            provider: provider,
            repository: repository,
          )
        : null,
    'like_count': instance.likes,
    'comment_count': instance.commentCount,
    'share_count': instance.shareCount,
    'view_count': instance.viewCount,
    'metadata': instance.metadata,
  };
}

Future<VideoPostModel> _$VideoPostModelFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return VideoPostModel(
    id: data['id'] as String,
    postType: data['post_type'] as String,
    mediaUrls: jsonDecode(data['media_urls']).toList().cast<String>(),
    thumbnailUrl: data['thumbnail_url'] == null
        ? null
        : data['thumbnail_url'] as String?,
    content: data['content'] == null ? null : data['content'] as String?,
    videoDurationSeconds: data['video_duration_seconds'] == null
        ? null
        : data['video_duration_seconds'] as int?,
    createdAt: data['created_at'] == null
        ? null
        : data['created_at'] == null
        ? null
        : DateTime.tryParse(data['created_at'] as String),
    authorId: data['author_id'] == null ? null : data['author_id'] as String?,
    author: data['author_UserModel_brick_id'] == null
        ? null
        : (data['author_UserModel_brick_id'] > -1
              ? (await repository?.getAssociation<UserModel>(
                  Query.where(
                    'primaryKey',
                    data['author_UserModel_brick_id'] as int,
                    limit1: true,
                  ),
                ))?.first
              : null),
    likes: data['likes'] as int,
    commentCount: data['comment_count'] as int,
    shareCount: data['share_count'] as int,
    viewCount: data['view_count'] as int,
    metadata: data['metadata'] == null ? null : jsonDecode(data['metadata']),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$VideoPostModelToSqlite(
  VideoPostModel instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'post_type': instance.postType,
    'media_urls': jsonEncode(instance.mediaUrls),
    'thumbnail_url': instance.thumbnailUrl,
    'content': instance.content,
    'video_duration_seconds': instance.videoDurationSeconds,
    'created_at': instance.createdAt?.toIso8601String(),
    'author_id': instance.authorId,
    'author_UserModel_brick_id': instance.author != null
        ? instance.author!.primaryKey ??
              await provider.upsert<UserModel>(
                instance.author!,
                repository: repository,
              )
        : null,
    'likes': instance.likes,
    'comment_count': instance.commentCount,
    'share_count': instance.shareCount,
    'view_count': instance.viewCount,
    'metadata': instance.metadata != null
        ? jsonEncode(instance.metadata)
        : null,
  };
}

/// Construct a [VideoPostModel]
class VideoPostModelAdapter
    extends OfflineFirstWithSupabaseAdapter<VideoPostModel> {
  VideoPostModelAdapter();

  @override
  final supabaseTableName = 'posts';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'postType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'post_type',
    ),
    'mediaUrls': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'media_urls',
    ),
    'thumbnailUrl': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'thumbnail_url',
    ),
    'content': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'content',
    ),
    'videoDurationSeconds': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'video_duration_seconds',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'authorId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'author_id',
    ),
    'author': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'author',
      associationType: UserModel,
      associationIsNullable: true,
      foreignKey: 'author_id',
    ),
    'likes': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'like_count',
    ),
    'commentCount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'comment_count',
    ),
    'shareCount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'share_count',
    ),
    'viewCount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'view_count',
    ),
    'metadata': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'metadata',
    ),
  };
  @override
  final ignoreDuplicates = false;
  @override
  final uniqueFields = {'id'};
  @override
  final Map<String, RuntimeSqliteColumnDefinition> fieldsToSqliteColumns = {
    'primaryKey': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: '_brick_id',
      iterable: false,
      type: int,
    ),
    'id': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'id',
      iterable: false,
      type: String,
    ),
    'postType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'post_type',
      iterable: false,
      type: String,
    ),
    'mediaUrls': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'media_urls',
      iterable: true,
      type: String,
    ),
    'thumbnailUrl': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'thumbnail_url',
      iterable: false,
      type: String,
    ),
    'content': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'content',
      iterable: false,
      type: String,
    ),
    'videoDurationSeconds': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'video_duration_seconds',
      iterable: false,
      type: int,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
    ),
    'authorId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'author_id',
      iterable: false,
      type: String,
    ),
    'author': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'author_UserModel_brick_id',
      iterable: false,
      type: UserModel,
    ),
    'likes': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'likes',
      iterable: false,
      type: int,
    ),
    'commentCount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'comment_count',
      iterable: false,
      type: int,
    ),
    'shareCount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'share_count',
      iterable: false,
      type: int,
    ),
    'viewCount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'view_count',
      iterable: false,
      type: int,
    ),
    'metadata': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'metadata',
      iterable: false,
      type: Map,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    VideoPostModel instance,
    DatabaseExecutor executor,
  ) async => instance.primaryKey;
  @override
  final String tableName = 'VideoPostModel';

  @override
  Future<VideoPostModel> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$VideoPostModelFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    VideoPostModel input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$VideoPostModelToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<VideoPostModel> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$VideoPostModelFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    VideoPostModel input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$VideoPostModelToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
