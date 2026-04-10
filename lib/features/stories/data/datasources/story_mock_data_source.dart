import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/errors/exceptions.dart';
import '../models/story_model.dart';

@LazySingleton()
class StoryMockDataSource {
  List<StoryModel>? _cachedStories;
  final Random _random = Random();

  // Mock image URLs for story backgrounds
  static const List<String> _storyImageUrls = [
    'https://images.unsplash.com/photo-1609619385002-f40f8e7c8945?w=800', // Temple
    'https://images.unsplash.com/photo-1545126178-862cdb469409?w=800', // Ganges
    'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?w=800', // Taj Mahal
    'https://images.unsplash.com/photo-1561361513-2d000a50f0dc?w=800', // Hindu temple
    'https://images.unsplash.com/photo-1544006659-f0b21884ce1d?w=800', // Varanasi
    'https://images.unsplash.com/photo-1590077428593-a55bb07c4665?w=800', // Diya lamps
    'https://images.unsplash.com/photo-1600093463592-8e36ae95ef56?w=800', // Temple interior
    'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?w=800', // Hampi
    'https://images.unsplash.com/photo-1593693397690-362cb9666fc2?w=800', // Temple at sunset
    'https://images.unsplash.com/photo-1604508155216-b0e0f0a02911?w=800', // Khajuraho
    'https://images.unsplash.com/photo-1548013146-72479768bada?w=800', // Indian architecture
    'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=800', // Sacred place
  ];

  Future<List<StoryModel>> getStoriesFromAssets() async {
    if (_cachedStories != null) {
      return _cachedStories!;
    }

    try {
      final String jsonString = await rootBundle.loadString(
        'docs/dataset.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);

      _cachedStories = jsonList.map((json) {
        final id = json['id'] ?? _generateId();

        final attributesJson = json['attributes'] ?? {};
        final attributes = _parseAttributes(attributesJson);

        final likes = _random.nextInt(1000);
        final views = likes + _random.nextInt(500);
        final publishedAt = DateTime.now().subtract(
          Duration(days: _random.nextInt(365)),
        );

        return StoryModel(
          id: id,
          title: _toStringValue(json['title']) == '' ? 'Untitled Story' : _toStringValue(json['title']),
          scripture: _toStringValue(json['scripture']) == '' ? 'Unknown Scripture' : _toStringValue(json['scripture']),
          story: _toStringValue(json['story']),
          quotes: _toStringValue(json['quotes']),
          trivia: _toStringValue(json['trivia']),
          activity: _toStringValue(json['activity']),
          lesson: _toStringValue(json['lesson']),
          attributes: attributes,
          imageUrl:
              json['image'] is String
                  ? json['image'] as String
                  : _storyImageUrls[_random.nextInt(_storyImageUrls.length)],
          author: null,
          publishedAt: publishedAt,
          likes: likes,
          views: views,
          isFavorite: false,
        );
      }).toList();

      return _cachedStories!;
    } catch (e) {
      throw CacheException(
        'Failed to load stories from assets: ${e.toString()}',
      );
    }
  }

  String _generateId() {
    return 'story_${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(10000)}';
  }

  /// Coerces a JSON value to String (handles List from dataset.json).
  static String _toStringValue(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is List) {
      return value.map((e) => e?.toString() ?? '').join('\n');
    }
    return value.toString();
  }

  StoryAttributesModel _parseAttributes(Map<String, dynamic> json) {
    return StoryAttributesModel(
      storyType: json['storyType'] ?? 'Scriptural',
      theme: json['theme'] ?? 'Devotion',
      mainCharacterType: json['mainCharacterType'] ?? 'Divine',
      storySetting: json['storySetting'] ?? 'Ancient India',
      timeEra: json['timeEra'] ?? 'Vedic Period',
      narrativePerspective: json['narrativePerspective'] ?? 'Third Person',
      languageStyle: json['languageStyle'] ?? 'Traditional',
      emotionalTone: json['emotionalTone'] ?? 'Inspirational',
      narrativeStyle: json['narrativeStyle'] ?? 'Descriptive',
      plotStructure: json['plotStructure'] ?? 'Linear',
      storyLength: json['storyLength'] ?? 'Medium',
      references:
          (json['references'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
    );
  }

  void clearCache() {
    _cachedStories = null;
  }
}
