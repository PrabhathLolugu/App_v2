// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stories_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StoriesEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoriesEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StoriesEvent()';
}


}

/// @nodoc
class $StoriesEventCopyWith<$Res>  {
$StoriesEventCopyWith(StoriesEvent _, $Res Function(StoriesEvent) __);
}


/// Adds pattern-matching-related methods to [StoriesEvent].
extension StoriesEventPatterns on StoriesEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _LoadStories value)?  loadStories,TResult Function( _SearchStories value)?  searchStories,TResult Function( _SortStories value)?  sortStories,TResult Function( _FilterByType value)?  filterByType,TResult Function( _FilterByTheme value)?  filterByTheme,TResult Function( _ToggleFavorite value)?  toggleFavorite,TResult Function( _LoadTrendingStories value)?  loadTrendingStories,TResult Function( _RefreshStories value)?  refreshStories,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoadStories() when loadStories != null:
return loadStories(_that);case _SearchStories() when searchStories != null:
return searchStories(_that);case _SortStories() when sortStories != null:
return sortStories(_that);case _FilterByType() when filterByType != null:
return filterByType(_that);case _FilterByTheme() when filterByTheme != null:
return filterByTheme(_that);case _ToggleFavorite() when toggleFavorite != null:
return toggleFavorite(_that);case _LoadTrendingStories() when loadTrendingStories != null:
return loadTrendingStories(_that);case _RefreshStories() when refreshStories != null:
return refreshStories(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _LoadStories value)  loadStories,required TResult Function( _SearchStories value)  searchStories,required TResult Function( _SortStories value)  sortStories,required TResult Function( _FilterByType value)  filterByType,required TResult Function( _FilterByTheme value)  filterByTheme,required TResult Function( _ToggleFavorite value)  toggleFavorite,required TResult Function( _LoadTrendingStories value)  loadTrendingStories,required TResult Function( _RefreshStories value)  refreshStories,}){
final _that = this;
switch (_that) {
case _LoadStories():
return loadStories(_that);case _SearchStories():
return searchStories(_that);case _SortStories():
return sortStories(_that);case _FilterByType():
return filterByType(_that);case _FilterByTheme():
return filterByTheme(_that);case _ToggleFavorite():
return toggleFavorite(_that);case _LoadTrendingStories():
return loadTrendingStories(_that);case _RefreshStories():
return refreshStories(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _LoadStories value)?  loadStories,TResult? Function( _SearchStories value)?  searchStories,TResult? Function( _SortStories value)?  sortStories,TResult? Function( _FilterByType value)?  filterByType,TResult? Function( _FilterByTheme value)?  filterByTheme,TResult? Function( _ToggleFavorite value)?  toggleFavorite,TResult? Function( _LoadTrendingStories value)?  loadTrendingStories,TResult? Function( _RefreshStories value)?  refreshStories,}){
final _that = this;
switch (_that) {
case _LoadStories() when loadStories != null:
return loadStories(_that);case _SearchStories() when searchStories != null:
return searchStories(_that);case _SortStories() when sortStories != null:
return sortStories(_that);case _FilterByType() when filterByType != null:
return filterByType(_that);case _FilterByTheme() when filterByTheme != null:
return filterByTheme(_that);case _ToggleFavorite() when toggleFavorite != null:
return toggleFavorite(_that);case _LoadTrendingStories() when loadTrendingStories != null:
return loadTrendingStories(_that);case _RefreshStories() when refreshStories != null:
return refreshStories(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadStories,TResult Function( String query)?  searchStories,TResult Function( String sortBy)?  sortStories,TResult Function( String type)?  filterByType,TResult Function( String theme)?  filterByTheme,TResult Function( String storyId)?  toggleFavorite,TResult Function()?  loadTrendingStories,TResult Function()?  refreshStories,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoadStories() when loadStories != null:
return loadStories();case _SearchStories() when searchStories != null:
return searchStories(_that.query);case _SortStories() when sortStories != null:
return sortStories(_that.sortBy);case _FilterByType() when filterByType != null:
return filterByType(_that.type);case _FilterByTheme() when filterByTheme != null:
return filterByTheme(_that.theme);case _ToggleFavorite() when toggleFavorite != null:
return toggleFavorite(_that.storyId);case _LoadTrendingStories() when loadTrendingStories != null:
return loadTrendingStories();case _RefreshStories() when refreshStories != null:
return refreshStories();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadStories,required TResult Function( String query)  searchStories,required TResult Function( String sortBy)  sortStories,required TResult Function( String type)  filterByType,required TResult Function( String theme)  filterByTheme,required TResult Function( String storyId)  toggleFavorite,required TResult Function()  loadTrendingStories,required TResult Function()  refreshStories,}) {final _that = this;
switch (_that) {
case _LoadStories():
return loadStories();case _SearchStories():
return searchStories(_that.query);case _SortStories():
return sortStories(_that.sortBy);case _FilterByType():
return filterByType(_that.type);case _FilterByTheme():
return filterByTheme(_that.theme);case _ToggleFavorite():
return toggleFavorite(_that.storyId);case _LoadTrendingStories():
return loadTrendingStories();case _RefreshStories():
return refreshStories();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadStories,TResult? Function( String query)?  searchStories,TResult? Function( String sortBy)?  sortStories,TResult? Function( String type)?  filterByType,TResult? Function( String theme)?  filterByTheme,TResult? Function( String storyId)?  toggleFavorite,TResult? Function()?  loadTrendingStories,TResult? Function()?  refreshStories,}) {final _that = this;
switch (_that) {
case _LoadStories() when loadStories != null:
return loadStories();case _SearchStories() when searchStories != null:
return searchStories(_that.query);case _SortStories() when sortStories != null:
return sortStories(_that.sortBy);case _FilterByType() when filterByType != null:
return filterByType(_that.type);case _FilterByTheme() when filterByTheme != null:
return filterByTheme(_that.theme);case _ToggleFavorite() when toggleFavorite != null:
return toggleFavorite(_that.storyId);case _LoadTrendingStories() when loadTrendingStories != null:
return loadTrendingStories();case _RefreshStories() when refreshStories != null:
return refreshStories();case _:
  return null;

}
}

}

/// @nodoc


class _LoadStories implements StoriesEvent {
  const _LoadStories();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadStories);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StoriesEvent.loadStories()';
}


}




/// @nodoc


class _SearchStories implements StoriesEvent {
  const _SearchStories(this.query);
  

 final  String query;

/// Create a copy of StoriesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchStoriesCopyWith<_SearchStories> get copyWith => __$SearchStoriesCopyWithImpl<_SearchStories>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchStories&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,query);

@override
String toString() {
  return 'StoriesEvent.searchStories(query: $query)';
}


}

/// @nodoc
abstract mixin class _$SearchStoriesCopyWith<$Res> implements $StoriesEventCopyWith<$Res> {
  factory _$SearchStoriesCopyWith(_SearchStories value, $Res Function(_SearchStories) _then) = __$SearchStoriesCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class __$SearchStoriesCopyWithImpl<$Res>
    implements _$SearchStoriesCopyWith<$Res> {
  __$SearchStoriesCopyWithImpl(this._self, this._then);

  final _SearchStories _self;
  final $Res Function(_SearchStories) _then;

/// Create a copy of StoriesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(_SearchStories(
null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SortStories implements StoriesEvent {
  const _SortStories(this.sortBy);
  

 final  String sortBy;

/// Create a copy of StoriesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SortStoriesCopyWith<_SortStories> get copyWith => __$SortStoriesCopyWithImpl<_SortStories>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SortStories&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy));
}


@override
int get hashCode => Object.hash(runtimeType,sortBy);

@override
String toString() {
  return 'StoriesEvent.sortStories(sortBy: $sortBy)';
}


}

/// @nodoc
abstract mixin class _$SortStoriesCopyWith<$Res> implements $StoriesEventCopyWith<$Res> {
  factory _$SortStoriesCopyWith(_SortStories value, $Res Function(_SortStories) _then) = __$SortStoriesCopyWithImpl;
@useResult
$Res call({
 String sortBy
});




}
/// @nodoc
class __$SortStoriesCopyWithImpl<$Res>
    implements _$SortStoriesCopyWith<$Res> {
  __$SortStoriesCopyWithImpl(this._self, this._then);

  final _SortStories _self;
  final $Res Function(_SortStories) _then;

/// Create a copy of StoriesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? sortBy = null,}) {
  return _then(_SortStories(
null == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _FilterByType implements StoriesEvent {
  const _FilterByType(this.type);
  

 final  String type;

/// Create a copy of StoriesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FilterByTypeCopyWith<_FilterByType> get copyWith => __$FilterByTypeCopyWithImpl<_FilterByType>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FilterByType&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,type);

@override
String toString() {
  return 'StoriesEvent.filterByType(type: $type)';
}


}

/// @nodoc
abstract mixin class _$FilterByTypeCopyWith<$Res> implements $StoriesEventCopyWith<$Res> {
  factory _$FilterByTypeCopyWith(_FilterByType value, $Res Function(_FilterByType) _then) = __$FilterByTypeCopyWithImpl;
@useResult
$Res call({
 String type
});




}
/// @nodoc
class __$FilterByTypeCopyWithImpl<$Res>
    implements _$FilterByTypeCopyWith<$Res> {
  __$FilterByTypeCopyWithImpl(this._self, this._then);

  final _FilterByType _self;
  final $Res Function(_FilterByType) _then;

/// Create a copy of StoriesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? type = null,}) {
  return _then(_FilterByType(
null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _FilterByTheme implements StoriesEvent {
  const _FilterByTheme(this.theme);
  

 final  String theme;

/// Create a copy of StoriesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FilterByThemeCopyWith<_FilterByTheme> get copyWith => __$FilterByThemeCopyWithImpl<_FilterByTheme>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FilterByTheme&&(identical(other.theme, theme) || other.theme == theme));
}


@override
int get hashCode => Object.hash(runtimeType,theme);

@override
String toString() {
  return 'StoriesEvent.filterByTheme(theme: $theme)';
}


}

/// @nodoc
abstract mixin class _$FilterByThemeCopyWith<$Res> implements $StoriesEventCopyWith<$Res> {
  factory _$FilterByThemeCopyWith(_FilterByTheme value, $Res Function(_FilterByTheme) _then) = __$FilterByThemeCopyWithImpl;
@useResult
$Res call({
 String theme
});




}
/// @nodoc
class __$FilterByThemeCopyWithImpl<$Res>
    implements _$FilterByThemeCopyWith<$Res> {
  __$FilterByThemeCopyWithImpl(this._self, this._then);

  final _FilterByTheme _self;
  final $Res Function(_FilterByTheme) _then;

/// Create a copy of StoriesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? theme = null,}) {
  return _then(_FilterByTheme(
null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ToggleFavorite implements StoriesEvent {
  const _ToggleFavorite(this.storyId);
  

 final  String storyId;

/// Create a copy of StoriesEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ToggleFavoriteCopyWith<_ToggleFavorite> get copyWith => __$ToggleFavoriteCopyWithImpl<_ToggleFavorite>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToggleFavorite&&(identical(other.storyId, storyId) || other.storyId == storyId));
}


@override
int get hashCode => Object.hash(runtimeType,storyId);

@override
String toString() {
  return 'StoriesEvent.toggleFavorite(storyId: $storyId)';
}


}

/// @nodoc
abstract mixin class _$ToggleFavoriteCopyWith<$Res> implements $StoriesEventCopyWith<$Res> {
  factory _$ToggleFavoriteCopyWith(_ToggleFavorite value, $Res Function(_ToggleFavorite) _then) = __$ToggleFavoriteCopyWithImpl;
@useResult
$Res call({
 String storyId
});




}
/// @nodoc
class __$ToggleFavoriteCopyWithImpl<$Res>
    implements _$ToggleFavoriteCopyWith<$Res> {
  __$ToggleFavoriteCopyWithImpl(this._self, this._then);

  final _ToggleFavorite _self;
  final $Res Function(_ToggleFavorite) _then;

/// Create a copy of StoriesEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? storyId = null,}) {
  return _then(_ToggleFavorite(
null == storyId ? _self.storyId : storyId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _LoadTrendingStories implements StoriesEvent {
  const _LoadTrendingStories();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadTrendingStories);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StoriesEvent.loadTrendingStories()';
}


}




/// @nodoc


class _RefreshStories implements StoriesEvent {
  const _RefreshStories();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RefreshStories);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StoriesEvent.refreshStories()';
}


}




// dart format on
