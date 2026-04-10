import 'dart:convert';

class StoryChatMessage {
  final String sender; // 'user' | 'bot'
  final String text;
  final DateTime timestamp;

  /// Optional story context (used by the website on the first bot message).
  final Map<String, dynamic>? storyContext;

  const StoryChatMessage({
    required this.sender,
    required this.text,
    required this.timestamp,
    this.storyContext,
  });

  StoryChatMessage copyWith({
    String? sender,
    String? text,
    DateTime? timestamp,
    Map<String, dynamic>? storyContext,
  }) {
    return StoryChatMessage(
      sender: sender ?? this.sender,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      storyContext: storyContext ?? this.storyContext,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      if (storyContext != null) 'storyContext': storyContext,
    };
  }

  factory StoryChatMessage.fromJson(Map<String, dynamic> json) {
    return StoryChatMessage(
      sender: (json['sender'] ?? 'bot').toString(),
      text: (json['text'] ?? '').toString(),
      timestamp: DateTime.tryParse((json['timestamp'] ?? '').toString()) ??
          DateTime.now(),
      storyContext: json['storyContext'] is Map<String, dynamic>
          ? (json['storyContext'] as Map<String, dynamic>)
          : null,
    );
  }
}

class StoryChatConversation {
  final String id;
  final String storyId;
  final String userId;
  final String title;
  final List<StoryChatMessage> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  const StoryChatConversation({
    required this.id,
    required this.storyId,
    required this.userId,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  StoryChatConversation copyWith({
    String? id,
    String? storyId,
    String? userId,
    String? title,
    List<StoryChatMessage>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StoryChatConversation(
      id: id ?? this.id,
      storyId: storyId ?? this.storyId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toSupabaseInsert() {
    return {
      'id': id,
      'story_id': storyId,
      'user_id': userId,
      'title': title,
      'messages': messages.map((m) => m.toJson()).toList(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  factory StoryChatConversation.fromSupabaseRow(Map<String, dynamic> row) {
    final rawMessages = row['messages'];

    List<StoryChatMessage> parsed = const [];
    if (rawMessages is List) {
      parsed = rawMessages
          .whereType<Map<String, dynamic>>()
          .map(StoryChatMessage.fromJson)
          .toList();
    } else if (rawMessages is String) {
      // Safety fallback if messages were stored as a JSON string.
      try {
        final decoded = jsonDecode(rawMessages);
        if (decoded is List) {
          parsed = decoded
              .whereType<Map<String, dynamic>>()
              .map(StoryChatMessage.fromJson)
              .toList();
        }
      } catch (_) {}
    }

    return StoryChatConversation(
      id: (row['id'] ?? '').toString(),
      storyId: (row['story_id'] ?? '').toString(),
      userId: (row['user_id'] ?? '').toString(),
      title: (row['title'] ?? '').toString(),
      messages: parsed,
      createdAt: DateTime.tryParse((row['created_at'] ?? '').toString()) ??
          DateTime.now(),
      updatedAt: DateTime.tryParse((row['updated_at'] ?? '').toString()) ??
          DateTime.now(),
    );
  }
}
