import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:myitihas/core/widgets/markdown/app_markdown.dart';
import 'package:myitihas/core/widgets/markdown/markdown_link_handler.dart';

/// A sanitized markdown widget for user-generated content.
///
/// This widget restricts markdown features to prevent abuse:
/// - ✅ Bold, italic, strikethrough
/// - ✅ Links (external and internal)
/// - ✅ Unordered and ordered lists
/// - ✅ Inline code
/// - ❌ Images (blocked)
/// - ❌ Raw HTML (blocked)
/// - ❌ Code blocks (blocked)
/// - ❌ Tables (blocked)
///
/// Use this for comments, posts, bios, and other user-generated content.
class SanitizedMarkdown extends StatelessWidget {
  /// The markdown content to render.
  final String data;

  /// Whether the text should be selectable.
  final bool selectable;

  /// Custom style sheet overrides.
  final MarkdownStyleSheet? styleSheetOverride;

  /// Optional callback when a link is tapped.
  final void Function(String text, String? href, String title)? onTapLink;

  /// Maximum number of lines to show (0 = unlimited).
  final int maxLines;

  /// Text overflow behavior when maxLines is set.
  final TextOverflow overflow;

  const SanitizedMarkdown({
    super.key,
    required this.data,
    this.selectable = true,
    this.styleSheetOverride,
    this.onTapLink,
    this.maxLines = 0,
    this.overflow = TextOverflow.ellipsis,
  });

  /// Sanitize the input markdown by removing blocked elements.
  String _sanitizeMarkdown(String input) {
    // First preprocess to handle escaped newlines
    String sanitized = preprocessMarkdown(input);

    // Remove images: ![alt](url) or ![alt]
    sanitized = sanitized.replaceAll(RegExp(r'!\[[^\]]*\]\([^)]*\)'), '');
    sanitized = sanitized.replaceAll(RegExp(r'!\[[^\]]*\]'), '');

    // Remove raw HTML tags
    sanitized = sanitized.replaceAll(RegExp(r'<[^>]+>'), '');

    // Remove code blocks (triple backticks)
    sanitized = sanitized.replaceAll(RegExp(r'```[\s\S]*?```'), '');

    // Remove tables (lines starting with |)
    sanitized = sanitized.replaceAll(RegExp(r'^\|.+\|$', multiLine: true), '');

    // Remove table separator lines
    sanitized = sanitized.replaceAll(
      RegExp(r'^\|[-:\s|]+\|$', multiLine: true),
      '',
    );

    // Remove horizontal rules
    sanitized = sanitized.replaceAll(
      RegExp(r'^[-*_]{3,}$', multiLine: true),
      '',
    );

    // Remove headings (we don't want users to create headings in comments)
    sanitized = sanitized.replaceAll(
      RegExp(r'^#{1,6}\s+', multiLine: true),
      '',
    );

    // Clean up multiple blank lines
    sanitized = sanitized.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    return sanitized.trim();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final sanitizedData = _sanitizeMarkdown(data);

    final baseStyleSheet = MarkdownStyleSheet.fromTheme(theme).copyWith(
      // Body text
      p: theme.textTheme.bodyMedium?.copyWith(
        height: 1.5,
        color: colorScheme.onSurface,
      ),

      // Strong and emphasis
      strong: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
      em: theme.textTheme.bodyMedium?.copyWith(
        fontStyle: FontStyle.italic,
        color: colorScheme.onSurface,
      ),

      // Inline code (allowed)
      code: TextStyle(
        fontFamily: 'monospace',
        fontSize: 13,
        backgroundColor: colorScheme.surfaceContainerHighest,
        color: colorScheme.onSurface,
      ),

      // Lists
      listBullet: theme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      listIndent: 16,

      // Links
      a: theme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.primary,
        decoration: TextDecoration.underline,
        decorationColor: colorScheme.primary,
      ),

      // Disable blockquotes styling (not fully blocked but discouraged)
      blockquote: theme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
        fontStyle: FontStyle.italic,
      ),
      blockquoteDecoration: const BoxDecoration(),
      blockquotePadding: EdgeInsets.zero,

      // Remove code block styling since we strip them
      codeblockDecoration: const BoxDecoration(),
      codeblockPadding: EdgeInsets.zero,
    );

    final effectiveStyleSheet = styleSheetOverride != null
        ? baseStyleSheet.merge(styleSheetOverride!)
        : baseStyleSheet;

    // Use a restricted extension set (no tables, no autolinks for images)
    final extensionSet = md.ExtensionSet(
      [], // No block syntaxes (removes tables, etc.)
      [
        md.EmojiSyntax(),
        md.StrikethroughSyntax(),
        md.AutolinkSyntax(),
        md.AutolinkExtensionSyntax(),
      ],
    );

    final markdownBody = MarkdownBody(
      data: sanitizedData,
      selectable: selectable,
      extensionSet: extensionSet,
      styleSheet: effectiveStyleSheet,
      shrinkWrap: true,
      onTapLink:
          onTapLink ??
          (text, href, title) =>
              MarkdownLinkHandler.handleLinkTap(context, text, href, title),
    );

    // Wrap in ClipRect to prevent overflow errors when placed in constrained containers
    return ClipRect(child: markdownBody);
  }
}

/// A compact sanitized markdown for inline usage (like comment text).
///
/// This removes even more features and is suitable for single-line or
/// short multi-line text like comments.
class CompactSanitizedMarkdown extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow overflow;

  const CompactSanitizedMarkdown({
    super.key,
    required this.data,
    this.style,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    // For very compact usage, use the full SanitizedMarkdown
    // with appropriate styling
    return SanitizedMarkdown(
      data: data,
      selectable: false,
      styleSheetOverride: style != null
          ? MarkdownStyleSheet(
              p: style,
              strong: style?.copyWith(fontWeight: FontWeight.bold),
              em: style?.copyWith(fontStyle: FontStyle.italic),
            )
          : null,
    );
  }
}
