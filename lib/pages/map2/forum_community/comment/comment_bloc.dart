import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// --- Events ---
abstract class CommentEvent {}

class LoadComments extends CommentEvent {
  final String activityId;
  LoadComments(this.activityId);
}

class SetReplyingTo extends CommentEvent {
  final Map<String, dynamic>? comment;
  SetReplyingTo(this.comment);
}

class ResetCommentFocus extends CommentEvent {}

// Internal event used to push stream updates into the Bloc state
class _UpdateCommentsInternal extends CommentEvent {
  final List<Map<String, dynamic>> comments;
  _UpdateCommentsInternal(this.comments);
}

// --- State ---
class CommentState {
  final List<Map<String, dynamic>> comments; // Original flat list
  final List<Map<String, dynamic>> threadedComments; // Structured for UI
  final Map<String, dynamic>? replyingTo;
  final bool isLoading;

  CommentState({
    this.comments = const [],
    this.threadedComments = const [],
    this.replyingTo,
    this.isLoading = false,
  });
}

// --- Bloc Implementation ---
class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final _supabase = Supabase.instance.client;
  StreamSubscription? _subscription;

  CommentBloc() : super(CommentState()) {
    // Registering handlers once with clean separated logic
    on<LoadComments>(_onLoadComments);
    on<_UpdateCommentsInternal>(_onUpdateCommentsInternal);
    on<SetReplyingTo>(_onSetReplyingTo);
    on<ResetCommentFocus>(_onResetCommentFocus);
  }

  Future<void> _onLoadComments(
    LoadComments event,
    Emitter<CommentState> emit,
  ) async {
    emit(CommentState(isLoading: true));

    // 1. Cancel any existing subscriptions to prevent memory leaks or duplicate data
    await _subscription?.cancel();

    // 2. Start the Supabase Realtime Stream for the specific activity (site/discussion)
    _subscription = _supabase
        .from('map_comments') // Matches your Supabase table name
        .stream(primaryKey: ['id'])
        .eq('activity_id', event.activityId)
        .order('created_at', ascending: true)
        .listen((data) {
          // Whenever the database changes, this triggers a new state update
          add(_UpdateCommentsInternal(List<Map<String, dynamic>>.from(data)));
        });
  }
  // inside lib/pages/map2/forum_community/comment_bloc.dart

  void _onSetReplyingTo(SetReplyingTo event, Emitter<CommentState> emit) {
    emit(
      CommentState(
        comments:
            state.comments, // 👈 Keep the comments so the screen stays full
        threadedComments: state.threadedComments, // 👈 Keep the visual threads
        replyingTo: event.comment,
        isLoading: false,
      ),
    );
  }

  void _onUpdateCommentsInternal(
    _UpdateCommentsInternal event,
    Emitter<CommentState> emit,
  ) {
    final List<Map<String, dynamic>> raw = event.comments;
    List<Map<String, dynamic>> structured = [];

    final mainComments = raw.where((c) => c['parent_id'] == null).toList();

    void addReplies(String parentId, int level) {
      final relatedReplies = raw
          .where((r) => r['parent_id'] == parentId)
          .toList();

      for (var reply in relatedReplies) {
        // 1. Determine the visual level (Max out at 2 for 0, 1, 2 = 3 levels)
        int visualLevel = level > 2 ? 2 : level;

        // 2. Add the message to the list so it actually SHOWS UP
        structured.add({...reply, 'nesting_level': visualLevel});

        // 3. Keep looking for more replies, but don't stop the current loop
        addReplies(reply['id'].toString(), level + 1);
      }
    }

    for (var parent in mainComments) {
      structured.add({...parent, 'nesting_level': 0});
      addReplies(parent['id'].toString(), 1);
    }

    emit(
      CommentState(
        comments: raw,
        threadedComments: structured,
        replyingTo: state.replyingTo,
        isLoading: false,
      ),
    );
  }

  void _onResetCommentFocus(
    ResetCommentFocus event,
    Emitter<CommentState> emit,
  ) {
    emit(
      CommentState(
        comments: state.comments,
        threadedComments: state.threadedComments,
        replyingTo: null, // Clear the reply-to focus
        isLoading: false,
      ),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel(); // Always clean up your streams
    return super.close();
  }
}
