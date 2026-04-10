import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myitihas/features/festivals/domain/entities/hindu_festival.dart';
import 'package:myitihas/features/home/domain/entities/quote.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/pages/map2/Model/sacred_location.dart';

part 'home_state.freezed.dart';

/// State for HomeBloc
@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    /// Whether the home screen is loading
    @Default(false) bool isLoading,

    /// Whether a refresh is in progress
    @Default(false) bool isRefreshing,

    /// Quote of the day
    Quote? quote,

    /// Whether quote is loading
    @Default(false) bool isQuoteLoading,

    /// Featured stories
    @Default([]) List<Story> featuredStories,

    /// Whether featured stories are loading
    @Default(false) bool isFeaturedLoading,

    /// Stories in progress (continue reading)
    @Default([]) List<Story> continueReading,

    /// Whether continue reading is loading
    @Default(false) bool isContinueReadingLoading,

    /// Saved/bookmarked stories
    @Default([]) List<Story> savedStories,

    /// Whether saved stories are loading
    @Default(false) bool isSavedStoriesLoading,

    /// User's generated stories
    @Default([]) List<Story> myGeneratedStories,

    /// Whether generated stories are loading
    @Default(false) bool isMyGeneratedStoriesLoading,

    /// Error message if any
    String? errorMessage,

    /// Time-based greeting key
    @Default('morning') String greetingKey,

    /// User's display name
    String? userName,

    /// Sacred locations for "Where to Visit" section
    @Default([]) List<SacredLocation> sacredLocations,

    /// Whether sacred locations are loading
    @Default(false) bool isSacredLocationsLoading,

    /// Sanatan festivals for the Festival Stories section
    @Default([]) List<HinduFestival> festivals,

    /// Whether festivals are loading
    @Default(false) bool isFestivalsLoading,
  }) = _HomeState;

  const HomeState._();

  /// Whether any section is still loading
  bool get hasLoadingSection =>
      isQuoteLoading ||
      isFeaturedLoading ||
      isContinueReadingLoading ||
      isSavedStoriesLoading ||
      isMyGeneratedStoriesLoading ||
      isSacredLocationsLoading ||
      isFestivalsLoading;

  /// Whether the home screen has any content
  bool get hasContent =>
      quote != null ||
      featuredStories.isNotEmpty ||
      continueReading.isNotEmpty ||
      savedStories.isNotEmpty ||
      myGeneratedStories.isNotEmpty ||
      sacredLocations.isNotEmpty ||
      festivals.isNotEmpty;
}
