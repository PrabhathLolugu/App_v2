import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/errors/failures.dart';
import 'package:myitihas/core/usecases/usecase.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import '../repositories/story_generator_repository.dart';

/// Use case for liking a story
@lazySingleton
class LikeStory implements UseCase<Story, LikeStoryParams> {
  final StoryGeneratorRepository repository;

  LikeStory(this.repository);

  @override
  Future<Either<Failure, Story>> call(LikeStoryParams params) async {
    return await repository.likeStory(
      params.story,
      params.isLiked,
    );
  }
}

/// Parameters for liking a story
class LikeStoryParams {
  final Story story;
  final bool isLiked;

  const LikeStoryParams({required this.story, required this.isLiked});
}
