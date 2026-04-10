import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/features/social/domain/entities/content_type.dart';
import 'package:myitihas/features/social/presentation/widgets/comment_sheet.dart';
import 'package:myitihas/pages/map2/widgets/custom_icon_widget.dart';
import 'package:myitihas/profile/widget/custom_image_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

class ProfileContentGridWidget extends StatefulWidget {
  final List<Map<String, dynamic>> contentItems;
  final bool isLoading;
  final int currentTabIndex;

  const ProfileContentGridWidget({
    super.key,
    required this.contentItems,
    required this.isLoading,
    required this.currentTabIndex,
  });

  @override
  State<ProfileContentGridWidget> createState() =>
      _ProfileContentGridWidgetState();
}

class _ProfileContentGridWidgetState extends State<ProfileContentGridWidget> {
  static const Duration _extraHoldDuration = Duration(milliseconds: 700);
  Timer? _extraHoldTimer;
  BuildContext? _previewDialogContext;
  bool _isPreviewOpen = false;
  bool _openedOptionsFromHold = false;

  @override
  void dispose() {
    _extraHoldTimer?.cancel();
    _closeHoldPreview();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.isLoading) {
      return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 1.w,
          mainAxisSpacing: 1.w,
          childAspectRatio: 1,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          childCount: 9,
        ),
      );
    }

    if (widget.contentItems.isEmpty) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 30.h,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: widget.currentTabIndex == 3
                      ? 'auto_stories'
                      : 'photo_library',
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.5,
                  ),
                  size: 48,
                ),
                SizedBox(height: 2.h),
                Text(
                  widget.currentTabIndex == 3
                      ? 'No stories yet'
                      : 'No content yet',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 3.h),
                Container(
                  decoration: BoxDecoration(
                    gradient: theme
                        .extension<GradientExtension>()
                        ?.primaryButtonGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (widget.currentTabIndex == 3) {
                        const StoryGeneratorRoute().push(context);
                      } else {
                        const CreatePostRoute().push(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 1.5.h,
                      ),
                    ),
                    child: Text(
                      widget.currentTabIndex == 3
                          ? 'Generate a story'
                          : 'Create a post',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1.w,
        mainAxisSpacing: 1.w,
        childAspectRatio: 1,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final item = widget.contentItems[index];
        return GestureDetector(
          onTap: () {
            _openInstagramViewer(context, index);
          },
          onLongPressStart: (_) => _handleLongPressStart(context, item),
          onLongPressEnd: (_) => _handleLongPressEnd(),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl: item['thumbnail'],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  semanticLabel: item['semanticLabel'],
                ),
              ),
              if (item['type'] == 'video')
                Positioned(
                  top: 1.h,
                  right: 1.w,
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: CustomIconWidget(
                      iconName: 'play_arrow',
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              if (item['type'] == 'photo' &&
                  ((item['images'] as List?)?.length ?? 0) > 1)
                Positioned(
                  top: 1.h,
                  right: 1.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 1.5.w,
                      vertical: 0.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'collections',
                          color: Colors.white,
                          size: 14,
                        ),
                        SizedBox(width: 0.5.w),
                        Text(
                          '+${((item['images'] as List?)?.length ?? 0) - 1}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Positioned(
                bottom: 1.h,
                left: 1.w,
                right: 1.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 0.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'favorite',
                        color: Colors.white,
                        size: 12,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        _formatCount((item['likes'] as int?) ?? 0),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontSize: 10.sp,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      CustomIconWidget(
                        iconName: 'comment',
                        color: Colors.white,
                        size: 12,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        _formatCount((item['comments'] as int?) ?? 0),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }, childCount: widget.contentItems.length),
    );
  }

  void _handleLongPressStart(BuildContext context, Map<String, dynamic> item) {
    _openedOptionsFromHold = false;
    _showHoldPreview(context, item);

    _extraHoldTimer?.cancel();
    _extraHoldTimer = Timer(_extraHoldDuration, () {
      if (!mounted) return;
      _openedOptionsFromHold = true;
      _closeHoldPreview();
      _showContentOptions(context, item);
    });
  }

  void _handleLongPressEnd() {
    _extraHoldTimer?.cancel();
    if (!_openedOptionsFromHold) {
      _closeHoldPreview();
    }
  }

  Future<void> _showHoldPreview(
    BuildContext context,
    Map<String, dynamic> item,
  ) async {
    if (_isPreviewOpen) return;

    _isPreviewOpen = true;
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Preview',
      transitionDuration: const Duration(milliseconds: 120),
      pageBuilder: (_, __, ___) {
        return StatefulBuilder(
          builder: (dialogContext, _) {
            _previewDialogContext = dialogContext;
            return Listener(
              behavior: HitTestBehavior.opaque,
              onPointerUp: (_) => _closeHoldPreview(),
              onPointerCancel: (_) => _closeHoldPreview(),
              child: Material(
                color: Colors.black.withValues(alpha: 0.9),
                child: SafeArea(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 9 / 16,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: _buildMainMedia(item, isViewerPageActive: true),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
    _previewDialogContext = null;
    _isPreviewOpen = false;
  }

  void _closeHoldPreview() {
    final dialogContext = _previewDialogContext;
    if (_isPreviewOpen && dialogContext != null) {
      Navigator.of(dialogContext).pop();
    }
  }

  void _openInstagramViewer(BuildContext context, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _ProfileGridInstagramViewer(
          initialItems: widget.contentItems,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  Widget _buildMainMedia(
    Map<String, dynamic> item, {
    required bool isViewerPageActive,
  }) {
    final type = (item['type'] ?? '').toString();
    if (type == 'video') {
      final videoUrl = (item['videoUrl'] ?? '').toString();
      if (videoUrl.isNotEmpty) {
        return _AutoplayVideoSurface(
          videoUrl: videoUrl,
          thumbnailUrl: (item['thumbnail'] ?? '').toString(),
          isActive: isViewerPageActive,
        );
      }
    }

    final images =
        (item['images'] as List?)?.cast<String>() ?? const <String>[];
    if (images.length > 1) {
      return _ImageCarousel(images: images);
    }

    return Container(
      color: Colors.black,
      child: InteractiveViewer(
        minScale: 1,
        maxScale: 4,
        child: Center(
          child: CustomImageWidget(
            imageUrl: (item['thumbnail'] ?? '').toString(),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.contain,
            semanticLabel: (item['semanticLabel'] ?? '').toString(),
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(
    BuildContext context,
    String iconName,
    int count,
    ThemeData theme,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: theme.colorScheme.primary,
            size: 18,
          ),
          SizedBox(width: 1.w),
          Text(
            _formatCount(count),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showContentOptions(BuildContext context, Map<String, dynamic> item) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 2.h),
              Text('Post Options', style: theme.textTheme.titleLarge),
              SizedBox(height: 3.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'edit',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                title: Text('Edit Post', style: theme.textTheme.bodyLarge),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'share',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                title: Text('Share Post', style: theme.textTheme.bodyLarge),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'delete',
                  color: theme.colorScheme.error,
                  size: 24,
                ),
                title: Text(
                  'Delete Post',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileGridInstagramViewer extends StatefulWidget {
  final List<Map<String, dynamic>> initialItems;
  final int initialIndex;

  const _ProfileGridInstagramViewer({
    required this.initialItems,
    required this.initialIndex,
  });

  @override
  State<_ProfileGridInstagramViewer> createState() =>
      _ProfileGridInstagramViewerState();
}

class _ProfileGridInstagramViewerState
    extends State<_ProfileGridInstagramViewer> {
  static const int _prefetchRadius = 1;
  late final PageController _pageController;
  late List<Map<String, dynamic>> _items;
  late int _currentIndex;
  final Set<String> _warmedVideoUrls = <String>{};

  @override
  void initState() {
    super.initState();
    _items = widget.initialItems
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    final maxInitial = _items.isEmpty ? 0 : _items.length - 1;
    _currentIndex = widget.initialIndex.clamp(0, maxInitial);
    _pageController = PageController(initialPage: _currentIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _prefetchAroundIndex(_currentIndex);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _itemCount(String key) => (_items[_currentIndex][key] as int?) ?? 0;

  bool _isLiked() => (_items[_currentIndex]['isLiked'] as bool?) ?? false;

  void _toggleLike() {
    setState(() {
      final currentLiked = _isLiked();
      _items[_currentIndex]['isLiked'] = !currentLiked;
      final currentLikes = _itemCount('likes');
      _items[_currentIndex]['likes'] = currentLiked
          ? (currentLikes - 1).clamp(0, 9999999)
          : currentLikes + 1;
    });
  }

  ContentType? _mapItemToContentType(Map<String, dynamic> item) {
    final rawType = (item['type'] ?? '').toString().toLowerCase();
    switch (rawType) {
      case 'video':
        return ContentType.videoPost;
      case 'photo':
      case 'image':
        return ContentType.imagePost;
      case 'thought':
      case 'text':
        return ContentType.textPost;
      case 'share':
      case 'story':
      case 'story_share':
        return ContentType.story;
      default:
        return null;
    }
  }

  List<String> _imageUrlsFor(Map<String, dynamic> item) {
    final urls = <String>[];
    final thumbnail = (item['thumbnail'] ?? '').toString();
    if (thumbnail.isNotEmpty) {
      urls.add(thumbnail);
    }
    final images =
        (item['images'] as List?)?.cast<String>() ?? const <String>[];
    urls.addAll(images.where((url) => url.isNotEmpty));
    return urls.toSet().toList();
  }

  String? _videoUrlFor(Map<String, dynamic> item) {
    final videoUrl = (item['videoUrl'] ?? '').toString();
    return videoUrl.isEmpty ? null : videoUrl;
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

  void _prefetchItem(Map<String, dynamic> item) {
    for (final url in _imageUrlsFor(item)) {
      precacheImage(NetworkImage(url), context);
    }

    final videoUrl = _videoUrlFor(item);
    if (videoUrl != null) {
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

  Future<void> _showComments() async {
    if (_items.isEmpty) return;
    final currentItem = _items[_currentIndex];
    final contentType = _mapItemToContentType(currentItem);
    final contentId =
        (currentItem['contentId'] ?? currentItem['id'])?.toString() ?? '';

    if (contentType == null || contentId.isEmpty) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(
          content: Text('Comments are not available for this post.'),
        ),
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return CommentSheet(
          contentId: contentId,
          contentType: contentType,
          initialCommentCount: _itemCount('comments'),
          onCommentCountChanged: (newCount) {
            if (!mounted) return;
            setState(() {
              _items[_currentIndex]['comments'] = newCount;
            });
          },
        );
      },
    );
  }

  Future<void> _shareCurrent() async {
    final item = _items[_currentIndex];
    final thumbnail = (item['thumbnail'] ?? '').toString();
    await SharePlus.instance.share(
      ShareParams(text: 'Check this post on MyItihas\n\n$thumbnail'),
    );
    setState(() {
      final currentShares = _itemCount('shareCount');
      _items[_currentIndex]['shareCount'] = currentShares + 1;
    });
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

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            allowImplicitScrolling: true,
            physics: const BouncingScrollPhysics(),
            itemCount: _items.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
              _prefetchAroundIndex(index);
            },
            itemBuilder: (context, index) {
              final item = _items[index];
              final type = (item['type'] ?? '').toString();
              final videoUrl = (item['videoUrl'] ?? '').toString();
              final images =
                  (item['images'] as List?)?.cast<String>() ?? const <String>[];

              Widget media;
              if (type == 'video' && videoUrl.isNotEmpty) {
                media = _AutoplayVideoSurface(
                  videoUrl: videoUrl,
                  thumbnailUrl: (item['thumbnail'] ?? '').toString(),
                  isActive: index == _currentIndex,
                );
              } else if (images.length > 1) {
                media = _ImageCarousel(images: images);
              } else {
                media = InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  child: Center(
                    child: CustomImageWidget(
                      imageUrl: (item['thumbnail'] ?? '').toString(),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.contain,
                      semanticLabel: (item['semanticLabel'] ?? '').toString(),
                    ),
                  ),
                );
              }

              return KeyedSubtree(
                key: ValueKey<String>(
                  'own-profile-${item['id']}-${item['type']}',
                ),
                child: Container(color: Colors.black, child: media),
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
                onTap: () => Navigator.of(context).pop(),
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.paddingOf(context).bottom + 16,
            child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.4.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _ActionButton(
                      icon: _isLiked() ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked() ? Colors.redAccent : Colors.white,
                      label: '${_itemCount('likes')}',
                      onTap: _toggleLike,
                    ),
                    _ActionButton(
                      icon: Icons.mode_comment_outlined,
                      color: Colors.white,
                      label: '${_itemCount('comments')}',
                      onTap: _showComments,
                    ),
                    _ActionButton(
                      icon: Icons.share_outlined,
                      color: Colors.white,
                      label: '${_itemCount('shareCount')}',
                      onTap: _shareCurrent,
                    ),
                    _ActionButton(
                      icon: Icons.more_horiz,
                      color: Colors.white,
                      label: 'More',
                      onTap: () {
                        showModalBottomSheet<void>(
                          context: context,
                          showDragHandle: true,
                          builder: (ctx) {
                            return ListTile(
                              leading: Icon(
                                Icons.info_outline,
                                color: theme.colorScheme.primary,
                              ),
                              title: const Text('Post details'),
                              subtitle: const Text(
                                'More actions can be added here.',
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageCarousel extends StatefulWidget {
  final List<String> images;

  const _ImageCarousel({required this.images});

  @override
  State<_ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<_ImageCarousel> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView.builder(
          itemCount: widget.images.length,
          onPageChanged: (index) {
            setState(() {
              _current = index;
            });
          },
          itemBuilder: (context, index) {
            return InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Center(
                child: CustomImageWidget(
                  imageUrl: widget.images[index],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,
                  semanticLabel: 'Carousel image ${index + 1}',
                ),
              ),
            );
          },
        ),
        Positioned(
          bottom: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${_current + 1}/${widget.images.length}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class _AutoplayVideoSurface extends StatefulWidget {
  final String videoUrl;
  final String thumbnailUrl;
  final bool isActive;

  const _AutoplayVideoSurface({
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.isActive,
  });

  @override
  State<_AutoplayVideoSurface> createState() => _AutoplayVideoSurfaceState();
}

class _AutoplayVideoSurfaceState extends State<_AutoplayVideoSurface>
    with AutomaticKeepAliveClientMixin {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void didUpdateWidget(covariant _AutoplayVideoSurface oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.videoUrl != oldWidget.videoUrl) {
      _disposeController();
      _initialize();
      return;
    }

    if (_controller == null || !_isInitialized) return;
    if (widget.isActive) {
      _controller!.play();
    } else {
      _controller!.pause();
    }
  }

  Future<void> _initialize() async {
    try {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );
      await controller.initialize();
      await controller.setLooping(true);
      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _controller = controller;
        _isInitialized = true;
      });

      if (widget.isActive) {
        controller.play();
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
      });
    }
  }

  void _disposeController() {
    _controller?.dispose();
    _controller = null;
    _isInitialized = false;
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_hasError) {
      return Center(
        child: CustomImageWidget(
          imageUrl: widget.thumbnailUrl,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.contain,
          semanticLabel: 'Video thumbnail fallback',
        ),
      );
    }

    if (!_isInitialized || _controller == null) {
      return Center(
        child: CustomImageWidget(
          imageUrl: widget.thumbnailUrl,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.contain,
          semanticLabel: 'Video loading thumbnail',
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (_controller!.value.isPlaying) {
          _controller!.pause();
        } else if (widget.isActive) {
          _controller!.play();
        }
        setState(() {});
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: _controller!.value.size.width,
              height: _controller!.value.size.height,
              child: VideoPlayer(_controller!),
            ),
          ),
          if (!_controller!.value.isPlaying)
            const Center(
              child: Icon(
                Icons.play_circle_fill_rounded,
                color: Colors.white,
                size: 64,
              ),
            ),
        ],
      ),
    );
  }
}
