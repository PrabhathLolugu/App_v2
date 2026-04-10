// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProfileEvent()';
}


}

/// @nodoc
class $ProfileEventCopyWith<$Res>  {
$ProfileEventCopyWith(ProfileEvent _, $Res Function(ProfileEvent) __);
}


/// Adds pattern-matching-related methods to [ProfileEvent].
extension ProfileEventPatterns on ProfileEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadProfileEvent value)?  loadProfile,TResult Function( ToggleFollowEvent value)?  toggleFollow,TResult Function( LoadFollowersEvent value)?  loadFollowers,TResult Function( LoadFollowingEvent value)?  loadFollowing,TResult Function( ChangeTabEvent value)?  changeTab,TResult Function( LoadUserPostsEvent value)?  loadUserPosts,TResult Function( ClearFollowErrorEvent value)?  clearFollowError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadProfileEvent() when loadProfile != null:
return loadProfile(_that);case ToggleFollowEvent() when toggleFollow != null:
return toggleFollow(_that);case LoadFollowersEvent() when loadFollowers != null:
return loadFollowers(_that);case LoadFollowingEvent() when loadFollowing != null:
return loadFollowing(_that);case ChangeTabEvent() when changeTab != null:
return changeTab(_that);case LoadUserPostsEvent() when loadUserPosts != null:
return loadUserPosts(_that);case ClearFollowErrorEvent() when clearFollowError != null:
return clearFollowError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadProfileEvent value)  loadProfile,required TResult Function( ToggleFollowEvent value)  toggleFollow,required TResult Function( LoadFollowersEvent value)  loadFollowers,required TResult Function( LoadFollowingEvent value)  loadFollowing,required TResult Function( ChangeTabEvent value)  changeTab,required TResult Function( LoadUserPostsEvent value)  loadUserPosts,required TResult Function( ClearFollowErrorEvent value)  clearFollowError,}){
final _that = this;
switch (_that) {
case LoadProfileEvent():
return loadProfile(_that);case ToggleFollowEvent():
return toggleFollow(_that);case LoadFollowersEvent():
return loadFollowers(_that);case LoadFollowingEvent():
return loadFollowing(_that);case ChangeTabEvent():
return changeTab(_that);case LoadUserPostsEvent():
return loadUserPosts(_that);case ClearFollowErrorEvent():
return clearFollowError(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadProfileEvent value)?  loadProfile,TResult? Function( ToggleFollowEvent value)?  toggleFollow,TResult? Function( LoadFollowersEvent value)?  loadFollowers,TResult? Function( LoadFollowingEvent value)?  loadFollowing,TResult? Function( ChangeTabEvent value)?  changeTab,TResult? Function( LoadUserPostsEvent value)?  loadUserPosts,TResult? Function( ClearFollowErrorEvent value)?  clearFollowError,}){
final _that = this;
switch (_that) {
case LoadProfileEvent() when loadProfile != null:
return loadProfile(_that);case ToggleFollowEvent() when toggleFollow != null:
return toggleFollow(_that);case LoadFollowersEvent() when loadFollowers != null:
return loadFollowers(_that);case LoadFollowingEvent() when loadFollowing != null:
return loadFollowing(_that);case ChangeTabEvent() when changeTab != null:
return changeTab(_that);case LoadUserPostsEvent() when loadUserPosts != null:
return loadUserPosts(_that);case ClearFollowErrorEvent() when clearFollowError != null:
return clearFollowError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String userId)?  loadProfile,TResult Function( String userId)?  toggleFollow,TResult Function( String userId)?  loadFollowers,TResult Function( String userId)?  loadFollowing,TResult Function( int tabIndex)?  changeTab,TResult Function( String userId,  String postType,  bool refresh)?  loadUserPosts,TResult Function()?  clearFollowError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadProfileEvent() when loadProfile != null:
return loadProfile(_that.userId);case ToggleFollowEvent() when toggleFollow != null:
return toggleFollow(_that.userId);case LoadFollowersEvent() when loadFollowers != null:
return loadFollowers(_that.userId);case LoadFollowingEvent() when loadFollowing != null:
return loadFollowing(_that.userId);case ChangeTabEvent() when changeTab != null:
return changeTab(_that.tabIndex);case LoadUserPostsEvent() when loadUserPosts != null:
return loadUserPosts(_that.userId,_that.postType,_that.refresh);case ClearFollowErrorEvent() when clearFollowError != null:
return clearFollowError();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String userId)  loadProfile,required TResult Function( String userId)  toggleFollow,required TResult Function( String userId)  loadFollowers,required TResult Function( String userId)  loadFollowing,required TResult Function( int tabIndex)  changeTab,required TResult Function( String userId,  String postType,  bool refresh)  loadUserPosts,required TResult Function()  clearFollowError,}) {final _that = this;
switch (_that) {
case LoadProfileEvent():
return loadProfile(_that.userId);case ToggleFollowEvent():
return toggleFollow(_that.userId);case LoadFollowersEvent():
return loadFollowers(_that.userId);case LoadFollowingEvent():
return loadFollowing(_that.userId);case ChangeTabEvent():
return changeTab(_that.tabIndex);case LoadUserPostsEvent():
return loadUserPosts(_that.userId,_that.postType,_that.refresh);case ClearFollowErrorEvent():
return clearFollowError();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String userId)?  loadProfile,TResult? Function( String userId)?  toggleFollow,TResult? Function( String userId)?  loadFollowers,TResult? Function( String userId)?  loadFollowing,TResult? Function( int tabIndex)?  changeTab,TResult? Function( String userId,  String postType,  bool refresh)?  loadUserPosts,TResult? Function()?  clearFollowError,}) {final _that = this;
switch (_that) {
case LoadProfileEvent() when loadProfile != null:
return loadProfile(_that.userId);case ToggleFollowEvent() when toggleFollow != null:
return toggleFollow(_that.userId);case LoadFollowersEvent() when loadFollowers != null:
return loadFollowers(_that.userId);case LoadFollowingEvent() when loadFollowing != null:
return loadFollowing(_that.userId);case ChangeTabEvent() when changeTab != null:
return changeTab(_that.tabIndex);case LoadUserPostsEvent() when loadUserPosts != null:
return loadUserPosts(_that.userId,_that.postType,_that.refresh);case ClearFollowErrorEvent() when clearFollowError != null:
return clearFollowError();case _:
  return null;

}
}

}

/// @nodoc


class LoadProfileEvent implements ProfileEvent {
  const LoadProfileEvent(this.userId);
  

 final  String userId;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadProfileEventCopyWith<LoadProfileEvent> get copyWith => _$LoadProfileEventCopyWithImpl<LoadProfileEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadProfileEvent&&(identical(other.userId, userId) || other.userId == userId));
}


@override
int get hashCode => Object.hash(runtimeType,userId);

@override
String toString() {
  return 'ProfileEvent.loadProfile(userId: $userId)';
}


}

/// @nodoc
abstract mixin class $LoadProfileEventCopyWith<$Res> implements $ProfileEventCopyWith<$Res> {
  factory $LoadProfileEventCopyWith(LoadProfileEvent value, $Res Function(LoadProfileEvent) _then) = _$LoadProfileEventCopyWithImpl;
@useResult
$Res call({
 String userId
});




}
/// @nodoc
class _$LoadProfileEventCopyWithImpl<$Res>
    implements $LoadProfileEventCopyWith<$Res> {
  _$LoadProfileEventCopyWithImpl(this._self, this._then);

  final LoadProfileEvent _self;
  final $Res Function(LoadProfileEvent) _then;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userId = null,}) {
  return _then(LoadProfileEvent(
null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ToggleFollowEvent implements ProfileEvent {
  const ToggleFollowEvent(this.userId);
  

 final  String userId;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToggleFollowEventCopyWith<ToggleFollowEvent> get copyWith => _$ToggleFollowEventCopyWithImpl<ToggleFollowEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToggleFollowEvent&&(identical(other.userId, userId) || other.userId == userId));
}


@override
int get hashCode => Object.hash(runtimeType,userId);

@override
String toString() {
  return 'ProfileEvent.toggleFollow(userId: $userId)';
}


}

/// @nodoc
abstract mixin class $ToggleFollowEventCopyWith<$Res> implements $ProfileEventCopyWith<$Res> {
  factory $ToggleFollowEventCopyWith(ToggleFollowEvent value, $Res Function(ToggleFollowEvent) _then) = _$ToggleFollowEventCopyWithImpl;
@useResult
$Res call({
 String userId
});




}
/// @nodoc
class _$ToggleFollowEventCopyWithImpl<$Res>
    implements $ToggleFollowEventCopyWith<$Res> {
  _$ToggleFollowEventCopyWithImpl(this._self, this._then);

  final ToggleFollowEvent _self;
  final $Res Function(ToggleFollowEvent) _then;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userId = null,}) {
  return _then(ToggleFollowEvent(
null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class LoadFollowersEvent implements ProfileEvent {
  const LoadFollowersEvent(this.userId);
  

 final  String userId;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadFollowersEventCopyWith<LoadFollowersEvent> get copyWith => _$LoadFollowersEventCopyWithImpl<LoadFollowersEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadFollowersEvent&&(identical(other.userId, userId) || other.userId == userId));
}


@override
int get hashCode => Object.hash(runtimeType,userId);

@override
String toString() {
  return 'ProfileEvent.loadFollowers(userId: $userId)';
}


}

/// @nodoc
abstract mixin class $LoadFollowersEventCopyWith<$Res> implements $ProfileEventCopyWith<$Res> {
  factory $LoadFollowersEventCopyWith(LoadFollowersEvent value, $Res Function(LoadFollowersEvent) _then) = _$LoadFollowersEventCopyWithImpl;
@useResult
$Res call({
 String userId
});




}
/// @nodoc
class _$LoadFollowersEventCopyWithImpl<$Res>
    implements $LoadFollowersEventCopyWith<$Res> {
  _$LoadFollowersEventCopyWithImpl(this._self, this._then);

  final LoadFollowersEvent _self;
  final $Res Function(LoadFollowersEvent) _then;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userId = null,}) {
  return _then(LoadFollowersEvent(
null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class LoadFollowingEvent implements ProfileEvent {
  const LoadFollowingEvent(this.userId);
  

 final  String userId;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadFollowingEventCopyWith<LoadFollowingEvent> get copyWith => _$LoadFollowingEventCopyWithImpl<LoadFollowingEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadFollowingEvent&&(identical(other.userId, userId) || other.userId == userId));
}


@override
int get hashCode => Object.hash(runtimeType,userId);

@override
String toString() {
  return 'ProfileEvent.loadFollowing(userId: $userId)';
}


}

/// @nodoc
abstract mixin class $LoadFollowingEventCopyWith<$Res> implements $ProfileEventCopyWith<$Res> {
  factory $LoadFollowingEventCopyWith(LoadFollowingEvent value, $Res Function(LoadFollowingEvent) _then) = _$LoadFollowingEventCopyWithImpl;
@useResult
$Res call({
 String userId
});




}
/// @nodoc
class _$LoadFollowingEventCopyWithImpl<$Res>
    implements $LoadFollowingEventCopyWith<$Res> {
  _$LoadFollowingEventCopyWithImpl(this._self, this._then);

  final LoadFollowingEvent _self;
  final $Res Function(LoadFollowingEvent) _then;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userId = null,}) {
  return _then(LoadFollowingEvent(
null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ChangeTabEvent implements ProfileEvent {
  const ChangeTabEvent(this.tabIndex);
  

 final  int tabIndex;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangeTabEventCopyWith<ChangeTabEvent> get copyWith => _$ChangeTabEventCopyWithImpl<ChangeTabEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangeTabEvent&&(identical(other.tabIndex, tabIndex) || other.tabIndex == tabIndex));
}


@override
int get hashCode => Object.hash(runtimeType,tabIndex);

@override
String toString() {
  return 'ProfileEvent.changeTab(tabIndex: $tabIndex)';
}


}

/// @nodoc
abstract mixin class $ChangeTabEventCopyWith<$Res> implements $ProfileEventCopyWith<$Res> {
  factory $ChangeTabEventCopyWith(ChangeTabEvent value, $Res Function(ChangeTabEvent) _then) = _$ChangeTabEventCopyWithImpl;
@useResult
$Res call({
 int tabIndex
});




}
/// @nodoc
class _$ChangeTabEventCopyWithImpl<$Res>
    implements $ChangeTabEventCopyWith<$Res> {
  _$ChangeTabEventCopyWithImpl(this._self, this._then);

  final ChangeTabEvent _self;
  final $Res Function(ChangeTabEvent) _then;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tabIndex = null,}) {
  return _then(ChangeTabEvent(
null == tabIndex ? _self.tabIndex : tabIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class LoadUserPostsEvent implements ProfileEvent {
  const LoadUserPostsEvent({required this.userId, required this.postType, this.refresh = false});
  

 final  String userId;
 final  String postType;
@JsonKey() final  bool refresh;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadUserPostsEventCopyWith<LoadUserPostsEvent> get copyWith => _$LoadUserPostsEventCopyWithImpl<LoadUserPostsEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadUserPostsEvent&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.postType, postType) || other.postType == postType)&&(identical(other.refresh, refresh) || other.refresh == refresh));
}


@override
int get hashCode => Object.hash(runtimeType,userId,postType,refresh);

@override
String toString() {
  return 'ProfileEvent.loadUserPosts(userId: $userId, postType: $postType, refresh: $refresh)';
}


}

/// @nodoc
abstract mixin class $LoadUserPostsEventCopyWith<$Res> implements $ProfileEventCopyWith<$Res> {
  factory $LoadUserPostsEventCopyWith(LoadUserPostsEvent value, $Res Function(LoadUserPostsEvent) _then) = _$LoadUserPostsEventCopyWithImpl;
@useResult
$Res call({
 String userId, String postType, bool refresh
});




}
/// @nodoc
class _$LoadUserPostsEventCopyWithImpl<$Res>
    implements $LoadUserPostsEventCopyWith<$Res> {
  _$LoadUserPostsEventCopyWithImpl(this._self, this._then);

  final LoadUserPostsEvent _self;
  final $Res Function(LoadUserPostsEvent) _then;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? postType = null,Object? refresh = null,}) {
  return _then(LoadUserPostsEvent(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,postType: null == postType ? _self.postType : postType // ignore: cast_nullable_to_non_nullable
as String,refresh: null == refresh ? _self.refresh : refresh // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class ClearFollowErrorEvent implements ProfileEvent {
  const ClearFollowErrorEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClearFollowErrorEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProfileEvent.clearFollowError()';
}


}




// dart format on
