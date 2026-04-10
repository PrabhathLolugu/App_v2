// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'like.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Like {

 String get userId; String get contentId; String get contentType; DateTime get timestamp;
/// Create a copy of Like
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LikeCopyWith<Like> get copyWith => _$LikeCopyWithImpl<Like>(this as Like, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Like&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.contentId, contentId) || other.contentId == contentId)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}


@override
int get hashCode => Object.hash(runtimeType,userId,contentId,contentType,timestamp);

@override
String toString() {
  return 'Like(userId: $userId, contentId: $contentId, contentType: $contentType, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $LikeCopyWith<$Res>  {
  factory $LikeCopyWith(Like value, $Res Function(Like) _then) = _$LikeCopyWithImpl;
@useResult
$Res call({
 String userId, String contentId, String contentType, DateTime timestamp
});




}
/// @nodoc
class _$LikeCopyWithImpl<$Res>
    implements $LikeCopyWith<$Res> {
  _$LikeCopyWithImpl(this._self, this._then);

  final Like _self;
  final $Res Function(Like) _then;

/// Create a copy of Like
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? contentId = null,Object? contentType = null,Object? timestamp = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,contentId: null == contentId ? _self.contentId : contentId // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Like].
extension LikePatterns on Like {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Like value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Like() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Like value)  $default,){
final _that = this;
switch (_that) {
case _Like():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Like value)?  $default,){
final _that = this;
switch (_that) {
case _Like() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String contentId,  String contentType,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Like() when $default != null:
return $default(_that.userId,_that.contentId,_that.contentType,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String contentId,  String contentType,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _Like():
return $default(_that.userId,_that.contentId,_that.contentType,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String contentId,  String contentType,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _Like() when $default != null:
return $default(_that.userId,_that.contentId,_that.contentType,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc


class _Like extends Like {
  const _Like({required this.userId, required this.contentId, this.contentType = 'story', required this.timestamp}): super._();
  

@override final  String userId;
@override final  String contentId;
@override@JsonKey() final  String contentType;
@override final  DateTime timestamp;

/// Create a copy of Like
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LikeCopyWith<_Like> get copyWith => __$LikeCopyWithImpl<_Like>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Like&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.contentId, contentId) || other.contentId == contentId)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}


@override
int get hashCode => Object.hash(runtimeType,userId,contentId,contentType,timestamp);

@override
String toString() {
  return 'Like(userId: $userId, contentId: $contentId, contentType: $contentType, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$LikeCopyWith<$Res> implements $LikeCopyWith<$Res> {
  factory _$LikeCopyWith(_Like value, $Res Function(_Like) _then) = __$LikeCopyWithImpl;
@override @useResult
$Res call({
 String userId, String contentId, String contentType, DateTime timestamp
});




}
/// @nodoc
class __$LikeCopyWithImpl<$Res>
    implements _$LikeCopyWith<$Res> {
  __$LikeCopyWithImpl(this._self, this._then);

  final _Like _self;
  final $Res Function(_Like) _then;

/// Create a copy of Like
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? contentId = null,Object? contentType = null,Object? timestamp = null,}) {
  return _then(_Like(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,contentId: null == contentId ? _self.contentId : contentId // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
