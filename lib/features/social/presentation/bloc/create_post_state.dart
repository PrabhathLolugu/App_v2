import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myitihas/services/post_service.dart';

part 'create_post_state.freezed.dart';

/// Per-media edit metadata.
///
/// This is the in-memory representation of the editing state for a single
/// media item (image or video). It is later serialized into the `metadata`
/// column on the `posts` row as part of the `media_meta` array.
class MediaEditInfo {
  const MediaEditInfo({
    this.aspectRatio,
    this.durationSeconds,
    this.rotationDegrees,
    this.isFlippedHorizontally,
    this.filterName,
    this.startSeconds,
    this.endSeconds,
    this.coverUrl,
    this.playbackSpeed,
  });

  /// Aspect ratio for images (width / height) or videos after editing.
  final double? aspectRatio;

  /// Duration in seconds for trimmed videos.
  final int? durationSeconds;

  /// Clockwise rotation in degrees (e.g. 0, 90, 180, 270).
  final int? rotationDegrees;

  /// Whether the media is flipped horizontally.
  final bool? isFlippedHorizontally;

  /// Optional filter identifier applied to the media (e.g. 'warm', 'mono').
  final String? filterName;

  /// Normalized or absolute start time for trimmed video segments (in seconds).
  final double? startSeconds;

  /// Normalized or absolute end time for trimmed video segments (in seconds).
  final double? endSeconds;

  /// Optional URL for a generated cover image (primarily for videos).
  final String? coverUrl;

  /// Playback speed applied during edit (e.g. 0.5, 1.0, 1.5, 2.0).
  final double? playbackSpeed;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaEditInfo &&
          runtimeType == other.runtimeType &&
          aspectRatio == other.aspectRatio &&
          durationSeconds == other.durationSeconds &&
          rotationDegrees == other.rotationDegrees &&
          isFlippedHorizontally == other.isFlippedHorizontally &&
          filterName == other.filterName &&
          startSeconds == other.startSeconds &&
          endSeconds == other.endSeconds &&
          coverUrl == other.coverUrl &&
          playbackSpeed == other.playbackSpeed;

  @override
  int get hashCode => Object.hash(
    aspectRatio,
    durationSeconds,
    rotationDegrees,
    isFlippedHorizontally,
    filterName,
    startSeconds,
    endSeconds,
    coverUrl,
    playbackSpeed,
  );
}

@freezed
abstract class CreatePostState with _$CreatePostState {
  const CreatePostState._();

  const factory CreatePostState({
    @Default(PostType.text) PostType postType,

    @Default('') String content,

    @Default('') String title,

    @Default([]) List<File> mediaFiles,

    /// Same length as [mediaFiles]. Optional aspect ratio (image) or duration (video).
    @Default([]) List<MediaEditInfo?> mediaEditInfos,

    @Default(PostVisibility.public) PostVisibility visibility,

    @Default(false) bool isSubmitting,

    String? errorMessage,

    /// When true, the post will be scheduled instead of published immediately.
    @Default(false) bool isScheduled,

    /// The user-selected scheduled time in the device's local timezone
    /// (intended to be IST for most users).
    DateTime? scheduledAtLocal,

    /// Validation message specifically for scheduling issues (e.g. time in past).
    String? schedulingErrorMessage,

    @Default(false) bool isSuccess,

    String? createdPostId,

    @Default(false) bool isOfflineError,

    @Default(false) bool showValidationError,

    @Default(false) bool pollEnabled,

    @Default([]) List<String> pollOptions,
  }) = _CreatePostState;

  bool get hasContent =>
      content.isNotEmpty ||
      title.isNotEmpty ||
      mediaFiles.isNotEmpty ||
      pollEnabled ||
      pollOptions.any((option) => option.trim().isNotEmpty);

  static const int minPollOptions = 2;
  static const int maxPollOptions = 4;

  List<String> get normalizedPollOptions => pollOptions
      .map((option) => option.trim())
      .where((option) => option.isNotEmpty)
      .toList();

  bool get isPollValid {
    if (!pollEnabled) return true;
    final normalized = normalizedPollOptions;
    return normalized.length >= minPollOptions &&
        normalized.length <= maxPollOptions;
  }

  bool get canSubmit {
    if (isSubmitting) return false;

    switch (postType) {
      case PostType.text:
        return content.isNotEmpty && isPollValid;
      case PostType.image:
        return mediaFiles.isNotEmpty;
      case PostType.video:
        return mediaFiles.isNotEmpty;
      case PostType.storyShare:
        return content.isNotEmpty;
    }
  }

  String? get validationMessage {
    switch (postType) {
      case PostType.text:
        if (content.isEmpty) return 'Please enter some text';
        if (pollEnabled && !isPollValid) {
          return 'Please add 2 to 4 poll options';
        }
        return null;
      case PostType.image:
        if (mediaFiles.isEmpty) return 'Please select at least one image';
        return null;
      case PostType.video:
        if (mediaFiles.isEmpty) return 'Please select a video';
        return null;
      case PostType.storyShare:
        return null;
    }
  }
}
