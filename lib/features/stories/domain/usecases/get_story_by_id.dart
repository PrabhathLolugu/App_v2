import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/errors/failures.dart';
import 'package:myitihas/core/usecases/usecase.dart';
import '../entities/story.dart';
import '../repositories/story_repository.dart';

@lazySingleton
class GetStoryById implements UseCase<Story, String> {
  final StoryRepository repository;

  GetStoryById(this.repository);

  @override
  Future<Either<Failure, Story>> call(String id) async {
    return await repository.getStoryById(id);
  }
}
