import 'package:flutter/material.dart';
import 'package:myitihas/i18n/strings.g.dart';

enum PostOverflowAction { save, repost, report, edit, delete }

enum RepostAction { repostNow, repostWithThoughts }

class PostReportSelection {
  final String reason;
  final String? details;

  const PostReportSelection({required this.reason, this.details});
}

Future<PostOverflowAction?> showPostOverflowActionsSheet({
  required BuildContext context,
  required bool isOwnPost,
  required bool isSaved,
}) {
  final t = Translations.of(context);
  final colorScheme = Theme.of(context).colorScheme;
  return showModalBottomSheet<PostOverflowAction>(
    context: context,
    backgroundColor: colorScheme.surface,
    showDragHandle: true,
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isOwnPost) ...[
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: Text(t.social.editCaption),
                onTap: () => Navigator.of(sheetContext).pop(PostOverflowAction.edit),
              ),
              ListTile(
                leading: Icon(Icons.delete_outline, color: colorScheme.error),
                title: Text(
                  t.social.deletePost,
                  style: TextStyle(color: colorScheme.error),
                ),
                onTap: () =>
                    Navigator.of(sheetContext).pop(PostOverflowAction.delete),
              ),
            ] else ...[
              ListTile(
                leading: Icon(
                  isSaved ? Icons.bookmark_remove_outlined : Icons.bookmark_add_outlined,
                ),
                title: Text(isSaved ? t.feed.removedFromBookmarks : t.common.save),
                onTap: () => Navigator.of(sheetContext).pop(PostOverflowAction.save),
              ),
              ListTile(
                leading: const Icon(Icons.repeat_rounded),
                title: Text(t.social.repost),
                onTap: () =>
                    Navigator.of(sheetContext).pop(PostOverflowAction.repost),
              ),
              ListTile(
                leading: const Icon(Icons.flag_outlined),
                title: Text(t.social.reportPost),
                onTap: () => Navigator.of(sheetContext).pop(PostOverflowAction.report),
              ),
            ],
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}

Future<RepostAction?> showRepostActionSheet(BuildContext context) {
  final t = Translations.of(context);
  final colorScheme = Theme.of(context).colorScheme;
  return showModalBottomSheet<RepostAction>(
    context: context,
    backgroundColor: colorScheme.surface,
    showDragHandle: true,
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.repeat_rounded),
              title: Text(t.social.repostNow),
              subtitle: Text(t.social.repostNowSubtitle),
              onTap: () => Navigator.of(sheetContext).pop(RepostAction.repostNow),
            ),
            ListTile(
              leading: const Icon(Icons.edit_note_rounded),
              title: Text(t.social.repostWithThoughts),
              subtitle: Text(t.social.repostWithThoughtsSubtitle),
              onTap: () =>
                  Navigator.of(sheetContext).pop(RepostAction.repostWithThoughts),
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}

Future<String?> showRepostQuoteDialog(BuildContext context) async {
  final t = Translations.of(context);
  final controller = TextEditingController();
  final result = await showDialog<String>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(t.social.repostWithThoughts),
        content: TextField(
          controller: controller,
          minLines: 3,
          maxLines: 5,
          maxLength: 500,
          autofocus: true,
          decoration: InputDecoration(
            hintText: t.social.repostThoughtsHint,
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(Translations.of(context).common.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(controller.text.trim()),
            child: Text(t.social.repost),
          ),
        ],
      );
    },
  );
  controller.dispose();
  return result;
}

Future<PostReportSelection?> showPostReportReasonSheet(BuildContext context) async {
  final t = Translations.of(context);
  final reasons = <String>[
    t.social.reportReasonSpam,
    t.social.reportReasonHarassment,
    t.social.reportReasonHateSpeech,
    t.social.reportReasonViolence,
    t.social.reportReasonFalseInfo,
    t.social.reportReasonNotRelevant,
    t.social.reportReasonOther,
  ];
  final selectedReason = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      return SafeArea(
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: reasons.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (_, index) {
            final reason = reasons[index];
            return ListTile(
              title: Text(reason),
              onTap: () => Navigator.of(sheetContext).pop(reason),
            );
          },
        ),
      );
    },
  );

  if (selectedReason == null) return null;
  if (selectedReason != t.social.reportReasonOther) {
    return PostReportSelection(reason: selectedReason);
  }

  final details = await _showOtherReportDetailsDialog(context);
  if (details == null) return null;
  return PostReportSelection(reason: selectedReason, details: details);
}

Future<String?> _showOtherReportDetailsDialog(BuildContext context) async {
  final controller = TextEditingController();
  bool showError = false;

  final result = await showDialog<String>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (dialogInnerContext, setDialogState) => AlertDialog(
        title: Text(Translations.of(context).social.reportPost),
        content: TextField(
          controller: controller,
          autofocus: true,
          minLines: 3,
          maxLines: 5,
          maxLength: 500,
          onChanged: (value) {
            setDialogState(() {
              if (showError && value.trim().isNotEmpty) {
                showError = false;
              }
            });
          },
          decoration: InputDecoration(
            hintText: Translations.of(context).social.reportReasonHint,
            border: const OutlineInputBorder(),
            errorText: showError ? Translations.of(context).social.reportDetailsRequired : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(Translations.of(context).common.cancel),
          ),
          TextButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isEmpty) {
                setDialogState(() => showError = true);
                return;
              }
              Navigator.of(dialogContext).pop(text);
            },
            child: Text(Translations.of(context).chat.submit),
          ),
        ],
      ),
    ),
  );
  controller.dispose();
  return result;
}
