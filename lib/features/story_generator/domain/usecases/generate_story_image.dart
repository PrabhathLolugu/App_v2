import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/errors/failures.dart';
import 'package:myitihas/core/usecases/usecase.dart';
import 'package:myitihas/features/story_generator/domain/repositories/story_generator_repository.dart';

@lazySingleton
class GenerateStoryImage implements UseCase<String, GenerateStoryImageParams> {
  final StoryGeneratorRepository repository;

  GenerateStoryImage(this.repository);

  @override
  Future<Either<Failure, String>> call(GenerateStoryImageParams params) async {
    return await repository.generateStoryImage(
      title: params.title,
      story: params.story,
      moral: params.moral,
    );
  }
}

class GenerateStoryImageParams {
  final String title;
  final String story;
  final String moral;

  GenerateStoryImageParams({
    required this.title,
    required this.story,
    required this.moral,
  });
}
