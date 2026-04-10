import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;

/// Custom MarkdownElementBuilder that renders the first paragraph with a drop cap.
///
/// The first letter of the first paragraph is rendered with a larger font size
/// and primary color, similar to traditional book typography.
class DropCapBuilder extends MarkdownElementBuilder {
  final TextStyle? baseStyle;
  final TextStyle? dropCapStyle;
  final bool isFirstParagraph;

  /// Track whether we've already rendered the drop cap
  static bool _hasRenderedDropCap = false;

  DropCapBuilder({
    this.baseStyle,
    this.dropCapStyle,
    this.isFirstParagraph = true,
  });

  /// Reset the drop cap state (call this when building a new markdown widget)
  static void reset() {
    _hasRenderedDropCap = false;
  }

  @override
  Widget visitText(md.Text text, TextStyle? preferredStyle) {
    final content = text.textContent;
    if (content.isEmpty) {
      return const SizedBox.shrink();
    }

    // If we haven't rendered the drop cap yet and this is content
    if (!_hasRenderedDropCap && content.isNotEmpty) {
      _hasRenderedDropCap = true;
      return _buildDropCapText(content, preferredStyle);
    }

    return Text(content, style: preferredStyle ?? baseStyle);
  }

  Widget _buildDropCapText(String content, TextStyle? preferredStyle) {
    if (content.isEmpty) {
      return const SizedBox.shrink();
    }

    final firstChar = content[0];
    final remainingText = content.length > 1 ? content.substring(1) : '';

    final effectiveBaseStyle = preferredStyle ?? baseStyle ?? const TextStyle();

    final effectiveDropCapStyle =
        dropCapStyle ??
        effectiveBaseStyle.copyWith(
          fontSize: (effectiveBaseStyle.fontSize ?? 14) * 2.5,
          fontWeight: FontWeight.bold,
          height: 1.0,
        );

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: firstChar, style: effectiveDropCapStyle),
          TextSpan(text: remainingText, style: effectiveBaseStyle),
        ],
      ),
    );
  }
}

/// A wrapper widget that creates a DropCapBuilder with proper theming.
///
/// Use this in the `builders` map of AppMarkdown:
/// ```dart
/// AppMarkdown(
///   data: storyContent,
///   builders: {
///     'p': DropCapParagraphBuilder(context),
///   },
/// )
/// ```
class DropCapParagraphBuilder extends MarkdownElementBuilder {
  final BuildContext context;
  bool _isFirstParagraph = true;

  DropCapParagraphBuilder(this.context);

  @override
  Widget visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final content = element.textContent;
    if (content.isEmpty) {
      return const SizedBox.shrink();
    }

    // Consistent base style for all paragraphs
    final baseStyle =
        preferredStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          height: 1.6,
          color: colorScheme.onSurface,
        ) ??
        TextStyle(fontSize: 14, height: 1.6, color: colorScheme.onSurface);

    // Only apply drop cap to the first paragraph
    if (_isFirstParagraph && content.isNotEmpty) {
      _isFirstParagraph = false;

      final firstChar = content[0];
      final remainingText = content.length > 1 ? content.substring(1) : '';

      final dropCapStyle = baseStyle.copyWith(
        fontSize: (baseStyle.fontSize ?? 14) * 2.5,
        fontWeight: FontWeight.bold,
        color: colorScheme.primary,
        height: 1.0,
      );

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: firstChar, style: dropCapStyle),
              TextSpan(text: remainingText, style: baseStyle),
            ],
          ),
          textAlign: TextAlign.justify,
        ),
      );
    }

    // Regular paragraph - same styling as first paragraph (minus drop cap)
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(content, style: baseStyle, textAlign: TextAlign.justify),
    );
  }
}

/// Creates a DropCapParagraphBuilder for use in markdown builders map.
///
/// Example usage:
/// ```dart
/// AppMarkdown(
///   data: storyContent,
///   builders: createDropCapBuilders(context),
/// )
/// ```
Map<String, MarkdownElementBuilder> createDropCapBuilders(
  BuildContext context,
) {
  return {'p': DropCapParagraphBuilder(context)};
}

/// Paragraph builder that renders all paragraphs with [TextAlign.justify],
/// without a drop cap. Use for Trivia and Moral sections to match story body.
class JustifiedParagraphBuilder extends MarkdownElementBuilder {
  final BuildContext context;

  JustifiedParagraphBuilder(this.context);

  @override
  Widget visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final content = element.textContent;
    if (content.isEmpty) {
      return const SizedBox.shrink();
    }

    final baseStyle =
        preferredStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          height: 1.6,
          color: colorScheme.onSurface,
        ) ??
        TextStyle(fontSize: 14, height: 1.6, color: colorScheme.onSurface);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(content, style: baseStyle, textAlign: TextAlign.justify),
    );
  }
}

/// Creates builders that render paragraphs justified (no drop cap).
/// Use with [AppMarkdownBody] for Trivia and Moral sections.
Map<String, MarkdownElementBuilder> createJustifiedBuilders(
  BuildContext context,
) {
  return {'p': JustifiedParagraphBuilder(context)};
}
