import 'package:flutter/material.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/features/social/domain/entities/content_type.dart';
import 'package:myitihas/features/social/domain/entities/feed_item.dart';
import 'package:myitihas/features/social/domain/repositories/post_repository.dart';

Future<String?> showEditCaptionSheet({
  required BuildContext context,
  required FeedItem feedItem,
}) async {
  // Only support image, text and video posts
  if (feedItem.contentType == ContentType.story) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Editing is not supported for this content.',
        ),
      ),
    );
    return null;
  }

  final initialText = feedItem.when(
    story: (_) => '',
    imagePost: (post) => post.caption ?? '',
    textPost: (post) => post.body,
    videoPost: (post) => post.caption ?? '',
  );

  final controller = TextEditingController(text: initialText);
  String? errorText;
  bool isSaving = false;

  final result = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      final theme = Theme.of(sheetContext);
      final colorScheme = theme.colorScheme;

      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 8,
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 16,
        ),
        child: StatefulBuilder(
          builder: (ctx, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit caption',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(sheetContext).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller,
                  maxLines: 5,
                  minLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Update the caption for your post',
                    border: const OutlineInputBorder(),
                    errorText: errorText,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: isSaving
                          ? null
                          : () => Navigator.of(sheetContext).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: isSaving
                          ? null
                          : () async {
                              final text = controller.text.trim();
                              if (text.isEmpty) {
                                setState(
                                  () =>
                                      errorText = 'Caption cannot be empty',
                                );
                                return;
                              }

                              setState(() {
                                isSaving = true;
                                errorText = null;
                              });

                              final repo = getIt<PostRepository>();
                              final result = await repo.updatePostContent(
                                postId: feedItem.id,
                                content: text,
                              );

                              if (!sheetContext.mounted) return;

                              result.fold(
                                (failure) {
                                  setState(() {
                                    isSaving = false;
                                    errorText = failure.message;
                                  });
                                },
                                (_) {
                                  Navigator.of(sheetContext).pop(text);
                                },
                              );
                            },
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                      ),
                      child: isSaving
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.onPrimary,
                              ),
                            )
                          : const Text('Save'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );
    },
  );

  controller.dispose();
  return result;
}

