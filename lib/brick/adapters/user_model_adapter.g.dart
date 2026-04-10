// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<UserModel> _$UserModelFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return UserModel(
    id: data['id'] as String,
    username: data['username'] as String,
    displayName: data['full_name'] == null
        ? null
        : data['full_name'] as String?,
    avatarUrl: data['avatar_url'] == null
        ? null
        : data['avatar_url'] as String?,
    bio: data['bio'] == null ? null : data['bio'] as String?,
    isVerified: data['is_verified'] as bool,
    acceptsDirectMessages: data['accepts_direct_messages'] as bool,
    isOfficialMyitihas: data['is_official_myitihas'] as bool,
  );
}

Future<Map<String, dynamic>> _$UserModelToSupabase(
  UserModel instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'username': instance.username,
    'full_name': instance.displayName,
    'avatar_url': instance.avatarUrl,
    'bio': instance.bio,
    'is_verified': instance.isVerified,
    'accepts_direct_messages': instance.acceptsDirectMessages,
    'is_official_myitihas': instance.isOfficialMyitihas,
  };
}

Future<UserModel> _$UserModelFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return UserModel(
    id: data['id'] as String,
    username: data['username'] as String,
    displayName: data['display_name'] == null
        ? null
        : data['display_name'] as String?,
    avatarUrl: data['avatar_url'] == null
        ? null
        : data['avatar_url'] as String?,
    bio: data['bio'] == null ? null : data['bio'] as String?,
    isVerified: data['is_verified'] == 1,
    acceptsDirectMessages: data['accepts_direct_messages'] == 1,
    isOfficialMyitihas: data['is_official_myitihas'] == 1,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$UserModelToSqlite(
  UserModel instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'username': instance.username,
    'display_name': instance.displayName,
    'avatar_url': instance.avatarUrl,
    'bio': instance.bio,
    'is_verified': instance.isVerified ? 1 : 0,
    'accepts_direct_messages': instance.acceptsDirectMessages ? 1 : 0,
    'is_official_myitihas': instance.isOfficialMyitihas ? 1 : 0,
  };
}

/// Construct a [UserModel]
class UserModelAdapter extends OfflineFirstWithSupabaseAdapter<UserModel> {
  UserModelAdapter();

  @override
  final supabaseTableName = 'profiles';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'username': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'username',
    ),
    'displayName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'full_name',
    ),
    'avatarUrl': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'avatar_url',
    ),
    'bio': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'bio',
    ),
    'isVerified': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_verified',
    ),
    'acceptsDirectMessages': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'accepts_direct_messages',
    ),
    'isOfficialMyitihas': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_official_myitihas',
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
    'username': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'username',
      iterable: false,
      type: String,
    ),
    'displayName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'display_name',
      iterable: false,
      type: String,
    ),
    'avatarUrl': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'avatar_url',
      iterable: false,
      type: String,
    ),
    'bio': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'bio',
      iterable: false,
      type: String,
    ),
    'isVerified': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_verified',
      iterable: false,
      type: bool,
    ),
    'acceptsDirectMessages': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'accepts_direct_messages',
      iterable: false,
      type: bool,
    ),
    'isOfficialMyitihas': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_official_myitihas',
      iterable: false,
      type: bool,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    UserModel instance,
    DatabaseExecutor executor,
  ) async => instance.primaryKey;
  @override
  final String tableName = 'UserModel';

  @override
  Future<UserModel> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$UserModelFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    UserModel input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$UserModelToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<UserModel> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$UserModelFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    UserModel input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$UserModelToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
