import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/errors/failures.dart';
import 'package:myitihas/core/usecases/usecase.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/features/story_generator/domain/repositories/story_generator_repository.dart';

@lazySingleton
class UpdateGeneratedStory implements UseCase<Story, Story> {
  final StoryGeneratorRepository repository;

  UpdateGeneratedStory(this.repository);

  @override
  Future<Either<Failure, Story>> call(Story story) async {
    return await repository.updateStory(story);
  }
}
