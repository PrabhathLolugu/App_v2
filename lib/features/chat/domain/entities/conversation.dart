import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myitihas/features/social/domain/entities/user.dart';
import 'message.dart';

part 'conversation.freezed.dart';

@freezed
abstract class Conversation with _$Conversation {
  const factory Conversation({
    required String id,
    required List<String> participantIds,
    required List<User> participants,
    Message? lastMessage,
    @Default(0) int unreadCount,
    required DateTime updatedAt,
  }) = _Conversation;

  const Conversation._();
}
