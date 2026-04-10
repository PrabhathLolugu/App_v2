// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShareModel _$ShareModelFromJson(Map<String, dynamic> json) => _ShareModel(
  userId: json['userId'] as String,
  contentId: json['contentId'] as String,
  contentType: json['contentType'] as String,
  shareType: $enumDecode(_$ShareTypeEnumMap, json['shareType']),
  recipientId: json['recipientId'] as String?,
  repostId: json['repostId'] as String?,
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$ShareModelToJson(_ShareModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'contentId': instance.contentId,
      'contentType': instance.contentType,
      'shareType': _$ShareTypeEnumMap[instance.shareType]!,
      'recipientId': instance.recipientId,
      'repostId': instance.repostId,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$ShareTypeEnumMap = {
  ShareType.repost: 'repost',
  ShareType.directMessage: 'directMessage',
  ShareType.external: 'external',
};
