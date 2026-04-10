import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_event.freezed.dart';

/// Events for HomeBloc
@freezed
sealed class HomeEvent with _$HomeEvent {
  /// Load all home screen data
  const factory HomeEvent.loadHome() = _LoadHome;

  /// Refresh home screen data
  const factory HomeEvent.refresh() = _Refresh;

  /// Load quote of the day
  const factory HomeEvent.loadQuote() = _LoadQuote;

  /// Load featured stories
  const factory HomeEvent.loadFeaturedStories() = _LoadFeaturedStories;

  /// Load continue reading stories
  const factory HomeEvent.loadContinueReading() = _LoadContinueReading;

  /// Load saved/bookmarked stories
  const factory HomeEvent.loadSavedStories() = _LoadSavedStories;

  /// Load user's generated stories
  const factory HomeEvent.loadMyGeneratedStories() = _LoadMyGeneratedStories;

  /// Refetch story lists without toggling section shimmer (e.g. after closing story detail).
  const factory HomeEvent.reloadStorySectionsQuietly() =
      _ReloadStorySectionsQuietly;

  /// Share quote
  const factory HomeEvent.shareQuote() = _ShareQuote;

  /// Copy quote to clipboard
  const factory HomeEvent.copyQuote() = _CopyQuote;
}
