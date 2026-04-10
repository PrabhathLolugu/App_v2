import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/errors/failures.dart';
import 'package:myitihas/core/usecases/usecase.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import '../repositories/story_generator_repository.dart';

@lazySingleton
class ExpandStory implements UseCase<String, ExpandStoryParams> {
  final StoryGeneratorRepository repository;

  ExpandStory(this.repository);

  @override
  Future<Either<Failure, String>> call(ExpandStoryParams params) async {
    return await repository.expandStory(
      story: params.story,
      currentChapter: params.currentChapter,
      storyLanguage: params.storyLanguage,
    );
  }
}

class ExpandStoryParams {
  final Story story;
  final int currentChapter;
  final String storyLanguage;

  const ExpandStoryParams({
    required this.story,
    required this.currentChapter,
    required this.storyLanguage,
  });
}
