// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<StoryChatConversationModel> _$StoryChatConversationModelFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return StoryChatConversationModel(
    id: data['id'] as String,
    storyId: data['story_id'] as String,
    userId: data['user_id'] as String,
    title: data['title'] as String,
    messagesJson: jsonEncode(data['messages']),
    createdAt: DateTime.parse(data['created_at'] as String),
    updatedAt: DateTime.parse(data['updated_at'] as String),
  );
}

Future<Map<String, dynamic>> _$StoryChatConversationModelToSupabase(
  StoryChatConversationModel instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'story_id': instance.storyId,
    'user_id': instance.userId,
    'title': instance.title,
    'messages': jsonDecode(instance.messagesJson),
    'created_at': instance.createdAt.toIso8601String(),
    'updated_at': instance.updatedAt.toIso8601String(),
  };
}

Future<StoryChatConversationModel> _$StoryChatConversationModelFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return StoryChatConversationModel(
    id: data['id'] as String,
    storyId: data['story_id'] as String,
    userId: data['user_id'] as String,
    title: data['title'] as String,
    messagesJson: data['messages'] as String,
    createdAt: DateTime.parse(data['created_at'] as String),
    updatedAt: DateTime.parse(data['updated_at'] as String),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$StoryChatConversationModelToSqlite(
  StoryChatConversationModel instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'story_id': instance.storyId,
    'user_id': instance.userId,
    'title': instance.title,
    'messages': instance.messagesJson,
    'created_at': instance.createdAt.toIso8601String(),
    'updated_at': instance.updatedAt.toIso8601String(),
  };
}

/// Construct a [StoryChatConversationModel]
class StoryChatConversationModelAdapter
    extends OfflineFirstWithSupabaseAdapter<StoryChatConversationModel> {
  StoryChatConversationModelAdapter();

  @override
  final supabaseTableName = 'story_chats';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'storyId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'story_id',
    ),
    'userId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'user_id',
    ),
    'title': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'title',
    ),
    'messagesJson': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'messages',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'updatedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'updated_at',
    ),
  };
  @override
  final ignoreDuplicates = false;
  @override
  final uniqueFields = {'id', 'storyId', 'userId'};
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
    'storyId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'story_id',
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
    'messagesJson': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'messages',
      iterable: false,
      type: String,
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
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    StoryChatConversationModel instance,
    DatabaseExecutor executor,
  ) async => instance.primaryKey;
  @override
  final String tableName = 'StoryChatConversationModel';

  @override
  Future<StoryChatConversationModel> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$StoryChatConversationModelFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    StoryChatConversationModel input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$StoryChatConversationModelToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<StoryChatConversationModel> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$StoryChatConversationModelFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    StoryChatConversationModel input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$StoryChatConversationModelToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
