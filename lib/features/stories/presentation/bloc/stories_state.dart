import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/story.dart';

part 'stories_state.freezed.dart';

@Freezed(toStringOverride: true)
class StoriesState with _$StoriesState {
  const factory StoriesState.initial() = _Initial;

  const factory StoriesState.loading() = _Loading;

  const factory StoriesState.loaded({
    required List<Story> stories,
    String? searchQuery,
    String? sortBy,
    String? filterType,
    String? filterTheme,
  }) = _Loaded;

  const factory StoriesState.error(String message) = _Error;

  const StoriesState._();

  @override
  String toString() {
    return map(
      initial: (_) => 'StoriesState.initial()',
      loading: (_) => 'StoriesState.loading()',
      loaded: (state) =>
          'StoriesState.loaded(stories: ${state.stories.length}, query: ${state.searchQuery})',
      error: (state) => 'StoriesState.error(message: "${state.message}")',
    );
  }
}
