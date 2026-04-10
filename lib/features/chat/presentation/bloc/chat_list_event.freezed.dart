// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_list_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatListEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatListEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatListEvent()';
}


}

/// @nodoc
class $ChatListEventCopyWith<$Res>  {
$ChatListEventCopyWith(ChatListEvent _, $Res Function(ChatListEvent) __);
}


/// Adds pattern-matching-related methods to [ChatListEvent].
extension ChatListEventPatterns on ChatListEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadConversationsEvent value)?  loadConversations,TResult Function( RefreshConversationsEvent value)?  refreshConversations,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadConversationsEvent() when loadConversations != null:
return loadConversations(_that);case RefreshConversationsEvent() when refreshConversations != null:
return refreshConversations(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadConversationsEvent value)  loadConversations,required TResult Function( RefreshConversationsEvent value)  refreshConversations,}){
final _that = this;
switch (_that) {
case LoadConversationsEvent():
return loadConversations(_that);case RefreshConversationsEvent():
return refreshConversations(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadConversationsEvent value)?  loadConversations,TResult? Function( RefreshConversationsEvent value)?  refreshConversations,}){
final _that = this;
switch (_that) {
case LoadConversationsEvent() when loadConversations != null:
return loadConversations(_that);case RefreshConversationsEvent() when refreshConversations != null:
return refreshConversations(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadConversations,TResult Function()?  refreshConversations,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadConversationsEvent() when loadConversations != null:
return loadConversations();case RefreshConversationsEvent() when refreshConversations != null:
return refreshConversations();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadConversations,required TResult Function()  refreshConversations,}) {final _that = this;
switch (_that) {
case LoadConversationsEvent():
return loadConversations();case RefreshConversationsEvent():
return refreshConversations();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadConversations,TResult? Function()?  refreshConversations,}) {final _that = this;
switch (_that) {
case LoadConversationsEvent() when loadConversations != null:
return loadConversations();case RefreshConversationsEvent() when refreshConversations != null:
return refreshConversations();case _:
  return null;

}
}

}

/// @nodoc


class LoadConversationsEvent implements ChatListEvent {
  const LoadConversationsEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadConversationsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatListEvent.loadConversations()';
}


}




/// @nodoc


class RefreshConversationsEvent implements ChatListEvent {
  const RefreshConversationsEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefreshConversationsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatListEvent.refreshConversations()';
}


}




// dart format on
