import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/errors/failures.dart';
import 'package:myitihas/core/usecases/usecase.dart';
import '../entities/story.dart';
import '../repositories/story_repository.dart';

@lazySingleton
class GetStories implements UseCase<List<Story>, GetStoriesParams> {
  final StoryRepository repository;

  GetStories(this.repository);

  @override
  Future<Either<Failure, List<Story>>> call(GetStoriesParams params) async {
    return await repository.getStories(
      searchQuery: params.searchQuery,
      sortBy: params.sortBy,
      filterByType: params.filterByType,
      filterByTheme: params.filterByTheme,
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class GetStoriesParams {
  final String? searchQuery;
  final String? sortBy;
  final String? filterByType;
  final String? filterByTheme;
  final int? limit;
  final int? offset;

  GetStoriesParams({
    this.searchQuery,
    this.sortBy,
    this.filterByType,
    this.filterByTheme,
    this.limit,
    this.offset,
  });
}
