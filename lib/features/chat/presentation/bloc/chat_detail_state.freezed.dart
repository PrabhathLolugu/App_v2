// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatDetailState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatDetailState()';
}


}

/// @nodoc
class $ChatDetailStateCopyWith<$Res>  {
$ChatDetailStateCopyWith(ChatDetailState _, $Res Function(ChatDetailState) __);
}


/// Adds pattern-matching-related methods to [ChatDetailState].
extension ChatDetailStatePatterns on ChatDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ChatDetailInitial value)?  initial,TResult Function( ChatDetailLoading value)?  loading,TResult Function( ChatDetailLoaded value)?  loaded,TResult Function( ChatDetailError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ChatDetailInitial() when initial != null:
return initial(_that);case ChatDetailLoading() when loading != null:
return loading(_that);case ChatDetailLoaded() when loaded != null:
return loaded(_that);case ChatDetailError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ChatDetailInitial value)  initial,required TResult Function( ChatDetailLoading value)  loading,required TResult Function( ChatDetailLoaded value)  loaded,required TResult Function( ChatDetailError value)  error,}){
final _that = this;
switch (_that) {
case ChatDetailInitial():
return initial(_that);case ChatDetailLoading():
return loading(_that);case ChatDetailLoaded():
return loaded(_that);case ChatDetailError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ChatDetailInitial value)?  initial,TResult? Function( ChatDetailLoading value)?  loading,TResult? Function( ChatDetailLoaded value)?  loaded,TResult? Function( ChatDetailError value)?  error,}){
final _that = this;
switch (_that) {
case ChatDetailInitial() when initial != null:
return initial(_that);case ChatDetailLoading() when loading != null:
return loading(_that);case ChatDetailLoaded() when loaded != null:
return loaded(_that);case ChatDetailError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String conversationId,  List<Message> messages,  bool isTyping,  bool isSending,  String? error,  bool isOfflineError)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ChatDetailInitial() when initial != null:
return initial();case ChatDetailLoading() when loading != null:
return loading();case ChatDetailLoaded() when loaded != null:
return loaded(_that.conversationId,_that.messages,_that.isTyping,_that.isSending,_that.error,_that.isOfflineError);case ChatDetailError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String conversationId,  List<Message> messages,  bool isTyping,  bool isSending,  String? error,  bool isOfflineError)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case ChatDetailInitial():
return initial();case ChatDetailLoading():
return loading();case ChatDetailLoaded():
return loaded(_that.conversationId,_that.messages,_that.isTyping,_that.isSending,_that.error,_that.isOfflineError);case ChatDetailError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String conversationId,  List<Message> messages,  bool isTyping,  bool isSending,  String? error,  bool isOfflineError)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case ChatDetailInitial() when initial != null:
return initial();case ChatDetailLoading() when loading != null:
return loading();case ChatDetailLoaded() when loaded != null:
return loaded(_that.conversationId,_that.messages,_that.isTyping,_that.isSending,_that.error,_that.isOfflineError);case ChatDetailError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ChatDetailInitial extends ChatDetailState {
  const ChatDetailInitial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatDetailInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatDetailState.initial()';
}


}




/// @nodoc


class ChatDetailLoading extends ChatDetailState {
  const ChatDetailLoading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatDetailState.loading()';
}


}




/// @nodoc


class ChatDetailLoaded extends ChatDetailState {
  const ChatDetailLoaded({required this.conversationId, required final  List<Message> messages, this.isTyping = false, this.isSending = false, this.error, this.isOfflineError = false}): _messages = messages,super._();
  

 final  String conversationId;
 final  List<Message> _messages;
 List<Message> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@JsonKey() final  bool isTyping;
@JsonKey() final  bool isSending;
 final  String? error;
@JsonKey() final  bool isOfflineError;

/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatDetailLoadedCopyWith<ChatDetailLoaded> get copyWith => _$ChatDetailLoadedCopyWithImpl<ChatDetailLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatDetailLoaded&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.isTyping, isTyping) || other.isTyping == isTyping)&&(identical(other.isSending, isSending) || other.isSending == isSending)&&(identical(other.error, error) || other.error == error)&&(identical(other.isOfflineError, isOfflineError) || other.isOfflineError == isOfflineError));
}


@override
int get hashCode => Object.hash(runtimeType,conversationId,const DeepCollectionEquality().hash(_messages),isTyping,isSending,error,isOfflineError);

@override
String toString() {
  return 'ChatDetailState.loaded(conversationId: $conversationId, messages: $messages, isTyping: $isTyping, isSending: $isSending, error: $error, isOfflineError: $isOfflineError)';
}


}

/// @nodoc
abstract mixin class $ChatDetailLoadedCopyWith<$Res> implements $ChatDetailStateCopyWith<$Res> {
  factory $ChatDetailLoadedCopyWith(ChatDetailLoaded value, $Res Function(ChatDetailLoaded) _then) = _$ChatDetailLoadedCopyWithImpl;
@useResult
$Res call({
 String conversationId, List<Message> messages, bool isTyping, bool isSending, String? error, bool isOfflineError
});




}
/// @nodoc
class _$ChatDetailLoadedCopyWithImpl<$Res>
    implements $ChatDetailLoadedCopyWith<$Res> {
  _$ChatDetailLoadedCopyWithImpl(this._self, this._then);

  final ChatDetailLoaded _self;
  final $Res Function(ChatDetailLoaded) _then;

/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? conversationId = null,Object? messages = null,Object? isTyping = null,Object? isSending = null,Object? error = freezed,Object? isOfflineError = null,}) {
  return _then(ChatDetailLoaded(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<Message>,isTyping: null == isTyping ? _self.isTyping : isTyping // ignore: cast_nullable_to_non_nullable
as bool,isSending: null == isSending ? _self.isSending : isSending // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,isOfflineError: null == isOfflineError ? _self.isOfflineError : isOfflineError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class ChatDetailError extends ChatDetailState {
  const ChatDetailError(this.message): super._();
  

 final  String message;

/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatDetailErrorCopyWith<ChatDetailError> get copyWith => _$ChatDetailErrorCopyWithImpl<ChatDetailError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatDetailError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ChatDetailState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ChatDetailErrorCopyWith<$Res> implements $ChatDetailStateCopyWith<$Res> {
  factory $ChatDetailErrorCopyWith(ChatDetailError value, $Res Function(ChatDetailError) _then) = _$ChatDetailErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ChatDetailErrorCopyWithImpl<$Res>
    implements $ChatDetailErrorCopyWith<$Res> {
  _$ChatDetailErrorCopyWithImpl(this._self, this._then);

  final ChatDetailError _self;
  final $Res Function(ChatDetailError) _then;

/// Create a copy of ChatDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ChatDetailError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
