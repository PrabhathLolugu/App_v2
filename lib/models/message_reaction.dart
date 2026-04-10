class MessageReaction {
  final String id;
  final String messageId;
  final String conversationId;
  final String userId;
  final String emoji;
  final DateTime createdAt;

  const MessageReaction({
    required this.id,
    required this.messageId,
    required this.conversationId,
    required this.userId,
    required this.emoji,
    required this.createdAt,
  });

  factory MessageReaction.fromJson(Map<String, dynamic> json) {
    return MessageReaction(
      id: json['id'].toString(),
      messageId: json['message_id'] as String,
      conversationId: json['conversation_id'] as String,
      userId: json['user_id'] as String,
      emoji: json['emoji'] as String,
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
    );
  }
}

/// Aggregated reactions for a single message, grouped by emoji.
class MessageReactionsSummary {
  final String messageId;
  final Map<String, int> counts; // emoji -> total count
  final String? currentUserEmoji; // emoji chosen by current user, if any

  const MessageReactionsSummary({
    required this.messageId,
    required this.counts,
    required this.currentUserEmoji,
  });

  MessageReactionsSummary copyWith({
    Map<String, int>? counts,
    String? currentUserEmoji,
  }) {
    return MessageReactionsSummary(
      messageId: messageId,
      counts: counts ?? this.counts,
      currentUserEmoji: currentUserEmoji ?? this.currentUserEmoji,
    );
  }
}

