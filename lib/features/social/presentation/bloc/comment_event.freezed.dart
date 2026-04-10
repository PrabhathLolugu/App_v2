// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CommentEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CommentEvent()';
}


}

/// @nodoc
class $CommentEventCopyWith<$Res>  {
$CommentEventCopyWith(CommentEvent _, $Res Function(CommentEvent) __);
}


/// Adds pattern-matching-related methods to [CommentEvent].
extension CommentEventPatterns on CommentEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadCommentsEvent value)?  loadComments,TResult Function( AddCommentEvent value)?  addComment,TResult Function( ToggleCommentLikeEvent value)?  toggleLike,TResult Function( ToggleCollapseEvent value)?  toggleCollapse,TResult Function( DeleteCommentEvent value)?  deleteComment,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadCommentsEvent() when loadComments != null:
return loadComments(_that);case AddCommentEvent() when addComment != null:
return addComment(_that);case ToggleCommentLikeEvent() when toggleLike != null:
return toggleLike(_that);case ToggleCollapseEvent() when toggleCollapse != null:
return toggleCollapse(_that);case DeleteCommentEvent() when deleteComment != null:
return deleteComment(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadCommentsEvent value)  loadComments,required TResult Function( AddCommentEvent value)  addComment,required TResult Function( ToggleCommentLikeEvent value)  toggleLike,required TResult Function( ToggleCollapseEvent value)  toggleCollapse,required TResult Function( DeleteCommentEvent value)  deleteComment,}){
final _that = this;
switch (_that) {
case LoadCommentsEvent():
return loadComments(_that);case AddCommentEvent():
return addComment(_that);case ToggleCommentLikeEvent():
return toggleLike(_that);case ToggleCollapseEvent():
return toggleCollapse(_that);case DeleteCommentEvent():
return deleteComment(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadCommentsEvent value)?  loadComments,TResult? Function( AddCommentEvent value)?  addComment,TResult? Function( ToggleCommentLikeEvent value)?  toggleLike,TResult? Function( ToggleCollapseEvent value)?  toggleCollapse,TResult? Function( DeleteCommentEvent value)?  deleteComment,}){
final _that = this;
switch (_that) {
case LoadCommentsEvent() when loadComments != null:
return loadComments(_that);case AddCommentEvent() when addComment != null:
return addComment(_that);case ToggleCommentLikeEvent() when toggleLike != null:
return toggleLike(_that);case ToggleCollapseEvent() when toggleCollapse != null:
return toggleCollapse(_that);case DeleteCommentEvent() when deleteComment != null:
return deleteComment(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String storyId)?  loadComments,TResult Function( String storyId,  String text,  String? parentCommentId)?  addComment,TResult Function( String storyId,  String commentId)?  toggleLike,TResult Function( String commentId)?  toggleCollapse,TResult Function( String storyId,  String commentId)?  deleteComment,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadCommentsEvent() when loadComments != null:
return loadComments(_that.storyId);case AddCommentEvent() when addComment != null:
return addComment(_that.storyId,_that.text,_that.parentCommentId);case ToggleCommentLikeEvent() when toggleLike != null:
return toggleLike(_that.storyId,_that.commentId);case ToggleCollapseEvent() when toggleCollapse != null:
return toggleCollapse(_that.commentId);case DeleteCommentEvent() when deleteComment != null:
return deleteComment(_that.storyId,_that.commentId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String storyId)  loadComments,required TResult Function( String storyId,  String text,  String? parentCommentId)  addComment,required TResult Function( String storyId,  String commentId)  toggleLike,required TResult Function( String commentId)  toggleCollapse,required TResult Function( String storyId,  String commentId)  deleteComment,}) {final _that = this;
switch (_that) {
case LoadCommentsEvent():
return loadComments(_that.storyId);case AddCommentEvent():
return addComment(_that.storyId,_that.text,_that.parentCommentId);case ToggleCommentLikeEvent():
return toggleLike(_that.storyId,_that.commentId);case ToggleCollapseEvent():
return toggleCollapse(_that.commentId);case DeleteCommentEvent():
return deleteComment(_that.storyId,_that.commentId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String storyId)?  loadComments,TResult? Function( String storyId,  String text,  String? parentCommentId)?  addComment,TResult? Function( String storyId,  String commentId)?  toggleLike,TResult? Function( String commentId)?  toggleCollapse,TResult? Function( String storyId,  String commentId)?  deleteComment,}) {final _that = this;
switch (_that) {
case LoadCommentsEvent() when loadComments != null:
return loadComments(_that.storyId);case AddCommentEvent() when addComment != null:
return addComment(_that.storyId,_that.text,_that.parentCommentId);case ToggleCommentLikeEvent() when toggleLike != null:
return toggleLike(_that.storyId,_that.commentId);case ToggleCollapseEvent() when toggleCollapse != null:
return toggleCollapse(_that.commentId);case DeleteCommentEvent() when deleteComment != null:
return deleteComment(_that.storyId,_that.commentId);case _:
  return null;

}
}

}

/// @nodoc


class LoadCommentsEvent implements CommentEvent {
  const LoadCommentsEvent(this.storyId);
  

 final  String storyId;

/// Create a copy of CommentEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadCommentsEventCopyWith<LoadCommentsEvent> get copyWith => _$LoadCommentsEventCopyWithImpl<LoadCommentsEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadCommentsEvent&&(identical(other.storyId, storyId) || other.storyId == storyId));
}


@override
int get hashCode => Object.hash(runtimeType,storyId);

@override
String toString() {
  return 'CommentEvent.loadComments(storyId: $storyId)';
}


}

/// @nodoc
abstract mixin class $LoadCommentsEventCopyWith<$Res> implements $CommentEventCopyWith<$Res> {
  factory $LoadCommentsEventCopyWith(LoadCommentsEvent value, $Res Function(LoadCommentsEvent) _then) = _$LoadCommentsEventCopyWithImpl;
@useResult
$Res call({
 String storyId
});




}
/// @nodoc
class _$LoadCommentsEventCopyWithImpl<$Res>
    implements $LoadCommentsEventCopyWith<$Res> {
  _$LoadCommentsEventCopyWithImpl(this._self, this._then);

  final LoadCommentsEvent _self;
  final $Res Function(LoadCommentsEvent) _then;

/// Create a copy of CommentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? storyId = null,}) {
  return _then(LoadCommentsEvent(
null == storyId ? _self.storyId : storyId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AddCommentEvent implements CommentEvent {
  const AddCommentEvent({required this.storyId, required this.text, this.parentCommentId});
  

 final  String storyId;
 final  String text;
 final  String? parentCommentId;

/// Create a copy of CommentEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddCommentEventCopyWith<AddCommentEvent> get copyWith => _$AddCommentEventCopyWithImpl<AddCommentEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddCommentEvent&&(identical(other.storyId, storyId) || other.storyId == storyId)&&(identical(other.text, text) || other.text == text)&&(identical(other.parentCommentId, parentCommentId) || other.parentCommentId == parentCommentId));
}


@override
int get hashCode => Object.hash(runtimeType,storyId,text,parentCommentId);

@override
String toString() {
  return 'CommentEvent.addComment(storyId: $storyId, text: $text, parentCommentId: $parentCommentId)';
}


}

/// @nodoc
abstract mixin class $AddCommentEventCopyWith<$Res> implements $CommentEventCopyWith<$Res> {
  factory $AddCommentEventCopyWith(AddCommentEvent value, $Res Function(AddCommentEvent) _then) = _$AddCommentEventCopyWithImpl;
@useResult
$Res call({
 String storyId, String text, String? parentCommentId
});




}
/// @nodoc
class _$AddCommentEventCopyWithImpl<$Res>
    implements $AddCommentEventCopyWith<$Res> {
  _$AddCommentEventCopyWithImpl(this._self, this._then);

  final AddCommentEvent _self;
  final $Res Function(AddCommentEvent) _then;

/// Create a copy of CommentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? storyId = null,Object? text = null,Object? parentCommentId = freezed,}) {
  return _then(AddCommentEvent(
storyId: null == storyId ? _self.storyId : storyId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,parentCommentId: freezed == parentCommentId ? _self.parentCommentId : parentCommentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ToggleCommentLikeEvent implements CommentEvent {
  const ToggleCommentLikeEvent({required this.storyId, required this.commentId});
  

 final  String storyId;
 final  String commentId;

/// Create a copy of CommentEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToggleCommentLikeEventCopyWith<ToggleCommentLikeEvent> get copyWith => _$ToggleCommentLikeEventCopyWithImpl<ToggleCommentLikeEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToggleCommentLikeEvent&&(identical(other.storyId, storyId) || other.storyId == storyId)&&(identical(other.commentId, commentId) || other.commentId == commentId));
}


@override
int get hashCode => Object.hash(runtimeType,storyId,commentId);

@override
String toString() {
  return 'CommentEvent.toggleLike(storyId: $storyId, commentId: $commentId)';
}


}

/// @nodoc
abstract mixin class $ToggleCommentLikeEventCopyWith<$Res> implements $CommentEventCopyWith<$Res> {
  factory $ToggleCommentLikeEventCopyWith(ToggleCommentLikeEvent value, $Res Function(ToggleCommentLikeEvent) _then) = _$ToggleCommentLikeEventCopyWithImpl;
@useResult
$Res call({
 String storyId, String commentId
});




}
/// @nodoc
class _$ToggleCommentLikeEventCopyWithImpl<$Res>
    implements $ToggleCommentLikeEventCopyWith<$Res> {
  _$ToggleCommentLikeEventCopyWithImpl(this._self, this._then);

  final ToggleCommentLikeEvent _self;
  final $Res Function(ToggleCommentLikeEvent) _then;

/// Create a copy of CommentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? storyId = null,Object? commentId = null,}) {
  return _then(ToggleCommentLikeEvent(
storyId: null == storyId ? _self.storyId : storyId // ignore: cast_nullable_to_non_nullable
as String,commentId: null == commentId ? _self.commentId : commentId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ToggleCollapseEvent implements CommentEvent {
  const ToggleCollapseEvent(this.commentId);
  

 final  String commentId;

/// Create a copy of CommentEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToggleCollapseEventCopyWith<ToggleCollapseEvent> get copyWith => _$ToggleCollapseEventCopyWithImpl<ToggleCollapseEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToggleCollapseEvent&&(identical(other.commentId, commentId) || other.commentId == commentId));
}


@override
int get hashCode => Object.hash(runtimeType,commentId);

@override
String toString() {
  return 'CommentEvent.toggleCollapse(commentId: $commentId)';
}


}

/// @nodoc
abstract mixin class $ToggleCollapseEventCopyWith<$Res> implements $CommentEventCopyWith<$Res> {
  factory $ToggleCollapseEventCopyWith(ToggleCollapseEvent value, $Res Function(ToggleCollapseEvent) _then) = _$ToggleCollapseEventCopyWithImpl;
@useResult
$Res call({
 String commentId
});




}
/// @nodoc
class _$ToggleCollapseEventCopyWithImpl<$Res>
    implements $ToggleCollapseEventCopyWith<$Res> {
  _$ToggleCollapseEventCopyWithImpl(this._self, this._then);

  final ToggleCollapseEvent _self;
  final $Res Function(ToggleCollapseEvent) _then;

/// Create a copy of CommentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? commentId = null,}) {
  return _then(ToggleCollapseEvent(
null == commentId ? _self.commentId : commentId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DeleteCommentEvent implements CommentEvent {
  const DeleteCommentEvent({required this.storyId, required this.commentId});
  

 final  String storyId;
 final  String commentId;

/// Create a copy of CommentEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteCommentEventCopyWith<DeleteCommentEvent> get copyWith => _$DeleteCommentEventCopyWithImpl<DeleteCommentEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteCommentEvent&&(identical(other.storyId, storyId) || other.storyId == storyId)&&(identical(other.commentId, commentId) || other.commentId == commentId));
}


@override
int get hashCode => Object.hash(runtimeType,storyId,commentId);

@override
String toString() {
  return 'CommentEvent.deleteComment(storyId: $storyId, commentId: $commentId)';
}


}

/// @nodoc
abstract mixin class $DeleteCommentEventCopyWith<$Res> implements $CommentEventCopyWith<$Res> {
  factory $DeleteCommentEventCopyWith(DeleteCommentEvent value, $Res Function(DeleteCommentEvent) _then) = _$DeleteCommentEventCopyWithImpl;
@useResult
$Res call({
 String storyId, String commentId
});




}
/// @nodoc
class _$DeleteCommentEventCopyWithImpl<$Res>
    implements $DeleteCommentEventCopyWith<$Res> {
  _$DeleteCommentEventCopyWithImpl(this._self, this._then);

  final DeleteCommentEvent _self;
  final $Res Function(DeleteCommentEvent) _then;

/// Create a copy of CommentEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? storyId = null,Object? commentId = null,}) {
  return _then(DeleteCommentEvent(
storyId: null == storyId ? _self.storyId : storyId // ignore: cast_nullable_to_non_nullable
as String,commentId: null == commentId ? _self.commentId : commentId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
