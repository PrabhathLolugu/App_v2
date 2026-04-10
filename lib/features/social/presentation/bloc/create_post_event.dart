import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myitihas/services/post_service.dart';

part 'create_post_event.freezed.dart';

@freezed
sealed class CreatePostEvent with _$CreatePostEvent {
  const factory CreatePostEvent.initialize() = InitializeCreatePostEvent;

  const factory CreatePostEvent.selectType(PostType type) = SelectPostTypeEvent;

  const factory CreatePostEvent.updateContent(String content) =
      UpdateContentEvent;

  const factory CreatePostEvent.updateTitle(String title) = UpdateTitleEvent;

  const factory CreatePostEvent.addMedia(List<File> files) = AddMediaEvent;

  /// Replaces all media with edited files (e.g. after image edit screen). [aspectRatios] length must match [files]; use null for unknown.
  const factory CreatePostEvent.setMedia(
    List<File> files, {
    @Default([]) List<double?> aspectRatios,
  }) = SetMediaEvent;

  const factory CreatePostEvent.replaceMedia(
    int index,
    File file, {
    double? aspectRatio,
    int? durationSeconds,
    double? startSeconds,
    double? endSeconds,
    double? playbackSpeed,
  }) = ReplaceMediaEvent;

  const factory CreatePostEvent.removeMedia(int index) = RemoveMediaEvent;
  const factory CreatePostEvent.changeVisibility(PostVisibility visibility) =
      ChangeVisibilityEvent;

  /// Toggle between posting immediately and scheduling for later.
  const factory CreatePostEvent.toggleScheduling(bool isScheduled) =
      ToggleSchedulingEvent;

  /// Update the selected scheduled time (device local / IST).
  const factory CreatePostEvent.updateScheduledAt(DateTime scheduledAtLocal) =
      UpdateScheduledAtEvent;

  const factory CreatePostEvent.togglePoll(bool enabled) = TogglePollEvent;

  const factory CreatePostEvent.updatePollOption(int index, String value) =
      UpdatePollOptionEvent;

  const factory CreatePostEvent.addPollOption() = AddPollOptionEvent;

  const factory CreatePostEvent.removePollOption(int index) =
      RemovePollOptionEvent;

  const factory CreatePostEvent.submit() = SubmitPostEvent;

  const factory CreatePostEvent.reset() = ResetCreatePostEvent;
}
