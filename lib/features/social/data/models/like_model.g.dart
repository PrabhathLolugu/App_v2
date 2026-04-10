// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LikeModel _$LikeModelFromJson(Map<String, dynamic> json) => _LikeModel(
  userId: json['userId'] as String,
  contentId: json['contentId'] as String,
  contentType: json['contentType'] as String? ?? 'story',
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$LikeModelToJson(_LikeModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'contentId': instance.contentId,
      'contentType': instance.contentType,
      'timestamp': instance.timestamp.toIso8601String(),
    };
