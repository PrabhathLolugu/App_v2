// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FeedEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedEvent()';
}


}

/// @nodoc
class $FeedEventCopyWith<$Res>  {
$FeedEventCopyWith(FeedEvent _, $Res Function(FeedEvent) __);
}


/// Adds pattern-matching-related methods to [FeedEvent].
extension FeedEventPatterns on FeedEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadFeedEvent value)?  loadFeed,TResult Function( LoadMoreFeedEvent value)?  loadMore,TResult Function( RefreshFeedEvent value)?  refreshFeed,TResult Function( ChangeFeedTypeEvent value)?  changeFeedType,TResult Function( CheckConnectivityEvent value)?  checkConnectivity,TResult Function( RealtimePostReceivedEvent value)?  realtimePostReceived,TResult Function( ToggleLikeEvent value)?  toggleLike,TResult Function( ToggleBookmarkEvent value)?  toggleBookmark,TResult Function( AddCommentEvent value)?  addComment,TResult Function( CommentCountIncrementedEvent value)?  commentCountIncremented,TResult Function( SetCommentCountEvent value)?  setCommentCount,TResult Function( ShareContentEvent value)?  shareContent,TResult Function( RepostPostEvent value)?  repostPost,TResult Function( FollowUserEvent value)?  followUser,TResult Function( UnfollowUserEvent value)?  unfollowUser,TResult Function( SetHashtagFilterEvent value)?  setHashtagFilter,TResult Function( ClearHashtagFilterEvent value)?  clearHashtagFilter,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadFeedEvent() when loadFeed != null:
return loadFeed(_that);case LoadMoreFeedEvent() when loadMore != null:
return loadMore(_that);case RefreshFeedEvent() when refreshFeed != null:
return refreshFeed(_that);case ChangeFeedTypeEvent() when changeFeedType != null:
return changeFeedType(_that);case CheckConnectivityEvent() when checkConnectivity != null:
return checkConnectivity(_that);case RealtimePostReceivedEvent() when realtimePostReceived != null:
return realtimePostReceived(_that);case ToggleLikeEvent() when toggleLike != null:
return toggleLike(_that);case ToggleBookmarkEvent() when toggleBookmark != null:
return toggleBookmark(_that);case AddCommentEvent() when addComment != null:
return addComment(_that);case CommentCountIncrementedEvent() when commentCountIncremented != null:
return commentCountIncremented(_that);case SetCommentCountEvent() when setCommentCount != null:
return setCommentCount(_that);case ShareContentEvent() when shareContent != null:
return shareContent(_that);case RepostPostEvent() when repostPost != null:
return repostPost(_that);case FollowUserEvent() when followUser != null:
return followUser(_that);case UnfollowUserEvent() when unfollowUser != null:
return unfollowUser(_that);case SetHashtagFilterEvent() when setHashtagFilter != null:
return setHashtagFilter(_that);case ClearHashtagFilterEvent() when clearHashtagFilter != null:
return clearHashtagFilter(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadFeedEvent value)  loadFeed,required TResult Function( LoadMoreFeedEvent value)  loadMore,required TResult Function( RefreshFeedEvent value)  refreshFeed,required TResult Function( ChangeFeedTypeEvent value)  changeFeedType,required TResult Function( CheckConnectivityEvent value)  checkConnectivity,required TResult Function( RealtimePostReceivedEvent value)  realtimePostReceived,required TResult Function( ToggleLikeEvent value)  toggleLike,required TResult Function( ToggleBookmarkEvent value)  toggleBookmark,required TResult Function( AddCommentEvent value)  addComment,required TResult Function( CommentCountIncrementedEvent value)  commentCountIncremented,required TResult Function( SetCommentCountEvent value)  setCommentCount,required TResult Function( ShareContentEvent value)  shareContent,required TResult Function( RepostPostEvent value)  repostPost,required TResult Function( FollowUserEvent value)  followUser,required TResult Function( UnfollowUserEvent value)  unfollowUser,required TResult Function( SetHashtagFilterEvent value)  setHashtagFilter,required TResult Function( ClearHashtagFilterEvent value)  clearHashtagFilter,}){
final _that = this;
switch (_that) {
case LoadFeedEvent():
return loadFeed(_that);case LoadMoreFeedEvent():
return loadMore(_that);case RefreshFeedEvent():
return refreshFeed(_that);case ChangeFeedTypeEvent():
return changeFeedType(_that);case CheckConnectivityEvent():
return checkConnectivity(_that);case RealtimePostReceivedEvent():
return realtimePostReceived(_that);case ToggleLikeEvent():
return toggleLike(_that);case ToggleBookmarkEvent():
return toggleBookmark(_that);case AddCommentEvent():
return addComment(_that);case CommentCountIncrementedEvent():
return commentCountIncremented(_that);case SetCommentCountEvent():
return setCommentCount(_that);case ShareContentEvent():
return shareContent(_that);case RepostPostEvent():
return repostPost(_that);case FollowUserEvent():
return followUser(_that);case UnfollowUserEvent():
return unfollowUser(_that);case SetHashtagFilterEvent():
return setHashtagFilter(_that);case ClearHashtagFilterEvent():
return clearHashtagFilter(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadFeedEvent value)?  loadFeed,TResult? Function( LoadMoreFeedEvent value)?  loadMore,TResult? Function( RefreshFeedEvent value)?  refreshFeed,TResult? Function( ChangeFeedTypeEvent value)?  changeFeedType,TResult? Function( CheckConnectivityEvent value)?  checkConnectivity,TResult? Function( RealtimePostReceivedEvent value)?  realtimePostReceived,TResult? Function( ToggleLikeEvent value)?  toggleLike,TResult? Function( ToggleBookmarkEvent value)?  toggleBookmark,TResult? Function( AddCommentEvent value)?  addComment,TResult? Function( CommentCountIncrementedEvent value)?  commentCountIncremented,TResult? Function( SetCommentCountEvent value)?  setCommentCount,TResult? Function( ShareContentEvent value)?  shareContent,TResult? Function( RepostPostEvent value)?  repostPost,TResult? Function( FollowUserEvent value)?  followUser,TResult? Function( UnfollowUserEvent value)?  unfollowUser,TResult? Function( SetHashtagFilterEvent value)?  setHashtagFilter,TResult? Function( ClearHashtagFilterEvent value)?  clearHashtagFilter,}){
final _that = this;
switch (_that) {
case LoadFeedEvent() when loadFeed != null:
return loadFeed(_that);case LoadMoreFeedEvent() when loadMore != null:
return loadMore(_that);case RefreshFeedEvent() when refreshFeed != null:
return refreshFeed(_that);case ChangeFeedTypeEvent() when changeFeedType != null:
return changeFeedType(_that);case CheckConnectivityEvent() when checkConnectivity != null:
return checkConnectivity(_that);case RealtimePostReceivedEvent() when realtimePostReceived != null:
return realtimePostReceived(_that);case ToggleLikeEvent() when toggleLike != null:
return toggleLike(_that);case ToggleBookmarkEvent() when toggleBookmark != null:
return toggleBookmark(_that);case AddCommentEvent() when addComment != null:
return addComment(_that);case CommentCountIncrementedEvent() when commentCountIncremented != null:
return commentCountIncremented(_that);case SetCommentCountEvent() when setCommentCount != null:
return setCommentCount(_that);case ShareContentEvent() when shareContent != null:
return shareContent(_that);case RepostPostEvent() when repostPost != null:
return repostPost(_that);case FollowUserEvent() when followUser != null:
return followUser(_that);case UnfollowUserEvent() when unfollowUser != null:
return unfollowUser(_that);case SetHashtagFilterEvent() when setHashtagFilter != null:
return setHashtagFilter(_that);case ClearHashtagFilterEvent() when clearHashtagFilter != null:
return clearHashtagFilter(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadFeed,TResult Function()?  loadMore,TResult Function()?  refreshFeed,TResult Function( FeedType feedType)?  changeFeedType,TResult Function()?  checkConnectivity,TResult Function( FeedItem post)?  realtimePostReceived,TResult Function( String contentId,  ContentType contentType)?  toggleLike,TResult Function( String contentId,  ContentType contentType)?  toggleBookmark,TResult Function( String contentId,  ContentType contentType,  String text,  String? parentCommentId)?  addComment,TResult Function( String contentId,  ContentType contentType)?  commentCountIncremented,TResult Function( String contentId,  ContentType contentType,  int count)?  setCommentCount,TResult Function( String contentId,  ContentType contentType,  bool isDirect,  String? recipientId)?  shareContent,TResult Function( String originalPostId,  String? quoteCaption)?  repostPost,TResult Function( String userId)?  followUser,TResult Function( String userId)?  unfollowUser,TResult Function( String normalizedTag)?  setHashtagFilter,TResult Function()?  clearHashtagFilter,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadFeedEvent() when loadFeed != null:
return loadFeed();case LoadMoreFeedEvent() when loadMore != null:
return loadMore();case RefreshFeedEvent() when refreshFeed != null:
return refreshFeed();case ChangeFeedTypeEvent() when changeFeedType != null:
return changeFeedType(_that.feedType);case CheckConnectivityEvent() when checkConnectivity != null:
return checkConnectivity();case RealtimePostReceivedEvent() when realtimePostReceived != null:
return realtimePostReceived(_that.post);case ToggleLikeEvent() when toggleLike != null:
return toggleLike(_that.contentId,_that.contentType);case ToggleBookmarkEvent() when toggleBookmark != null:
return toggleBookmark(_that.contentId,_that.contentType);case AddCommentEvent() when addComment != null:
return addComment(_that.contentId,_that.contentType,_that.text,_that.parentCommentId);case CommentCountIncrementedEvent() when commentCountIncremented != null:
return commentCountIncremented(_that.contentId,_that.contentType);case SetCommentCountEvent() when setCommentCount != null:
return setCommentCount(_that.contentId,_that.contentType,_that.count);case ShareContentEvent() when shareContent != null:
return shareContent(_that.contentId,_that.contentType,_that.isDirect,_that.recipientId);case RepostPostEvent() when repostPost != null:
return repostPost(_that.originalPostId,_that.quoteCaption);case FollowUserEvent() when followUser != null:
return followUser(_that.userId);case UnfollowUserEvent() when unfollowUser != null:
return unfollowUser(_that.userId);case SetHashtagFilterEvent() when setHashtagFilter != null:
return setHashtagFilter(_that.normalizedTag);case ClearHashtagFilterEvent() when clearHashtagFilter != null:
return clearHashtagFilter();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadFeed,required TResult Function()  loadMore,required TResult Function()  refreshFeed,required TResult Function( FeedType feedType)  changeFeedType,required TResult Function()  checkConnectivity,required TResult Function( FeedItem post)  realtimePostReceived,required TResult Function( String contentId,  ContentType contentType)  toggleLike,required TResult Function( String contentId,  ContentType contentType)  toggleBookmark,required TResult Function( String contentId,  ContentType contentType,  String text,  String? parentCommentId)  addComment,required TResult Function( String contentId,  ContentType contentType)  commentCountIncremented,required TResult Function( String contentId,  ContentType contentType,  int count)  setCommentCount,required TResult Function( String contentId,  ContentType contentType,  bool isDirect,  String? recipientId)  shareContent,required TResult Function( String originalPostId,  String? quoteCaption)  repostPost,required TResult Function( String userId)  followUser,required TResult Function( String userId)  unfollowUser,required TResult Function( String normalizedTag)  setHashtagFilter,required TResult Function()  clearHashtagFilter,}) {final _that = this;
switch (_that) {
case LoadFeedEvent():
return loadFeed();case LoadMoreFeedEvent():
return loadMore();case RefreshFeedEvent():
return refreshFeed();case ChangeFeedTypeEvent():
return changeFeedType(_that.feedType);case CheckConnectivityEvent():
return checkConnectivity();case RealtimePostReceivedEvent():
return realtimePostReceived(_that.post);case ToggleLikeEvent():
return toggleLike(_that.contentId,_that.contentType);case ToggleBookmarkEvent():
return toggleBookmark(_that.contentId,_that.contentType);case AddCommentEvent():
return addComment(_that.contentId,_that.contentType,_that.text,_that.parentCommentId);case CommentCountIncrementedEvent():
return commentCountIncremented(_that.contentId,_that.contentType);case SetCommentCountEvent():
return setCommentCount(_that.contentId,_that.contentType,_that.count);case ShareContentEvent():
return shareContent(_that.contentId,_that.contentType,_that.isDirect,_that.recipientId);case RepostPostEvent():
return repostPost(_that.originalPostId,_that.quoteCaption);case FollowUserEvent():
return followUser(_that.userId);case UnfollowUserEvent():
return unfollowUser(_that.userId);case SetHashtagFilterEvent():
return setHashtagFilter(_that.normalizedTag);case ClearHashtagFilterEvent():
return clearHashtagFilter();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadFeed,TResult? Function()?  loadMore,TResult? Function()?  refreshFeed,TResult? Function( FeedType feedType)?  changeFeedType,TResult? Function()?  checkConnectivity,TResult? Function( FeedItem post)?  realtimePostReceived,TResult? Function( String contentId,  ContentType contentType)?  toggleLike,TResult? Function( String contentId,  ContentType contentType)?  toggleBookmark,TResult? Function( String contentId,  ContentType contentType,  String text,  String? parentCommentId)?  addComment,TResult? Function( String contentId,  ContentType contentType)?  commentCountIncremented,TResult? Function( String contentId,  ContentType contentType,  int count)?  setCommentCount,TResult? Function( String contentId,  ContentType contentType,  bool isDirect,  String? recipientId)?  shareContent,TResult? Function( String originalPostId,  String? quoteCaption)?  repostPost,TResult? Function( String userId)?  followUser,TResult? Function( String userId)?  unfollowUser,TResult? Function( String normalizedTag)?  setHashtagFilter,TResult? Function()?  clearHashtagFilter,}) {final _that = this;
switch (_that) {
case LoadFeedEvent() when loadFeed != null:
return loadFeed();case LoadMoreFeedEvent() when loadMore != null:
return loadMore();case RefreshFeedEvent() when refreshFeed != null:
return refreshFeed();case ChangeFeedTypeEvent() when changeFeedType != null:
return changeFeedType(_that.feedType);case CheckConnectivityEvent() when checkConnectivity != null:
return checkConnectivity();case RealtimePostReceivedEvent() when realtimePostReceived != null:
return realtimePostReceived(_that.post);case ToggleLikeEvent() when toggleLike != null:
return toggleLike(_that.contentId,_that.contentType);case ToggleBookmarkEvent() when toggleBookmark != null:
return toggleBookmark(_that.contentId,_that.contentType);case AddCommentEvent() when addComment != null:
return addComment(_that.contentId,_that.contentType,_that.text,_that.parentCommentId);case CommentCountIncrementedEvent() when commentCountIncremented != null:
return commentCountIncremented(_that.contentId,_that.contentType);case SetCommentCountEvent() when setCommentCount != null:
return setCommentCount(_that.contentId,_that.contentType,_that.count);case ShareContentEvent() when shareContent != null:
return shareContent(_that.contentId,_that.contentType,_that.isDirect,_that.recipientId);case RepostPostEvent() when repostPost != null:
return repostPost(_that.originalPostId,_that.quoteCaption);case FollowUserEvent() when followUser != null:
return followUser(_that.userId);case UnfollowUserEvent() when unfollowUser != null:
return unfollowUser(_that.userId);case SetHashtagFilterEvent() when setHashtagFilter != null:
return setHashtagFilter(_that.normalizedTag);case ClearHashtagFilterEvent() when clearHashtagFilter != null:
return clearHashtagFilter();case _:
  return null;

}
}

}

/// @nodoc


class LoadFeedEvent implements FeedEvent {
  const LoadFeedEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadFeedEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedEvent.loadFeed()';
}


}




/// @nodoc


class LoadMoreFeedEvent implements FeedEvent {
  const LoadMoreFeedEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadMoreFeedEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedEvent.loadMore()';
}


}




/// @nodoc


class RefreshFeedEvent implements FeedEvent {
  const RefreshFeedEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefreshFeedEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedEvent.refreshFeed()';
}


}




/// @nodoc


class ChangeFeedTypeEvent implements FeedEvent {
  const ChangeFeedTypeEvent(this.feedType);
  

 final  FeedType feedType;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangeFeedTypeEventCopyWith<ChangeFeedTypeEvent> get copyWith => _$ChangeFeedTypeEventCopyWithImpl<ChangeFeedTypeEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangeFeedTypeEvent&&(identical(other.feedType, feedType) || other.feedType == feedType));
}


@override
int get hashCode => Object.hash(runtimeType,feedType);

@override
String toString() {
  return 'FeedEvent.changeFeedType(feedType: $feedType)';
}


}

/// @nodoc
abstract mixin class $ChangeFeedTypeEventCopyWith<$Res> implements $FeedEventCopyWith<$Res> {
  factory $ChangeFeedTypeEventCopyWith(ChangeFeedTypeEvent value, $Res Function(ChangeFeedTypeEvent) _then) = _$ChangeFeedTypeEventCopyWithImpl;
@useResult
$Res call({
 FeedType feedType
});




}
/// @nodoc
class _$ChangeFeedTypeEventCopyWithImpl<$Res>
    implements $ChangeFeedTypeEventCopyWith<$Res> {
  _$ChangeFeedTypeEventCopyWithImpl(this._self, this._then);

  final ChangeFeedTypeEvent _self;
  final $Res Function(ChangeFeedTypeEvent) _then;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? feedType = null,}) {
  return _then(ChangeFeedTypeEvent(
null == feedType ? _self.feedType : feedType // ignore: cast_nullable_to_non_nullable
as FeedType,
  ));
}


}

/// @nodoc


class CheckConnectivityEvent implements FeedEvent {
  const CheckConnectivityEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckConnectivityEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedEvent.checkConnectivity()';
}


}




/// @nodoc


class RealtimePostReceivedEvent implements FeedEvent {
  const RealtimePostReceivedEvent(this.post);
  

 final  FeedItem post;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RealtimePostReceivedEventCopyWith<RealtimePostReceivedEvent> get copyWith => _$RealtimePostReceivedEventCopyWithImpl<RealtimePostReceivedEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RealtimePostReceivedEvent&&(identical(other.post, post) || other.post == post));
}


@override
int get hashCode => Object.hash(runtimeType,post);

@override
String toString() {
  return 'FeedEvent.realtimePostReceived(post: $post)';
}


}

/// @nodoc
abstract mixin class $RealtimePostReceivedEventCopyWith<$Res> implements $FeedEventCopyWith<$Res> {
  factory $RealtimePostReceivedEventCopyWith(RealtimePostReceivedEvent value, $Res Function(RealtimePostReceivedEvent) _then) = _$RealtimePostReceivedEventCopyWithImpl;
@useResult
$Res call({
 FeedItem post
});


$FeedItemCopyWith<$Res> get post;

}
/// @nodoc
class _$RealtimePostReceivedEventCopyWithImpl<$Res>
    implements $RealtimePostReceivedEventCopyWith<$Res> {
  _$RealtimePostReceivedEventCopyWithImpl(this._self, this._then);

  final RealtimePostReceivedEvent _self;
  final $Res Function(RealtimePostReceivedEvent) _then;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? post = null,}) {
  return _then(RealtimePostReceivedEvent(
null == post ? _self.post : post // ignore: cast_nullable_to_non_nullable
as FeedItem,
  ));
}

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeedItemCopyWith<$Res> get post {
  
  return $FeedItemCopyWith<$Res>(_self.post, (value) {
    return _then(_self.copyWith(post: value));
  });
}
}

/// @nodoc


class ToggleLikeEvent implements FeedEvent {
  const ToggleLikeEvent({required this.contentId, required this.contentType});
  

 final  String contentId;
 final  ContentType contentType;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToggleLikeEventCopyWith<ToggleLikeEvent> get copyWith => _$ToggleLikeEventCopyWithImpl<ToggleLikeEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToggleLikeEvent&&(identical(other.contentId, contentId) || other.contentId == contentId)&&(identical(other.contentType, contentType) || other.contentType == contentType));
}


@override
int get hashCode => Object.hash(runtimeType,contentId,contentType);

@override
String toString() {
  return 'FeedEvent.toggleLike(contentId: $contentId, contentType: $contentType)';
}


}

/// @nodoc
abstract mixin class $ToggleLikeEventCopyWith<$Res> implements $FeedEventCopyWith<$Res> {
  factory $ToggleLikeEventCopyWith(ToggleLikeEvent value, $Res Function(ToggleLikeEvent) _then) = _$ToggleLikeEventCopyWithImpl;
@useResult
$Res call({
 String contentId, ContentType contentType
});




}
/// @nodoc
class _$ToggleLikeEventCopyWithImpl<$Res>
    implements $ToggleLikeEventCopyWith<$Res> {
  _$ToggleLikeEventCopyWithImpl(this._self, this._then);

  final ToggleLikeEvent _self;
  final $Res Function(ToggleLikeEvent) _then;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? contentId = null,Object? contentType = null,}) {
  return _then(ToggleLikeEvent(
contentId: null == contentId ? _self.contentId : contentId // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as ContentType,
  ));
}


}

/// @nodoc


class ToggleBookmarkEvent implements FeedEvent {
  const ToggleBookmarkEvent({required this.contentId, required this.contentType});
  

 final  String contentId;
 final  ContentType contentType;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToggleBookmarkEventCopyWith<ToggleBookmarkEvent> get copyWith => _$ToggleBookmarkEventCopyWithImpl<ToggleBookmarkEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToggleBookmarkEvent&&(identical(other.contentId, contentId) || other.contentId == contentId)&&(identical(other.contentType, contentType) || other.contentType == contentType));
}


@override
int get hashCode => Object.hash(runtimeType,contentId,contentType);

@override
String toString() {
  return 'FeedEvent.toggleBookmark(contentId: $contentId, contentType: $contentType)';
}


}

/// @nodoc
abstract mixin class $ToggleBookmarkEventCopyWith<$Res> implements $FeedEventCopyWith<$Res> {
  factory $ToggleBookmarkEventCopyWith(ToggleBookmarkEvent value, $Res Function(ToggleBookmarkEvent) _then) = _$ToggleBookmarkEventCopyWithImpl;
@useResult
$Res call({
 String contentId, ContentType contentType
});




}
/// @nodoc
class _$ToggleBookmarkEventCopyWithImpl<$Res>
    implements $ToggleBookmarkEventCopyWith<$Res> {
  _$ToggleBookmarkEventCopyWithImpl(this._self, this._then);

  final ToggleBookmarkEvent _self;
  final $Res Function(ToggleBookmarkEvent) _then;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? contentId = null,Object? contentType = null,}) {
  return _then(ToggleBookmarkEvent(
contentId: null == contentId ? _self.contentId : contentId // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as ContentType,
  ));
}


}

/// @nodoc


class AddCommentEvent implements FeedEvent {
  const AddCommentEvent({required this.contentId, required this.contentType, required this.text, this.parentCommentId});
  

 final  String contentId;
 final  ContentType contentType;
 final  String text;
 final  String? parentCommentId;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddCommentEventCopyWith<AddCommentEvent> get copyWith => _$AddCommentEventCopyWithImpl<AddCommentEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddCommentEvent&&(identical(other.contentId, contentId) || other.contentId == contentId)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.text, text) || other.text == text)&&(identical(other.parentCommentId, parentCommentId) || other.parentCommentId == parentCommentId));
}


@override
int get hashCode => Object.hash(runtimeType,contentId,contentType,text,parentCommentId);

@override
String toString() {
  return 'FeedEvent.addComment(contentId: $contentId, contentType: $contentType, text: $text, parentCommentId: $parentCommentId)';
}


}

/// @nodoc
abstract mixin class $AddCommentEventCopyWith<$Res> implements $FeedEventCopyWith<$Res> {
  factory $AddCommentEventCopyWith(AddCommentEvent value, $Res Function(AddCommentEvent) _then) = _$AddCommentEventCopyWithImpl;
@useResult
$Res call({
 String contentId, ContentType contentType, String text, String? parentCommentId
});




}
/// @nodoc
class _$AddCommentEventCopyWithImpl<$Res>
    implements $AddCommentEventCopyWith<$Res> {
  _$AddCommentEventCopyWithImpl(this._self, this._then);

  final AddCommentEvent _self;
  final $Res Function(AddCommentEvent) _then;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? contentId = null,Object? contentType = null,Object? text = null,Object? parentCommentId = freezed,}) {
  return _then(AddCommentEvent(
contentId: null == contentId ? _self.contentId : contentId // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as ContentType,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,parentCommentId: freezed == parentCommentId ? _self.parentCommentId : parentCommentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class CommentCountIncrementedEvent implements FeedEvent {
  const CommentCountIncrementedEvent({required this.contentId, required this.contentType});
  

 final  String contentId;
 final  ContentType contentType;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentCountIncrementedEventCopyWith<CommentCountIncrementedEvent> get copyWith => _$CommentCountIncrementedEventCopyWithImpl<CommentCountIncrementedEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentCountIncrementedEvent&&(identical(other.contentId, contentId) || other.contentId == contentId)&&(identical(other.contentType, contentType) || other.contentType == contentType));
}


@override
int get hashCode => Object.hash(runtimeType,contentId,contentType);

@override
String toString() {
  return 'FeedEvent.commentCountIncremented(contentId: $contentId, contentType: $contentType)';
}


}

/// @nodoc
abstract mixin class $CommentCountIncrementedEventCopyWith<$Res> implements $FeedEventCopyWith<$Res> {
  factory $CommentCountIncrementedEventCopyWith(CommentCountIncrementedEvent value, $Res Function(CommentCountIncrementedEvent) _then) = _$CommentCountIncrementedEventCopyWithImpl;
@useResult
$Res call({
 String contentId, ContentType contentType
});




}
/// @nodoc
class _$CommentCountIncrementedEventCopyWithImpl<$Res>
    implements $CommentCountIncrementedEventCopyWith<$Res> {
  _$CommentCountIncrementedEventCopyWithImpl(this._self, this._then);

  final CommentCountIncrementedEvent _self;
  final $Res Function(CommentCountIncrementedEvent) _then;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? contentId = null,Object? contentType = null,}) {
  return _then(CommentCountIncrementedEvent(
contentId: null == contentId ? _self.contentId : contentId // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as ContentType,
  ));
}


}

/// @nodoc


class SetCommentCountEvent implements FeedEvent {
  const SetCommentCountEvent({required this.contentId, required this.contentType, required this.count});
  

 final  String contentId;
 final  ContentType contentType;
 final  int count;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetCommentCountEventCopyWith<SetCommentCountEvent> get copyWith => _$SetCommentCountEventCopyWithImpl<SetCommentCountEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetCommentCountEvent&&(identical(other.contentId, contentId) || other.contentId == contentId)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.count, count) || other.count == count));
}


@override
int get hashCode => Object.hash(runtimeType,contentId,contentType,count);

@override
String toString() {
  return 'FeedEvent.setCommentCount(contentId: $contentId, contentType: $contentType, count: $count)';
}


}

/// @nodoc
abstract mixin class $SetCommentCountEventCopyWith<$Res> implements $FeedEventCopyWith<$Res> {
  factory $SetCommentCountEventCopyWith(SetCommentCountEvent value, $Res Function(SetCommentCountEvent) _then) = _$SetCommentCountEventCopyWithImpl;
@useResult
$Res call({
 String contentId, ContentType contentType, int count
});




}
/// @nodoc
class _$SetCommentCountEventCopyWithImpl<$Res>
    implements $SetCommentCountEventCopyWith<$Res> {
  _$SetCommentCountEventCopyWithImpl(this._self, this._then);

  final SetCommentCountEvent _self;
  final $Res Function(SetCommentCountEvent) _then;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? contentId = null,Object? contentType = null,Object? count = null,}) {
  return _then(SetCommentCountEvent(
contentId: null == contentId ? _self.contentId : contentId // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as ContentType,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ShareContentEvent implements FeedEvent {
  const ShareContentEvent({required this.contentId, required this.contentType, required this.isDirect, this.recipientId});
  

 final  String contentId;
 final  ContentType contentType;
 final  bool isDirect;
 final  String? recipientId;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShareContentEventCopyWith<ShareContentEvent> get copyWith => _$ShareContentEventCopyWithImpl<ShareContentEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShareContentEvent&&(identical(other.contentId, contentId) || other.contentId == contentId)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.isDirect, isDirect) || other.isDirect == isDirect)&&(identical(other.recipientId, recipientId) || other.recipientId == recipientId));
}


@override
int get hashCode => Object.hash(runtimeType,contentId,contentType,isDirect,recipientId);

@override
String toString() {
  return 'FeedEvent.shareContent(contentId: $contentId, contentType: $contentType, isDirect: $isDirect, recipientId: $recipientId)';
}


}

/// @nodoc
abstract mixin class $ShareContentEventCopyWith<$Res> implements $FeedEventCopyWith<$Res> {
  factory $ShareContentEventCopyWith(ShareContentEvent value, $Res Function(ShareContentEvent) _then) = _$ShareContentEventCopyWithImpl;
@useResult
$Res call({
 String contentId, ContentType contentType, bool isDirect, String? recipientId
});




}
/// @nodoc
class _$ShareContentEventCopyWithImpl<$Res>
    implements $ShareContentEventCopyWith<$Res> {
  _$ShareContentEventCopyWithImpl(this._self, this._then);

  final ShareContentEvent _self;
  final $Res Function(ShareContentEvent) _then;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? contentId = null,Object? contentType = null,Object? isDirect = null,Object? recipientId = freezed,}) {
  return _then(ShareContentEvent(
contentId: null == contentId ? _self.contentId : contentId // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as ContentType,isDirect: null == isDirect ? _self.isDirect : isDirect // ignore: cast_nullable_to_non_nullable
as bool,recipientId: freezed == recipientId ? _self.recipientId : recipientId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class RepostPostEvent implements FeedEvent {
  const RepostPostEvent({required this.originalPostId, this.quoteCaption});
  

 final  String originalPostId;
 final  String? quoteCaption;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RepostPostEventCopyWith<RepostPostEvent> get copyWith => _$RepostPostEventCopyWithImpl<RepostPostEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RepostPostEvent&&(identical(other.originalPostId, originalPostId) || other.originalPostId == originalPostId)&&(identical(other.quoteCaption, quoteCaption) || other.quoteCaption == quoteCaption));
}


@override
int get hashCode => Object.hash(runtimeType,originalPostId,quoteCaption);

@override
String toString() {
  return 'FeedEvent.repostPost(originalPostId: $originalPostId, quoteCaption: $quoteCaption)';
}


}

/// @nodoc
abstract mixin class $RepostPostEventCopyWith<$Res> implements $FeedEventCopyWith<$Res> {
  factory $RepostPostEventCopyWith(RepostPostEvent value, $Res Function(RepostPostEvent) _then) = _$RepostPostEventCopyWithImpl;
@useResult
$Res call({
 String originalPostId, String? quoteCaption
});




}
/// @nodoc
class _$RepostPostEventCopyWithImpl<$Res>
    implements $RepostPostEventCopyWith<$Res> {
  _$RepostPostEventCopyWithImpl(this._self, this._then);

  final RepostPostEvent _self;
  final $Res Function(RepostPostEvent) _then;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? originalPostId = null,Object? quoteCaption = freezed,}) {
  return _then(RepostPostEvent(
originalPostId: null == originalPostId ? _self.originalPostId : originalPostId // ignore: cast_nullable_to_non_nullable
as String,quoteCaption: freezed == quoteCaption ? _self.quoteCaption : quoteCaption // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class FollowUserEvent implements FeedEvent {
  const FollowUserEvent(this.userId);
  

 final  String userId;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FollowUserEventCopyWith<FollowUserEvent> get copyWith => _$FollowUserEventCopyWithImpl<FollowUserEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FollowUserEvent&&(identical(other.userId, userId) || other.userId == userId));
}


@override
int get hashCode => Object.hash(runtimeType,userId);

@override
String toString() {
  return 'FeedEvent.followUser(userId: $userId)';
}


}

/// @nodoc
abstract mixin class $FollowUserEventCopyWith<$Res> implements $FeedEventCopyWith<$Res> {
  factory $FollowUserEventCopyWith(FollowUserEvent value, $Res Function(FollowUserEvent) _then) = _$FollowUserEventCopyWithImpl;
@useResult
$Res call({
 String userId
});




}
/// @nodoc
class _$FollowUserEventCopyWithImpl<$Res>
    implements $FollowUserEventCopyWith<$Res> {
  _$FollowUserEventCopyWithImpl(this._self, this._then);

  final FollowUserEvent _self;
  final $Res Function(FollowUserEvent) _then;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userId = null,}) {
  return _then(FollowUserEvent(
null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UnfollowUserEvent implements FeedEvent {
  const UnfollowUserEvent(this.userId);
  

 final  String userId;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnfollowUserEventCopyWith<UnfollowUserEvent> get copyWith => _$UnfollowUserEventCopyWithImpl<UnfollowUserEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnfollowUserEvent&&(identical(other.userId, userId) || other.userId == userId));
}


@override
int get hashCode => Object.hash(runtimeType,userId);

@override
String toString() {
  return 'FeedEvent.unfollowUser(userId: $userId)';
}


}

/// @nodoc
abstract mixin class $UnfollowUserEventCopyWith<$Res> implements $FeedEventCopyWith<$Res> {
  factory $UnfollowUserEventCopyWith(UnfollowUserEvent value, $Res Function(UnfollowUserEvent) _then) = _$UnfollowUserEventCopyWithImpl;
@useResult
$Res call({
 String userId
});




}
/// @nodoc
class _$UnfollowUserEventCopyWithImpl<$Res>
    implements $UnfollowUserEventCopyWith<$Res> {
  _$UnfollowUserEventCopyWithImpl(this._self, this._then);

  final UnfollowUserEvent _self;
  final $Res Function(UnfollowUserEvent) _then;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userId = null,}) {
  return _then(UnfollowUserEvent(
null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SetHashtagFilterEvent implements FeedEvent {
  const SetHashtagFilterEvent(this.normalizedTag);
  

 final  String normalizedTag;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetHashtagFilterEventCopyWith<SetHashtagFilterEvent> get copyWith => _$SetHashtagFilterEventCopyWithImpl<SetHashtagFilterEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetHashtagFilterEvent&&(identical(other.normalizedTag, normalizedTag) || other.normalizedTag == normalizedTag));
}


@override
int get hashCode => Object.hash(runtimeType,normalizedTag);

@override
String toString() {
  return 'FeedEvent.setHashtagFilter(normalizedTag: $normalizedTag)';
}


}

/// @nodoc
abstract mixin class $SetHashtagFilterEventCopyWith<$Res> implements $FeedEventCopyWith<$Res> {
  factory $SetHashtagFilterEventCopyWith(SetHashtagFilterEvent value, $Res Function(SetHashtagFilterEvent) _then) = _$SetHashtagFilterEventCopyWithImpl;
@useResult
$Res call({
 String normalizedTag
});




}
/// @nodoc
class _$SetHashtagFilterEventCopyWithImpl<$Res>
    implements $SetHashtagFilterEventCopyWith<$Res> {
  _$SetHashtagFilterEventCopyWithImpl(this._self, this._then);

  final SetHashtagFilterEvent _self;
  final $Res Function(SetHashtagFilterEvent) _then;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? normalizedTag = null,}) {
  return _then(SetHashtagFilterEvent(
null == normalizedTag ? _self.normalizedTag : normalizedTag // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ClearHashtagFilterEvent implements FeedEvent {
  const ClearHashtagFilterEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClearHashtagFilterEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedEvent.clearHashtagFilter()';
}


}




// dart format on
