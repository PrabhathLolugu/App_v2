import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/features/social/domain/entities/feed_item.dart';
import 'package:myitihas/features/social/domain/repositories/user_repository.dart';
import 'package:myitihas/features/social/domain/repositories/post_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

/// BLoC for managing user profiles
@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;
  final PostRepository postRepository;

  ProfileBloc({required this.userRepository, required this.postRepository})
    : super(const ProfileState.initial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<ToggleFollowEvent>(_onToggleFollow);
    on<ClearFollowErrorEvent>(_onClearFollowError);
    on<LoadFollowersEvent>(_onLoadFollowers);
    on<LoadFollowingEvent>(_onLoadFollowing);
    on<ChangeTabEvent>(_onChangeTab);
    on<LoadUserPostsEvent>(_onLoadUserPosts);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final logger = getIt<Talker>();
    logger.info('📱 [ProfileBloc] Loading profile for user: ${event.userId}');

    final currentState = state;
    final isRefresh = currentState is ProfileLoaded && currentState.user.id == event.userId;

    // When refreshing the same profile, don't emit loading() so posts and tab stay visible
    if (!isRefresh) {
      emit(const ProfileState.loading());
    }

    final result = await userRepository.getUserProfile(event.userId);

    await result.fold(
      (failure) async {
        logger.error(
          '❌ [ProfileBloc] Failed to load profile: ${failure.message}',
        );
        emit(ProfileState.error(failure.message));
      },
      (user) async {
        logger.info('✅ [ProfileBloc] Profile loaded successfully');
        logger.info('👤 [ProfileBloc] User: ${user.displayName}');
        logger.info('🖼️ [ProfileBloc] Avatar URL: "${user.avatarUrl}"');

        // Fetch post count
        final postCountResult = await postRepository.getUserPostCount(
          event.userId,
        );
        final postCount = postCountResult.fold(
          (failure) {
            logger.warning(
              '⚠️ [ProfileBloc] Failed to load post count: ${failure.message}',
            );
            return 0;
          },
          (count) {
            logger.info('📊 [ProfileBloc] Post count: $count');
            return count;
          },
        );

        // Update user with post count
        final updatedUser = user.copyWith(postCount: postCount);

        // Load scheduled posts only for own profile
        List<FeedItem> scheduledPosts = const [];
        final currentUserResult = await userRepository.getCurrentUser();
        final currentUserId = currentUserResult.fold((_) => null, (u) => u.id);
        if (currentUserId != null && event.userId == currentUserId) {
          final scheduledResult = await postRepository.getScheduledPostsForCurrentUser();
          scheduledPosts = scheduledResult.fold((_) => <FeedItem>[], (list) => list);
        }

        if (isRefresh) {
          // Preserve posts, currentTab, and other UI state so they don't vanish
          emit(currentState.copyWith(user: updatedUser, scheduledPosts: scheduledPosts));
        } else {
          emit(ProfileState.loaded(user: updatedUser, scheduledPosts: scheduledPosts));
        }
      },
    );
  }

  Future<void> _onToggleFollow(
    ToggleFollowEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final logger = getIt<Talker>();
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    final user = currentState.user;
    final isCurrentlyFollowing = user.isFollowing;

    final updatedUser = user.copyWith(
      isFollowing: !isCurrentlyFollowing,
      followerCount: isCurrentlyFollowing
          ? user.followerCount - 1
          : user.followerCount + 1,
    );

    emit(currentState.copyWith(user: updatedUser));

    final result = isCurrentlyFollowing
        ? await userRepository.unfollowUser(event.userId)
        : await userRepository.followUser(event.userId);

    result.fold((failure) {
      logger.warning(
        '[ProfileBloc] Follow/unfollow failed: ${failure.message}',
      );
      if (!emit.isDone) {
        emit(currentState.copyWith(
          user: user,
          followError: failure.message,
        ));
      }
    }, (_) {});

    if (result.isRight() && !emit.isDone) {
      final profileResult = await userRepository.getUserProfile(event.userId);
      profileResult.fold((failure) {}, (reloadedUser) {
        if (!emit.isDone) {
          emit(currentState.copyWith(user: reloadedUser));
        }
      });
    }
  }

  void _onClearFollowError(
    ClearFollowErrorEvent event,
    Emitter<ProfileState> emit,
  ) {
    final currentState = state;
    if (currentState is ProfileLoaded && currentState.followError != null) {
      emit(currentState.copyWith(followError: null));
    }
  }

  Future<void> _onLoadFollowers(
    LoadFollowersEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    emit(currentState.copyWith(isLoadingFollowers: true));

    final result = await userRepository.getFollowers(event.userId);

    result.fold(
      (failure) => emit(currentState.copyWith(isLoadingFollowers: false)),
      (followers) => emit(
        currentState.copyWith(followers: followers, isLoadingFollowers: false),
      ),
    );
  }

  Future<void> _onLoadFollowing(
    LoadFollowingEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    emit(currentState.copyWith(isLoadingFollowing: true));

    final result = await userRepository.getFollowing(event.userId);

    result.fold(
      (failure) => emit(currentState.copyWith(isLoadingFollowing: false)),
      (following) => emit(
        currentState.copyWith(following: following, isLoadingFollowing: false),
      ),
    );
  }

  Future<void> _onChangeTab(
    ChangeTabEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    final logger = getIt<Talker>();
    logger.info('🔄 [ProfileBloc] Changing to tab ${event.tabIndex}');

    emit(currentState.copyWith(currentTab: event.tabIndex, posts: []));
  }

  Future<void> _onLoadUserPosts(
    LoadUserPostsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    final logger = getIt<Talker>();
    logger.info(
      '📦 [ProfileBloc] Loading ${event.postType} posts for user ${event.userId}',
    );

    // Set loading state
    emit(
      currentState.copyWith(
        isLoadingPosts: true,
        posts: event.refresh ? [] : currentState.posts,
      ),
    );

    final offset = event.refresh ? 0 : currentState.posts.length;
    final result = event.postType == 'saved'
        ? await postRepository.getSavedPosts(limit: 20, offset: offset)
        : await postRepository.getUserPostsByType(
            userId: event.userId,
            postType: event.postType,
            limit: 20,
            offset: offset,
          );

    result.fold(
      (failure) {
        logger.error(
          '❌ [ProfileBloc] Failed to load posts: ${failure.message}',
        );
        emit(currentState.copyWith(isLoadingPosts: false));
      },
      (posts) {
        logger.info('✅ [ProfileBloc] Loaded ${posts.length} posts');
        final updatedPosts = event.refresh
            ? posts
            : [...currentState.posts, ...posts];
        emit(
          currentState.copyWith(
            posts: updatedPosts,
            isLoadingPosts: false,
            hasMorePosts: posts.length >= 20,
          ),
        );
      },
    );
  }
}
