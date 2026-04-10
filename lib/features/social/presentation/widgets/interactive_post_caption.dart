import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:myitihas/features/social/domain/entities/post_mention.dart';
import 'package:myitihas/features/social/domain/utils/post_caption_metadata.dart';
import 'package:myitihas/features/social/presentation/widgets/expandable_hashtag_text.dart';

/// Caption with tappable `#hashtags` and `@mentions` (mentions require [mentions] from post metadata).
class InteractivePostCaption extends StatefulWidget {
  const InteractivePostCaption({
    super.key,
    required this.data,
    this.maxCollapsedLength = 300,
    this.baseStyle,
    this.hashtagStyle,
    this.mentionStyle,
    this.readMoreText = 'read more',
    this.readLessText = 'read less',
    this.toggleStyle,
    this.textAlign = TextAlign.start,
    this.mentions = const [],
    this.onHashtagTap,
    this.onMentionTap,
  });

  final String data;
  final int maxCollapsedLength;
  final TextStyle? baseStyle;
  final TextStyle? hashtagStyle;
  final TextStyle? mentionStyle;
  final String readMoreText;
  final String readLessText;
  final TextStyle? toggleStyle;
  final TextAlign textAlign;
  final List<PostMention> mentions;
  final void Function(String normalizedTagWithoutHash)? onHashtagTap;
  final void Function(String userId)? onMentionTap;

  @override
  State<InteractivePostCaption> createState() => _InteractivePostCaptionState();
}

class _MatchSeg {
  _MatchSeg({
    required this.start,
    required this.end,
    required this.isHashtag,
    required this.raw,
  });

  final int start;
  final int end;
  final bool isHashtag;
  final String raw;
}

class _InteractivePostCaptionState extends State<InteractivePostCaption> {
  late bool _expanded;
  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void initState() {
    super.initState();
    _expanded = false;
  }

  @override
  void didUpdateWidget(InteractivePostCaption oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _expanded = false;
    }
  }

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  void _disposeRecognizers() {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();
  }

  bool get _needsTruncation => widget.data.length > widget.maxCollapsedLength;

  String get _displaySource {
    if (_expanded || !_needsTruncation) return widget.data;
    return truncatePlainTextAtWordBoundary(
      widget.data,
      widget.maxCollapsedLength,
    );
  }

  static List<_MatchSeg> _mergeMatches(String text) {
    final raw = <_MatchSeg>[];
    for (final m in kPostHashtagPattern.allMatches(text)) {
      final g = m.group(0);
      if (g != null) {
        raw.add(
          _MatchSeg(start: m.start, end: m.end, isHashtag: true, raw: g),
        );
      }
    }
    for (final m in kPostMentionPattern.allMatches(text)) {
      final g = m.group(0);
      if (g != null) {
        raw.add(
          _MatchSeg(start: m.start, end: m.end, isHashtag: false, raw: g),
        );
      }
    }
    raw.sort((a, b) => a.start.compareTo(b.start));
    final out = <_MatchSeg>[];
    int? lastEnd;
    for (final m in raw) {
      if (lastEnd != null && m.start < lastEnd) {
        continue;
      }
      out.add(m);
      lastEnd = m.end;
    }
    return out;
  }

  List<InlineSpan> _buildSpans({
    required String source,
    required TextStyle base,
    required TextStyle tagStyle,
    required TextStyle mentionStyle,
  }) {
    _disposeRecognizers();
    final mentionByUserLower = {
      for (final m in widget.mentions) m.username.toLowerCase(): m.userId,
    };

    final matches = _mergeMatches(source);
    if (matches.isEmpty) {
      return [TextSpan(text: source, style: base)];
    }

    final spans = <InlineSpan>[];
    var cursor = 0;
    for (final m in matches) {
      if (m.start > cursor) {
        spans.add(TextSpan(text: source.substring(cursor, m.start), style: base));
      }

      if (m.isHashtag) {
        final normalized = m.raw.length > 1
            ? m.raw.substring(1).toLowerCase()
            : '';
        if (widget.onHashtagTap != null && normalized.isNotEmpty) {
          final recognizer = TapGestureRecognizer()
            ..onTap = () => widget.onHashtagTap!(normalized);
          _recognizers.add(recognizer);
          spans.add(
            TextSpan(
              text: m.raw,
              style: tagStyle,
              recognizer: recognizer,
            ),
          );
        } else {
          spans.add(TextSpan(text: m.raw, style: tagStyle));
        }
      } else {
        final handle = m.raw.startsWith('@') && m.raw.length > 1
            ? m.raw.substring(1)
            : m.raw;
        final userId = mentionByUserLower[handle.toLowerCase()];
        if (userId != null &&
            userId.isNotEmpty &&
            widget.onMentionTap != null) {
          final recognizer = TapGestureRecognizer()
            ..onTap = () => widget.onMentionTap!(userId);
          _recognizers.add(recognizer);
          spans.add(
            TextSpan(
              text: m.raw,
              style: mentionStyle,
              recognizer: recognizer,
            ),
          );
        } else {
          spans.add(TextSpan(text: m.raw, style: base));
        }
      }
      cursor = m.end;
    }
    if (cursor < source.length) {
      spans.add(TextSpan(text: source.substring(cursor), style: base));
    }
    return spans;
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
        base.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w500,
        );
    final mentionStyle =
        widget.mentionStyle ??
        base.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
        );
    final toggle =
        widget.toggleStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        );

    final source = _displaySource;
    final spans = _buildSpans(
      source: source,
      base: base,
      tagStyle: tagStyle,
      mentionStyle: mentionStyle,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: Alignment.topLeft,
          child: SelectionArea(
            child: Text.rich(
              TextSpan(children: spans),
              textAlign: widget.textAlign,
            ),
          ),
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
