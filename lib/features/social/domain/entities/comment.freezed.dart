// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Comment {

 String get id; String get contentId;// ID of the story/post being commented on
 String get contentType;// 'story', 'post'
 String get userId; String get userName; String get userAvatar; String get text; DateTime get createdAt; int get likeCount; String? get parentCommentId;// null for top-level comments
 List<Comment> get replies; int get depth;// 0 for top-level, max 3
 bool get isCollapsed; bool get isLikedByCurrentUser;
/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentCopyWith<Comment> get copyWith => _$CommentCopyWithImpl<Comment>(this as Comment, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Comment&&(identical(other.id, id) || other.id == id)&&(identical(other.contentId, contentId) || other.contentId == contentId)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userAvatar, userAvatar) || other.userAvatar == userAvatar)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.parentCommentId, parentCommentId) || other.parentCommentId == parentCommentId)&&const DeepCollectionEquality().equals(other.replies, replies)&&(identical(other.depth, depth) || other.depth == depth)&&(identical(other.isCollapsed, isCollapsed) || other.isCollapsed == isCollapsed)&&(identical(other.isLikedByCurrentUser, isLikedByCurrentUser) || other.isLikedByCurrentUser == isLikedByCurrentUser));
}


@override
int get hashCode => Object.hash(runtimeType,id,contentId,contentType,userId,userName,userAvatar,text,createdAt,likeCount,parentCommentId,const DeepCollectionEquality().hash(replies),depth,isCollapsed,isLikedByCurrentUser);

@override
String toString() {
  return 'Comment(id: $id, contentId: $contentId, contentType: $contentType, userId: $userId, userName: $userName, userAvatar: $userAvatar, text: $text, createdAt: $createdAt, likeCount: $likeCount, parentCommentId: $parentCommentId, replies: $replies, depth: $depth, isCollapsed: $isCollapsed, isLikedByCurrentUser: $isLikedByCurrentUser)';
}


}

/// @nodoc
abstract mixin class $CommentCopyWith<$Res>  {
  factory $CommentCopyWith(Comment value, $Res Function(Comment) _then) = _$CommentCopyWithImpl;
@useResult
$Res call({
 String id, String contentId, String contentType, String userId, String userName, String userAvatar, String text, DateTime createdAt, int likeCount, String? parentCommentId, List<Comment> replies, int depth, bool isCollapsed, bool isLikedByCurrentUser
});




}
/// @nodoc
class _$CommentCopyWithImpl<$Res>
    implements $CommentCopyWith<$Res> {
  _$CommentCopyWithImpl(this._self, this._then);

  final Comment _self;
  final $Res Function(Comment) _then;

/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? contentId = null,Object? contentType = null,Object? userId = null,Object? userName = null,Object? userAvatar = null,Object? text = null,Object? createdAt = null,Object? likeCount = null,Object? parentCommentId = freezed,Object? replies = null,Object? depth = null,Object? isCollapsed = null,Object? isLikedByCurrentUser = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,contentId: null == contentId ? _self.contentId : contentId // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,userAvatar: null == userAvatar ? _self.userAvatar : userAvatar // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,parentCommentId: freezed == parentCommentId ? _self.parentCommentId : parentCommentId // ignore: cast_nullable_to_non_nullable
as String?,replies: null == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as List<Comment>,depth: null == depth ? _self.depth : depth // ignore: cast_nullable_to_non_nullable
as int,isCollapsed: null == isCollapsed ? _self.isCollapsed : isCollapsed // ignore: cast_nullable_to_non_nullable
as bool,isLikedByCurrentUser: null == isLikedByCurrentUser ? _self.isLikedByCurrentUser : isLikedByCurrentUser // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Comment].
extension CommentPatterns on Comment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Comment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Comment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Comment value)  $default,){
final _that = this;
switch (_that) {
case _Comment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Comment value)?  $default,){
final _that = this;
switch (_that) {
case _Comment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String contentId,  String contentType,  String userId,  String userName,  String userAvatar,  String text,  DateTime createdAt,  int likeCount,  String? parentCommentId,  List<Comment> replies,  int depth,  bool isCollapsed,  bool isLikedByCurrentUser)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Comment() when $default != null:
return $default(_that.id,_that.contentId,_that.contentType,_that.userId,_that.userName,_that.userAvatar,_that.text,_that.createdAt,_that.likeCount,_that.parentCommentId,_that.replies,_that.depth,_that.isCollapsed,_that.isLikedByCurrentUser);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String contentId,  String contentType,  String userId,  String userName,  String userAvatar,  String text,  DateTime createdAt,  int likeCount,  String? parentCommentId,  List<Comment> replies,  int depth,  bool isCollapsed,  bool isLikedByCurrentUser)  $default,) {final _that = this;
switch (_that) {
case _Comment():
return $default(_that.id,_that.contentId,_that.contentType,_that.userId,_that.userName,_that.userAvatar,_that.text,_that.createdAt,_that.likeCount,_that.parentCommentId,_that.replies,_that.depth,_that.isCollapsed,_that.isLikedByCurrentUser);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String contentId,  String contentType,  String userId,  String userName,  String userAvatar,  String text,  DateTime createdAt,  int likeCount,  String? parentCommentId,  List<Comment> replies,  int depth,  bool isCollapsed,  bool isLikedByCurrentUser)?  $default,) {final _that = this;
switch (_that) {
case _Comment() when $default != null:
return $default(_that.id,_that.contentId,_that.contentType,_that.userId,_that.userName,_that.userAvatar,_that.text,_that.createdAt,_that.likeCount,_that.parentCommentId,_that.replies,_that.depth,_that.isCollapsed,_that.isLikedByCurrentUser);case _:
  return null;

}
}

}

/// @nodoc


class _Comment extends Comment {
  const _Comment({required this.id, required this.contentId, this.contentType = 'story', required this.userId, required this.userName, required this.userAvatar, required this.text, required this.createdAt, this.likeCount = 0, this.parentCommentId, final  List<Comment> replies = const [], this.depth = 0, this.isCollapsed = false, this.isLikedByCurrentUser = false}): _replies = replies,super._();
  

@override final  String id;
@override final  String contentId;
// ID of the story/post being commented on
@override@JsonKey() final  String contentType;
// 'story', 'post'
@override final  String userId;
@override final  String userName;
@override final  String userAvatar;
@override final  String text;
@override final  DateTime createdAt;
@override@JsonKey() final  int likeCount;
@override final  String? parentCommentId;
// null for top-level comments
 final  List<Comment> _replies;
// null for top-level comments
@override@JsonKey() List<Comment> get replies {
  if (_replies is EqualUnmodifiableListView) return _replies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_replies);
}

@override@JsonKey() final  int depth;
// 0 for top-level, max 3
@override@JsonKey() final  bool isCollapsed;
@override@JsonKey() final  bool isLikedByCurrentUser;

/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentCopyWith<_Comment> get copyWith => __$CommentCopyWithImpl<_Comment>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Comment&&(identical(other.id, id) || other.id == id)&&(identical(other.contentId, contentId) || other.contentId == contentId)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userAvatar, userAvatar) || other.userAvatar == userAvatar)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.parentCommentId, parentCommentId) || other.parentCommentId == parentCommentId)&&const DeepCollectionEquality().equals(other._replies, _replies)&&(identical(other.depth, depth) || other.depth == depth)&&(identical(other.isCollapsed, isCollapsed) || other.isCollapsed == isCollapsed)&&(identical(other.isLikedByCurrentUser, isLikedByCurrentUser) || other.isLikedByCurrentUser == isLikedByCurrentUser));
}


@override
int get hashCode => Object.hash(runtimeType,id,contentId,contentType,userId,userName,userAvatar,text,createdAt,likeCount,parentCommentId,const DeepCollectionEquality().hash(_replies),depth,isCollapsed,isLikedByCurrentUser);

@override
String toString() {
  return 'Comment(id: $id, contentId: $contentId, contentType: $contentType, userId: $userId, userName: $userName, userAvatar: $userAvatar, text: $text, createdAt: $createdAt, likeCount: $likeCount, parentCommentId: $parentCommentId, replies: $replies, depth: $depth, isCollapsed: $isCollapsed, isLikedByCurrentUser: $isLikedByCurrentUser)';
}


}

/// @nodoc
abstract mixin class _$CommentCopyWith<$Res> implements $CommentCopyWith<$Res> {
  factory _$CommentCopyWith(_Comment value, $Res Function(_Comment) _then) = __$CommentCopyWithImpl;
@override @useResult
$Res call({
 String id, String contentId, String contentType, String userId, String userName, String userAvatar, String text, DateTime createdAt, int likeCount, String? parentCommentId, List<Comment> replies, int depth, bool isCollapsed, bool isLikedByCurrentUser
});




}
/// @nodoc
class __$CommentCopyWithImpl<$Res>
    implements _$CommentCopyWith<$Res> {
  __$CommentCopyWithImpl(this._self, this._then);

  final _Comment _self;
  final $Res Function(_Comment) _then;

/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? contentId = null,Object? contentType = null,Object? userId = null,Object? userName = null,Object? userAvatar = null,Object? text = null,Object? createdAt = null,Object? likeCount = null,Object? parentCommentId = freezed,Object? replies = null,Object? depth = null,Object? isCollapsed = null,Object? isLikedByCurrentUser = null,}) {
  return _then(_Comment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,contentId: null == contentId ? _self.contentId : contentId // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,userAvatar: null == userAvatar ? _self.userAvatar : userAvatar // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,parentCommentId: freezed == parentCommentId ? _self.parentCommentId : parentCommentId // ignore: cast_nullable_to_non_nullable
as String?,replies: null == replies ? _self._replies : replies // ignore: cast_nullable_to_non_nullable
as List<Comment>,depth: null == depth ? _self.depth : depth // ignore: cast_nullable_to_non_nullable
as int,isCollapsed: null == isCollapsed ? _self.isCollapsed : isCollapsed // ignore: cast_nullable_to_non_nullable
as bool,isLikedByCurrentUser: null == isLikedByCurrentUser ? _self.isLikedByCurrentUser : isLikedByCurrentUser // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
