import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/features/social/domain/entities/content_type.dart';
import 'package:myitihas/features/social/domain/entities/feed_item.dart';
import 'package:myitihas/features/social/domain/entities/share.dart';
import 'package:myitihas/features/social/domain/repositories/post_repository.dart';
import 'package:myitihas/features/social/domain/repositories/social_repository.dart';
import 'package:myitihas/features/social/domain/repositories/user_repository.dart';
import 'package:myitihas/features/social/domain/utils/share_url_builder.dart';
import 'package:myitihas/features/social/presentation/utils/share_preview_generator.dart';
import 'package:myitihas/features/social/presentation/widgets/comment_sheet.dart';
import 'package:myitihas/features/social/presentation/widgets/post_detail_text_comment_thread.dart';
import 'package:myitihas/features/social/presentation/widgets/edit_caption_sheet.dart';
import 'package:myitihas/features/social/presentation/widgets/feed_item_card.dart';
import 'package:myitihas/features/social/presentation/widgets/post_action_sheets.dart';
import 'package:myitihas/features/social/presentation/widgets/timeline_post_card.dart';
import 'package:myitihas/features/social/presentation/widgets/user_selector_sheet.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/services/social_service.dart';
import 'package:share_plus/share_plus.dart';

class PostDetailPage extends StatefulWidget {
  final String postId;
  final String postType;
  final String? initialCommentId;
  /// When opening a scheduled post from profile, pass the item so it can be
  /// used if the fetch by ID returns not found (e.g. due to RLS).
  final FeedItem? initialFeedItem;

  const PostDetailPage({
    super.key,
    required this.postId,
    this.postType = 'image',
    this.initialCommentId,
    this.initialFeedItem,
  });

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  FeedItem? _feedItem;
  bool _isLoading = true;
  String? _error;
  String? _currentUserId;
  bool _openedInitialCommentThread = false;

  /// Focus target for the inline comment composer on text post detail.
  final FocusNode _textPostCommentFocus = FocusNode();

  final GlobalKey<PostDetailTextCommentThreadState> _textCommentThreadKey =
      GlobalKey<PostDetailTextCommentThreadState>();

  @override
  void initState() {
    super.initState();
    _loadPost(showLoader: true);
  }

  @override
  void dispose() {
    _textPostCommentFocus.dispose();
    super.dispose();
  }

  String _normalizePostType(String rawType) {
    switch (rawType.toLowerCase()) {
      case 'post':
      case 'image':
      case 'image_post':
      case 'imagepost':
        return 'image';
      case 'text':
      case 'text_post':
      case 'textpost':
        return 'text';
      case 'video':
      case 'video_post':
      case 'videopost':
        return 'video';
      case 'story_share':
      case 'storyshare':
        return 'image';
      default:
        return rawType.toLowerCase();
    }
  }

  FeedItem _applySocialStatus(
    FeedItem item, {
    required bool isLiked,
    required bool isBookmarked,
  }) {
    return item.when(
      story: (story) => FeedItem.story(
        story.copyWith(isLikedByCurrentUser: isLiked, isFavorite: isBookmarked),
      ),
      imagePost: (post) => FeedItem.imagePost(
        post.copyWith(isLikedByCurrentUser: isLiked, isFavorite: isBookmarked),
      ),
      textPost: (post) => FeedItem.textPost(
        post.copyWith(isLikedByCurrentUser: isLiked, isFavorite: isBookmarked),
      ),
      videoPost: (post) => FeedItem.videoPost(
        post.copyWith(isLikedByCurrentUser: isLiked, isFavorite: isBookmarked),
      ),
    );
  }

  Future<void> _loadPost({bool showLoader = false}) async {
    final repository = getIt<PostRepository>();
    final userRepository = getIt<UserRepository>();
    final socialService = getIt<SocialService>();

    if (showLoader && mounted) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final currentUserResult = await userRepository.getCurrentUser();
      final currentUserId = currentUserResult.fold(
        (_) => null,
        (user) => user.id,
      );

      FeedItem? item;
      final normalizedType = _normalizePostType(widget.postType);

      switch (normalizedType) {
        case 'image':
          final result = await repository.getImagePostById(widget.postId);
          result.fold((failure) => _error = failure.message, (post) {
            item = FeedItem.imagePost(post);
          });
          break;
        case 'text':
          final result = await repository.getTextPostById(widget.postId);
          result.fold((failure) => _error = failure.message, (post) {
            item = FeedItem.textPost(post);
          });
          break;
        case 'video':
          final result = await repository.getVideoPostById(widget.postId);
          result.fold((failure) => _error = failure.message, (post) {
            item = FeedItem.videoPost(post);
          });
          break;
        default:
          _error = 'Unknown post type: ${widget.postType}';
      }

      // Use initial feed item when opening a scheduled post from profile (fetch
      // can return not found due to RLS or timing).
      if (item == null &&
          widget.initialFeedItem != null &&
          widget.initialFeedItem!.id == widget.postId) {
        item = widget.initialFeedItem;
        _error = null;
      }

      if (item == null) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _currentUserId = currentUserId;
        });
        return;
      }

      final enriched = await repository.enrichFeedItemWithUserData(item!);
      enriched.fold((_) => null, (enrichedItem) => item = enrichedItem);

      final contentType = item!.contentType;
      final socialResults = await Future.wait([
        socialService.isLiked(
          contentType: contentType,
          contentId: widget.postId,
        ),
        socialService.isBookmarked(
          contentType: contentType,
          contentId: widget.postId,
        ),
      ]);

      final isLiked = socialResults[0];
      final isBookmarked = socialResults[1];
      item = _applySocialStatus(
        item!,
        isLiked: isLiked,
        isBookmarked: isBookmarked,
      );

      if (!mounted) return;
      setState(() {
        _feedItem = item;
        _isLoading = false;
        _error = null;
        _currentUserId = currentUserId;
      });

      if (!_openedInitialCommentThread &&
          widget.initialCommentId != null &&
          widget.initialCommentId!.isNotEmpty) {
        _openedInitialCommentThread = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final loaded = _feedItem;
          if (loaded?.contentType == ContentType.textPost) {
            return;
          }
          _showCommentSheet(initialTargetCommentId: widget.initialCommentId);
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showMessage(String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _toggleLike() async {
    final item = _feedItem;
    if (item == null) return;

    final previous = item;
    setState(() => _feedItem = item.toggleLike());

    final postRepository = getIt<PostRepository>();
    final socialRepository = getIt<SocialRepository>();

    final wasLiked = previous.isLikedByCurrentUser;
    final result = previous.contentType == ContentType.story
        ? wasLiked
              ? await socialRepository.unlikeStory(previous.id)
              : await socialRepository.likeStory(previous.id)
        : wasLiked
        ? await postRepository.unlikeContent(
            contentId: previous.id,
            contentType: previous.contentType,
          )
        : await postRepository.likeContent(
            contentId: previous.id,
            contentType: previous.contentType,
          );

    if (!mounted) return;
    result.fold((failure) {
      setState(() => _feedItem = previous);
      _showMessage('Failed to update like: ${failure.message}');
    }, (_) {});
  }

  Future<void> _toggleBookmark() async {
    final item = _feedItem;
    if (item == null) return;
    if (item.contentType == ContentType.story) {
      _showMessage('Bookmark is not supported for this content here.');
      return;
    }

    final previous = item;
    setState(() => _feedItem = item.toggleBookmark());

    final result = await getIt<PostRepository>().toggleBookmark(
      contentId: item.id,
      contentType: item.contentType,
    );

    if (!mounted) return;
    result.fold((failure) {
      setState(() => _feedItem = previous);
      _showMessage('Failed to update bookmark: ${failure.message}');
    }, (_) {});
  }

  Future<void> _toggleFollow() async {
    final item = _feedItem;
    final author = item?.authorUser;
    if (item == null || author == null || author.isCurrentUser) return;

    final userRepository = getIt<UserRepository>();
    final shouldFollow = !author.isFollowing;

    final result = shouldFollow
        ? await userRepository.followUser(author.id)
        : await userRepository.unfollowUser(author.id);

    if (!mounted) return;
    result.fold(
      (failure) =>
          _showMessage('Failed to update follow status: ${failure.message}'),
      (_) {
        setState(() {
          _feedItem = item.when(
            story: (story) {
              final currentAuthor = story.authorUser;
              if (currentAuthor == null) return FeedItem.story(story);
              final updatedAuthor = currentAuthor.copyWith(
                isFollowing: shouldFollow,
                followerCount:
                    (currentAuthor.followerCount + (shouldFollow ? 1 : -1))
                        .clamp(0, 9999999),
              );
              return FeedItem.story(story.copyWith(authorUser: updatedAuthor));
            },
            imagePost: (post) {
              final currentAuthor = post.authorUser;
              if (currentAuthor == null) return FeedItem.imagePost(post);
              final updatedAuthor = currentAuthor.copyWith(
                isFollowing: shouldFollow,
                followerCount:
                    (currentAuthor.followerCount + (shouldFollow ? 1 : -1))
                        .clamp(0, 9999999),
              );
              return FeedItem.imagePost(
                post.copyWith(authorUser: updatedAuthor),
              );
            },
            textPost: (post) {
              final currentAuthor = post.authorUser;
              if (currentAuthor == null) return FeedItem.textPost(post);
              final updatedAuthor = currentAuthor.copyWith(
                isFollowing: shouldFollow,
                followerCount:
                    (currentAuthor.followerCount + (shouldFollow ? 1 : -1))
                        .clamp(0, 9999999),
              );
              return FeedItem.textPost(
                post.copyWith(authorUser: updatedAuthor),
              );
            },
            videoPost: (post) {
              final currentAuthor = post.authorUser;
              if (currentAuthor == null) return FeedItem.videoPost(post);
              final updatedAuthor = currentAuthor.copyWith(
                isFollowing: shouldFollow,
                followerCount:
                    (currentAuthor.followerCount + (shouldFollow ? 1 : -1))
                        .clamp(0, 9999999),
              );
              return FeedItem.videoPost(
                post.copyWith(authorUser: updatedAuthor),
              );
            },
          );
        });
      },
    );
  }

  Future<void> _showCommentSheet({String? initialTargetCommentId}) async {
    final item = _feedItem;
    if (item == null) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CommentSheet(
        contentId: item.id,
        contentType: item.contentType,
        initialCommentCount: item.commentCount,
        initialTargetCommentId: initialTargetCommentId,
      ),
    );

    if (!mounted) return;
    await _loadPost(showLoader: false);
  }

  String _buildContentLink(FeedItem item) {
    switch (item.contentType) {
      case ContentType.imagePost:
        return ShareUrlBuilder.buildPostUrl(item.id);
      case ContentType.textPost:
        return ShareUrlBuilder.buildPostUrl(item.id);
      case ContentType.videoPost:
        return ShareUrlBuilder.buildVideoUrl(item.id);
      case ContentType.story:
        return ShareUrlBuilder.buildStoryUrl(item.id);
      case ContentType.post:
        return ShareUrlBuilder.buildPostUrl(item.id);
      case ContentType.comment:
        return ShareUrlBuilder.buildPostUrl(item.id);
    }
  }

  Future<void> _recordShare({
    required FeedItem item,
    required bool isDirect,
    String? recipientId,
  }) async {
    final result = await getIt<SocialRepository>().shareContent(
      contentId: item.id,
      contentType: item.contentType,
      shareType: isDirect ? ShareType.directMessage : ShareType.external,
      recipientId: recipientId,
    );

    if (!mounted) return;
    result.fold(
      (failure) => _showMessage('Failed to record share: ${failure.message}'),
      (_) {
        if (_feedItem == null) return;
        setState(() => _feedItem = _feedItem!.incrementShareCount());
      },
    );
  }

  Future<void> _shareExternally() async {
    final item = _feedItem;
    if (item == null) return;

    try {
      await item.when(
        story: (story) => SharePreviewGenerator.shareAsText(story: story),
        imagePost: (post) => SharePreviewGenerator.shareImagePost(post: post),
        textPost: (post) => SharePreviewGenerator.shareTextPost(post: post),
        videoPost: (post) {
          final link = _buildContentLink(item);
          final title = post.caption?.isNotEmpty == true
              ? post.caption!
              : 'Check out this video';
          return SharePlus.instance.share(
            ShareParams(text: '$title\n\n$link', subject: 'MyItihas Video'),
          );
        },
      );

      await _recordShare(item: item, isDirect: false);
    } catch (e) {
      _showMessage('Failed to share post: $e');
    }
  }

  Future<void> _copyLink() async {
    final item = _feedItem;
    if (item == null) return;
    await Clipboard.setData(ClipboardData(text: _buildContentLink(item)));
    _showMessage('Link copied');
  }

  Future<void> _sendToUser() async {
    final item = _feedItem;
    if (item == null) return;

    final selectedUser = await UserSelectorSheet.show(context);
    if (selectedUser == null || !mounted) return;

    await _recordShare(
      item: item,
      isDirect: true,
      recipientId: selectedUser.id,
    );
    if (!mounted) return;
    _showMessage('Sent to ${selectedUser.displayName}');
  }

  void _showShareSheet() {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: colorScheme.surface,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.share_outlined),
                title: const Text('Share externally'),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  await _shareExternally();
                },
              ),
              ListTile(
                leading: const Icon(Icons.send_outlined),
                title: const Text('Send to user'),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  await _sendToUser();
                },
              ),
              ListTile(
                leading: const Icon(Icons.link),
                title: const Text('Copy link'),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  await _copyLink();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  bool _canManagePost(FeedItem feedItem) {
    final currentUserId = _currentUserId;
    if (currentUserId == null) return false;
    final authorId = feedItem.authorId;
    return authorId != null && authorId == currentUserId;
  }

  void _showPostOptionsSheet() async {
    final feedItem = _feedItem;
    if (feedItem == null) return;

    final isOwnPost = _canManagePost(feedItem);
    final action = await showPostOverflowActionsSheet(
      context: context,
      isOwnPost: isOwnPost,
      isSaved: feedItem.isFavorite,
    );

    if (!mounted || action == null) return;

    switch (action) {
      case PostOverflowAction.edit:
        await _editCaption();
        break;
      case PostOverflowAction.delete:
        _confirmDeletePost(feedItem.id);
        break;
      case PostOverflowAction.save:
        await _toggleBookmark();
        break;
      case PostOverflowAction.repost:
        await _handleRepost(feedItem);
        break;
      case PostOverflowAction.report:
        final selection = await showPostReportReasonSheet(context);
        if (selection == null) return;
        await _submitPostReport(
          postId: feedItem.id,
          reason: selection.reason,
          details: selection.details,
        );
        break;
    }
  }

  Future<void> _editCaption() async {
    final item = _feedItem;
    if (item == null) return;

    final updated = await showEditCaptionSheet(
      context: context,
      feedItem: item,
    );

    if (!mounted || updated == null) return;
    await _loadPost(showLoader: false);
  }

  Future<void> _handleRepost(FeedItem feedItem) async {
    if (feedItem.contentType == ContentType.story) return;
    final repostAction = await showRepostActionSheet(context);
    if (!mounted || repostAction == null) return;

    String? quoteCaption;
    if (repostAction == RepostAction.repostWithThoughts) {
      quoteCaption = await showRepostQuoteDialog(context);
      if (!mounted || quoteCaption == null) return;
    }

    final result = await getIt<PostRepository>().repostPost(
      originalPostId: feedItem.id,
      quoteCaption: quoteCaption,
    );

    if (!mounted) return;
    result.fold(
      (failure) => _showMessage('Failed to repost: ${failure.message}'),
      (_) => _showMessage(Translations.of(context).social.repostedToFeed),
    );
  }

  Future<void> _submitPostReport({
    required String postId,
    required String reason,
    String? details,
  }) async {
    final result = await getIt<PostRepository>().reportPost(
      postId: postId,
      reason: reason,
      details: details,
    );

    if (!mounted) return;
    result.fold(
      (failure) => _showMessage('Failed to report post: ${failure.message}'),
      (_) => _showMessage('Report submitted. Thank you.'),
    );
  }

  Future<void> _confirmDeletePost(String postId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete post'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    final result = await getIt<PostRepository>().deletePost(postId);
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (!mounted) return;

    result.fold(
      (failure) => messenger?.showSnackBar(
        SnackBar(content: Text('Failed to delete post: ${failure.message}')),
      ),
      (_) {
        context.pop(true);
        messenger?.showSnackBar(const SnackBar(content: Text('Post deleted')));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null || _feedItem == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                _error ?? t.feed.errorTitle,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _loadPost(showLoader: true),
                icon: const Icon(Icons.refresh),
                label: Text(t.feed.tryAgain),
              ),
            ],
          ),
        ),
      );
    }

    final feedItem = _feedItem!;

    if (feedItem.contentType == ContentType.videoPost) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
        ),
        body: FeedItemCard(
          feedItem: feedItem,
          isVisible: true,
          onLike: (_, __) => _toggleLike(),
          onComment: (_, __) => _showCommentSheet(),
          onShare: (_, __) => _showShareSheet(),
          onBookmark: (_, __) => _toggleBookmark(),
          onMoreTap: () => _showPostOptionsSheet(),
          onProfileTap: () {
            final authorUser = feedItem.authorUser;
            if (authorUser != null) {
              ProfileRoute(userId: authorUser.id).push(context);
            }
          },
          onFollowTap: _toggleFollow,
        ),
      );
    }

    if (feedItem.contentType == ContentType.textPost) {
      final colorScheme = Theme.of(context).colorScheme;
      return Scaffold(
        backgroundColor: colorScheme.surface,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(t.feed.tabs.text),
        ),
        body: SafeArea(
          child: PostDetailTextCommentThread(
            key: _textCommentThreadKey,
            post: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: TimelinePostCard(
                feedItem: feedItem,
                showCommentPreviewLink: false,
                showTrailingDivider: false,
                onLike: _toggleLike,
                onComment: () {
                  _textCommentThreadKey.currentState?.revealComposer();
                  _textPostCommentFocus.requestFocus();
                },
                onShare: _showShareSheet,
                onBookmark: _toggleBookmark,
                onMoreTap: _showPostOptionsSheet,
                onProfileTap: () {
                  final authorUser = feedItem.authorUser;
                  if (authorUser != null) {
                    ProfileRoute(userId: authorUser.id).push(context);
                  }
                },
                onFollowTap: _toggleFollow,
              ),
            ),
            contentId: feedItem.id,
            contentType: feedItem.contentType,
            initialCommentCount: feedItem.commentCount,
            initialTargetCommentId: widget.initialCommentId,
            commentInputFocusNode: _textPostCommentFocus,
            onCommentCountChanged: (count) {
              setState(() {
                final item = _feedItem;
                if (item != null) {
                  _feedItem = item.setCommentCount(count);
                }
              });
            },
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(t.feed.tabs.posts),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: TimelinePostCard(
            feedItem: feedItem,
            onLike: _toggleLike,
            onComment: _showCommentSheet,
            onShare: _showShareSheet,
            onBookmark: _toggleBookmark,
            onMoreTap: _showPostOptionsSheet,
            onProfileTap: () {
              final authorUser = feedItem.authorUser;
              if (authorUser != null) {
                ProfileRoute(userId: authorUser.id).push(context);
              }
            },
            onFollowTap: _toggleFollow,
          ),
        ),
      ),
    );
  }
}
