import 'dart:convert';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/features/stories/data/models/story_model.dart';
import 'package:myitihas/core/logging/talker_setup.dart';

class DownloadedStoriesService {
  static const String _storageKey = 'downloaded_stories';

  static final DownloadedStoriesService _instance = DownloadedStoriesService._internal();

  factory DownloadedStoriesService() {
    return _instance;
  }

  DownloadedStoriesService._internal();

  /// Save a story locally and cache its main image.
  Future<void> saveStory(Story story) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> savedStoriesJson = prefs.getStringList(_storageKey) ?? [];

      // Check if already downloaded
      final isAlreadyDownloaded = savedStoriesJson.any((jsonStr) {
        final Map<String, dynamic> map = jsonDecode(jsonStr);
        return map['id'] == story.id;
      });

      if (!isAlreadyDownloaded) {
        final storyModel = StoryModel.fromEntity(story);
        savedStoriesJson.add(jsonEncode(storyModel.toJson()));
        await prefs.setStringList(_storageKey, savedStoriesJson);
      }

      // Cache the image for offline use if it exists
      if (story.imageUrl != null && story.imageUrl!.isNotEmpty) {
        await DefaultCacheManager().downloadFile(story.imageUrl!);
      }
      talker.info('Story "${story.id}" saved successfully for offline reading.');
    } catch (e) {
      talker.error('Error saving story for offline reading', e);
      throw Exception('Failed to save story locally');
    }
  }

  /// Retrieve all downloaded stories
  Future<List<Story>> getDownloadedStories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> savedStoriesJson = prefs.getStringList(_storageKey) ?? [];
      
      return savedStoriesJson.map((jsonStr) {
        return StoryModel.fromJson(jsonDecode(jsonStr)).toEntity();
      }).toList();
    } catch (e) {
      talker.error('Error retrieving downloaded stories', e);
      return [];
    }
  }

  /// Delete a specific downloaded story
  Future<void> deleteDownloadedStory(String storyId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> savedStoriesJson = prefs.getStringList(_storageKey) ?? [];
      
      final updatedStoriesJson = savedStoriesJson.where((jsonStr) {
        final Map<String, dynamic> map = jsonDecode(jsonStr);
        return map['id'] != storyId;
      }).toList();

      await prefs.setStringList(_storageKey, updatedStoriesJson);
      talker.info('Story "$storyId" deleted from offline storage.');
    } catch (e) {
      talker.error('Error deleting downloaded story', e);
    }
  }

  /// Clear all downloaded stories (should be called on logout)
  Future<void> clearAllDownloadedStories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
      talker.info('All downloaded stories cleared.');
    } catch (e) {
      talker.error('Error clearing all downloaded stories', e);
    }
  }

  /// Check if a story is downloaded
  Future<bool> isStoryDownloaded(String storyId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> savedStoriesJson = prefs.getStringList(_storageKey) ?? [];
      
      return savedStoriesJson.any((jsonStr) {
        final Map<String, dynamic> map = jsonDecode(jsonStr);
        return map['id'] == storyId;
      });
    } catch (e) {
      return false;
    }
  }
}
