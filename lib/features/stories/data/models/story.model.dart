import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/features/story_generator/domain/entities/story_translation.dart';
import 'package:myitihas/core/logging/talker_setup.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'stories'),
  sqliteConfig: SqliteSerializable(),
)
class StoryModel extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  final String id;

  /// User ID - required by Supabase (NOT NULL constraint)
  /// SQLite nullable to handle existing records before migration
  @Supabase(name: 'user_id')
  @Sqlite(nullable: true)
  final String? userId;

  final String title;

  /// Story content
  @Supabase(name: 'content')
  final String content;

  /// Attributes stored as JSONB
  @Supabase(name: 'attributes')
  final Map<String, dynamic> attributesJson;

  /// Metadata stored as JSONB
  @Supabase(name: 'metadata')
  final Map<String, dynamic>? metadata;

  /// Image URL - now stores URLs instead of base64 data after migration
  @Supabase(name: 'image_url')
  final String? imageUrl;

  final String? author;

  @Supabase(name: 'author_id')
  final String? authorId;

  @Supabase(name: 'published_at')
  final DateTime? publishedAt;

  @Supabase(name: 'created_at')
  final DateTime? createdAt;

  @Supabase(name: 'updated_at')
  final DateTime? updatedAt;

  final int likes;

  final int views;

  @Supabase(name: 'is_favourite')
  final bool isFavorite;

  @Supabase(name: 'comment_count')
  final int? commentCount;

  @Supabase(name: 'share_count')
  final int? shareCount;

  @Supabase(name: 'is_featured')
  final bool isFeatured;

  StoryModel({
    required this.id,
    this.userId,
    required this.title,
    this.content = '',
    this.attributesJson = const <String, dynamic>{},
    this.metadata,
    this.imageUrl,
    this.author,
    this.authorId,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
    this.likes = 0,
    this.views = 0,
    this.isFavorite = false,
    this.isFeatured = false,
    this.commentCount,
    this.shareCount,
  });

  factory StoryModel.fromDomain(Story entity) {
    // Serialize attributes to JSON
    final attributesJson = <String, dynamic>{
      'story_type': entity.attributes.storyType,
      'theme': entity.attributes.theme,
      'main_character_type': entity.attributes.mainCharacterType,
      'story_setting': entity.attributes.storySetting,
      'time_era': entity.attributes.timeEra,
      'narrative_perspective': entity.attributes.narrativePerspective,
      'language_style': entity.attributes.languageStyle,
      'emotional_tone': entity.attributes.emotionalTone,
      'narrative_style': entity.attributes.narrativeStyle,
      'plot_structure': entity.attributes.plotStructure,
      'story_length': entity.attributes.storyLength,
      'references': entity.attributes.references,
      'tags': entity.attributes.tags,
      'characters': entity.attributes.characters,
      'character_details': entity.attributes.characterDetails,
      'translations': entity.attributes.translations.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
    };

    // Combine story parts into content (or store separately in metadata)
    final contentParts = <String>[];
    if (entity.story.isNotEmpty) contentParts.add(entity.story);

    final metadata = <String, dynamic>{
      'scripture': entity.scripture,
      'quotes': entity.quotes,
      'trivia': entity.trivia,
      'activity': entity.activity,
      'lesson': entity.lesson,
    };

    return StoryModel(
      id: entity.id,
      userId: entity.authorId ?? '', // user_id in Supabase, required NOT NULL
      title: entity.title,
      content: contentParts.join('\n\n'),
      attributesJson: attributesJson,
      metadata: metadata,
      imageUrl: entity.imageUrl,
      author: entity.author,
      authorId: entity.authorId,
      publishedAt: entity.publishedAt,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      likes: entity.likes,
      views: entity.views,
      isFavorite: entity.isFavorite,
      isFeatured: entity.isFeatured,
    );
  }

  /// Coerces a metadata value to String. Handles String, List (joined by newlines), and null.
  static String _metadataString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is List) {
      return value.map((e) => e?.toString() ?? '').join('\n');
    }
    return value.toString();
  }

  Story toDomain() {
    // Parse attributes from JSON
    final attributes = _parseAttributes(attributesJson);

    // Extract story parts from metadata or use defaults (metadata may store lists from API)
    final scripture = _metadataString(metadata?['scripture']);
    final quotes = _metadataString(metadata?['quotes']);
    final trivia = _metadataString(metadata?['trivia']);
    final activity = _metadataString(metadata?['activity']);
    final lesson = _metadataString(metadata?['lesson']);

    return Story(
      id: id,
      title: title,
      scripture: scripture,
      story: content,
      quotes: quotes,
      trivia: trivia,
      activity: activity,
      lesson: lesson,
      attributes: attributes,
      imageUrl: imageUrl,
      author: author,
      authorId: authorId,
      publishedAt: publishedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      likes: likes,
      views: views,
      isFavorite: isFavorite,
      isFeatured: isFeatured,
    );
  }

  StoryAttributes _parseAttributes(Map<String, dynamic> json) {
    // Parse translations
    Map<String, TranslatedStory> translations = {};
    final translationsData = json['translations'];
    if (translationsData is Map<String, dynamic>) {
      for (final entry in translationsData.entries) {
        try {
          if (entry.value is Map<String, dynamic>) {
            translations[entry.key] = TranslatedStory.fromJson(entry.value);
          }
        } catch (e) {
          talker.warning('Failed to parse translation for ${entry.key}: $e');
        }
      }
    }

    return StoryAttributes(
      storyType: json['story_type'] as String? ?? '',
      theme: json['theme'] as String? ?? '',
      mainCharacterType: json['main_character_type'] as String? ?? '',
      storySetting: json['story_setting'] as String? ?? '',
      timeEra: json['time_era'] as String? ?? '',
      narrativePerspective: json['narrative_perspective'] as String? ?? '',
      languageStyle: json['language_style'] as String? ?? '',
      emotionalTone: json['emotional_tone'] as String? ?? '',
      narrativeStyle: json['narrative_style'] as String? ?? '',
      plotStructure: json['plot_structure'] as String? ?? '',
      storyLength: json['story_length'] as String? ?? '',
      references: _parseStringList(json['references']),
      tags: _parseStringList(json['tags']),
      characters: _parseStringList(json['characters']),
      characterDetails: json['character_details'] is Map<String, dynamic>
          ? json['character_details'] as Map<String, dynamic>
          : <String, dynamic>{},
      translations: translations,
    );
  }

  List<String> _parseStringList(dynamic value) {
    if (value is List) {
      return value.cast<String>();
    }
    return <String>[];
  }
}
