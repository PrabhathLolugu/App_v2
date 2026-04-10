// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  username: json['username'] as String,
  displayName: json['displayName'] as String,
  avatarUrl: json['avatarUrl'] as String,
  bio: json['bio'] as String,
  followerCount: (json['followerCount'] as num?)?.toInt() ?? 0,
  followingCount: (json['followingCount'] as num?)?.toInt() ?? 0,
  postCount: (json['postCount'] as num?)?.toInt() ?? 0,
  isFollowing: json['isFollowing'] as bool? ?? false,
  isCurrentUser: json['isCurrentUser'] as bool? ?? false,
  savedStories:
      (json['savedStories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  isVerified: json['isVerified'] as bool? ?? false,
  acceptsDirectMessages: json['acceptsDirectMessages'] as bool? ?? true,
  isOfficialMyitihas: json['isOfficialMyitihas'] as bool? ?? false,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'displayName': instance.displayName,
      'avatarUrl': instance.avatarUrl,
      'bio': instance.bio,
      'followerCount': instance.followerCount,
      'followingCount': instance.followingCount,
      'postCount': instance.postCount,
      'isFollowing': instance.isFollowing,
      'isCurrentUser': instance.isCurrentUser,
      'savedStories': instance.savedStories,
      'isVerified': instance.isVerified,
      'acceptsDirectMessages': instance.acceptsDirectMessages,
      'isOfficialMyitihas': instance.isOfficialMyitihas,
    };
