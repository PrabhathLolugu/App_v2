import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String username,
    required String displayName,
    required String avatarUrl,
    required String bio,
    @Default(0) int followerCount,
    @Default(0) int followingCount,
    @Default(0) int postCount,
    @Default(false) bool isFollowing,
    @Default(false) bool isCurrentUser,
    @Default(<String>[]) List<String> savedStories,
    @Default(false) bool isVerified,
    @Default(true) bool acceptsDirectMessages,
    /// True only for myitihas@gmail.com (server: profiles.is_official_myitihas).
    @Default(false) bool isOfficialMyitihas,
  }) = _User;

  const User._();
}
