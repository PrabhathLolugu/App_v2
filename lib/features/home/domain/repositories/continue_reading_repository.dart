import 'package:fpdart/fpdart.dart';
import 'package:myitihas/core/errors/failures.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';

/// Repository interface for continue reading functionality
abstract class ContinueReadingRepository {
  /// Get all stories in the continue reading list
  Future<Either<Failure, List<Story>>> getContinueReadingStories();

  /// Add a story to the continue reading list
  /// If the story already exists, it will be moved to the top (most recent)
  Future<Either<Failure, void>> addStoryToContinueReading(Story story);

  /// Remove a story from the continue reading list
  Future<Either<Failure, void>> removeStoryFromContinueReading(String storyId);

  /// Clear all stories from the continue reading list
  Future<Either<Failure, void>> clearContinueReading();
}
