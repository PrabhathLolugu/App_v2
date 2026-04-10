// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<ConversationModel> _$ConversationModelFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return ConversationModel(
    id: data['id'] as String,
    isGroup: data['is_group'] as bool,
    groupName: data['group_name'] == null
        ? null
        : data['group_name'] as String?,
    groupAvatarUrl: data['group_avatar_url'] == null
        ? null
        : data['group_avatar_url'] as String?,
    groupDescription: data['group_description'] == null
        ? null
        : data['group_description'] as String?,
    lastMessage: data['last_message'] == null
        ? null
        : data['last_message'] as String?,
    lastMessageAt: data['last_message_at'] == null
        ? null
        : data['last_message_at'] == null
        ? null
        : DateTime.tryParse(data['last_message_at'] as String),
    lastMessageSenderId: data['last_message_sender_id'] == null
        ? null
        : data['last_message_sender_id'] as String?,
    createdAt: DateTime.parse(data['created_at'] as String),
    updatedAt: DateTime.parse(data['updated_at'] as String),
  );
}

Future<Map<String, dynamic>> _$ConversationModelToSupabase(
  ConversationModel instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'is_group': instance.isGroup,
    'group_name': instance.groupName,
    'group_avatar_url': instance.groupAvatarUrl,
    'group_description': instance.groupDescription,
    'last_message': instance.lastMessage,
    'last_message_at': instance.lastMessageAt?.toIso8601String(),
    'last_message_sender_id': instance.lastMessageSenderId,
    'created_at': instance.createdAt.toIso8601String(),
    'updated_at': instance.updatedAt.toIso8601String(),
  };
}

Future<ConversationModel> _$ConversationModelFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return ConversationModel(
    id: data['id'] as String,
    isGroup: data['is_group'] == 1,
    groupName: data['group_name'] == null
        ? null
        : data['group_name'] as String?,
    groupAvatarUrl: data['group_avatar_url'] == null
        ? null
        : data['group_avatar_url'] as String?,
    groupDescription: data['group_description'] == null
        ? null
        : data['group_description'] as String?,
    lastMessage: data['last_message'] == null
        ? null
        : data['last_message'] as String?,
    lastMessageAt: data['last_message_at'] == null
        ? null
        : data['last_message_at'] == null
        ? null
        : DateTime.tryParse(data['last_message_at'] as String),
    lastMessageSenderId: data['last_message_sender_id'] == null
        ? null
        : data['last_message_sender_id'] as String?,
    createdAt: DateTime.parse(data['created_at'] as String),
    updatedAt: DateTime.parse(data['updated_at'] as String),
    participantIds: jsonDecode(data['participant_ids']).toList().cast<String>(),
    unreadCount: data['unread_count'] as int,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$ConversationModelToSqlite(
  ConversationModel instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'is_group': instance.isGroup ? 1 : 0,
    'group_name': instance.groupName,
    'group_avatar_url': instance.groupAvatarUrl,
    'group_description': instance.groupDescription,
    'last_message': instance.lastMessage,
    'last_message_at': instance.lastMessageAt?.toIso8601String(),
    'last_message_sender_id': instance.lastMessageSenderId,
    'created_at': instance.createdAt.toIso8601String(),
    'updated_at': instance.updatedAt.toIso8601String(),
    'participant_ids': jsonEncode(instance.participantIds),
    'unread_count': instance.unreadCount,
  };
}

/// Construct a [ConversationModel]
class ConversationModelAdapter
    extends OfflineFirstWithSupabaseAdapter<ConversationModel> {
  ConversationModelAdapter();

  @override
  final supabaseTableName = 'conversations';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'isGroup': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_group',
    ),
    'groupName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'group_name',
    ),
    'groupAvatarUrl': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'group_avatar_url',
    ),
    'groupDescription': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'group_description',
    ),
    'lastMessage': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_message',
    ),
    'lastMessageAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_message_at',
    ),
    'lastMessageSenderId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_message_sender_id',
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
    'isGroup': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_group',
      iterable: false,
      type: bool,
    ),
    'groupName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'group_name',
      iterable: false,
      type: String,
    ),
    'groupAvatarUrl': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'group_avatar_url',
      iterable: false,
      type: String,
    ),
    'groupDescription': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'group_description',
      iterable: false,
      type: String,
    ),
    'lastMessage': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_message',
      iterable: false,
      type: String,
    ),
    'lastMessageAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_message_at',
      iterable: false,
      type: DateTime,
    ),
    'lastMessageSenderId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_message_sender_id',
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
    'participantIds': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'participant_ids',
      iterable: true,
      type: String,
    ),
    'unreadCount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'unread_count',
      iterable: false,
      type: int,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    ConversationModel instance,
    DatabaseExecutor executor,
  ) async => instance.primaryKey;
  @override
  final String tableName = 'ConversationModel';

  @override
  Future<ConversationModel> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ConversationModelFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    ConversationModel input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ConversationModelToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<ConversationModel> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ConversationModelFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    ConversationModel input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ConversationModelToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
