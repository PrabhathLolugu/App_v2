import 'package:freezed_annotation/freezed_annotation.dart';

part 'stories_event.freezed.dart';

@freezed
sealed class StoriesEvent with _$StoriesEvent {
  const factory StoriesEvent.loadStories() = _LoadStories;

  const factory StoriesEvent.searchStories(String query) = _SearchStories;

  const factory StoriesEvent.sortStories(String sortBy) = _SortStories;

  const factory StoriesEvent.filterByType(String type) = _FilterByType;

  const factory StoriesEvent.filterByTheme(String theme) = _FilterByTheme;

  const factory StoriesEvent.toggleFavorite(String storyId) = _ToggleFavorite;

  const factory StoriesEvent.loadTrendingStories() = _LoadTrendingStories;

  const factory StoriesEvent.refreshStories() = _RefreshStories;
}
