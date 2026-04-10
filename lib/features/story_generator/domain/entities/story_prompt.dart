import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_prompt.freezed.dart';

/// Represents the user's selected options for story generation
@freezed
abstract class StoryPrompt with _$StoryPrompt {
  const factory StoryPrompt({
    String? scripture,
    String? scriptureSubtype,
    String? storyType,
    String? theme,
    String? mainCharacter,
    String? setting,
    String? rawPrompt,
    @Default(false) bool isRawPrompt,
  }) = _StoryPrompt;

  const StoryPrompt._();

  /// Check if all required interactive options are selected
  bool get isComplete {
    if (isRawPrompt) {
      return rawPrompt != null && rawPrompt!.trim().isNotEmpty;
    }
    return scripture != null &&
        storyType != null &&
        theme != null &&
        mainCharacter != null &&
        setting != null;
  }

  /// Get a human-readable summary of selected options
  String get summary {
    if (isRawPrompt) {
      return rawPrompt ?? '';
    }
    final parts = <String>[];
    if (scripture != null) parts.add(scripture!);
    if (storyType != null) parts.add(storyType!);
    if (theme != null) parts.add(theme!);
    if (mainCharacter != null) parts.add(mainCharacter!);
    if (setting != null) parts.add(setting!);
    return parts.join(' • ');
  }
}
