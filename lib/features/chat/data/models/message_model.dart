import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myitihas/features/chat/domain/entities/message.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
abstract class MessageModel with _$MessageModel {
  const MessageModel._();

  const factory MessageModel({
    required String id,
    required String conversationId,
    required String senderId,
    required String senderName,
    required String senderAvatar,
    required String text,
    required DateTime timestamp,
    @Default(MessageDeliveryStatus.sending)
    MessageDeliveryStatus deliveryStatus,
    @Default([]) List<String> readBy,
    String? sharedContentId,
    String? type,
    Map<String, dynamic>? metadata,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Message toEntity() {
    return Message(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      senderName: senderName,
      senderAvatar: senderAvatar,
      text: text,
      timestamp: timestamp,
      deliveryStatus: deliveryStatus,
      readBy: readBy,
      sharedContentId: sharedContentId,
      type: type,
      metadata: metadata,
    );
  }

  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      id: message.id,
      conversationId: message.conversationId,
      senderId: message.senderId,
      senderName: message.senderName,
      senderAvatar: message.senderAvatar,
      text: message.text,
      timestamp: message.timestamp,
      deliveryStatus: message.deliveryStatus,
      readBy: message.readBy,
      sharedContentId: message.sharedContentId,
      type: message.type,
      metadata: message.metadata,
    );
  }
}
