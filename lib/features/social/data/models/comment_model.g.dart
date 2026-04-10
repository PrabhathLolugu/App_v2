// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommentModel _$CommentModelFromJson(Map<String, dynamic> json) =>
    _CommentModel(
      id: json['id'] as String,
      contentId: json['contentId'] as String,
      contentType: json['contentType'] as String? ?? 'story',
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      parentCommentId: json['parentCommentId'] as String?,
      replies:
          (json['replies'] as List<dynamic>?)
              ?.map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      depth: (json['depth'] as num?)?.toInt() ?? 0,
      isCollapsed: json['isCollapsed'] as bool? ?? false,
      isLikedByCurrentUser: json['isLikedByCurrentUser'] as bool? ?? false,
    );

Map<String, dynamic> _$CommentModelToJson(_CommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contentId': instance.contentId,
      'contentType': instance.contentType,
      'userId': instance.userId,
      'userName': instance.userName,
      'userAvatar': instance.userAvatar,
      'text': instance.text,
      'createdAt': instance.createdAt.toIso8601String(),
      'likeCount': instance.likeCount,
      'parentCommentId': instance.parentCommentId,
      'replies': instance.replies,
      'depth': instance.depth,
      'isCollapsed': instance.isCollapsed,
      'isLikedByCurrentUser': instance.isLikedByCurrentUser,
    };
