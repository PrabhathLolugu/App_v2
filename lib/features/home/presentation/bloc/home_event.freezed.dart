// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeEvent()';
}


}

/// @nodoc
class $HomeEventCopyWith<$Res>  {
$HomeEventCopyWith(HomeEvent _, $Res Function(HomeEvent) __);
}


/// Adds pattern-matching-related methods to [HomeEvent].
extension HomeEventPatterns on HomeEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _LoadHome value)?  loadHome,TResult Function( _Refresh value)?  refresh,TResult Function( _LoadQuote value)?  loadQuote,TResult Function( _LoadFeaturedStories value)?  loadFeaturedStories,TResult Function( _LoadContinueReading value)?  loadContinueReading,TResult Function( _LoadSavedStories value)?  loadSavedStories,TResult Function( _LoadMyGeneratedStories value)?  loadMyGeneratedStories,TResult Function( _ReloadStorySectionsQuietly value)?  reloadStorySectionsQuietly,TResult Function( _ShareQuote value)?  shareQuote,TResult Function( _CopyQuote value)?  copyQuote,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoadHome() when loadHome != null:
return loadHome(_that);case _Refresh() when refresh != null:
return refresh(_that);case _LoadQuote() when loadQuote != null:
return loadQuote(_that);case _LoadFeaturedStories() when loadFeaturedStories != null:
return loadFeaturedStories(_that);case _LoadContinueReading() when loadContinueReading != null:
return loadContinueReading(_that);case _LoadSavedStories() when loadSavedStories != null:
return loadSavedStories(_that);case _LoadMyGeneratedStories() when loadMyGeneratedStories != null:
return loadMyGeneratedStories(_that);case _ReloadStorySectionsQuietly() when reloadStorySectionsQuietly != null:
return reloadStorySectionsQuietly(_that);case _ShareQuote() when shareQuote != null:
return shareQuote(_that);case _CopyQuote() when copyQuote != null:
return copyQuote(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _LoadHome value)  loadHome,required TResult Function( _Refresh value)  refresh,required TResult Function( _LoadQuote value)  loadQuote,required TResult Function( _LoadFeaturedStories value)  loadFeaturedStories,required TResult Function( _LoadContinueReading value)  loadContinueReading,required TResult Function( _LoadSavedStories value)  loadSavedStories,required TResult Function( _LoadMyGeneratedStories value)  loadMyGeneratedStories,required TResult Function( _ReloadStorySectionsQuietly value)  reloadStorySectionsQuietly,required TResult Function( _ShareQuote value)  shareQuote,required TResult Function( _CopyQuote value)  copyQuote,}){
final _that = this;
switch (_that) {
case _LoadHome():
return loadHome(_that);case _Refresh():
return refresh(_that);case _LoadQuote():
return loadQuote(_that);case _LoadFeaturedStories():
return loadFeaturedStories(_that);case _LoadContinueReading():
return loadContinueReading(_that);case _LoadSavedStories():
return loadSavedStories(_that);case _LoadMyGeneratedStories():
return loadMyGeneratedStories(_that);case _ReloadStorySectionsQuietly():
return reloadStorySectionsQuietly(_that);case _ShareQuote():
return shareQuote(_that);case _CopyQuote():
return copyQuote(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _LoadHome value)?  loadHome,TResult? Function( _Refresh value)?  refresh,TResult? Function( _LoadQuote value)?  loadQuote,TResult? Function( _LoadFeaturedStories value)?  loadFeaturedStories,TResult? Function( _LoadContinueReading value)?  loadContinueReading,TResult? Function( _LoadSavedStories value)?  loadSavedStories,TResult? Function( _LoadMyGeneratedStories value)?  loadMyGeneratedStories,TResult? Function( _ReloadStorySectionsQuietly value)?  reloadStorySectionsQuietly,TResult? Function( _ShareQuote value)?  shareQuote,TResult? Function( _CopyQuote value)?  copyQuote,}){
final _that = this;
switch (_that) {
case _LoadHome() when loadHome != null:
return loadHome(_that);case _Refresh() when refresh != null:
return refresh(_that);case _LoadQuote() when loadQuote != null:
return loadQuote(_that);case _LoadFeaturedStories() when loadFeaturedStories != null:
return loadFeaturedStories(_that);case _LoadContinueReading() when loadContinueReading != null:
return loadContinueReading(_that);case _LoadSavedStories() when loadSavedStories != null:
return loadSavedStories(_that);case _LoadMyGeneratedStories() when loadMyGeneratedStories != null:
return loadMyGeneratedStories(_that);case _ReloadStorySectionsQuietly() when reloadStorySectionsQuietly != null:
return reloadStorySectionsQuietly(_that);case _ShareQuote() when shareQuote != null:
return shareQuote(_that);case _CopyQuote() when copyQuote != null:
return copyQuote(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadHome,TResult Function()?  refresh,TResult Function()?  loadQuote,TResult Function()?  loadFeaturedStories,TResult Function()?  loadContinueReading,TResult Function()?  loadSavedStories,TResult Function()?  loadMyGeneratedStories,TResult Function()?  reloadStorySectionsQuietly,TResult Function()?  shareQuote,TResult Function()?  copyQuote,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoadHome() when loadHome != null:
return loadHome();case _Refresh() when refresh != null:
return refresh();case _LoadQuote() when loadQuote != null:
return loadQuote();case _LoadFeaturedStories() when loadFeaturedStories != null:
return loadFeaturedStories();case _LoadContinueReading() when loadContinueReading != null:
return loadContinueReading();case _LoadSavedStories() when loadSavedStories != null:
return loadSavedStories();case _LoadMyGeneratedStories() when loadMyGeneratedStories != null:
return loadMyGeneratedStories();case _ReloadStorySectionsQuietly() when reloadStorySectionsQuietly != null:
return reloadStorySectionsQuietly();case _ShareQuote() when shareQuote != null:
return shareQuote();case _CopyQuote() when copyQuote != null:
return copyQuote();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadHome,required TResult Function()  refresh,required TResult Function()  loadQuote,required TResult Function()  loadFeaturedStories,required TResult Function()  loadContinueReading,required TResult Function()  loadSavedStories,required TResult Function()  loadMyGeneratedStories,required TResult Function()  reloadStorySectionsQuietly,required TResult Function()  shareQuote,required TResult Function()  copyQuote,}) {final _that = this;
switch (_that) {
case _LoadHome():
return loadHome();case _Refresh():
return refresh();case _LoadQuote():
return loadQuote();case _LoadFeaturedStories():
return loadFeaturedStories();case _LoadContinueReading():
return loadContinueReading();case _LoadSavedStories():
return loadSavedStories();case _LoadMyGeneratedStories():
return loadMyGeneratedStories();case _ReloadStorySectionsQuietly():
return reloadStorySectionsQuietly();case _ShareQuote():
return shareQuote();case _CopyQuote():
return copyQuote();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadHome,TResult? Function()?  refresh,TResult? Function()?  loadQuote,TResult? Function()?  loadFeaturedStories,TResult? Function()?  loadContinueReading,TResult? Function()?  loadSavedStories,TResult? Function()?  loadMyGeneratedStories,TResult? Function()?  reloadStorySectionsQuietly,TResult? Function()?  shareQuote,TResult? Function()?  copyQuote,}) {final _that = this;
switch (_that) {
case _LoadHome() when loadHome != null:
return loadHome();case _Refresh() when refresh != null:
return refresh();case _LoadQuote() when loadQuote != null:
return loadQuote();case _LoadFeaturedStories() when loadFeaturedStories != null:
return loadFeaturedStories();case _LoadContinueReading() when loadContinueReading != null:
return loadContinueReading();case _LoadSavedStories() when loadSavedStories != null:
return loadSavedStories();case _LoadMyGeneratedStories() when loadMyGeneratedStories != null:
return loadMyGeneratedStories();case _ReloadStorySectionsQuietly() when reloadStorySectionsQuietly != null:
return reloadStorySectionsQuietly();case _ShareQuote() when shareQuote != null:
return shareQuote();case _CopyQuote() when copyQuote != null:
return copyQuote();case _:
  return null;

}
}

}

/// @nodoc


class _LoadHome implements HomeEvent {
  const _LoadHome();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadHome);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeEvent.loadHome()';
}


}




/// @nodoc


class _Refresh implements HomeEvent {
  const _Refresh();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Refresh);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeEvent.refresh()';
}


}




/// @nodoc


class _LoadQuote implements HomeEvent {
  const _LoadQuote();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadQuote);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeEvent.loadQuote()';
}


}




/// @nodoc


class _LoadFeaturedStories implements HomeEvent {
  const _LoadFeaturedStories();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadFeaturedStories);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeEvent.loadFeaturedStories()';
}


}




/// @nodoc


class _LoadContinueReading implements HomeEvent {
  const _LoadContinueReading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadContinueReading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeEvent.loadContinueReading()';
}


}




/// @nodoc


class _LoadSavedStories implements HomeEvent {
  const _LoadSavedStories();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadSavedStories);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeEvent.loadSavedStories()';
}


}




/// @nodoc


class _LoadMyGeneratedStories implements HomeEvent {
  const _LoadMyGeneratedStories();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadMyGeneratedStories);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeEvent.loadMyGeneratedStories()';
}


}




/// @nodoc


class _ReloadStorySectionsQuietly implements HomeEvent {
  const _ReloadStorySectionsQuietly();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReloadStorySectionsQuietly);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeEvent.reloadStorySectionsQuietly()';
}


}




/// @nodoc


class _ShareQuote implements HomeEvent {
  const _ShareQuote();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShareQuote);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeEvent.shareQuote()';
}


}




/// @nodoc


class _CopyQuote implements HomeEvent {
  const _CopyQuote();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CopyQuote);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeEvent.copyQuote()';
}


}




// dart format on
