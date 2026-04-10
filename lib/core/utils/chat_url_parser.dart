class ChatUrlMatch {
  final int start;
  final int end;
  final String raw;
  final String cleaned;
  final String trailing;
  final Uri normalizedUri;

  const ChatUrlMatch({
    required this.start,
    required this.end,
    required this.raw,
    required this.cleaned,
    required this.trailing,
    required this.normalizedUri,
  });
}

class ChatUrlParser {
  ChatUrlParser._();

  static final RegExp _candidateRegex = RegExp(
    r'((?:https?:\/\/|www\.)[^\s]+|(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(?:\/[^\s]*)?)',
    caseSensitive: false,
  );

  static const String _trailingPunctuation = '.,!?;:)]}"\'';

  static List<ChatUrlMatch> extractMatches(String input) {
    final matches = <ChatUrlMatch>[];

    for (final candidate in _candidateRegex.allMatches(input)) {
      final raw = candidate.group(0);
      if (raw == null || raw.isEmpty) {
        continue;
      }

      final beforeIndex = candidate.start - 1;
      if (beforeIndex >= 0 && input[beforeIndex] == '@') {
        continue;
      }

      final split = _splitTrailing(raw);
      final normalized = normalizeUrl(split.cleaned);
      if (normalized == null) {
        continue;
      }

      matches.add(
        ChatUrlMatch(
          start: candidate.start,
          end: candidate.end,
          raw: raw,
          cleaned: split.cleaned,
          trailing: split.trailing,
          normalizedUri: normalized,
        ),
      );
    }

    return matches;
  }

  static Uri? normalizeUrl(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final split = _splitTrailing(trimmed);
    var candidate = split.cleaned;
    if (candidate.isEmpty) {
      return null;
    }

    if (candidate.startsWith('www.')) {
      candidate = 'https://$candidate';
    }

    var uri = Uri.tryParse(candidate);
    if (uri == null) {
      return null;
    }

    if (!uri.hasScheme) {
      candidate = 'https://$candidate';
      uri = Uri.tryParse(candidate);
      if (uri == null) {
        return null;
      }
    }

    final scheme = uri.scheme.toLowerCase();
    if (scheme != 'http' && scheme != 'https') {
      return null;
    }

    if (uri.host.isEmpty || !uri.host.contains('.')) {
      return null;
    }

    return uri;
  }

  static String? extractFirstNormalizedUrl(String input) {
    final matches = extractMatches(input);
    if (matches.isEmpty) {
      return null;
    }
    return matches.first.normalizedUri.toString();
  }

  static String? extractDomain(String? url) {
    if (url == null || url.isEmpty) {
      return null;
    }
    final uri = normalizeUrl(url);
    if (uri == null || uri.host.isEmpty) {
      return null;
    }
    return uri.host;
  }

  static ({String cleaned, String trailing}) _splitTrailing(String value) {
    var end = value.length;
    while (end > 0 && _trailingPunctuation.contains(value[end - 1])) {
      end--;
    }

    final cleaned = value.substring(0, end);
    final trailing = value.substring(end);
    return (cleaned: cleaned, trailing: trailing);
  }
}
