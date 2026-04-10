import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myitihas/features/social/domain/entities/feed_item.dart';
import 'package:myitihas/features/social/domain/entities/user.dart';
import 'package:myitihas/features/social/presentation/bloc/feed_event.dart';

part 'feed_state.freezed.dart';

@Freezed(toStringOverride: true)
sealed class FeedState with _$FeedState {
  const factory FeedState.initial() = FeedInitial;

  const factory FeedState.loading() = FeedLoading;

  const factory FeedState.loaded({
    required List<FeedItem> feedItems,
    required User currentUser,
    required bool hasMore,
    @Default(FeedType.stories) FeedType currentFeedType,
    @Default(false) bool isLoadingMore,
    @Default(true) bool isOnline,
    String? error,
    @Default(false) bool isOfflineError,
    /// Normalized hashtag without `#` (lowercase); null = show full feed.
    String? activeHashtag,
  }) = FeedLoaded;

  const factory FeedState.refreshing({
    required List<FeedItem> feedItems,
    required User currentUser,
    required bool hasMore,
    @Default(FeedType.stories) FeedType currentFeedType,
    String? activeHashtag,
  }) = FeedRefreshing;

  const factory FeedState.error(String message) = FeedError;

  const FeedState._();

  @override
  String toString() {
    return map(
      initial: (_) => 'FeedState.initial()',
      loading: (_) => 'FeedState.loading()',
      loaded: (state) =>
          'FeedState.loaded(feedItems: ${state.feedItems.length}, feedType: ${state.currentFeedType}, hasMore: ${state.hasMore})',
      refreshing: (state) =>
          'FeedState.refreshing(feedItems: ${state.feedItems.length})',
      error: (state) => 'FeedState.error(message: "${state.message}")',
    );
  }
}
