import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/errors/failures.dart';
import 'package:myitihas/core/usecases/usecase.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import '../repositories/story_generator_repository.dart';

@lazySingleton
class GetCharacterDetails
    implements UseCase<Map<String, dynamic>, GetCharacterDetailsParams> {
  final StoryGeneratorRepository repository;

  GetCharacterDetails(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
    GetCharacterDetailsParams params,
  ) async {
    return await repository.getCharacterDetails(
      story: params.story,
      characterName: params.characterName,
      currentChapter: params.currentChapter,
      storyLanguage: params.storyLanguage,
    );
  }
}

class GetCharacterDetailsParams {
  final Story story;
  final String characterName;
  final int currentChapter;
  final String storyLanguage;

  const GetCharacterDetailsParams({
    required this.story,
    required this.characterName,
    required this.currentChapter,
    required this.storyLanguage,
  });
}
