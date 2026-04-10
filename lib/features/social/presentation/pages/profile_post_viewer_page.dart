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
import 'package:myitihas/features/social/presentation/widgets/comment_sheet.dart';
import 'package:myitihas/features/social/presentation/widgets/feed_item_card.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class ProfilePostViewerPage extends StatefulWidget {
  final List<FeedItem> feedItems;
  final int initialIndex;

  const ProfilePostViewerPage({
    super.key,
    required this.feedItems,
    required this.initialIndex,
  });

  @override
  State<ProfilePostViewerPage> createState() => _ProfilePostViewerPageState();
}

class _ProfilePostViewerPageState extends State<ProfilePostViewerPage> {
  static const int _prefetchRadius = 1;
  late final PageController _pageController;
  late List<FeedItem> _items;
  late int _currentIndex;
  bool _isRouteActive = true;
  String? _currentUserId;
  final Set<String> _warmedVideoUrls = <String>{};

  @override
  void initState() {
    super.initState();
    final maxInitialIndex = widget.feedItems.isEmpty
        ? 0
        : widget.feedItems.length - 1;
    _currentIndex = widget.initialIndex.clamp(0, maxInitialIndex);
    _items = List<FeedItem>.from(widget.feedItems);
    _pageController = PageController(initialPage: _currentIndex);
    _loadCurrentUser();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _prefetchAroundIndex(_currentIndex);
    });
  }

  List<String> _imageUrlsFor(FeedItem item) {
    return item.when(
      story: (story) => story.imageUrl != null && story.imageUrl!.isNotEmpty
          ? <String>[story.imageUrl!]
          : const <String>[],
      imagePost: (post) => post.displayUrls,
      textPost: (post) => post.imageUrl != null && post.imageUrl!.isNotEmpty
          ? <String>[post.imageUrl!]
          : const <String>[],
      videoPost: (post) =>
          post.thumbnailUrl != null && post.thumbnailUrl!.isNotEmpty
          ? <String>[post.thumbnailUrl!]
          : const <String>[],
    );
  }

  String? _videoUrlFor(FeedItem item) {
    return item.when(
      story: (_) => null,
      imagePost: (_) => null,
      textPost: (_) => null,
      videoPost: (post) => post.videoUrl,
    );
  }

  void _prefetchAroundIndex(int centerIndex) {
    if (!mounted || _items.isEmpty) return;

    final int start = (centerIndex - _prefetchRadius).clamp(
      0,
      _items.length - 1,
    );
    final int end = (centerIndex + _prefetchRadius).clamp(0, _items.length - 1);

    for (int i = start; i <= end; i++) {
      _prefetchItem(_items[i]);
    }
  }

  void _prefetchItem(FeedItem item) {
    final imageUrls = _imageUrlsFor(item);
    for (final url in imageUrls) {
      if (url.isEmpty) continue;
      precacheImage(NetworkImage(url), context);
    }

    final videoUrl = _videoUrlFor(item);
    if (videoUrl != null && videoUrl.isNotEmpty) {
      _warmVideo(videoUrl);
    }
  }

  Future<void> _warmVideo(String videoUrl) async {
    if (_warmedVideoUrls.contains(videoUrl)) return;
    _warmedVideoUrls.add(videoUrl);

    try {
      final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await controller.initialize();
      await controller.dispose();
    } catch (_) {}
  }

  Future<void> _loadCurrentUser() async {
    final result = await getIt<UserRepository>().getCurrentUser();
    if (!mounted) return;

    setState(() {
      _currentUserId = result.fold((_) => null, (user) => user.id);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.showSnackBar(SnackBar(content: Text(message)));
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
      case ContentType.comment:
        return ShareUrlBuilder.buildPostUrl(item.id);
    }
  }

  Future<void> _toggleLike(int index) async {
    if (index < 0 || index >= _items.length) return;

    final previous = _items[index];
    final updated = previous.toggleLike();

    setState(() {
      _items[index] = updated;
    });

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
      setState(() {
        _items[index] = previous;
      });
      _showMessage('Failed to update like: ${failure.message}');
    }, (_) {});
  }

  Future<void> _toggleBookmark(int index) async {
    if (index < 0 || index >= _items.length) return;

    final previous = _items[index];
    if (previous.contentType == ContentType.story) {
      _showMessage('Bookmark is not supported for this content here.');
      return;
    }

    final updated = previous.toggleBookmark();
    setState(() {
      _items[index] = updated;
    });

    final result = await getIt<PostRepository>().toggleBookmark(
      contentId: previous.id,
      contentType: previous.contentType,
    );

    if (!mounted) return;

    result.fold((failure) {
      setState(() {
        _items[index] = previous;
      });
      _showMessage('Failed to update bookmark: ${failure.message}');
    }, (_) {});
  }

  Future<void> _showCommentSheet(int index) async {
    if (index < 0 || index >= _items.length) return;
    final item = _items[index];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CommentSheet(
        contentId: item.id,
        contentType: item.contentType,
        initialCommentCount: item.commentCount,
      ),
    );
  }

  Future<void> _recordShare(FeedItem item) async {
    final result = await getIt<SocialRepository>().shareContent(
      contentId: item.id,
      contentType: item.contentType,
      shareType: ShareType.external,
    );

    if (!mounted) return;

    result.fold((_) {}, (_) {
      final index = _items.indexWhere((element) => element.id == item.id);
      if (index == -1) return;
      setState(() {
        _items[index] = _items[index].incrementShareCount();
      });
    });
  }

  Future<void> _shareExternally(int index) async {
    if (index < 0 || index >= _items.length) return;
    final item = _items[index];
    final link = _buildContentLink(item);

    try {
      await SharePlus.instance.share(
        ShareParams(text: 'Check this out on MyItihas\n\n$link'),
      );
      await _recordShare(item);
    } catch (e) {
      _showMessage('Failed to share post: $e');
    }
  }

  Future<void> _copyLink(int index) async {
    if (index < 0 || index >= _items.length) return;
    await Clipboard.setData(
      ClipboardData(text: _buildContentLink(_items[index])),
    );
    _showMessage('Link copied');
  }

  Future<void> _showShareSheet(int index) async {
    if (index < 0 || index >= _items.length) return;

    final colorScheme = Theme.of(context).colorScheme;

    await showModalBottomSheet<void>(
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
                  await _shareExternally(index);
                },
              ),
              ListTile(
                leading: const Icon(Icons.link),
                title: const Text('Copy link'),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  await _copyLink(index);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  bool _canManagePost(FeedItem item) {
    final authorId = item.authorId;
    if (authorId == null || _currentUserId == null) return false;
    return authorId == _currentUserId;
  }

  Future<void> _deletePost(int index) async {
    if (index < 0 || index >= _items.length) return;

    final item = _items[index];
    final result = await getIt<PostRepository>().deletePost(item.id);
    if (!mounted) return;

    result.fold(
      (failure) => _showMessage('Failed to delete post: ${failure.message}'),
      (_) {
        setState(() {
          _items.removeAt(index);
          if (_items.isEmpty) {
            context.pop(true);
            return;
          }

          if (_currentIndex >= _items.length) {
            _currentIndex = _items.length - 1;
          }
        });

        if (_items.isNotEmpty && _pageController.hasClients) {
          _pageController.jumpToPage(_currentIndex);
        }

        _showMessage('Post deleted');
      },
    );
  }

  Future<void> _showMoreSheet(int index) async {
    if (index < 0 || index >= _items.length) return;
    final item = _items[index];
    final isOwnPost = _canManagePost(item);
    final colorScheme = Theme.of(context).colorScheme;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: colorScheme.surface,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isOwnPost)
                ListTile(
                  leading: Icon(Icons.delete_outline, color: colorScheme.error),
                  title: Text(
                    'Delete post',
                    style: TextStyle(color: colorScheme.error),
                  ),
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    await _deletePost(index);
                  },
                )
              else
                ListTile(
                  leading: const Icon(Icons.flag_outlined),
                  title: const Text('Report post'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _showMessage('Report flow will be added here.');
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text(
            'No posts to display',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              allowImplicitScrolling: true,
              physics: const BouncingScrollPhysics(),
              itemCount: _items.length,
              onPageChanged: (index) {
                HapticFeedback.selectionClick();
                setState(() {
                  _currentIndex = index;
                });
                _prefetchAroundIndex(index);
              },
              itemBuilder: (context, index) {
                final item = _items[index];
                return KeyedSubtree(
                  key: ValueKey<String>(
                    'profile-viewer-${item.id}-${item.contentType.name}',
                  ),
                  child: FeedItemCard(
                    feedItem: item,
                    isVisible: index == _currentIndex && _isRouteActive,
                    imageMediaFit: BoxFit.contain,
                    videoStartMuted: true,
                    videoShowPersistentMuteBadge: true,
                    onLike: (_, __) => _toggleLike(index),
                    onComment: (_, __) => _showCommentSheet(index),
                    onShare: (_, __) => _showShareSheet(index),
                    onBookmark: (_, __) => _toggleBookmark(index),
                    onProfileTap: () async {
                      final author = item.authorUser;
                      if (author == null) return;

                      setState(() {
                        _isRouteActive = false;
                      });

                      await WidgetsBinding.instance.endOfFrame;

                      try {
                        await ProfileRoute(userId: author.id).push(context);
                      } finally {
                        if (mounted) {
                          setState(() {
                            _isRouteActive = true;
                          });
                        }
                      }
                    },
                    onMoreTap: () => _showMoreSheet(index),
                  ),
                );
              },
            ),
            Positioned(
              top: MediaQuery.paddingOf(context).top + 8,
              left: 8,
              child: Material(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(999),
                child: InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () => context.pop(),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.paddingOf(context).top + 14,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_currentIndex + 1}/${_items.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
