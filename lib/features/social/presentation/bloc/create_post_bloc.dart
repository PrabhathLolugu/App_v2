import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/services/post_service.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'create_post_event.dart';
import 'create_post_state.dart';

@injectable
class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final PostService _postService;
  final InternetConnection _internetConnection;

  CreatePostBloc(
    this._postService, {
    required InternetConnection internetConnection,
  }) : _internetConnection = internetConnection,
       super(const CreatePostState()) {
    on<InitializeCreatePostEvent>(_onInitialize);
    on<SelectPostTypeEvent>(_onSelectType);
    on<UpdateContentEvent>(_onUpdateContent);
    on<UpdateTitleEvent>(_onUpdateTitle);
    on<AddMediaEvent>(_onAddMedia);
    on<SetMediaEvent>(_onSetMedia);
    on<ReplaceMediaEvent>(_onReplaceMedia);
    on<RemoveMediaEvent>(_onRemoveMedia);
    on<ChangeVisibilityEvent>(_onChangeVisibility);
    on<ToggleSchedulingEvent>(_onToggleScheduling);
    on<UpdateScheduledAtEvent>(_onUpdateScheduledAt);
    on<TogglePollEvent>(_onTogglePoll);
    on<UpdatePollOptionEvent>(_onUpdatePollOption);
    on<AddPollOptionEvent>(_onAddPollOption);
    on<RemovePollOptionEvent>(_onRemovePollOption);
    on<SubmitPostEvent>(_onSubmit);
    on<ResetCreatePostEvent>(_onReset);
  }

  void _onInitialize(
    InitializeCreatePostEvent event,
    Emitter<CreatePostState> emit,
  ) {
    emit(const CreatePostState());
  }

  void _onSelectType(SelectPostTypeEvent event, Emitter<CreatePostState> emit) {
    final isTextType = event.type == PostType.text;
    emit(
      state.copyWith(
        postType: event.type,
        mediaFiles: [],
        mediaEditInfos: [],
        pollEnabled: isTextType ? state.pollEnabled : false,
        pollOptions: isTextType ? state.pollOptions : const [],
        errorMessage: null,
        showValidationError: false,
      ),
    );
  }

  void _onUpdateContent(
    UpdateContentEvent event,
    Emitter<CreatePostState> emit,
  ) {
    emit(
      state.copyWith(
        content: event.content,
        errorMessage: null,
        showValidationError: false,
      ),
    );
  }

  void _onUpdateTitle(UpdateTitleEvent event, Emitter<CreatePostState> emit) {
    emit(
      state.copyWith(
        title: event.title,
        errorMessage: null,
        showValidationError: false,
      ),
    );
  }

  void _onAddMedia(AddMediaEvent event, Emitter<CreatePostState> emit) {
    final maxFiles = state.postType == PostType.video ? 1 : 10;
    final newFiles = [
      ...state.mediaFiles,
      ...event.files,
    ].take(maxFiles).toList();
    final newInfos = [
      ...state.mediaEditInfos,
      ...List<MediaEditInfo?>.filled(event.files.length, null),
    ].take(maxFiles).toList();

    emit(
      state.copyWith(
        mediaFiles: newFiles,
        mediaEditInfos: newInfos,
        errorMessage: null,
        showValidationError: false,
      ),
    );
  }

  void _onSetMedia(SetMediaEvent event, Emitter<CreatePostState> emit) {
    final maxFiles = state.postType == PostType.video ? 1 : 10;
    final files = event.files.take(maxFiles).toList();
    final ratios = event.aspectRatios;
    final infos = List<MediaEditInfo?>.generate(
      files.length,
      (i) => i < ratios.length && ratios[i] != null
          ? MediaEditInfo(aspectRatio: ratios[i])
          : null,
    );
    emit(
      state.copyWith(
        mediaFiles: files,
        mediaEditInfos: infos,
        errorMessage: null,
        showValidationError: false,
      ),
    );
  }

  void _onReplaceMedia(ReplaceMediaEvent event, Emitter<CreatePostState> emit) {
    if (event.index < 0 || event.index >= state.mediaFiles.length) return;
    final newFiles = [...state.mediaFiles]..[event.index] = event.file;
    final info = MediaEditInfo(
      aspectRatio: event.aspectRatio,
      durationSeconds: event.durationSeconds,
      startSeconds: event.startSeconds,
      endSeconds: event.endSeconds,
      playbackSpeed: event.playbackSpeed,
    );
    final newInfos = [...state.mediaEditInfos];
    while (newInfos.length <= event.index) {
      newInfos.add(null);
    }
    newInfos[event.index] = info;

    emit(
      state.copyWith(
        mediaFiles: newFiles,
        mediaEditInfos: newInfos,
        errorMessage: null,
        showValidationError: false,
      ),
    );
  }

  void _onRemoveMedia(RemoveMediaEvent event, Emitter<CreatePostState> emit) {
    if (event.index >= 0 && event.index < state.mediaFiles.length) {
      final newFiles = [...state.mediaFiles]..removeAt(event.index);
      final newInfos = [...state.mediaEditInfos];
      if (event.index < newInfos.length) newInfos.removeAt(event.index);
      emit(
        state.copyWith(
          mediaFiles: newFiles,
          mediaEditInfos: newInfos,
          errorMessage: null,
          showValidationError: false,
        ),
      );
    }
  }

  void _onChangeVisibility(
    ChangeVisibilityEvent event,
    Emitter<CreatePostState> emit,
  ) {
    emit(state.copyWith(visibility: event.visibility));
  }

  void _onToggleScheduling(
    ToggleSchedulingEvent event,
    Emitter<CreatePostState> emit,
  ) {
    emit(
      state.copyWith(
        isScheduled: event.isScheduled,
        // Clear scheduled time & errors when turning scheduling off
        scheduledAtLocal: event.isScheduled ? state.scheduledAtLocal : null,
        schedulingErrorMessage: null,
      ),
    );
  }

  void _onUpdateScheduledAt(
    UpdateScheduledAtEvent event,
    Emitter<CreatePostState> emit,
  ) {
    emit(
      state.copyWith(
        scheduledAtLocal: event.scheduledAtLocal,
        schedulingErrorMessage: null,
      ),
    );
  }

  void _onTogglePoll(TogglePollEvent event, Emitter<CreatePostState> emit) {
    final enabled = event.enabled && state.postType == PostType.text;
    emit(
      state.copyWith(
        pollEnabled: enabled,
        pollOptions: enabled
            ? (state.pollOptions.length >= CreatePostState.minPollOptions
                  ? state.pollOptions
                  : List<String>.generate(
                      CreatePostState.minPollOptions,
                      (index) => index < state.pollOptions.length
                          ? state.pollOptions[index]
                          : '',
                    ))
            : const [],
        errorMessage: null,
        showValidationError: false,
      ),
    );
  }

  void _onUpdatePollOption(
    UpdatePollOptionEvent event,
    Emitter<CreatePostState> emit,
  ) {
    if (!state.pollEnabled) return;
    if (event.index < 0 || event.index >= state.pollOptions.length) return;

    final options = [...state.pollOptions];
    options[event.index] = event.value;
    emit(
      state.copyWith(
        pollOptions: options,
        errorMessage: null,
        showValidationError: false,
      ),
    );
  }

  void _onAddPollOption(
    AddPollOptionEvent event,
    Emitter<CreatePostState> emit,
  ) {
    if (!state.pollEnabled) return;
    if (state.pollOptions.length >= CreatePostState.maxPollOptions) return;

    emit(
      state.copyWith(
        pollOptions: [...state.pollOptions, ''],
        errorMessage: null,
        showValidationError: false,
      ),
    );
  }

  void _onRemovePollOption(
    RemovePollOptionEvent event,
    Emitter<CreatePostState> emit,
  ) {
    if (!state.pollEnabled) return;
    if (state.pollOptions.length <= CreatePostState.minPollOptions) return;
    if (event.index < 0 || event.index >= state.pollOptions.length) return;

    final options = [...state.pollOptions]..removeAt(event.index);
    emit(
      state.copyWith(
        pollOptions: options,
        errorMessage: null,
        showValidationError: false,
      ),
    );
  }

  Future<void> _onSubmit(
    SubmitPostEvent event,
    Emitter<CreatePostState> emit,
  ) async {
    final logger = getIt<Talker>();

    if (!state.canSubmit) {
      emit(state.copyWith(showValidationError: true));
      return;
    }

    // Additional validation for scheduled posts
    DateTime? scheduledAtUtc;
    String status = 'published';

    if (state.isScheduled) {
      final scheduledLocal = state.scheduledAtLocal;
      if (scheduledLocal == null) {
        emit(
          state.copyWith(
            schedulingErrorMessage:
                'Please choose a date and time for your post.',
            showValidationError: true,
          ),
        );
        return;
      }

      final nowLocal = DateTime.now();
      final minAllowed = nowLocal.add(const Duration(minutes: 5));
      final maxAllowed = nowLocal.add(const Duration(days: 30));
      if (!scheduledLocal.isAfter(minAllowed)) {
        emit(
          state.copyWith(
            schedulingErrorMessage:
                'Scheduled time must be at least 5 minutes from now.',
            showValidationError: true,
          ),
        );
        return;
      }
      if (scheduledLocal.isAfter(maxAllowed)) {
        emit(
          state.copyWith(
            schedulingErrorMessage:
                'You can schedule posts up to 1 month in advance only.',
            showValidationError: true,
          ),
        );
        return;
      }

      // Treat picked date/time as IST and convert to UTC (IST = UTC + 5:30).
      final istAsUtc = DateTime.utc(
        scheduledLocal.year,
        scheduledLocal.month,
        scheduledLocal.day,
        scheduledLocal.hour,
        scheduledLocal.minute,
      );
      scheduledAtUtc = istAsUtc.subtract(const Duration(hours: 5, minutes: 30));
      status = 'scheduled';
    }

    // Check connectivity before attempting write action
    final isOnline = await _internetConnection.hasInternetAccess;
    if (!isOnline) {
      emit(
        state.copyWith(
          errorMessage: 'Cannot create post while offline',
          isOfflineError: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        errorMessage: null,
        schedulingErrorMessage: null,
      ),
    );

    try {
      logger.info('[CreatePostBloc] Submitting ${state.postType.name} post');

      final metadata = <String, dynamic>{};
      final mediaMeta = <Map<String, dynamic>>[];

      // Build per-media metadata array that describes how each attached file
      // was edited (crop/aspect, duration, rotation, filters, etc.).
      for (var i = 0; i < state.mediaFiles.length; i++) {
        final info = i < state.mediaEditInfos.length
            ? state.mediaEditInfos[i]
            : null;
        if (info == null) {
          mediaMeta.add(const <String, dynamic>{});
          continue;
        }

        final entry = <String, dynamic>{};
        if (info.aspectRatio != null) {
          entry['aspect_ratio'] = info.aspectRatio;
        }
        if (info.durationSeconds != null) {
          entry['duration_seconds'] = info.durationSeconds;
        }
        if (info.rotationDegrees != null) {
          entry['rotation_degrees'] = info.rotationDegrees;
        }
        if (info.isFlippedHorizontally != null) {
          entry['is_flipped_horizontally'] = info.isFlippedHorizontally;
        }
        if (info.filterName != null && info.filterName!.isNotEmpty) {
          entry['filter'] = info.filterName;
        }
        if (info.startSeconds != null) {
          entry['start_seconds'] = info.startSeconds;
        }
        if (info.endSeconds != null) {
          entry['end_seconds'] = info.endSeconds;
        }
        if (info.coverUrl != null && info.coverUrl!.isNotEmpty) {
          entry['cover_url'] = info.coverUrl;
        }
        if (info.playbackSpeed != null) {
          entry['playback_speed'] = info.playbackSpeed;
        }

        mediaMeta.add(entry);
      }

      // Persist array only if at least one entry has non-empty metadata.
      final hasAnyMediaMeta = mediaMeta.any(
        (entry) => entry.isNotEmpty == true,
      );
      if (hasAnyMediaMeta) {
        metadata['media_meta'] = mediaMeta;
      }

      if (state.postType == PostType.text && state.pollEnabled) {
        final pollOptions = state.normalizedPollOptions;
        metadata['poll'] = {'options': pollOptions};
      }

      // For backwards compatibility with existing clients and queries, also
      // expose aspect_ratio and duration_seconds for the first media item.
      if (state.mediaEditInfos.isNotEmpty &&
          state.mediaEditInfos.first != null) {
        final info = state.mediaEditInfos.first!;
        if (info.aspectRatio != null) {
          metadata['aspect_ratio'] = info.aspectRatio;
        }
        if (info.durationSeconds != null) {
          metadata['duration_seconds'] = info.durationSeconds;
        }
      }

      final result = await _postService.createPost(
        postType: state.postType,
        content: state.content.isNotEmpty ? state.content : null,
        title: state.title.isNotEmpty ? state.title : null,
        mediaFiles: state.mediaFiles.isNotEmpty ? state.mediaFiles : null,
        visibility: state.visibility,
        metadata: metadata.isNotEmpty ? metadata : null,
        scheduledAtUtc: scheduledAtUtc,
        status: status,
      );

      final postId = result['id'] as String;
      logger.info('[CreatePostBloc] Post created successfully: $postId');

      emit(
        state.copyWith(
          isSubmitting: false,
          isSuccess: true,
          createdPostId: postId,
        ),
      );
    } catch (e, stackTrace) {
      logger.error('[CreatePostBloc] Failed to create post', e, stackTrace);

      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'Failed to create post: ${e.toString()}',
        ),
      );
    }
  }

  void _onReset(ResetCreatePostEvent event, Emitter<CreatePostState> emit) {
    emit(const CreatePostState());
  }
}
