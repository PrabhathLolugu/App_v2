// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FeedState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedState()';
}


}

/// @nodoc
class $FeedStateCopyWith<$Res>  {
$FeedStateCopyWith(FeedState _, $Res Function(FeedState) __);
}


/// Adds pattern-matching-related methods to [FeedState].
extension FeedStatePatterns on FeedState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FeedInitial value)?  initial,TResult Function( FeedLoading value)?  loading,TResult Function( FeedLoaded value)?  loaded,TResult Function( FeedRefreshing value)?  refreshing,TResult Function( FeedError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FeedInitial() when initial != null:
return initial(_that);case FeedLoading() when loading != null:
return loading(_that);case FeedLoaded() when loaded != null:
return loaded(_that);case FeedRefreshing() when refreshing != null:
return refreshing(_that);case FeedError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FeedInitial value)  initial,required TResult Function( FeedLoading value)  loading,required TResult Function( FeedLoaded value)  loaded,required TResult Function( FeedRefreshing value)  refreshing,required TResult Function( FeedError value)  error,}){
final _that = this;
switch (_that) {
case FeedInitial():
return initial(_that);case FeedLoading():
return loading(_that);case FeedLoaded():
return loaded(_that);case FeedRefreshing():
return refreshing(_that);case FeedError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FeedInitial value)?  initial,TResult? Function( FeedLoading value)?  loading,TResult? Function( FeedLoaded value)?  loaded,TResult? Function( FeedRefreshing value)?  refreshing,TResult? Function( FeedError value)?  error,}){
final _that = this;
switch (_that) {
case FeedInitial() when initial != null:
return initial(_that);case FeedLoading() when loading != null:
return loading(_that);case FeedLoaded() when loaded != null:
return loaded(_that);case FeedRefreshing() when refreshing != null:
return refreshing(_that);case FeedError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<FeedItem> feedItems,  User currentUser,  bool hasMore,  FeedType currentFeedType,  bool isLoadingMore,  bool isOnline,  String? error,  bool isOfflineError,  String? activeHashtag)?  loaded,TResult Function( List<FeedItem> feedItems,  User currentUser,  bool hasMore,  FeedType currentFeedType,  String? activeHashtag)?  refreshing,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FeedInitial() when initial != null:
return initial();case FeedLoading() when loading != null:
return loading();case FeedLoaded() when loaded != null:
return loaded(_that.feedItems,_that.currentUser,_that.hasMore,_that.currentFeedType,_that.isLoadingMore,_that.isOnline,_that.error,_that.isOfflineError,_that.activeHashtag);case FeedRefreshing() when refreshing != null:
return refreshing(_that.feedItems,_that.currentUser,_that.hasMore,_that.currentFeedType,_that.activeHashtag);case FeedError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<FeedItem> feedItems,  User currentUser,  bool hasMore,  FeedType currentFeedType,  bool isLoadingMore,  bool isOnline,  String? error,  bool isOfflineError,  String? activeHashtag)  loaded,required TResult Function( List<FeedItem> feedItems,  User currentUser,  bool hasMore,  FeedType currentFeedType,  String? activeHashtag)  refreshing,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case FeedInitial():
return initial();case FeedLoading():
return loading();case FeedLoaded():
return loaded(_that.feedItems,_that.currentUser,_that.hasMore,_that.currentFeedType,_that.isLoadingMore,_that.isOnline,_that.error,_that.isOfflineError,_that.activeHashtag);case FeedRefreshing():
return refreshing(_that.feedItems,_that.currentUser,_that.hasMore,_that.currentFeedType,_that.activeHashtag);case FeedError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<FeedItem> feedItems,  User currentUser,  bool hasMore,  FeedType currentFeedType,  bool isLoadingMore,  bool isOnline,  String? error,  bool isOfflineError,  String? activeHashtag)?  loaded,TResult? Function( List<FeedItem> feedItems,  User currentUser,  bool hasMore,  FeedType currentFeedType,  String? activeHashtag)?  refreshing,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case FeedInitial() when initial != null:
return initial();case FeedLoading() when loading != null:
return loading();case FeedLoaded() when loaded != null:
return loaded(_that.feedItems,_that.currentUser,_that.hasMore,_that.currentFeedType,_that.isLoadingMore,_that.isOnline,_that.error,_that.isOfflineError,_that.activeHashtag);case FeedRefreshing() when refreshing != null:
return refreshing(_that.feedItems,_that.currentUser,_that.hasMore,_that.currentFeedType,_that.activeHashtag);case FeedError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class FeedInitial extends FeedState {
  const FeedInitial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedState.initial()';
}


}




/// @nodoc


class FeedLoading extends FeedState {
  const FeedLoading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedState.loading()';
}


}




/// @nodoc


class FeedLoaded extends FeedState {
  const FeedLoaded({required final  List<FeedItem> feedItems, required this.currentUser, required this.hasMore, this.currentFeedType = FeedType.stories, this.isLoadingMore = false, this.isOnline = true, this.error, this.isOfflineError = false, this.activeHashtag}): _feedItems = feedItems,super._();
  

 final  List<FeedItem> _feedItems;
 List<FeedItem> get feedItems {
  if (_feedItems is EqualUnmodifiableListView) return _feedItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_feedItems);
}

 final  User currentUser;
 final  bool hasMore;
@JsonKey() final  FeedType currentFeedType;
@JsonKey() final  bool isLoadingMore;
@JsonKey() final  bool isOnline;
 final  String? error;
@JsonKey() final  bool isOfflineError;
/// Normalized hashtag without `#` (lowercase); null = show full feed.
 final  String? activeHashtag;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedLoadedCopyWith<FeedLoaded> get copyWith => _$FeedLoadedCopyWithImpl<FeedLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedLoaded&&const DeepCollectionEquality().equals(other._feedItems, _feedItems)&&(identical(other.currentUser, currentUser) || other.currentUser == currentUser)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.currentFeedType, currentFeedType) || other.currentFeedType == currentFeedType)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.error, error) || other.error == error)&&(identical(other.isOfflineError, isOfflineError) || other.isOfflineError == isOfflineError)&&(identical(other.activeHashtag, activeHashtag) || other.activeHashtag == activeHashtag));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_feedItems),currentUser,hasMore,currentFeedType,isLoadingMore,isOnline,error,isOfflineError,activeHashtag);

@override
String toString() {
  return 'FeedState.loaded(feedItems: $feedItems, currentUser: $currentUser, hasMore: $hasMore, currentFeedType: $currentFeedType, isLoadingMore: $isLoadingMore, isOnline: $isOnline, error: $error, isOfflineError: $isOfflineError, activeHashtag: $activeHashtag)';
}


}

/// @nodoc
abstract mixin class $FeedLoadedCopyWith<$Res> implements $FeedStateCopyWith<$Res> {
  factory $FeedLoadedCopyWith(FeedLoaded value, $Res Function(FeedLoaded) _then) = _$FeedLoadedCopyWithImpl;
@useResult
$Res call({
 List<FeedItem> feedItems, User currentUser, bool hasMore, FeedType currentFeedType, bool isLoadingMore, bool isOnline, String? error, bool isOfflineError, String? activeHashtag
});


$UserCopyWith<$Res> get currentUser;

}
/// @nodoc
class _$FeedLoadedCopyWithImpl<$Res>
    implements $FeedLoadedCopyWith<$Res> {
  _$FeedLoadedCopyWithImpl(this._self, this._then);

  final FeedLoaded _self;
  final $Res Function(FeedLoaded) _then;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? feedItems = null,Object? currentUser = null,Object? hasMore = null,Object? currentFeedType = null,Object? isLoadingMore = null,Object? isOnline = null,Object? error = freezed,Object? isOfflineError = null,Object? activeHashtag = freezed,}) {
  return _then(FeedLoaded(
feedItems: null == feedItems ? _self._feedItems : feedItems // ignore: cast_nullable_to_non_nullable
as List<FeedItem>,currentUser: null == currentUser ? _self.currentUser : currentUser // ignore: cast_nullable_to_non_nullable
as User,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,currentFeedType: null == currentFeedType ? _self.currentFeedType : currentFeedType // ignore: cast_nullable_to_non_nullable
as FeedType,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,isOfflineError: null == isOfflineError ? _self.isOfflineError : isOfflineError // ignore: cast_nullable_to_non_nullable
as bool,activeHashtag: freezed == activeHashtag ? _self.activeHashtag : activeHashtag // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get currentUser {
  
  return $UserCopyWith<$Res>(_self.currentUser, (value) {
    return _then(_self.copyWith(currentUser: value));
  });
}
}

/// @nodoc


class FeedRefreshing extends FeedState {
  const FeedRefreshing({required final  List<FeedItem> feedItems, required this.currentUser, required this.hasMore, this.currentFeedType = FeedType.stories, this.activeHashtag}): _feedItems = feedItems,super._();
  

 final  List<FeedItem> _feedItems;
 List<FeedItem> get feedItems {
  if (_feedItems is EqualUnmodifiableListView) return _feedItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_feedItems);
}

 final  User currentUser;
 final  bool hasMore;
@JsonKey() final  FeedType currentFeedType;
 final  String? activeHashtag;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedRefreshingCopyWith<FeedRefreshing> get copyWith => _$FeedRefreshingCopyWithImpl<FeedRefreshing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedRefreshing&&const DeepCollectionEquality().equals(other._feedItems, _feedItems)&&(identical(other.currentUser, currentUser) || other.currentUser == currentUser)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.currentFeedType, currentFeedType) || other.currentFeedType == currentFeedType)&&(identical(other.activeHashtag, activeHashtag) || other.activeHashtag == activeHashtag));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_feedItems),currentUser,hasMore,currentFeedType,activeHashtag);

@override
String toString() {
  return 'FeedState.refreshing(feedItems: $feedItems, currentUser: $currentUser, hasMore: $hasMore, currentFeedType: $currentFeedType, activeHashtag: $activeHashtag)';
}


}

/// @nodoc
abstract mixin class $FeedRefreshingCopyWith<$Res> implements $FeedStateCopyWith<$Res> {
  factory $FeedRefreshingCopyWith(FeedRefreshing value, $Res Function(FeedRefreshing) _then) = _$FeedRefreshingCopyWithImpl;
@useResult
$Res call({
 List<FeedItem> feedItems, User currentUser, bool hasMore, FeedType currentFeedType, String? activeHashtag
});


$UserCopyWith<$Res> get currentUser;

}
/// @nodoc
class _$FeedRefreshingCopyWithImpl<$Res>
    implements $FeedRefreshingCopyWith<$Res> {
  _$FeedRefreshingCopyWithImpl(this._self, this._then);

  final FeedRefreshing _self;
  final $Res Function(FeedRefreshing) _then;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? feedItems = null,Object? currentUser = null,Object? hasMore = null,Object? currentFeedType = null,Object? activeHashtag = freezed,}) {
  return _then(FeedRefreshing(
feedItems: null == feedItems ? _self._feedItems : feedItems // ignore: cast_nullable_to_non_nullable
as List<FeedItem>,currentUser: null == currentUser ? _self.currentUser : currentUser // ignore: cast_nullable_to_non_nullable
as User,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,currentFeedType: null == currentFeedType ? _self.currentFeedType : currentFeedType // ignore: cast_nullable_to_non_nullable
as FeedType,activeHashtag: freezed == activeHashtag ? _self.activeHashtag : activeHashtag // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get currentUser {
  
  return $UserCopyWith<$Res>(_self.currentUser, (value) {
    return _then(_self.copyWith(currentUser: value));
  });
}
}

/// @nodoc


class FeedError extends FeedState {
  const FeedError(this.message): super._();
  

 final  String message;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedErrorCopyWith<FeedError> get copyWith => _$FeedErrorCopyWithImpl<FeedError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'FeedState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $FeedErrorCopyWith<$Res> implements $FeedStateCopyWith<$Res> {
  factory $FeedErrorCopyWith(FeedError value, $Res Function(FeedError) _then) = _$FeedErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$FeedErrorCopyWithImpl<$Res>
    implements $FeedErrorCopyWith<$Res> {
  _$FeedErrorCopyWithImpl(this._self, this._then);

  final FeedError _self;
  final $Res Function(FeedError) _then;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(FeedError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
