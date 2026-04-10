import 'dart:convert';

import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:myitihas/features/story_generator/domain/entities/story_chat_message.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'story_chats'),
  sqliteConfig: SqliteSerializable(),
)
class StoryChatConversationModel extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  final String id;

  @Supabase(name: 'story_id', unique: true)
  final String storyId;

  @Supabase(name: 'user_id', unique: true)
  final String userId;

  final String title;

  // Supabase stores as JSONB array, SQLite stores as JSON string
  @Supabase(
    name: 'messages',
    fromGenerator: 'jsonEncode(%DATA_PROPERTY%)',
    toGenerator: 'jsonDecode(%INSTANCE_PROPERTY%)',
  )
  @Sqlite(name: 'messages')
  final String messagesJson;

  @Supabase(name: 'created_at')
  final DateTime createdAt;

  @Supabase(name: 'updated_at')
  final DateTime updatedAt;

  StoryChatConversationModel({
    required this.id,
    required this.storyId,
    required this.userId,
    required this.title,
    required this.messagesJson,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StoryChatConversationModel.fromDomain(StoryChatConversation entity) {
    return StoryChatConversationModel(
      id: entity.id,
      storyId: entity.storyId,
      userId: entity.userId,
      title: entity.title,
      messagesJson: jsonEncode(entity.messages.map((m) => m.toJson()).toList()),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  StoryChatConversation toDomain() {
    return StoryChatConversation(
      id: id,
      storyId: storyId,
      userId: userId,
      title: title,
      messages: (jsonDecode(messagesJson) as List<dynamic>)
          .map((json) => StoryChatMessage.fromJson(json as Map<String, dynamic>))
          .toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
