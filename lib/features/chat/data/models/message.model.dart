import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:myitihas/features/chat/domain/entities/message.dart';
import 'package:myitihas/features/social/data/models/user.model.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'chat_messages'),
  sqliteConfig: SqliteSerializable(),
)
class MessageModel extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  final String id;

  @Supabase(name: 'conversation_id')
  final String conversationId;

  @Supabase(name: 'sender_id')
  final String senderId;

  // Nullable sender for cache resilience (Phase 4 pattern)
  @Supabase(foreignKey: 'sender_id')
  final UserModel? sender;

  // CRITICAL: Dart field is 'content', maps to Supabase 'content' column
  // Maps to entity's 'text' field in toDomain()
  @Supabase(name: 'content')
  final String content;

  @Supabase(name: 'type')
  final String? type;

  @Supabase(name: 'created_at')
  final DateTime createdAt;

  // Local-only delivery status (not in Supabase)
  @Supabase(ignore: true)
  @Sqlite()
  final String deliveryStatus;

  // Local-only read tracking
  @Supabase(ignore: true)
  @Sqlite()
  final List<String> readBy;

  // Optional shared content reference
  @Supabase(name: 'shared_content_id')
  @Sqlite()
  final String? sharedContentId;

  @Supabase(name: 'metadata')
  @Sqlite()
  final Map<String, dynamic>? metadata;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.sender,
    required this.content,
    this.type = 'text',
    required this.createdAt,
    this.deliveryStatus = 'sent',
    this.readBy = const [],
    this.sharedContentId,
    this.metadata,
  });

  Message toDomain() {
    final status = _parseDeliveryStatus(deliveryStatus);

    return Message(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      senderName: sender?.displayName ?? 'Unknown',
      senderAvatar: sender?.avatarUrl ?? '',
      text: content, // Map model's content to entity's text field
      timestamp: createdAt,
      deliveryStatus: status,
      readBy: readBy,
      sharedContentId: sharedContentId,
      type: type,
      metadata: metadata,
    );
  }

  MessageDeliveryStatus _parseDeliveryStatus(String status) {
    switch (status) {
      case 'sending':
        return MessageDeliveryStatus.sending;
      case 'sent':
        return MessageDeliveryStatus.sent;
      case 'delivered':
        return MessageDeliveryStatus.delivered;
      case 'read':
        return MessageDeliveryStatus.read;
      case 'failed':
        return MessageDeliveryStatus.failed;
      default:
        return MessageDeliveryStatus.sent;
    }
  }

  factory MessageModel.fromDomain(Message entity) {
    return MessageModel(
      id: entity.id,
      conversationId: entity.conversationId,
      senderId: entity.senderId,
      content: entity.text, // Map entity's text to model's content field
      createdAt: entity.timestamp,
      deliveryStatus: entity.deliveryStatus.name,
      readBy: entity.readBy,
      sharedContentId: entity.sharedContentId,
      type: entity.type,
      metadata: entity.metadata,
    );
  }
}
