// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cache_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CacheConfig {

 int get imageCacheSizeBytes;// 500 MB default
 int get videoCacheSizeBytes;// 300 MB default
 int get audioCacheSizeBytes;// 200 MB default
 bool get wifiOnlyMode;
/// Create a copy of CacheConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CacheConfigCopyWith<CacheConfig> get copyWith => _$CacheConfigCopyWithImpl<CacheConfig>(this as CacheConfig, _$identity);

  /// Serializes this CacheConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CacheConfig&&(identical(other.imageCacheSizeBytes, imageCacheSizeBytes) || other.imageCacheSizeBytes == imageCacheSizeBytes)&&(identical(other.videoCacheSizeBytes, videoCacheSizeBytes) || other.videoCacheSizeBytes == videoCacheSizeBytes)&&(identical(other.audioCacheSizeBytes, audioCacheSizeBytes) || other.audioCacheSizeBytes == audioCacheSizeBytes)&&(identical(other.wifiOnlyMode, wifiOnlyMode) || other.wifiOnlyMode == wifiOnlyMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imageCacheSizeBytes,videoCacheSizeBytes,audioCacheSizeBytes,wifiOnlyMode);

@override
String toString() {
  return 'CacheConfig(imageCacheSizeBytes: $imageCacheSizeBytes, videoCacheSizeBytes: $videoCacheSizeBytes, audioCacheSizeBytes: $audioCacheSizeBytes, wifiOnlyMode: $wifiOnlyMode)';
}


}

/// @nodoc
abstract mixin class $CacheConfigCopyWith<$Res>  {
  factory $CacheConfigCopyWith(CacheConfig value, $Res Function(CacheConfig) _then) = _$CacheConfigCopyWithImpl;
@useResult
$Res call({
 int imageCacheSizeBytes, int videoCacheSizeBytes, int audioCacheSizeBytes, bool wifiOnlyMode
});




}
/// @nodoc
class _$CacheConfigCopyWithImpl<$Res>
    implements $CacheConfigCopyWith<$Res> {
  _$CacheConfigCopyWithImpl(this._self, this._then);

  final CacheConfig _self;
  final $Res Function(CacheConfig) _then;

/// Create a copy of CacheConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? imageCacheSizeBytes = null,Object? videoCacheSizeBytes = null,Object? audioCacheSizeBytes = null,Object? wifiOnlyMode = null,}) {
  return _then(_self.copyWith(
imageCacheSizeBytes: null == imageCacheSizeBytes ? _self.imageCacheSizeBytes : imageCacheSizeBytes // ignore: cast_nullable_to_non_nullable
as int,videoCacheSizeBytes: null == videoCacheSizeBytes ? _self.videoCacheSizeBytes : videoCacheSizeBytes // ignore: cast_nullable_to_non_nullable
as int,audioCacheSizeBytes: null == audioCacheSizeBytes ? _self.audioCacheSizeBytes : audioCacheSizeBytes // ignore: cast_nullable_to_non_nullable
as int,wifiOnlyMode: null == wifiOnlyMode ? _self.wifiOnlyMode : wifiOnlyMode // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CacheConfig].
extension CacheConfigPatterns on CacheConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CacheConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CacheConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CacheConfig value)  $default,){
final _that = this;
switch (_that) {
case _CacheConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CacheConfig value)?  $default,){
final _that = this;
switch (_that) {
case _CacheConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int imageCacheSizeBytes,  int videoCacheSizeBytes,  int audioCacheSizeBytes,  bool wifiOnlyMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CacheConfig() when $default != null:
return $default(_that.imageCacheSizeBytes,_that.videoCacheSizeBytes,_that.audioCacheSizeBytes,_that.wifiOnlyMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int imageCacheSizeBytes,  int videoCacheSizeBytes,  int audioCacheSizeBytes,  bool wifiOnlyMode)  $default,) {final _that = this;
switch (_that) {
case _CacheConfig():
return $default(_that.imageCacheSizeBytes,_that.videoCacheSizeBytes,_that.audioCacheSizeBytes,_that.wifiOnlyMode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int imageCacheSizeBytes,  int videoCacheSizeBytes,  int audioCacheSizeBytes,  bool wifiOnlyMode)?  $default,) {final _that = this;
switch (_that) {
case _CacheConfig() when $default != null:
return $default(_that.imageCacheSizeBytes,_that.videoCacheSizeBytes,_that.audioCacheSizeBytes,_that.wifiOnlyMode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CacheConfig implements CacheConfig {
  const _CacheConfig({this.imageCacheSizeBytes = 500 * 1024 * 1024, this.videoCacheSizeBytes = 300 * 1024 * 1024, this.audioCacheSizeBytes = 200 * 1024 * 1024, this.wifiOnlyMode = false});
  factory _CacheConfig.fromJson(Map<String, dynamic> json) => _$CacheConfigFromJson(json);

@override@JsonKey() final  int imageCacheSizeBytes;
// 500 MB default
@override@JsonKey() final  int videoCacheSizeBytes;
// 300 MB default
@override@JsonKey() final  int audioCacheSizeBytes;
// 200 MB default
@override@JsonKey() final  bool wifiOnlyMode;

/// Create a copy of CacheConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CacheConfigCopyWith<_CacheConfig> get copyWith => __$CacheConfigCopyWithImpl<_CacheConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CacheConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CacheConfig&&(identical(other.imageCacheSizeBytes, imageCacheSizeBytes) || other.imageCacheSizeBytes == imageCacheSizeBytes)&&(identical(other.videoCacheSizeBytes, videoCacheSizeBytes) || other.videoCacheSizeBytes == videoCacheSizeBytes)&&(identical(other.audioCacheSizeBytes, audioCacheSizeBytes) || other.audioCacheSizeBytes == audioCacheSizeBytes)&&(identical(other.wifiOnlyMode, wifiOnlyMode) || other.wifiOnlyMode == wifiOnlyMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imageCacheSizeBytes,videoCacheSizeBytes,audioCacheSizeBytes,wifiOnlyMode);

@override
String toString() {
  return 'CacheConfig(imageCacheSizeBytes: $imageCacheSizeBytes, videoCacheSizeBytes: $videoCacheSizeBytes, audioCacheSizeBytes: $audioCacheSizeBytes, wifiOnlyMode: $wifiOnlyMode)';
}


}

/// @nodoc
abstract mixin class _$CacheConfigCopyWith<$Res> implements $CacheConfigCopyWith<$Res> {
  factory _$CacheConfigCopyWith(_CacheConfig value, $Res Function(_CacheConfig) _then) = __$CacheConfigCopyWithImpl;
@override @useResult
$Res call({
 int imageCacheSizeBytes, int videoCacheSizeBytes, int audioCacheSizeBytes, bool wifiOnlyMode
});




}
/// @nodoc
class __$CacheConfigCopyWithImpl<$Res>
    implements _$CacheConfigCopyWith<$Res> {
  __$CacheConfigCopyWithImpl(this._self, this._then);

  final _CacheConfig _self;
  final $Res Function(_CacheConfig) _then;

/// Create a copy of CacheConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? imageCacheSizeBytes = null,Object? videoCacheSizeBytes = null,Object? audioCacheSizeBytes = null,Object? wifiOnlyMode = null,}) {
  return _then(_CacheConfig(
imageCacheSizeBytes: null == imageCacheSizeBytes ? _self.imageCacheSizeBytes : imageCacheSizeBytes // ignore: cast_nullable_to_non_nullable
as int,videoCacheSizeBytes: null == videoCacheSizeBytes ? _self.videoCacheSizeBytes : videoCacheSizeBytes // ignore: cast_nullable_to_non_nullable
as int,audioCacheSizeBytes: null == audioCacheSizeBytes ? _self.audioCacheSizeBytes : audioCacheSizeBytes // ignore: cast_nullable_to_non_nullable
as int,wifiOnlyMode: null == wifiOnlyMode ? _self.wifiOnlyMode : wifiOnlyMode // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
