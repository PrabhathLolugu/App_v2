import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/cache/services/prefetch_service.dart';
import 'package:myitihas/core/logging/talker_setup.dart';
import '../../domain/usecases/get_stories.dart';
import '../../domain/usecases/toggle_favorite.dart';
import 'stories_event.dart';
import 'stories_state.dart';

export 'stories_event.dart';
export 'stories_state.dart';

@injectable
class StoriesBloc extends Bloc<StoriesEvent, StoriesState> {
  final GetStories getStories;
  final ToggleFavorite toggleFavorite;
  final PrefetchService prefetchService;

  StoriesBloc({
    required this.getStories,
    required this.toggleFavorite,
    required this.prefetchService,
  }) : super(const StoriesState.initial()) {
    on<StoriesEvent>((event, emit) async {
      await event.when(
        loadStories: () => _onLoadStories(emit),
        searchStories: (query) => _onSearchStories(query, emit),
        sortStories: (sortBy) => _onSortStories(sortBy, emit),
        filterByType: (type) => _onFilterByType(type, emit),
        filterByTheme: (theme) => _onFilterByTheme(theme, emit),
        toggleFavorite: (storyId) => _onToggleFavorite(storyId, emit),
        loadTrendingStories: () => _onLoadTrendingStories(emit),
        refreshStories: () => _onRefreshStories(emit),
      );
    });
  }

  Future<void> _onLoadStories(Emitter<StoriesState> emit) async {
    emit(const StoriesState.loading());
    talker.info('Loading stories...');

    final result = await getStories(GetStoriesParams());

    result.fold(
      (failure) {
        talker.error('Failed to load stories: ${failure.message}');
        emit(StoriesState.error(failure.message));
      },
      (stories) {
        talker.info('Loaded ${stories.length} stories');
        emit(StoriesState.loaded(stories: stories));
      },
    );
  }

  Future<void> _onLoadTrendingStories(Emitter<StoriesState> emit) async {
    emit(const StoriesState.loading());
    talker.info('Loading trending stories...');

    final result = await getStories(GetStoriesParams(limit: 10));

    result.fold(
      (failure) {
        talker.error('Failed to load trending stories: ${failure.message}');
        emit(StoriesState.error(failure.message));
      },
      (stories) {
        talker.info('Loaded ${stories.length} trending stories');
        emit(StoriesState.loaded(stories: stories));
      },
    );
  }

  Future<void> _onSearchStories(
    String query,
    Emitter<StoriesState> emit,
  ) async {
    emit(const StoriesState.loading());
    talker.info('Searching stories with query: $query');

    final result = await getStories(GetStoriesParams(searchQuery: query));

    result.fold(
      (failure) {
        talker.error('Failed to search stories: ${failure.message}');
        emit(StoriesState.error(failure.message));
      },
      (stories) {
        talker.info('Found ${stories.length} stories');
        emit(StoriesState.loaded(stories: stories, searchQuery: query));
      },
    );
  }

  Future<void> _onSortStories(String sortBy, Emitter<StoriesState> emit) async {
    await state.whenOrNull(
      loaded:
          (stories, searchQuery, currentSortBy, filterType, filterTheme) async {
            emit(const StoriesState.loading());
            talker.info('Sorting stories by: $sortBy');

            final result = await getStories(
              GetStoriesParams(
                sortBy: sortBy,
                searchQuery: searchQuery,
                filterByType: filterType,
                filterByTheme: filterTheme,
              ),
            );

            result.fold(
              (failure) {
                talker.error('Failed to sort stories: ${failure.message}');
                emit(StoriesState.error(failure.message));
              },
              (stories) {
                talker.info('Sorted ${stories.length} stories');
                emit(
                  StoriesState.loaded(
                    stories: stories,
                    sortBy: sortBy,
                    searchQuery: searchQuery,
                    filterType: filterType,
                    filterTheme: filterTheme,
                  ),
                );
              },
            );
          },
    );
  }

  Future<void> _onFilterByType(String type, Emitter<StoriesState> emit) async {
    await state.whenOrNull(
      loaded: (stories, searchQuery, sortBy, filterType, filterTheme) async {
        emit(const StoriesState.loading());
        talker.info('Filtering stories by type: $type');

        final result = await getStories(
          GetStoriesParams(
            filterByType: type,
            sortBy: sortBy,
            searchQuery: searchQuery,
            filterByTheme: filterTheme,
          ),
        );

        result.fold(
          (failure) {
            talker.error('Failed to filter stories: ${failure.message}');
            emit(StoriesState.error(failure.message));
          },
          (stories) {
            talker.info('Filtered ${stories.length} stories');
            emit(
              StoriesState.loaded(
                stories: stories,
                filterType: type,
                sortBy: sortBy,
                searchQuery: searchQuery,
                filterTheme: filterTheme,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onFilterByTheme(
    String theme,
    Emitter<StoriesState> emit,
  ) async {
    await state.whenOrNull(
      loaded: (stories, searchQuery, sortBy, filterType, filterTheme) async {
        emit(const StoriesState.loading());
        talker.info('Filtering stories by theme: $theme');

        final result = await getStories(
          GetStoriesParams(
            filterByTheme: theme,
            sortBy: sortBy,
            searchQuery: searchQuery,
            filterByType: filterType,
          ),
        );

        result.fold(
          (failure) {
            talker.error('Failed to filter stories: ${failure.message}');
            emit(StoriesState.error(failure.message));
          },
          (stories) {
            talker.info('Filtered ${stories.length} stories');
            emit(
              StoriesState.loaded(
                stories: stories,
                filterTheme: theme,
                sortBy: sortBy,
                searchQuery: searchQuery,
                filterType: filterType,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onToggleFavorite(
    String storyId,
    Emitter<StoriesState> emit,
  ) async {
    await state.whenOrNull(
      loaded: (stories, searchQuery, sortBy, filterType, filterTheme) async {
        talker.info('Toggling favorite for story: $storyId');

        final result = await toggleFavorite(storyId);

        result.fold(
          (failure) {
            talker.error('Failed to toggle favorite: ${failure.message}');
          },
          (_) {
            talker.info('Favorite toggled successfully');
            final updatedStories = stories.map((story) {
              if (story.id == storyId) {
                return story.copyWith(isFavorite: !story.isFavorite);
              }
              return story;
            }).toList();

            emit(
              StoriesState.loaded(
                stories: updatedStories,
                sortBy: sortBy,
                searchQuery: searchQuery,
                filterType: filterType,
                filterTheme: filterTheme,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onRefreshStories(Emitter<StoriesState> emit) async {
    talker.info('Refreshing stories...');

    String? searchQuery;
    String? sortBy;
    String? filterType;
    String? filterTheme;

    state.whenOrNull(
      loaded: (stories, sq, sb, ft, fth) {
        searchQuery = sq;
        sortBy = sb;
        filterType = ft;
        filterTheme = fth;
      },
    );

    final result = await getStories(
      GetStoriesParams(
        sortBy: sortBy,
        searchQuery: searchQuery,
        filterByType: filterType,
        filterByTheme: filterTheme,
      ),
    );

    result.fold(
      (failure) {
        talker.error('Failed to refresh stories: ${failure.message}');
        emit(StoriesState.error(failure.message));
      },
      (stories) {
        talker.info('Refreshed ${stories.length} stories');
        emit(
          StoriesState.loaded(
            stories: stories,
            sortBy: sortBy,
            searchQuery: searchQuery,
            filterType: filterType,
            filterTheme: filterTheme,
          ),
        );
      },
    );
  }
}
