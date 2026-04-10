// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModel {

 String get id; String get username; String get displayName; String get avatarUrl; String get bio; int get followerCount; int get followingCount; int get postCount; bool get isFollowing; bool get isCurrentUser; List<String> get savedStories; bool get isVerified; bool get acceptsDirectMessages; bool get isOfficialMyitihas;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.followerCount, followerCount) || other.followerCount == followerCount)&&(identical(other.followingCount, followingCount) || other.followingCount == followingCount)&&(identical(other.postCount, postCount) || other.postCount == postCount)&&(identical(other.isFollowing, isFollowing) || other.isFollowing == isFollowing)&&(identical(other.isCurrentUser, isCurrentUser) || other.isCurrentUser == isCurrentUser)&&const DeepCollectionEquality().equals(other.savedStories, savedStories)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.acceptsDirectMessages, acceptsDirectMessages) || other.acceptsDirectMessages == acceptsDirectMessages)&&(identical(other.isOfficialMyitihas, isOfficialMyitihas) || other.isOfficialMyitihas == isOfficialMyitihas));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,displayName,avatarUrl,bio,followerCount,followingCount,postCount,isFollowing,isCurrentUser,const DeepCollectionEquality().hash(savedStories),isVerified,acceptsDirectMessages,isOfficialMyitihas);

@override
String toString() {
  return 'UserModel(id: $id, username: $username, displayName: $displayName, avatarUrl: $avatarUrl, bio: $bio, followerCount: $followerCount, followingCount: $followingCount, postCount: $postCount, isFollowing: $isFollowing, isCurrentUser: $isCurrentUser, savedStories: $savedStories, isVerified: $isVerified, acceptsDirectMessages: $acceptsDirectMessages, isOfficialMyitihas: $isOfficialMyitihas)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
 String id, String username, String displayName, String avatarUrl, String bio, int followerCount, int followingCount, int postCount, bool isFollowing, bool isCurrentUser, List<String> savedStories, bool isVerified, bool acceptsDirectMessages, bool isOfficialMyitihas
});




}
/// @nodoc
class _$UserModelCopyWithImpl<$Res>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? displayName = null,Object? avatarUrl = null,Object? bio = null,Object? followerCount = null,Object? followingCount = null,Object? postCount = null,Object? isFollowing = null,Object? isCurrentUser = null,Object? savedStories = null,Object? isVerified = null,Object? acceptsDirectMessages = null,Object? isOfficialMyitihas = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,followerCount: null == followerCount ? _self.followerCount : followerCount // ignore: cast_nullable_to_non_nullable
as int,followingCount: null == followingCount ? _self.followingCount : followingCount // ignore: cast_nullable_to_non_nullable
as int,postCount: null == postCount ? _self.postCount : postCount // ignore: cast_nullable_to_non_nullable
as int,isFollowing: null == isFollowing ? _self.isFollowing : isFollowing // ignore: cast_nullable_to_non_nullable
as bool,isCurrentUser: null == isCurrentUser ? _self.isCurrentUser : isCurrentUser // ignore: cast_nullable_to_non_nullable
as bool,savedStories: null == savedStories ? _self.savedStories : savedStories // ignore: cast_nullable_to_non_nullable
as List<String>,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,acceptsDirectMessages: null == acceptsDirectMessages ? _self.acceptsDirectMessages : acceptsDirectMessages // ignore: cast_nullable_to_non_nullable
as bool,isOfficialMyitihas: null == isOfficialMyitihas ? _self.isOfficialMyitihas : isOfficialMyitihas // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserModel].
extension UserModelPatterns on UserModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserModel value)  $default,){
final _that = this;
switch (_that) {
case _UserModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username,  String displayName,  String avatarUrl,  String bio,  int followerCount,  int followingCount,  int postCount,  bool isFollowing,  bool isCurrentUser,  List<String> savedStories,  bool isVerified,  bool acceptsDirectMessages,  bool isOfficialMyitihas)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.username,_that.displayName,_that.avatarUrl,_that.bio,_that.followerCount,_that.followingCount,_that.postCount,_that.isFollowing,_that.isCurrentUser,_that.savedStories,_that.isVerified,_that.acceptsDirectMessages,_that.isOfficialMyitihas);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username,  String displayName,  String avatarUrl,  String bio,  int followerCount,  int followingCount,  int postCount,  bool isFollowing,  bool isCurrentUser,  List<String> savedStories,  bool isVerified,  bool acceptsDirectMessages,  bool isOfficialMyitihas)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
return $default(_that.id,_that.username,_that.displayName,_that.avatarUrl,_that.bio,_that.followerCount,_that.followingCount,_that.postCount,_that.isFollowing,_that.isCurrentUser,_that.savedStories,_that.isVerified,_that.acceptsDirectMessages,_that.isOfficialMyitihas);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username,  String displayName,  String avatarUrl,  String bio,  int followerCount,  int followingCount,  int postCount,  bool isFollowing,  bool isCurrentUser,  List<String> savedStories,  bool isVerified,  bool acceptsDirectMessages,  bool isOfficialMyitihas)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.username,_that.displayName,_that.avatarUrl,_that.bio,_that.followerCount,_that.followingCount,_that.postCount,_that.isFollowing,_that.isCurrentUser,_that.savedStories,_that.isVerified,_that.acceptsDirectMessages,_that.isOfficialMyitihas);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserModel extends UserModel {
  const _UserModel({required this.id, required this.username, required this.displayName, required this.avatarUrl, required this.bio, this.followerCount = 0, this.followingCount = 0, this.postCount = 0, this.isFollowing = false, this.isCurrentUser = false, final  List<String> savedStories = const <String>[], this.isVerified = false, this.acceptsDirectMessages = true, this.isOfficialMyitihas = false}): _savedStories = savedStories,super._();
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override final  String id;
@override final  String username;
@override final  String displayName;
@override final  String avatarUrl;
@override final  String bio;
@override@JsonKey() final  int followerCount;
@override@JsonKey() final  int followingCount;
@override@JsonKey() final  int postCount;
@override@JsonKey() final  bool isFollowing;
@override@JsonKey() final  bool isCurrentUser;
 final  List<String> _savedStories;
@override@JsonKey() List<String> get savedStories {
  if (_savedStories is EqualUnmodifiableListView) return _savedStories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_savedStories);
}

@override@JsonKey() final  bool isVerified;
@override@JsonKey() final  bool acceptsDirectMessages;
@override@JsonKey() final  bool isOfficialMyitihas;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserModelCopyWith<_UserModel> get copyWith => __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.followerCount, followerCount) || other.followerCount == followerCount)&&(identical(other.followingCount, followingCount) || other.followingCount == followingCount)&&(identical(other.postCount, postCount) || other.postCount == postCount)&&(identical(other.isFollowing, isFollowing) || other.isFollowing == isFollowing)&&(identical(other.isCurrentUser, isCurrentUser) || other.isCurrentUser == isCurrentUser)&&const DeepCollectionEquality().equals(other._savedStories, _savedStories)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.acceptsDirectMessages, acceptsDirectMessages) || other.acceptsDirectMessages == acceptsDirectMessages)&&(identical(other.isOfficialMyitihas, isOfficialMyitihas) || other.isOfficialMyitihas == isOfficialMyitihas));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,displayName,avatarUrl,bio,followerCount,followingCount,postCount,isFollowing,isCurrentUser,const DeepCollectionEquality().hash(_savedStories),isVerified,acceptsDirectMessages,isOfficialMyitihas);

@override
String toString() {
  return 'UserModel(id: $id, username: $username, displayName: $displayName, avatarUrl: $avatarUrl, bio: $bio, followerCount: $followerCount, followingCount: $followingCount, postCount: $postCount, isFollowing: $isFollowing, isCurrentUser: $isCurrentUser, savedStories: $savedStories, isVerified: $isVerified, acceptsDirectMessages: $acceptsDirectMessages, isOfficialMyitihas: $isOfficialMyitihas)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String username, String displayName, String avatarUrl, String bio, int followerCount, int followingCount, int postCount, bool isFollowing, bool isCurrentUser, List<String> savedStories, bool isVerified, bool acceptsDirectMessages, bool isOfficialMyitihas
});




}
/// @nodoc
class __$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? displayName = null,Object? avatarUrl = null,Object? bio = null,Object? followerCount = null,Object? followingCount = null,Object? postCount = null,Object? isFollowing = null,Object? isCurrentUser = null,Object? savedStories = null,Object? isVerified = null,Object? acceptsDirectMessages = null,Object? isOfficialMyitihas = null,}) {
  return _then(_UserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,followerCount: null == followerCount ? _self.followerCount : followerCount // ignore: cast_nullable_to_non_nullable
as int,followingCount: null == followingCount ? _self.followingCount : followingCount // ignore: cast_nullable_to_non_nullable
as int,postCount: null == postCount ? _self.postCount : postCount // ignore: cast_nullable_to_non_nullable
as int,isFollowing: null == isFollowing ? _self.isFollowing : isFollowing // ignore: cast_nullable_to_non_nullable
as bool,isCurrentUser: null == isCurrentUser ? _self.isCurrentUser : isCurrentUser // ignore: cast_nullable_to_non_nullable
as bool,savedStories: null == savedStories ? _self._savedStories : savedStories // ignore: cast_nullable_to_non_nullable
as List<String>,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,acceptsDirectMessages: null == acceptsDirectMessages ? _self.acceptsDirectMessages : acceptsDirectMessages // ignore: cast_nullable_to_non_nullable
as bool,isOfficialMyitihas: null == isOfficialMyitihas ? _self.isOfficialMyitihas : isOfficialMyitihas // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
