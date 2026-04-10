// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connectivity_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConnectivityEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectivityEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConnectivityEvent()';
}


}

/// @nodoc
class $ConnectivityEventCopyWith<$Res>  {
$ConnectivityEventCopyWith(ConnectivityEvent _, $Res Function(ConnectivityEvent) __);
}


/// Adds pattern-matching-related methods to [ConnectivityEvent].
extension ConnectivityEventPatterns on ConnectivityEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CheckConnectivityEvent value)?  checkConnectivity,TResult Function( ConnectivityChangedEvent value)?  connectivityChanged,TResult Function( AppLifecycleChangedEvent value)?  appLifecycleChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CheckConnectivityEvent() when checkConnectivity != null:
return checkConnectivity(_that);case ConnectivityChangedEvent() when connectivityChanged != null:
return connectivityChanged(_that);case AppLifecycleChangedEvent() when appLifecycleChanged != null:
return appLifecycleChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CheckConnectivityEvent value)  checkConnectivity,required TResult Function( ConnectivityChangedEvent value)  connectivityChanged,required TResult Function( AppLifecycleChangedEvent value)  appLifecycleChanged,}){
final _that = this;
switch (_that) {
case CheckConnectivityEvent():
return checkConnectivity(_that);case ConnectivityChangedEvent():
return connectivityChanged(_that);case AppLifecycleChangedEvent():
return appLifecycleChanged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CheckConnectivityEvent value)?  checkConnectivity,TResult? Function( ConnectivityChangedEvent value)?  connectivityChanged,TResult? Function( AppLifecycleChangedEvent value)?  appLifecycleChanged,}){
final _that = this;
switch (_that) {
case CheckConnectivityEvent() when checkConnectivity != null:
return checkConnectivity(_that);case ConnectivityChangedEvent() when connectivityChanged != null:
return connectivityChanged(_that);case AppLifecycleChangedEvent() when appLifecycleChanged != null:
return appLifecycleChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  checkConnectivity,TResult Function( InternetStatus status)?  connectivityChanged,TResult Function( AppLifecycleState state)?  appLifecycleChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CheckConnectivityEvent() when checkConnectivity != null:
return checkConnectivity();case ConnectivityChangedEvent() when connectivityChanged != null:
return connectivityChanged(_that.status);case AppLifecycleChangedEvent() when appLifecycleChanged != null:
return appLifecycleChanged(_that.state);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  checkConnectivity,required TResult Function( InternetStatus status)  connectivityChanged,required TResult Function( AppLifecycleState state)  appLifecycleChanged,}) {final _that = this;
switch (_that) {
case CheckConnectivityEvent():
return checkConnectivity();case ConnectivityChangedEvent():
return connectivityChanged(_that.status);case AppLifecycleChangedEvent():
return appLifecycleChanged(_that.state);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  checkConnectivity,TResult? Function( InternetStatus status)?  connectivityChanged,TResult? Function( AppLifecycleState state)?  appLifecycleChanged,}) {final _that = this;
switch (_that) {
case CheckConnectivityEvent() when checkConnectivity != null:
return checkConnectivity();case ConnectivityChangedEvent() when connectivityChanged != null:
return connectivityChanged(_that.status);case AppLifecycleChangedEvent() when appLifecycleChanged != null:
return appLifecycleChanged(_that.state);case _:
  return null;

}
}

}

/// @nodoc


class CheckConnectivityEvent implements ConnectivityEvent {
  const CheckConnectivityEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckConnectivityEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConnectivityEvent.checkConnectivity()';
}


}




/// @nodoc


class ConnectivityChangedEvent implements ConnectivityEvent {
  const ConnectivityChangedEvent(this.status);
  

 final  InternetStatus status;

/// Create a copy of ConnectivityEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectivityChangedEventCopyWith<ConnectivityChangedEvent> get copyWith => _$ConnectivityChangedEventCopyWithImpl<ConnectivityChangedEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectivityChangedEvent&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,status);

@override
String toString() {
  return 'ConnectivityEvent.connectivityChanged(status: $status)';
}


}

/// @nodoc
abstract mixin class $ConnectivityChangedEventCopyWith<$Res> implements $ConnectivityEventCopyWith<$Res> {
  factory $ConnectivityChangedEventCopyWith(ConnectivityChangedEvent value, $Res Function(ConnectivityChangedEvent) _then) = _$ConnectivityChangedEventCopyWithImpl;
@useResult
$Res call({
 InternetStatus status
});




}
/// @nodoc
class _$ConnectivityChangedEventCopyWithImpl<$Res>
    implements $ConnectivityChangedEventCopyWith<$Res> {
  _$ConnectivityChangedEventCopyWithImpl(this._self, this._then);

  final ConnectivityChangedEvent _self;
  final $Res Function(ConnectivityChangedEvent) _then;

/// Create a copy of ConnectivityEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? status = null,}) {
  return _then(ConnectivityChangedEvent(
null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InternetStatus,
  ));
}


}

/// @nodoc


class AppLifecycleChangedEvent implements ConnectivityEvent {
  const AppLifecycleChangedEvent(this.state);
  

 final  AppLifecycleState state;

/// Create a copy of ConnectivityEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppLifecycleChangedEventCopyWith<AppLifecycleChangedEvent> get copyWith => _$AppLifecycleChangedEventCopyWithImpl<AppLifecycleChangedEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppLifecycleChangedEvent&&(identical(other.state, state) || other.state == state));
}


@override
int get hashCode => Object.hash(runtimeType,state);

@override
String toString() {
  return 'ConnectivityEvent.appLifecycleChanged(state: $state)';
}


}

/// @nodoc
abstract mixin class $AppLifecycleChangedEventCopyWith<$Res> implements $ConnectivityEventCopyWith<$Res> {
  factory $AppLifecycleChangedEventCopyWith(AppLifecycleChangedEvent value, $Res Function(AppLifecycleChangedEvent) _then) = _$AppLifecycleChangedEventCopyWithImpl;
@useResult
$Res call({
 AppLifecycleState state
});




}
/// @nodoc
class _$AppLifecycleChangedEventCopyWithImpl<$Res>
    implements $AppLifecycleChangedEventCopyWith<$Res> {
  _$AppLifecycleChangedEventCopyWithImpl(this._self, this._then);

  final AppLifecycleChangedEvent _self;
  final $Res Function(AppLifecycleChangedEvent) _then;

/// Create a copy of ConnectivityEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? state = null,}) {
  return _then(AppLifecycleChangedEvent(
null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as AppLifecycleState,
  ));
}


}

// dart format on
