import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/errors/failures.dart';
import 'package:myitihas/core/usecases/usecase.dart';
import '../entities/story_prompt.dart';
import '../repositories/story_generator_repository.dart';

/// Use case for getting random story options
@lazySingleton
class RandomizeOptions implements UseCase<StoryPrompt, NoParams> {
  final StoryGeneratorRepository repository;

  RandomizeOptions(this.repository);

  @override
  Future<Either<Failure, StoryPrompt>> call(NoParams params) async {
    return await repository.getRandomOptions();
  }
}
