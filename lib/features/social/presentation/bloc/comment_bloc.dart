import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:myitihas/features/social/domain/entities/comment.dart';
import 'package:myitihas/features/social/domain/repositories/social_repository.dart';
import 'comment_event.dart';
import 'comment_state.dart';

/// BLoC for managing comments and threaded replies
@injectable
class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final SocialRepository socialRepository;
  final InternetConnection _internetConnection;

  CommentBloc({
    required this.socialRepository,
    InternetConnection? internetConnection,
  })  : _internetConnection = internetConnection ?? InternetConnection(),
        super(const CommentState.initial()) {
    on<LoadCommentsEvent>(_onLoadComments);
    on<AddCommentEvent>(_onAddComment);
    on<ToggleCommentLikeEvent>(_onToggleLike);
    on<ToggleCollapseEvent>(_onToggleCollapse);
    on<DeleteCommentEvent>(_onDeleteComment);
  }

  Future<void> _onLoadComments(
    LoadCommentsEvent event,
    Emitter<CommentState> emit,
  ) async {
    emit(const CommentState.loading());

    final result = await socialRepository.getCommentsTree(event.storyId);

    result.fold(
      (failure) => emit(CommentState.error(failure.message)),
      (comments) =>
          emit(CommentState.loaded(storyId: event.storyId, comments: comments)),
    );
  }

  Future<void> _onAddComment(
    AddCommentEvent event,
    Emitter<CommentState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CommentLoaded) return;

    // Check connectivity before attempting write action
    final isOnline = await _internetConnection.hasInternetAccess;
    if (!isOnline) {
      emit(currentState.copyWith(
        error: 'Cannot comment while offline',
        isOfflineError: true,
      ));
      return;
    }

    emit(currentState.copyWith(isAddingComment: true));

    final result = await socialRepository.addComment(
      storyId: event.storyId,
      text: event.text,
      parentCommentId: event.parentCommentId,
    );

    await result.fold(
      (failure) async {
        emit(currentState.copyWith(isAddingComment: false));
        emit(CommentState.error(failure.message));
      },
      (newComment) async {
        final commentsResult = await socialRepository.getCommentsTree(
          event.storyId,
        );

        commentsResult.fold(
          (failure) {
            emit(currentState.copyWith(isAddingComment: false));
          },
          (comments) {
            emit(
              CommentState.loaded(
                storyId: event.storyId,
                comments: comments,
                collapsedStates: currentState.collapsedStates,
                isAddingComment: false,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onToggleLike(
    ToggleCommentLikeEvent event,
    Emitter<CommentState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CommentLoaded) return;

    // Check connectivity before attempting write action
    final isOnline = await _internetConnection.hasInternetAccess;
    if (!isOnline) {
      emit(currentState.copyWith(
        error: 'Cannot like comment while offline',
        isOfflineError: true,
      ));
      return;
    }

    final comment = _findCommentById(currentState.comments, event.commentId);
    if (comment == null) return;

    final isLiked = comment.isLikedByCurrentUser;

    final updatedComments = _updateCommentInTree(
      currentState.comments,
      event.commentId,
      (c) => c.copyWith(
        isLikedByCurrentUser: !isLiked,
        likeCount: isLiked ? c.likeCount - 1 : c.likeCount + 1,
      ),
    );

    emit(currentState.copyWith(comments: updatedComments));

    final result = isLiked
        ? await socialRepository.unlikeComment(event.commentId)
        : await socialRepository.likeComment(event.commentId);

    result.fold((failure) async {
      final reloadResult = await socialRepository.getCommentsTree(
        event.storyId,
      );
      reloadResult.fold((failure) {}, (comments) {
        emit(currentState.copyWith(comments: comments));
      });
    }, (_) {});
  }

  Future<void> _onToggleCollapse(
    ToggleCollapseEvent event,
    Emitter<CommentState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CommentLoaded) return;

    final currentCollapsedState =
        currentState.collapsedStates[event.commentId] ?? false;

    final updatedCollapsedStates = Map<String, bool>.from(
      currentState.collapsedStates,
    );
    updatedCollapsedStates[event.commentId] = !currentCollapsedState;

    emit(currentState.copyWith(collapsedStates: updatedCollapsedStates));
  }

  Future<void> _onDeleteComment(
    DeleteCommentEvent event,
    Emitter<CommentState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CommentLoaded) return;

    final result = await socialRepository.deleteComment(event.commentId);

    await result.fold(
      (failure) async {
        emit(CommentState.error(failure.message));
      },
      (_) async {
        final commentsResult = await socialRepository.getCommentsTree(
          event.storyId,
        );

        commentsResult.fold(
          (failure) {
            emit(CommentState.error(failure.message));
          },
          (comments) {
            emit(currentState.copyWith(comments: comments));
          },
        );
      },
    );
  }

  // Helper methods for tree manipulation
  Comment? _findCommentById(List<Comment> comments, String commentId) {
    for (final comment in comments) {
      if (comment.id == commentId) return comment;

      final found = _findCommentById(comment.replies, commentId);
      if (found != null) return found;
    }
    return null;
  }

  List<Comment> _updateCommentInTree(
    List<Comment> comments,
    String commentId,
    Comment Function(Comment) updateFn,
  ) {
    return comments.map((comment) {
      if (comment.id == commentId) {
        return updateFn(comment);
      }

      if (comment.replies.isNotEmpty) {
        return comment.copyWith(
          replies: _updateCommentInTree(comment.replies, commentId, updateFn),
        );
      }

      return comment;
    }).toList();
  }
}
