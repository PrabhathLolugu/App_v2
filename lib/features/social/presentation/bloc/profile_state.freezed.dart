// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProfileState()';
}


}

/// @nodoc
class $ProfileStateCopyWith<$Res>  {
$ProfileStateCopyWith(ProfileState _, $Res Function(ProfileState) __);
}


/// Adds pattern-matching-related methods to [ProfileState].
extension ProfileStatePatterns on ProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ProfileInitial value)?  initial,TResult Function( ProfileLoading value)?  loading,TResult Function( ProfileLoaded value)?  loaded,TResult Function( ProfileError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ProfileInitial() when initial != null:
return initial(_that);case ProfileLoading() when loading != null:
return loading(_that);case ProfileLoaded() when loaded != null:
return loaded(_that);case ProfileError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ProfileInitial value)  initial,required TResult Function( ProfileLoading value)  loading,required TResult Function( ProfileLoaded value)  loaded,required TResult Function( ProfileError value)  error,}){
final _that = this;
switch (_that) {
case ProfileInitial():
return initial(_that);case ProfileLoading():
return loading(_that);case ProfileLoaded():
return loaded(_that);case ProfileError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ProfileInitial value)?  initial,TResult? Function( ProfileLoading value)?  loading,TResult? Function( ProfileLoaded value)?  loaded,TResult? Function( ProfileError value)?  error,}){
final _that = this;
switch (_that) {
case ProfileInitial() when initial != null:
return initial(_that);case ProfileLoading() when loading != null:
return loading(_that);case ProfileLoaded() when loaded != null:
return loaded(_that);case ProfileError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( User user,  List<User> followers,  List<User> following,  bool isLoadingFollowers,  bool isLoadingFollowing,  int currentTab,  List<FeedItem> posts,  List<FeedItem> scheduledPosts,  bool isLoadingPosts,  bool hasMorePosts,  Map<String, List<FeedItem>> cachedPostsByType,  Map<String, bool> hasMorePostsByType,  String? followError)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ProfileInitial() when initial != null:
return initial();case ProfileLoading() when loading != null:
return loading();case ProfileLoaded() when loaded != null:
return loaded(_that.user,_that.followers,_that.following,_that.isLoadingFollowers,_that.isLoadingFollowing,_that.currentTab,_that.posts,_that.scheduledPosts,_that.isLoadingPosts,_that.hasMorePosts,_that.cachedPostsByType,_that.hasMorePostsByType,_that.followError);case ProfileError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( User user,  List<User> followers,  List<User> following,  bool isLoadingFollowers,  bool isLoadingFollowing,  int currentTab,  List<FeedItem> posts,  List<FeedItem> scheduledPosts,  bool isLoadingPosts,  bool hasMorePosts,  Map<String, List<FeedItem>> cachedPostsByType,  Map<String, bool> hasMorePostsByType,  String? followError)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case ProfileInitial():
return initial();case ProfileLoading():
return loading();case ProfileLoaded():
return loaded(_that.user,_that.followers,_that.following,_that.isLoadingFollowers,_that.isLoadingFollowing,_that.currentTab,_that.posts,_that.scheduledPosts,_that.isLoadingPosts,_that.hasMorePosts,_that.cachedPostsByType,_that.hasMorePostsByType,_that.followError);case ProfileError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( User user,  List<User> followers,  List<User> following,  bool isLoadingFollowers,  bool isLoadingFollowing,  int currentTab,  List<FeedItem> posts,  List<FeedItem> scheduledPosts,  bool isLoadingPosts,  bool hasMorePosts,  Map<String, List<FeedItem>> cachedPostsByType,  Map<String, bool> hasMorePostsByType,  String? followError)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case ProfileInitial() when initial != null:
return initial();case ProfileLoading() when loading != null:
return loading();case ProfileLoaded() when loaded != null:
return loaded(_that.user,_that.followers,_that.following,_that.isLoadingFollowers,_that.isLoadingFollowing,_that.currentTab,_that.posts,_that.scheduledPosts,_that.isLoadingPosts,_that.hasMorePosts,_that.cachedPostsByType,_that.hasMorePostsByType,_that.followError);case ProfileError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ProfileInitial extends ProfileState {
  const ProfileInitial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProfileState.initial()';
}


}




/// @nodoc


class ProfileLoading extends ProfileState {
  const ProfileLoading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProfileState.loading()';
}


}




/// @nodoc


class ProfileLoaded extends ProfileState {
  const ProfileLoaded({required this.user, final  List<User> followers = const [], final  List<User> following = const [], this.isLoadingFollowers = false, this.isLoadingFollowing = false, this.currentTab = 0, final  List<FeedItem> posts = const [], final  List<FeedItem> scheduledPosts = const [], this.isLoadingPosts = false, this.hasMorePosts = true, final  Map<String, List<FeedItem>> cachedPostsByType = const {}, final  Map<String, bool> hasMorePostsByType = const {}, this.followError}): _followers = followers,_following = following,_posts = posts,_scheduledPosts = scheduledPosts,_cachedPostsByType = cachedPostsByType,_hasMorePostsByType = hasMorePostsByType,super._();
  

 final  User user;
 final  List<User> _followers;
@JsonKey() List<User> get followers {
  if (_followers is EqualUnmodifiableListView) return _followers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_followers);
}

 final  List<User> _following;
@JsonKey() List<User> get following {
  if (_following is EqualUnmodifiableListView) return _following;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_following);
}

@JsonKey() final  bool isLoadingFollowers;
@JsonKey() final  bool isLoadingFollowing;
@JsonKey() final  int currentTab;
 final  List<FeedItem> _posts;
@JsonKey() List<FeedItem> get posts {
  if (_posts is EqualUnmodifiableListView) return _posts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posts);
}

 final  List<FeedItem> _scheduledPosts;
@JsonKey() List<FeedItem> get scheduledPosts {
  if (_scheduledPosts is EqualUnmodifiableListView) return _scheduledPosts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_scheduledPosts);
}

@JsonKey() final  bool isLoadingPosts;
@JsonKey() final  bool hasMorePosts;
 final  Map<String, List<FeedItem>> _cachedPostsByType;
@JsonKey() Map<String, List<FeedItem>> get cachedPostsByType {
  if (_cachedPostsByType is EqualUnmodifiableMapView) return _cachedPostsByType;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_cachedPostsByType);
}

 final  Map<String, bool> _hasMorePostsByType;
@JsonKey() Map<String, bool> get hasMorePostsByType {
  if (_hasMorePostsByType is EqualUnmodifiableMapView) return _hasMorePostsByType;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_hasMorePostsByType);
}

 final  String? followError;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileLoadedCopyWith<ProfileLoaded> get copyWith => _$ProfileLoadedCopyWithImpl<ProfileLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileLoaded&&(identical(other.user, user) || other.user == user)&&const DeepCollectionEquality().equals(other._followers, _followers)&&const DeepCollectionEquality().equals(other._following, _following)&&(identical(other.isLoadingFollowers, isLoadingFollowers) || other.isLoadingFollowers == isLoadingFollowers)&&(identical(other.isLoadingFollowing, isLoadingFollowing) || other.isLoadingFollowing == isLoadingFollowing)&&(identical(other.currentTab, currentTab) || other.currentTab == currentTab)&&const DeepCollectionEquality().equals(other._posts, _posts)&&const DeepCollectionEquality().equals(other._scheduledPosts, _scheduledPosts)&&(identical(other.isLoadingPosts, isLoadingPosts) || other.isLoadingPosts == isLoadingPosts)&&(identical(other.hasMorePosts, hasMorePosts) || other.hasMorePosts == hasMorePosts)&&const DeepCollectionEquality().equals(other._cachedPostsByType, _cachedPostsByType)&&const DeepCollectionEquality().equals(other._hasMorePostsByType, _hasMorePostsByType)&&(identical(other.followError, followError) || other.followError == followError));
}


@override
int get hashCode => Object.hash(runtimeType,user,const DeepCollectionEquality().hash(_followers),const DeepCollectionEquality().hash(_following),isLoadingFollowers,isLoadingFollowing,currentTab,const DeepCollectionEquality().hash(_posts),const DeepCollectionEquality().hash(_scheduledPosts),isLoadingPosts,hasMorePosts,const DeepCollectionEquality().hash(_cachedPostsByType),const DeepCollectionEquality().hash(_hasMorePostsByType),followError);

@override
String toString() {
  return 'ProfileState.loaded(user: $user, followers: $followers, following: $following, isLoadingFollowers: $isLoadingFollowers, isLoadingFollowing: $isLoadingFollowing, currentTab: $currentTab, posts: $posts, scheduledPosts: $scheduledPosts, isLoadingPosts: $isLoadingPosts, hasMorePosts: $hasMorePosts, cachedPostsByType: $cachedPostsByType, hasMorePostsByType: $hasMorePostsByType, followError: $followError)';
}


}

/// @nodoc
abstract mixin class $ProfileLoadedCopyWith<$Res> implements $ProfileStateCopyWith<$Res> {
  factory $ProfileLoadedCopyWith(ProfileLoaded value, $Res Function(ProfileLoaded) _then) = _$ProfileLoadedCopyWithImpl;
@useResult
$Res call({
 User user, List<User> followers, List<User> following, bool isLoadingFollowers, bool isLoadingFollowing, int currentTab, List<FeedItem> posts, List<FeedItem> scheduledPosts, bool isLoadingPosts, bool hasMorePosts, Map<String, List<FeedItem>> cachedPostsByType, Map<String, bool> hasMorePostsByType, String? followError
});


$UserCopyWith<$Res> get user;

}
/// @nodoc
class _$ProfileLoadedCopyWithImpl<$Res>
    implements $ProfileLoadedCopyWith<$Res> {
  _$ProfileLoadedCopyWithImpl(this._self, this._then);

  final ProfileLoaded _self;
  final $Res Function(ProfileLoaded) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,Object? followers = null,Object? following = null,Object? isLoadingFollowers = null,Object? isLoadingFollowing = null,Object? currentTab = null,Object? posts = null,Object? scheduledPosts = null,Object? isLoadingPosts = null,Object? hasMorePosts = null,Object? cachedPostsByType = null,Object? hasMorePostsByType = null,Object? followError = freezed,}) {
  return _then(ProfileLoaded(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,followers: null == followers ? _self._followers : followers // ignore: cast_nullable_to_non_nullable
as List<User>,following: null == following ? _self._following : following // ignore: cast_nullable_to_non_nullable
as List<User>,isLoadingFollowers: null == isLoadingFollowers ? _self.isLoadingFollowers : isLoadingFollowers // ignore: cast_nullable_to_non_nullable
as bool,isLoadingFollowing: null == isLoadingFollowing ? _self.isLoadingFollowing : isLoadingFollowing // ignore: cast_nullable_to_non_nullable
as bool,currentTab: null == currentTab ? _self.currentTab : currentTab // ignore: cast_nullable_to_non_nullable
as int,posts: null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as List<FeedItem>,scheduledPosts: null == scheduledPosts ? _self._scheduledPosts : scheduledPosts // ignore: cast_nullable_to_non_nullable
as List<FeedItem>,isLoadingPosts: null == isLoadingPosts ? _self.isLoadingPosts : isLoadingPosts // ignore: cast_nullable_to_non_nullable
as bool,hasMorePosts: null == hasMorePosts ? _self.hasMorePosts : hasMorePosts // ignore: cast_nullable_to_non_nullable
as bool,cachedPostsByType: null == cachedPostsByType ? _self._cachedPostsByType : cachedPostsByType // ignore: cast_nullable_to_non_nullable
as Map<String, List<FeedItem>>,hasMorePostsByType: null == hasMorePostsByType ? _self._hasMorePostsByType : hasMorePostsByType // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,followError: freezed == followError ? _self.followError : followError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user {
  
  return $UserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

/// @nodoc


class ProfileError extends ProfileState {
  const ProfileError(this.message): super._();
  

 final  String message;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileErrorCopyWith<ProfileError> get copyWith => _$ProfileErrorCopyWithImpl<ProfileError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ProfileState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ProfileErrorCopyWith<$Res> implements $ProfileStateCopyWith<$Res> {
  factory $ProfileErrorCopyWith(ProfileError value, $Res Function(ProfileError) _then) = _$ProfileErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ProfileErrorCopyWithImpl<$Res>
    implements $ProfileErrorCopyWith<$Res> {
  _$ProfileErrorCopyWithImpl(this._self, this._then);

  final ProfileError _self;
  final $Res Function(ProfileError) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ProfileError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
