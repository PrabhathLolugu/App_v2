class ParsedDiscussionSearchQuery {
  const ParsedDiscussionSearchQuery({
    required this.hashtags,
    required this.textQuery,
  });

  final List<String> hashtags;
  final String textQuery;
}

/// One hashtag: non-alphanumeric → spaces, words merged to PascalCase (e.g. "South India" → "SouthIndia").
/// Does not split on `#`; use [parseHashtagsFromComposerInput] for multi-tag field text.
String normalizeHashtagSegment(String segment) {
  final trimmed = segment.trim();
  if (trimmed.isEmpty) return '';

  final alphanumeric = trimmed.replaceAll(RegExp(r'[^A-Za-z0-9]+'), ' ');
  final words = alphanumeric
      .trim()
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .toList();

  if (words.isEmpty) return '';

  final normalized = words
      .map(
        (word) =>
            '${word.substring(0, 1).toUpperCase()}${word.substring(1).toLowerCase()}',
      )
      .join();
  return normalized.length > 64 ? normalized.substring(0, 64) : normalized;
}

/// Normalizes a single tag (e.g. from search or DB). Leading `#` is ignored.
String normalizeHashtagToken(String input) {
  final s = input.trim();
  if (s.isEmpty) return '';
  final noLeadingHash = s.replaceFirst(RegExp(r'^#+'), '').trim();
  return normalizeHashtagSegment(noLeadingHash);
}

/// Splits composer field text on `#` so each part is one hashtag (`India#Bharat`, `#India #Bharat` → two tags).
List<String> parseHashtagsFromComposerInput(String raw) {
  if (raw.trim().isEmpty) return const [];
  final out = <String>[];
  for (final part in raw.split('#')) {
    final t = part.trim();
    if (t.isNotEmpty) out.add(t);
  }
  return out.map(normalizeHashtagSegment).where((s) => s.isNotEmpty).toList();
}

List<String> mergeHashtags(
  List<String> auto,
  List<String> user, {
  int max = 5,
}) {
  final merged = <String>[];
  final seen = <String>{};

  for (final source in [...auto, ...user]) {
    final normalized = normalizeHashtagToken(source);
    if (normalized.isEmpty) continue;
    final key = normalized.toLowerCase();
    if (seen.contains(key)) continue;
    seen.add(key);
    merged.add(normalized);
    if (merged.length >= max) break;
  }
  return merged;
}

List<String> buildHashtagsFromParts(
  Iterable<String?> parts, {
  int max = 5,
}) {
  return mergeHashtags(
    const [],
    parts.whereType<String>().toList(),
    max: max,
  );
}

List<String> parseRegionTokens(
  String? region, {
  int max = 3,
}) {
  if (region == null || region.trim().isEmpty) return const [];
  final split = region.split(RegExp(r'[,/|]'));
  return buildHashtagsFromParts(split, max: max);
}

ParsedDiscussionSearchQuery parseDiscussionSearchQuery(String query) {
  final hashtagMatches = RegExp(r'#[A-Za-z0-9_]+').allMatches(query);
  final hashtagTokens = hashtagMatches
      .map((match) => match.group(0) ?? '')
      .map(normalizeHashtagToken)
      .where((token) => token.isNotEmpty)
      .toList();

  final plainText = query.replaceAll(RegExp(r'#[A-Za-z0-9_]+'), ' ');
  final normalizedText = plainText.replaceAll(RegExp(r'\s+'), ' ').trim();

  return ParsedDiscussionSearchQuery(
    hashtags: mergeHashtags(const [], hashtagTokens),
    textQuery: normalizedText,
  );
}
