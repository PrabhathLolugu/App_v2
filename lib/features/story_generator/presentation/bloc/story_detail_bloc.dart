import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/logging/talker_setup.dart';
import 'package:myitihas/core/utils/content_language.dart';
import 'package:myitihas/core/utils/language_voice_resolver.dart';
import 'package:myitihas/features/home/data/datasources/activity_local_datasource.dart';
import 'package:myitihas/features/home/domain/entities/activity_item.dart';
import 'package:myitihas/features/home/domain/repositories/continue_reading_repository.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/features/story_generator/domain/entities/generator_options.dart';
import 'package:myitihas/features/story_generator/domain/entities/story_chat_message.dart';
import 'package:myitihas/features/story_generator/domain/entities/story_prompt.dart';
import 'package:myitihas/features/story_generator/domain/entities/story_translation.dart';
import 'package:myitihas/features/story_generator/domain/repositories/story_generator_repository.dart';
import 'package:myitihas/services/supabase_service.dart';

const Object _kUnset = Object();

/// A lightweight view-model for chapter rendering.
class StoryChapter {
  final int number;
  final String content;

  const StoryChapter({required this.number, required this.content});

  String get title => 'Chapter $number';
}

/// Events for StoryDetailBloc (no codegen to keep it easy to integrate).
sealed class StoryDetailEvent {
  const StoryDetailEvent();
}

class StoryDetailStarted extends StoryDetailEvent {
  final Story story;
  const StoryDetailStarted(this.story);
}

class StoryDetailToggleFavorite extends StoryDetailEvent {
  const StoryDetailToggleFavorite();
}

class StoryDetailLanguageChanged extends StoryDetailEvent {
  final String languageName;
  const StoryDetailLanguageChanged(this.languageName);
}

class StoryDetailTranslationRefreshRequested extends StoryDetailEvent {
  const StoryDetailTranslationRefreshRequested();
}

class StoryDetailRegenerateRequested extends StoryDetailEvent {
  const StoryDetailRegenerateRequested();
}

class StoryDetailGenerateImageRequested extends StoryDetailEvent {
  const StoryDetailGenerateImageRequested();
}

class StoryDetailReadMorePressed extends StoryDetailEvent {
  const StoryDetailReadMorePressed();
}

class StoryDetailExpandRequested extends StoryDetailEvent {
  const StoryDetailExpandRequested();
}

class StoryDetailDownloadStatusChanged extends StoryDetailEvent {
  final bool isDownloading;
  const StoryDetailDownloadStatusChanged(this.isDownloading);
}

/// Fetch character details for a given character (cache-first).
class StoryDetailCharacterDetailsRequested extends StoryDetailEvent {
  final String characterName;
  const StoryDetailCharacterDetailsRequested(this.characterName);
}

/// Clear currently selected character details (optional).
class StoryDetailCharacterDetailsClosed extends StoryDetailEvent {
  const StoryDetailCharacterDetailsClosed();
}

/// Open the story chat (loads conversation cache-first).
class StoryDetailChatOpened extends StoryDetailEvent {
  const StoryDetailChatOpened();
}

/// Send a message in the story chat.
class StoryDetailChatMessageSubmitted extends StoryDetailEvent {
  final String message;
  const StoryDetailChatMessageSubmitted(this.message);
}

/// Close chat (optional: clears errors).
class StoryDetailChatClosed extends StoryDetailEvent {
  const StoryDetailChatClosed();
}

/// State for StoryDetailBloc.
class StoryDetailState {
  final Story? story;

  /// Parsed chapters (Chapter 1 is the original story content).
  final List<StoryChapter> chapters;

  /// How many chapters are currently revealed in the UI.
  final int visibleChapters;

  final bool isGeneratingImage;
  final bool isRegenerating;
  final bool isExpanding;
  final bool isSaving;
  final bool isDownloading;

  /// Character details bottom-sheet
  final bool isFetchingCharacter;
  final String? selectedCharacterName;
  final Map<String, dynamic>? selectedCharacterDetails;

  // Story chat bottom-sheet
  final bool isChatLoading;
  final bool isChatSending;
  final StoryChatConversation? chatConversation;
  final String? chatError;

  /// Display name shown in dropdown (e.g., "English")
  final String selectedLanguage;

  final bool isTranslating;
  final String? translationError;

  final String? errorMessage;

  const StoryDetailState({
    required this.story,
    required this.chapters,
    required this.visibleChapters,
    required this.isGeneratingImage,
    required this.isRegenerating,
    required this.isExpanding,
    required this.isSaving,
    required this.isDownloading,
    required this.isFetchingCharacter,
    required this.selectedCharacterName,
    required this.selectedCharacterDetails,
    required this.isChatLoading,
    required this.isChatSending,
    required this.chatConversation,
    required this.chatError,
    required this.selectedLanguage,
    required this.isTranslating,
    required this.translationError,
    required this.errorMessage,
  });

  factory StoryDetailState.initial() => const StoryDetailState(
    story: null,
    chapters: [],
    visibleChapters: 1,
    isGeneratingImage: false,
    isRegenerating: false,
    isExpanding: false,
    isSaving: false,
    isDownloading: false,
    isFetchingCharacter: false,
    selectedCharacterName: null,
    selectedCharacterDetails: null,
    isChatLoading: false,
    isChatSending: false,
    chatConversation: null,
    chatError: null,
    selectedLanguage: 'English',
    isTranslating: false,
    translationError: null,
    errorMessage: null,
  );

  StoryDetailState copyWith({
    Story? story,
    List<StoryChapter>? chapters,
    int? visibleChapters,
    bool? isGeneratingImage,
    bool? isRegenerating,
    bool? isExpanding,
    bool? isSaving,
    bool? isDownloading,
    bool? isFetchingCharacter,
    String? selectedCharacterName,
    Map<String, dynamic>? selectedCharacterDetails,
    bool clearSelectedCharacterDetails = false,
    bool? isChatLoading,
    bool? isChatSending,
    Object? chatConversation = _kUnset,
    Object? chatError = _kUnset,
    String? selectedLanguage,
    bool? isTranslating,
    String? translationError,
    Object? errorMessage = _kUnset,
  }) {
    return StoryDetailState(
      story: story ?? this.story,
      chapters: chapters ?? this.chapters,
      visibleChapters: visibleChapters ?? this.visibleChapters,
      isGeneratingImage: isGeneratingImage ?? this.isGeneratingImage,
      isRegenerating: isRegenerating ?? this.isRegenerating,
      isExpanding: isExpanding ?? this.isExpanding,
      isSaving: isSaving ?? this.isSaving,
      isDownloading: isDownloading ?? this.isDownloading,
      isFetchingCharacter: isFetchingCharacter ?? this.isFetchingCharacter,
      selectedCharacterName: clearSelectedCharacterDetails
          ? null
          : (selectedCharacterName ?? this.selectedCharacterName),
      selectedCharacterDetails: clearSelectedCharacterDetails
          ? null
          : (selectedCharacterDetails ?? this.selectedCharacterDetails),
      isChatLoading: isChatLoading ?? this.isChatLoading,
      isChatSending: isChatSending ?? this.isChatSending,
      chatConversation: chatConversation == _kUnset
          ? this.chatConversation
          : chatConversation as StoryChatConversation?,
      chatError: chatError == _kUnset ? this.chatError : chatError as String?,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      isTranslating: isTranslating ?? this.isTranslating,
      translationError: translationError ?? this.translationError,
      errorMessage: errorMessage == _kUnset
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}

@injectable
class StoryDetailBloc extends Bloc<StoryDetailEvent, StoryDetailState> {
  static const String _insightsOwnerOnlyMessage =
      'Story insights and interactions are available only for stories you generated.';
  static const Set<String> _translationSupportedCodes = {
    'en',
    'hi',
    'te',
    'ta',
    'bn',
    'mr',
    'gu',
    'kn',
    'ml',
    'pa',
    'or',
    'ur',
    'sa',
    'as',
  };
  final StoryGeneratorRepository _repo;
  final ContinueReadingRepository _continueReadingRepo;
  final ActivityLocalDataSource _activityDataSource;

  StoryDetailBloc(
    this._repo,
    this._continueReadingRepo,
    this._activityDataSource,
  ) : super(StoryDetailState.initial()) {
    on<StoryDetailStarted>(_onStarted);
    on<StoryDetailToggleFavorite>(_onToggleFavorite);
    on<StoryDetailLanguageChanged>(_onLanguageChanged);
    on<StoryDetailTranslationRefreshRequested>(_onTranslationRefreshRequested);
    on<StoryDetailRegenerateRequested>(_onRegenerate);
    on<StoryDetailGenerateImageRequested>(_onGenerateImage);
    on<StoryDetailReadMorePressed>(_onReadMorePressed);
    on<StoryDetailExpandRequested>(_onExpandRequested);
    on<StoryDetailDownloadStatusChanged>(_onDownloadStatusChanged);
    on<StoryDetailCharacterDetailsRequested>(_onCharacterDetailsRequested);
    on<StoryDetailChatOpened>(_onChatOpened);
    on<StoryDetailChatMessageSubmitted>(_onChatMessageSubmitted);
    on<StoryDetailChatClosed>(_onChatClosed);
    on<StoryDetailCharacterDetailsClosed>(_onCharacterDetailsClosed);
  }

  Future<void> _onStarted(
    StoryDetailStarted event,
    Emitter<StoryDetailState> emit,
  ) async {
    final story = event.story;
    final isOwnedByCurrentUser = _isStoryOwnedByCurrentUser(story);

    final chapters = _parseChapters(story.story);

    String selectedLanguage;
    if (story.attributes.languageStyle.isNotEmpty) {
      selectedLanguage = story.attributes.languageStyle;
    } else {
      // Fall back to global content language when story metadata is missing.
      final contentLang = await ContentLanguageSettings.getCurrentLanguage();
      selectedLanguage = contentLang.displayName;
    }
    selectedLanguage = _resolveInitialSelectedLanguage(story, selectedLanguage);

    emit(
      state.copyWith(
        story: story,
        chapters: chapters,
        visibleChapters: chapters.length,
        selectedLanguage: selectedLanguage,
        errorMessage: null,
      ),
    );

    // Auto-generate image only for stories owned by the current user.
    if ((story.imageUrl == null || story.imageUrl!.isEmpty) &&
        isOwnedByCurrentUser) {
      talker.info('Story ${story.id} has no imageUrl, generating...');
      add(const StoryDetailGenerateImageRequested());
    } else if (story.imageUrl == null || story.imageUrl!.isEmpty) {
      talker.debug(
        'Story ${story.id} has no imageUrl but is not owned by current user; skipping auto-generation.',
      );
    } else {
      talker.info('Story ${story.id} has imageUrl: ${story.imageUrl}');
    }

    // Add to continue reading list
    _continueReadingRepo.addStoryToContinueReading(story);

    // Record activity
    _activityDataSource.recordActivity(
      ActivityItem(
        id: ActivityLocalDataSource.generateActivityId(),
        type: ActivityType.storyRead,
        storyId: story.id,
        storyTitle: story.title,
        timestamp: DateTime.now(),
        thumbnailUrl: story.imageUrl,
        scripture: story.scripture,
      ),
    );
  }

  Future<void> _onToggleFavorite(
    StoryDetailToggleFavorite event,
    Emitter<StoryDetailState> emit,
  ) async {
    final story = state.story;
    if (story == null) return;

    final updated = story.copyWith(isFavorite: !story.isFavorite);

    // Optimistic update
    emit(state.copyWith(story: updated, errorMessage: null, isSaving: true));

    final saved = await _repo.likeStory(updated, updated.isFavorite);
    saved.fold(
      (failure) {
        talker.error('Failed to update favorite: ${failure.message}');
        // rollback
        emit(
          state.copyWith(
            story: story,
            isSaving: false,
            errorMessage: failure.message,
          ),
        );
      },
      (savedStory) {
        emit(
          state.copyWith(
            story: savedStory,
            isSaving: false,
            errorMessage: null,
          ),
        );
      },
    );
  }

  String _languageNameToCode(String name) {
    return LanguageVoiceResolver.languageCodeFromAny(name);
  }

  Future<void> _onLanguageChanged(
    StoryDetailLanguageChanged event,
    Emitter<StoryDetailState> emit,
  ) async {
    await _translateToLanguage(
      languageName: event.languageName,
      emit: emit,
      forceRefresh: false,
    );
  }

  Future<void> _onTranslationRefreshRequested(
    StoryDetailTranslationRefreshRequested event,
    Emitter<StoryDetailState> emit,
  ) async {
    await _translateToLanguage(
      languageName: state.selectedLanguage,
      emit: emit,
      forceRefresh: true,
    );
  }

  Future<void> _translateToLanguage({
    required String languageName,
    required Emitter<StoryDetailState> emit,
    required bool forceRefresh,
  }) async {
    final story = state.story;
    if (story == null) return;

    // Normalize the incoming display name to a canonical chat language
    // name understood by the Edge function prompts.
    final normalizedName = languageName.trim();
    if (normalizedName.isEmpty) return;

    final langCode = _languageNameToCode(normalizedName);
    final sourceLangCode = _resolveSourceLanguageCode(story);

    // If selected language is the source language, show original.
    if (!forceRefresh && langCode == sourceLangCode) {
      final newChapters = _parseChapters(story.story);
      final newVisible = newChapters.isEmpty
          ? 0
          : state.visibleChapters.clamp(1, newChapters.length);
      emit(
        state.copyWith(
          selectedLanguage: languageName,
          chapters: newChapters,
          visibleChapters: newVisible,
          clearSelectedCharacterDetails: true,
          errorMessage: null,
        ),
      );
      return;
    }

    // Use cached translation only if it has the EXACT same number of chapters as current story
    final cached = story.attributes.translations[langCode];
    final currentChapterCount = _parseChapters(story.story).length;
    final normalizedOriginal = _normalizeTranslationComparisonText(story.story);
    final normalizedCached = _normalizeTranslationComparisonText(cached?.story);
    final cachedLooksUntranslated =
        normalizedCached.isNotEmpty && normalizedCached == normalizedOriginal;
    final englishCacheScriptMismatch =
        langCode == LanguageVoiceResolver.defaultLanguageCode &&
        cached != null &&
        _inferLanguageCodeFromScript(cached.story) !=
            LanguageVoiceResolver.defaultLanguageCode;
    final cachedValid =
        cached != null &&
        _parseChapters(cached.story).length == currentChapterCount &&
        !cachedLooksUntranslated &&
        !englishCacheScriptMismatch;

    if (!forceRefresh && cachedValid) {
      final newChapters = _parseChapters(cached.story);
      final newVisible = newChapters.isEmpty
          ? 0
          : state.visibleChapters.clamp(1, newChapters.length);
      emit(
        state.copyWith(
          selectedLanguage: languageName,
          chapters: newChapters,
          visibleChapters: newVisible,
          clearSelectedCharacterDetails: true,
          errorMessage: null,
        ),
      );
      return;
    }

    if (!_translationSupportedCodes.contains(langCode)) {
      final fallback = _parseChapters(story.story);
      final newVisible = fallback.isEmpty
          ? 0
          : state.visibleChapters.clamp(1, fallback.length);
      emit(
        state.copyWith(
          selectedLanguage: languageName,
          chapters: fallback,
          visibleChapters: newVisible,
          clearSelectedCharacterDetails: true,
          translationError:
              'Translation is not available for ${LanguageVoiceResolver.displayNameForCode(langCode)} yet. Reading original story.',
        ),
      );
      return;
    }

    // Start translation - update UI to show loading state
    emit(
      state.copyWith(
        selectedLanguage: languageName,
        isTranslating: true,
        clearSelectedCharacterDetails: true,
        errorMessage: null,
      ),
    );

    final res = await _repo.translateStory(story: story, targetLang: langCode);

    await res.fold(
      (failure) async {
        // Translation failed - fall back to original content
        final fallback = _parseChapters(story.story);
        final newVisible = fallback.isEmpty
            ? 0
            : state.visibleChapters.clamp(1, fallback.length);
        emit(
          state.copyWith(
            isTranslating: false,
            chapters: fallback,
            visibleChapters: newVisible,
            clearSelectedCharacterDetails: true,
            errorMessage: failure.message,
          ),
        );
      },
      (translated) async {
        // Verify translated content has same chapter count as original
        final translatedChapters = _parseChapters(translated.story);
        final originalChapters = _parseChapters(story.story);

        if (translatedChapters.length != originalChapters.length) {
          // Translation structure mismatch - fall back to original
          talker.warning(
            'Translation chapter count mismatch: original=${originalChapters.length}, '
            'translated=${translatedChapters.length}. Falling back.',
          );
          final fallback = originalChapters;
          final newVisible = fallback.isEmpty
              ? 0
              : state.visibleChapters.clamp(1, fallback.length);
          emit(
            state.copyWith(
              isTranslating: false,
              chapters: fallback,
              visibleChapters: newVisible,
              clearSelectedCharacterDetails: true,
              errorMessage:
                  'Translation structure was corrupted. Showing original content.',
            ),
          );
          return;
        }

        final updatedTranslations = Map<String, TranslatedStory>.from(
          story.attributes.translations,
        )..[langCode] = translated;

        final updatedStory = story.copyWith(
          attributes: story.attributes.copyWith(
            translations: updatedTranslations,
          ),
        );

        // Non-owners can still view translation in-memory without persisting.
        if (!_isStoryOwnedByCurrentUser(story)) {
          final newChapters = _parseChapters(translated.story);
          final newVisible = newChapters.isEmpty
              ? 0
              : state.visibleChapters.clamp(1, newChapters.length);
          emit(
            state.copyWith(
              story: updatedStory,
              isTranslating: false,
              chapters: newChapters,
              visibleChapters: newVisible,
              clearSelectedCharacterDetails: true,
              errorMessage: null,
            ),
          );
          return;
        }

        final saved = await _repo.updateStory(updatedStory);

        saved.fold(
          (f) {
            // Save failed - fall back to original
            final fallback = _parseChapters(story.story);
            final newVisible = fallback.isEmpty
                ? 0
                : state.visibleChapters.clamp(1, fallback.length);
            emit(
              state.copyWith(
                isTranslating: false,
                chapters: fallback,
                visibleChapters: newVisible,
                clearSelectedCharacterDetails: true,
                errorMessage: 'Failed to save translation: ${f.message}',
              ),
            );
          },
          (savedStory) {
            final newChapters = _parseChapters(translated.story);
            final newVisible = newChapters.isEmpty
                ? 0
                : state.visibleChapters.clamp(1, newChapters.length);
            emit(
              state.copyWith(
                story: savedStory,
                isTranslating: false,
                chapters: newChapters,
                visibleChapters: newVisible,
                clearSelectedCharacterDetails: true,
                errorMessage: null,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onRegenerate(
    StoryDetailRegenerateRequested event,
    Emitter<StoryDetailState> emit,
  ) async {
    final original = state.story;
    if (original == null || state.isRegenerating) return;

    emit(state.copyWith(isRegenerating: true, errorMessage: null));

    try {
      final prompt = StoryPrompt(
        scripture: original.scripture.isNotEmpty ? original.scripture : null,
        storyType: original.attributes.storyType.isNotEmpty
            ? original.attributes.storyType
            : null,
        theme: original.attributes.theme.isNotEmpty
            ? original.attributes.theme
            : null,
        mainCharacter: original.attributes.mainCharacterType.isNotEmpty
            ? original.attributes.mainCharacterType
            : null,
        setting: original.attributes.storySetting.isNotEmpty
            ? original.attributes.storySetting
            : null,
        isRawPrompt: false,
      );

      final options = GeneratorOptions(
        language: StoryLanguage.values.firstWhere(
          (lang) =>
              lang.name.toLowerCase() ==
              state.selectedLanguage.toLowerCase().replaceAll(' ', ''),
          orElse: () => StoryLanguage.english,
        ),
        length: original.attributes.storyLength.isNotEmpty
            ? StoryLength.values.firstWhere(
                (len) =>
                    len.name.toLowerCase() ==
                    original.attributes.storyLength.toLowerCase(),
                orElse: () => StoryLength.medium,
              )
            : StoryLength.medium,
        format: original.attributes.narrativeStyle.isNotEmpty
            ? StoryFormat.values.firstWhere(
                (fmt) =>
                    fmt.name.toLowerCase() ==
                    original.attributes.narrativeStyle.toLowerCase(),
                orElse: () => StoryFormat.narrative,
              )
            : StoryFormat.narrative,
      );

      final result = await _repo.regenerateStory(
        original: original,
        prompt: prompt,
        options: options,
      );

      await result.fold(
        (failure) async {
          talker.error('Regenerate failed: ${failure.message}');
          emit(
            state.copyWith(
              isRegenerating: false,
              errorMessage: failure.message,
            ),
          );
        },
        (regenerated) async {
          final chapters = _parseChapters(regenerated.story);

          emit(
            state.copyWith(
              story: regenerated,
              chapters: chapters,
              visibleChapters: chapters.isEmpty ? 0 : 1,
              isRegenerating: false,
              errorMessage: null,
              clearSelectedCharacterDetails: true,
            ),
          );

          // After regenerate, the repo sets image_url null -> generate new image.
          add(const StoryDetailGenerateImageRequested());
        },
      );
    } catch (e) {
      talker.error('Error during regenerate: $e');
      emit(state.copyWith(isRegenerating: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onGenerateImage(
    StoryDetailGenerateImageRequested event,
    Emitter<StoryDetailState> emit,
  ) async {
    final story = state.story;
    if (story == null || state.isGeneratingImage) return;
    if (!_isStoryOwnedByCurrentUser(story)) {
      emit(state.copyWith(errorMessage: _insightsOwnerOnlyMessage));
      return;
    }

    emit(state.copyWith(isGeneratingImage: true, errorMessage: null));

    final result = await _repo.generateStoryImage(
      title: story.title,
      story: story.story,
      moral: story.lesson,
    );

    await result.fold(
      (failure) async {
        talker.error('Image gen failed: ${failure.message}');
        emit(
          state.copyWith(
            isGeneratingImage: false,
            errorMessage: failure.message,
          ),
        );
      },
      (imageUrl) async {
        final normalized = imageUrl.contains(',')
            ? imageUrl.split(',').last
            : imageUrl;
        final updated = story.copyWith(imageUrl: normalized);

        emit(state.copyWith(story: updated, isSaving: true));

        final saved = await _repo.updateStory(updated);
        saved.fold(
          (failure) {
            talker.error('Failed to save image: ${failure.message}');
            emit(
              state.copyWith(
                isGeneratingImage: false,
                isSaving: false,
                errorMessage: failure.message,
              ),
            );
          },
          (savedStory) {
            emit(
              state.copyWith(
                story: savedStory,
                isGeneratingImage: false,
                isSaving: false,
                errorMessage: null,
              ),
            );
            // Replace continue-reading snapshot so home tiles get the new cover without refresh.
            _continueReadingRepo.addStoryToContinueReading(savedStory);
          },
        );
      },
    );
  }

  Future<void> _onReadMorePressed(
    StoryDetailReadMorePressed event,
    Emitter<StoryDetailState> emit,
  ) async {
    final story = state.story;
    if (story == null) return;
    if (!_isStoryOwnedByCurrentUser(story)) {
      emit(state.copyWith(errorMessage: _insightsOwnerOnlyMessage));
      return;
    }

    // Reveal next already-fetched chapter, else fetch a new one.
    if (state.visibleChapters < state.chapters.length) {
      emit(state.copyWith(visibleChapters: state.visibleChapters + 1));
      return;
    }
    add(const StoryDetailExpandRequested());
  }

  Future<void> _onExpandRequested(
    StoryDetailExpandRequested event,
    Emitter<StoryDetailState> emit,
  ) async {
    final story = state.story;
    if (story == null || state.isExpanding) return;
    if (!_isStoryOwnedByCurrentUser(story)) {
      emit(state.copyWith(errorMessage: _insightsOwnerOnlyMessage));
      return;
    }

    emit(state.copyWith(isExpanding: true, errorMessage: null));

    final currentChapter = state.chapters.isEmpty ? 1 : state.chapters.length;

    final result = await _repo.expandStory(
      story: story,
      currentChapter: currentChapter,
      storyLanguage: state.selectedLanguage,
    );

    await result.fold(
      (failure) async {
        talker.error('Expand failed: ${failure.message}');
        emit(state.copyWith(isExpanding: false, errorMessage: failure.message));
      },
      (newChapterText) async {
        final nextNumber = currentChapter + 1;
        final updatedChapters = [
          ...state.chapters,
          StoryChapter(number: nextNumber, content: newChapterText.trim()),
        ];

        final updatedContent = _buildStoryContent(updatedChapters);

        final updatedStory = story.copyWith(story: updatedContent);

        final saved = await _repo.updateStory(updatedStory);

        // Optimistic update so UI opens the new chapter immediately
        emit(
          state.copyWith(
            story: updatedStory,
            chapters: updatedChapters,
            visibleChapters: state.visibleChapters + 1,
            isExpanding: false,
            isSaving: true,
          ),
        );

        saved.fold(
          (failure) {
            talker.error('Failed to save expanded story: ${failure.message}');
            emit(
              state.copyWith(isSaving: false, errorMessage: failure.message),
            );
          },
          (savedStory) {
            emit(
              state.copyWith(
                story: savedStory,
                isSaving: false,
                errorMessage: null,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onDownloadStatusChanged(
    StoryDetailDownloadStatusChanged event,
    Emitter<StoryDetailState> emit,
  ) async {
    emit(state.copyWith(isDownloading: event.isDownloading));
  }

  Future<void> _onCharacterDetailsRequested(
    StoryDetailCharacterDetailsRequested event,
    Emitter<StoryDetailState> emit,
  ) async {
    final story = state.story;
    if (story == null || state.isFetchingCharacter) return;
    if (!_isStoryOwnedByCurrentUser(story)) {
      emit(state.copyWith(errorMessage: _insightsOwnerOnlyMessage));
      return;
    }

    final key = _characterDetailsCacheKey(
      event.characterName,
      state.selectedLanguage,
    );
    final cached = story.attributes.characterDetails[key];

    // Cache hit
    if (cached != null && cached.isNotEmpty && cached.length > 2) {
      emit(
        state.copyWith(
          isFetchingCharacter: false,
          selectedCharacterName: event.characterName,
          selectedCharacterDetails: cached.cast<String, dynamic>(),
          errorMessage: null,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isFetchingCharacter: true,
        selectedCharacterName: event.characterName,
        selectedCharacterDetails: null,
        isChatLoading: false,
        isChatSending: false,
        chatConversation: null,
        chatError: null,
        errorMessage: null,
      ),
    );

    final currentChapter = state.chapters.isEmpty ? 1 : state.chapters.length;

    final result = await _repo.getCharacterDetails(
      story: story,
      characterName: event.characterName,
      currentChapter: currentChapter,
      storyLanguage: state.selectedLanguage,
    );

    await result.fold(
      (failure) async {
        talker.error('Character details failed: ${failure.message}');
        emit(
          state.copyWith(
            isFetchingCharacter: false,
            errorMessage: failure.message,
          ),
        );
      },
      (details) async {
        final updatedMap = {...story.attributes.characterDetails, key: details};

        final updatedStory = story.copyWith(
          attributes: story.attributes.copyWith(characterDetails: updatedMap),
        );

        // Optimistic update so sheet renders immediately
        emit(
          state.copyWith(
            story: updatedStory,
            isFetchingCharacter: false,
            selectedCharacterName: event.characterName,
            selectedCharacterDetails: details,
            isSaving: true,
            errorMessage: null,
          ),
        );

        final saved = await _repo.updateStory(updatedStory);
        saved.fold(
          (failure) {
            talker.error(
              'Failed to save character details: ${failure.message}',
            );
            emit(
              state.copyWith(isSaving: false, errorMessage: failure.message),
            );
          },
          (savedStory) {
            emit(
              state.copyWith(
                story: savedStory,
                isSaving: false,
                errorMessage: null,
              ),
            );
          },
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Story Chat (Discuss Story)
  // ---------------------------------------------------------------------------

  Future<void> _onChatOpened(
    StoryDetailChatOpened event,
    Emitter<StoryDetailState> emit,
  ) async {
    final story = state.story;
    if (story == null || state.isChatLoading) return;
    if (!_isStoryOwnedByCurrentUser(story)) {
      emit(state.copyWith(chatError: _insightsOwnerOnlyMessage));
      return;
    }

    emit(state.copyWith(isChatLoading: true, chatError: null));

    final result = await _repo.getOrCreateStoryChat(story: story);
    result.fold(
      (failure) {
        talker.error('Chat load failed: ${failure.message}');
        emit(state.copyWith(isChatLoading: false, chatError: failure.message));
      },
      (conversation) {
        emit(
          state.copyWith(
            isChatLoading: false,
            chatConversation: conversation,
            chatError: null,
          ),
        );
      },
    );
  }

  Future<void> _onChatMessageSubmitted(
    StoryDetailChatMessageSubmitted event,
    Emitter<StoryDetailState> emit,
  ) async {
    final story = state.story;
    final conversation = state.chatConversation;
    if (story == null || conversation == null || state.isChatSending) return;
    if (!_isStoryOwnedByCurrentUser(story)) {
      emit(state.copyWith(chatError: _insightsOwnerOnlyMessage));
      return;
    }

    final text = event.message.trim();
    if (text.isEmpty) return;

    final optimisticConversation = conversation.copyWith(
      messages: [
        ...conversation.messages,
        StoryChatMessage(sender: 'user', text: text, timestamp: DateTime.now()),
      ],
      updatedAt: DateTime.now(),
    );

    emit(
      state.copyWith(
        isChatSending: true,
        chatError: null,
        chatConversation: optimisticConversation,
      ),
    );

    final result = await _repo.sendStoryChatMessage(
      story: story,
      conversation: conversation,
      message: text,
      language: state.selectedLanguage,
    );

    result.fold(
      (failure) {
        talker.error('Chat send failed: ${failure.message}');
        emit(
          state.copyWith(
            isChatSending: false,
            chatError: failure.message,
            chatConversation: optimisticConversation,
          ),
        );
      },
      (updatedConversation) {
        emit(
          state.copyWith(
            isChatSending: false,
            chatConversation: updatedConversation,
            chatError: null,
          ),
        );
      },
    );
  }

  Future<void> _onChatClosed(
    StoryDetailChatClosed event,
    Emitter<StoryDetailState> emit,
  ) async {
    emit(state.copyWith(chatError: null));
  }

  Future<void> _onCharacterDetailsClosed(
    StoryDetailCharacterDetailsClosed event,
    Emitter<StoryDetailState> emit,
  ) async {
    emit(state.copyWith(clearSelectedCharacterDetails: true));
  }

  // -------------------------
  // Helpers
  // -------------------------

  String _characterDetailsCacheKey(String name, String languageName) {
    final normalizedLanguageCode = _languageNameToCode(languageName);
    return buildCharacterDetailsCacheKey(
      characterName: name,
      languageCode: normalizedLanguageCode,
    );
  }

  @visibleForTesting
  static String buildCharacterDetailsCacheKey({
    required String characterName,
    required String languageCode,
  }) {
    final normalizedName = characterName.trim().toLowerCase();
    final normalizedLanguage = languageCode.trim().toLowerCase();
    return '$normalizedName::$normalizedLanguage';
  }

  bool _isStoryOwnedByCurrentUser(Story story) {
    try {
      final currentUserId = SupabaseService.client.auth.currentUser?.id;
      if (currentUserId == null || currentUserId.isEmpty) return false;
      return story.authorId == currentUserId ||
          story.authorUser?.id == currentUserId;
    } catch (_) {
      // Supabase may be unavailable in tests or before initialization.
      return false;
    }
  }

  List<StoryChapter> _parseChapters(String full) {
    final content = full
        .replaceAll('\\r\\n', '\n')
        .replaceAll('\\n', '\n')
        .replaceAll('\\r', '\n')
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .trim();
    if (content.isEmpty) return const [];

    final parts = content.split(RegExp(r'\n\s*-{5,}\s*\n'));

    final chapters = <StoryChapter>[];

    // First chunk => Chapter 1
    final first = parts.first.trim();
    if (first.isNotEmpty) {
      chapters.add(StoryChapter(number: 1, content: first));
    }

    for (var i = 1; i < parts.length; i++) {
      final chunk = parts[i].trim();
      if (chunk.isEmpty) continue;

      // Try to read "Chapter N" from the first line.
      final lines = chunk.split('\n');
      int number = i + 1;
      int startLine = 0;

      final m = RegExp(
        r'^Chapter\s+(\d+)\s*$',
        caseSensitive: false,
      ).firstMatch(lines.first.trim());
      if (m != null) {
        number = int.tryParse(m.group(1) ?? '') ?? number;
        startLine = 1;
      }

      final body = lines.skip(startLine).join('\n').trim();
      chapters.add(
        StoryChapter(number: number, content: body.isEmpty ? chunk : body),
      );
    }

    chapters.sort((a, b) => a.number.compareTo(b.number));
    return chapters;
  }

  /// Build the canonical stored content format:
  ///   Chapter1Content
  ///   -----
  ///   Chapter 2
  ///   `<chapter2>`
  ///   -----
  ///   Chapter 3
  ///   `<chapter3>`
  String _buildStoryContent(List<StoryChapter> chapters) {
    if (chapters.isEmpty) return '';

    final buffer = StringBuffer();
    buffer.write(chapters.first.content.trim());

    for (final chapter in chapters.skip(1)) {
      buffer.write(
        '\n\n-----\nChapter ${chapter.number}\n${chapter.content.trim()}\n',
      );
    }
    return buffer.toString().trim();
  }

  String _resolveInitialSelectedLanguage(
    Story story,
    String fallbackDisplayName,
  ) {
    final metadataCode = _languageNameToCode(story.attributes.languageStyle);
    final inferredCode = _resolveSourceLanguageCode(story);
    final fallbackCode = _languageNameToCode(fallbackDisplayName);

    if (story.attributes.languageStyle.trim().isEmpty) {
      return LanguageVoiceResolver.displayNameForCode(inferredCode);
    }

    // If metadata says English but story text is clearly in another script,
    // prefer inferred code so translation dropdown starts from source language.
    if (metadataCode == LanguageVoiceResolver.defaultLanguageCode &&
        inferredCode != LanguageVoiceResolver.defaultLanguageCode) {
      return LanguageVoiceResolver.displayNameForCode(inferredCode);
    }

    if (metadataCode.isNotEmpty) {
      return story.attributes.languageStyle;
    }

    return LanguageVoiceResolver.displayNameForCode(fallbackCode);
  }

  String _resolveSourceLanguageCode(Story story) {
    final originalStory = story.story.trim();
    if (originalStory.isEmpty) {
      return _languageNameToCode(story.attributes.languageStyle);
    }

    final inferredFromScript = _inferLanguageCodeFromScript(originalStory);
    final metadataCode = _languageNameToCode(story.attributes.languageStyle);

    // If metadata says English but script is clearly non-English,
    // trust script inference so English translation is not short-circuited.
    if (metadataCode == LanguageVoiceResolver.defaultLanguageCode &&
        inferredFromScript != LanguageVoiceResolver.defaultLanguageCode) {
      return inferredFromScript;
    }

    if (metadataCode != LanguageVoiceResolver.defaultLanguageCode ||
        inferredFromScript == LanguageVoiceResolver.defaultLanguageCode) {
      return metadataCode;
    }

    return inferredFromScript;
  }

  String _inferLanguageCodeFromScript(String text) {
    if (text.trim().isEmpty) return LanguageVoiceResolver.defaultLanguageCode;

    int countMatches(RegExp scriptPattern) {
      return scriptPattern.allMatches(text).length;
    }

    final scriptCounts = <String, int>{
      'hi': countMatches(RegExp(r'[\u0900-\u097F]')), // Devanagari
      'bn': countMatches(RegExp(r'[\u0980-\u09FF]')), // Bengali/Assamese
      'pa': countMatches(RegExp(r'[\u0A00-\u0A7F]')), // Gurmukhi
      'gu': countMatches(RegExp(r'[\u0A80-\u0AFF]')), // Gujarati
      'or': countMatches(RegExp(r'[\u0B00-\u0B7F]')), // Odia
      'ta': countMatches(RegExp(r'[\u0B80-\u0BFF]')), // Tamil
      'te': countMatches(RegExp(r'[\u0C00-\u0C7F]')), // Telugu
      'kn': countMatches(RegExp(r'[\u0C80-\u0CFF]')), // Kannada
      'ml': countMatches(RegExp(r'[\u0D00-\u0D7F]')), // Malayalam
      'ur': countMatches(RegExp(r'[\u0600-\u06FF]')), // Arabic script/Urdu
    };

    var bestCode = LanguageVoiceResolver.defaultLanguageCode;
    var bestCount = 0;
    for (final entry in scriptCounts.entries) {
      if (entry.value > bestCount) {
        bestCode = entry.key;
        bestCount = entry.value;
      }
    }

    // Avoid false positives from stray glyphs while still detecting short stories.
    if (bestCount < 5) {
      return LanguageVoiceResolver.defaultLanguageCode;
    }

    return bestCode;
  }

  String _normalizeTranslationComparisonText(String? input) {
    if (input == null || input.isEmpty) return '';
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'[^\p{L}\p{N} ]', unicode: true), '')
        .trim();
  }
}
