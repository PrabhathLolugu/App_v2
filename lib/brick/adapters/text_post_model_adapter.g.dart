// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<TextPostModel> _$TextPostModelFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return TextPostModel(
    id: data['id'] as String,
    postType: data['post_type'] as String,
    body: data['content'] as String,
    imageUrl: data['thumbnail_url'] == null
        ? null
        : data['thumbnail_url'] as String?,
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

Future<Map<String, dynamic>> _$TextPostModelToSupabase(
  TextPostModel instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'post_type': instance.postType,
    'content': instance.body,
    'thumbnail_url': instance.imageUrl,
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

Future<TextPostModel> _$TextPostModelFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return TextPostModel(
    id: data['id'] as String,
    postType: data['post_type'] as String,
    body: data['body'] as String,
    imageUrl: data['image_url'] == null ? null : data['image_url'] as String?,
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

Future<Map<String, dynamic>> _$TextPostModelToSqlite(
  TextPostModel instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'post_type': instance.postType,
    'body': instance.body,
    'image_url': instance.imageUrl,
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

/// Construct a [TextPostModel]
class TextPostModelAdapter
    extends OfflineFirstWithSupabaseAdapter<TextPostModel> {
  TextPostModelAdapter();

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
    'body': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'content',
    ),
    'imageUrl': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'thumbnail_url',
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
    'body': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'body',
      iterable: false,
      type: String,
    ),
    'imageUrl': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'image_url',
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
    TextPostModel instance,
    DatabaseExecutor executor,
  ) async => instance.primaryKey;
  @override
  final String tableName = 'TextPostModel';

  @override
  Future<TextPostModel> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$TextPostModelFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    TextPostModel input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$TextPostModelToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<TextPostModel> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$TextPostModelFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    TextPostModel input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$TextPostModelToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
