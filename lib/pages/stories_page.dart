import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/core/widgets/voice_input/voice_input_button.dart';
import 'package:myitihas/core/cache/services/prefetch_service.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/features/stories/presentation/bloc/stories_bloc.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/features/stories/presentation/widgets/story_card.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/pages/Chat/Widget/share_to_conversation_sheet.dart';
import 'package:myitihas/services/chat_service.dart';
import 'package:shimmer/shimmer.dart';

class StoriesPage extends StatelessWidget {
  const StoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<StoriesBloc>()..add(const StoriesEvent.loadStories()),
      child: const _StoriesPageContent(),
    );
  }
}

class _StoriesPageContent extends StatefulWidget {
  const _StoriesPageContent();

  @override
  State<_StoriesPageContent> createState() => _StoriesPageContentState();
}

class _StoriesPageContentState extends State<_StoriesPageContent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final gradients = theme.extension<GradientExtension>();
    final aspectRatio = MediaQuery.of(context).size.aspectRatio;

    return BlocListener<StoriesBloc, StoriesState>(
      listenWhen: (prev, curr) => curr.maybeWhen(
        loaded: (stories, searchQuery, sortBy, filterType, filterTheme) =>
            stories.isNotEmpty,
        orElse: () => false,
      ),
      listener: (context, state) {
        state.whenOrNull(
          loaded: (stories, searchQuery, sortBy, filterType, filterTheme) {
            final urls = stories
                .where((s) =>
                    s.imageUrl != null && s.imageUrl!.trim().isNotEmpty)
                .map((s) => s.imageUrl!)
                .toSet()
                .toList();
            if (urls.isNotEmpty && context.mounted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!context.mounted) return;
                getIt<PrefetchService>().prefetchImages(
                  context,
                  urls,
                  maxPrefetch: 12,
                );
              });
            }
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: theme.extension<GradientExtension>()?.screenBackgroundGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.fromLTRB(8.w, 12.h, 8.w, 12.h),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      color: theme.colorScheme.onSurface,
                      tooltip: t.common.back,
                      onPressed: () => context.pop(),
                      style: IconButton.styleFrom(
                        backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) =>
                                (gradients?.brandTextGradient ??
                                        LinearGradient(
                                          colors: [
                                            theme.colorScheme.primary,
                                            theme.colorScheme.secondary,
                                          ],
                                        ))
                                    .createShader(bounds),
                            child: Text(
                              t.stories.title,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            t.stories.subtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.9),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Search and Sort Row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: _SearchBar(
                        controller: _searchController,
                        hint: t.stories.searchHint,
                        onChanged: (query) {
                          context.read<StoriesBloc>().add(
                                StoriesEvent.searchStories(query),
                              );
                        },
                        onClear: () {
                          _searchController.clear();
                          context.read<StoriesBloc>().add(
                                const StoriesEvent.searchStories(''),
                              );
                        },
                        theme: theme,
                        isDark: isDark,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    _SortButton(
                      theme: theme,
                      gradients: gradients,
                      aspectRatio: aspectRatio,
                      onSelected: (value) {
                        HapticFeedback.selectionClick();
                        context.read<StoriesBloc>().add(
                              StoriesEvent.sortStories(value),
                            );
                      },
                      sortNewest: t.stories.sortNewest,
                      sortOldest: t.stories.sortOldest,
                      sortPopular: t.stories.sortPopular,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // Stories List
              Expanded(
                child: BlocBuilder<StoriesBloc, StoriesState>(
                  builder: (context, state) {
                    return state.when(
                      initial: () => _buildLoadingShimmer(context, isDark),
                      loading: () => _buildLoadingShimmer(context, isDark),
                      loaded:
                          (stories, searchQuery, sortBy, filterType, filterTheme) {
                        if (stories.isEmpty) {
                          return _buildEmptyState(context, theme, t);
                        }
                        return RefreshIndicator(
                          onRefresh: () async {
                            HapticFeedback.mediumImpact();
                            context.read<StoriesBloc>().add(
                                  const StoriesEvent.refreshStories(),
                                );
                          },
                          color: theme.colorScheme.primary,
                          backgroundColor: theme.colorScheme.surfaceContainerHighest,
                          strokeWidth: 2.5,
                          child: ListView.builder(
                            itemCount: stories.length,
                            padding: EdgeInsets.only(
                              top: 4.h,
                              bottom: 24.h,
                              left: 0,
                              right: 0,
                            ),
                            physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics(),
                            ),
                            itemBuilder: (context, index) {
                              final story = stories[index];
                              return _StaggeredStoryTile(
                                index: index,
                                child: StoryCard(
                                  story: story,
                                  onTap: () {
                                    StoryDetailRoute(id: story.id).go(context);
                                  },
                                  onFavorite: () {
                                    context.read<StoriesBloc>().add(
                                          StoriesEvent.toggleFavorite(story.id),
                                        );
                                  },
                                  onShare: () => _shareStoryToConversation(context, story),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      error: (message) => _buildErrorState(
                        context,
                        theme,
                        t,
                        message,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _shareStoryToConversation(BuildContext context, Story story) async {
    final conversationId = await ShareToConversationSheet.show(context);
    if (conversationId == null || !context.mounted) return;

    final chatService = getIt<ChatService>();
    try {
      await chatService.sendMessage(
        conversationId: conversationId,
        content: 'Shared a story',
        type: 'story',
        sharedContentId: story.id,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Story shared'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to share story: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildLoadingShimmer(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final baseColor = isDark
        ? theme.colorScheme.surfaceContainerHigh
        : theme.colorScheme.surfaceContainerLow;
    final highlightColor = isDark
        ? theme.colorScheme.surfaceContainerLow
        : theme.colorScheme.surfaceContainerHighest;

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              height: 280.h,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 160.h,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.r),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 18.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: highlightColor,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          height: 12.h,
                          width: 120.w,
                          decoration: BoxDecoration(
                            color: highlightColor,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          height: 12.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: highlightColor,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          height: 12.h,
                          width: 200.w,
                          decoration: BoxDecoration(
                            color: highlightColor,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    ThemeData theme,
    Translations t,
  ) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(28.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_stories_rounded,
                size: 72.sp,
                color: theme.colorScheme.primary.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              t.stories.noStories,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              t.stories.noStoriesHint,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    ThemeData theme,
    Translations t,
    String message,
  ) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_off_rounded,
                size: 64.sp,
                color: theme.colorScheme.error,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              t.stories.errorLoadingStories,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            FilledButton.icon(
              onPressed: () {
                HapticFeedback.mediumImpact();
                context.read<StoriesBloc>().add(
                      const StoriesEvent.loadStories(),
                    );
              },
              icon: const Icon(Icons.refresh_rounded),
              label: Text(t.common.retry),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Search bar with optional glass effect
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final ThemeData theme;
  final bool isDark;

  const _SearchBar({
    required this.controller,
    required this.hint,
    required this.onChanged,
    required this.onClear,
    required this.theme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: TextFormField(
          controller: controller,
          autofocus: false,
          onChanged: onChanged,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              Icons.search_rounded,
              color: theme.colorScheme.primary,
              size: 22.sp,
            ),
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    VoiceInputButton(
                      controller: controller,
                      compact: true,
                    ),
                    if (value.text.isNotEmpty)
                      IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          size: 20.sp,
                          color: theme.colorScheme.outline,
                        ),
                        onPressed: onClear,
                      ),
                  ],
                );
              },
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 14.h,
              horizontal: 18.w,
            ),
            filled: true,
            fillColor: isDark
                ? theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.6)
                : theme.colorScheme.surface.withValues(alpha: 0.9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.r),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.r),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.15),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.r),
              borderSide: BorderSide(
                color: theme.colorScheme.primary.withValues(alpha: 0.6),
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  final ThemeData theme;
  final GradientExtension? gradients;
  final double aspectRatio;
  final ValueChanged<String> onSelected;
  final String sortNewest;
  final String sortOldest;
  final String sortPopular;

  const _SortButton({
    required this.theme,
    required this.gradients,
    required this.aspectRatio,
    required this.onSelected,
    required this.sortNewest,
    required this.sortOldest,
    required this.sortPopular,
  });

  @override
  Widget build(BuildContext context) {
    final size = aspectRatio > 0.5 ? 52.0 : 48.0;
    return PopupMenuButton<String>(
      onSelected: onSelected,
      splashRadius: 0,
      padding: EdgeInsets.zero,
      offset: const Offset(0, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      color: theme.cardColor,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'newest',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.schedule_rounded, size: 20.sp),
            title: Text(sortNewest),
          ),
        ),
        PopupMenuItem(
          value: 'oldest',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.history_rounded, size: 20.sp),
            title: Text(sortOldest),
          ),
        ),
        PopupMenuItem(
          value: 'popular',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.trending_up_rounded, size: 20.sp),
            title: Text(sortPopular),
          ),
        ),
      ],
      child: Container(
        width: size.w,
        height: size.w,
        decoration: BoxDecoration(
          gradient: gradients?.primaryButtonGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.sort_rounded,
          color: Colors.white,
          size: (aspectRatio > 0.5 ? 26 : 22).sp,
        ),
      ),
    );
  }
}

/// Wraps a story card with a staggered fade-in animation
class _StaggeredStoryTile extends StatefulWidget {
  final int index;
  final Widget child;

  const _StaggeredStoryTile({
    required this.index,
    required this.child,
  });

  @override
  State<_StaggeredStoryTile> createState() => _StaggeredStoryTileState();
}

class _StaggeredStoryTileState extends State<_StaggeredStoryTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.03),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    final delay = widget.index * 40;
    Future.delayed(Duration(milliseconds: delay.clamp(0, 200)), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}
