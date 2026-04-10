// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessageModel _$MessageModelFromJson(Map<String, dynamic> json) =>
    _MessageModel(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      senderAvatar: json['senderAvatar'] as String,
      text: json['text'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      deliveryStatus:
          $enumDecodeNullable(
            _$MessageDeliveryStatusEnumMap,
            json['deliveryStatus'],
          ) ??
          MessageDeliveryStatus.sending,
      readBy:
          (json['readBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      sharedContentId: json['sharedContentId'] as String?,
      type: json['type'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$MessageModelToJson(
  _MessageModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'conversationId': instance.conversationId,
  'senderId': instance.senderId,
  'senderName': instance.senderName,
  'senderAvatar': instance.senderAvatar,
  'text': instance.text,
  'timestamp': instance.timestamp.toIso8601String(),
  'deliveryStatus': _$MessageDeliveryStatusEnumMap[instance.deliveryStatus]!,
  'readBy': instance.readBy,
  'sharedContentId': instance.sharedContentId,
  'type': instance.type,
  'metadata': instance.metadata,
};

const _$MessageDeliveryStatusEnumMap = {
  MessageDeliveryStatus.sending: 'sending',
  MessageDeliveryStatus.sent: 'sent',
  MessageDeliveryStatus.delivered: 'delivered',
  MessageDeliveryStatus.read: 'read',
  MessageDeliveryStatus.failed: 'failed',
};
