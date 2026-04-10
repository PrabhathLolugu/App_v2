// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_poll.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PostPoll {

 List<String> get options; List<int> get voteCounts; int get totalVotes; int? get mySelectedIndex;
/// Create a copy of PostPoll
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostPollCopyWith<PostPoll> get copyWith => _$PostPollCopyWithImpl<PostPoll>(this as PostPoll, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostPoll&&const DeepCollectionEquality().equals(other.options, options)&&const DeepCollectionEquality().equals(other.voteCounts, voteCounts)&&(identical(other.totalVotes, totalVotes) || other.totalVotes == totalVotes)&&(identical(other.mySelectedIndex, mySelectedIndex) || other.mySelectedIndex == mySelectedIndex));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(options),const DeepCollectionEquality().hash(voteCounts),totalVotes,mySelectedIndex);

@override
String toString() {
  return 'PostPoll(options: $options, voteCounts: $voteCounts, totalVotes: $totalVotes, mySelectedIndex: $mySelectedIndex)';
}


}

/// @nodoc
abstract mixin class $PostPollCopyWith<$Res>  {
  factory $PostPollCopyWith(PostPoll value, $Res Function(PostPoll) _then) = _$PostPollCopyWithImpl;
@useResult
$Res call({
 List<String> options, List<int> voteCounts, int totalVotes, int? mySelectedIndex
});




}
/// @nodoc
class _$PostPollCopyWithImpl<$Res>
    implements $PostPollCopyWith<$Res> {
  _$PostPollCopyWithImpl(this._self, this._then);

  final PostPoll _self;
  final $Res Function(PostPoll) _then;

/// Create a copy of PostPoll
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? options = null,Object? voteCounts = null,Object? totalVotes = null,Object? mySelectedIndex = freezed,}) {
  return _then(_self.copyWith(
options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,voteCounts: null == voteCounts ? _self.voteCounts : voteCounts // ignore: cast_nullable_to_non_nullable
as List<int>,totalVotes: null == totalVotes ? _self.totalVotes : totalVotes // ignore: cast_nullable_to_non_nullable
as int,mySelectedIndex: freezed == mySelectedIndex ? _self.mySelectedIndex : mySelectedIndex // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PostPoll].
extension PostPollPatterns on PostPoll {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostPoll value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostPoll() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostPoll value)  $default,){
final _that = this;
switch (_that) {
case _PostPoll():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostPoll value)?  $default,){
final _that = this;
switch (_that) {
case _PostPoll() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> options,  List<int> voteCounts,  int totalVotes,  int? mySelectedIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostPoll() when $default != null:
return $default(_that.options,_that.voteCounts,_that.totalVotes,_that.mySelectedIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> options,  List<int> voteCounts,  int totalVotes,  int? mySelectedIndex)  $default,) {final _that = this;
switch (_that) {
case _PostPoll():
return $default(_that.options,_that.voteCounts,_that.totalVotes,_that.mySelectedIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> options,  List<int> voteCounts,  int totalVotes,  int? mySelectedIndex)?  $default,) {final _that = this;
switch (_that) {
case _PostPoll() when $default != null:
return $default(_that.options,_that.voteCounts,_that.totalVotes,_that.mySelectedIndex);case _:
  return null;

}
}

}

/// @nodoc


class _PostPoll extends PostPoll {
  const _PostPoll({final  List<String> options = const [], final  List<int> voteCounts = const [0, 0, 0, 0], this.totalVotes = 0, this.mySelectedIndex}): _options = options,_voteCounts = voteCounts,super._();
  

 final  List<String> _options;
@override@JsonKey() List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

 final  List<int> _voteCounts;
@override@JsonKey() List<int> get voteCounts {
  if (_voteCounts is EqualUnmodifiableListView) return _voteCounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_voteCounts);
}

@override@JsonKey() final  int totalVotes;
@override final  int? mySelectedIndex;

/// Create a copy of PostPoll
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostPollCopyWith<_PostPoll> get copyWith => __$PostPollCopyWithImpl<_PostPoll>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostPoll&&const DeepCollectionEquality().equals(other._options, _options)&&const DeepCollectionEquality().equals(other._voteCounts, _voteCounts)&&(identical(other.totalVotes, totalVotes) || other.totalVotes == totalVotes)&&(identical(other.mySelectedIndex, mySelectedIndex) || other.mySelectedIndex == mySelectedIndex));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_options),const DeepCollectionEquality().hash(_voteCounts),totalVotes,mySelectedIndex);

@override
String toString() {
  return 'PostPoll(options: $options, voteCounts: $voteCounts, totalVotes: $totalVotes, mySelectedIndex: $mySelectedIndex)';
}


}

/// @nodoc
abstract mixin class _$PostPollCopyWith<$Res> implements $PostPollCopyWith<$Res> {
  factory _$PostPollCopyWith(_PostPoll value, $Res Function(_PostPoll) _then) = __$PostPollCopyWithImpl;
@override @useResult
$Res call({
 List<String> options, List<int> voteCounts, int totalVotes, int? mySelectedIndex
});




}
/// @nodoc
class __$PostPollCopyWithImpl<$Res>
    implements _$PostPollCopyWith<$Res> {
  __$PostPollCopyWithImpl(this._self, this._then);

  final _PostPoll _self;
  final $Res Function(_PostPoll) _then;

/// Create a copy of PostPoll
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? options = null,Object? voteCounts = null,Object? totalVotes = null,Object? mySelectedIndex = freezed,}) {
  return _then(_PostPoll(
options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,voteCounts: null == voteCounts ? _self._voteCounts : voteCounts // ignore: cast_nullable_to_non_nullable
as List<int>,totalVotes: null == totalVotes ? _self.totalVotes : totalVotes // ignore: cast_nullable_to_non_nullable
as int,mySelectedIndex: freezed == mySelectedIndex ? _self.mySelectedIndex : mySelectedIndex // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
