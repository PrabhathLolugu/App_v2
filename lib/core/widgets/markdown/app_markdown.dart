import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:myitihas/core/widgets/markdown/markdown_link_handler.dart';

/// Preprocesses markdown content to handle common issues:
/// - Converts escaped newlines (\n, \\n) to actual newlines
/// - Normalizes line endings
/// - Trims excess whitespace
String preprocessMarkdown(String data) {
  if (data.isEmpty) return data;

  String processed = data;

  // Handle multiple levels of escaping that can occur from JSON/database storage
  // First pass: handle double-escaped backslashes followed by n (\\n -> \n)
  while (processed.contains('\\\\n')) {
    processed = processed.replaceAll('\\\\n', '\\n');
  }

  processed = processed.replaceAll('\\r\\n', '\n');
  processed = processed.replaceAll('\\n', '\n');
  processed = processed.replaceAll('\\r', '\n');

  // Normalize carriage returns
  processed = processed.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

  // Normalize multiple newlines
  processed = processed.replaceAll(RegExp(r'\n{3,}'), '\n\n');

  // Normalize escaped asterisks while preserving valid markdown emphasis.
  processed = processed.replaceAll(r'\*', '*');

  return processed.trim();
}

/// Base markdown widget with app theming and standard configurations.
///
/// Provides:
/// - Theme-based styling with custom blockquote styling
/// - GitHub Flavored Markdown + emoji syntax
/// - Smart link handling (internal via GoRouter, external via url_launcher)
/// - Selectable text support
/// - Plain monospace code blocks
class AppMarkdown extends StatelessWidget {
  /// The markdown content to render.
  final String data;

  /// Whether the text should be selectable.
  final bool selectable;

  /// Whether to shrink wrap the content (use for non-scrolling contexts).
  final bool shrinkWrap;

  /// Custom style sheet overrides.
  final MarkdownStyleSheet? styleSheetOverride;

  /// Optional scroll controller for the markdown content.
  final ScrollController? controller;

  /// Custom element builders.
  final Map<String, MarkdownElementBuilder>? builders;

  /// Optional callback when a link is tapped (overrides default behavior).
  final void Function(String text, String? href, String title)? onTapLink;

  /// Physics for the scroll view.
  final ScrollPhysics? physics;

  const AppMarkdown({
    super.key,
    required this.data,
    this.selectable = true,
    this.shrinkWrap = false,
    this.styleSheetOverride,
    this.controller,
    this.builders,
    this.onTapLink,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final baseStyleSheet = MarkdownStyleSheet.fromTheme(theme).copyWith(
      // Headings
      h1: theme.textTheme.headlineLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
      h2: theme.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      h3: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      h4: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      h5: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      h6: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),

      // Body text
      p: theme.textTheme.bodyMedium?.copyWith(
        height: 1.6,
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

      // Blockquotes - styled for scripture quotes
      blockquote: theme.textTheme.bodyMedium?.copyWith(
        fontStyle: FontStyle.italic,
        color: colorScheme.onSurfaceVariant,
        height: 1.5,
      ),
      blockquoteDecoration: BoxDecoration(
        color: isDark
            ? colorScheme.primaryContainer.withValues(alpha: 0.15)
            : colorScheme.primaryContainer.withValues(alpha: 0.3),
        border: Border(left: BorderSide(color: colorScheme.primary, width: 4)),
      ),
      blockquotePadding: const EdgeInsets.fromLTRB(16, 12, 12, 12),

      // Code - plain monospace
      code: TextStyle(
        fontFamily: 'monospace',
        fontSize: 14,
        backgroundColor: isDark
            ? colorScheme.surfaceContainerHighest
            : Colors.grey[200],
        color: colorScheme.onSurface,
      ),
      codeblockDecoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainerHighest : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      codeblockPadding: const EdgeInsets.all(12),

      // Lists
      listBullet: theme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.primary,
      ),
      listIndent: 20,

      // Tables
      tableBorder: TableBorder.all(
        color: colorScheme.outlineVariant,
        width: 1,
        borderRadius: BorderRadius.circular(4),
      ),
      tableCellsPadding: const EdgeInsets.all(8),
      tableHead: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),

      // Horizontal rule
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant, width: 1),
        ),
      ),

      // Links
      a: theme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.primary,
        decoration: TextDecoration.underline,
        decorationColor: colorScheme.primary,
      ),
    );

    // Merge with any overrides
    final effectiveStyleSheet = styleSheetOverride != null
        ? baseStyleSheet.merge(styleSheetOverride!)
        : baseStyleSheet;

    // Extension set with GitHub Flavored Markdown + Emoji
    final extensionSet = md.ExtensionSet(
      md.ExtensionSet.gitHubFlavored.blockSyntaxes,
      [md.EmojiSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
    );

    // Preprocess the markdown content
    final processedData = preprocessMarkdown(data);

    if (shrinkWrap) {
      return MarkdownBody(
        data: processedData,
        selectable: selectable,
        extensionSet: extensionSet,
        styleSheet: effectiveStyleSheet,
        builders: builders ?? const {},
        onTapLink:
            onTapLink ??
            (text, href, title) =>
                MarkdownLinkHandler.handleLinkTap(context, text, href, title),
      );
    }

    return Markdown(
      data: processedData,
      selectable: selectable,
      controller: controller,
      physics: physics,
      extensionSet: extensionSet,
      styleSheet: effectiveStyleSheet,
      builders: builders ?? const {},
      onTapLink:
          onTapLink ??
          (text, href, title) =>
              MarkdownLinkHandler.handleLinkTap(context, text, href, title),
    );
  }
}

/// Non-scrollable markdown body for embedding in other scrollable widgets.
///
/// This is a convenience wrapper around [AppMarkdown] with [shrinkWrap] = true.
class AppMarkdownBody extends StatelessWidget {
  final String data;
  final bool selectable;
  final MarkdownStyleSheet? styleSheetOverride;
  final Map<String, MarkdownElementBuilder>? builders;
  final void Function(String text, String? href, String title)? onTapLink;

  const AppMarkdownBody({
    super.key,
    required this.data,
    this.selectable = true,
    this.styleSheetOverride,
    this.builders,
    this.onTapLink,
  });

  @override
  Widget build(BuildContext context) {
    return AppMarkdown(
      data: data,
      selectable: selectable,
      shrinkWrap: true,
      styleSheetOverride: styleSheetOverride,
      builders: builders,
      onTapLink: onTapLink,
    );
  }
}
