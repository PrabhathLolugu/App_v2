// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Story {

 String get id; String get title; String get scripture; String get story; String get quotes; String get trivia; String get activity; String get lesson; StoryAttributes get attributes; String? get imageUrl; String? get author; DateTime? get publishedAt; DateTime? get createdAt; DateTime? get updatedAt; int get likes; int get views; bool get isFavorite; bool get isFeatured; String? get authorId; User? get authorUser; int get commentCount; int get shareCount; bool get isLikedByCurrentUser;
/// Create a copy of Story
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryCopyWith<Story> get copyWith => _$StoryCopyWithImpl<Story>(this as Story, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Story&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.scripture, scripture) || other.scripture == scripture)&&(identical(other.story, story) || other.story == story)&&(identical(other.quotes, quotes) || other.quotes == quotes)&&(identical(other.trivia, trivia) || other.trivia == trivia)&&(identical(other.activity, activity) || other.activity == activity)&&(identical(other.lesson, lesson) || other.lesson == lesson)&&(identical(other.attributes, attributes) || other.attributes == attributes)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.author, author) || other.author == author)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.views, views) || other.views == views)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.authorUser, authorUser) || other.authorUser == authorUser)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.shareCount, shareCount) || other.shareCount == shareCount)&&(identical(other.isLikedByCurrentUser, isLikedByCurrentUser) || other.isLikedByCurrentUser == isLikedByCurrentUser));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,title,scripture,story,quotes,trivia,activity,lesson,attributes,imageUrl,author,publishedAt,createdAt,updatedAt,likes,views,isFavorite,isFeatured,authorId,authorUser,commentCount,shareCount,isLikedByCurrentUser]);

@override
String toString() {
  return 'Story(id: $id, title: $title, scripture: $scripture, story: $story, quotes: $quotes, trivia: $trivia, activity: $activity, lesson: $lesson, attributes: $attributes, imageUrl: $imageUrl, author: $author, publishedAt: $publishedAt, createdAt: $createdAt, updatedAt: $updatedAt, likes: $likes, views: $views, isFavorite: $isFavorite, isFeatured: $isFeatured, authorId: $authorId, authorUser: $authorUser, commentCount: $commentCount, shareCount: $shareCount, isLikedByCurrentUser: $isLikedByCurrentUser)';
}


}

/// @nodoc
abstract mixin class $StoryCopyWith<$Res>  {
  factory $StoryCopyWith(Story value, $Res Function(Story) _then) = _$StoryCopyWithImpl;
@useResult
$Res call({
 String id, String title, String scripture, String story, String quotes, String trivia, String activity, String lesson, StoryAttributes attributes, String? imageUrl, String? author, DateTime? publishedAt, DateTime? createdAt, DateTime? updatedAt, int likes, int views, bool isFavorite, bool isFeatured, String? authorId, User? authorUser, int commentCount, int shareCount, bool isLikedByCurrentUser
});


$StoryAttributesCopyWith<$Res> get attributes;$UserCopyWith<$Res>? get authorUser;

}
/// @nodoc
class _$StoryCopyWithImpl<$Res>
    implements $StoryCopyWith<$Res> {
  _$StoryCopyWithImpl(this._self, this._then);

  final Story _self;
  final $Res Function(Story) _then;

/// Create a copy of Story
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? scripture = null,Object? story = null,Object? quotes = null,Object? trivia = null,Object? activity = null,Object? lesson = null,Object? attributes = null,Object? imageUrl = freezed,Object? author = freezed,Object? publishedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? likes = null,Object? views = null,Object? isFavorite = null,Object? isFeatured = null,Object? authorId = freezed,Object? authorUser = freezed,Object? commentCount = null,Object? shareCount = null,Object? isLikedByCurrentUser = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,scripture: null == scripture ? _self.scripture : scripture // ignore: cast_nullable_to_non_nullable
as String,story: null == story ? _self.story : story // ignore: cast_nullable_to_non_nullable
as String,quotes: null == quotes ? _self.quotes : quotes // ignore: cast_nullable_to_non_nullable
as String,trivia: null == trivia ? _self.trivia : trivia // ignore: cast_nullable_to_non_nullable
as String,activity: null == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as String,lesson: null == lesson ? _self.lesson : lesson // ignore: cast_nullable_to_non_nullable
as String,attributes: null == attributes ? _self.attributes : attributes // ignore: cast_nullable_to_non_nullable
as StoryAttributes,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,authorId: freezed == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String?,authorUser: freezed == authorUser ? _self.authorUser : authorUser // ignore: cast_nullable_to_non_nullable
as User?,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,shareCount: null == shareCount ? _self.shareCount : shareCount // ignore: cast_nullable_to_non_nullable
as int,isLikedByCurrentUser: null == isLikedByCurrentUser ? _self.isLikedByCurrentUser : isLikedByCurrentUser // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of Story
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoryAttributesCopyWith<$Res> get attributes {
  
  return $StoryAttributesCopyWith<$Res>(_self.attributes, (value) {
    return _then(_self.copyWith(attributes: value));
  });
}/// Create a copy of Story
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get authorUser {
    if (_self.authorUser == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.authorUser!, (value) {
    return _then(_self.copyWith(authorUser: value));
  });
}
}


/// Adds pattern-matching-related methods to [Story].
extension StoryPatterns on Story {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Story value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Story() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Story value)  $default,){
final _that = this;
switch (_that) {
case _Story():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Story value)?  $default,){
final _that = this;
switch (_that) {
case _Story() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String scripture,  String story,  String quotes,  String trivia,  String activity,  String lesson,  StoryAttributes attributes,  String? imageUrl,  String? author,  DateTime? publishedAt,  DateTime? createdAt,  DateTime? updatedAt,  int likes,  int views,  bool isFavorite,  bool isFeatured,  String? authorId,  User? authorUser,  int commentCount,  int shareCount,  bool isLikedByCurrentUser)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Story() when $default != null:
return $default(_that.id,_that.title,_that.scripture,_that.story,_that.quotes,_that.trivia,_that.activity,_that.lesson,_that.attributes,_that.imageUrl,_that.author,_that.publishedAt,_that.createdAt,_that.updatedAt,_that.likes,_that.views,_that.isFavorite,_that.isFeatured,_that.authorId,_that.authorUser,_that.commentCount,_that.shareCount,_that.isLikedByCurrentUser);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String scripture,  String story,  String quotes,  String trivia,  String activity,  String lesson,  StoryAttributes attributes,  String? imageUrl,  String? author,  DateTime? publishedAt,  DateTime? createdAt,  DateTime? updatedAt,  int likes,  int views,  bool isFavorite,  bool isFeatured,  String? authorId,  User? authorUser,  int commentCount,  int shareCount,  bool isLikedByCurrentUser)  $default,) {final _that = this;
switch (_that) {
case _Story():
return $default(_that.id,_that.title,_that.scripture,_that.story,_that.quotes,_that.trivia,_that.activity,_that.lesson,_that.attributes,_that.imageUrl,_that.author,_that.publishedAt,_that.createdAt,_that.updatedAt,_that.likes,_that.views,_that.isFavorite,_that.isFeatured,_that.authorId,_that.authorUser,_that.commentCount,_that.shareCount,_that.isLikedByCurrentUser);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String scripture,  String story,  String quotes,  String trivia,  String activity,  String lesson,  StoryAttributes attributes,  String? imageUrl,  String? author,  DateTime? publishedAt,  DateTime? createdAt,  DateTime? updatedAt,  int likes,  int views,  bool isFavorite,  bool isFeatured,  String? authorId,  User? authorUser,  int commentCount,  int shareCount,  bool isLikedByCurrentUser)?  $default,) {final _that = this;
switch (_that) {
case _Story() when $default != null:
return $default(_that.id,_that.title,_that.scripture,_that.story,_that.quotes,_that.trivia,_that.activity,_that.lesson,_that.attributes,_that.imageUrl,_that.author,_that.publishedAt,_that.createdAt,_that.updatedAt,_that.likes,_that.views,_that.isFavorite,_that.isFeatured,_that.authorId,_that.authorUser,_that.commentCount,_that.shareCount,_that.isLikedByCurrentUser);case _:
  return null;

}
}

}

/// @nodoc


class _Story extends Story {
  const _Story({required this.id, required this.title, required this.scripture, required this.story, required this.quotes, required this.trivia, required this.activity, required this.lesson, required this.attributes, this.imageUrl, this.author, this.publishedAt, this.createdAt, this.updatedAt, this.likes = 0, this.views = 0, this.isFavorite = false, this.isFeatured = false, this.authorId, this.authorUser, this.commentCount = 0, this.shareCount = 0, this.isLikedByCurrentUser = false}): super._();
  

@override final  String id;
@override final  String title;
@override final  String scripture;
@override final  String story;
@override final  String quotes;
@override final  String trivia;
@override final  String activity;
@override final  String lesson;
@override final  StoryAttributes attributes;
@override final  String? imageUrl;
@override final  String? author;
@override final  DateTime? publishedAt;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override@JsonKey() final  int likes;
@override@JsonKey() final  int views;
@override@JsonKey() final  bool isFavorite;
@override@JsonKey() final  bool isFeatured;
@override final  String? authorId;
@override final  User? authorUser;
@override@JsonKey() final  int commentCount;
@override@JsonKey() final  int shareCount;
@override@JsonKey() final  bool isLikedByCurrentUser;

/// Create a copy of Story
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryCopyWith<_Story> get copyWith => __$StoryCopyWithImpl<_Story>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Story&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.scripture, scripture) || other.scripture == scripture)&&(identical(other.story, story) || other.story == story)&&(identical(other.quotes, quotes) || other.quotes == quotes)&&(identical(other.trivia, trivia) || other.trivia == trivia)&&(identical(other.activity, activity) || other.activity == activity)&&(identical(other.lesson, lesson) || other.lesson == lesson)&&(identical(other.attributes, attributes) || other.attributes == attributes)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.author, author) || other.author == author)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.views, views) || other.views == views)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.authorUser, authorUser) || other.authorUser == authorUser)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.shareCount, shareCount) || other.shareCount == shareCount)&&(identical(other.isLikedByCurrentUser, isLikedByCurrentUser) || other.isLikedByCurrentUser == isLikedByCurrentUser));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,title,scripture,story,quotes,trivia,activity,lesson,attributes,imageUrl,author,publishedAt,createdAt,updatedAt,likes,views,isFavorite,isFeatured,authorId,authorUser,commentCount,shareCount,isLikedByCurrentUser]);

@override
String toString() {
  return 'Story(id: $id, title: $title, scripture: $scripture, story: $story, quotes: $quotes, trivia: $trivia, activity: $activity, lesson: $lesson, attributes: $attributes, imageUrl: $imageUrl, author: $author, publishedAt: $publishedAt, createdAt: $createdAt, updatedAt: $updatedAt, likes: $likes, views: $views, isFavorite: $isFavorite, isFeatured: $isFeatured, authorId: $authorId, authorUser: $authorUser, commentCount: $commentCount, shareCount: $shareCount, isLikedByCurrentUser: $isLikedByCurrentUser)';
}


}

/// @nodoc
abstract mixin class _$StoryCopyWith<$Res> implements $StoryCopyWith<$Res> {
  factory _$StoryCopyWith(_Story value, $Res Function(_Story) _then) = __$StoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String scripture, String story, String quotes, String trivia, String activity, String lesson, StoryAttributes attributes, String? imageUrl, String? author, DateTime? publishedAt, DateTime? createdAt, DateTime? updatedAt, int likes, int views, bool isFavorite, bool isFeatured, String? authorId, User? authorUser, int commentCount, int shareCount, bool isLikedByCurrentUser
});


@override $StoryAttributesCopyWith<$Res> get attributes;@override $UserCopyWith<$Res>? get authorUser;

}
/// @nodoc
class __$StoryCopyWithImpl<$Res>
    implements _$StoryCopyWith<$Res> {
  __$StoryCopyWithImpl(this._self, this._then);

  final _Story _self;
  final $Res Function(_Story) _then;

/// Create a copy of Story
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? scripture = null,Object? story = null,Object? quotes = null,Object? trivia = null,Object? activity = null,Object? lesson = null,Object? attributes = null,Object? imageUrl = freezed,Object? author = freezed,Object? publishedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? likes = null,Object? views = null,Object? isFavorite = null,Object? isFeatured = null,Object? authorId = freezed,Object? authorUser = freezed,Object? commentCount = null,Object? shareCount = null,Object? isLikedByCurrentUser = null,}) {
  return _then(_Story(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,scripture: null == scripture ? _self.scripture : scripture // ignore: cast_nullable_to_non_nullable
as String,story: null == story ? _self.story : story // ignore: cast_nullable_to_non_nullable
as String,quotes: null == quotes ? _self.quotes : quotes // ignore: cast_nullable_to_non_nullable
as String,trivia: null == trivia ? _self.trivia : trivia // ignore: cast_nullable_to_non_nullable
as String,activity: null == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as String,lesson: null == lesson ? _self.lesson : lesson // ignore: cast_nullable_to_non_nullable
as String,attributes: null == attributes ? _self.attributes : attributes // ignore: cast_nullable_to_non_nullable
as StoryAttributes,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,authorId: freezed == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String?,authorUser: freezed == authorUser ? _self.authorUser : authorUser // ignore: cast_nullable_to_non_nullable
as User?,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,shareCount: null == shareCount ? _self.shareCount : shareCount // ignore: cast_nullable_to_non_nullable
as int,isLikedByCurrentUser: null == isLikedByCurrentUser ? _self.isLikedByCurrentUser : isLikedByCurrentUser // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of Story
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoryAttributesCopyWith<$Res> get attributes {
  
  return $StoryAttributesCopyWith<$Res>(_self.attributes, (value) {
    return _then(_self.copyWith(attributes: value));
  });
}/// Create a copy of Story
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get authorUser {
    if (_self.authorUser == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.authorUser!, (value) {
    return _then(_self.copyWith(authorUser: value));
  });
}
}

/// @nodoc
mixin _$StoryAttributes {

 String get storyType; String get theme; String get mainCharacterType; String get storySetting; String get timeEra; String get narrativePerspective; String get languageStyle; String get emotionalTone; String get narrativeStyle; String get plotStructure; String get storyLength; List<String> get references; List<String> get tags; List<String> get characters; Map<String, dynamic> get characterDetails; Map<String, TranslatedStory> get translations;
/// Create a copy of StoryAttributes
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryAttributesCopyWith<StoryAttributes> get copyWith => _$StoryAttributesCopyWithImpl<StoryAttributes>(this as StoryAttributes, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryAttributes&&(identical(other.storyType, storyType) || other.storyType == storyType)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.mainCharacterType, mainCharacterType) || other.mainCharacterType == mainCharacterType)&&(identical(other.storySetting, storySetting) || other.storySetting == storySetting)&&(identical(other.timeEra, timeEra) || other.timeEra == timeEra)&&(identical(other.narrativePerspective, narrativePerspective) || other.narrativePerspective == narrativePerspective)&&(identical(other.languageStyle, languageStyle) || other.languageStyle == languageStyle)&&(identical(other.emotionalTone, emotionalTone) || other.emotionalTone == emotionalTone)&&(identical(other.narrativeStyle, narrativeStyle) || other.narrativeStyle == narrativeStyle)&&(identical(other.plotStructure, plotStructure) || other.plotStructure == plotStructure)&&(identical(other.storyLength, storyLength) || other.storyLength == storyLength)&&const DeepCollectionEquality().equals(other.references, references)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.characters, characters)&&const DeepCollectionEquality().equals(other.characterDetails, characterDetails)&&const DeepCollectionEquality().equals(other.translations, translations));
}


@override
int get hashCode => Object.hash(runtimeType,storyType,theme,mainCharacterType,storySetting,timeEra,narrativePerspective,languageStyle,emotionalTone,narrativeStyle,plotStructure,storyLength,const DeepCollectionEquality().hash(references),const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(characters),const DeepCollectionEquality().hash(characterDetails),const DeepCollectionEquality().hash(translations));

@override
String toString() {
  return 'StoryAttributes(storyType: $storyType, theme: $theme, mainCharacterType: $mainCharacterType, storySetting: $storySetting, timeEra: $timeEra, narrativePerspective: $narrativePerspective, languageStyle: $languageStyle, emotionalTone: $emotionalTone, narrativeStyle: $narrativeStyle, plotStructure: $plotStructure, storyLength: $storyLength, references: $references, tags: $tags, characters: $characters, characterDetails: $characterDetails, translations: $translations)';
}


}

/// @nodoc
abstract mixin class $StoryAttributesCopyWith<$Res>  {
  factory $StoryAttributesCopyWith(StoryAttributes value, $Res Function(StoryAttributes) _then) = _$StoryAttributesCopyWithImpl;
@useResult
$Res call({
 String storyType, String theme, String mainCharacterType, String storySetting, String timeEra, String narrativePerspective, String languageStyle, String emotionalTone, String narrativeStyle, String plotStructure, String storyLength, List<String> references, List<String> tags, List<String> characters, Map<String, dynamic> characterDetails, Map<String, TranslatedStory> translations
});




}
/// @nodoc
class _$StoryAttributesCopyWithImpl<$Res>
    implements $StoryAttributesCopyWith<$Res> {
  _$StoryAttributesCopyWithImpl(this._self, this._then);

  final StoryAttributes _self;
  final $Res Function(StoryAttributes) _then;

/// Create a copy of StoryAttributes
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? storyType = null,Object? theme = null,Object? mainCharacterType = null,Object? storySetting = null,Object? timeEra = null,Object? narrativePerspective = null,Object? languageStyle = null,Object? emotionalTone = null,Object? narrativeStyle = null,Object? plotStructure = null,Object? storyLength = null,Object? references = null,Object? tags = null,Object? characters = null,Object? characterDetails = null,Object? translations = null,}) {
  return _then(_self.copyWith(
storyType: null == storyType ? _self.storyType : storyType // ignore: cast_nullable_to_non_nullable
as String,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String,mainCharacterType: null == mainCharacterType ? _self.mainCharacterType : mainCharacterType // ignore: cast_nullable_to_non_nullable
as String,storySetting: null == storySetting ? _self.storySetting : storySetting // ignore: cast_nullable_to_non_nullable
as String,timeEra: null == timeEra ? _self.timeEra : timeEra // ignore: cast_nullable_to_non_nullable
as String,narrativePerspective: null == narrativePerspective ? _self.narrativePerspective : narrativePerspective // ignore: cast_nullable_to_non_nullable
as String,languageStyle: null == languageStyle ? _self.languageStyle : languageStyle // ignore: cast_nullable_to_non_nullable
as String,emotionalTone: null == emotionalTone ? _self.emotionalTone : emotionalTone // ignore: cast_nullable_to_non_nullable
as String,narrativeStyle: null == narrativeStyle ? _self.narrativeStyle : narrativeStyle // ignore: cast_nullable_to_non_nullable
as String,plotStructure: null == plotStructure ? _self.plotStructure : plotStructure // ignore: cast_nullable_to_non_nullable
as String,storyLength: null == storyLength ? _self.storyLength : storyLength // ignore: cast_nullable_to_non_nullable
as String,references: null == references ? _self.references : references // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,characters: null == characters ? _self.characters : characters // ignore: cast_nullable_to_non_nullable
as List<String>,characterDetails: null == characterDetails ? _self.characterDetails : characterDetails // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,translations: null == translations ? _self.translations : translations // ignore: cast_nullable_to_non_nullable
as Map<String, TranslatedStory>,
  ));
}

}


/// Adds pattern-matching-related methods to [StoryAttributes].
extension StoryAttributesPatterns on StoryAttributes {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoryAttributes value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoryAttributes() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoryAttributes value)  $default,){
final _that = this;
switch (_that) {
case _StoryAttributes():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoryAttributes value)?  $default,){
final _that = this;
switch (_that) {
case _StoryAttributes() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String storyType,  String theme,  String mainCharacterType,  String storySetting,  String timeEra,  String narrativePerspective,  String languageStyle,  String emotionalTone,  String narrativeStyle,  String plotStructure,  String storyLength,  List<String> references,  List<String> tags,  List<String> characters,  Map<String, dynamic> characterDetails,  Map<String, TranslatedStory> translations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoryAttributes() when $default != null:
return $default(_that.storyType,_that.theme,_that.mainCharacterType,_that.storySetting,_that.timeEra,_that.narrativePerspective,_that.languageStyle,_that.emotionalTone,_that.narrativeStyle,_that.plotStructure,_that.storyLength,_that.references,_that.tags,_that.characters,_that.characterDetails,_that.translations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String storyType,  String theme,  String mainCharacterType,  String storySetting,  String timeEra,  String narrativePerspective,  String languageStyle,  String emotionalTone,  String narrativeStyle,  String plotStructure,  String storyLength,  List<String> references,  List<String> tags,  List<String> characters,  Map<String, dynamic> characterDetails,  Map<String, TranslatedStory> translations)  $default,) {final _that = this;
switch (_that) {
case _StoryAttributes():
return $default(_that.storyType,_that.theme,_that.mainCharacterType,_that.storySetting,_that.timeEra,_that.narrativePerspective,_that.languageStyle,_that.emotionalTone,_that.narrativeStyle,_that.plotStructure,_that.storyLength,_that.references,_that.tags,_that.characters,_that.characterDetails,_that.translations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String storyType,  String theme,  String mainCharacterType,  String storySetting,  String timeEra,  String narrativePerspective,  String languageStyle,  String emotionalTone,  String narrativeStyle,  String plotStructure,  String storyLength,  List<String> references,  List<String> tags,  List<String> characters,  Map<String, dynamic> characterDetails,  Map<String, TranslatedStory> translations)?  $default,) {final _that = this;
switch (_that) {
case _StoryAttributes() when $default != null:
return $default(_that.storyType,_that.theme,_that.mainCharacterType,_that.storySetting,_that.timeEra,_that.narrativePerspective,_that.languageStyle,_that.emotionalTone,_that.narrativeStyle,_that.plotStructure,_that.storyLength,_that.references,_that.tags,_that.characters,_that.characterDetails,_that.translations);case _:
  return null;

}
}

}

/// @nodoc


class _StoryAttributes implements StoryAttributes {
  const _StoryAttributes({required this.storyType, required this.theme, required this.mainCharacterType, required this.storySetting, required this.timeEra, required this.narrativePerspective, required this.languageStyle, required this.emotionalTone, required this.narrativeStyle, required this.plotStructure, required this.storyLength, final  List<String> references = const [], final  List<String> tags = const [], final  List<String> characters = const [], final  Map<String, dynamic> characterDetails = const {}, final  Map<String, TranslatedStory> translations = const {}}): _references = references,_tags = tags,_characters = characters,_characterDetails = characterDetails,_translations = translations;
  

@override final  String storyType;
@override final  String theme;
@override final  String mainCharacterType;
@override final  String storySetting;
@override final  String timeEra;
@override final  String narrativePerspective;
@override final  String languageStyle;
@override final  String emotionalTone;
@override final  String narrativeStyle;
@override final  String plotStructure;
@override final  String storyLength;
 final  List<String> _references;
@override@JsonKey() List<String> get references {
  if (_references is EqualUnmodifiableListView) return _references;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_references);
}

 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

 final  List<String> _characters;
@override@JsonKey() List<String> get characters {
  if (_characters is EqualUnmodifiableListView) return _characters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_characters);
}

 final  Map<String, dynamic> _characterDetails;
@override@JsonKey() Map<String, dynamic> get characterDetails {
  if (_characterDetails is EqualUnmodifiableMapView) return _characterDetails;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_characterDetails);
}

 final  Map<String, TranslatedStory> _translations;
@override@JsonKey() Map<String, TranslatedStory> get translations {
  if (_translations is EqualUnmodifiableMapView) return _translations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_translations);
}


/// Create a copy of StoryAttributes
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryAttributesCopyWith<_StoryAttributes> get copyWith => __$StoryAttributesCopyWithImpl<_StoryAttributes>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoryAttributes&&(identical(other.storyType, storyType) || other.storyType == storyType)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.mainCharacterType, mainCharacterType) || other.mainCharacterType == mainCharacterType)&&(identical(other.storySetting, storySetting) || other.storySetting == storySetting)&&(identical(other.timeEra, timeEra) || other.timeEra == timeEra)&&(identical(other.narrativePerspective, narrativePerspective) || other.narrativePerspective == narrativePerspective)&&(identical(other.languageStyle, languageStyle) || other.languageStyle == languageStyle)&&(identical(other.emotionalTone, emotionalTone) || other.emotionalTone == emotionalTone)&&(identical(other.narrativeStyle, narrativeStyle) || other.narrativeStyle == narrativeStyle)&&(identical(other.plotStructure, plotStructure) || other.plotStructure == plotStructure)&&(identical(other.storyLength, storyLength) || other.storyLength == storyLength)&&const DeepCollectionEquality().equals(other._references, _references)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._characters, _characters)&&const DeepCollectionEquality().equals(other._characterDetails, _characterDetails)&&const DeepCollectionEquality().equals(other._translations, _translations));
}


@override
int get hashCode => Object.hash(runtimeType,storyType,theme,mainCharacterType,storySetting,timeEra,narrativePerspective,languageStyle,emotionalTone,narrativeStyle,plotStructure,storyLength,const DeepCollectionEquality().hash(_references),const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_characters),const DeepCollectionEquality().hash(_characterDetails),const DeepCollectionEquality().hash(_translations));

@override
String toString() {
  return 'StoryAttributes(storyType: $storyType, theme: $theme, mainCharacterType: $mainCharacterType, storySetting: $storySetting, timeEra: $timeEra, narrativePerspective: $narrativePerspective, languageStyle: $languageStyle, emotionalTone: $emotionalTone, narrativeStyle: $narrativeStyle, plotStructure: $plotStructure, storyLength: $storyLength, references: $references, tags: $tags, characters: $characters, characterDetails: $characterDetails, translations: $translations)';
}


}

/// @nodoc
abstract mixin class _$StoryAttributesCopyWith<$Res> implements $StoryAttributesCopyWith<$Res> {
  factory _$StoryAttributesCopyWith(_StoryAttributes value, $Res Function(_StoryAttributes) _then) = __$StoryAttributesCopyWithImpl;
@override @useResult
$Res call({
 String storyType, String theme, String mainCharacterType, String storySetting, String timeEra, String narrativePerspective, String languageStyle, String emotionalTone, String narrativeStyle, String plotStructure, String storyLength, List<String> references, List<String> tags, List<String> characters, Map<String, dynamic> characterDetails, Map<String, TranslatedStory> translations
});




}
/// @nodoc
class __$StoryAttributesCopyWithImpl<$Res>
    implements _$StoryAttributesCopyWith<$Res> {
  __$StoryAttributesCopyWithImpl(this._self, this._then);

  final _StoryAttributes _self;
  final $Res Function(_StoryAttributes) _then;

/// Create a copy of StoryAttributes
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? storyType = null,Object? theme = null,Object? mainCharacterType = null,Object? storySetting = null,Object? timeEra = null,Object? narrativePerspective = null,Object? languageStyle = null,Object? emotionalTone = null,Object? narrativeStyle = null,Object? plotStructure = null,Object? storyLength = null,Object? references = null,Object? tags = null,Object? characters = null,Object? characterDetails = null,Object? translations = null,}) {
  return _then(_StoryAttributes(
storyType: null == storyType ? _self.storyType : storyType // ignore: cast_nullable_to_non_nullable
as String,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String,mainCharacterType: null == mainCharacterType ? _self.mainCharacterType : mainCharacterType // ignore: cast_nullable_to_non_nullable
as String,storySetting: null == storySetting ? _self.storySetting : storySetting // ignore: cast_nullable_to_non_nullable
as String,timeEra: null == timeEra ? _self.timeEra : timeEra // ignore: cast_nullable_to_non_nullable
as String,narrativePerspective: null == narrativePerspective ? _self.narrativePerspective : narrativePerspective // ignore: cast_nullable_to_non_nullable
as String,languageStyle: null == languageStyle ? _self.languageStyle : languageStyle // ignore: cast_nullable_to_non_nullable
as String,emotionalTone: null == emotionalTone ? _self.emotionalTone : emotionalTone // ignore: cast_nullable_to_non_nullable
as String,narrativeStyle: null == narrativeStyle ? _self.narrativeStyle : narrativeStyle // ignore: cast_nullable_to_non_nullable
as String,plotStructure: null == plotStructure ? _self.plotStructure : plotStructure // ignore: cast_nullable_to_non_nullable
as String,storyLength: null == storyLength ? _self.storyLength : storyLength // ignore: cast_nullable_to_non_nullable
as String,references: null == references ? _self._references : references // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,characters: null == characters ? _self._characters : characters // ignore: cast_nullable_to_non_nullable
as List<String>,characterDetails: null == characterDetails ? _self._characterDetails : characterDetails // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,translations: null == translations ? _self._translations : translations // ignore: cast_nullable_to_non_nullable
as Map<String, TranslatedStory>,
  ));
}


}

// dart format on
