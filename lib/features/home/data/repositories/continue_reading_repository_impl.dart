import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/errors/failures.dart';
import 'package:myitihas/features/home/data/datasources/continue_story_local_store.dart';
import 'package:myitihas/features/home/domain/repositories/continue_reading_repository.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';

@LazySingleton(as: ContinueReadingRepository)
class ContinueReadingRepositoryImpl implements ContinueReadingRepository {
  final ContinueStoryLocalStore _localStore;

  ContinueReadingRepositoryImpl(this._localStore);

  @override
  Future<Either<Failure, List<Story>>> getContinueReadingStories() async {
    try {
      final stories = _localStore.getStorys();
      return Right(stories);
    } catch (e) {
      return Left(
        CacheFailure(
          'Failed to fetch continue reading stories: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> addStoryToContinueReading(Story story) async {
    try {
      await _localStore.touch(story);
      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure(
          'Failed to add story to continue reading: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> removeStoryFromContinueReading(
    String storyId,
  ) async {
    try {
      await _localStore.remove(storyId);
      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure(
          'Failed to remove story from continue reading: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> clearContinueReading() async {
    try {
      await _localStore.clear();
      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure('Failed to clear continue reading: ${e.toString()}'),
      );
    }
  }
}
