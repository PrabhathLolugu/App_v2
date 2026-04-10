/// Model representing a chat message.
///
/// Maps to the chat_messages table in the database.
class ChatMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final DateTime createdAt;
  final String? sharedContentId;
  final String? type; // e.g., 'text', 'story', 'post', etc.
  /// Whether this message has been deleted for everyone by the sender.
  final bool isDeletedForEveryone;

  /// Sender display name (from profiles), used in group chats.
  final String? senderName;

  /// Sender avatar URL (from profiles), used in group chats.
  final String? senderAvatarUrl;

  /// Optional media attachments for this message.
  final List<ChatAttachment> attachments;

  /// Optional link preview metadata for this message.
  final ChatLinkPreview? linkPreview;

  /// Server JSONB metadata (poll options, location coordinates, etc.).
  final Map<String, dynamic>? metadata;

  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.createdAt,
    this.type,
    this.sharedContentId,
    this.isDeletedForEveryone = false,
    this.senderName,
    this.senderAvatarUrl,
    this.attachments = const [],
    this.linkPreview,
    this.metadata,
  });

  ChatPollPayload? get pollPayload =>
      ChatPollPayload.tryParse(metadata, type);

  ChatLocationPayload? get locationPayload =>
      ChatLocationPayload.tryParse(metadata, type);

  /// Creates a ChatMessage from a database row.
  /// Supports nested profile data from join: json['profiles'] or json['sender']
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    String? senderName;
    String? senderAvatarUrl;
    final profiles = json['profiles'] ?? json['sender'];
    if (profiles is Map<String, dynamic>) {
      senderName =
          profiles['full_name'] as String? ?? profiles['username'] as String?;
      senderAvatarUrl = profiles['avatar_url'] as String?;
    }
    final rawType = json['type'] as String?;
    final normalizedType = _normalizeMessageType(rawType);
    final rawSharedContentId = json['shared_content_id'] as String?;
    final resolvedSharedContentId =
        rawSharedContentId ?? _extractSharedContentIdFromType(rawType);

    Map<String, dynamic>? meta;
    final rawMeta = json['metadata'];
    if (rawMeta is Map<String, dynamic>) {
      meta = rawMeta;
    } else if (rawMeta is Map) {
      meta = Map<String, dynamic>.from(rawMeta);
    }

    return ChatMessage(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      senderId: json['sender_id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
      type: normalizedType,
      sharedContentId: resolvedSharedContentId,
      isDeletedForEveryone: json['is_deleted_for_everyone'] as bool? ?? false,
      senderName: senderName ?? json['sender_name'] as String?,
      senderAvatarUrl: senderAvatarUrl ?? json['sender_avatar_url'] as String?,
      attachments: ((json['attachments'] as List?) ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ChatAttachment.fromJson)
          .toList(),
      linkPreview: json['link_preview'] is Map<String, dynamic>
          ? ChatLinkPreview.fromJson(
              json['link_preview'] as Map<String, dynamic>,
            )
          : null,
      metadata: meta,
    );
  }

  static String? _normalizeMessageType(String? rawType) {
    final trimmed = rawType?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;

    final separatorIndex = trimmed.indexOf(':');
    if (separatorIndex == -1) return trimmed;

    final baseType = trimmed.substring(0, separatorIndex).trim();
    return baseType.isEmpty ? null : baseType;
  }

  static String? _extractSharedContentIdFromType(String? rawType) {
    final trimmed = rawType?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;

    final separatorIndex = trimmed.indexOf(':');
    if (separatorIndex == -1) return null;

    final baseType = trimmed.substring(0, separatorIndex).trim().toLowerCase();
    if (baseType != 'sacredsite') return null;

    final encodedId = trimmed.substring(separatorIndex + 1).trim();
    final parsedId = int.tryParse(encodedId);
    if (parsedId == null) return null;

    return parsedId.toString();
  }

  /// Converts the ChatMessage to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      if (type != null) 'type': type,
      if (sharedContentId != null) 'shared_content_id': sharedContentId,
      if (attachments.isNotEmpty)
        'attachments': attachments.map((a) => a.toJson()).toList(),
      if (linkPreview != null) 'link_preview': linkPreview!.toJson(),
      if (metadata != null && metadata!.isNotEmpty) 'metadata': metadata,
    };
  }
}

/// Parsed poll definition from [ChatMessage.metadata].
class ChatPollPayload {
  final String question;
  final List<String> options;

  const ChatPollPayload({required this.question, required this.options});

  static ChatPollPayload? tryParse(Map<String, dynamic>? metadata, String? type) {
    if (metadata == null || type == null) return null;
    if (type.toLowerCase() != 'poll') return null;
    final q = metadata['question'] as String?;
    final rawOpts = metadata['options'];
    if (q == null || q.trim().isEmpty) return null;
    if (rawOpts is! List || rawOpts.length < 2) return null;
    final opts = rawOpts
        .map((e) => e?.toString().trim() ?? '')
        .where((s) => s.isNotEmpty)
        .toList();
    if (opts.length < 2 || opts.length > 4) return null;
    return ChatPollPayload(question: q.trim(), options: opts);
  }
}

/// Parsed shared location from [ChatMessage.metadata].
class ChatLocationPayload {
  final double lat;
  final double lng;
  final double? accuracyMeters;

  const ChatLocationPayload({
    required this.lat,
    required this.lng,
    this.accuracyMeters,
  });

  static ChatLocationPayload? tryParse(
    Map<String, dynamic>? metadata,
    String? type,
  ) {
    if (metadata == null || type == null) return null;
    if (type.toLowerCase() != 'location') return null;
    final lat = (metadata['lat'] as num?)?.toDouble();
    final lng = (metadata['lng'] as num?)?.toDouble();
    if (lat == null || lng == null) return null;
    final acc = (metadata['accuracy_m'] as num?)?.toDouble();
    return ChatLocationPayload(lat: lat, lng: lng, accuracyMeters: acc);
  }
}

class ChatAttachment {
  final String id;
  final String bucket;
  final String objectPath;
  final String? mimeType;
  final int? sizeBytes;
  final String? signedUrl;

  ChatAttachment({
    required this.id,
    required this.bucket,
    required this.objectPath,
    this.mimeType,
    this.sizeBytes,
    this.signedUrl,
  });

  factory ChatAttachment.fromJson(Map<String, dynamic> json) {
    return ChatAttachment(
      id: json['id']?.toString() ?? '',
      bucket: json['bucket']?.toString() ?? 'chat-media',
      objectPath: json['object_path']?.toString() ?? '',
      mimeType: json['mime_type'] as String?,
      sizeBytes: json['size_bytes'] as int?,
      signedUrl: json['signed_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bucket': bucket,
      'object_path': objectPath,
      if (mimeType != null) 'mime_type': mimeType,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (signedUrl != null) 'signed_url': signedUrl,
    };
  }
}

class ChatLinkPreview {
  final String url;
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? domain;

  ChatLinkPreview({
    required this.url,
    this.title,
    this.description,
    this.imageUrl,
    this.domain,
  });

  factory ChatLinkPreview.fromJson(Map<String, dynamic> json) {
    return ChatLinkPreview(
      url: json['url']?.toString() ?? '',
      title: json['title'] as String?,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      domain: json['domain'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (imageUrl != null) 'image_url': imageUrl,
      if (domain != null) 'domain': domain,
    };
  }
}
