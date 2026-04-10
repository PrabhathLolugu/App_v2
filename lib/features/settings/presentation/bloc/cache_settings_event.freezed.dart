// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cache_settings_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CacheSettingsEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CacheSettingsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CacheSettingsEvent()';
}


}

/// @nodoc
class $CacheSettingsEventCopyWith<$Res>  {
$CacheSettingsEventCopyWith(CacheSettingsEvent _, $Res Function(CacheSettingsEvent) __);
}


/// Adds pattern-matching-related methods to [CacheSettingsEvent].
extension CacheSettingsEventPatterns on CacheSettingsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadSettingsEvent value)?  loadSettings,TResult Function( UpdateImageCacheSizeEvent value)?  updateImageCacheSize,TResult Function( UpdateVideoCacheSizeEvent value)?  updateVideoCacheSize,TResult Function( UpdateAudioCacheSizeEvent value)?  updateAudioCacheSize,TResult Function( ToggleWifiOnlyEvent value)?  toggleWifiOnly,TResult Function( ClearCacheEvent value)?  clearCache,TResult Function( RefreshUsageEvent value)?  refreshUsage,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadSettingsEvent() when loadSettings != null:
return loadSettings(_that);case UpdateImageCacheSizeEvent() when updateImageCacheSize != null:
return updateImageCacheSize(_that);case UpdateVideoCacheSizeEvent() when updateVideoCacheSize != null:
return updateVideoCacheSize(_that);case UpdateAudioCacheSizeEvent() when updateAudioCacheSize != null:
return updateAudioCacheSize(_that);case ToggleWifiOnlyEvent() when toggleWifiOnly != null:
return toggleWifiOnly(_that);case ClearCacheEvent() when clearCache != null:
return clearCache(_that);case RefreshUsageEvent() when refreshUsage != null:
return refreshUsage(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadSettingsEvent value)  loadSettings,required TResult Function( UpdateImageCacheSizeEvent value)  updateImageCacheSize,required TResult Function( UpdateVideoCacheSizeEvent value)  updateVideoCacheSize,required TResult Function( UpdateAudioCacheSizeEvent value)  updateAudioCacheSize,required TResult Function( ToggleWifiOnlyEvent value)  toggleWifiOnly,required TResult Function( ClearCacheEvent value)  clearCache,required TResult Function( RefreshUsageEvent value)  refreshUsage,}){
final _that = this;
switch (_that) {
case LoadSettingsEvent():
return loadSettings(_that);case UpdateImageCacheSizeEvent():
return updateImageCacheSize(_that);case UpdateVideoCacheSizeEvent():
return updateVideoCacheSize(_that);case UpdateAudioCacheSizeEvent():
return updateAudioCacheSize(_that);case ToggleWifiOnlyEvent():
return toggleWifiOnly(_that);case ClearCacheEvent():
return clearCache(_that);case RefreshUsageEvent():
return refreshUsage(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadSettingsEvent value)?  loadSettings,TResult? Function( UpdateImageCacheSizeEvent value)?  updateImageCacheSize,TResult? Function( UpdateVideoCacheSizeEvent value)?  updateVideoCacheSize,TResult? Function( UpdateAudioCacheSizeEvent value)?  updateAudioCacheSize,TResult? Function( ToggleWifiOnlyEvent value)?  toggleWifiOnly,TResult? Function( ClearCacheEvent value)?  clearCache,TResult? Function( RefreshUsageEvent value)?  refreshUsage,}){
final _that = this;
switch (_that) {
case LoadSettingsEvent() when loadSettings != null:
return loadSettings(_that);case UpdateImageCacheSizeEvent() when updateImageCacheSize != null:
return updateImageCacheSize(_that);case UpdateVideoCacheSizeEvent() when updateVideoCacheSize != null:
return updateVideoCacheSize(_that);case UpdateAudioCacheSizeEvent() when updateAudioCacheSize != null:
return updateAudioCacheSize(_that);case ToggleWifiOnlyEvent() when toggleWifiOnly != null:
return toggleWifiOnly(_that);case ClearCacheEvent() when clearCache != null:
return clearCache(_that);case RefreshUsageEvent() when refreshUsage != null:
return refreshUsage(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadSettings,TResult Function( int sizeBytes)?  updateImageCacheSize,TResult Function( int sizeBytes)?  updateVideoCacheSize,TResult Function( int sizeBytes)?  updateAudioCacheSize,TResult Function( bool enabled)?  toggleWifiOnly,TResult Function()?  clearCache,TResult Function()?  refreshUsage,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadSettingsEvent() when loadSettings != null:
return loadSettings();case UpdateImageCacheSizeEvent() when updateImageCacheSize != null:
return updateImageCacheSize(_that.sizeBytes);case UpdateVideoCacheSizeEvent() when updateVideoCacheSize != null:
return updateVideoCacheSize(_that.sizeBytes);case UpdateAudioCacheSizeEvent() when updateAudioCacheSize != null:
return updateAudioCacheSize(_that.sizeBytes);case ToggleWifiOnlyEvent() when toggleWifiOnly != null:
return toggleWifiOnly(_that.enabled);case ClearCacheEvent() when clearCache != null:
return clearCache();case RefreshUsageEvent() when refreshUsage != null:
return refreshUsage();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadSettings,required TResult Function( int sizeBytes)  updateImageCacheSize,required TResult Function( int sizeBytes)  updateVideoCacheSize,required TResult Function( int sizeBytes)  updateAudioCacheSize,required TResult Function( bool enabled)  toggleWifiOnly,required TResult Function()  clearCache,required TResult Function()  refreshUsage,}) {final _that = this;
switch (_that) {
case LoadSettingsEvent():
return loadSettings();case UpdateImageCacheSizeEvent():
return updateImageCacheSize(_that.sizeBytes);case UpdateVideoCacheSizeEvent():
return updateVideoCacheSize(_that.sizeBytes);case UpdateAudioCacheSizeEvent():
return updateAudioCacheSize(_that.sizeBytes);case ToggleWifiOnlyEvent():
return toggleWifiOnly(_that.enabled);case ClearCacheEvent():
return clearCache();case RefreshUsageEvent():
return refreshUsage();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadSettings,TResult? Function( int sizeBytes)?  updateImageCacheSize,TResult? Function( int sizeBytes)?  updateVideoCacheSize,TResult? Function( int sizeBytes)?  updateAudioCacheSize,TResult? Function( bool enabled)?  toggleWifiOnly,TResult? Function()?  clearCache,TResult? Function()?  refreshUsage,}) {final _that = this;
switch (_that) {
case LoadSettingsEvent() when loadSettings != null:
return loadSettings();case UpdateImageCacheSizeEvent() when updateImageCacheSize != null:
return updateImageCacheSize(_that.sizeBytes);case UpdateVideoCacheSizeEvent() when updateVideoCacheSize != null:
return updateVideoCacheSize(_that.sizeBytes);case UpdateAudioCacheSizeEvent() when updateAudioCacheSize != null:
return updateAudioCacheSize(_that.sizeBytes);case ToggleWifiOnlyEvent() when toggleWifiOnly != null:
return toggleWifiOnly(_that.enabled);case ClearCacheEvent() when clearCache != null:
return clearCache();case RefreshUsageEvent() when refreshUsage != null:
return refreshUsage();case _:
  return null;

}
}

}

/// @nodoc


class LoadSettingsEvent implements CacheSettingsEvent {
  const LoadSettingsEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadSettingsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CacheSettingsEvent.loadSettings()';
}


}




/// @nodoc


class UpdateImageCacheSizeEvent implements CacheSettingsEvent {
  const UpdateImageCacheSizeEvent(this.sizeBytes);
  

 final  int sizeBytes;

/// Create a copy of CacheSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateImageCacheSizeEventCopyWith<UpdateImageCacheSizeEvent> get copyWith => _$UpdateImageCacheSizeEventCopyWithImpl<UpdateImageCacheSizeEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateImageCacheSizeEvent&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes));
}


@override
int get hashCode => Object.hash(runtimeType,sizeBytes);

@override
String toString() {
  return 'CacheSettingsEvent.updateImageCacheSize(sizeBytes: $sizeBytes)';
}


}

/// @nodoc
abstract mixin class $UpdateImageCacheSizeEventCopyWith<$Res> implements $CacheSettingsEventCopyWith<$Res> {
  factory $UpdateImageCacheSizeEventCopyWith(UpdateImageCacheSizeEvent value, $Res Function(UpdateImageCacheSizeEvent) _then) = _$UpdateImageCacheSizeEventCopyWithImpl;
@useResult
$Res call({
 int sizeBytes
});




}
/// @nodoc
class _$UpdateImageCacheSizeEventCopyWithImpl<$Res>
    implements $UpdateImageCacheSizeEventCopyWith<$Res> {
  _$UpdateImageCacheSizeEventCopyWithImpl(this._self, this._then);

  final UpdateImageCacheSizeEvent _self;
  final $Res Function(UpdateImageCacheSizeEvent) _then;

/// Create a copy of CacheSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? sizeBytes = null,}) {
  return _then(UpdateImageCacheSizeEvent(
null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class UpdateVideoCacheSizeEvent implements CacheSettingsEvent {
  const UpdateVideoCacheSizeEvent(this.sizeBytes);
  

 final  int sizeBytes;

/// Create a copy of CacheSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateVideoCacheSizeEventCopyWith<UpdateVideoCacheSizeEvent> get copyWith => _$UpdateVideoCacheSizeEventCopyWithImpl<UpdateVideoCacheSizeEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateVideoCacheSizeEvent&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes));
}


@override
int get hashCode => Object.hash(runtimeType,sizeBytes);

@override
String toString() {
  return 'CacheSettingsEvent.updateVideoCacheSize(sizeBytes: $sizeBytes)';
}


}

/// @nodoc
abstract mixin class $UpdateVideoCacheSizeEventCopyWith<$Res> implements $CacheSettingsEventCopyWith<$Res> {
  factory $UpdateVideoCacheSizeEventCopyWith(UpdateVideoCacheSizeEvent value, $Res Function(UpdateVideoCacheSizeEvent) _then) = _$UpdateVideoCacheSizeEventCopyWithImpl;
@useResult
$Res call({
 int sizeBytes
});




}
/// @nodoc
class _$UpdateVideoCacheSizeEventCopyWithImpl<$Res>
    implements $UpdateVideoCacheSizeEventCopyWith<$Res> {
  _$UpdateVideoCacheSizeEventCopyWithImpl(this._self, this._then);

  final UpdateVideoCacheSizeEvent _self;
  final $Res Function(UpdateVideoCacheSizeEvent) _then;

/// Create a copy of CacheSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? sizeBytes = null,}) {
  return _then(UpdateVideoCacheSizeEvent(
null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class UpdateAudioCacheSizeEvent implements CacheSettingsEvent {
  const UpdateAudioCacheSizeEvent(this.sizeBytes);
  

 final  int sizeBytes;

/// Create a copy of CacheSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateAudioCacheSizeEventCopyWith<UpdateAudioCacheSizeEvent> get copyWith => _$UpdateAudioCacheSizeEventCopyWithImpl<UpdateAudioCacheSizeEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateAudioCacheSizeEvent&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes));
}


@override
int get hashCode => Object.hash(runtimeType,sizeBytes);

@override
String toString() {
  return 'CacheSettingsEvent.updateAudioCacheSize(sizeBytes: $sizeBytes)';
}


}

/// @nodoc
abstract mixin class $UpdateAudioCacheSizeEventCopyWith<$Res> implements $CacheSettingsEventCopyWith<$Res> {
  factory $UpdateAudioCacheSizeEventCopyWith(UpdateAudioCacheSizeEvent value, $Res Function(UpdateAudioCacheSizeEvent) _then) = _$UpdateAudioCacheSizeEventCopyWithImpl;
@useResult
$Res call({
 int sizeBytes
});




}
/// @nodoc
class _$UpdateAudioCacheSizeEventCopyWithImpl<$Res>
    implements $UpdateAudioCacheSizeEventCopyWith<$Res> {
  _$UpdateAudioCacheSizeEventCopyWithImpl(this._self, this._then);

  final UpdateAudioCacheSizeEvent _self;
  final $Res Function(UpdateAudioCacheSizeEvent) _then;

/// Create a copy of CacheSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? sizeBytes = null,}) {
  return _then(UpdateAudioCacheSizeEvent(
null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ToggleWifiOnlyEvent implements CacheSettingsEvent {
  const ToggleWifiOnlyEvent(this.enabled);
  

 final  bool enabled;

/// Create a copy of CacheSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToggleWifiOnlyEventCopyWith<ToggleWifiOnlyEvent> get copyWith => _$ToggleWifiOnlyEventCopyWithImpl<ToggleWifiOnlyEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToggleWifiOnlyEvent&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode => Object.hash(runtimeType,enabled);

@override
String toString() {
  return 'CacheSettingsEvent.toggleWifiOnly(enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class $ToggleWifiOnlyEventCopyWith<$Res> implements $CacheSettingsEventCopyWith<$Res> {
  factory $ToggleWifiOnlyEventCopyWith(ToggleWifiOnlyEvent value, $Res Function(ToggleWifiOnlyEvent) _then) = _$ToggleWifiOnlyEventCopyWithImpl;
@useResult
$Res call({
 bool enabled
});




}
/// @nodoc
class _$ToggleWifiOnlyEventCopyWithImpl<$Res>
    implements $ToggleWifiOnlyEventCopyWith<$Res> {
  _$ToggleWifiOnlyEventCopyWithImpl(this._self, this._then);

  final ToggleWifiOnlyEvent _self;
  final $Res Function(ToggleWifiOnlyEvent) _then;

/// Create a copy of CacheSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? enabled = null,}) {
  return _then(ToggleWifiOnlyEvent(
null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class ClearCacheEvent implements CacheSettingsEvent {
  const ClearCacheEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClearCacheEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CacheSettingsEvent.clearCache()';
}


}




/// @nodoc


class RefreshUsageEvent implements CacheSettingsEvent {
  const RefreshUsageEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefreshUsageEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CacheSettingsEvent.refreshUsage()';
}


}




// dart format on
