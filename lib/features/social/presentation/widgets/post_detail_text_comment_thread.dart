import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myitihas/config/routes.dart';
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

/// Unified scroll: [post] first, then comments; scroll up to move the post off-screen.
/// Bottom composer is hidden when there are no comments until [revealComposer] runs
/// (e.g. user taps the post's comment action).
class PostDetailTextCommentThread extends StatefulWidget {
  const PostDetailTextCommentThread({
    super.key,
    required this.post,
    required this.contentId,
    required this.contentType,
    required this.initialCommentCount,
    this.initialTargetCommentId,
    required this.commentInputFocusNode,
    this.onCommentCountChanged,
  });

  final Widget post;
  final String contentId;
  final ContentType contentType;
  final int initialCommentCount;
  final String? initialTargetCommentId;
  final FocusNode commentInputFocusNode;
  final void Function(int newCount)? onCommentCountChanged;

  @override
  PostDetailTextCommentThreadState createState() =>
      PostDetailTextCommentThreadState();
}

class PostDetailTextCommentThreadState extends State<PostDetailTextCommentThread> {
  final _commentController = TextEditingController();
  final _scrollController = ScrollController();

  List<Comment> _comments = [];
  bool _isLoading = true;
  bool _isPosting = false;
  String? _error;
  String? _replyToCommentId;
  String? _replyToUserName;
  bool _initialTargetHandled = false;

  /// When false and there are no loaded comments, the thread UI + composer stay hidden.
  late bool _showComposerBar;

  late final VoidCallback _commentControllerListener;

  @override
  void initState() {
    super.initState();
    _showComposerBar = widget.initialCommentCount > 0 ||
        (widget.initialTargetCommentId != null &&
            widget.initialTargetCommentId!.trim().isNotEmpty);
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
    _scrollController.dispose();
    super.dispose();
  }

  /// Shows the bottom composer and comments section (call from post comment icon).
  void revealComposer() {
    if (_showComposerBar) return;
    setState(() => _showComposerBar = true);
  }

  Future<List<Comment>?> _loadComments() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repository = getIt<SocialRepository>();
      final result = await repository.getContentComments(
        contentId: widget.contentId,
        contentType: widget.contentType,
      );

      return result.fold(
        (failure) {
          if (mounted) setState(() => _error = failure.message);
          return null;
        },
        (comments) {
          if (mounted) {
            setState(() {
              _comments = comments;
              if (_totalCommentCount(comments) > 0) {
                _showComposerBar = true;
              }
            });
            _focusInitialTargetComment(comments);
          }
          return comments;
        },
      );
    } catch (e, stackTrace) {
      debugPrint('[PostDetailTextCommentThread] Load comments error: $e');
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

    final t = Translations.of(context);

    setState(() {
      _isPosting = true;
      _showComposerBar = true;
    });
    HapticFeedback.mediumImpact();

    try {
      final repository = getIt<SocialRepository>();
      final result = await repository.addContentComment(
        contentId: widget.contentId,
        contentType: widget.contentType,
        text: text,
        parentCommentId: _replyToCommentId,
      );

      if (!mounted) return;
      result.fold(
        (failure) {
          setState(() => _error = failure.message);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.message),
              duration: const Duration(seconds: 6),
              action: SnackBarAction(label: 'OK', onPressed: () {}),
            ),
          );
        },
        (_) {
          setState(() => _error = null);
          _commentController.clear();
          _cancelReply();
          _loadComments().then((loaded) {
            if (loaded != null) {
              widget.onCommentCountChanged?.call(_totalCommentCount(loaded));
            }
          });
        },
      );
    } catch (e, stackTrace) {
      if (!mounted) return;
      debugPrint('[PostDetailTextCommentThread] Comment error: $e');
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
    widget.commentInputFocusNode.requestFocus();
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

    final comment = _findComment(commentId, _comments);
    if (comment == null) return;

    final wasLiked = comment.isLikedByCurrentUser;

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
      if (!_scrollController.hasClients) return;
      final topLevelIndex = comments.indexWhere(
        (comment) =>
            comment.id == targetCommentId ||
            comment.replies.any((reply) => reply.id == targetCommentId),
      );
      if (topLevelIndex <= 0) return;
      // Unified scroll includes the post above comments; nudge past a typical post block.
      final maxExtent = _scrollController.position.maxScrollExtent;
      final targetOffset =
          (360.0 + topLevelIndex * 88.0).clamp(0.0, maxExtent);
      await _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
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

  int _totalCommentCount(List<Comment> comments) {
    int total = 0;
    for (final c in comments) {
      total += 1 + _totalCommentCount(c.replies);
    }
    return total;
  }

  /// Omits the whole thread (header + list) while loading when we expect zero
  /// comments, so the screen is just the post until the user opens the composer
  /// or we know comments exist.
  bool get _showCommentsSection {
    if (_showComposerBar || _comments.isNotEmpty || _error != null) {
      return true;
    }
    if (_isLoading) {
      return widget.initialCommentCount > 0 ||
          (widget.initialTargetCommentId != null &&
              widget.initialTargetCommentId!.trim().isNotEmpty);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gradients = theme.extension<GradientExtension>();
    final t = Translations.of(context);

    final scrollView = CustomScrollView(
      controller: _scrollController,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverToBoxAdapter(child: widget.post),
        if (_showCommentsSection) ...[
          SliverToBoxAdapter(
            child: Divider(height: 1, color: colorScheme.outlineVariant),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
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
          ),
          ..._buildCommentSlivers(colorScheme, t),
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
        ],
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: scrollView),
        if (_showComposerBar && _replyToUserName != null)
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
                Expanded(
                  child: Text(
                    t.social.comments.replyingTo(name: _replyToUserName!),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
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
        if (_showComposerBar)
          Material(
            color: colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                top: 12.h,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      focusNode: widget.commentInputFocusNode,
                      onTapOutside: (_) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      decoration: InputDecoration(
                        hintText: _replyToUserName != null
                            ? t.social.comments.replyHint(
                                name: _replyToUserName!,
                              )
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
                      onPressed: _isPosting ||
                              _commentController.text.trim().isEmpty
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
          ),
      ],
    );
  }

  List<Widget> _buildCommentSlivers(ColorScheme colorScheme, Translations t) {
    if (_isLoading) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }

    if (_error != null) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
                  SizedBox(height: 16.h),
                  Text(_error!, textAlign: TextAlign.center),
                  SizedBox(height: 16.h),
                  FilledButton(
                    onPressed: _loadComments,
                    child: Text(t.common.retry),
                  ),
                ],
              ),
            ),
          ),
        ),
      ];
    }

    if (_comments.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
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
          ),
        ),
      ];
    }

    return [
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final comment = _comments[index];
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (index > 0)
                  Divider(height: 1, indent: 16.w, endIndent: 16.w),
                CommentTile(
                  comment: comment,
                  onLike: _likeComment,
                  onReply: _startReply,
                  onProfileTap: () {
                    ProfileRoute(userId: comment.userId).push(context);
                  },
                ),
              ],
            );
          },
          childCount: _comments.length,
        ),
      ),
    ];
  }
}
