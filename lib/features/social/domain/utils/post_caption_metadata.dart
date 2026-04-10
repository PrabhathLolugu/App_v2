/// Hashtags: `#` then a run of non-space, non-`#` (matches feed rendering).
final RegExp kPostHashtagPattern = RegExp(r'#[^\s#]+');

/// Twitter-like @handle: ASCII letters, digits, underscore.
final RegExp kPostMentionPattern = RegExp(r'@([a-zA-Z0-9_]{1,30})');

const int kMaxStoredTags = 30;

/// Normalized hashtag tokens (no `#`, lowercase) for storage and filtering.
List<String> normalizedHashtagsFromText(String? content, String? title) {
  final buf = StringBuffer();
  if (title != null && title.isNotEmpty) {
    buf.write(title);
    buf.write(' ');
  }
  if (content != null && content.isNotEmpty) {
    buf.write(content);
  }
  final text = buf.toString();
  if (text.isEmpty) return [];

  final seen = <String>{};
  final out = <String>[];
  for (final m in kPostHashtagPattern.allMatches(text)) {
    final raw = m.group(0);
    if (raw == null || raw.length < 2) continue;
    final normalized = raw.substring(1).toLowerCase();
    if (normalized.isEmpty) continue;
    if (seen.add(normalized)) {
      out.add(normalized);
      if (out.length >= kMaxStoredTags) break;
    }
  }
  return out;
}

/// Distinct mention handles as typed (without `@`), in first-seen order.
List<String> mentionUsernamesFromText(String? content, String? title) {
  final buf = StringBuffer();
  if (title != null && title.isNotEmpty) {
    buf.write(title);
    buf.write(' ');
  }
  if (content != null && content.isNotEmpty) {
    buf.write(content);
  }
  final text = buf.toString();
  if (text.isEmpty) return [];

  final seen = <String>{};
  final out = <String>[];
  for (final m in kPostMentionPattern.allMatches(text)) {
    final u = m.group(1);
    if (u == null || u.isEmpty) continue;
    if (seen.add(u.toLowerCase())) {
      out.add(u);
    }
  }
  return out;
}

/// Merges [fromText] tags with existing `metadata['tags']` (deduped, capped).
List<String> mergeTagLists(dynamic existingRaw, List<String> fromText) {
  final existing = <String>[];
  if (existingRaw is List) {
    for (final e in existingRaw) {
      final s = e.toString().toLowerCase().trim();
      if (s.isNotEmpty) existing.add(s);
    }
  }
  final seen = <String>{...existing};
  final out = <String>[...existing];
  for (final t in fromText) {
    final n = t.toLowerCase();
    if (seen.add(n)) out.add(n);
    if (out.length >= kMaxStoredTags) break;
  }
  return out;
}

/// Resolved mentions for [metadata.mentions]; keys are lowercase usernames.
List<Map<String, dynamic>> buildMentionsJson(
  List<String> mentionOrder,
  Map<String, String> usernameLowerToUserId,
) {
  final out = <Map<String, dynamic>>[];
  final seenIds = <String>{};
  for (final u in mentionOrder) {
    final id = usernameLowerToUserId[u.toLowerCase()];
    if (id == null || id.isEmpty) continue;
    if (!seenIds.add(id)) continue;
    out.add({'username': u, 'user_id': id});
  }
  return out;
}

/// Whether [normalizedTag] (no `#`, lowercase) appears in post [tags].
bool feedItemTagsContain(List<String> tags, String normalizedTag) {
  final n = normalizedTag.toLowerCase();
  for (final t in tags) {
    if (t.toLowerCase() == n) return true;
  }
  return false;
}

/// True if [title] or [bodyOrCaption] contains a `#hashtag` token matching [normalizedTag].
/// Aligns with [normalizedHashtagsFromText] / server ILIKE + hashtag filter.
bool captionHashtagMatches(
  String? bodyOrCaption,
  String? title,
  String normalizedTag,
) {
  final n = normalizedTag.toLowerCase();
  if (n.isEmpty) return false;
  final buf = StringBuffer();
  if (title != null && title.isNotEmpty) {
    buf.write(title);
    buf.write(' ');
  }
  if (bodyOrCaption != null && bodyOrCaption.isNotEmpty) {
    buf.write(bodyOrCaption);
  }
  final text = buf.toString();
  if (text.isEmpty) return false;
  for (final m in kPostHashtagPattern.allMatches(text)) {
    final raw = m.group(0);
    if (raw != null && raw.length > 1 && raw.substring(1).toLowerCase() == n) {
      return true;
    }
  }
  return false;
}
