import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:myitihas/features/social/data/models/user.model.dart';
import 'package:myitihas/features/chat/domain/entities/conversation.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'conversations'),
  sqliteConfig: SqliteSerializable(),
)
class ConversationModel extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  final String id;

  @Supabase(name: 'is_group')
  final bool isGroup;

  @Supabase(name: 'group_name')
  final String? groupName;

  @Supabase(name: 'group_avatar_url')
  final String? groupAvatarUrl;

  @Supabase(name: 'group_description')
  final String? groupDescription;

  @Supabase(name: 'last_message')
  final String? lastMessage;

  @Supabase(name: 'last_message_at')
  final DateTime? lastMessageAt;

  @Supabase(name: 'last_message_sender_id')
  final String? lastMessageSenderId;

  @Supabase(name: 'created_at')
  final DateTime createdAt;

  @Supabase(name: 'updated_at')
  final DateTime updatedAt;

  // Local-only fields (participants loaded manually via conversation_members)
  @Supabase(ignore: true)
  @Sqlite()
  final List<String> participantIds;

  @Supabase(ignore: true)
  @Sqlite(ignore: true)
  final List<UserModel> participants;

  @Supabase(ignore: true)
  @Sqlite()
  final int unreadCount;

  ConversationModel({
    required this.id,
    this.isGroup = false,
    this.groupName,
    this.groupAvatarUrl,
    this.groupDescription,
    this.lastMessage,
    this.lastMessageAt,
    this.lastMessageSenderId,
    required this.createdAt,
    required this.updatedAt,
    this.participantIds = const [],
    this.participants = const [],
    this.unreadCount = 0,
  });

  Conversation toDomain() {
    return Conversation(
      id: id,
      participantIds: participantIds,
      participants: participants.map((p) => p.toDomain()).toList(),
      lastMessage: null, // Model stores String? but entity expects Message?
      unreadCount: unreadCount,
      updatedAt: updatedAt,
    );
  }

  factory ConversationModel.fromDomain(Conversation entity) {
    return ConversationModel(
      id: entity.id,
      participantIds: entity.participantIds,
      participants: entity.participants.map((p) => UserModel.fromDomain(p)).toList(),
      lastMessage: entity.lastMessage?.text,
      lastMessageAt: entity.lastMessage?.timestamp,
      lastMessageSenderId: entity.lastMessage?.senderId,
      createdAt: DateTime.now(),
      updatedAt: entity.updatedAt,
      unreadCount: entity.unreadCount,
    );
  }
}
