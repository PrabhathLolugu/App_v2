import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/logging/talker_setup.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/features/story_generator/domain/entities/story_translation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class ContinueStoryLocalStore {
  static const String _baseKey = 'continue_story_ids';

  String? get _userScopedKey {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return null;
    return '${_baseKey}_${user.id}';
  }

  String get _activeWriteKey => _userScopedKey ?? _baseKey;

  List<String> get _storageKeysForRead {
    final keys = <String>[];
    final userKey = _userScopedKey;
    if (userKey != null) keys.add(userKey);
    keys.add(_baseKey);
    return keys;
  }

  final SharedPreferences _prefs;
  final int maxItems = 5;

  ContinueStoryLocalStore(this._prefs);

  List<Story> getStorys() {
    final deduped = <String, Story>{};
    for (final key in _storageKeysForRead) {
      final jsonString = _prefs.getString(key);
      if (jsonString == null || jsonString.isEmpty) continue;
      talker.debug('ContinueReading: Found stored stories at $key');

      for (final story in _parseStoriesFromJson(jsonString, key)) {
        deduped.putIfAbsent(story.id, () => story);
      }
    }
    return deduped.values.toList();
  }

  Future<void> touch(Story story) async {
    talker.debug(
      'ContinueReading: Touching story: ${story.title} (${story.id})',
    );
    final stories = getStorys();

    // Remove the story if it already exists (to avoid duplicates)
    stories.removeWhere((e) => e.id == story.id);

    // Insert at the beginning (most recent)
    stories.insert(0, story);

    // Keep only maxItems
    if (stories.length > maxItems) {
      stories.removeRange(maxItems, stories.length);
    }

    // Save to SharedPreferences
    await _saveStories(stories);
    if (_activeWriteKey != _baseKey) {
      // Migrate/avoid stale guest entries once the user is authenticated.
      await _prefs.remove(_baseKey);
    }
    talker.debug('ContinueReading: Saved ${stories.length} stories');
  }

  Future<void> remove(String storyId) async {
    final stories = getStorys();
    stories.removeWhere((e) => e.id == storyId);
    for (final key in _storageKeysForRead) {
      await _saveStories(stories, key: key);
    }
  }

  Future<void> clear() async {
    for (final key in _storageKeysForRead) {
      await _prefs.remove(key);
    }
  }

  Future<void> _saveStories(List<Story> stories, {String? key}) async {
    final jsonList = stories.map((story) => _storyToMap(story)).toList();
    final jsonString = jsonEncode(jsonList);
    await _prefs.setString(key ?? _activeWriteKey, jsonString);
  }

  List<Story> _parseStoriesFromJson(String rawJson, String sourceKey) {
    try {
      final decoded = jsonDecode(rawJson);
      if (decoded is! List) return <Story>[];

      final parsed = <Story>[];
      for (final item in decoded) {
        try {
          if (item is Map) {
            parsed.add(mapSupabaseRowToStory(Map<String, dynamic>.from(item)));
          }
        } catch (e) {
          talker.error(
            'ContinueReading: Skipping invalid story entry from $sourceKey: $e',
          );
        }
      }
      return parsed;
    } catch (e) {
      talker.error('ContinueReading: Error parsing JSON from $sourceKey: $e');
      return <Story>[];
    }
  }

  Map<String, dynamic> _storyToMap(Story story) {
    return {
      'id': story.id,
      'user_id': story.authorId,
      'title': story.title,
      'content': story.story,
      'language': story.attributes.languageStyle,
      'image_url': story.imageUrl,
      'created_at': story.createdAt?.toIso8601String(),
      'updated_at': story.updatedAt?.toIso8601String(),
      'published_at': story.publishedAt?.toIso8601String(),
      'author': story.author,
      'likes': story.likes,
      'views': story.views,
      'is_favourite': story.isFavorite,
      'comment_count': story.commentCount,
      'share_count': story.shareCount,
      'attributes': {
        'scripture': story.scripture,
        'quotes': story.quotes,
        'trivia': story.trivia,
        'activity': story.activity,
        'moral': story.lesson,
        'story_type': story.attributes.storyType,
        'theme': story.attributes.theme,
        'main_character_type': story.attributes.mainCharacterType,
        'story_setting': story.attributes.storySetting,
        'time_era': story.attributes.timeEra,
        'narrative_perspective': story.attributes.narrativePerspective,
        'language_style': story.attributes.languageStyle,
        'emotional_tone': story.attributes.emotionalTone,
        'narrative_style': story.attributes.narrativeStyle,
        'plot_structure': story.attributes.plotStructure,
        'story_length': story.attributes.storyLength,
        'tags': story.attributes.tags,
        'references': story.attributes.references,
        'characters': story.attributes.characters,
        'character_details': story.attributes.characterDetails,
        'translations': story.attributes.translations.map(
          (key, value) => MapEntry(key, {
            'title': value.title,
            'story': value.story,
            'moral': value.moral,
            'lang': value.lang,
          }),
        ),
      },
    };
  }
}

Story mapSupabaseRowToStory(Map<String, dynamic> row) {
  final rawAttributes = row['attributes'];
  final attr = rawAttributes is Map
      ? rawAttributes.cast<String, dynamic>()
      : <String, dynamic>{};
  final characterDetails =
      (attr['character_details'] as Map?)?.cast<String, dynamic>() ??
      <String, dynamic>{};

  return Story(
    id: row['id']!.toString(),
    authorId: row['user_id']?.toString(),
    title: row['title']?.toString() ?? 'Untitled Story',
    story: row['content']?.toString() ?? row['story']?.toString() ?? '',
    scripture: attr['scripture']?.toString() ?? 'Scripture',
    quotes: attr['quotes']?.toString() ?? '',
    trivia: attr['trivia']?.toString() ?? '',
    activity: attr['activity']?.toString() ?? '',
    lesson: attr['moral']?.toString() ?? '',
    attributes: StoryAttributes(
      storyType: attr['story_type']?.toString() ?? 'General',
      theme: attr['theme']?.toString() ?? 'Dharma (Duty)',
      mainCharacterType:
          attr['main_character_type']?.toString() ?? 'Protagonist',
      storySetting: attr['story_setting']?.toString() ?? 'Ancient India',
      timeEra: attr['time_era']?.toString() ?? 'Ancient',
      narrativePerspective:
          attr['narrative_perspective']?.toString() ?? 'Third Person',
      languageStyle:
          row['language']?.toString() ??
          attr['language_style']?.toString() ??
          'English',
      emotionalTone: attr['emotional_tone']?.toString() ?? 'Inspirational',
      narrativeStyle: attr['narrative_style']?.toString() ?? 'Narrative',
      plotStructure: attr['plot_structure']?.toString() ?? 'Linear',
      storyLength: attr['story_length']?.toString() ?? 'Medium ~1000 words',
      tags: (attr['tags'] as List<dynamic>? ?? const [])
          .map((tag) => tag.toString())
          .toList(),
      references: (attr['references'] is List)
          ? (attr['references'] as List<dynamic>)
                .map((e) => e.toString())
                .toList()
          : [attr['references']?.toString() ?? ''],
      characters: (attr['characters'] as List<dynamic>? ?? const [])
          .map((char) => char.toString())
          .toList(),
      characterDetails: characterDetails,
      translations: _parseTranslations(attr['translations']),
    ),
    imageUrl: row['image_url']?.toString(),
    createdAt: row['created_at'] != null
        ? DateTime.tryParse(row['created_at'].toString())
        : null,
    updatedAt: row['updated_at'] != null
        ? DateTime.tryParse(row['updated_at'].toString())
        : null,
    publishedAt: row['published_at'] != null
        ? DateTime.tryParse(row['published_at'].toString())
        : null,
    author: row['author']?.toString(),
    likes: (row['likes'] is int)
        ? row['likes'] as int
        : (row['likes'] as num?)?.toInt() ?? 0,
    views: (row['views'] is int)
        ? row['views'] as int
        : (row['views'] as num?)?.toInt() ?? 0,
    isFavorite: row['is_favourite'] as bool? ?? false,
    commentCount: (row['comment_count'] as num?)?.toInt() ?? 0,
    shareCount: (row['share_count'] as num?)?.toInt() ?? 0,
  );
}

Map<String, TranslatedStory> _parseTranslations(dynamic raw) {
  if (raw == null) return <String, TranslatedStory>{};

  if (raw is Map) {
    final out = <String, TranslatedStory>{};

    for (final entry in raw.entries) {
      final lang = entry.key.toString();
      final val = entry.value;

      if (val == null) continue;

      if (val is Map<String, dynamic>) {
        out[lang] = TranslatedStory.fromJson(val);
        continue;
      }
      if (val is Map) {
        out[lang] = TranslatedStory.fromJson(Map<String, dynamic>.from(val));
        continue;
      }

      if (val is String) {
        try {
          final decoded = jsonDecode(val);
          if (decoded is Map) {
            out[lang] = TranslatedStory.fromJson(
              Map<String, dynamic>.from(decoded),
            );
          }
        } catch (_) {}
      }
    }

    return out;
  }

  return <String, TranslatedStory>{};
}
