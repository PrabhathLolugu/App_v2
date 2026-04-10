import 'package:flutter/material.dart';
import 'package:myitihas/features/social/domain/utils/post_caption_metadata.dart';

/// Hashtags: `#` followed by non-space, non-`#` run (supports letters/numbers/_ and Indic scripts).
final RegExp kHashtagPattern = kPostHashtagPattern;

/// Word-boundary truncation (same idea as [ExpandableMarkdown]).
String truncatePlainTextAtWordBoundary(String text, int maxLength) {
  if (text.length <= maxLength) return text;
  var truncateIndex = maxLength;
  while (truncateIndex > 0 && text[truncateIndex] != ' ') {
    truncateIndex--;
  }
  if (truncateIndex == 0) truncateIndex = maxLength;
  return '${text.substring(0, truncateIndex).trimRight()}...';
}

List<InlineSpan> buildHashtagSpans({
  required String text,
  required TextStyle baseStyle,
  required TextStyle hashtagStyle,
}) {
  final spans = <InlineSpan>[];
  var start = 0;
  for (final m in kHashtagPattern.allMatches(text)) {
    if (m.start > start) {
      spans.add(
        TextSpan(text: text.substring(start, m.start), style: baseStyle),
      );
    }
    spans.add(TextSpan(text: m.group(0), style: hashtagStyle));
    start = m.end;
  }
  if (start < text.length) {
    spans.add(TextSpan(text: text.substring(start), style: baseStyle));
  }
  if (spans.isEmpty) {
    spans.add(TextSpan(text: text, style: baseStyle));
  }
  return spans;
}

/// Plain text with `#hashtags` in [hashtagStyle]; optional read more / less.
class ExpandableHashtagText extends StatefulWidget {
  final String data;
  final int maxCollapsedLength;
  final TextStyle? baseStyle;
  final TextStyle? hashtagStyle;
  final TextStyle? toggleStyle;
  final String readMoreText;
  final String readLessText;
  final bool selectable;
  final TextAlign textAlign;

  const ExpandableHashtagText({
    super.key,
    required this.data,
    this.maxCollapsedLength = 300,
    this.baseStyle,
    this.hashtagStyle,
    this.toggleStyle,
    this.readMoreText = 'read more',
    this.readLessText = 'read less',
    this.selectable = true,
    this.textAlign = TextAlign.start,
  });

  @override
  State<ExpandableHashtagText> createState() => _ExpandableHashtagTextState();
}

class _ExpandableHashtagTextState extends State<ExpandableHashtagText> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = false;
  }

  @override
  void didUpdateWidget(ExpandableHashtagText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _expanded = false;
    }
  }

  bool get _needsTruncation => widget.data.length > widget.maxCollapsedLength;

  String get _displaySource {
    if (_expanded || !_needsTruncation) return widget.data;
    return truncatePlainTextAtWordBoundary(
      widget.data,
      widget.maxCollapsedLength,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final base =
        widget.baseStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
          height: 1.5,
        ) ??
        TextStyle(color: colorScheme.onSurface, height: 1.5);
    final tagStyle =
        widget.hashtagStyle ??
        base.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w500);
    final toggle =
        widget.toggleStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        );

    final spans = buildHashtagSpans(
      text: _displaySource,
      baseStyle: base,
      hashtagStyle: tagStyle,
    );

    final rich = TextSpan(children: spans);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: Alignment.topLeft,
          child: widget.selectable
              ? SelectableText.rich(rich, textAlign: widget.textAlign)
              : Text.rich(rich, textAlign: widget.textAlign),
        ),
        if (_needsTruncation)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Text(
                _expanded ? widget.readLessText : widget.readMoreText,
                style: toggle,
              ),
            ),
          ),
      ],
    );
  }
}

/// Inline caption: prefix (e.g. bold name) + space + expandable hashtag body.
class ExpandableHashtagCaptionRow extends StatefulWidget {
  final String prefix;
  final TextStyle prefixStyle;
  final String caption;
  final int maxCollapsedLength;
  final TextStyle bodyStyle;
  final TextStyle hashtagStyle;
  final TextStyle? toggleStyle;
  final String readMoreText;
  final String readLessText;

  const ExpandableHashtagCaptionRow({
    super.key,
    required this.prefix,
    required this.prefixStyle,
    required this.caption,
    this.maxCollapsedLength = 150,
    required this.bodyStyle,
    required this.hashtagStyle,
    this.toggleStyle,
    this.readMoreText = 'read more',
    this.readLessText = 'read less',
  });

  @override
  State<ExpandableHashtagCaptionRow> createState() =>
      _ExpandableHashtagCaptionRowState();
}

class _ExpandableHashtagCaptionRowState
    extends State<ExpandableHashtagCaptionRow> {
  bool _expanded = false;

  @override
  void didUpdateWidget(ExpandableHashtagCaptionRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.caption != widget.caption) {
      _expanded = false;
    }
  }

  bool get _needsTruncation =>
      widget.caption.length > widget.maxCollapsedLength;

  String get _bodySource {
    if (_expanded || !_needsTruncation) return widget.caption;
    return truncatePlainTextAtWordBoundary(
      widget.caption,
      widget.maxCollapsedLength,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final toggle =
        widget.toggleStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        );

    final bodySpans = buildHashtagSpans(
      text: _bodySource,
      baseStyle: widget.bodyStyle,
      hashtagStyle: widget.hashtagStyle,
    );

    final fullSpan = TextSpan(
      children: [
        TextSpan(text: widget.prefix, style: widget.prefixStyle),
        const TextSpan(text: ' '),
        ...bodySpans,
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SelectableText.rich(fullSpan),
        if (_needsTruncation)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => setState(() => _expanded = !_expanded),
              child: Text(
                _expanded ? widget.readLessText : widget.readMoreText,
                style: toggle,
              ),
            ),
          ),
      ],
    );
  }
}
