import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  @override
  @JsonKey(name: 'id')
  String get id;

  @override
  @JsonKey(name: 'username')
  String get username;

  @override
  @JsonKey(name: 'displayName')
  String get displayName;

  @override
  @JsonKey(name: 'avatarUrl')
  String get avatarUrl;

  @override
  @JsonKey(name: 'bio')
  String get bio;

  @override
  @JsonKey(name: 'followerCount')
  int get followerCount;

  @override
  @JsonKey(name: 'followingCount')
  int get followingCount;

  @override
  @JsonKey(name: 'isFollowing')
  bool get isFollowing;

  @override
  @JsonKey(name: 'isCurrentUser')
  bool get isCurrentUser;

  @override
  @JsonKey(name: 'savedStories')
  List<String> get savedStories;

  @override
  @JsonKey(name: 'isVerified')
  bool get isVerified;

  @override
  @JsonKey(name: 'acceptsDirectMessages')
  bool get acceptsDirectMessages;

  @override
  @JsonKey(name: 'isOfficialMyitihas')
  bool get isOfficialMyitihas;

  const factory UserModel({
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
    @Default(false) bool isOfficialMyitihas,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  User toEntity() {
    return User(
      id: id,
      username: username,
      displayName: displayName,
      avatarUrl: avatarUrl,
      bio: bio,
      followerCount: followerCount,
      followingCount: followingCount,
      postCount: postCount,
      isFollowing: isFollowing,
      isCurrentUser: isCurrentUser,
      savedStories: savedStories,
      isVerified: isVerified,
      acceptsDirectMessages: acceptsDirectMessages,
      isOfficialMyitihas: isOfficialMyitihas,
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      username: user.username,
      displayName: user.displayName,
      avatarUrl: user.avatarUrl,
      bio: user.bio,
      followerCount: user.followerCount,
      followingCount: user.followingCount,
      postCount: user.postCount,
      isFollowing: user.isFollowing,
      isCurrentUser: user.isCurrentUser,
      savedStories: user.savedStories,
      isVerified: user.isVerified,
      acceptsDirectMessages: user.acceptsDirectMessages,
      isOfficialMyitihas: user.isOfficialMyitihas,
    );
  }
}
