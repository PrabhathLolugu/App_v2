import 'package:flutter/material.dart';
import 'package:myitihas/services/notification_service.dart';

/// Presentation-layer model wrapping the raw Map from NotificationService.
class NotificationItem {
  final String id;
  final String notificationType;
  final String? title;
  final String? body;
  final bool isRead;
  final DateTime createdAt;
  final String? actorId;
  final String? actorUsername;
  final String? actorFullName;
  final String? actorAvatarUrl;
  final String? entityType;
  final String? entityId;
  final String? actionUrl;
  final Map<String, dynamic> metadata;

  const NotificationItem({
    required this.id,
    required this.notificationType,
    this.title,
    this.body,
    required this.isRead,
    required this.createdAt,
    this.actorId,
    this.actorUsername,
    this.actorFullName,
    this.actorAvatarUrl,
    this.entityType,
    this.entityId,
    this.actionUrl,
    this.metadata = const {},
  });

  factory NotificationItem.fromMap(Map<String, dynamic> map) {
    final actor = map['actor'] as Map<String, dynamic>?;
    final rawMetadata = map['metadata'];
    final metadata = rawMetadata is Map
        ? rawMetadata.map(
            (key, value) => MapEntry(key.toString(), value),
          )
        : <String, dynamic>{};

    return NotificationItem(
      id: map['id'] as String,
      notificationType: map['notification_type'] as String? ?? '',
      title: map['title'] as String?,
      body: map['body'] as String?,
      isRead: map['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(map['created_at'] as String),
      actorId: actor?['id'] as String?,
      actorUsername: actor?['username'] as String?,
      actorFullName: actor?['full_name'] as String?,
      actorAvatarUrl: actor?['avatar_url'] as String?,
      entityType: map['entity_type'] as String?,
      entityId: map['entity_id'] as String?,
      actionUrl: map['action_url'] as String?,
      metadata: metadata,
    );
  }

  String get displayName =>
      actorFullName?.isNotEmpty == true
          ? actorFullName!
          : actorUsername ?? 'Someone';

  NotificationType? get parsedType {
    switch (notificationType) {
      case 'like':
        return NotificationType.like;
      case 'comment':
        return NotificationType.comment;
      case 'reply':
        return NotificationType.reply;
      case 'follow':
        return NotificationType.follow;
      case 'mention':
        return NotificationType.mention;
      case 'share':
        return NotificationType.share;
      case 'repost':
        return NotificationType.repost;
      case 'new_post':
        return NotificationType.newPost;
      case 'story_suggestion':
        return NotificationType.storySuggestion;
      case 'message':
        return NotificationType.message;
      case 'group_message':
        return NotificationType.groupMessage;
      default:
        return null;
    }
  }

  String? metadataString(String key) {
    final value = metadata[key];
    if (value == null) return null;
    final asString = value.toString().trim();
    return asString.isEmpty ? null : asString;
  }

  bool metadataBool(String key, {bool fallback = false}) {
    final value = metadata[key];
    if (value is bool) return value;
    if (value is String) {
      final normalized = value.toLowerCase().trim();
      if (normalized == 'true') return true;
      if (normalized == 'false') return false;
    }
    return fallback;
  }

  String? get contentType => metadataString('content_type');

  String? get targetCommentId => metadataString('target_comment_id');

  String? get parentEntityType => metadataString('parent_entity_type');

  String? get parentEntityId => metadataString('parent_entity_id');

  String? get conversationId => metadataString('conversation_id') ?? entityId;

  bool get isGroupConversation => metadataBool('is_group');

  IconData get icon {
    switch (parsedType) {
      case NotificationType.like:
        return Icons.favorite_rounded;
      case NotificationType.comment:
        return Icons.chat_bubble_rounded;
      case NotificationType.reply:
        return Icons.reply_rounded;
      case NotificationType.follow:
        return Icons.person_add_rounded;
      case NotificationType.mention:
        return Icons.alternate_email_rounded;
      case NotificationType.share:
        return Icons.share_rounded;
      case NotificationType.repost:
        return Icons.repeat_rounded;
      case NotificationType.newPost:
        return Icons.article_rounded;
      case NotificationType.storySuggestion:
        return Icons.auto_stories_rounded;
      case NotificationType.message:
      case NotificationType.groupMessage:
        return Icons.forum_rounded;
      case null:
        return Icons.notifications_rounded;
    }
  }

  Color get color {
    switch (parsedType) {
      case NotificationType.like:
        return const Color(0xFFEC4899);
      case NotificationType.comment:
        return const Color(0xFF3B82F6);
      case NotificationType.reply:
        return const Color(0xFF6366F1);
      case NotificationType.follow:
        return const Color(0xFF8B5CF6);
      case NotificationType.mention:
        return const Color(0xFFF59E0B);
      case NotificationType.share:
        return const Color(0xFF10B981);
      case NotificationType.repost:
        return const Color(0xFF14B8A6);
      case NotificationType.newPost:
        return const Color(0xFFF97316);
      case NotificationType.storySuggestion:
        return const Color(0xFF0EA5E9);
      case NotificationType.message:
      case NotificationType.groupMessage:
        return const Color(0xFF06B6D4);
      case null:
        return const Color(0xFF6B7280);
    }
  }

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      id: id,
      notificationType: notificationType,
      title: title,
      body: body,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
      actorId: actorId,
      actorUsername: actorUsername,
      actorFullName: actorFullName,
      actorAvatarUrl: actorAvatarUrl,
      entityType: entityType,
      entityId: entityId,
      actionUrl: actionUrl,
      metadata: metadata,
    );
  }
}
