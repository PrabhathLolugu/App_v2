import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/presentation/widgets/app_snackbar.dart';
import 'package:myitihas/core/utils/app_error_mapper.dart';
import 'package:myitihas/core/utils/language_voice_resolver.dart';
import 'package:myitihas/core/widgets/image_loading_placeholder/image_loading_placeholder.dart';
import 'package:myitihas/core/widgets/voice_input/voice_input_button.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/services/post_service.dart';

/// Shows a bottom sheet dialog for sharing a story to the social feed
Future<void> showShareToFeedDialog({
  required BuildContext context,
  required Story story,
  required String selectedLanguage,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (bottomSheetContext) {
      return _ShareToFeedDialogContent(
        story: story,
        selectedLanguage: selectedLanguage,
      );
    },
  );
}

class _ShareToFeedDialogContent extends StatefulWidget {
  final Story story;
  final String selectedLanguage;

  const _ShareToFeedDialogContent({
    required this.story,
    required this.selectedLanguage,
  });

  @override
  State<_ShareToFeedDialogContent> createState() =>
      _ShareToFeedDialogContentState();
}

class _ShareToFeedDialogContentState extends State<_ShareToFeedDialogContent> {
  late final TextEditingController _captionController;
  bool _isSharing = false;

  String _resolvedTitle() {
    final langCode = LanguageVoiceResolver.languageCodeFromAny(
      widget.selectedLanguage,
    );
    return widget.story.attributes.translations[langCode]?.title ??
        widget.story.title;
  }

  String _resolvedLesson() {
    final langCode = LanguageVoiceResolver.languageCodeFromAny(
      widget.selectedLanguage,
    );
    return widget.story.attributes.translations[langCode]?.moral ??
        widget.story.lesson;
  }

  @override
  void initState() {
    super.initState();
    _captionController = TextEditingController();
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final t = Translations.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.homeScreen.shareStoryTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Story preview
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: colorScheme.tertiary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: widget.story.imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.network(
                              widget.story.imageUrl!,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return ImageLoadingPlaceholder(
                                      width: 60.w,
                                      height: 60.h,
                                      borderRadius: BorderRadius.circular(8.r),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                    Icons.auto_stories,
                                    color: colorScheme.tertiary,
                                  ),
                            ),
                          )
                        : Icon(Icons.auto_stories, color: colorScheme.tertiary),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _resolvedTitle(),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          widget.story.scripture,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Caption input
            Text(
              t.homeScreen.shareStoryMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _captionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: t.homeScreen.shareStoryHint,
                suffixIcon: VoiceInputButton(controller: _captionController),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // Share button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSharing ? null : _handleShare,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: _isSharing
                      ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.onPrimary,
                          ),
                        )
                      : Text(t.homeScreen.shareToFeed),
                ),
              ),
            ),

            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  Future<void> _handleShare() async {
    // Capture caption text before any async operations
    final caption = _captionController.text;

    setState(() => _isSharing = true);

    try {
      await _shareStoryToFeed(caption);
    } finally {
      // Only update state if still mounted
      if (mounted) {
        setState(() => _isSharing = false);
        Navigator.pop(context);
      }
    }
  }

  Future<void> _shareStoryToFeed(String caption) async {
    final t = Translations.of(context);
    final postService = getIt<PostService>();
    final resolvedTitle = _resolvedTitle();
    final resolvedLesson = _resolvedLesson();

    try {
      await postService.createPost(
        postType: PostType.storyShare,
        content: caption.isNotEmpty ? caption : resolvedLesson,
        title: resolvedTitle,
        sharedStoryId: widget.story.id,
        metadata: {
          'story_title': resolvedTitle,
          'story_scripture': widget.story.scripture,
          'story_image_url': widget.story.imageUrl,
          'story_lesson': resolvedLesson,
          'selected_language': widget.selectedLanguage,
        },
      );

      if (mounted) {
        AppSnackBar.showSuccess(context, t.homeScreen.sharedToFeed);
      }
    } catch (e) {
      if (mounted) {
        final friendly = AppErrorMapper.getUserMessage(
          e,
          fallbackMessage:
              'We couldn\'t share this story right now. Please try again.',
        );
        AppSnackBar.showError(context, friendly);
      }
    }
  }
}
