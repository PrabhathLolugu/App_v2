/// Active `@handle` being composed at [caretOffset] in [text], if any.
///
/// The handle is the word segment starting with `@` up to the caret, with no
/// whitespace inside the segment (matches Twitter/Instagram-style typing).
class MentionComposerRange {
  const MentionComposerRange({
    required this.atIndex,
    required this.endIndex,
    required this.query,
  });

  /// Index of the `@` character.
  final int atIndex;

  /// Exclusive end index (caret position while typing).
  final int endIndex;

  /// Text after `@` without the `@` (may be empty).
  final String query;
}

/// Returns the active mention range when the caret is immediately after `@` or
/// inside a mention token (no whitespace between `@` and caret).
MentionComposerRange? activeMentionAtCaret(String text, int caretOffset) {
  if (caretOffset < 0 || caretOffset > text.length) return null;
  var i = caretOffset - 1;
  while (i >= 0) {
    final c = text[i];
    if (c == ' ' || c == '\n' || c == '\t') {
      break;
    }
    i--;
  }
  final start = i + 1;
  if (start >= caretOffset) return null;
  if (text[start] != '@') return null;
  final query = text.substring(start + 1, caretOffset);
  if (query.contains(' ') || query.contains('\n') || query.contains('\t')) {
    return null;
  }
  return MentionComposerRange(atIndex: start, endIndex: caretOffset, query: query);
}
