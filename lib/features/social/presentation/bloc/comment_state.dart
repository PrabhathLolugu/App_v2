import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myitihas/features/social/domain/entities/comment.dart';

part 'comment_state.freezed.dart';

@Freezed(toStringOverride: true)
sealed class CommentState with _$CommentState {
  const factory CommentState.initial() = CommentInitial;

  const factory CommentState.loading() = CommentLoading;

  const factory CommentState.loaded({
    required String storyId,
    required List<Comment> comments,
    @Default({}) Map<String, bool> collapsedStates,
    @Default(false) bool isAddingComment,
    String? error,
    @Default(false) bool isOfflineError,
  }) = CommentLoaded;

  const factory CommentState.error(String message) = CommentError;

  const CommentState._();

  @override
  String toString() {
    return map(
      initial: (_) => 'CommentState.initial()',
      loading: (_) => 'CommentState.loading()',
      loaded: (state) =>
          'CommentState.loaded(storyId: ${state.storyId}, comments: ${state.comments.length})',
      error: (state) => 'CommentState.error(message: "${state.message}")',
    );
  }
}
