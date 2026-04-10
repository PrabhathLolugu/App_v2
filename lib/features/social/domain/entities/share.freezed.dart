// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'share.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Share {

 String get userId; String get contentId; String get contentType;// 'post' or 'story'
 ShareType get shareType; String? get recipientId;// For DM shares
 String? get repostId;// For repost shares, the new post id
 DateTime get timestamp;
/// Create a copy of Share
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShareCopyWith<Share> get copyWith => _$ShareCopyWithImpl<Share>(this as Share, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Share&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.contentId, contentId) || other.contentId == contentId)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.shareType, shareType) || other.shareType == shareType)&&(identical(other.recipientId, recipientId) || other.recipientId == recipientId)&&(identical(other.repostId, repostId) || other.repostId == repostId)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}


@override
int get hashCode => Object.hash(runtimeType,userId,contentId,contentType,shareType,recipientId,repostId,timestamp);

@override
String toString() {
  return 'Share(userId: $userId, contentId: $contentId, contentType: $contentType, shareType: $shareType, recipientId: $recipientId, repostId: $repostId, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $ShareCopyWith<$Res>  {
  factory $ShareCopyWith(Share value, $Res Function(Share) _then) = _$ShareCopyWithImpl;
@useResult
$Res call({
 String userId, String contentId, String contentType, ShareType shareType, String? recipientId, String? repostId, DateTime timestamp
});




}
/// @nodoc
class _$ShareCopyWithImpl<$Res>
    implements $ShareCopyWith<$Res> {
  _$ShareCopyWithImpl(this._self, this._then);

  final Share _self;
  final $Res Function(Share) _then;

/// Create a copy of Share
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? contentId = null,Object? contentType = null,Object? shareType = null,Object? recipientId = freezed,Object? repostId = freezed,Object? timestamp = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,contentId: null == contentId ? _self.contentId : contentId // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,shareType: null == shareType ? _self.shareType : shareType // ignore: cast_nullable_to_non_nullable
as ShareType,recipientId: freezed == recipientId ? _self.recipientId : recipientId // ignore: cast_nullable_to_non_nullable
as String?,repostId: freezed == repostId ? _self.repostId : repostId // ignore: cast_nullable_to_non_nullable
as String?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Share].
extension SharePatterns on Share {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Share value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Share() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Share value)  $default,){
final _that = this;
switch (_that) {
case _Share():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Share value)?  $default,){
final _that = this;
switch (_that) {
case _Share() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String contentId,  String contentType,  ShareType shareType,  String? recipientId,  String? repostId,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Share() when $default != null:
return $default(_that.userId,_that.contentId,_that.contentType,_that.shareType,_that.recipientId,_that.repostId,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String contentId,  String contentType,  ShareType shareType,  String? recipientId,  String? repostId,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _Share():
return $default(_that.userId,_that.contentId,_that.contentType,_that.shareType,_that.recipientId,_that.repostId,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String contentId,  String contentType,  ShareType shareType,  String? recipientId,  String? repostId,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _Share() when $default != null:
return $default(_that.userId,_that.contentId,_that.contentType,_that.shareType,_that.recipientId,_that.repostId,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc


class _Share extends Share {
  const _Share({required this.userId, required this.contentId, required this.contentType, required this.shareType, this.recipientId, this.repostId, required this.timestamp}): super._();
  

@override final  String userId;
@override final  String contentId;
@override final  String contentType;
// 'post' or 'story'
@override final  ShareType shareType;
@override final  String? recipientId;
// For DM shares
@override final  String? repostId;
// For repost shares, the new post id
@override final  DateTime timestamp;

/// Create a copy of Share
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShareCopyWith<_Share> get copyWith => __$ShareCopyWithImpl<_Share>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Share&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.contentId, contentId) || other.contentId == contentId)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.shareType, shareType) || other.shareType == shareType)&&(identical(other.recipientId, recipientId) || other.recipientId == recipientId)&&(identical(other.repostId, repostId) || other.repostId == repostId)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}


@override
int get hashCode => Object.hash(runtimeType,userId,contentId,contentType,shareType,recipientId,repostId,timestamp);

@override
String toString() {
  return 'Share(userId: $userId, contentId: $contentId, contentType: $contentType, shareType: $shareType, recipientId: $recipientId, repostId: $repostId, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$ShareCopyWith<$Res> implements $ShareCopyWith<$Res> {
  factory _$ShareCopyWith(_Share value, $Res Function(_Share) _then) = __$ShareCopyWithImpl;
@override @useResult
$Res call({
 String userId, String contentId, String contentType, ShareType shareType, String? recipientId, String? repostId, DateTime timestamp
});




}
/// @nodoc
class __$ShareCopyWithImpl<$Res>
    implements _$ShareCopyWith<$Res> {
  __$ShareCopyWithImpl(this._self, this._then);

  final _Share _self;
  final $Res Function(_Share) _then;

/// Create a copy of Share
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? contentId = null,Object? contentType = null,Object? shareType = null,Object? recipientId = freezed,Object? repostId = freezed,Object? timestamp = null,}) {
  return _then(_Share(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,contentId: null == contentId ? _self.contentId : contentId // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,shareType: null == shareType ? _self.shareType : shareType // ignore: cast_nullable_to_non_nullable
as ShareType,recipientId: freezed == recipientId ? _self.recipientId : recipientId // ignore: cast_nullable_to_non_nullable
as String?,repostId: freezed == repostId ? _self.repostId : repostId // ignore: cast_nullable_to_non_nullable
as String?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
