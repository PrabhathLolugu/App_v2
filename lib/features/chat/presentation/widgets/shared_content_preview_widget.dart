import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/core/cache/managers/image_cache_manager.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/utils/content_language.dart';
import 'package:myitihas/core/utils/language_voice_resolver.dart';
import 'package:myitihas/core/widgets/image_loading_placeholder/image_loading_placeholder.dart';
import 'package:myitihas/features/social/domain/repositories/post_repository.dart';
import 'package:myitihas/features/stories/domain/repositories/story_repository.dart';
import 'package:myitihas/pages/map2/Model/sacred_location.dart';
import 'package:myitihas/pages/map2/plan/saved_travel_plan.dart';
import 'package:myitihas/services/supabase_service.dart';

class SharedContentPreviewWidget extends StatefulWidget {
  final String sharedContentId;
  final String? contentType;

  const SharedContentPreviewWidget({
    super.key,
    required this.sharedContentId,
    this.contentType,
  });

  @override
  State<SharedContentPreviewWidget> createState() =>
      _SharedContentPreviewWidgetState();
}

class _SharedContentPreviewWidgetState
    extends State<SharedContentPreviewWidget> {
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _contentData;
  SavedTravelPlan? _cachedPlan;
  SacredLocation? _cachedLocation;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final normalizedType = widget.contentType?.toLowerCase();
      final isStoryType =
          normalizedType == null ||
          normalizedType.isEmpty ||
          normalizedType == 'story' ||
          normalizedType == 'story_share';

      if (normalizedType == 'sacredsite' && await _tryLoadSacredSite()) return;
      if (isStoryType && await _tryLoadStory()) return;
      if (await _tryLoadPost(normalizedType)) return;
      if (!isStoryType && await _tryLoadStory()) return;
      if (normalizedType == 'travelplan' && await _tryLoadTravelPlan()) return;

      _setError('Content not available');
    } catch (_) {
      _setError('Failed to load content');
    }
  }

  Future<bool> _tryLoadStory() async {
    final storyRepo = getIt<StoryRepository>();
    final storyResult = await storyRepo.getStoryById(widget.sharedContentId);
    final story = storyResult.fold((_) => null, (value) => value);
    if (story == null) return false;

    final contentLanguage = await ContentLanguageSettings.getCurrentLanguage();
    final languageCode = LanguageVoiceResolver.languageCodeFromAny(
      contentLanguage.displayName,
    );
    final translated = story.attributes.translations[languageCode];
    final resolvedTitle =
        translated != null && translated.title.trim().isNotEmpty
        ? translated.title
        : story.title;

    _setContentData({
      'type': 'story',
      'title': resolvedTitle,
      'imageUrl': story.imageUrl,
      'author': story.authorUser?.displayName ?? story.author ?? 'Unknown',
      'scripture': story.scripture,
    });
    return true;
  }

  Future<bool> _tryLoadPost(String? normalizedType) async {
    final postRepo = getIt<PostRepository>();

    switch (normalizedType) {
      case 'image':
      case 'imagepost':
      case 'image_post':
      case 'post':
      case null:
      case '':
        return _tryLoadImagePost(postRepo);
      case 'text':
      case 'textpost':
      case 'text_post':
        return _tryLoadTextPost(postRepo);
      case 'video':
      case 'videopost':
      case 'video_post':
        return _tryLoadVideoPost(postRepo);
      default:
        return false;
    }
  }

  Future<bool> _tryLoadImagePost(PostRepository postRepo) async {
    final result = await postRepo.getImagePostById(widget.sharedContentId);
    return result.fold((_) => false, (post) {
      _setContentData({
        'type': 'post',
        'postType': 'image',
        'title': post.caption ?? 'Image post',
        'imageUrl': post.imageUrl,
        'author': post.authorUser?.displayName ?? 'Unknown',
      });
      return true;
    });
  }

  Future<bool> _tryLoadTextPost(PostRepository postRepo) async {
    final result = await postRepo.getTextPostById(widget.sharedContentId);
    return result.fold((_) => false, (post) {
      final body = post.body.trim();
      _setContentData({
        'type': 'post',
        'postType': 'text',
        'title': body.isEmpty ? 'Post' : body,
        'imageUrl': post.imageUrl,
        'author': post.authorUser?.displayName ?? 'Unknown',
      });
      return true;
    });
  }

  Future<bool> _tryLoadVideoPost(PostRepository postRepo) async {
    final result = await postRepo.getVideoPostById(widget.sharedContentId);
    return result.fold((_) => false, (post) {
      _setContentData({
        'type': 'post',
        'postType': 'video',
        'title': post.caption?.trim().isNotEmpty == true
            ? post.caption!.trim()
            : 'Video post',
        'imageUrl': post.thumbnailUrl,
        'author': post.authorUser?.displayName ?? 'Unknown',
      });
      return true;
    });
  }

  Future<bool> _tryLoadTravelPlan() async {
    try {
      final response = await SupabaseService.client
          .from('saved_travel_plans')
          .select()
          .eq('id', widget.sharedContentId)
          .maybeSingle();
      if (response == null) return false;
      // ignore: unnecessary_cast - Supabase maybeSingle returns dynamic
      final plan = SavedTravelPlan.fromJson(response as Map<String, dynamic>);
      if (mounted) _cachedPlan = plan;
      _setContentData({
        'type': 'travelPlan',
        'title': plan.displayTitle,
        'imageUrl': plan.destinationImage,
        'author': plan.destinationRegion ?? 'Travel plan',
        'scripture': null,
        'fromLocation': plan.fromLocation,
        'startDate': plan.startDate,
        'endDate': plan.endDate,
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _tryLoadSacredSite() async {
    try {
      final id = int.tryParse(widget.sharedContentId);
      if (id == null) return false;

      final response = await SupabaseService.client
          .from('sacred_locations')
          .select()
          .eq('id', id)
          .maybeSingle();
      if (response == null) return false;

      final loc = SacredLocation.fromJson(response);
      if (mounted) _cachedLocation = loc;

      final name = loc.name;
      final region = loc.region;

      _setContentData({
        'type': 'sacredSite',
        'title': name,
        'imageUrl': loc.image,
        'author': region ?? 'Sacred site',
        'scripture': null,
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  void _setContentData(Map<String, dynamic> data) {
    if (!mounted) return;
    setState(() {
      _contentData = data;
      _isLoading = false;
    });
  }

  void _setError(String message) {
    if (!mounted) return;
    setState(() {
      _error = message;
      _isLoading = false;
    });
  }

  String _formatPlanSubtitle({
    required String title,
    String? fromLocation,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final parts = <String>[];
    if (fromLocation != null && fromLocation.trim().isNotEmpty) {
      parts.add('From $fromLocation');
    }
    if (startDate != null && endDate != null) {
      final start = '${startDate.day}/${startDate.month}/${startDate.year}';
      final end = '${endDate.day}/${endDate.month}/${endDate.year}';
      parts.add('Plan from $start to $end');
    } else if (startDate != null) {
      final start = '${startDate.day}/${startDate.month}/${startDate.year}';
      parts.add('Starting $start');
    }
    if (parts.isEmpty) return title;
    return parts.join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_isLoading) {
      return Container(
        padding: EdgeInsets.all(12.w),
        margin: EdgeInsets.symmetric(vertical: 4.h),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: colorScheme.outlineVariant, width: 1),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 20.w,
              height: 20.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'Loading shared content...',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    if (_error != null || _contentData == null) {
      return Container(
        padding: EdgeInsets.all(12.w),
        margin: EdgeInsets.symmetric(vertical: 4.h),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: colorScheme.error.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: colorScheme.error, size: 20.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                _error ?? 'Content not available',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final isStory = _contentData!['type'] == 'story';
    final isTravelPlan = _contentData!['type'] == 'travelPlan';
    final isSacredSite = _contentData!['type'] == 'sacredSite';
    final title = _contentData!['title'] as String;
    final imageUrl = _contentData!['imageUrl'] as String?;
    final author = _contentData!['author'] as String;
    final scripture = _contentData!['scripture'] as String?;
    final fromLocation = _contentData!['fromLocation'];
    final startDate = _contentData!['startDate'] as DateTime?;
    final endDate = _contentData!['endDate'] as DateTime?;
    final postType = (_contentData!['postType'] as String?) ?? 'image';

    return GestureDetector(
      onTap: () async {
        if (isStory) {
          StoryDetailRoute(id: widget.sharedContentId).push(context);
        } else if (isTravelPlan && _cachedPlan != null) {
          SavedPlanDetailRoute($extra: _cachedPlan!).push(context);
        } else if (isSacredSite && _cachedLocation != null) {
          SiteDetailRoute($extra: _cachedLocation!).push(context);
        } else if (!isStory) {
          PostDetailRoute(
            postId: widget.sharedContentId,
            postType: postType,
          ).push(context);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image preview
            if (imageUrl != null && imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(11.r)),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  cacheManager: ImageCacheManager.instance,
                  height: 150.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const ImageLoadingPlaceholder(),
                  errorWidget: (context, url, error) => Container(
                    height: 150.h,
                    color: colorScheme.surfaceContainerHigh,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: colorScheme.onSurfaceVariant,
                      size: 48.sp,
                    ),
                  ),
                ),
              ),

            // Content info
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isStory
                            ? Icons.auto_stories
                            : isTravelPlan || isSacredSite
                            ? Icons.temple_hindu_rounded
                            : Icons.image,
                        size: 16.sp,
                        color: colorScheme.primary,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        isStory
                            ? 'Shared a story'
                            : isTravelPlan
                            ? 'Shared a travel plan'
                            : isSacredSite
                            ? 'Shared a sacred site'
                            : 'Shared a post',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  if (scripture != null) ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withValues(
                          alpha: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        scripture,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                  ],
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  if (isTravelPlan && (startDate != null || endDate != null))
                    Text(
                      _formatPlanSubtitle(
                        title: title,
                        fromLocation: fromLocation?.toString(),
                        startDate: startDate,
                        endDate: endDate,
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    )
                  else
                    Text(
                      'By $author',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.touch_app,
                        size: 14.sp,
                        color: colorScheme.primary,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Tap to view',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
