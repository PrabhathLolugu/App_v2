// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationPageState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationPageState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationPageState()';
}


}

/// @nodoc
class $NotificationPageStateCopyWith<$Res>  {
$NotificationPageStateCopyWith(NotificationPageState _, $Res Function(NotificationPageState) __);
}


/// Adds pattern-matching-related methods to [NotificationPageState].
extension NotificationPageStatePatterns on NotificationPageState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NotificationPageInitial value)?  initial,TResult Function( NotificationPageLoading value)?  loading,TResult Function( NotificationPageLoaded value)?  loaded,TResult Function( NotificationPageError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NotificationPageInitial() when initial != null:
return initial(_that);case NotificationPageLoading() when loading != null:
return loading(_that);case NotificationPageLoaded() when loaded != null:
return loaded(_that);case NotificationPageError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NotificationPageInitial value)  initial,required TResult Function( NotificationPageLoading value)  loading,required TResult Function( NotificationPageLoaded value)  loaded,required TResult Function( NotificationPageError value)  error,}){
final _that = this;
switch (_that) {
case NotificationPageInitial():
return initial(_that);case NotificationPageLoading():
return loading(_that);case NotificationPageLoaded():
return loaded(_that);case NotificationPageError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NotificationPageInitial value)?  initial,TResult? Function( NotificationPageLoading value)?  loading,TResult? Function( NotificationPageLoaded value)?  loaded,TResult? Function( NotificationPageError value)?  error,}){
final _that = this;
switch (_that) {
case NotificationPageInitial() when initial != null:
return initial(_that);case NotificationPageLoading() when loading != null:
return loading(_that);case NotificationPageLoaded() when loaded != null:
return loaded(_that);case NotificationPageError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<NotificationItem> notifications,  bool hasMore,  bool isLoadingMore)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NotificationPageInitial() when initial != null:
return initial();case NotificationPageLoading() when loading != null:
return loading();case NotificationPageLoaded() when loaded != null:
return loaded(_that.notifications,_that.hasMore,_that.isLoadingMore);case NotificationPageError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<NotificationItem> notifications,  bool hasMore,  bool isLoadingMore)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case NotificationPageInitial():
return initial();case NotificationPageLoading():
return loading();case NotificationPageLoaded():
return loaded(_that.notifications,_that.hasMore,_that.isLoadingMore);case NotificationPageError():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<NotificationItem> notifications,  bool hasMore,  bool isLoadingMore)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case NotificationPageInitial() when initial != null:
return initial();case NotificationPageLoading() when loading != null:
return loading();case NotificationPageLoaded() when loaded != null:
return loaded(_that.notifications,_that.hasMore,_that.isLoadingMore);case NotificationPageError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class NotificationPageInitial implements NotificationPageState {
  const NotificationPageInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationPageInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationPageState.initial()';
}


}




/// @nodoc


class NotificationPageLoading implements NotificationPageState {
  const NotificationPageLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationPageLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationPageState.loading()';
}


}




/// @nodoc


class NotificationPageLoaded implements NotificationPageState {
  const NotificationPageLoaded({required final  List<NotificationItem> notifications, required this.hasMore, this.isLoadingMore = false}): _notifications = notifications;
  

 final  List<NotificationItem> _notifications;
 List<NotificationItem> get notifications {
  if (_notifications is EqualUnmodifiableListView) return _notifications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notifications);
}

 final  bool hasMore;
@JsonKey() final  bool isLoadingMore;

/// Create a copy of NotificationPageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationPageLoadedCopyWith<NotificationPageLoaded> get copyWith => _$NotificationPageLoadedCopyWithImpl<NotificationPageLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationPageLoaded&&const DeepCollectionEquality().equals(other._notifications, _notifications)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_notifications),hasMore,isLoadingMore);

@override
String toString() {
  return 'NotificationPageState.loaded(notifications: $notifications, hasMore: $hasMore, isLoadingMore: $isLoadingMore)';
}


}

/// @nodoc
abstract mixin class $NotificationPageLoadedCopyWith<$Res> implements $NotificationPageStateCopyWith<$Res> {
  factory $NotificationPageLoadedCopyWith(NotificationPageLoaded value, $Res Function(NotificationPageLoaded) _then) = _$NotificationPageLoadedCopyWithImpl;
@useResult
$Res call({
 List<NotificationItem> notifications, bool hasMore, bool isLoadingMore
});




}
/// @nodoc
class _$NotificationPageLoadedCopyWithImpl<$Res>
    implements $NotificationPageLoadedCopyWith<$Res> {
  _$NotificationPageLoadedCopyWithImpl(this._self, this._then);

  final NotificationPageLoaded _self;
  final $Res Function(NotificationPageLoaded) _then;

/// Create a copy of NotificationPageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? notifications = null,Object? hasMore = null,Object? isLoadingMore = null,}) {
  return _then(NotificationPageLoaded(
notifications: null == notifications ? _self._notifications : notifications // ignore: cast_nullable_to_non_nullable
as List<NotificationItem>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class NotificationPageError implements NotificationPageState {
  const NotificationPageError(this.message);
  

 final  String message;

/// Create a copy of NotificationPageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationPageErrorCopyWith<NotificationPageError> get copyWith => _$NotificationPageErrorCopyWithImpl<NotificationPageError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationPageError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'NotificationPageState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $NotificationPageErrorCopyWith<$Res> implements $NotificationPageStateCopyWith<$Res> {
  factory $NotificationPageErrorCopyWith(NotificationPageError value, $Res Function(NotificationPageError) _then) = _$NotificationPageErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$NotificationPageErrorCopyWithImpl<$Res>
    implements $NotificationPageErrorCopyWith<$Res> {
  _$NotificationPageErrorCopyWithImpl(this._self, this._then);

  final NotificationPageError _self;
  final $Res Function(NotificationPageError) _then;

/// Create a copy of NotificationPageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(NotificationPageError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
