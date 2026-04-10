import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/features/story_generator/domain/entities/story_translation.dart';
import 'package:myitihas/core/logging/talker_setup.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'story_attributes'),
  sqliteConfig: SqliteSerializable(),
)
class StoryAttributesModel extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  final String id;
  final String storyType;
  final String theme;
  final String mainCharacterType;
  final String storySetting;
  final String timeEra;
  final String narrativePerspective;
  final String languageStyle;
  final String emotionalTone;
  final String narrativeStyle;
  final String plotStructure;
  final String storyLength;
  final List<String> references;
  final List<String> tags;
  final List<String> characters;
  @Supabase(name: 'character_details')
  @Sqlite(name: 'character_details')
  final Map<String, dynamic> characterDetails;
  @Supabase(name: 'translations')
  @Sqlite(name: 'translations')
  final Map<String, dynamic> translationsJson;

  StoryAttributesModel({
    required this.id,
    required this.storyType,
    required this.theme,
    required this.mainCharacterType,
    required this.storySetting,
    required this.timeEra,
    required this.narrativePerspective,
    required this.languageStyle,
    required this.emotionalTone,
    required this.narrativeStyle,
    required this.plotStructure,
    required this.storyLength,
    this.references = const [],
    this.tags = const [],
    this.characters = const [],
    this.characterDetails = const {},
    this.translationsJson = const {},
  });

  factory StoryAttributesModel.fromDomain(StoryAttributes entity) {
    return StoryAttributesModel(
      id: '',
      storyType: entity.storyType,
      theme: entity.theme,
      mainCharacterType: entity.mainCharacterType,
      storySetting: entity.storySetting,
      timeEra: entity.timeEra,
      narrativePerspective: entity.narrativePerspective,
      languageStyle: entity.languageStyle,
      emotionalTone: entity.emotionalTone,
      narrativeStyle: entity.narrativeStyle,
      plotStructure: entity.plotStructure,
      storyLength: entity.storyLength,
      references: entity.references,
      tags: entity.tags,
      characters: entity.characters,
      characterDetails: entity.characterDetails,
      translationsJson: entity.translations.map((key, value) => MapEntry(key, value.toJson())),
    );
  }

  StoryAttributes toDomain() {
    return StoryAttributes(
      storyType: storyType,
      theme: theme,
      mainCharacterType: mainCharacterType,
      storySetting: storySetting,
      timeEra: timeEra,
      narrativePerspective: narrativePerspective,
      languageStyle: languageStyle,
      emotionalTone: emotionalTone,
      narrativeStyle: narrativeStyle,
      plotStructure: plotStructure,
      storyLength: storyLength,
      references: references,
      tags: tags,
      characters: characters,
      characterDetails: characterDetails,
      translations: _parseTranslations(translationsJson),
    );
  }

  Map<String, TranslatedStory> _parseTranslations(Map<String, dynamic> json) {
    final result = <String, TranslatedStory>{};
    for (final entry in json.entries) {
      try {
        if (entry.value is Map<String, dynamic>) {
          result[entry.key] = TranslatedStory.fromJson(entry.value);
        }
      } catch (e) {
        // Skip invalid translation entries - log but don't crash
        talker.warning('Failed to parse translation for ${entry.key}: $e');
      }
    }
    return result;
  }
}
