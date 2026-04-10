import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:myitihas/core/logging/talker_setup.dart';
import 'package:myitihas/core/network/network_info.dart';
import 'package:myitihas/core/usecases/usecase.dart';
import 'package:myitihas/core/utils/content_language.dart';
import 'package:myitihas/features/story_generator/domain/entities/generator_options.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/features/story_generator/domain/entities/quick_prompt.dart';
import 'package:myitihas/features/story_generator/domain/entities/story_prompt.dart';
import 'package:myitihas/features/story_generator/domain/usecases/generate_story.dart';
import 'package:myitihas/features/story_generator/domain/usecases/generate_story_image.dart';
import 'package:myitihas/features/story_generator/domain/usecases/get_generated_stories.dart';
import 'package:myitihas/features/story_generator/domain/usecases/randomize_options.dart';
import 'package:myitihas/core/widgets/voice_input/microphone_permission_helper.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:myitihas/features/stories/domain/entities/story_options.dart';

import 'package:myitihas/features/home/domain/entities/activity_item.dart';
import 'package:myitihas/features/home/data/datasources/activity_local_datasource.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'story_generator_event.dart';
import 'story_generator_state.dart';

export 'story_generator_event.dart';
export 'story_generator_state.dart';

/// BLoC for managing story generation state
@injectable
class StoryGeneratorBloc
    extends Bloc<StoryGeneratorEvent, StoryGeneratorState> {
  final GenerateStory generateStory;
  final GenerateStoryImage generateStoryImage;
  final GetGeneratedStories getGeneratedStories;
  final RandomizeOptions randomizeOptions;
  final NetworkInfo _networkInfo;
  final ActivityLocalDataSource _activityDataSource;

  final SpeechToText _speechToText = SpeechToText();
  bool _isSpeechInitialized = false;

  StreamSubscription<InternetStatus>? _connectivitySubscription;

  StoryGeneratorBloc({
    required this.generateStory,
    required this.generateStoryImage,
    required this.getGeneratedStories,
    required this.randomizeOptions,
    required NetworkInfo networkInfo,
    required ActivityLocalDataSource activityDataSource,
  }) : _networkInfo = networkInfo,
       _activityDataSource = activityDataSource,
       super(const StoryGeneratorState()) {
    on<StoryGeneratorEvent>((event, emit) async {
      await event.when(
        initialize: (initialPrompt) => _onInitialize(initialPrompt, emit),
        togglePromptType: (isRawPrompt) =>
            _onTogglePromptType(isRawPrompt, emit),
        selectOption: (category, value, parentValue) =>
            _onSelectOption(category, value, parentValue, emit),
        updateRawPrompt: (text) => _onUpdateRawPrompt(text, emit),
        applyQuickPrompt: (quickPrompt) =>
            _onApplyQuickPrompt(quickPrompt, emit),
        randomize: () => _onRandomize(emit),
        updateGeneratorOptions: (language, format, length) =>
            _onUpdateGeneratorOptions(language, format, length, emit),
        generate: () => _onGenerate(emit),
        reset: () => _onReset(emit),
        generateImage: () => _onGenerateImage(emit),
        loadHistory: (loadMore) => _onLoadHistory(loadMore, emit),
        checkConnectivity: () => _onCheckConnectivity(emit),
        toggleVoiceInput: () => _onToggleVoiceInput(emit),
        voiceListenEngineStopped: () async => _onVoiceListenEngineStopped(emit),
        updateVoiceResult: (text, isFinal) =>
            _onUpdateVoiceResult(text, isFinal, emit),
      );
    });

    // Listen to connectivity changes
    _connectivitySubscription = InternetConnection().onStatusChange.listen((
      InternetStatus status,
    ) {
      add(const StoryGeneratorEvent.checkConnectivity());
    });

    // Check initial connectivity
    add(const StoryGeneratorEvent.checkConnectivity());
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadHistory(
    bool loadMore,
    Emitter<StoryGeneratorState> emit,
  ) async {
    if (state.isLoadingHistory) return;
    if (loadMore && !state.hasMoreHistory) return;

    talker.info('Loading generated stories history (loadMore: $loadMore)');
    emit(state.copyWith(isLoadingHistory: true));

    final int limit = 10;
    final int offset = loadMore ? state.history.length : 0;

    final result = await getGeneratedStories(
      GetGeneratedStoriesParams(limit: limit, offset: offset),
    );

    result.fold(
      (failure) {
        talker.error('Failed to load history: ${failure.message}');
        emit(state.copyWith(isLoadingHistory: false));
      },
      (stories) {
        talker.info('Loaded ${stories.length} stories from history');
        
        final combinedList = loadMore ? [...state.history, ...stories] : stories;
        
        // Deduplicate stories by title
        final uniqueStories = <String, Story>{};
        for (final story in combinedList) {
          final key = story.title;
          if (!uniqueStories.containsKey(key)) {
            uniqueStories[key] = story;
          } else {
            // Keep the one with an image or the newest one
            final existingStory = uniqueStories[key]!;
            final existingHasImage = existingStory.imageUrl != null && existingStory.imageUrl!.isNotEmpty;
            final newHasImage = story.imageUrl != null && story.imageUrl!.isNotEmpty;
            
            if (!existingHasImage && newHasImage) {
              uniqueStories[key] = story;
            } else if (existingHasImage && newHasImage) {
              final existingTime = existingStory.updatedAt ?? existingStory.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
              final newTime = story.updatedAt ?? story.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
              if (newTime.isAfter(existingTime)) {
                uniqueStories[key] = story;
              }
            }
          }
        }
        
        final deduplicatedStories = uniqueStories.values.toList();
        deduplicatedStories.sort((a, b) {
          final aTime = a.updatedAt ?? a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bTime = b.updatedAt ?? b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bTime.compareTo(aTime);
        });

        emit(
          state.copyWith(
            isLoadingHistory: false,
            history: deduplicatedStories,
            hasMoreHistory: stories.length == limit,
          ),
        );
      },
    );
  }

  Future<void> _onCheckConnectivity(Emitter<StoryGeneratorState> emit) async {
    final isOnline = await _networkInfo.isConnected;
    emit(state.copyWith(isOnline: isOnline));
  }

  Future<void> _onGenerateImage(Emitter<StoryGeneratorState> emit) async {
    final story = state.generatedStory;
    if (story == null) {
      talker.warning('Cannot generate image: no story generated yet');
      return;
    }

    talker.info('Starting story image generation');
    emit(state.copyWith(isGeneratingImage: true, imageGenerationError: null));

    final result = await generateStoryImage(
      GenerateStoryImageParams(
        title: story.title,
        story: story.story,
        moral: story.lesson,
      ),
    );

    result.fold(
      (failure) {
        talker.error('Failed to generate story image: ${failure.message}');
        emit(
          state.copyWith(
            isGeneratingImage: false,
            imageGenerationError: failure.message,
          ),
        );
      },
      (imageUrl) {
        talker.info('Story image generated successfully');
        emit(state.copyWith(isGeneratingImage: false, storyImageUrl: imageUrl));
      },
    );
  }

  Future<void> _onInitialize(
    String? initialPrompt,
    Emitter<StoryGeneratorState> emit,
  ) async {
    talker.info('Initializing story generator with initialPrompt: $initialPrompt');
    final defaultLanguage = await ContentLanguageSettings.getCurrentLanguage();

    if (initialPrompt != null && initialPrompt.isNotEmpty) {
      emit(
        StoryGeneratorState(
          options: GeneratorOptions(language: defaultLanguage),
          isRawPromptMode: true,
          rawPrompt: StoryPrompt(isRawPrompt: true, rawPrompt: initialPrompt),
        ),
      );
    } else {
      emit(
        StoryGeneratorState(
          options: GeneratorOptions(language: defaultLanguage),
        ),
      );
    }
  }

  Future<void> _onTogglePromptType(
    bool isRawPrompt,
    Emitter<StoryGeneratorState> emit,
  ) async {
    talker.info('Toggling prompt type to raw: $isRawPrompt');
    emit(state.copyWith(isRawPromptMode: isRawPrompt, errorMessage: null));
  }

  Future<void> _onSelectOption(
    String category,
    String value,
    String? parentValue,
    Emitter<StoryGeneratorState> emit,
  ) async {
    talker.info('Selecting option: $category = $value');

    final currentPrompt = state.prompt;
    StoryPrompt updatedPrompt;
    switch (category) {
      case 'scripture':
        updatedPrompt = currentPrompt.copyWith(
          scripture: value,
          scriptureSubtype: parentValue,
        );
        break;
      case 'storyType':
        updatedPrompt = currentPrompt.copyWith(storyType: value);
        break;
      case 'theme':
        updatedPrompt = currentPrompt.copyWith(theme: value);
        break;
      case 'mainCharacter':
        updatedPrompt = currentPrompt.copyWith(mainCharacter: value);
        break;
      case 'setting':
        updatedPrompt = currentPrompt.copyWith(setting: value);
        break;
      default:
        return;
    }

    // Update the correct prompt based on current mode
    if (state.isRawPromptMode) {
      emit(state.copyWith(rawPrompt: updatedPrompt, errorMessage: null));
    } else {
      emit(
        state.copyWith(interactivePrompt: updatedPrompt, errorMessage: null),
      );
    }
  }

  Future<void> _onUpdateRawPrompt(
    String text,
    Emitter<StoryGeneratorState> emit,
  ) async {
    emit(
      state.copyWith(
        rawPrompt: state.rawPrompt.copyWith(rawPrompt: text),
        errorMessage: null,
      ),
    );
  }

  Future<void> _onApplyQuickPrompt(
    QuickPrompt quickPrompt,
    Emitter<StoryGeneratorState> emit,
  ) async {
    talker.info('Applying quick prompt: ${quickPrompt.title}');
    // Quick prompts are applied to the interactive prompt and switch to interactive mode
    emit(
      state.copyWith(
        interactivePrompt: quickPrompt.presetOptions,
        isRawPromptMode: false,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onRandomize(Emitter<StoryGeneratorState> emit) async {
    talker.info('Randomizing options');
    emit(state.copyWith(isLoadingOptions: true, errorMessage: null));

    final result = await randomizeOptions(NoParams());

    result.fold(
      (failure) {
        talker.error('Failed to randomize options: ${failure.message}');
        emit(
          state.copyWith(
            isLoadingOptions: false,
            errorMessage: failure.message,
          ),
        );
      },
      (prompt) {
        talker.info('Randomized options: ${prompt.summary}');
        // Randomize applies to interactive prompt
        emit(
          state.copyWith(isLoadingOptions: false, interactivePrompt: prompt),
        );
      },
    );
  }

  Future<void> _onUpdateGeneratorOptions(
    StoryLanguage? language,
    StoryFormat? format,
    StoryLength? length,
    Emitter<StoryGeneratorState> emit,
  ) async {
    final newLanguage = language ?? state.options.language;
    final updatedOptions = state.options.copyWith(
      language: newLanguage,
      format: format ?? state.options.format,
      length: length ?? state.options.length,
    );
    emit(state.copyWith(options: updatedOptions));

    // Persist global content language when user explicitly changes it.
    if (language != null) {
      await ContentLanguageSettings.setCurrentLanguage(newLanguage);
    }
  }

  Future<void> _onGenerate(Emitter<StoryGeneratorState> emit) async {
    if (!state.canGenerate) {
      talker.warning('Cannot generate: prompt is incomplete');
      emit(
        state.copyWith(errorMessage: 'Please complete all required options'),
      );
      return;
    }

    // Check online before generation
    final isOnline = await _networkInfo.isConnected;
    if (!isOnline) {
      emit(
        state.copyWith(
          errorMessage: 'Story generation requires internet connection',
        ),
      );
      return;
    }

    talker.info('Starting story generation');

    // Progress messages for loading overlay
    final progressMessages = [
      'Consulting the ancient scriptures...',
      'Weaving your tale...',
      'Adding divine wisdom...',
      'Polishing the narrative...',
      'Almost there...',
    ];

    emit(
      state.copyWith(
        isGenerating: true,
        generatingMessage: progressMessages[0],
        errorMessage: null,
        generatedStory: null,
      ),
    );

    // Start progress message rotation
    int messageIndex = 0;
    final progressTimer = Timer.periodic(const Duration(milliseconds: 800), (
      timer,
    ) {
      messageIndex = (messageIndex + 1) % progressMessages.length;
      if (!emit.isDone) {
        emit(state.copyWith(generatingMessage: progressMessages[messageIndex]));
      }
    });

    final result = await generateStory(
      GenerateStoryParams(prompt: state.prompt, options: state.options),
    );

    progressTimer.cancel();

    result.fold(
      (failure) {
        talker.error('Failed to generate story: ${failure.message}');
        emit(
          state.copyWith(
            isGenerating: false,
            generatingMessage: null,
            errorMessage: failure.message,
          ),
        );
      },
      (story) {
        talker.info('Story generated: ${story.title}');
        
        // Record activity
        _activityDataSource.recordActivity(
          ActivityItem(
            id: ActivityLocalDataSource.generateActivityId(),
            type: ActivityType.storyGenerated,
            storyId: story.id,
            storyTitle: story.title,
            timestamp: DateTime.now(),
            thumbnailUrl: story.imageUrl,
            scripture: story.scripture,
          ),
        );

        emit(
          state.copyWith(
            isGenerating: false,
            generatingMessage: null,
            generatedStory: story,
          ),
        );
      },
    );
  }

  Future<void> _onReset(Emitter<StoryGeneratorState> emit) async {
    talker.info('Resetting story generator');
    emit(const StoryGeneratorState());
  }

  Future<void> _onToggleVoiceInput(Emitter<StoryGeneratorState> emit) async {
    if (state.isListening) {
      await _speechToText.stop();
      emit(state.copyWith(isListening: false));
    } else {
      if (!_isSpeechInitialized) {
        final micOk = await requestMicrophonePermission();
        if (!micOk) {
          emit(state.copyWith(errorMessage: 'Microphone permission denied'));
          return;
        }

        // Allow system to apply one-time grant before starting speech (e.g. Samsung).
        await Future<void>.delayed(const Duration(milliseconds: 150));

        try {
          _isSpeechInitialized = await _speechToText.initialize(
            onError: (val) {
              talker.error('Speech error: ${val.errorMsg}');
            },
            finalTimeout: const Duration(seconds: 5),
            onStatus: (val) {
              talker.debug('Speech status: $val');
              if (val == SpeechToText.doneStatus ||
                  val == SpeechToText.notListeningStatus) {
                add(const StoryGeneratorEvent.voiceListenEngineStopped());
              }
            },
          );
        } catch (e) {
          talker.error('Voice initialization error: $e');
          emit(
            state.copyWith(errorMessage: 'Failed to initialize voice input'),
          );
          return;
        }
      }

      if (_isSpeechInitialized) {
        emit(state.copyWith(isListening: true, partialVoiceResult: ''));
        try {
          await _speechToText.listen(
            onResult: (result) {
              add(
                StoryGeneratorEvent.updateVoiceResult(
                  text: result.recognizedWords,
                  isFinal: result.finalResult,
                ),
              );
            },
            listenFor: const Duration(minutes: 3),
            pauseFor: const Duration(seconds: 30),
            listenOptions: SpeechListenOptions(
              listenMode: ListenMode.dictation,
              partialResults: true,
            ),
          );
        } catch (e) {
          talker.error('Voice listen error: $e');
          emit(
            state.copyWith(
              isListening: false,
              errorMessage: 'Failed to start listening',
            ),
          );
        }
      } else {
        emit(state.copyWith(errorMessage: 'Speech recognition not available'));
      }
    }
  }

  void _onVoiceListenEngineStopped(Emitter<StoryGeneratorState> emit) {
    if (!state.isListening) return;
    emit(state.copyWith(isListening: false, partialVoiceResult: null));
  }

  Future<void> _onUpdateVoiceResult(
    String text,
    bool isFinal,
    Emitter<StoryGeneratorState> emit,
  ) async {
    emit(state.copyWith(partialVoiceResult: text));

    if (isFinal) {
      if (!state.isRawPromptMode) {
        // Interactive mode: try to map voice to options
        final mapped = _mapVoiceToInteractiveOptions(text.trim());
        if (mapped != null) {
          await _speechToText.stop();
          emit(
            state.copyWith(
              interactivePrompt: state.interactivePrompt.copyWith(
                scripture: mapped.scripture ?? state.interactivePrompt.scripture,
                scriptureSubtype: mapped.scriptureSubtype ??
                    state.interactivePrompt.scriptureSubtype,
                storyType:
                    mapped.storyType ?? state.interactivePrompt.storyType,
                theme: mapped.theme ?? state.interactivePrompt.theme,
                mainCharacter:
                    mapped.mainCharacter ?? state.interactivePrompt.mainCharacter,
                setting: mapped.setting ?? state.interactivePrompt.setting,
              ),
              partialVoiceResult: null,
              isListening: false,
            ),
          );
          return;
        }
      }

      // Raw mode or no mapping: append to raw prompt; keep listening for more.
      final currentText = state.rawPrompt.rawPrompt;
      final newText =
          currentText != null &&
              (currentText.isEmpty || currentText.endsWith(' '))
          ? text
          : '$currentText $text';
      emit(
        state.copyWith(
          rawPrompt: state.rawPrompt.copyWith(
            rawPrompt: capitalizeFirstLetter(newText
                .replaceFirst('null ', '')
                .replaceFirst('null', '')),
          ),
          partialVoiceResult: null,
        ),
      );
    }
  }

  /// Attempts to parse voice text and map to interactive prompt options.
  /// Returns non-null if at least one category was matched.
  _InteractiveMapping? _mapVoiceToInteractiveOptions(String text) {
    if (text.isEmpty) return null;
    final lower = text.toLowerCase();
    String? scripture;
    String? scriptureSubtype;
    String? storyType;
    String? theme;
    String? mainCharacter;
    String? setting;

    // Check scripture subtypes first (more specific)
    // selectOption uses value for scripture, parent for scriptureSubtype
    final scriptureData = storyOptions['scripture'];
    if (scriptureData != null) {
      final subtypes = scriptureData['subtypes'] as Map<String, dynamic>?;
      if (subtypes != null) {
        for (final entry in subtypes.entries) {
          final parent = entry.key;
          final children = entry.value as List<dynamic>;
          for (final child in children) {
            final childStr = child.toString();
            if (lower.contains(childStr.toLowerCase())) {
              scripture = childStr; // value = subtype
              scriptureSubtype = parent; // parent = category
              break;
            }
          }
          if (scripture != null) break;
        }
      }
      if (scripture == null) {
        final types = scriptureData['types'] as List<dynamic>? ?? [];
        for (final t in types) {
          if (lower.contains(t.toString().toLowerCase())) {
            scripture = t.toString();
            break;
          }
        }
      }
    }

    // Check storyType, theme, mainCharacter, setting
    for (final category in ['storyType', 'theme', 'mainCharacter', 'setting']) {
      final data = storyOptions[category];
      if (data == null) continue;
      final types = data['types'] as List<dynamic>? ?? [];
      for (final t in types) {
        final opt = t.toString();
        if (lower.contains(opt.toLowerCase())) {
          switch (category) {
            case 'storyType':
              storyType = opt;
              break;
            case 'theme':
              theme = opt;
              break;
            case 'mainCharacter':
              mainCharacter = opt;
              break;
            case 'setting':
              setting = opt;
              break;
          }
          break;
        }
      }
    }

    if (scripture != null ||
        scriptureSubtype != null ||
        storyType != null ||
        theme != null ||
        mainCharacter != null ||
        setting != null) {
      return _InteractiveMapping(
        scripture: scripture,
        scriptureSubtype: scriptureSubtype,
        storyType: storyType,
        theme: theme,
        mainCharacter: mainCharacter,
        setting: setting,
      );
    }
    return null;
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input; // Return as is if string is empty
    return input[0].toUpperCase() + input.substring(1);
  }
}

/// Helper class for voice-to-interactive mapping result
class _InteractiveMapping {
  final String? scripture;
  final String? scriptureSubtype;
  final String? storyType;
  final String? theme;
  final String? mainCharacter;
  final String? setting;

  _InteractiveMapping({
    this.scripture,
    this.scriptureSubtype,
    this.storyType,
    this.theme,
    this.mainCharacter,
    this.setting,
  });
}
