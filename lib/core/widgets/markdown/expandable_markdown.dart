import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:myitihas/core/widgets/markdown/app_markdown.dart';
import 'package:myitihas/core/widgets/markdown/drop_cap_builder.dart';

/// An expandable markdown widget with truncation and read more/less toggle.
///
/// Features:
/// - Truncates markdown content at word boundaries
/// - Shows "read more" / "read less" toggle button
/// - Optional drop cap support for first paragraph
/// - Smooth expand/collapse animation
class ExpandableMarkdown extends StatefulWidget {
  /// The markdown content to render.
  final String data;

  /// Maximum number of characters to show when collapsed.
  /// Truncation happens at word boundaries.
  final int maxCollapsedLength;

  /// Whether to show drop cap on the first paragraph.
  final bool showDropCap;

  /// Text to show for the "read more" button.
  final String readMoreText;

  /// Text to show for the "read less" button.
  final String readLessText;

  /// Style for the toggle button text.
  final TextStyle? toggleButtonStyle;

  /// Whether the text should be selectable.
  final bool selectable;

  /// Custom style sheet overrides.
  final MarkdownStyleSheet? styleSheetOverride;

  /// Optional callback when a link is tapped.
  final void Function(String text, String? href, String title)? onTapLink;

  /// Whether to start expanded.
  final bool initiallyExpanded;

  const ExpandableMarkdown({
    super.key,
    required this.data,
    this.maxCollapsedLength = 300,
    this.showDropCap = false,
    this.readMoreText = 'read more',
    this.readLessText = 'read less',
    this.toggleButtonStyle,
    this.selectable = true,
    this.styleSheetOverride,
    this.onTapLink,
    this.initiallyExpanded = false,
  });

  @override
  State<ExpandableMarkdown> createState() => _ExpandableMarkdownState();
}

class _ExpandableMarkdownState extends State<ExpandableMarkdown>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late String _processedData;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _processedData = preprocessMarkdown(widget.data);
  }

  @override
  void didUpdateWidget(ExpandableMarkdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _processedData = preprocessMarkdown(widget.data);
    }
  }

  /// Truncate the markdown at a word boundary, preserving markdown syntax.
  String _truncateAtWordBoundary(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }

    // Find the last space before maxLength
    int truncateIndex = maxLength;
    while (truncateIndex > 0 && text[truncateIndex] != ' ') {
      truncateIndex--;
    }

    // If no space found, just truncate at maxLength
    if (truncateIndex == 0) {
      truncateIndex = maxLength;
    }

    String truncated = text.substring(0, truncateIndex).trimRight();

    // Clean up any incomplete markdown syntax at the end
    truncated = _cleanupIncompleteMarkdown(truncated);

    return '$truncated...';
  }

  /// Clean up incomplete markdown syntax at the end of truncated text.
  String _cleanupIncompleteMarkdown(String text) {
    // Remove trailing incomplete bold/italic markers
    text = text.replaceAll(RegExp(r'\*+$'), '');
    text = text.replaceAll(RegExp(r'_+$'), '');

    // Remove trailing incomplete links
    text = text.replaceAll(RegExp(r'\[([^\]]*?)$'), '');
    text = text.replaceAll(RegExp(r'\]\([^)]*?$'), '');

    // Balance unclosed bold/italic pairs
    final singleAsterisks = '*'.allMatches(text).length;
    final doubleAsterisks = '**'.allMatches(text).length * 2;
    final unpairedAsterisks = singleAsterisks - doubleAsterisks;
    if (unpairedAsterisks.isOdd) {
      text = '$text*';
    }

    final singleUnderscores = '_'.allMatches(text).length;
    final doubleUnderscores = '__'.allMatches(text).length * 2;
    final unpairedUnderscores = singleUnderscores - doubleUnderscores;
    if (unpairedUnderscores.isOdd) {
      text = '${text}_';
    }

    return text.trimRight();
  }

  bool get _needsTruncation =>
      _processedData.length > widget.maxCollapsedLength;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final displayText = _isExpanded || !_needsTruncation
        ? _processedData
        : _truncateAtWordBoundary(_processedData, widget.maxCollapsedLength);

    final effectiveToggleStyle =
        widget.toggleButtonStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: Alignment.topLeft,
          child: AppMarkdownBody(
            data: displayText,
            selectable: widget.selectable,
            styleSheetOverride: widget.styleSheetOverride,
            builders: widget.showDropCap
                ? createDropCapBuilders(context)
                : null,
            onTapLink: widget.onTapLink,
          ),
        ),
        if (_needsTruncation)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Text(
                _isExpanded ? widget.readLessText : widget.readMoreText,
                style: effectiveToggleStyle,
              ),
            ),
          ),
      ],
    );
  }
}

/// A simpler expandable markdown that uses line-based truncation.
///
/// This shows a maximum number of lines and fades out,
/// similar to the existing SwipeableContentSection behavior.
class FadingMarkdown extends StatelessWidget {
  final String data;
  final int maxLines;
  final bool darkOverlay;
  final bool selectable;
  final MarkdownStyleSheet? styleSheetOverride;

  const FadingMarkdown({
    super.key,
    required this.data,
    this.maxLines = 6,
    this.darkOverlay = false,
    this.selectable = false,
    this.styleSheetOverride,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.white, Colors.transparent],
          stops: const [0.0, 0.7, 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: maxLines * 20.0, // Approximate line height
        ),
        child: AppMarkdownBody(
          data: data,
          selectable: selectable,
          styleSheetOverride: styleSheetOverride,
        ),
      ),
    );
  }
}
