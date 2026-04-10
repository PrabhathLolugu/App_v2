// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<MessageModel> _$MessageModelFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return MessageModel(
    id: data['id'] as String,
    conversationId: data['conversation_id'] as String,
    senderId: data['sender_id'] as String,
    sender: data['sender'] == null
        ? null
        : await UserModelAdapter().fromSupabase(
            data['sender'],
            provider: provider,
            repository: repository,
          ),
    content: data['content'] as String,
    type: data['type'] == null ? null : data['type'] as String?,
    createdAt: DateTime.parse(data['created_at'] as String),
    sharedContentId: data['shared_content_id'] == null
        ? null
        : data['shared_content_id'] as String?,
    metadata: data['metadata'] == null ? null : data['metadata'],
  );
}

Future<Map<String, dynamic>> _$MessageModelToSupabase(
  MessageModel instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'conversation_id': instance.conversationId,
    'sender_id': instance.senderId,
    'sender': instance.sender != null
        ? await UserModelAdapter().toSupabase(
            instance.sender!,
            provider: provider,
            repository: repository,
          )
        : null,
    'content': instance.content,
    'type': instance.type,
    'created_at': instance.createdAt.toIso8601String(),
    'shared_content_id': instance.sharedContentId,
    'metadata': instance.metadata,
  };
}

Future<MessageModel> _$MessageModelFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return MessageModel(
    id: data['id'] as String,
    conversationId: data['conversation_id'] as String,
    senderId: data['sender_id'] as String,
    sender: data['sender_UserModel_brick_id'] == null
        ? null
        : (data['sender_UserModel_brick_id'] > -1
              ? (await repository?.getAssociation<UserModel>(
                  Query.where(
                    'primaryKey',
                    data['sender_UserModel_brick_id'] as int,
                    limit1: true,
                  ),
                ))?.first
              : null),
    content: data['content'] as String,
    type: data['type'] == null ? null : data['type'] as String?,
    createdAt: DateTime.parse(data['created_at'] as String),
    deliveryStatus: data['delivery_status'] as String,
    readBy: jsonDecode(data['read_by']).toList().cast<String>(),
    sharedContentId: data['shared_content_id'] == null
        ? null
        : data['shared_content_id'] as String?,
    metadata: data['metadata'] == null ? null : jsonDecode(data['metadata']),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$MessageModelToSqlite(
  MessageModel instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'conversation_id': instance.conversationId,
    'sender_id': instance.senderId,
    'sender_UserModel_brick_id': instance.sender != null
        ? instance.sender!.primaryKey ??
              await provider.upsert<UserModel>(
                instance.sender!,
                repository: repository,
              )
        : null,
    'content': instance.content,
    'type': instance.type,
    'created_at': instance.createdAt.toIso8601String(),
    'delivery_status': instance.deliveryStatus,
    'read_by': jsonEncode(instance.readBy),
    'shared_content_id': instance.sharedContentId,
    'metadata': instance.metadata != null
        ? jsonEncode(instance.metadata)
        : null,
  };
}

/// Construct a [MessageModel]
class MessageModelAdapter
    extends OfflineFirstWithSupabaseAdapter<MessageModel> {
  MessageModelAdapter();

  @override
  final supabaseTableName = 'chat_messages';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'conversationId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'conversation_id',
    ),
    'senderId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'sender_id',
    ),
    'sender': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'sender',
      associationType: UserModel,
      associationIsNullable: true,
      foreignKey: 'sender_id',
    ),
    'content': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'content',
    ),
    'type': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'type',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'sharedContentId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'shared_content_id',
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
    'conversationId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'conversation_id',
      iterable: false,
      type: String,
    ),
    'senderId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'sender_id',
      iterable: false,
      type: String,
    ),
    'sender': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'sender_UserModel_brick_id',
      iterable: false,
      type: UserModel,
    ),
    'content': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'content',
      iterable: false,
      type: String,
    ),
    'type': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'type',
      iterable: false,
      type: String,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
    ),
    'deliveryStatus': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'delivery_status',
      iterable: false,
      type: String,
    ),
    'readBy': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'read_by',
      iterable: true,
      type: String,
    ),
    'sharedContentId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'shared_content_id',
      iterable: false,
      type: String,
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
    MessageModel instance,
    DatabaseExecutor executor,
  ) async => instance.primaryKey;
  @override
  final String tableName = 'MessageModel';

  @override
  Future<MessageModel> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$MessageModelFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    MessageModel input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$MessageModelToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<MessageModel> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$MessageModelFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    MessageModel input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$MessageModelToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
