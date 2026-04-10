// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'text_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TextPost {

 String get id; String get body; String? get title; String? get imageUrl; int get backgroundColor; int get textColor; double get fontSize; String? get fontFamily; DateTime? get createdAt; DateTime? get scheduledAt; DateTime? get publishedAt; String? get status; String? get authorId; User? get authorUser; int get likes; int get commentCount; int get shareCount; bool get isLikedByCurrentUser; bool get isFavorite; List<String> get tags; List<PostMention> get mentions; PostPoll? get poll; String? get repostedPostId; String? get repostedPostType; String? get repostedMediaUrl; String? get repostedThumbnailUrl; String? get repostedCaption; String? get repostedAuthorId; String? get repostedAuthorName; String? get repostedAuthorUsername; String? get repostedAuthorAvatarUrl;
/// Create a copy of TextPost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextPostCopyWith<TextPost> get copyWith => _$TextPostCopyWithImpl<TextPost>(this as TextPost, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextPost&&(identical(other.id, id) || other.id == id)&&(identical(other.body, body) || other.body == body)&&(identical(other.title, title) || other.title == title)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.backgroundColor, backgroundColor) || other.backgroundColor == backgroundColor)&&(identical(other.textColor, textColor) || other.textColor == textColor)&&(identical(other.fontSize, fontSize) || other.fontSize == fontSize)&&(identical(other.fontFamily, fontFamily) || other.fontFamily == fontFamily)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.authorUser, authorUser) || other.authorUser == authorUser)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.shareCount, shareCount) || other.shareCount == shareCount)&&(identical(other.isLikedByCurrentUser, isLikedByCurrentUser) || other.isLikedByCurrentUser == isLikedByCurrentUser)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.mentions, mentions)&&(identical(other.poll, poll) || other.poll == poll)&&(identical(other.repostedPostId, repostedPostId) || other.repostedPostId == repostedPostId)&&(identical(other.repostedPostType, repostedPostType) || other.repostedPostType == repostedPostType)&&(identical(other.repostedMediaUrl, repostedMediaUrl) || other.repostedMediaUrl == repostedMediaUrl)&&(identical(other.repostedThumbnailUrl, repostedThumbnailUrl) || other.repostedThumbnailUrl == repostedThumbnailUrl)&&(identical(other.repostedCaption, repostedCaption) || other.repostedCaption == repostedCaption)&&(identical(other.repostedAuthorId, repostedAuthorId) || other.repostedAuthorId == repostedAuthorId)&&(identical(other.repostedAuthorName, repostedAuthorName) || other.repostedAuthorName == repostedAuthorName)&&(identical(other.repostedAuthorUsername, repostedAuthorUsername) || other.repostedAuthorUsername == repostedAuthorUsername)&&(identical(other.repostedAuthorAvatarUrl, repostedAuthorAvatarUrl) || other.repostedAuthorAvatarUrl == repostedAuthorAvatarUrl));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,body,title,imageUrl,backgroundColor,textColor,fontSize,fontFamily,createdAt,scheduledAt,publishedAt,status,authorId,authorUser,likes,commentCount,shareCount,isLikedByCurrentUser,isFavorite,const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(mentions),poll,repostedPostId,repostedPostType,repostedMediaUrl,repostedThumbnailUrl,repostedCaption,repostedAuthorId,repostedAuthorName,repostedAuthorUsername,repostedAuthorAvatarUrl]);

@override
String toString() {
  return 'TextPost(id: $id, body: $body, title: $title, imageUrl: $imageUrl, backgroundColor: $backgroundColor, textColor: $textColor, fontSize: $fontSize, fontFamily: $fontFamily, createdAt: $createdAt, scheduledAt: $scheduledAt, publishedAt: $publishedAt, status: $status, authorId: $authorId, authorUser: $authorUser, likes: $likes, commentCount: $commentCount, shareCount: $shareCount, isLikedByCurrentUser: $isLikedByCurrentUser, isFavorite: $isFavorite, tags: $tags, mentions: $mentions, poll: $poll, repostedPostId: $repostedPostId, repostedPostType: $repostedPostType, repostedMediaUrl: $repostedMediaUrl, repostedThumbnailUrl: $repostedThumbnailUrl, repostedCaption: $repostedCaption, repostedAuthorId: $repostedAuthorId, repostedAuthorName: $repostedAuthorName, repostedAuthorUsername: $repostedAuthorUsername, repostedAuthorAvatarUrl: $repostedAuthorAvatarUrl)';
}


}

/// @nodoc
abstract mixin class $TextPostCopyWith<$Res>  {
  factory $TextPostCopyWith(TextPost value, $Res Function(TextPost) _then) = _$TextPostCopyWithImpl;
@useResult
$Res call({
 String id, String body, String? title, String? imageUrl, int backgroundColor, int textColor, double fontSize, String? fontFamily, DateTime? createdAt, DateTime? scheduledAt, DateTime? publishedAt, String? status, String? authorId, User? authorUser, int likes, int commentCount, int shareCount, bool isLikedByCurrentUser, bool isFavorite, List<String> tags, List<PostMention> mentions, PostPoll? poll, String? repostedPostId, String? repostedPostType, String? repostedMediaUrl, String? repostedThumbnailUrl, String? repostedCaption, String? repostedAuthorId, String? repostedAuthorName, String? repostedAuthorUsername, String? repostedAuthorAvatarUrl
});


$UserCopyWith<$Res>? get authorUser;$PostPollCopyWith<$Res>? get poll;

}
/// @nodoc
class _$TextPostCopyWithImpl<$Res>
    implements $TextPostCopyWith<$Res> {
  _$TextPostCopyWithImpl(this._self, this._then);

  final TextPost _self;
  final $Res Function(TextPost) _then;

/// Create a copy of TextPost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? body = null,Object? title = freezed,Object? imageUrl = freezed,Object? backgroundColor = null,Object? textColor = null,Object? fontSize = null,Object? fontFamily = freezed,Object? createdAt = freezed,Object? scheduledAt = freezed,Object? publishedAt = freezed,Object? status = freezed,Object? authorId = freezed,Object? authorUser = freezed,Object? likes = null,Object? commentCount = null,Object? shareCount = null,Object? isLikedByCurrentUser = null,Object? isFavorite = null,Object? tags = null,Object? mentions = null,Object? poll = freezed,Object? repostedPostId = freezed,Object? repostedPostType = freezed,Object? repostedMediaUrl = freezed,Object? repostedThumbnailUrl = freezed,Object? repostedCaption = freezed,Object? repostedAuthorId = freezed,Object? repostedAuthorName = freezed,Object? repostedAuthorUsername = freezed,Object? repostedAuthorAvatarUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,backgroundColor: null == backgroundColor ? _self.backgroundColor : backgroundColor // ignore: cast_nullable_to_non_nullable
as int,textColor: null == textColor ? _self.textColor : textColor // ignore: cast_nullable_to_non_nullable
as int,fontSize: null == fontSize ? _self.fontSize : fontSize // ignore: cast_nullable_to_non_nullable
as double,fontFamily: freezed == fontFamily ? _self.fontFamily : fontFamily // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,authorId: freezed == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String?,authorUser: freezed == authorUser ? _self.authorUser : authorUser // ignore: cast_nullable_to_non_nullable
as User?,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,shareCount: null == shareCount ? _self.shareCount : shareCount // ignore: cast_nullable_to_non_nullable
as int,isLikedByCurrentUser: null == isLikedByCurrentUser ? _self.isLikedByCurrentUser : isLikedByCurrentUser // ignore: cast_nullable_to_non_nullable
as bool,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,mentions: null == mentions ? _self.mentions : mentions // ignore: cast_nullable_to_non_nullable
as List<PostMention>,poll: freezed == poll ? _self.poll : poll // ignore: cast_nullable_to_non_nullable
as PostPoll?,repostedPostId: freezed == repostedPostId ? _self.repostedPostId : repostedPostId // ignore: cast_nullable_to_non_nullable
as String?,repostedPostType: freezed == repostedPostType ? _self.repostedPostType : repostedPostType // ignore: cast_nullable_to_non_nullable
as String?,repostedMediaUrl: freezed == repostedMediaUrl ? _self.repostedMediaUrl : repostedMediaUrl // ignore: cast_nullable_to_non_nullable
as String?,repostedThumbnailUrl: freezed == repostedThumbnailUrl ? _self.repostedThumbnailUrl : repostedThumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,repostedCaption: freezed == repostedCaption ? _self.repostedCaption : repostedCaption // ignore: cast_nullable_to_non_nullable
as String?,repostedAuthorId: freezed == repostedAuthorId ? _self.repostedAuthorId : repostedAuthorId // ignore: cast_nullable_to_non_nullable
as String?,repostedAuthorName: freezed == repostedAuthorName ? _self.repostedAuthorName : repostedAuthorName // ignore: cast_nullable_to_non_nullable
as String?,repostedAuthorUsername: freezed == repostedAuthorUsername ? _self.repostedAuthorUsername : repostedAuthorUsername // ignore: cast_nullable_to_non_nullable
as String?,repostedAuthorAvatarUrl: freezed == repostedAuthorAvatarUrl ? _self.repostedAuthorAvatarUrl : repostedAuthorAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of TextPost
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
}/// Create a copy of TextPost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostPollCopyWith<$Res>? get poll {
    if (_self.poll == null) {
    return null;
  }

  return $PostPollCopyWith<$Res>(_self.poll!, (value) {
    return _then(_self.copyWith(poll: value));
  });
}
}


/// Adds pattern-matching-related methods to [TextPost].
extension TextPostPatterns on TextPost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TextPost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TextPost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TextPost value)  $default,){
final _that = this;
switch (_that) {
case _TextPost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TextPost value)?  $default,){
final _that = this;
switch (_that) {
case _TextPost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String body,  String? title,  String? imageUrl,  int backgroundColor,  int textColor,  double fontSize,  String? fontFamily,  DateTime? createdAt,  DateTime? scheduledAt,  DateTime? publishedAt,  String? status,  String? authorId,  User? authorUser,  int likes,  int commentCount,  int shareCount,  bool isLikedByCurrentUser,  bool isFavorite,  List<String> tags,  List<PostMention> mentions,  PostPoll? poll,  String? repostedPostId,  String? repostedPostType,  String? repostedMediaUrl,  String? repostedThumbnailUrl,  String? repostedCaption,  String? repostedAuthorId,  String? repostedAuthorName,  String? repostedAuthorUsername,  String? repostedAuthorAvatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TextPost() when $default != null:
return $default(_that.id,_that.body,_that.title,_that.imageUrl,_that.backgroundColor,_that.textColor,_that.fontSize,_that.fontFamily,_that.createdAt,_that.scheduledAt,_that.publishedAt,_that.status,_that.authorId,_that.authorUser,_that.likes,_that.commentCount,_that.shareCount,_that.isLikedByCurrentUser,_that.isFavorite,_that.tags,_that.mentions,_that.poll,_that.repostedPostId,_that.repostedPostType,_that.repostedMediaUrl,_that.repostedThumbnailUrl,_that.repostedCaption,_that.repostedAuthorId,_that.repostedAuthorName,_that.repostedAuthorUsername,_that.repostedAuthorAvatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String body,  String? title,  String? imageUrl,  int backgroundColor,  int textColor,  double fontSize,  String? fontFamily,  DateTime? createdAt,  DateTime? scheduledAt,  DateTime? publishedAt,  String? status,  String? authorId,  User? authorUser,  int likes,  int commentCount,  int shareCount,  bool isLikedByCurrentUser,  bool isFavorite,  List<String> tags,  List<PostMention> mentions,  PostPoll? poll,  String? repostedPostId,  String? repostedPostType,  String? repostedMediaUrl,  String? repostedThumbnailUrl,  String? repostedCaption,  String? repostedAuthorId,  String? repostedAuthorName,  String? repostedAuthorUsername,  String? repostedAuthorAvatarUrl)  $default,) {final _that = this;
switch (_that) {
case _TextPost():
return $default(_that.id,_that.body,_that.title,_that.imageUrl,_that.backgroundColor,_that.textColor,_that.fontSize,_that.fontFamily,_that.createdAt,_that.scheduledAt,_that.publishedAt,_that.status,_that.authorId,_that.authorUser,_that.likes,_that.commentCount,_that.shareCount,_that.isLikedByCurrentUser,_that.isFavorite,_that.tags,_that.mentions,_that.poll,_that.repostedPostId,_that.repostedPostType,_that.repostedMediaUrl,_that.repostedThumbnailUrl,_that.repostedCaption,_that.repostedAuthorId,_that.repostedAuthorName,_that.repostedAuthorUsername,_that.repostedAuthorAvatarUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String body,  String? title,  String? imageUrl,  int backgroundColor,  int textColor,  double fontSize,  String? fontFamily,  DateTime? createdAt,  DateTime? scheduledAt,  DateTime? publishedAt,  String? status,  String? authorId,  User? authorUser,  int likes,  int commentCount,  int shareCount,  bool isLikedByCurrentUser,  bool isFavorite,  List<String> tags,  List<PostMention> mentions,  PostPoll? poll,  String? repostedPostId,  String? repostedPostType,  String? repostedMediaUrl,  String? repostedThumbnailUrl,  String? repostedCaption,  String? repostedAuthorId,  String? repostedAuthorName,  String? repostedAuthorUsername,  String? repostedAuthorAvatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _TextPost() when $default != null:
return $default(_that.id,_that.body,_that.title,_that.imageUrl,_that.backgroundColor,_that.textColor,_that.fontSize,_that.fontFamily,_that.createdAt,_that.scheduledAt,_that.publishedAt,_that.status,_that.authorId,_that.authorUser,_that.likes,_that.commentCount,_that.shareCount,_that.isLikedByCurrentUser,_that.isFavorite,_that.tags,_that.mentions,_that.poll,_that.repostedPostId,_that.repostedPostType,_that.repostedMediaUrl,_that.repostedThumbnailUrl,_that.repostedCaption,_that.repostedAuthorId,_that.repostedAuthorName,_that.repostedAuthorUsername,_that.repostedAuthorAvatarUrl);case _:
  return null;

}
}

}

/// @nodoc


class _TextPost extends TextPost {
  const _TextPost({required this.id, required this.body, this.title, this.imageUrl, this.backgroundColor = 0xFF1E3A5F, this.textColor = 0xFFFFFFFF, this.fontSize = 18.0, this.fontFamily, this.createdAt, this.scheduledAt, this.publishedAt, this.status, this.authorId, this.authorUser, this.likes = 0, this.commentCount = 0, this.shareCount = 0, this.isLikedByCurrentUser = false, this.isFavorite = false, final  List<String> tags = const [], final  List<PostMention> mentions = const [], this.poll, this.repostedPostId, this.repostedPostType, this.repostedMediaUrl, this.repostedThumbnailUrl, this.repostedCaption, this.repostedAuthorId, this.repostedAuthorName, this.repostedAuthorUsername, this.repostedAuthorAvatarUrl}): _tags = tags,_mentions = mentions,super._();
  

@override final  String id;
@override final  String body;
@override final  String? title;
@override final  String? imageUrl;
@override@JsonKey() final  int backgroundColor;
@override@JsonKey() final  int textColor;
@override@JsonKey() final  double fontSize;
@override final  String? fontFamily;
@override final  DateTime? createdAt;
@override final  DateTime? scheduledAt;
@override final  DateTime? publishedAt;
@override final  String? status;
@override final  String? authorId;
@override final  User? authorUser;
@override@JsonKey() final  int likes;
@override@JsonKey() final  int commentCount;
@override@JsonKey() final  int shareCount;
@override@JsonKey() final  bool isLikedByCurrentUser;
@override@JsonKey() final  bool isFavorite;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

 final  List<PostMention> _mentions;
@override@JsonKey() List<PostMention> get mentions {
  if (_mentions is EqualUnmodifiableListView) return _mentions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mentions);
}

@override final  PostPoll? poll;
@override final  String? repostedPostId;
@override final  String? repostedPostType;
@override final  String? repostedMediaUrl;
@override final  String? repostedThumbnailUrl;
@override final  String? repostedCaption;
@override final  String? repostedAuthorId;
@override final  String? repostedAuthorName;
@override final  String? repostedAuthorUsername;
@override final  String? repostedAuthorAvatarUrl;

/// Create a copy of TextPost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TextPostCopyWith<_TextPost> get copyWith => __$TextPostCopyWithImpl<_TextPost>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TextPost&&(identical(other.id, id) || other.id == id)&&(identical(other.body, body) || other.body == body)&&(identical(other.title, title) || other.title == title)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.backgroundColor, backgroundColor) || other.backgroundColor == backgroundColor)&&(identical(other.textColor, textColor) || other.textColor == textColor)&&(identical(other.fontSize, fontSize) || other.fontSize == fontSize)&&(identical(other.fontFamily, fontFamily) || other.fontFamily == fontFamily)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.authorUser, authorUser) || other.authorUser == authorUser)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.shareCount, shareCount) || other.shareCount == shareCount)&&(identical(other.isLikedByCurrentUser, isLikedByCurrentUser) || other.isLikedByCurrentUser == isLikedByCurrentUser)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._mentions, _mentions)&&(identical(other.poll, poll) || other.poll == poll)&&(identical(other.repostedPostId, repostedPostId) || other.repostedPostId == repostedPostId)&&(identical(other.repostedPostType, repostedPostType) || other.repostedPostType == repostedPostType)&&(identical(other.repostedMediaUrl, repostedMediaUrl) || other.repostedMediaUrl == repostedMediaUrl)&&(identical(other.repostedThumbnailUrl, repostedThumbnailUrl) || other.repostedThumbnailUrl == repostedThumbnailUrl)&&(identical(other.repostedCaption, repostedCaption) || other.repostedCaption == repostedCaption)&&(identical(other.repostedAuthorId, repostedAuthorId) || other.repostedAuthorId == repostedAuthorId)&&(identical(other.repostedAuthorName, repostedAuthorName) || other.repostedAuthorName == repostedAuthorName)&&(identical(other.repostedAuthorUsername, repostedAuthorUsername) || other.repostedAuthorUsername == repostedAuthorUsername)&&(identical(other.repostedAuthorAvatarUrl, repostedAuthorAvatarUrl) || other.repostedAuthorAvatarUrl == repostedAuthorAvatarUrl));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,body,title,imageUrl,backgroundColor,textColor,fontSize,fontFamily,createdAt,scheduledAt,publishedAt,status,authorId,authorUser,likes,commentCount,shareCount,isLikedByCurrentUser,isFavorite,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_mentions),poll,repostedPostId,repostedPostType,repostedMediaUrl,repostedThumbnailUrl,repostedCaption,repostedAuthorId,repostedAuthorName,repostedAuthorUsername,repostedAuthorAvatarUrl]);

@override
String toString() {
  return 'TextPost(id: $id, body: $body, title: $title, imageUrl: $imageUrl, backgroundColor: $backgroundColor, textColor: $textColor, fontSize: $fontSize, fontFamily: $fontFamily, createdAt: $createdAt, scheduledAt: $scheduledAt, publishedAt: $publishedAt, status: $status, authorId: $authorId, authorUser: $authorUser, likes: $likes, commentCount: $commentCount, shareCount: $shareCount, isLikedByCurrentUser: $isLikedByCurrentUser, isFavorite: $isFavorite, tags: $tags, mentions: $mentions, poll: $poll, repostedPostId: $repostedPostId, repostedPostType: $repostedPostType, repostedMediaUrl: $repostedMediaUrl, repostedThumbnailUrl: $repostedThumbnailUrl, repostedCaption: $repostedCaption, repostedAuthorId: $repostedAuthorId, repostedAuthorName: $repostedAuthorName, repostedAuthorUsername: $repostedAuthorUsername, repostedAuthorAvatarUrl: $repostedAuthorAvatarUrl)';
}


}

/// @nodoc
abstract mixin class _$TextPostCopyWith<$Res> implements $TextPostCopyWith<$Res> {
  factory _$TextPostCopyWith(_TextPost value, $Res Function(_TextPost) _then) = __$TextPostCopyWithImpl;
@override @useResult
$Res call({
 String id, String body, String? title, String? imageUrl, int backgroundColor, int textColor, double fontSize, String? fontFamily, DateTime? createdAt, DateTime? scheduledAt, DateTime? publishedAt, String? status, String? authorId, User? authorUser, int likes, int commentCount, int shareCount, bool isLikedByCurrentUser, bool isFavorite, List<String> tags, List<PostMention> mentions, PostPoll? poll, String? repostedPostId, String? repostedPostType, String? repostedMediaUrl, String? repostedThumbnailUrl, String? repostedCaption, String? repostedAuthorId, String? repostedAuthorName, String? repostedAuthorUsername, String? repostedAuthorAvatarUrl
});


@override $UserCopyWith<$Res>? get authorUser;@override $PostPollCopyWith<$Res>? get poll;

}
/// @nodoc
class __$TextPostCopyWithImpl<$Res>
    implements _$TextPostCopyWith<$Res> {
  __$TextPostCopyWithImpl(this._self, this._then);

  final _TextPost _self;
  final $Res Function(_TextPost) _then;

/// Create a copy of TextPost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? body = null,Object? title = freezed,Object? imageUrl = freezed,Object? backgroundColor = null,Object? textColor = null,Object? fontSize = null,Object? fontFamily = freezed,Object? createdAt = freezed,Object? scheduledAt = freezed,Object? publishedAt = freezed,Object? status = freezed,Object? authorId = freezed,Object? authorUser = freezed,Object? likes = null,Object? commentCount = null,Object? shareCount = null,Object? isLikedByCurrentUser = null,Object? isFavorite = null,Object? tags = null,Object? mentions = null,Object? poll = freezed,Object? repostedPostId = freezed,Object? repostedPostType = freezed,Object? repostedMediaUrl = freezed,Object? repostedThumbnailUrl = freezed,Object? repostedCaption = freezed,Object? repostedAuthorId = freezed,Object? repostedAuthorName = freezed,Object? repostedAuthorUsername = freezed,Object? repostedAuthorAvatarUrl = freezed,}) {
  return _then(_TextPost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,backgroundColor: null == backgroundColor ? _self.backgroundColor : backgroundColor // ignore: cast_nullable_to_non_nullable
as int,textColor: null == textColor ? _self.textColor : textColor // ignore: cast_nullable_to_non_nullable
as int,fontSize: null == fontSize ? _self.fontSize : fontSize // ignore: cast_nullable_to_non_nullable
as double,fontFamily: freezed == fontFamily ? _self.fontFamily : fontFamily // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,authorId: freezed == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String?,authorUser: freezed == authorUser ? _self.authorUser : authorUser // ignore: cast_nullable_to_non_nullable
as User?,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,shareCount: null == shareCount ? _self.shareCount : shareCount // ignore: cast_nullable_to_non_nullable
as int,isLikedByCurrentUser: null == isLikedByCurrentUser ? _self.isLikedByCurrentUser : isLikedByCurrentUser // ignore: cast_nullable_to_non_nullable
as bool,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,mentions: null == mentions ? _self._mentions : mentions // ignore: cast_nullable_to_non_nullable
as List<PostMention>,poll: freezed == poll ? _self.poll : poll // ignore: cast_nullable_to_non_nullable
as PostPoll?,repostedPostId: freezed == repostedPostId ? _self.repostedPostId : repostedPostId // ignore: cast_nullable_to_non_nullable
as String?,repostedPostType: freezed == repostedPostType ? _self.repostedPostType : repostedPostType // ignore: cast_nullable_to_non_nullable
as String?,repostedMediaUrl: freezed == repostedMediaUrl ? _self.repostedMediaUrl : repostedMediaUrl // ignore: cast_nullable_to_non_nullable
as String?,repostedThumbnailUrl: freezed == repostedThumbnailUrl ? _self.repostedThumbnailUrl : repostedThumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,repostedCaption: freezed == repostedCaption ? _self.repostedCaption : repostedCaption // ignore: cast_nullable_to_non_nullable
as String?,repostedAuthorId: freezed == repostedAuthorId ? _self.repostedAuthorId : repostedAuthorId // ignore: cast_nullable_to_non_nullable
as String?,repostedAuthorName: freezed == repostedAuthorName ? _self.repostedAuthorName : repostedAuthorName // ignore: cast_nullable_to_non_nullable
as String?,repostedAuthorUsername: freezed == repostedAuthorUsername ? _self.repostedAuthorUsername : repostedAuthorUsername // ignore: cast_nullable_to_non_nullable
as String?,repostedAuthorAvatarUrl: freezed == repostedAuthorAvatarUrl ? _self.repostedAuthorAvatarUrl : repostedAuthorAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of TextPost
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
}/// Create a copy of TextPost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostPollCopyWith<$Res>? get poll {
    if (_self.poll == null) {
    return null;
  }

  return $PostPollCopyWith<$Res>(_self.poll!, (value) {
    return _then(_self.copyWith(poll: value));
  });
}
}

// dart format on
