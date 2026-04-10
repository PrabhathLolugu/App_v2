// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<StoryAttributesModel> _$StoryAttributesModelFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return StoryAttributesModel(
    id: data['id'] as String,
    storyType: data['story_type'] as String,
    theme: data['theme'] as String,
    mainCharacterType: data['main_character_type'] as String,
    storySetting: data['story_setting'] as String,
    timeEra: data['time_era'] as String,
    narrativePerspective: data['narrative_perspective'] as String,
    languageStyle: data['language_style'] as String,
    emotionalTone: data['emotional_tone'] as String,
    narrativeStyle: data['narrative_style'] as String,
    plotStructure: data['plot_structure'] as String,
    storyLength: data['story_length'] as String,
    references: data['references'].toList().cast<String>(),
    tags: data['tags'].toList().cast<String>(),
    characters: data['characters'].toList().cast<String>(),
    characterDetails: data['character_details'],
    translationsJson: data['translations'],
  );
}

Future<Map<String, dynamic>> _$StoryAttributesModelToSupabase(
  StoryAttributesModel instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'story_type': instance.storyType,
    'theme': instance.theme,
    'main_character_type': instance.mainCharacterType,
    'story_setting': instance.storySetting,
    'time_era': instance.timeEra,
    'narrative_perspective': instance.narrativePerspective,
    'language_style': instance.languageStyle,
    'emotional_tone': instance.emotionalTone,
    'narrative_style': instance.narrativeStyle,
    'plot_structure': instance.plotStructure,
    'story_length': instance.storyLength,
    'references': instance.references,
    'tags': instance.tags,
    'characters': instance.characters,
    'character_details': instance.characterDetails,
    'translations': instance.translationsJson,
  };
}

Future<StoryAttributesModel> _$StoryAttributesModelFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return StoryAttributesModel(
    id: data['id'] as String,
    storyType: data['story_type'] as String,
    theme: data['theme'] as String,
    mainCharacterType: data['main_character_type'] as String,
    storySetting: data['story_setting'] as String,
    timeEra: data['time_era'] as String,
    narrativePerspective: data['narrative_perspective'] as String,
    languageStyle: data['language_style'] as String,
    emotionalTone: data['emotional_tone'] as String,
    narrativeStyle: data['narrative_style'] as String,
    plotStructure: data['plot_structure'] as String,
    storyLength: data['story_length'] as String,
    references: jsonDecode(data['references']).toList().cast<String>(),
    tags: jsonDecode(data['tags']).toList().cast<String>(),
    characters: jsonDecode(data['characters']).toList().cast<String>(),
    characterDetails: jsonDecode(data['character_details']),
    translationsJson: jsonDecode(data['translations']),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$StoryAttributesModelToSqlite(
  StoryAttributesModel instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'story_type': instance.storyType,
    'theme': instance.theme,
    'main_character_type': instance.mainCharacterType,
    'story_setting': instance.storySetting,
    'time_era': instance.timeEra,
    'narrative_perspective': instance.narrativePerspective,
    'language_style': instance.languageStyle,
    'emotional_tone': instance.emotionalTone,
    'narrative_style': instance.narrativeStyle,
    'plot_structure': instance.plotStructure,
    'story_length': instance.storyLength,
    'references': jsonEncode(instance.references),
    'tags': jsonEncode(instance.tags),
    'characters': jsonEncode(instance.characters),
    'character_details': jsonEncode(instance.characterDetails),
    'translations': jsonEncode(instance.translationsJson),
  };
}

/// Construct a [StoryAttributesModel]
class StoryAttributesModelAdapter
    extends OfflineFirstWithSupabaseAdapter<StoryAttributesModel> {
  StoryAttributesModelAdapter();

  @override
  final supabaseTableName = 'story_attributes';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'storyType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'story_type',
    ),
    'theme': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'theme',
    ),
    'mainCharacterType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'main_character_type',
    ),
    'storySetting': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'story_setting',
    ),
    'timeEra': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'time_era',
    ),
    'narrativePerspective': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'narrative_perspective',
    ),
    'languageStyle': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'language_style',
    ),
    'emotionalTone': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'emotional_tone',
    ),
    'narrativeStyle': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'narrative_style',
    ),
    'plotStructure': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'plot_structure',
    ),
    'storyLength': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'story_length',
    ),
    'references': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'references',
    ),
    'tags': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tags',
    ),
    'characters': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'characters',
    ),
    'characterDetails': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'character_details',
    ),
    'translationsJson': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'translations',
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
    'storyType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'story_type',
      iterable: false,
      type: String,
    ),
    'theme': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'theme',
      iterable: false,
      type: String,
    ),
    'mainCharacterType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'main_character_type',
      iterable: false,
      type: String,
    ),
    'storySetting': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'story_setting',
      iterable: false,
      type: String,
    ),
    'timeEra': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'time_era',
      iterable: false,
      type: String,
    ),
    'narrativePerspective': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'narrative_perspective',
      iterable: false,
      type: String,
    ),
    'languageStyle': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'language_style',
      iterable: false,
      type: String,
    ),
    'emotionalTone': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'emotional_tone',
      iterable: false,
      type: String,
    ),
    'narrativeStyle': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'narrative_style',
      iterable: false,
      type: String,
    ),
    'plotStructure': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'plot_structure',
      iterable: false,
      type: String,
    ),
    'storyLength': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'story_length',
      iterable: false,
      type: String,
    ),
    'references': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'references',
      iterable: true,
      type: String,
    ),
    'tags': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tags',
      iterable: true,
      type: String,
    ),
    'characters': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'characters',
      iterable: true,
      type: String,
    ),
    'characterDetails': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'character_details',
      iterable: false,
      type: Map,
    ),
    'translationsJson': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'translations',
      iterable: false,
      type: Map,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    StoryAttributesModel instance,
    DatabaseExecutor executor,
  ) async => instance.primaryKey;
  @override
  final String tableName = 'StoryAttributesModel';

  @override
  Future<StoryAttributesModel> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$StoryAttributesModelFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    StoryAttributesModel input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$StoryAttributesModelToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<StoryAttributesModel> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$StoryAttributesModelFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    StoryAttributesModel input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$StoryAttributesModelToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
