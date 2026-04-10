// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<ImagePostModel> _$ImagePostModelFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return ImagePostModel(
    id: data['id'] as String,
    postType: data['post_type'] as String,
    mediaUrls: data['media_urls'].toList().cast<String>(),
    content: data['content'] == null ? null : data['content'] as String?,
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
    metadata: data['metadata'] == null ? null : data['metadata'],
  );
}

Future<Map<String, dynamic>> _$ImagePostModelToSupabase(
  ImagePostModel instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'post_type': instance.postType,
    'media_urls': instance.mediaUrls,
    'content': instance.content,
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
    'metadata': instance.metadata,
  };
}

Future<ImagePostModel> _$ImagePostModelFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return ImagePostModel(
    id: data['id'] as String,
    postType: data['post_type'] as String,
    mediaUrls: jsonDecode(data['media_urls']).toList().cast<String>(),
    content: data['content'] == null ? null : data['content'] as String?,
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
    metadata: data['metadata'] == null ? null : jsonDecode(data['metadata']),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$ImagePostModelToSqlite(
  ImagePostModel instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'post_type': instance.postType,
    'media_urls': jsonEncode(instance.mediaUrls),
    'content': instance.content,
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
    'metadata': instance.metadata != null
        ? jsonEncode(instance.metadata)
        : null,
  };
}

/// Construct a [ImagePostModel]
class ImagePostModelAdapter
    extends OfflineFirstWithSupabaseAdapter<ImagePostModel> {
  ImagePostModelAdapter();

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
    'content': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'content',
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
    'content': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'content',
      iterable: false,
      type: String,
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
    'metadata': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'metadata',
      iterable: false,
      type: Map,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    ImagePostModel instance,
    DatabaseExecutor executor,
  ) async => instance.primaryKey;
  @override
  final String tableName = 'ImagePostModel';

  @override
  Future<ImagePostModel> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ImagePostModelFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    ImagePostModel input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ImagePostModelToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<ImagePostModel> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ImagePostModelFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    ImagePostModel input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ImagePostModelToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
