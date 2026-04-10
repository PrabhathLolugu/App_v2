import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/presentation/widgets/app_snackbar.dart';
import 'package:myitihas/core/utils/app_error_mapper.dart';
import 'package:myitihas/core/widgets/voice_input/voice_input_button.dart';
import 'package:myitihas/features/social/domain/entities/comment.dart';
import 'package:myitihas/features/social/domain/entities/content_type.dart';
import 'package:myitihas/features/social/domain/repositories/social_repository.dart';
import 'package:myitihas/features/social/presentation/widgets/comment_tile.dart';
import 'package:myitihas/i18n/strings.g.dart';

class CommentSheet extends StatefulWidget {
  final String contentId;
  final ContentType contentType;
  final int initialCommentCount;
  final String? initialTargetCommentId;

  /// Called when a comment was successfully posted so the feed can update the comment count.
  final VoidCallback? onCommentAdded;

  /// Called with the new comment count after a comment is posted.
  final void Function(int newCount)? onCommentCountChanged;

  /// When true, renders without sheet chrome (no drag handle, close button, or
  /// fixed height) so the thread can live inside a page layout.
  final bool embedded;

  /// When set (e.g. on post detail), the comment field uses this node so parent
  /// widgets can call [FocusNode.requestFocus] (e.g. from the post action bar).
  final FocusNode? commentInputFocusNode;

  const CommentSheet({
    super.key,
    required this.contentId,
    required this.contentType,
    required this.initialCommentCount,
    this.initialTargetCommentId,
    this.onCommentAdded,
    this.onCommentCountChanged,
    this.embedded = false,
    this.commentInputFocusNode,
  });

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final _commentController = TextEditingController();
  late final FocusNode _ownedFocusNode;
  late final FocusNode _focusNode;
  final _scrollController = ScrollController();

  List<Comment> _comments = [];
  bool _isLoading = true;
  bool _isPosting = false;
  String? _error;
  String? _replyToCommentId;
  String? _replyToUserName;
  bool _initialTargetHandled = false;

  late final VoidCallback _commentControllerListener;

  @override
  void initState() {
    super.initState();
    _ownedFocusNode = FocusNode();
    _focusNode = widget.commentInputFocusNode ?? _ownedFocusNode;
    _commentControllerListener = () {
      if (mounted) setState(() {});
    };
    _commentController.addListener(_commentControllerListener);
    _loadComments();
  }

  @override
  void dispose() {
    _commentController.removeListener(_commentControllerListener);
    _commentController.dispose();
    if (widget.commentInputFocusNode == null) {
      _ownedFocusNode.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  /// Loads comments and returns the loaded list on success, null on failure.
  Future<List<Comment>?> _loadComments() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repository = getIt<SocialRepository>();
      // Use polymorphic method for all content types
      final result = await repository.getContentComments(
        contentId: widget.contentId,
        contentType: widget.contentType,
      );

      return result.fold(
        (failure) {
          debugPrint('[CommentSheet] Load comments failed: ${failure.message}');
          if (mounted) setState(() => _error = failure.message);
          return null;
        },
        (comments) {
          if (mounted) {
            setState(() => _comments = comments);
            _focusInitialTargetComment(comments);
          }
          return comments;
        },
      );
    } catch (e, stackTrace) {
      debugPrint('[CommentSheet] Load comments error: $e');
      debugPrint(stackTrace.toString());
      final friendly = AppErrorMapper.getUserMessage(
        e,
        fallbackMessage:
            'We couldn\'t load comments right now. Please try again.',
      );
      if (mounted) setState(() => _error = friendly);
      return null;
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _postComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isPosting = true);
    HapticFeedback.mediumImpact();

    try {
      final repository = getIt<SocialRepository>();
      // Use polymorphic method for all content types
      final result = await repository.addContentComment(
        contentId: widget.contentId,
        contentType: widget.contentType,
        text: text,
        parentCommentId: _replyToCommentId,
      );

      if (!mounted) return;
      result.fold(
        (failure) {
          debugPrint('[CommentSheet] Post failed: ${failure.message}');
          setState(() => _error = failure.message);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.message),
              duration: const Duration(seconds: 6),
              action: SnackBarAction(label: 'OK', onPressed: () {}),
            ),
          );
        },
        (comment) {
          setState(() => _error = null);
          _commentController.clear();
          _cancelReply();
          widget.onCommentAdded?.call();
          // Call onCommentCountChanged with total count (comments + replies) to stay in sync with post
          _loadComments().then((loaded) {
            if (loaded != null) {
              widget.onCommentCountChanged?.call(_totalCommentCount(loaded));
            }
          });
        },
      );
    } catch (e, stackTrace) {
      if (!mounted) return;
      debugPrint('[CommentSheet] Comment error: $e');
      debugPrint(stackTrace.toString());
      final friendly = AppErrorMapper.getUserMessage(
        e,
        fallbackMessage:
            'We couldn\'t post your comment. Please try again in a moment.',
      );
      final msg = t.social.comments.failedToPost(error: friendly);
      AppSnackBar.showError(context, msg, duration: const Duration(seconds: 6));
    } finally {
      if (mounted) setState(() => _isPosting = false);
    }
  }

  void _startReply(String commentId, String userName) {
    setState(() {
      _replyToCommentId = commentId;
      _replyToUserName = userName;
    });
    _focusNode.requestFocus();
  }

  void _cancelReply() {
    setState(() {
      _replyToCommentId = null;
      _replyToUserName = null;
    });
  }

  Future<void> _likeComment(String commentId) async {
    HapticFeedback.lightImpact();
    final repository = getIt<SocialRepository>();

    // Find the comment and check if liked
    final comment = _findComment(commentId, _comments);
    if (comment == null) return;

    final wasLiked = comment.isLikedByCurrentUser;

    // Optimistic update so reply/comment like state changes immediately.
    setState(() {
      _comments = _updateCommentInTree(
        _comments,
        commentId,
        (c) => c.copyWith(
          isLikedByCurrentUser: !wasLiked,
          likeCount: wasLiked ? math.max(c.likeCount - 1, 0) : c.likeCount + 1,
        ),
      );
    });

    final result = wasLiked
        ? await repository.unlikeComment(commentId)
        : await repository.likeComment(commentId);

    if (!mounted) return;
    result.fold(
      (_) {
        // Revert optimistic update on failure.
        setState(() {
          _comments = _updateCommentInTree(
            _comments,
            commentId,
            (c) => c.copyWith(
              isLikedByCurrentUser: wasLiked,
              likeCount: wasLiked ? c.likeCount + 1 : math.max(c.likeCount - 1, 0),
            ),
          );
        });
      },
      (_) {
        // Keep local state and silently refresh in background to stay consistent.
        _loadComments();
      },
    );
  }

  void _focusInitialTargetComment(List<Comment> comments) {
    if (_initialTargetHandled) return;

    final targetCommentId = widget.initialTargetCommentId;
    if (targetCommentId == null || targetCommentId.isEmpty) return;

    _initialTargetHandled = true;
    final foundComment = _findComment(targetCommentId, comments);
    if (foundComment == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      if (_scrollController.hasClients) {
        final topLevelIndex = comments.indexWhere(
          (comment) =>
              comment.id == targetCommentId ||
              comment.replies.any((reply) => reply.id == targetCommentId),
        );
        if (topLevelIndex > 0) {
          final targetOffset = (topLevelIndex * 96.0).toDouble();
          await _scrollController.animateTo(
            targetOffset.clamp(
              0.0,
              _scrollController.position.maxScrollExtent,
            ),
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOut,
          );
        }
      }
    });
  }

  Comment? _findComment(String id, List<Comment> comments) {
    for (final comment in comments) {
      if (comment.id == id) return comment;
      final found = _findComment(id, comment.replies);
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

  /// Total count of comments including all nested replies (matches post comment_count).
  int _totalCommentCount(List<Comment> comments) {
    int total = 0;
    for (final c in comments) {
      total += 1 + _totalCommentCount(c.replies);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gradients = theme.extension<GradientExtension>();
    final t = Translations.of(context);

    final column = Column(
      children: [
        if (!widget.embedded) ...[
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Text(
                  t.feed.comments,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '${_totalCommentCount(_comments)}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
        ],
        if (widget.embedded)
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
            child: Row(
              children: [
                Text(
                  t.feed.comments,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '${_totalCommentCount(_comments)}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Divider(height: 1),
        // Comments list
        Expanded(child: _buildContent(colorScheme, t)),
        if (_replyToUserName != null)
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                border: Border(
                  top: BorderSide(color: colorScheme.outlineVariant),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.reply, size: 16.sp, color: colorScheme.primary),
                  SizedBox(width: 8.w),
                  Text(
                    t.social.comments.replyingTo(name: _replyToUserName!),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _cancelReply,
                    child: Icon(
                      Icons.close,
                      size: 16.sp,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          Container(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              top: 12.h,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              border: Border(
                top: BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    focusNode: _focusNode,
                    onTapOutside: (_) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    decoration: InputDecoration(
                      hintText: _replyToUserName != null
                          ? t.social.comments.replyHint(name: _replyToUserName!)
                          : t.feed.addCommentHint,
                      suffixIcon: VoiceInputButton(
                        controller: _commentController,
                        compact: true,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.r),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: colorScheme.surface,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _postComment(),
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  decoration: BoxDecoration(
                    gradient: gradients?.primaryButtonGradient,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed:
                        _isPosting || _commentController.text.trim().isEmpty
                        ? null
                        : _postComment,
                    icon: _isPosting
                        ? SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
    );

    if (widget.embedded) {
      return Material(
        color: colorScheme.surface,
        child: column,
      );
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: column,
    );
  }

  Widget _buildContent(ColorScheme colorScheme, Translations t) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
            SizedBox(height: 16.h),
            Text(_error!),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _loadComments,
              child: Text(t.common.retry),
            ),
          ],
        ),
      );
    }

    if (_comments.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 48.sp,
              color: colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: 16.h),
            Text(
              t.social.comments.noComments,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            SizedBox(height: 8.h),
            Text(
              t.social.comments.beFirst,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadComments,
      child: ListView.separated(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: _comments.length,
        separatorBuilder: (_, _) =>
            Divider(height: 1, indent: 16.w, endIndent: 16.w),
        itemBuilder: (context, index) {
          final comment = _comments[index];
          return CommentTile(
            comment: comment,
            onLike: (id) {
              _likeComment(id);
            },
            onReply: _startReply,
            onProfileTap: () {
              // Navigate to profile
            },
          );
        },
      ),
    );
  }
}
