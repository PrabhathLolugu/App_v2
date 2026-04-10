import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/errors/failures.dart';
import 'package:myitihas/core/usecases/usecase.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import '../repositories/story_generator_repository.dart';

@lazySingleton
class GetGeneratedStories
    implements UseCase<List<Story>, GetGeneratedStoriesParams> {
  final StoryGeneratorRepository repository;

  GetGeneratedStories(this.repository);

  @override
  Future<Either<Failure, List<Story>>> call(
    GetGeneratedStoriesParams params,
  ) async {
    return await repository.getGeneratedStories(
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class GetGeneratedStoriesParams {
  final int limit;
  final int offset;

  const GetGeneratedStoriesParams({this.limit = 10, this.offset = 0});
}
