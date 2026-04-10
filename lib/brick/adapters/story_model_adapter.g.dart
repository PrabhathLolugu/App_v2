// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<StoryModel> _$StoryModelFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return StoryModel(
    id: data['id'] as String,
    userId: data['user_id'] == null ? null : data['user_id'] as String?,
    title: data['title'] as String,
    content: data['content'] as String,
    attributesJson: data['attributes'],
    metadata: data['metadata'] == null ? null : data['metadata'],
    imageUrl: data['image_url'] == null ? null : data['image_url'] as String?,
    author: data['author'] == null ? null : data['author'] as String?,
    authorId: data['author_id'] == null ? null : data['author_id'] as String?,
    publishedAt: data['published_at'] == null
        ? null
        : data['published_at'] == null
        ? null
        : DateTime.tryParse(data['published_at'] as String),
    createdAt: data['created_at'] == null
        ? null
        : data['created_at'] == null
        ? null
        : DateTime.tryParse(data['created_at'] as String),
    updatedAt: data['updated_at'] == null
        ? null
        : data['updated_at'] == null
        ? null
        : DateTime.tryParse(data['updated_at'] as String),
    likes: data['likes'] as int,
    views: data['views'] as int,
    isFavorite: data['is_favourite'] as bool,
    commentCount: data['comment_count'] == null
        ? null
        : data['comment_count'] as int?,
    shareCount: data['share_count'] == null
        ? null
        : data['share_count'] as int?,
    isFeatured: data['is_featured'] as bool,
  );
}

Future<Map<String, dynamic>> _$StoryModelToSupabase(
  StoryModel instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'user_id': instance.userId,
    'title': instance.title,
    'content': instance.content,
    'attributes': instance.attributesJson,
    'metadata': instance.metadata,
    'image_url': instance.imageUrl,
    'author': instance.author,
    'author_id': instance.authorId,
    'published_at': instance.publishedAt?.toIso8601String(),
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'likes': instance.likes,
    'views': instance.views,
    'is_favourite': instance.isFavorite,
    'comment_count': instance.commentCount,
    'share_count': instance.shareCount,
    'is_featured': instance.isFeatured,
  };
}

Future<StoryModel> _$StoryModelFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return StoryModel(
    id: data['id'] as String,
    userId: data['user_id'] == null ? null : data['user_id'] as String?,
    title: data['title'] as String,
    content: data['content'] as String,
    attributesJson: jsonDecode(data['attributes_json']),
    metadata: data['metadata'] == null ? null : jsonDecode(data['metadata']),
    imageUrl: data['image_url'] == null ? null : data['image_url'] as String?,
    author: data['author'] == null ? null : data['author'] as String?,
    authorId: data['author_id'] == null ? null : data['author_id'] as String?,
    publishedAt: data['published_at'] == null
        ? null
        : data['published_at'] == null
        ? null
        : DateTime.tryParse(data['published_at'] as String),
    createdAt: data['created_at'] == null
        ? null
        : data['created_at'] == null
        ? null
        : DateTime.tryParse(data['created_at'] as String),
    updatedAt: data['updated_at'] == null
        ? null
        : data['updated_at'] == null
        ? null
        : DateTime.tryParse(data['updated_at'] as String),
    likes: data['likes'] as int,
    views: data['views'] as int,
    isFavorite: data['is_favorite'] == 1,
    commentCount: data['comment_count'] == null
        ? null
        : data['comment_count'] as int?,
    shareCount: data['share_count'] == null
        ? null
        : data['share_count'] as int?,
    isFeatured: data['is_featured'] == 1,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$StoryModelToSqlite(
  StoryModel instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'user_id': instance.userId,
    'title': instance.title,
    'content': instance.content,
    'attributes_json': jsonEncode(instance.attributesJson),
    'metadata': instance.metadata != null
        ? jsonEncode(instance.metadata)
        : null,
    'image_url': instance.imageUrl,
    'author': instance.author,
    'author_id': instance.authorId,
    'published_at': instance.publishedAt?.toIso8601String(),
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'likes': instance.likes,
    'views': instance.views,
    'is_favorite': instance.isFavorite ? 1 : 0,
    'comment_count': instance.commentCount,
    'share_count': instance.shareCount,
    'is_featured': instance.isFeatured ? 1 : 0,
  };
}

/// Construct a [StoryModel]
class StoryModelAdapter extends OfflineFirstWithSupabaseAdapter<StoryModel> {
  StoryModelAdapter();

  @override
  final supabaseTableName = 'stories';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'userId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'user_id',
    ),
    'title': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'title',
    ),
    'content': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'content',
    ),
    'attributesJson': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'attributes',
    ),
    'metadata': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'metadata',
    ),
    'imageUrl': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'image_url',
    ),
    'author': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'author',
    ),
    'authorId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'author_id',
    ),
    'publishedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'published_at',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'updatedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'updated_at',
    ),
    'likes': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'likes',
    ),
    'views': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'views',
    ),
    'isFavorite': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_favourite',
    ),
    'commentCount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'comment_count',
    ),
    'shareCount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'share_count',
    ),
    'isFeatured': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_featured',
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
    'userId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'user_id',
      iterable: false,
      type: String,
    ),
    'title': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'title',
      iterable: false,
      type: String,
    ),
    'content': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'content',
      iterable: false,
      type: String,
    ),
    'attributesJson': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'attributes_json',
      iterable: false,
      type: Map,
    ),
    'metadata': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'metadata',
      iterable: false,
      type: Map,
    ),
    'imageUrl': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'image_url',
      iterable: false,
      type: String,
    ),
    'author': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'author',
      iterable: false,
      type: String,
    ),
    'authorId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'author_id',
      iterable: false,
      type: String,
    ),
    'publishedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'published_at',
      iterable: false,
      type: DateTime,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
    ),
    'updatedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'updated_at',
      iterable: false,
      type: DateTime,
    ),
    'likes': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'likes',
      iterable: false,
      type: int,
    ),
    'views': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'views',
      iterable: false,
      type: int,
    ),
    'isFavorite': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_favorite',
      iterable: false,
      type: bool,
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
    'isFeatured': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_featured',
      iterable: false,
      type: bool,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    StoryModel instance,
    DatabaseExecutor executor,
  ) async => instance.primaryKey;
  @override
  final String tableName = 'StoryModel';

  @override
  Future<StoryModel> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$StoryModelFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    StoryModel input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$StoryModelToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<StoryModel> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$StoryModelFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    StoryModel input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$StoryModelToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
