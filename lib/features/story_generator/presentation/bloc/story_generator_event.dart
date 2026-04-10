import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myitihas/features/story_generator/domain/entities/generator_options.dart';
import 'package:myitihas/features/story_generator/domain/entities/quick_prompt.dart';

part 'story_generator_event.freezed.dart';

/// Events for the Story Generator BLoC
@freezed
sealed class StoryGeneratorEvent with _$StoryGeneratorEvent {
  /// Initialize the generator with default values
  const factory StoryGeneratorEvent.initialize({String? initialPrompt}) = _Initialize;

  /// Toggle between interactive and raw prompt modes
  const factory StoryGeneratorEvent.togglePromptType({
    required bool isRawPrompt,
  }) = _TogglePromptType;

  /// Select an option for a specific category
  const factory StoryGeneratorEvent.selectOption({
    required String category,
    required String value,
    String? parentValue,
  }) = _SelectOption;

  /// Update the raw prompt text
  const factory StoryGeneratorEvent.updateRawPrompt({required String text}) =
      _UpdateRawPrompt;

  /// Apply a quick prompt preset
  const factory StoryGeneratorEvent.applyQuickPrompt({
    required QuickPrompt quickPrompt,
  }) = _ApplyQuickPrompt;

  /// Randomize all options
  const factory StoryGeneratorEvent.randomize() = _Randomize;

  /// Update generator options (language, format, length)
  const factory StoryGeneratorEvent.updateGeneratorOptions({
    StoryLanguage? language,
    StoryFormat? format,
    StoryLength? length,
  }) = _UpdateGeneratorOptions;

  /// Generate the story
  const factory StoryGeneratorEvent.generate() = _Generate;

  /// Generate an image for the current story
  const factory StoryGeneratorEvent.generateImage() = _GenerateImage;

  /// Reset all selections
  const factory StoryGeneratorEvent.reset() = _Reset;

  /// Load generated stories history
  const factory StoryGeneratorEvent.loadHistory({
    @Default(false) bool loadMore,
  }) = _LoadHistory;

  /// Check connectivity status
  const factory StoryGeneratorEvent.checkConnectivity() = _CheckConnectivity;

  /// Start or stop voice input
  const factory StoryGeneratorEvent.toggleVoiceInput() = _ToggleVoiceInput;

  /// Speech engine ended the listen session (timeout / done); sync UI only.
  const factory StoryGeneratorEvent.voiceListenEngineStopped() =
      _VoiceListenEngineStopped;

  /// Update voice input partial result
  const factory StoryGeneratorEvent.updateVoiceResult({
    required String text,
    @Default(false) bool isFinal,
  }) = _UpdateVoiceResult;
}
