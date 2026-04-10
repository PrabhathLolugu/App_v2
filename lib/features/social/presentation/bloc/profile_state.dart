import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myitihas/features/social/domain/entities/user.dart';
import 'package:myitihas/features/social/domain/entities/feed_item.dart';

part 'profile_state.freezed.dart';

@Freezed(toStringOverride: true)
sealed class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = ProfileInitial;

  const factory ProfileState.loading() = ProfileLoading;

  const factory ProfileState.loaded({
    required User user,
    @Default([]) List<User> followers,
    @Default([]) List<User> following,
    @Default(false) bool isLoadingFollowers,
    @Default(false) bool isLoadingFollowing,
    @Default(0) int currentTab,
    @Default([]) List<FeedItem> posts,
    @Default([]) List<FeedItem> scheduledPosts,
    @Default(false) bool isLoadingPosts,
    @Default(true) bool hasMorePosts,
    @Default({}) Map<String, List<FeedItem>> cachedPostsByType,
    @Default({}) Map<String, bool> hasMorePostsByType,
    String? followError,
  }) = ProfileLoaded;

  const factory ProfileState.error(String message) = ProfileError;

  const ProfileState._();

  @override
  String toString() {
    return map(
      initial: (_) => 'ProfileState.initial()',
      loading: (_) => 'ProfileState.loading()',
      loaded: (state) =>
          'ProfileState.loaded(user: ${state.user.username}, followers: ${state.followers.length})',
      error: (state) => 'ProfileState.error(message: "${state.message}")',
    );
  }
}
