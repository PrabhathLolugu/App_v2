// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CommentState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CommentState()';
}


}

/// @nodoc
class $CommentStateCopyWith<$Res>  {
$CommentStateCopyWith(CommentState _, $Res Function(CommentState) __);
}


/// Adds pattern-matching-related methods to [CommentState].
extension CommentStatePatterns on CommentState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CommentInitial value)?  initial,TResult Function( CommentLoading value)?  loading,TResult Function( CommentLoaded value)?  loaded,TResult Function( CommentError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CommentInitial() when initial != null:
return initial(_that);case CommentLoading() when loading != null:
return loading(_that);case CommentLoaded() when loaded != null:
return loaded(_that);case CommentError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CommentInitial value)  initial,required TResult Function( CommentLoading value)  loading,required TResult Function( CommentLoaded value)  loaded,required TResult Function( CommentError value)  error,}){
final _that = this;
switch (_that) {
case CommentInitial():
return initial(_that);case CommentLoading():
return loading(_that);case CommentLoaded():
return loaded(_that);case CommentError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CommentInitial value)?  initial,TResult? Function( CommentLoading value)?  loading,TResult? Function( CommentLoaded value)?  loaded,TResult? Function( CommentError value)?  error,}){
final _that = this;
switch (_that) {
case CommentInitial() when initial != null:
return initial(_that);case CommentLoading() when loading != null:
return loading(_that);case CommentLoaded() when loaded != null:
return loaded(_that);case CommentError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String storyId,  List<Comment> comments,  Map<String, bool> collapsedStates,  bool isAddingComment,  String? error,  bool isOfflineError)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CommentInitial() when initial != null:
return initial();case CommentLoading() when loading != null:
return loading();case CommentLoaded() when loaded != null:
return loaded(_that.storyId,_that.comments,_that.collapsedStates,_that.isAddingComment,_that.error,_that.isOfflineError);case CommentError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String storyId,  List<Comment> comments,  Map<String, bool> collapsedStates,  bool isAddingComment,  String? error,  bool isOfflineError)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case CommentInitial():
return initial();case CommentLoading():
return loading();case CommentLoaded():
return loaded(_that.storyId,_that.comments,_that.collapsedStates,_that.isAddingComment,_that.error,_that.isOfflineError);case CommentError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String storyId,  List<Comment> comments,  Map<String, bool> collapsedStates,  bool isAddingComment,  String? error,  bool isOfflineError)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case CommentInitial() when initial != null:
return initial();case CommentLoading() when loading != null:
return loading();case CommentLoaded() when loaded != null:
return loaded(_that.storyId,_that.comments,_that.collapsedStates,_that.isAddingComment,_that.error,_that.isOfflineError);case CommentError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class CommentInitial extends CommentState {
  const CommentInitial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CommentState.initial()';
}


}




/// @nodoc


class CommentLoading extends CommentState {
  const CommentLoading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CommentState.loading()';
}


}




/// @nodoc


class CommentLoaded extends CommentState {
  const CommentLoaded({required this.storyId, required final  List<Comment> comments, final  Map<String, bool> collapsedStates = const {}, this.isAddingComment = false, this.error, this.isOfflineError = false}): _comments = comments,_collapsedStates = collapsedStates,super._();
  

 final  String storyId;
 final  List<Comment> _comments;
 List<Comment> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}

 final  Map<String, bool> _collapsedStates;
@JsonKey() Map<String, bool> get collapsedStates {
  if (_collapsedStates is EqualUnmodifiableMapView) return _collapsedStates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_collapsedStates);
}

@JsonKey() final  bool isAddingComment;
 final  String? error;
@JsonKey() final  bool isOfflineError;

/// Create a copy of CommentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentLoadedCopyWith<CommentLoaded> get copyWith => _$CommentLoadedCopyWithImpl<CommentLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentLoaded&&(identical(other.storyId, storyId) || other.storyId == storyId)&&const DeepCollectionEquality().equals(other._comments, _comments)&&const DeepCollectionEquality().equals(other._collapsedStates, _collapsedStates)&&(identical(other.isAddingComment, isAddingComment) || other.isAddingComment == isAddingComment)&&(identical(other.error, error) || other.error == error)&&(identical(other.isOfflineError, isOfflineError) || other.isOfflineError == isOfflineError));
}


@override
int get hashCode => Object.hash(runtimeType,storyId,const DeepCollectionEquality().hash(_comments),const DeepCollectionEquality().hash(_collapsedStates),isAddingComment,error,isOfflineError);

@override
String toString() {
  return 'CommentState.loaded(storyId: $storyId, comments: $comments, collapsedStates: $collapsedStates, isAddingComment: $isAddingComment, error: $error, isOfflineError: $isOfflineError)';
}


}

/// @nodoc
abstract mixin class $CommentLoadedCopyWith<$Res> implements $CommentStateCopyWith<$Res> {
  factory $CommentLoadedCopyWith(CommentLoaded value, $Res Function(CommentLoaded) _then) = _$CommentLoadedCopyWithImpl;
@useResult
$Res call({
 String storyId, List<Comment> comments, Map<String, bool> collapsedStates, bool isAddingComment, String? error, bool isOfflineError
});




}
/// @nodoc
class _$CommentLoadedCopyWithImpl<$Res>
    implements $CommentLoadedCopyWith<$Res> {
  _$CommentLoadedCopyWithImpl(this._self, this._then);

  final CommentLoaded _self;
  final $Res Function(CommentLoaded) _then;

/// Create a copy of CommentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? storyId = null,Object? comments = null,Object? collapsedStates = null,Object? isAddingComment = null,Object? error = freezed,Object? isOfflineError = null,}) {
  return _then(CommentLoaded(
storyId: null == storyId ? _self.storyId : storyId // ignore: cast_nullable_to_non_nullable
as String,comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<Comment>,collapsedStates: null == collapsedStates ? _self._collapsedStates : collapsedStates // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,isAddingComment: null == isAddingComment ? _self.isAddingComment : isAddingComment // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,isOfflineError: null == isOfflineError ? _self.isOfflineError : isOfflineError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class CommentError extends CommentState {
  const CommentError(this.message): super._();
  

 final  String message;

/// Create a copy of CommentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentErrorCopyWith<CommentError> get copyWith => _$CommentErrorCopyWithImpl<CommentError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'CommentState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $CommentErrorCopyWith<$Res> implements $CommentStateCopyWith<$Res> {
  factory $CommentErrorCopyWith(CommentError value, $Res Function(CommentError) _then) = _$CommentErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$CommentErrorCopyWithImpl<$Res>
    implements $CommentErrorCopyWith<$Res> {
  _$CommentErrorCopyWithImpl(this._self, this._then);

  final CommentError _self;
  final $Res Function(CommentError) _then;

/// Create a copy of CommentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(CommentError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
