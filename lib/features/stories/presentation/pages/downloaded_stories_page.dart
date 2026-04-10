import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/services/downloaded_stories_service.dart';
import 'package:myitihas/core/cache/widgets/story_image.dart';

class DownloadedStoriesPage extends StatefulWidget {
  const DownloadedStoriesPage({super.key});

  @override
  State<DownloadedStoriesPage> createState() => _DownloadedStoriesPageState();
}

class _DownloadedStoriesPageState extends State<DownloadedStoriesPage> {
  List<Story> _stories = [];
  bool _isLoading = true;
  Set<String> _selectedStoryIds = {};
  
  bool get _isSelectionMode => _selectedStoryIds.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _loadStories();
  }

  Future<void> _loadStories() async {
    setState(() => _isLoading = true);
    final service = DownloadedStoriesService();
    final stories = await service.getDownloadedStories();
    setState(() {
      _stories = stories;
      _isLoading = false;
    });
  }

  Future<void> _deleteStory(String id) async {
    final service = DownloadedStoriesService();
    await service.deleteDownloadedStory(id);
    _loadStories(); // reload
  }

  Future<void> _deleteSelectedStories() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Selected'),
        content: Text('Are you sure you want to remove ${_selectedStoryIds.length} stories from your device?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final service = DownloadedStoriesService();
    for (var id in _selectedStoryIds) {
      await service.deleteDownloadedStory(id);
    }
    setState(() => _selectedStoryIds.clear());
    _loadStories();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selected stories removed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    theme.colorScheme.surface,
                    theme.colorScheme.surface.withOpacity(0.95),
                    theme.colorScheme.surfaceContainerHigh,
                  ]
                : [
                    theme.colorScheme.surface,
                    theme.colorScheme.surfaceContainerLow.withOpacity(0.5),
                    theme.colorScheme.surfaceContainerHigh,
                  ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar.large(
              title: Text(_isSelectionMode ? '${_selectedStoryIds.length} Selected' : 'Downloaded Stories'),
              leading: _isSelectionMode
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _selectedStoryIds.clear()),
                    )
                  : IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      onPressed: () => context.pop(),
                    ),
              actions: [
                if (_isSelectionMode)
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: _deleteSelectedStories,
                  ),
              ],
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            if (_isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_stories.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _buildEmptyState(theme),
              )
            else
              _buildStoriesList(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_download_outlined,
                size: 80,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Offline Stories',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Stories you download will appear here for you to read anytime, even without an internet connection.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoriesList(ThemeData theme) {
    // Reverse the list to show newest downloads first
    final displayStories = _stories.reversed.toList();
    
    return SliverPadding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32, top: 8),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final story = displayStories[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Dismissible(
                key: Key(story.id),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _deleteStory(story.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Story removed from downloads')),
                  );
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 32),
                ),
                child: GestureDetector(
                  onLongPress: () {
                    setState(() {
                      if (_selectedStoryIds.contains(story.id)) {
                        _selectedStoryIds.remove(story.id);
                      } else {
                        _selectedStoryIds.add(story.id);
                      }
                    });
                  },
                  onTap: () {
                    if (_isSelectionMode) {
                      setState(() {
                        if (_selectedStoryIds.contains(story.id)) {
                          _selectedStoryIds.remove(story.id);
                        } else {
                          _selectedStoryIds.add(story.id);
                        }
                      });
                    } else {
                      GeneratedStoryResultRoute($extra: story).push(context);
                    }
                  },
                  child: Container(
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: _selectedStoryIds.contains(story.id)
                          ? Border.all(color: theme.colorScheme.primary, width: 3)
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Cached Image or Shimmer Generator
                          StoryImage(
                            imageUrl: story.imageUrl,
                            fit: BoxFit.cover,
                            memCacheWidth: 600,
                            memCacheHeight: 600,
                            fallbackIndex: index,
                          ),
                          // Dark Gradient Overlay for Readability
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.8),
                                ],
                                stops: const [0.4, 1.0],
                              ),
                            ),
                          ),
                          // Content Elements
                          Positioned(
                            bottom: 16,
                            left: 16,
                            right: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.menu_book_rounded, color: Colors.white.withOpacity(0.9), size: 16),
                                    const SizedBox(width: 8),
                                    Text(
                                      story.attributes.storyType.isNotEmpty ? story.attributes.storyType : 'Story',
                                      style: theme.textTheme.labelMedium?.copyWith(
                                        color: Colors.white.withOpacity(0.9),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  story.title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // Selection checkmark
                          if (_selectedStoryIds.contains(story.id))
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.check, color: theme.colorScheme.onPrimary, size: 20),
                              ),
                            ),
                          // Download Icon Indication
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.offline_pin_rounded, color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          childCount: displayStories.length,
        ),
      ),
    );
  }
}
