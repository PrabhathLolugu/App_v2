import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/errors/failures.dart';
import 'package:myitihas/core/usecases/usecase.dart';
import '../repositories/story_repository.dart';

@lazySingleton
class ToggleFavorite implements UseCase<void, String> {
  final StoryRepository repository;

  ToggleFavorite(this.repository);

  @override
  Future<Either<Failure, void>> call(String storyId) async {
    return await repository.toggleFavorite(storyId);
  }
}
