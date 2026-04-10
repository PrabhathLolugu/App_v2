/// Model representing a conversation (chat or group).
///
/// Maps to the conversations table in the database.
class Conversation {
  final String id;
  final bool isGroup;
  final String title;
  final String? avatarUrl;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final String? lastMessageSenderId;
  final DateTime? lastReadAt;

  Conversation({
    required this.id,
    required this.isGroup,
    required this.title,
    this.avatarUrl,
    this.lastMessage,
    this.lastMessageAt,
    this.lastMessageSenderId,
    this.lastReadAt,
  });

  /// Computes whether this conversation has unread messages for the current user.
  ///
  /// Logic:
  /// - If sender is current user → not unread
  /// - If never read (lastReadAt is null) → unread
  /// - If last message is after last read → unread
  /// - Otherwise → not unread
  bool isUnread(String currentUserId) {
    // Sender never sees their own message as unread
    if (lastMessageSenderId == currentUserId) {
      return false;
    }

    // Never opened the chat → unread
    if (lastReadAt == null) {
      return true;
    }

    // Has a new message after last read → unread
    if (lastMessageAt != null && lastMessageAt!.isAfter(lastReadAt!)) {
      return true;
    }

    // All caught up
    return false;
  }

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      isGroup: json['is_group'] as bool,
      title: json['title'] as String,
      avatarUrl: json['avatar_url'] as String?,
      lastMessage: json['last_message'] as String?,
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'] as String)
          : null,
      lastMessageSenderId: json['last_message_sender_id'] as String?,
      lastReadAt: json['last_read_at'] != null
          ? DateTime.parse(json['last_read_at'] as String)
          : null,
    );
  }

  /// Converts the Conversation to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_group': isGroup,
      'last_message': lastMessage,
      'last_message_at': lastMessageAt?.toIso8601String(),
      'last_message_sender_id': lastMessageSenderId,
      'last_read_at': lastReadAt?.toIso8601String(),
      'title': title,
      'avatar_url': avatarUrl,
    };
  }
}
