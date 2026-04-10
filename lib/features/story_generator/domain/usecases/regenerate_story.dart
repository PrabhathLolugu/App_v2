import 'package:fpdart/fpdart.dart';
import 'package:myitihas/core/errors/failures.dart';
import 'package:myitihas/core/usecases/usecase.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/features/story_generator/domain/entities/story_prompt.dart';
import 'package:myitihas/features/story_generator/domain/entities/generator_options.dart';
import 'package:myitihas/features/story_generator/domain/repositories/story_generator_repository.dart';

class RegenerateStory implements UseCase<Story, RegenerateStoryParams> {
  final StoryGeneratorRepository repository;

  RegenerateStory(this.repository);

  @override
  Future<Either<Failure, Story>> call(RegenerateStoryParams params) async {
    try {
      final regenStory = await repository.regenerateStory(
        original: params.original,
        prompt: params.prompt,
        options: params.options,
      );

      return regenStory;
    } catch (e) {
      return Left(ServerFailure('Failed to regenerate story: ${e.toString()}'));
    }
  }
}

class RegenerateStoryParams {
  final Story original;
  final StoryPrompt prompt;
  final GeneratorOptions options;

  RegenerateStoryParams({
    required this.original,
    required this.prompt,
    required this.options,
  });
}
