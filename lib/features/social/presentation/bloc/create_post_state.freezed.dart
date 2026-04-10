// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_post_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CreatePostState {

 PostType get postType; String get content; String get title; List<File> get mediaFiles;/// Same length as [mediaFiles]. Optional aspect ratio (image) or duration (video).
 List<MediaEditInfo?> get mediaEditInfos; PostVisibility get visibility; bool get isSubmitting; String? get errorMessage;/// When true, the post will be scheduled instead of published immediately.
 bool get isScheduled;/// The user-selected scheduled time in the device's local timezone
/// (intended to be IST for most users).
 DateTime? get scheduledAtLocal;/// Validation message specifically for scheduling issues (e.g. time in past).
 String? get schedulingErrorMessage; bool get isSuccess; String? get createdPostId; bool get isOfflineError; bool get showValidationError; bool get pollEnabled; List<String> get pollOptions;
/// Create a copy of CreatePostState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatePostStateCopyWith<CreatePostState> get copyWith => _$CreatePostStateCopyWithImpl<CreatePostState>(this as CreatePostState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatePostState&&(identical(other.postType, postType) || other.postType == postType)&&(identical(other.content, content) || other.content == content)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.mediaFiles, mediaFiles)&&const DeepCollectionEquality().equals(other.mediaEditInfos, mediaEditInfos)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isScheduled, isScheduled) || other.isScheduled == isScheduled)&&(identical(other.scheduledAtLocal, scheduledAtLocal) || other.scheduledAtLocal == scheduledAtLocal)&&(identical(other.schedulingErrorMessage, schedulingErrorMessage) || other.schedulingErrorMessage == schedulingErrorMessage)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.createdPostId, createdPostId) || other.createdPostId == createdPostId)&&(identical(other.isOfflineError, isOfflineError) || other.isOfflineError == isOfflineError)&&(identical(other.showValidationError, showValidationError) || other.showValidationError == showValidationError)&&(identical(other.pollEnabled, pollEnabled) || other.pollEnabled == pollEnabled)&&const DeepCollectionEquality().equals(other.pollOptions, pollOptions));
}


@override
int get hashCode => Object.hash(runtimeType,postType,content,title,const DeepCollectionEquality().hash(mediaFiles),const DeepCollectionEquality().hash(mediaEditInfos),visibility,isSubmitting,errorMessage,isScheduled,scheduledAtLocal,schedulingErrorMessage,isSuccess,createdPostId,isOfflineError,showValidationError,pollEnabled,const DeepCollectionEquality().hash(pollOptions));

@override
String toString() {
  return 'CreatePostState(postType: $postType, content: $content, title: $title, mediaFiles: $mediaFiles, mediaEditInfos: $mediaEditInfos, visibility: $visibility, isSubmitting: $isSubmitting, errorMessage: $errorMessage, isScheduled: $isScheduled, scheduledAtLocal: $scheduledAtLocal, schedulingErrorMessage: $schedulingErrorMessage, isSuccess: $isSuccess, createdPostId: $createdPostId, isOfflineError: $isOfflineError, showValidationError: $showValidationError, pollEnabled: $pollEnabled, pollOptions: $pollOptions)';
}


}

/// @nodoc
abstract mixin class $CreatePostStateCopyWith<$Res>  {
  factory $CreatePostStateCopyWith(CreatePostState value, $Res Function(CreatePostState) _then) = _$CreatePostStateCopyWithImpl;
@useResult
$Res call({
 PostType postType, String content, String title, List<File> mediaFiles, List<MediaEditInfo?> mediaEditInfos, PostVisibility visibility, bool isSubmitting, String? errorMessage, bool isScheduled, DateTime? scheduledAtLocal, String? schedulingErrorMessage, bool isSuccess, String? createdPostId, bool isOfflineError, bool showValidationError, bool pollEnabled, List<String> pollOptions
});




}
/// @nodoc
class _$CreatePostStateCopyWithImpl<$Res>
    implements $CreatePostStateCopyWith<$Res> {
  _$CreatePostStateCopyWithImpl(this._self, this._then);

  final CreatePostState _self;
  final $Res Function(CreatePostState) _then;

/// Create a copy of CreatePostState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? postType = null,Object? content = null,Object? title = null,Object? mediaFiles = null,Object? mediaEditInfos = null,Object? visibility = null,Object? isSubmitting = null,Object? errorMessage = freezed,Object? isScheduled = null,Object? scheduledAtLocal = freezed,Object? schedulingErrorMessage = freezed,Object? isSuccess = null,Object? createdPostId = freezed,Object? isOfflineError = null,Object? showValidationError = null,Object? pollEnabled = null,Object? pollOptions = null,}) {
  return _then(_self.copyWith(
postType: null == postType ? _self.postType : postType // ignore: cast_nullable_to_non_nullable
as PostType,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,mediaFiles: null == mediaFiles ? _self.mediaFiles : mediaFiles // ignore: cast_nullable_to_non_nullable
as List<File>,mediaEditInfos: null == mediaEditInfos ? _self.mediaEditInfos : mediaEditInfos // ignore: cast_nullable_to_non_nullable
as List<MediaEditInfo?>,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as PostVisibility,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isScheduled: null == isScheduled ? _self.isScheduled : isScheduled // ignore: cast_nullable_to_non_nullable
as bool,scheduledAtLocal: freezed == scheduledAtLocal ? _self.scheduledAtLocal : scheduledAtLocal // ignore: cast_nullable_to_non_nullable
as DateTime?,schedulingErrorMessage: freezed == schedulingErrorMessage ? _self.schedulingErrorMessage : schedulingErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,createdPostId: freezed == createdPostId ? _self.createdPostId : createdPostId // ignore: cast_nullable_to_non_nullable
as String?,isOfflineError: null == isOfflineError ? _self.isOfflineError : isOfflineError // ignore: cast_nullable_to_non_nullable
as bool,showValidationError: null == showValidationError ? _self.showValidationError : showValidationError // ignore: cast_nullable_to_non_nullable
as bool,pollEnabled: null == pollEnabled ? _self.pollEnabled : pollEnabled // ignore: cast_nullable_to_non_nullable
as bool,pollOptions: null == pollOptions ? _self.pollOptions : pollOptions // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CreatePostState].
extension CreatePostStatePatterns on CreatePostState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreatePostState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreatePostState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreatePostState value)  $default,){
final _that = this;
switch (_that) {
case _CreatePostState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreatePostState value)?  $default,){
final _that = this;
switch (_that) {
case _CreatePostState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PostType postType,  String content,  String title,  List<File> mediaFiles,  List<MediaEditInfo?> mediaEditInfos,  PostVisibility visibility,  bool isSubmitting,  String? errorMessage,  bool isScheduled,  DateTime? scheduledAtLocal,  String? schedulingErrorMessage,  bool isSuccess,  String? createdPostId,  bool isOfflineError,  bool showValidationError,  bool pollEnabled,  List<String> pollOptions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreatePostState() when $default != null:
return $default(_that.postType,_that.content,_that.title,_that.mediaFiles,_that.mediaEditInfos,_that.visibility,_that.isSubmitting,_that.errorMessage,_that.isScheduled,_that.scheduledAtLocal,_that.schedulingErrorMessage,_that.isSuccess,_that.createdPostId,_that.isOfflineError,_that.showValidationError,_that.pollEnabled,_that.pollOptions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PostType postType,  String content,  String title,  List<File> mediaFiles,  List<MediaEditInfo?> mediaEditInfos,  PostVisibility visibility,  bool isSubmitting,  String? errorMessage,  bool isScheduled,  DateTime? scheduledAtLocal,  String? schedulingErrorMessage,  bool isSuccess,  String? createdPostId,  bool isOfflineError,  bool showValidationError,  bool pollEnabled,  List<String> pollOptions)  $default,) {final _that = this;
switch (_that) {
case _CreatePostState():
return $default(_that.postType,_that.content,_that.title,_that.mediaFiles,_that.mediaEditInfos,_that.visibility,_that.isSubmitting,_that.errorMessage,_that.isScheduled,_that.scheduledAtLocal,_that.schedulingErrorMessage,_that.isSuccess,_that.createdPostId,_that.isOfflineError,_that.showValidationError,_that.pollEnabled,_that.pollOptions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PostType postType,  String content,  String title,  List<File> mediaFiles,  List<MediaEditInfo?> mediaEditInfos,  PostVisibility visibility,  bool isSubmitting,  String? errorMessage,  bool isScheduled,  DateTime? scheduledAtLocal,  String? schedulingErrorMessage,  bool isSuccess,  String? createdPostId,  bool isOfflineError,  bool showValidationError,  bool pollEnabled,  List<String> pollOptions)?  $default,) {final _that = this;
switch (_that) {
case _CreatePostState() when $default != null:
return $default(_that.postType,_that.content,_that.title,_that.mediaFiles,_that.mediaEditInfos,_that.visibility,_that.isSubmitting,_that.errorMessage,_that.isScheduled,_that.scheduledAtLocal,_that.schedulingErrorMessage,_that.isSuccess,_that.createdPostId,_that.isOfflineError,_that.showValidationError,_that.pollEnabled,_that.pollOptions);case _:
  return null;

}
}

}

/// @nodoc


class _CreatePostState extends CreatePostState {
  const _CreatePostState({this.postType = PostType.text, this.content = '', this.title = '', final  List<File> mediaFiles = const [], final  List<MediaEditInfo?> mediaEditInfos = const [], this.visibility = PostVisibility.public, this.isSubmitting = false, this.errorMessage, this.isScheduled = false, this.scheduledAtLocal, this.schedulingErrorMessage, this.isSuccess = false, this.createdPostId, this.isOfflineError = false, this.showValidationError = false, this.pollEnabled = false, final  List<String> pollOptions = const []}): _mediaFiles = mediaFiles,_mediaEditInfos = mediaEditInfos,_pollOptions = pollOptions,super._();
  

@override@JsonKey() final  PostType postType;
@override@JsonKey() final  String content;
@override@JsonKey() final  String title;
 final  List<File> _mediaFiles;
@override@JsonKey() List<File> get mediaFiles {
  if (_mediaFiles is EqualUnmodifiableListView) return _mediaFiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mediaFiles);
}

/// Same length as [mediaFiles]. Optional aspect ratio (image) or duration (video).
 final  List<MediaEditInfo?> _mediaEditInfos;
/// Same length as [mediaFiles]. Optional aspect ratio (image) or duration (video).
@override@JsonKey() List<MediaEditInfo?> get mediaEditInfos {
  if (_mediaEditInfos is EqualUnmodifiableListView) return _mediaEditInfos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mediaEditInfos);
}

@override@JsonKey() final  PostVisibility visibility;
@override@JsonKey() final  bool isSubmitting;
@override final  String? errorMessage;
/// When true, the post will be scheduled instead of published immediately.
@override@JsonKey() final  bool isScheduled;
/// The user-selected scheduled time in the device's local timezone
/// (intended to be IST for most users).
@override final  DateTime? scheduledAtLocal;
/// Validation message specifically for scheduling issues (e.g. time in past).
@override final  String? schedulingErrorMessage;
@override@JsonKey() final  bool isSuccess;
@override final  String? createdPostId;
@override@JsonKey() final  bool isOfflineError;
@override@JsonKey() final  bool showValidationError;
@override@JsonKey() final  bool pollEnabled;
 final  List<String> _pollOptions;
@override@JsonKey() List<String> get pollOptions {
  if (_pollOptions is EqualUnmodifiableListView) return _pollOptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pollOptions);
}


/// Create a copy of CreatePostState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatePostStateCopyWith<_CreatePostState> get copyWith => __$CreatePostStateCopyWithImpl<_CreatePostState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreatePostState&&(identical(other.postType, postType) || other.postType == postType)&&(identical(other.content, content) || other.content == content)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._mediaFiles, _mediaFiles)&&const DeepCollectionEquality().equals(other._mediaEditInfos, _mediaEditInfos)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isScheduled, isScheduled) || other.isScheduled == isScheduled)&&(identical(other.scheduledAtLocal, scheduledAtLocal) || other.scheduledAtLocal == scheduledAtLocal)&&(identical(other.schedulingErrorMessage, schedulingErrorMessage) || other.schedulingErrorMessage == schedulingErrorMessage)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.createdPostId, createdPostId) || other.createdPostId == createdPostId)&&(identical(other.isOfflineError, isOfflineError) || other.isOfflineError == isOfflineError)&&(identical(other.showValidationError, showValidationError) || other.showValidationError == showValidationError)&&(identical(other.pollEnabled, pollEnabled) || other.pollEnabled == pollEnabled)&&const DeepCollectionEquality().equals(other._pollOptions, _pollOptions));
}


@override
int get hashCode => Object.hash(runtimeType,postType,content,title,const DeepCollectionEquality().hash(_mediaFiles),const DeepCollectionEquality().hash(_mediaEditInfos),visibility,isSubmitting,errorMessage,isScheduled,scheduledAtLocal,schedulingErrorMessage,isSuccess,createdPostId,isOfflineError,showValidationError,pollEnabled,const DeepCollectionEquality().hash(_pollOptions));

@override
String toString() {
  return 'CreatePostState(postType: $postType, content: $content, title: $title, mediaFiles: $mediaFiles, mediaEditInfos: $mediaEditInfos, visibility: $visibility, isSubmitting: $isSubmitting, errorMessage: $errorMessage, isScheduled: $isScheduled, scheduledAtLocal: $scheduledAtLocal, schedulingErrorMessage: $schedulingErrorMessage, isSuccess: $isSuccess, createdPostId: $createdPostId, isOfflineError: $isOfflineError, showValidationError: $showValidationError, pollEnabled: $pollEnabled, pollOptions: $pollOptions)';
}


}

/// @nodoc
abstract mixin class _$CreatePostStateCopyWith<$Res> implements $CreatePostStateCopyWith<$Res> {
  factory _$CreatePostStateCopyWith(_CreatePostState value, $Res Function(_CreatePostState) _then) = __$CreatePostStateCopyWithImpl;
@override @useResult
$Res call({
 PostType postType, String content, String title, List<File> mediaFiles, List<MediaEditInfo?> mediaEditInfos, PostVisibility visibility, bool isSubmitting, String? errorMessage, bool isScheduled, DateTime? scheduledAtLocal, String? schedulingErrorMessage, bool isSuccess, String? createdPostId, bool isOfflineError, bool showValidationError, bool pollEnabled, List<String> pollOptions
});




}
/// @nodoc
class __$CreatePostStateCopyWithImpl<$Res>
    implements _$CreatePostStateCopyWith<$Res> {
  __$CreatePostStateCopyWithImpl(this._self, this._then);

  final _CreatePostState _self;
  final $Res Function(_CreatePostState) _then;

/// Create a copy of CreatePostState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? postType = null,Object? content = null,Object? title = null,Object? mediaFiles = null,Object? mediaEditInfos = null,Object? visibility = null,Object? isSubmitting = null,Object? errorMessage = freezed,Object? isScheduled = null,Object? scheduledAtLocal = freezed,Object? schedulingErrorMessage = freezed,Object? isSuccess = null,Object? createdPostId = freezed,Object? isOfflineError = null,Object? showValidationError = null,Object? pollEnabled = null,Object? pollOptions = null,}) {
  return _then(_CreatePostState(
postType: null == postType ? _self.postType : postType // ignore: cast_nullable_to_non_nullable
as PostType,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,mediaFiles: null == mediaFiles ? _self._mediaFiles : mediaFiles // ignore: cast_nullable_to_non_nullable
as List<File>,mediaEditInfos: null == mediaEditInfos ? _self._mediaEditInfos : mediaEditInfos // ignore: cast_nullable_to_non_nullable
as List<MediaEditInfo?>,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as PostVisibility,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isScheduled: null == isScheduled ? _self.isScheduled : isScheduled // ignore: cast_nullable_to_non_nullable
as bool,scheduledAtLocal: freezed == scheduledAtLocal ? _self.scheduledAtLocal : scheduledAtLocal // ignore: cast_nullable_to_non_nullable
as DateTime?,schedulingErrorMessage: freezed == schedulingErrorMessage ? _self.schedulingErrorMessage : schedulingErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,createdPostId: freezed == createdPostId ? _self.createdPostId : createdPostId // ignore: cast_nullable_to_non_nullable
as String?,isOfflineError: null == isOfflineError ? _self.isOfflineError : isOfflineError // ignore: cast_nullable_to_non_nullable
as bool,showValidationError: null == showValidationError ? _self.showValidationError : showValidationError // ignore: cast_nullable_to_non_nullable
as bool,pollEnabled: null == pollEnabled ? _self.pollEnabled : pollEnabled // ignore: cast_nullable_to_non_nullable
as bool,pollOptions: null == pollOptions ? _self._pollOptions : pollOptions // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
