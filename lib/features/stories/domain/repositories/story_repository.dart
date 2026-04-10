import 'package:fpdart/fpdart.dart';
import 'package:myitihas/core/errors/failures.dart';
import '../entities/story.dart';

abstract class StoryRepository {
  Future<Either<Failure, List<Story>>> getStories({
    String? searchQuery,
    String? sortBy,
    String? filterByType,
    String? filterByTheme,
    int? limit,
    int? offset,
  });

  Future<Either<Failure, Story>> getStoryById(String id);

  Future<Either<Failure, List<Story>>> getFavoriteStories();

  Future<Either<Failure, void>> toggleFavorite(String storyId);

  Future<Either<Failure, List<Story>>> getTrendingStories({int limit = 10});

  Future<Either<Failure, List<Story>>> getFeaturedStories({int limit = 5});

  Future<Either<Failure, List<Story>>> getStoriesByScripture(String scripture);

  Future<Either<Failure, List<Story>>> searchStories(String query);

  Future<Either<Failure, void>> cacheStories(List<Story> stories);

  Future<Either<Failure, List<Story>>> getCachedStories();
}
