// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cache_settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CacheSettingsState {

 CacheConfig get config; int get imageUsageBytes; int get videoUsageBytes; int get audioUsageBytes; bool get isLoading; String? get errorMessage;
/// Create a copy of CacheSettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CacheSettingsStateCopyWith<CacheSettingsState> get copyWith => _$CacheSettingsStateCopyWithImpl<CacheSettingsState>(this as CacheSettingsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CacheSettingsState&&(identical(other.config, config) || other.config == config)&&(identical(other.imageUsageBytes, imageUsageBytes) || other.imageUsageBytes == imageUsageBytes)&&(identical(other.videoUsageBytes, videoUsageBytes) || other.videoUsageBytes == videoUsageBytes)&&(identical(other.audioUsageBytes, audioUsageBytes) || other.audioUsageBytes == audioUsageBytes)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,config,imageUsageBytes,videoUsageBytes,audioUsageBytes,isLoading,errorMessage);

@override
String toString() {
  return 'CacheSettingsState(config: $config, imageUsageBytes: $imageUsageBytes, videoUsageBytes: $videoUsageBytes, audioUsageBytes: $audioUsageBytes, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $CacheSettingsStateCopyWith<$Res>  {
  factory $CacheSettingsStateCopyWith(CacheSettingsState value, $Res Function(CacheSettingsState) _then) = _$CacheSettingsStateCopyWithImpl;
@useResult
$Res call({
 CacheConfig config, int imageUsageBytes, int videoUsageBytes, int audioUsageBytes, bool isLoading, String? errorMessage
});


$CacheConfigCopyWith<$Res> get config;

}
/// @nodoc
class _$CacheSettingsStateCopyWithImpl<$Res>
    implements $CacheSettingsStateCopyWith<$Res> {
  _$CacheSettingsStateCopyWithImpl(this._self, this._then);

  final CacheSettingsState _self;
  final $Res Function(CacheSettingsState) _then;

/// Create a copy of CacheSettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? config = null,Object? imageUsageBytes = null,Object? videoUsageBytes = null,Object? audioUsageBytes = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as CacheConfig,imageUsageBytes: null == imageUsageBytes ? _self.imageUsageBytes : imageUsageBytes // ignore: cast_nullable_to_non_nullable
as int,videoUsageBytes: null == videoUsageBytes ? _self.videoUsageBytes : videoUsageBytes // ignore: cast_nullable_to_non_nullable
as int,audioUsageBytes: null == audioUsageBytes ? _self.audioUsageBytes : audioUsageBytes // ignore: cast_nullable_to_non_nullable
as int,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of CacheSettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CacheConfigCopyWith<$Res> get config {
  
  return $CacheConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}


/// Adds pattern-matching-related methods to [CacheSettingsState].
extension CacheSettingsStatePatterns on CacheSettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CacheSettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CacheSettingsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CacheSettingsState value)  $default,){
final _that = this;
switch (_that) {
case _CacheSettingsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CacheSettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _CacheSettingsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CacheConfig config,  int imageUsageBytes,  int videoUsageBytes,  int audioUsageBytes,  bool isLoading,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CacheSettingsState() when $default != null:
return $default(_that.config,_that.imageUsageBytes,_that.videoUsageBytes,_that.audioUsageBytes,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CacheConfig config,  int imageUsageBytes,  int videoUsageBytes,  int audioUsageBytes,  bool isLoading,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _CacheSettingsState():
return $default(_that.config,_that.imageUsageBytes,_that.videoUsageBytes,_that.audioUsageBytes,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CacheConfig config,  int imageUsageBytes,  int videoUsageBytes,  int audioUsageBytes,  bool isLoading,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _CacheSettingsState() when $default != null:
return $default(_that.config,_that.imageUsageBytes,_that.videoUsageBytes,_that.audioUsageBytes,_that.isLoading,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _CacheSettingsState implements CacheSettingsState {
  const _CacheSettingsState({required this.config, required this.imageUsageBytes, required this.videoUsageBytes, required this.audioUsageBytes, this.isLoading = false, this.errorMessage});
  

@override final  CacheConfig config;
@override final  int imageUsageBytes;
@override final  int videoUsageBytes;
@override final  int audioUsageBytes;
@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;

/// Create a copy of CacheSettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CacheSettingsStateCopyWith<_CacheSettingsState> get copyWith => __$CacheSettingsStateCopyWithImpl<_CacheSettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CacheSettingsState&&(identical(other.config, config) || other.config == config)&&(identical(other.imageUsageBytes, imageUsageBytes) || other.imageUsageBytes == imageUsageBytes)&&(identical(other.videoUsageBytes, videoUsageBytes) || other.videoUsageBytes == videoUsageBytes)&&(identical(other.audioUsageBytes, audioUsageBytes) || other.audioUsageBytes == audioUsageBytes)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,config,imageUsageBytes,videoUsageBytes,audioUsageBytes,isLoading,errorMessage);

@override
String toString() {
  return 'CacheSettingsState(config: $config, imageUsageBytes: $imageUsageBytes, videoUsageBytes: $videoUsageBytes, audioUsageBytes: $audioUsageBytes, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$CacheSettingsStateCopyWith<$Res> implements $CacheSettingsStateCopyWith<$Res> {
  factory _$CacheSettingsStateCopyWith(_CacheSettingsState value, $Res Function(_CacheSettingsState) _then) = __$CacheSettingsStateCopyWithImpl;
@override @useResult
$Res call({
 CacheConfig config, int imageUsageBytes, int videoUsageBytes, int audioUsageBytes, bool isLoading, String? errorMessage
});


@override $CacheConfigCopyWith<$Res> get config;

}
/// @nodoc
class __$CacheSettingsStateCopyWithImpl<$Res>
    implements _$CacheSettingsStateCopyWith<$Res> {
  __$CacheSettingsStateCopyWithImpl(this._self, this._then);

  final _CacheSettingsState _self;
  final $Res Function(_CacheSettingsState) _then;

/// Create a copy of CacheSettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? config = null,Object? imageUsageBytes = null,Object? videoUsageBytes = null,Object? audioUsageBytes = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_CacheSettingsState(
config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as CacheConfig,imageUsageBytes: null == imageUsageBytes ? _self.imageUsageBytes : imageUsageBytes // ignore: cast_nullable_to_non_nullable
as int,videoUsageBytes: null == videoUsageBytes ? _self.videoUsageBytes : videoUsageBytes // ignore: cast_nullable_to_non_nullable
as int,audioUsageBytes: null == audioUsageBytes ? _self.audioUsageBytes : audioUsageBytes // ignore: cast_nullable_to_non_nullable
as int,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of CacheSettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CacheConfigCopyWith<$Res> get config {
  
  return $CacheConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}

// dart format on
