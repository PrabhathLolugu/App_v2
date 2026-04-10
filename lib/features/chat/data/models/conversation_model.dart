import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myitihas/features/chat/domain/entities/conversation.dart';
import 'package:myitihas/features/social/data/models/user_model.dart';
import 'message_model.dart';

part 'conversation_model.freezed.dart';
part 'conversation_model.g.dart';

@freezed
abstract class ConversationModel with _$ConversationModel {
  const ConversationModel._();

  const factory ConversationModel({
    required String id,
    required List<String> participantIds,
    required List<UserModel> participants,
    MessageModel? lastMessage,
    @Default(0) int unreadCount,
    required DateTime updatedAt,
  }) = _ConversationModel;

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);

  Conversation toEntity() {
    return Conversation(
      id: id,
      participantIds: participantIds,
      participants: participants.map((p) => p.toEntity()).toList(),
      lastMessage: lastMessage?.toEntity(),
      unreadCount: unreadCount,
      updatedAt: updatedAt,
    );
  }

  factory ConversationModel.fromEntity(Conversation conversation) {
    return ConversationModel(
      id: conversation.id,
      participantIds: conversation.participantIds,
      participants: conversation.participants
          .map((p) => UserModel.fromEntity(p))
          .toList(),
      lastMessage: conversation.lastMessage != null
          ? MessageModel.fromEntity(conversation.lastMessage!)
          : null,
      unreadCount: conversation.unreadCount,
      updatedAt: conversation.updatedAt,
    );
  }
}
