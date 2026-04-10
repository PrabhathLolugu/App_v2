import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/logging/talker_setup.dart';
import 'package:myitihas/features/festivals/domain/entities/hindu_festival.dart';
import 'package:myitihas/features/home/data/datasources/quote_local_datasource.dart';
import 'package:myitihas/features/home/presentation/bloc/home_event.dart';
import 'package:myitihas/features/home/presentation/bloc/home_state.dart';
import 'package:myitihas/features/social/domain/repositories/user_repository.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/features/stories/domain/repositories/story_repository.dart';
import 'package:myitihas/features/story_generator/domain/repositories/story_generator_repository.dart';
import 'package:myitihas/features/home/domain/repositories/continue_reading_repository.dart';
import 'package:myitihas/pages/map2/Model/sacred_location.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// BLoC for HomeScreen state management
@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final QuoteLocalDataSource _quoteDataSource;
  final StoryRepository _storyRepository;
  final StoryGeneratorRepository _storyGeneratorRepository;
  final UserRepository _userRepository;
  final ContinueReadingRepository _continueReadingRepository;

  final _supabase = Supabase.instance.client;

  HomeBloc(
    this._quoteDataSource,
    this._storyRepository,
    this._storyGeneratorRepository,
    this._userRepository,
    this._continueReadingRepository,
  ) : super(const HomeState()) {
    on<HomeEvent>((event, emit) async {
      await event.when(
        loadHome: () => _onLoadHome(emit),
        refresh: () => _onRefresh(emit),
        loadQuote: () => _onLoadQuote(emit),
        loadFeaturedStories: () => _onLoadFeaturedStories(emit),
        loadContinueReading: () => _onLoadContinueReading(emit),
        loadSavedStories: () => _onLoadSavedStories(emit),
        loadMyGeneratedStories: () => _onLoadMyGeneratedStories(emit),
        reloadStorySectionsQuietly: () => _onReloadStorySectionsQuietly(emit),
        shareQuote: () => _onShareQuote(emit),
        copyQuote: () => _onCopyQuote(emit),
      );
    });
  }

  /// Load all home screen data
  Future<void> _onLoadHome(Emitter<HomeState> emit) async {
    // Set ALL loading flags to true initially
    emit(
      state.copyWith(
        isLoading: true,
        isQuoteLoading: true,
        isFeaturedLoading: true,
        isContinueReadingLoading: true,
        isSavedStoriesLoading: true,
        isMyGeneratedStoriesLoading: true,
        isSacredLocationsLoading: true,
        isFestivalsLoading: true,
        greetingKey: _getGreetingKey(),
      ),
    );

    // Load all sections in parallel
    await Future.wait([
      _loadQuote(emit),
      _loadContinueReading(emit),
      _loadFeaturedStories(emit),
      _loadSavedStories(emit),
      _loadMyGeneratedStories(emit),
      _loadSacredLocations(emit),
      _loadFestivals(emit),
      _loadUserName(emit),
    ]);

    // Set ALL loading flags to false finally
    emit(
      state.copyWith(
        isLoading: false,
        isQuoteLoading: false,
        isFeaturedLoading: false,
        isContinueReadingLoading: false,
        isSavedStoriesLoading: false,
        isMyGeneratedStoriesLoading: false,
        isSacredLocationsLoading: false,
        isFestivalsLoading: false,
      ),
    );
  }

  /// Refresh home screen data
  Future<void> _onRefresh(Emitter<HomeState> emit) async {
    emit(
      state.copyWith(
        isRefreshing: true,
        // Also set loading flags for refresh to ensure UI updates if needed
        isQuoteLoading: true,
        isFeaturedLoading: true,
        isContinueReadingLoading: true,
        isSavedStoriesLoading: true,
        isMyGeneratedStoriesLoading: true,
        isSacredLocationsLoading: true,
        isFestivalsLoading: true,
      ),
    );

    await Future.wait([
      _loadQuote(emit),
      _loadContinueReading(emit),
      _loadFeaturedStories(emit),
      _loadSavedStories(emit),
      _loadMyGeneratedStories(emit),
      _loadSacredLocations(emit),
      _loadFestivals(emit),
      _loadUserName(emit),
    ]);

    emit(
      state.copyWith(
        isRefreshing: false,
        isQuoteLoading: false,
        isFeaturedLoading: false,
        isContinueReadingLoading: false,
        isSavedStoriesLoading: false,
        isMyGeneratedStoriesLoading: false,
        isSacredLocationsLoading: false,
        isFestivalsLoading: false,
      ),
    );
  }

  /// Load quote of the day
  Future<void> _onLoadQuote(Emitter<HomeState> emit) async {
    emit(state.copyWith(isQuoteLoading: true));
    await _loadQuote(emit);
    emit(state.copyWith(isQuoteLoading: false));
  }

  Future<void> _loadQuote(Emitter<HomeState> emit) async {
    try {
      final quote = await _quoteDataSource.getQuoteOfTheDay();
      emit(state.copyWith(quote: quote));
    } catch (e, st) {
      talker.error('Failed to load quote', e, st);
    }
  }

  /// Load featured stories
  Future<void> _onLoadFeaturedStories(Emitter<HomeState> emit) async {
    emit(state.copyWith(isFeaturedLoading: true));
    await _loadFeaturedStories(emit);
    emit(state.copyWith(isFeaturedLoading: false));
  }

  Future<void> _loadFeaturedStories(Emitter<HomeState> emit) async {
    try {
      final result = await _storyRepository.getFeaturedStories(limit: 6);
      result.fold(
        (failure) {
          talker.error('Failed to load featured stories: ${failure.message}');
          emit(state.copyWith(featuredStories: []));
        },
        (stories) {
          final filtered = stories
              .where(
                (s) =>
                    s.imageUrl != null && s.imageUrl!.trim().isNotEmpty,
              )
              .toList();
          emit(state.copyWith(featuredStories: filtered));
        },
      );
    } catch (e, st) {
      talker.error('Failed to load featured stories', e, st);
      emit(state.copyWith(featuredStories: []));
    }
  }

  /// Refetch thumbnails without section shimmer (after story detail closes).
  Future<void> _onReloadStorySectionsQuietly(Emitter<HomeState> emit) async {
    await Future.wait([
      _loadContinueReading(emit),
      _loadSavedStories(emit),
      _loadMyGeneratedStories(emit),
    ]);
  }

  /// Load continue reading section
  Future<void> _onLoadContinueReading(Emitter<HomeState> emit) async {
    emit(state.copyWith(isContinueReadingLoading: true));
    await _loadContinueReading(emit);
    emit(state.copyWith(isContinueReadingLoading: false));
  }

  Future<void> _loadContinueReading(Emitter<HomeState> emit) async {
    try {
      // 1. Fetch full Story objects from our new repository
      final result = await _continueReadingRepository
          .getContinueReadingStories();

      final stories = result.fold((_) => <Story>[], (stories) => stories);
      
      // Deduplicate stories by ID and Title
      final uniqueStories = <String, Story>{};
      for (final story in stories) {
        if (story.title.toLowerCase() == 'untitled story') continue;
        
        // Use a composite key for robust deduplication
        final key = '${story.id}_${story.title}';
        if (!uniqueStories.containsKey(key)) {
          uniqueStories[key] = story;
        }
      }

      final deduped = uniqueStories.values.toList();
      // Local prefs often omit image_url; merge from canonical remote story record.
      final merged = await Future.wait(
        deduped.map(_mergeRemoteStoryImage),
      );

      emit(state.copyWith(continueReading: merged));
    } catch (e, st) {
      talker.error('Failed to load continue reading', e, st);
    }
  }

  /// Prefer remote image when present so list tiles match server / Supabase storage.
  String? _preferNonEmptyImage(String? primary, String? fallback) {
    if (primary != null && primary.trim().isNotEmpty) return primary.trim();
    if (fallback != null && fallback.trim().isNotEmpty) return fallback.trim();
    return primary ?? fallback;
  }

  Future<Story> _mergeRemoteStoryImage(Story local) async {
    final result = await _storyRepository.getStoryById(local.id);
    return result.fold(
      (_) => local,
      (remote) => local.copyWith(
        imageUrl: _preferNonEmptyImage(remote.imageUrl, local.imageUrl),
      ),
    );
  }

  /// Refresh cover URLs for rows missing them (Brick/local can omit imageUrl).
  Future<List<Story>> _hydrateMissingStoryImages(
    List<Story> stories, {
    int maxRemoteFetches = 30,
  }) async {
    if (stories.isEmpty) return stories;
    final indices = <int>[];
    for (var i = 0; i < stories.length; i++) {
      final s = stories[i];
      if (s.imageUrl == null || s.imageUrl!.trim().isEmpty) {
        indices.add(i);
        if (indices.length >= maxRemoteFetches) break;
      }
    }
    if (indices.isEmpty) return stories;
    final out = List<Story>.from(stories);
    final updates = await Future.wait(
      indices.map((i) async {
        final merged = await _mergeRemoteStoryImage(stories[i]);
        return MapEntry(i, merged);
      }),
    );
    for (final e in updates) {
      out[e.key] = e.value;
    }
    return out;
  }

  /// Load saved/bookmarked stories
  Future<void> _onLoadSavedStories(Emitter<HomeState> emit) async {
    emit(state.copyWith(isSavedStoriesLoading: true));
    await _loadSavedStories(emit);
    emit(state.copyWith(isSavedStoriesLoading: false));
  }

  Future<void> _loadSavedStories(Emitter<HomeState> emit) async {
    try {
      final result = await _userRepository.getSavedStories();
      await result.fold(
        (failure) async {
          talker.error('Failed to load saved stories: ${failure.message}');
          emit(state.copyWith(savedStories: []));
        },
        (stories) async {
          final filteredStories = stories
              .where((s) => s.title.toLowerCase() != 'untitled story')
              .toList();
          final hydrated = await _hydrateMissingStoryImages(filteredStories);
          emit(state.copyWith(savedStories: hydrated));
        },
      );
    } catch (e, st) {
      talker.error('Failed to load saved stories', e, st);
      emit(state.copyWith(savedStories: []));
    }
  }

  /// Load user's generated stories
  Future<void> _onLoadMyGeneratedStories(Emitter<HomeState> emit) async {
    emit(state.copyWith(isMyGeneratedStoriesLoading: true));
    await _loadMyGeneratedStories(emit);
    emit(state.copyWith(isMyGeneratedStoriesLoading: false));
  }

  Future<void> _loadMyGeneratedStories(Emitter<HomeState> emit) async {
    try {
      final result = await _storyGeneratorRepository.getGeneratedStories(
        limit: 100,
      );
      await result.fold(
        (failure) async {
          talker.error('Failed to load generated stories: ${failure.message}');
          emit(state.copyWith(myGeneratedStories: []));
        },
        (stories) async {
          // Deduplicate stories by title, keeping the one with an image if there are duplicates
          final uniqueStories = <String, Story>{};
          for (final story in stories) {
            final key = story.title;
            if (!uniqueStories.containsKey(key)) {
              uniqueStories[key] = story;
            } else {
              // If the existing one doesn't have an image but the new one does, replace it
              final existingStory = uniqueStories[key]!;
              final existingHasImage = existingStory.imageUrl != null && existingStory.imageUrl!.isNotEmpty;
              final newHasImage = story.imageUrl != null && story.imageUrl!.isNotEmpty;
              
              if (!existingHasImage && newHasImage) {
                uniqueStories[key] = story;
              } else if (existingHasImage && newHasImage) {
                // If both have images, keep the most recently updated one
                final existingTime = existingStory.updatedAt ?? existingStory.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
                final newTime = story.updatedAt ?? story.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
                if (newTime.isAfter(existingTime)) {
                  uniqueStories[key] = story;
                }
              }
            }
          }
          
          final deduplicatedList = uniqueStories.values
              .where((s) => s.title.toLowerCase() != 'untitled story')
              .toList();
          // Sort by updated_at descending
          deduplicatedList.sort((a, b) {
            final aTime = a.updatedAt ??
                a.createdAt ??
                DateTime.fromMillisecondsSinceEpoch(0);
            final bTime = b.updatedAt ??
                b.createdAt ??
                DateTime.fromMillisecondsSinceEpoch(0);
            return bTime.compareTo(aTime);
          });

          final hydrated = await _hydrateMissingStoryImages(deduplicatedList);
          emit(state.copyWith(myGeneratedStories: hydrated));
        },
      );
    } catch (e, st) {
      talker.error('Failed to load generated stories', e, st);
      emit(state.copyWith(myGeneratedStories: []));
    }
  }

  /// Share the current quote
  Future<void> _onShareQuote(Emitter<HomeState> emit) async {
    final quote = state.quote;
    if (quote == null) return;

    try {
      await SharePlus.instance.share(ShareParams(text: quote.shareableText));
      HapticFeedback.mediumImpact();
    } catch (e, st) {
      talker.error('Failed to share quote', e, st);
    }
  }

  /// Copy quote to clipboard
  Future<void> _onCopyQuote(Emitter<HomeState> emit) async {
    final quote = state.quote;
    if (quote == null) return;

    try {
      await Clipboard.setData(ClipboardData(text: quote.shareableText));
      HapticFeedback.lightImpact();
    } catch (e, st) {
      talker.error('Failed to copy quote', e, st);
    }
  }

  Future<void> _loadSacredLocations(Emitter<HomeState> emit) async {
    try {
      final response =
          await _supabase.from('sacred_locations').select().limit(50);
      final allLocations = (response as List)
          .map((json) => SacredLocation.fromJson(json))
          .toList();

      final prefs = await SharedPreferences.getInstance();
      final favorites = (prefs.getStringList('favorite_sites') ?? [])
          .map((id) => int.tryParse(id) ?? 0)
          .toSet();
      final visited = (prefs.getStringList('visited_sites') ?? [])
          .map((id) => int.tryParse(id) ?? 0)
          .toSet();

      final locationsWithMeta = allLocations.map((loc) {
        return SacredLocation(
          id: loc.id,
          name: loc.name,
          latitude: loc.latitude,
          longitude: loc.longitude,
          intent: loc.intent,
          type: loc.type,
          region: loc.region,
          tradition: loc.tradition,
          ref: loc.ref,
          image: loc.image,
          description: loc.description,
          isFavorite: favorites.contains(loc.id),
          visited: visited.contains(loc.id),
        );
      }).toList();

      emit(state.copyWith(sacredLocations: locationsWithMeta));
    } catch (e, st) {
      talker.error('Failed to load sacred locations', e, st);
      emit(state.copyWith(sacredLocations: []));
    }
  }

  Future<void> _loadFestivals(Emitter<HomeState> emit) async {
    try {
      final response = await _supabase
          .from('hindu_festivals')
          .select()
          .order('order_index');
      final festivals = (response as List)
          .map((json) => HinduFestival.fromJson(json as Map<String, dynamic>))
          .toList();

      // Custom homepage ordering: highlight key festivals first in the
      // exact order requested, then fall back to the configured order_index.
      const homepagePriority = [
        'rama-navami',
        'maha-shivaratri',
        'ganesh-chaturthi',
        'diwali',
        'holi',
        'navratri',
        'janmashtami',
        'makar-sankranti',
        'onam',
        'pongal',
      ];

      int rankFestival(HinduFestival f) {
        final idx = homepagePriority.indexOf(f.slug);
        if (idx != -1) return idx;
        // Anything not in the explicit list comes after, ordered by orderIndex.
        return homepagePriority.length + f.orderIndex;
      }

      festivals.sort((a, b) => rankFestival(a).compareTo(rankFestival(b)));

      emit(state.copyWith(festivals: festivals));
    } catch (e, st) {
      talker.error('Failed to load Sanatan festivals', e, st);
      emit(state.copyWith(festivals: []));
    }
  }

  Future<void> _loadUserName(Emitter<HomeState> emit) async {
    try {
      final result = await _userRepository.getCurrentUser();
      result.fold(
        (failure) {
          talker.error('Failed to load user name: ${failure.message}');
        },
        (user) {
          final firstName = user.displayName.split(' ').first;
          emit(state.copyWith(userName: firstName));
        },
      );
    } catch (e, st) {
      talker.error('Failed to load user name', e, st);
    }
  }

  /// Get greeting key based on time of day
  String _getGreetingKey() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'morning';
    } else if (hour >= 12 && hour < 17) {
      return 'afternoon';
    } else if (hour >= 17 && hour < 22) {
      return 'evening';
    } else {
      return 'night';
    }
  }

  /// Placeholder stories for development
  // List<Story> _getPlaceholderStories() {
  //   return [
  //     Story(
  //       id: 'featured_1',
  //       title: 'The Wisdom of Arjuna',
  //       scripture: 'Mahabharata',
  //       story: 'In the great battle of Kurukshetra...',
  //       quotes: 'Do your duty without attachment to results.',
  //       trivia: 'The Mahabharata is the longest epic poem ever written.',
  //       activity: 'Reflect on a time when you had to make a difficult choice.',
  //       lesson:
  //           'True wisdom comes from understanding both action and inaction.',
  //       attributes: StoryAttributes(
  //         storyType: 'Epic',
  //         theme: 'Wisdom',
  //         mainCharacterType: 'Warrior',
  //         storySetting: 'Battlefield',
  //         timeEra: 'Dwapara Yuga',
  //         narrativePerspective: 'Third Person',
  //         languageStyle: 'Classical',
  //         emotionalTone: 'Contemplative',
  //         narrativeStyle: 'Epic',
  //         plotStructure: 'Hero\'s Journey',
  //         storyLength: 'medium',
  //       ),
  //       imageUrl:
  //           'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800',
  //     ),
  //     Story(
  //       id: 'featured_2',
  //       title: 'Lord Hanuman\'s Devotion',
  //       scripture: 'Ramayana',
  //       story: 'When Lord Rama needed someone to cross the ocean...',
  //       quotes: 'With faith, mountains can be moved.',
  //       trivia: 'Hanuman is considered the 11th Rudra avatar.',
  //       activity: 'Practice a small act of selfless service today.',
  //       lesson: 'Devotion and faith can overcome any obstacle.',
  //       attributes: StoryAttributes(
  //         storyType: 'Devotional',
  //         theme: 'Faith',
  //         mainCharacterType: 'Divine',
  //         storySetting: 'Kingdom',
  //         timeEra: 'Treta Yuga',
  //         narrativePerspective: 'Third Person',
  //         languageStyle: 'Classical',
  //         emotionalTone: 'Inspiring',
  //         narrativeStyle: 'Devotional',
  //         plotStructure: 'Quest',
  //         storyLength: 'medium',
  //       ),
  //       imageUrl:
  //           'https://images.unsplash.com/photo-1609619385002-f40f1df9b7eb?w=800',
  //     ),
  //     Story(
  //       id: 'featured_3',
  //       title: 'The Churning of the Ocean',
  //       scripture: 'Vishnu Purana',
  //       story: 'The Devas and Asuras once joined forces...',
  //       quotes: 'From struggle comes nectar.',
  //       trivia: 'Samudra Manthan produced 14 treasures.',
  //       activity: 'Think about challenges that led to personal growth.',
  //       lesson: 'Cooperation can achieve what division cannot.',
  //       attributes: StoryAttributes(
  //         storyType: 'Scriptural',
  //         theme: 'Cooperation',
  //         mainCharacterType: 'Divine',
  //         storySetting: 'Cosmic Ocean',
  //         timeEra: 'Satya Yuga',
  //         narrativePerspective: 'Third Person',
  //         languageStyle: 'Classical',
  //         emotionalTone: 'Epic',
  //         narrativeStyle: 'Scriptural',
  //         plotStructure: 'Cosmic Drama',
  //         storyLength: 'long',
  //       ),
  //       imageUrl:
  //           'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800',
  //     ),
  //   ];
  // }
}
