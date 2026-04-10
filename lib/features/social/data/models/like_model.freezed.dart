// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'like_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LikeModel {

 String get userId; String get contentId; String get contentType; DateTime get timestamp;
/// Create a copy of LikeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LikeModelCopyWith<LikeModel> get copyWith => _$LikeModelCopyWithImpl<LikeModel>(this as LikeModel, _$identity);

  /// Serializes this LikeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LikeModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.contentId, contentId) || other.contentId == contentId)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,contentId,contentType,timestamp);

@override
String toString() {
  return 'LikeModel(userId: $userId, contentId: $contentId, contentType: $contentType, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $LikeModelCopyWith<$Res>  {
  factory $LikeModelCopyWith(LikeModel value, $Res Function(LikeModel) _then) = _$LikeModelCopyWithImpl;
@useResult
$Res call({
 String userId, String contentId, String contentType, DateTime timestamp
});




}
/// @nodoc
class _$LikeModelCopyWithImpl<$Res>
    implements $LikeModelCopyWith<$Res> {
  _$LikeModelCopyWithImpl(this._self, this._then);

  final LikeModel _self;
  final $Res Function(LikeModel) _then;

/// Create a copy of LikeModel
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


/// Adds pattern-matching-related methods to [LikeModel].
extension LikeModelPatterns on LikeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LikeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LikeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LikeModel value)  $default,){
final _that = this;
switch (_that) {
case _LikeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LikeModel value)?  $default,){
final _that = this;
switch (_that) {
case _LikeModel() when $default != null:
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
case _LikeModel() when $default != null:
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
case _LikeModel():
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
case _LikeModel() when $default != null:
return $default(_that.userId,_that.contentId,_that.contentType,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LikeModel extends LikeModel {
  const _LikeModel({required this.userId, required this.contentId, this.contentType = 'story', required this.timestamp}): super._();
  factory _LikeModel.fromJson(Map<String, dynamic> json) => _$LikeModelFromJson(json);

@override final  String userId;
@override final  String contentId;
@override@JsonKey() final  String contentType;
@override final  DateTime timestamp;

/// Create a copy of LikeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LikeModelCopyWith<_LikeModel> get copyWith => __$LikeModelCopyWithImpl<_LikeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LikeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LikeModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.contentId, contentId) || other.contentId == contentId)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,contentId,contentType,timestamp);

@override
String toString() {
  return 'LikeModel(userId: $userId, contentId: $contentId, contentType: $contentType, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$LikeModelCopyWith<$Res> implements $LikeModelCopyWith<$Res> {
  factory _$LikeModelCopyWith(_LikeModel value, $Res Function(_LikeModel) _then) = __$LikeModelCopyWithImpl;
@override @useResult
$Res call({
 String userId, String contentId, String contentType, DateTime timestamp
});




}
/// @nodoc
class __$LikeModelCopyWithImpl<$Res>
    implements _$LikeModelCopyWith<$Res> {
  __$LikeModelCopyWithImpl(this._self, this._then);

  final _LikeModel _self;
  final $Res Function(_LikeModel) _then;

/// Create a copy of LikeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? contentId = null,Object? contentType = null,Object? timestamp = null,}) {
  return _then(_LikeModel(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,contentId: null == contentId ? _self.contentId : contentId // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
