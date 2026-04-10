// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'generator_options.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GeneratorOptions {

 StoryLanguage get language; StoryFormat get format; StoryLength get length;
/// Create a copy of GeneratorOptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeneratorOptionsCopyWith<GeneratorOptions> get copyWith => _$GeneratorOptionsCopyWithImpl<GeneratorOptions>(this as GeneratorOptions, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeneratorOptions&&(identical(other.language, language) || other.language == language)&&(identical(other.format, format) || other.format == format)&&(identical(other.length, length) || other.length == length));
}


@override
int get hashCode => Object.hash(runtimeType,language,format,length);

@override
String toString() {
  return 'GeneratorOptions(language: $language, format: $format, length: $length)';
}


}

/// @nodoc
abstract mixin class $GeneratorOptionsCopyWith<$Res>  {
  factory $GeneratorOptionsCopyWith(GeneratorOptions value, $Res Function(GeneratorOptions) _then) = _$GeneratorOptionsCopyWithImpl;
@useResult
$Res call({
 StoryLanguage language, StoryFormat format, StoryLength length
});




}
/// @nodoc
class _$GeneratorOptionsCopyWithImpl<$Res>
    implements $GeneratorOptionsCopyWith<$Res> {
  _$GeneratorOptionsCopyWithImpl(this._self, this._then);

  final GeneratorOptions _self;
  final $Res Function(GeneratorOptions) _then;

/// Create a copy of GeneratorOptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? language = null,Object? format = null,Object? length = null,}) {
  return _then(_self.copyWith(
language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as StoryLanguage,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as StoryFormat,length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as StoryLength,
  ));
}

}


/// Adds pattern-matching-related methods to [GeneratorOptions].
extension GeneratorOptionsPatterns on GeneratorOptions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeneratorOptions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeneratorOptions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeneratorOptions value)  $default,){
final _that = this;
switch (_that) {
case _GeneratorOptions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeneratorOptions value)?  $default,){
final _that = this;
switch (_that) {
case _GeneratorOptions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StoryLanguage language,  StoryFormat format,  StoryLength length)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeneratorOptions() when $default != null:
return $default(_that.language,_that.format,_that.length);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StoryLanguage language,  StoryFormat format,  StoryLength length)  $default,) {final _that = this;
switch (_that) {
case _GeneratorOptions():
return $default(_that.language,_that.format,_that.length);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StoryLanguage language,  StoryFormat format,  StoryLength length)?  $default,) {final _that = this;
switch (_that) {
case _GeneratorOptions() when $default != null:
return $default(_that.language,_that.format,_that.length);case _:
  return null;

}
}

}

/// @nodoc


class _GeneratorOptions extends GeneratorOptions {
  const _GeneratorOptions({this.language = StoryLanguage.english, this.format = StoryFormat.narrative, this.length = StoryLength.medium}): super._();
  

@override@JsonKey() final  StoryLanguage language;
@override@JsonKey() final  StoryFormat format;
@override@JsonKey() final  StoryLength length;

/// Create a copy of GeneratorOptions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeneratorOptionsCopyWith<_GeneratorOptions> get copyWith => __$GeneratorOptionsCopyWithImpl<_GeneratorOptions>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeneratorOptions&&(identical(other.language, language) || other.language == language)&&(identical(other.format, format) || other.format == format)&&(identical(other.length, length) || other.length == length));
}


@override
int get hashCode => Object.hash(runtimeType,language,format,length);

@override
String toString() {
  return 'GeneratorOptions(language: $language, format: $format, length: $length)';
}


}

/// @nodoc
abstract mixin class _$GeneratorOptionsCopyWith<$Res> implements $GeneratorOptionsCopyWith<$Res> {
  factory _$GeneratorOptionsCopyWith(_GeneratorOptions value, $Res Function(_GeneratorOptions) _then) = __$GeneratorOptionsCopyWithImpl;
@override @useResult
$Res call({
 StoryLanguage language, StoryFormat format, StoryLength length
});




}
/// @nodoc
class __$GeneratorOptionsCopyWithImpl<$Res>
    implements _$GeneratorOptionsCopyWith<$Res> {
  __$GeneratorOptionsCopyWithImpl(this._self, this._then);

  final _GeneratorOptions _self;
  final $Res Function(_GeneratorOptions) _then;

/// Create a copy of GeneratorOptions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? language = null,Object? format = null,Object? length = null,}) {
  return _then(_GeneratorOptions(
language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as StoryLanguage,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as StoryFormat,length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as StoryLength,
  ));
}


}

// dart format on
