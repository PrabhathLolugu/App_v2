// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_prompt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StoryPrompt {

 String? get scripture; String? get scriptureSubtype; String? get storyType; String? get theme; String? get mainCharacter; String? get setting; String? get rawPrompt; bool get isRawPrompt;
/// Create a copy of StoryPrompt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryPromptCopyWith<StoryPrompt> get copyWith => _$StoryPromptCopyWithImpl<StoryPrompt>(this as StoryPrompt, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryPrompt&&(identical(other.scripture, scripture) || other.scripture == scripture)&&(identical(other.scriptureSubtype, scriptureSubtype) || other.scriptureSubtype == scriptureSubtype)&&(identical(other.storyType, storyType) || other.storyType == storyType)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.mainCharacter, mainCharacter) || other.mainCharacter == mainCharacter)&&(identical(other.setting, setting) || other.setting == setting)&&(identical(other.rawPrompt, rawPrompt) || other.rawPrompt == rawPrompt)&&(identical(other.isRawPrompt, isRawPrompt) || other.isRawPrompt == isRawPrompt));
}


@override
int get hashCode => Object.hash(runtimeType,scripture,scriptureSubtype,storyType,theme,mainCharacter,setting,rawPrompt,isRawPrompt);

@override
String toString() {
  return 'StoryPrompt(scripture: $scripture, scriptureSubtype: $scriptureSubtype, storyType: $storyType, theme: $theme, mainCharacter: $mainCharacter, setting: $setting, rawPrompt: $rawPrompt, isRawPrompt: $isRawPrompt)';
}


}

/// @nodoc
abstract mixin class $StoryPromptCopyWith<$Res>  {
  factory $StoryPromptCopyWith(StoryPrompt value, $Res Function(StoryPrompt) _then) = _$StoryPromptCopyWithImpl;
@useResult
$Res call({
 String? scripture, String? scriptureSubtype, String? storyType, String? theme, String? mainCharacter, String? setting, String? rawPrompt, bool isRawPrompt
});




}
/// @nodoc
class _$StoryPromptCopyWithImpl<$Res>
    implements $StoryPromptCopyWith<$Res> {
  _$StoryPromptCopyWithImpl(this._self, this._then);

  final StoryPrompt _self;
  final $Res Function(StoryPrompt) _then;

/// Create a copy of StoryPrompt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scripture = freezed,Object? scriptureSubtype = freezed,Object? storyType = freezed,Object? theme = freezed,Object? mainCharacter = freezed,Object? setting = freezed,Object? rawPrompt = freezed,Object? isRawPrompt = null,}) {
  return _then(_self.copyWith(
scripture: freezed == scripture ? _self.scripture : scripture // ignore: cast_nullable_to_non_nullable
as String?,scriptureSubtype: freezed == scriptureSubtype ? _self.scriptureSubtype : scriptureSubtype // ignore: cast_nullable_to_non_nullable
as String?,storyType: freezed == storyType ? _self.storyType : storyType // ignore: cast_nullable_to_non_nullable
as String?,theme: freezed == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String?,mainCharacter: freezed == mainCharacter ? _self.mainCharacter : mainCharacter // ignore: cast_nullable_to_non_nullable
as String?,setting: freezed == setting ? _self.setting : setting // ignore: cast_nullable_to_non_nullable
as String?,rawPrompt: freezed == rawPrompt ? _self.rawPrompt : rawPrompt // ignore: cast_nullable_to_non_nullable
as String?,isRawPrompt: null == isRawPrompt ? _self.isRawPrompt : isRawPrompt // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StoryPrompt].
extension StoryPromptPatterns on StoryPrompt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoryPrompt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoryPrompt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoryPrompt value)  $default,){
final _that = this;
switch (_that) {
case _StoryPrompt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoryPrompt value)?  $default,){
final _that = this;
switch (_that) {
case _StoryPrompt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? scripture,  String? scriptureSubtype,  String? storyType,  String? theme,  String? mainCharacter,  String? setting,  String? rawPrompt,  bool isRawPrompt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoryPrompt() when $default != null:
return $default(_that.scripture,_that.scriptureSubtype,_that.storyType,_that.theme,_that.mainCharacter,_that.setting,_that.rawPrompt,_that.isRawPrompt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? scripture,  String? scriptureSubtype,  String? storyType,  String? theme,  String? mainCharacter,  String? setting,  String? rawPrompt,  bool isRawPrompt)  $default,) {final _that = this;
switch (_that) {
case _StoryPrompt():
return $default(_that.scripture,_that.scriptureSubtype,_that.storyType,_that.theme,_that.mainCharacter,_that.setting,_that.rawPrompt,_that.isRawPrompt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? scripture,  String? scriptureSubtype,  String? storyType,  String? theme,  String? mainCharacter,  String? setting,  String? rawPrompt,  bool isRawPrompt)?  $default,) {final _that = this;
switch (_that) {
case _StoryPrompt() when $default != null:
return $default(_that.scripture,_that.scriptureSubtype,_that.storyType,_that.theme,_that.mainCharacter,_that.setting,_that.rawPrompt,_that.isRawPrompt);case _:
  return null;

}
}

}

/// @nodoc


class _StoryPrompt extends StoryPrompt {
  const _StoryPrompt({this.scripture, this.scriptureSubtype, this.storyType, this.theme, this.mainCharacter, this.setting, this.rawPrompt, this.isRawPrompt = false}): super._();
  

@override final  String? scripture;
@override final  String? scriptureSubtype;
@override final  String? storyType;
@override final  String? theme;
@override final  String? mainCharacter;
@override final  String? setting;
@override final  String? rawPrompt;
@override@JsonKey() final  bool isRawPrompt;

/// Create a copy of StoryPrompt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryPromptCopyWith<_StoryPrompt> get copyWith => __$StoryPromptCopyWithImpl<_StoryPrompt>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoryPrompt&&(identical(other.scripture, scripture) || other.scripture == scripture)&&(identical(other.scriptureSubtype, scriptureSubtype) || other.scriptureSubtype == scriptureSubtype)&&(identical(other.storyType, storyType) || other.storyType == storyType)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.mainCharacter, mainCharacter) || other.mainCharacter == mainCharacter)&&(identical(other.setting, setting) || other.setting == setting)&&(identical(other.rawPrompt, rawPrompt) || other.rawPrompt == rawPrompt)&&(identical(other.isRawPrompt, isRawPrompt) || other.isRawPrompt == isRawPrompt));
}


@override
int get hashCode => Object.hash(runtimeType,scripture,scriptureSubtype,storyType,theme,mainCharacter,setting,rawPrompt,isRawPrompt);

@override
String toString() {
  return 'StoryPrompt(scripture: $scripture, scriptureSubtype: $scriptureSubtype, storyType: $storyType, theme: $theme, mainCharacter: $mainCharacter, setting: $setting, rawPrompt: $rawPrompt, isRawPrompt: $isRawPrompt)';
}


}

/// @nodoc
abstract mixin class _$StoryPromptCopyWith<$Res> implements $StoryPromptCopyWith<$Res> {
  factory _$StoryPromptCopyWith(_StoryPrompt value, $Res Function(_StoryPrompt) _then) = __$StoryPromptCopyWithImpl;
@override @useResult
$Res call({
 String? scripture, String? scriptureSubtype, String? storyType, String? theme, String? mainCharacter, String? setting, String? rawPrompt, bool isRawPrompt
});




}
/// @nodoc
class __$StoryPromptCopyWithImpl<$Res>
    implements _$StoryPromptCopyWith<$Res> {
  __$StoryPromptCopyWithImpl(this._self, this._then);

  final _StoryPrompt _self;
  final $Res Function(_StoryPrompt) _then;

/// Create a copy of StoryPrompt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scripture = freezed,Object? scriptureSubtype = freezed,Object? storyType = freezed,Object? theme = freezed,Object? mainCharacter = freezed,Object? setting = freezed,Object? rawPrompt = freezed,Object? isRawPrompt = null,}) {
  return _then(_StoryPrompt(
scripture: freezed == scripture ? _self.scripture : scripture // ignore: cast_nullable_to_non_nullable
as String?,scriptureSubtype: freezed == scriptureSubtype ? _self.scriptureSubtype : scriptureSubtype // ignore: cast_nullable_to_non_nullable
as String?,storyType: freezed == storyType ? _self.storyType : storyType // ignore: cast_nullable_to_non_nullable
as String?,theme: freezed == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String?,mainCharacter: freezed == mainCharacter ? _self.mainCharacter : mainCharacter // ignore: cast_nullable_to_non_nullable
as String?,setting: freezed == setting ? _self.setting : setting // ignore: cast_nullable_to_non_nullable
as String?,rawPrompt: freezed == rawPrompt ? _self.rawPrompt : rawPrompt // ignore: cast_nullable_to_non_nullable
as String?,isRawPrompt: null == isRawPrompt ? _self.isRawPrompt : isRawPrompt // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
