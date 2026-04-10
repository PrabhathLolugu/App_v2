class ChatMentionMatch {
  final int start;
  final int end;
  final String raw;
  final String display;
  final String userId;

  const ChatMentionMatch({
    required this.start,
    required this.end,
    required this.raw,
    required this.display,
    required this.userId,
  });
}

class ChatMentionParser {
  ChatMentionParser._();

  static final RegExp _encodedMentionRegex = RegExp(
    r'@\[([^\]\n]+)\]\(([A-Za-z0-9-]{8,})\)',
  );

  static String encode({required String display, required String userId}) {
    final normalizedDisplay = display.trim();
    final normalizedUserId = userId.trim();

    if (normalizedDisplay.isEmpty || normalizedUserId.isEmpty) {
      return '@$normalizedDisplay';
    }

    return '@[$normalizedDisplay]($normalizedUserId)';
  }

  static List<ChatMentionMatch> extractEncodedMatches(String input) {
    final matches = <ChatMentionMatch>[];

    for (final match in _encodedMentionRegex.allMatches(input)) {
      final raw = match.group(0);
      final display = match.group(1);
      final userId = match.group(2);

      if (raw == null || display == null || userId == null) {
        continue;
      }

      matches.add(
        ChatMentionMatch(
          start: match.start,
          end: match.end,
          raw: raw,
          display: display,
          userId: userId,
        ),
      );
    }

    return matches;
  }

  static String toDisplayText(String input) {
    if (input.isEmpty) {
      return input;
    }

    return input.replaceAllMapped(_encodedMentionRegex, (match) {
      final display = match.group(1);
      if (display == null || display.trim().isEmpty) {
        return '@user';
      }
      return '@${display.trim()}';
    });
  }
}
