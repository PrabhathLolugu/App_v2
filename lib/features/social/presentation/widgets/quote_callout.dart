import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:share_plus/share_plus.dart';

class QuoteCallout extends StatelessWidget {
  final String quote;
  final String? attribution;
  final int maxLines;
  final bool darkOverlay;

  const QuoteCallout({
    super.key,
    required this.quote,
    this.attribution,
    this.maxLines = 3,
    this.darkOverlay = false,
  });

  void _showFullQuote(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SafeArea(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Color(0xFF1E293B)
                : Color(0xFFF1F5F9),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).brightness == Brightness.dark
                    ? Color(0xFF1E293B)
                    : Color(0xFFF1F5F9),
              ],
              transform: GradientRotation(3.14 / 1.5),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Theme.of(context).primaryColor.withAlpha(5),
                      Theme.of(context).brightness == Brightness.dark
                          ? Color(0xFF1E293B)
                          : Color(0xFFF1F5F9),
                    ],
                    transform: GradientRotation(3.14 / 1.5),
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  children: [
                    Icon(Icons.format_quote_rounded, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      t.feed.quote,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quote with decorative marks
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border(
                            left: BorderSide(
                              color: colorScheme.primary.withValues(alpha: 0.5),
                              width: 4,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '"',
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    height: 0.8,
                                    color: colorScheme.primary.withValues(alpha: 0.5),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    quote,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontStyle: FontStyle.italic,
                                      height: 1.6,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (attribution != null &&
                                attribution!.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '— $attribution',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Action buttons
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.3,
                  ),
                  border: Border(
                    top: BorderSide(
                      color: colorScheme.outlineVariant,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          final quoteText =
                              attribution != null && attribution!.isNotEmpty
                              ? '"$quote"\n\n— $attribution'
                              : '"$quote"';
                          Clipboard.setData(ClipboardData(text: quoteText));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(t.feed.quoteCopied),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.copy, size: 18),
                        label: Text(t.feed.copy),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          final quoteText =
                              attribution != null && attribution!.isNotEmpty
                              ? '"$quote"\n\n— $attribution'
                              : '"$quote"';
                          SharePlus.instance.share(
                            ShareParams(
                              subject: t.feed.quoteFromMyitihas,
                              text: quoteText,
                            ),
                          );
                        },
                        icon: const Icon(Icons.share, size: 18),
                        label: Text(t.common.share),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: colorScheme.primary,
                        ),
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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradients = theme.extension<GradientExtension>();
    final colorScheme = theme.colorScheme;

    final bgColor = darkOverlay
        ? Colors.white.withValues(alpha: 0.1)
        : (gradients?.glassBackground ??
              colorScheme.surfaceContainerHighest.withValues(alpha: 0.8));
    final textColor = darkOverlay ? Colors.white : colorScheme.onSurface;
    final mutedColor = darkOverlay
        ? Colors.white70
        : colorScheme.onSurfaceVariant;

    return Semantics(
      label: 'Quote: $quote${attribution != null ? ', from $attribution' : ''}',
      button: true,
      hint: 'Tap to view full quote',
      child: InkWell(
        onTap: () => _showFullQuote(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(
                color: darkOverlay ? Colors.white70 : colorScheme.primary,
                width: 3,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExcludeSemantics(
                    child: Text(
                      '"',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        height: 0.8,
                        color: darkOverlay
                            ? Colors.white70
                            : colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      quote,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: textColor.withValues(alpha: 0.9),
                        height: 1.4,
                      ),
                      maxLines: maxLines,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (attribution != null && attribution!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '— $attribution',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: mutedColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
