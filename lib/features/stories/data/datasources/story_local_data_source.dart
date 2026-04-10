import 'package:injectable/injectable.dart';
import 'package:myitihas/core/errors/exceptions.dart';
import '../models/story_model.dart';
import 'story_mock_data_source.dart';

abstract class StoryLocalDataSource {
  Future<List<StoryModel>> getCachedStories();
  Future<void> cacheStories(List<StoryModel> stories);
  Future<StoryModel?> getCachedStoryById(String id);
  Future<void> cacheStory(StoryModel story);
  Future<List<StoryModel>> getFavoriteStories();
  Future<void> toggleFavorite(String storyId);
  Future<void> clearCache();
}

@LazySingleton(as: StoryLocalDataSource)
class StoryLocalDataSourceImpl implements StoryLocalDataSource {
  final StoryMockDataSource mockDataSource;

  StoryLocalDataSourceImpl(this.mockDataSource);

  @override
  Future<List<StoryModel>> getCachedStories() async {
    // Stub: Return mock data directly (Brick handles actual caching)
    try {
      final stories = await mockDataSource.getStoriesFromAssets();
      return stories;
    } catch (e) {
      throw CacheException('Failed to get cached stories: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheStories(List<StoryModel> stories) async {
    // Stub: No-op (Brick handles caching)
  }

  @override
  Future<StoryModel?> getCachedStoryById(String id) async {
    // Stub: Try to find in mock data
    try {
      final stories = await mockDataSource.getStoriesFromAssets();
      return stories.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheStory(StoryModel story) async {
    // Stub: No-op (Brick handles caching)
  }

  @override
  Future<List<StoryModel>> getFavoriteStories() async {
    // Stub: Return empty (Brick handles this through repository)
    return [];
  }

  @override
  Future<void> toggleFavorite(String storyId) async {
    // Stub: No-op (Brick handles this through repository)
  }

  @override
  Future<void> clearCache() async {
    // Stub: No-op (Brick handles cache clearing)
  }
}
