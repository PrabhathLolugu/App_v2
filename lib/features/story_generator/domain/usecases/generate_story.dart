import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/errors/failures.dart';
import 'package:myitihas/core/usecases/usecase.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import '../entities/story_prompt.dart';
import '../entities/generator_options.dart';
import '../repositories/story_generator_repository.dart';

/// Use case for generating a story
@lazySingleton
class GenerateStory implements UseCase<Story, GenerateStoryParams> {
  final StoryGeneratorRepository repository;

  GenerateStory(this.repository);

  @override
  Future<Either<Failure, Story>> call(GenerateStoryParams params) async {
    return await repository.generateStory(
      prompt: params.prompt,
      options: params.options,
    );
  }
}

/// Parameters for generating a story
class GenerateStoryParams {
  final StoryPrompt prompt;
  final GeneratorOptions options;

  const GenerateStoryParams({required this.prompt, required this.options});
}
