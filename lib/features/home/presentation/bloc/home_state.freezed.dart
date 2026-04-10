// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeState {

/// Whether the home screen is loading
 bool get isLoading;/// Whether a refresh is in progress
 bool get isRefreshing;/// Quote of the day
 Quote? get quote;/// Whether quote is loading
 bool get isQuoteLoading;/// Featured stories
 List<Story> get featuredStories;/// Whether featured stories are loading
 bool get isFeaturedLoading;/// Stories in progress (continue reading)
 List<Story> get continueReading;/// Whether continue reading is loading
 bool get isContinueReadingLoading;/// Saved/bookmarked stories
 List<Story> get savedStories;/// Whether saved stories are loading
 bool get isSavedStoriesLoading;/// User's generated stories
 List<Story> get myGeneratedStories;/// Whether generated stories are loading
 bool get isMyGeneratedStoriesLoading;/// Error message if any
 String? get errorMessage;/// Time-based greeting key
 String get greetingKey;/// User's display name
 String? get userName;/// Sacred locations for "Where to Visit" section
 List<SacredLocation> get sacredLocations;/// Whether sacred locations are loading
 bool get isSacredLocationsLoading;/// Sanatan festivals for the Festival Stories section
 List<HinduFestival> get festivals;/// Whether festivals are loading
 bool get isFestivalsLoading;
/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeStateCopyWith<HomeState> get copyWith => _$HomeStateCopyWithImpl<HomeState>(this as HomeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&(identical(other.quote, quote) || other.quote == quote)&&(identical(other.isQuoteLoading, isQuoteLoading) || other.isQuoteLoading == isQuoteLoading)&&const DeepCollectionEquality().equals(other.featuredStories, featuredStories)&&(identical(other.isFeaturedLoading, isFeaturedLoading) || other.isFeaturedLoading == isFeaturedLoading)&&const DeepCollectionEquality().equals(other.continueReading, continueReading)&&(identical(other.isContinueReadingLoading, isContinueReadingLoading) || other.isContinueReadingLoading == isContinueReadingLoading)&&const DeepCollectionEquality().equals(other.savedStories, savedStories)&&(identical(other.isSavedStoriesLoading, isSavedStoriesLoading) || other.isSavedStoriesLoading == isSavedStoriesLoading)&&const DeepCollectionEquality().equals(other.myGeneratedStories, myGeneratedStories)&&(identical(other.isMyGeneratedStoriesLoading, isMyGeneratedStoriesLoading) || other.isMyGeneratedStoriesLoading == isMyGeneratedStoriesLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.greetingKey, greetingKey) || other.greetingKey == greetingKey)&&(identical(other.userName, userName) || other.userName == userName)&&const DeepCollectionEquality().equals(other.sacredLocations, sacredLocations)&&(identical(other.isSacredLocationsLoading, isSacredLocationsLoading) || other.isSacredLocationsLoading == isSacredLocationsLoading)&&const DeepCollectionEquality().equals(other.festivals, festivals)&&(identical(other.isFestivalsLoading, isFestivalsLoading) || other.isFestivalsLoading == isFestivalsLoading));
}


@override
int get hashCode => Object.hashAll([runtimeType,isLoading,isRefreshing,quote,isQuoteLoading,const DeepCollectionEquality().hash(featuredStories),isFeaturedLoading,const DeepCollectionEquality().hash(continueReading),isContinueReadingLoading,const DeepCollectionEquality().hash(savedStories),isSavedStoriesLoading,const DeepCollectionEquality().hash(myGeneratedStories),isMyGeneratedStoriesLoading,errorMessage,greetingKey,userName,const DeepCollectionEquality().hash(sacredLocations),isSacredLocationsLoading,const DeepCollectionEquality().hash(festivals),isFestivalsLoading]);

@override
String toString() {
  return 'HomeState(isLoading: $isLoading, isRefreshing: $isRefreshing, quote: $quote, isQuoteLoading: $isQuoteLoading, featuredStories: $featuredStories, isFeaturedLoading: $isFeaturedLoading, continueReading: $continueReading, isContinueReadingLoading: $isContinueReadingLoading, savedStories: $savedStories, isSavedStoriesLoading: $isSavedStoriesLoading, myGeneratedStories: $myGeneratedStories, isMyGeneratedStoriesLoading: $isMyGeneratedStoriesLoading, errorMessage: $errorMessage, greetingKey: $greetingKey, userName: $userName, sacredLocations: $sacredLocations, isSacredLocationsLoading: $isSacredLocationsLoading, festivals: $festivals, isFestivalsLoading: $isFestivalsLoading)';
}


}

/// @nodoc
abstract mixin class $HomeStateCopyWith<$Res>  {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) _then) = _$HomeStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isRefreshing, Quote? quote, bool isQuoteLoading, List<Story> featuredStories, bool isFeaturedLoading, List<Story> continueReading, bool isContinueReadingLoading, List<Story> savedStories, bool isSavedStoriesLoading, List<Story> myGeneratedStories, bool isMyGeneratedStoriesLoading, String? errorMessage, String greetingKey, String? userName, List<SacredLocation> sacredLocations, bool isSacredLocationsLoading, List<HinduFestival> festivals, bool isFestivalsLoading
});


$QuoteCopyWith<$Res>? get quote;

}
/// @nodoc
class _$HomeStateCopyWithImpl<$Res>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._self, this._then);

  final HomeState _self;
  final $Res Function(HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isRefreshing = null,Object? quote = freezed,Object? isQuoteLoading = null,Object? featuredStories = null,Object? isFeaturedLoading = null,Object? continueReading = null,Object? isContinueReadingLoading = null,Object? savedStories = null,Object? isSavedStoriesLoading = null,Object? myGeneratedStories = null,Object? isMyGeneratedStoriesLoading = null,Object? errorMessage = freezed,Object? greetingKey = null,Object? userName = freezed,Object? sacredLocations = null,Object? isSacredLocationsLoading = null,Object? festivals = null,Object? isFestivalsLoading = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,quote: freezed == quote ? _self.quote : quote // ignore: cast_nullable_to_non_nullable
as Quote?,isQuoteLoading: null == isQuoteLoading ? _self.isQuoteLoading : isQuoteLoading // ignore: cast_nullable_to_non_nullable
as bool,featuredStories: null == featuredStories ? _self.featuredStories : featuredStories // ignore: cast_nullable_to_non_nullable
as List<Story>,isFeaturedLoading: null == isFeaturedLoading ? _self.isFeaturedLoading : isFeaturedLoading // ignore: cast_nullable_to_non_nullable
as bool,continueReading: null == continueReading ? _self.continueReading : continueReading // ignore: cast_nullable_to_non_nullable
as List<Story>,isContinueReadingLoading: null == isContinueReadingLoading ? _self.isContinueReadingLoading : isContinueReadingLoading // ignore: cast_nullable_to_non_nullable
as bool,savedStories: null == savedStories ? _self.savedStories : savedStories // ignore: cast_nullable_to_non_nullable
as List<Story>,isSavedStoriesLoading: null == isSavedStoriesLoading ? _self.isSavedStoriesLoading : isSavedStoriesLoading // ignore: cast_nullable_to_non_nullable
as bool,myGeneratedStories: null == myGeneratedStories ? _self.myGeneratedStories : myGeneratedStories // ignore: cast_nullable_to_non_nullable
as List<Story>,isMyGeneratedStoriesLoading: null == isMyGeneratedStoriesLoading ? _self.isMyGeneratedStoriesLoading : isMyGeneratedStoriesLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,greetingKey: null == greetingKey ? _self.greetingKey : greetingKey // ignore: cast_nullable_to_non_nullable
as String,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,sacredLocations: null == sacredLocations ? _self.sacredLocations : sacredLocations // ignore: cast_nullable_to_non_nullable
as List<SacredLocation>,isSacredLocationsLoading: null == isSacredLocationsLoading ? _self.isSacredLocationsLoading : isSacredLocationsLoading // ignore: cast_nullable_to_non_nullable
as bool,festivals: null == festivals ? _self.festivals : festivals // ignore: cast_nullable_to_non_nullable
as List<HinduFestival>,isFestivalsLoading: null == isFestivalsLoading ? _self.isFestivalsLoading : isFestivalsLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuoteCopyWith<$Res>? get quote {
    if (_self.quote == null) {
    return null;
  }

  return $QuoteCopyWith<$Res>(_self.quote!, (value) {
    return _then(_self.copyWith(quote: value));
  });
}
}


/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeState value)  $default,){
final _that = this;
switch (_that) {
case _HomeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeState value)?  $default,){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isRefreshing,  Quote? quote,  bool isQuoteLoading,  List<Story> featuredStories,  bool isFeaturedLoading,  List<Story> continueReading,  bool isContinueReadingLoading,  List<Story> savedStories,  bool isSavedStoriesLoading,  List<Story> myGeneratedStories,  bool isMyGeneratedStoriesLoading,  String? errorMessage,  String greetingKey,  String? userName,  List<SacredLocation> sacredLocations,  bool isSacredLocationsLoading,  List<HinduFestival> festivals,  bool isFestivalsLoading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.isLoading,_that.isRefreshing,_that.quote,_that.isQuoteLoading,_that.featuredStories,_that.isFeaturedLoading,_that.continueReading,_that.isContinueReadingLoading,_that.savedStories,_that.isSavedStoriesLoading,_that.myGeneratedStories,_that.isMyGeneratedStoriesLoading,_that.errorMessage,_that.greetingKey,_that.userName,_that.sacredLocations,_that.isSacredLocationsLoading,_that.festivals,_that.isFestivalsLoading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isRefreshing,  Quote? quote,  bool isQuoteLoading,  List<Story> featuredStories,  bool isFeaturedLoading,  List<Story> continueReading,  bool isContinueReadingLoading,  List<Story> savedStories,  bool isSavedStoriesLoading,  List<Story> myGeneratedStories,  bool isMyGeneratedStoriesLoading,  String? errorMessage,  String greetingKey,  String? userName,  List<SacredLocation> sacredLocations,  bool isSacredLocationsLoading,  List<HinduFestival> festivals,  bool isFestivalsLoading)  $default,) {final _that = this;
switch (_that) {
case _HomeState():
return $default(_that.isLoading,_that.isRefreshing,_that.quote,_that.isQuoteLoading,_that.featuredStories,_that.isFeaturedLoading,_that.continueReading,_that.isContinueReadingLoading,_that.savedStories,_that.isSavedStoriesLoading,_that.myGeneratedStories,_that.isMyGeneratedStoriesLoading,_that.errorMessage,_that.greetingKey,_that.userName,_that.sacredLocations,_that.isSacredLocationsLoading,_that.festivals,_that.isFestivalsLoading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isRefreshing,  Quote? quote,  bool isQuoteLoading,  List<Story> featuredStories,  bool isFeaturedLoading,  List<Story> continueReading,  bool isContinueReadingLoading,  List<Story> savedStories,  bool isSavedStoriesLoading,  List<Story> myGeneratedStories,  bool isMyGeneratedStoriesLoading,  String? errorMessage,  String greetingKey,  String? userName,  List<SacredLocation> sacredLocations,  bool isSacredLocationsLoading,  List<HinduFestival> festivals,  bool isFestivalsLoading)?  $default,) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.isLoading,_that.isRefreshing,_that.quote,_that.isQuoteLoading,_that.featuredStories,_that.isFeaturedLoading,_that.continueReading,_that.isContinueReadingLoading,_that.savedStories,_that.isSavedStoriesLoading,_that.myGeneratedStories,_that.isMyGeneratedStoriesLoading,_that.errorMessage,_that.greetingKey,_that.userName,_that.sacredLocations,_that.isSacredLocationsLoading,_that.festivals,_that.isFestivalsLoading);case _:
  return null;

}
}

}

/// @nodoc


class _HomeState extends HomeState {
  const _HomeState({this.isLoading = false, this.isRefreshing = false, this.quote, this.isQuoteLoading = false, final  List<Story> featuredStories = const [], this.isFeaturedLoading = false, final  List<Story> continueReading = const [], this.isContinueReadingLoading = false, final  List<Story> savedStories = const [], this.isSavedStoriesLoading = false, final  List<Story> myGeneratedStories = const [], this.isMyGeneratedStoriesLoading = false, this.errorMessage, this.greetingKey = 'morning', this.userName, final  List<SacredLocation> sacredLocations = const [], this.isSacredLocationsLoading = false, final  List<HinduFestival> festivals = const [], this.isFestivalsLoading = false}): _featuredStories = featuredStories,_continueReading = continueReading,_savedStories = savedStories,_myGeneratedStories = myGeneratedStories,_sacredLocations = sacredLocations,_festivals = festivals,super._();
  

/// Whether the home screen is loading
@override@JsonKey() final  bool isLoading;
/// Whether a refresh is in progress
@override@JsonKey() final  bool isRefreshing;
/// Quote of the day
@override final  Quote? quote;
/// Whether quote is loading
@override@JsonKey() final  bool isQuoteLoading;
/// Featured stories
 final  List<Story> _featuredStories;
/// Featured stories
@override@JsonKey() List<Story> get featuredStories {
  if (_featuredStories is EqualUnmodifiableListView) return _featuredStories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_featuredStories);
}

/// Whether featured stories are loading
@override@JsonKey() final  bool isFeaturedLoading;
/// Stories in progress (continue reading)
 final  List<Story> _continueReading;
/// Stories in progress (continue reading)
@override@JsonKey() List<Story> get continueReading {
  if (_continueReading is EqualUnmodifiableListView) return _continueReading;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_continueReading);
}

/// Whether continue reading is loading
@override@JsonKey() final  bool isContinueReadingLoading;
/// Saved/bookmarked stories
 final  List<Story> _savedStories;
/// Saved/bookmarked stories
@override@JsonKey() List<Story> get savedStories {
  if (_savedStories is EqualUnmodifiableListView) return _savedStories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_savedStories);
}

/// Whether saved stories are loading
@override@JsonKey() final  bool isSavedStoriesLoading;
/// User's generated stories
 final  List<Story> _myGeneratedStories;
/// User's generated stories
@override@JsonKey() List<Story> get myGeneratedStories {
  if (_myGeneratedStories is EqualUnmodifiableListView) return _myGeneratedStories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_myGeneratedStories);
}

/// Whether generated stories are loading
@override@JsonKey() final  bool isMyGeneratedStoriesLoading;
/// Error message if any
@override final  String? errorMessage;
/// Time-based greeting key
@override@JsonKey() final  String greetingKey;
/// User's display name
@override final  String? userName;
/// Sacred locations for "Where to Visit" section
 final  List<SacredLocation> _sacredLocations;
/// Sacred locations for "Where to Visit" section
@override@JsonKey() List<SacredLocation> get sacredLocations {
  if (_sacredLocations is EqualUnmodifiableListView) return _sacredLocations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sacredLocations);
}

/// Whether sacred locations are loading
@override@JsonKey() final  bool isSacredLocationsLoading;
/// Sanatan festivals for the Festival Stories section
 final  List<HinduFestival> _festivals;
/// Sanatan festivals for the Festival Stories section
@override@JsonKey() List<HinduFestival> get festivals {
  if (_festivals is EqualUnmodifiableListView) return _festivals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_festivals);
}

/// Whether festivals are loading
@override@JsonKey() final  bool isFestivalsLoading;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeStateCopyWith<_HomeState> get copyWith => __$HomeStateCopyWithImpl<_HomeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&(identical(other.quote, quote) || other.quote == quote)&&(identical(other.isQuoteLoading, isQuoteLoading) || other.isQuoteLoading == isQuoteLoading)&&const DeepCollectionEquality().equals(other._featuredStories, _featuredStories)&&(identical(other.isFeaturedLoading, isFeaturedLoading) || other.isFeaturedLoading == isFeaturedLoading)&&const DeepCollectionEquality().equals(other._continueReading, _continueReading)&&(identical(other.isContinueReadingLoading, isContinueReadingLoading) || other.isContinueReadingLoading == isContinueReadingLoading)&&const DeepCollectionEquality().equals(other._savedStories, _savedStories)&&(identical(other.isSavedStoriesLoading, isSavedStoriesLoading) || other.isSavedStoriesLoading == isSavedStoriesLoading)&&const DeepCollectionEquality().equals(other._myGeneratedStories, _myGeneratedStories)&&(identical(other.isMyGeneratedStoriesLoading, isMyGeneratedStoriesLoading) || other.isMyGeneratedStoriesLoading == isMyGeneratedStoriesLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.greetingKey, greetingKey) || other.greetingKey == greetingKey)&&(identical(other.userName, userName) || other.userName == userName)&&const DeepCollectionEquality().equals(other._sacredLocations, _sacredLocations)&&(identical(other.isSacredLocationsLoading, isSacredLocationsLoading) || other.isSacredLocationsLoading == isSacredLocationsLoading)&&const DeepCollectionEquality().equals(other._festivals, _festivals)&&(identical(other.isFestivalsLoading, isFestivalsLoading) || other.isFestivalsLoading == isFestivalsLoading));
}


@override
int get hashCode => Object.hashAll([runtimeType,isLoading,isRefreshing,quote,isQuoteLoading,const DeepCollectionEquality().hash(_featuredStories),isFeaturedLoading,const DeepCollectionEquality().hash(_continueReading),isContinueReadingLoading,const DeepCollectionEquality().hash(_savedStories),isSavedStoriesLoading,const DeepCollectionEquality().hash(_myGeneratedStories),isMyGeneratedStoriesLoading,errorMessage,greetingKey,userName,const DeepCollectionEquality().hash(_sacredLocations),isSacredLocationsLoading,const DeepCollectionEquality().hash(_festivals),isFestivalsLoading]);

@override
String toString() {
  return 'HomeState(isLoading: $isLoading, isRefreshing: $isRefreshing, quote: $quote, isQuoteLoading: $isQuoteLoading, featuredStories: $featuredStories, isFeaturedLoading: $isFeaturedLoading, continueReading: $continueReading, isContinueReadingLoading: $isContinueReadingLoading, savedStories: $savedStories, isSavedStoriesLoading: $isSavedStoriesLoading, myGeneratedStories: $myGeneratedStories, isMyGeneratedStoriesLoading: $isMyGeneratedStoriesLoading, errorMessage: $errorMessage, greetingKey: $greetingKey, userName: $userName, sacredLocations: $sacredLocations, isSacredLocationsLoading: $isSacredLocationsLoading, festivals: $festivals, isFestivalsLoading: $isFestivalsLoading)';
}


}

/// @nodoc
abstract mixin class _$HomeStateCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory _$HomeStateCopyWith(_HomeState value, $Res Function(_HomeState) _then) = __$HomeStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isRefreshing, Quote? quote, bool isQuoteLoading, List<Story> featuredStories, bool isFeaturedLoading, List<Story> continueReading, bool isContinueReadingLoading, List<Story> savedStories, bool isSavedStoriesLoading, List<Story> myGeneratedStories, bool isMyGeneratedStoriesLoading, String? errorMessage, String greetingKey, String? userName, List<SacredLocation> sacredLocations, bool isSacredLocationsLoading, List<HinduFestival> festivals, bool isFestivalsLoading
});


@override $QuoteCopyWith<$Res>? get quote;

}
/// @nodoc
class __$HomeStateCopyWithImpl<$Res>
    implements _$HomeStateCopyWith<$Res> {
  __$HomeStateCopyWithImpl(this._self, this._then);

  final _HomeState _self;
  final $Res Function(_HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isRefreshing = null,Object? quote = freezed,Object? isQuoteLoading = null,Object? featuredStories = null,Object? isFeaturedLoading = null,Object? continueReading = null,Object? isContinueReadingLoading = null,Object? savedStories = null,Object? isSavedStoriesLoading = null,Object? myGeneratedStories = null,Object? isMyGeneratedStoriesLoading = null,Object? errorMessage = freezed,Object? greetingKey = null,Object? userName = freezed,Object? sacredLocations = null,Object? isSacredLocationsLoading = null,Object? festivals = null,Object? isFestivalsLoading = null,}) {
  return _then(_HomeState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,quote: freezed == quote ? _self.quote : quote // ignore: cast_nullable_to_non_nullable
as Quote?,isQuoteLoading: null == isQuoteLoading ? _self.isQuoteLoading : isQuoteLoading // ignore: cast_nullable_to_non_nullable
as bool,featuredStories: null == featuredStories ? _self._featuredStories : featuredStories // ignore: cast_nullable_to_non_nullable
as List<Story>,isFeaturedLoading: null == isFeaturedLoading ? _self.isFeaturedLoading : isFeaturedLoading // ignore: cast_nullable_to_non_nullable
as bool,continueReading: null == continueReading ? _self._continueReading : continueReading // ignore: cast_nullable_to_non_nullable
as List<Story>,isContinueReadingLoading: null == isContinueReadingLoading ? _self.isContinueReadingLoading : isContinueReadingLoading // ignore: cast_nullable_to_non_nullable
as bool,savedStories: null == savedStories ? _self._savedStories : savedStories // ignore: cast_nullable_to_non_nullable
as List<Story>,isSavedStoriesLoading: null == isSavedStoriesLoading ? _self.isSavedStoriesLoading : isSavedStoriesLoading // ignore: cast_nullable_to_non_nullable
as bool,myGeneratedStories: null == myGeneratedStories ? _self._myGeneratedStories : myGeneratedStories // ignore: cast_nullable_to_non_nullable
as List<Story>,isMyGeneratedStoriesLoading: null == isMyGeneratedStoriesLoading ? _self.isMyGeneratedStoriesLoading : isMyGeneratedStoriesLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,greetingKey: null == greetingKey ? _self.greetingKey : greetingKey // ignore: cast_nullable_to_non_nullable
as String,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,sacredLocations: null == sacredLocations ? _self._sacredLocations : sacredLocations // ignore: cast_nullable_to_non_nullable
as List<SacredLocation>,isSacredLocationsLoading: null == isSacredLocationsLoading ? _self.isSacredLocationsLoading : isSacredLocationsLoading // ignore: cast_nullable_to_non_nullable
as bool,festivals: null == festivals ? _self._festivals : festivals // ignore: cast_nullable_to_non_nullable
as List<HinduFestival>,isFestivalsLoading: null == isFestivalsLoading ? _self.isFestivalsLoading : isFestivalsLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuoteCopyWith<$Res>? get quote {
    if (_self.quote == null) {
    return null;
  }

  return $QuoteCopyWith<$Res>(_self.quote!, (value) {
    return _then(_self.copyWith(quote: value));
  });
}
}

// dart format on
