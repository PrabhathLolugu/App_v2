// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VideoPost {

 String get id; String get videoUrl; String? get thumbnailUrl; String? get caption; String? get title; String? get location; double get aspectRatio; int get durationSeconds; DateTime? get createdAt; DateTime? get scheduledAt; DateTime? get publishedAt; String? get status; String? get authorId; User? get authorUser; int get likes; int get commentCount; int get shareCount; int get viewCount; bool get isLikedByCurrentUser; bool get isFavorite; List<String> get tags; List<PostMention> get mentions; String? get repostedPostId; String? get repostedPostType; String? get repostedMediaUrl; String? get repostedThumbnailUrl; String? get repostedCaption; String? get repostedAuthorId; String? get repostedAuthorName; String? get repostedAuthorUsername; String? get repostedAuthorAvatarUrl;
/// Create a copy of VideoPost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoPostCopyWith<VideoPost> get copyWith => _$VideoPostCopyWithImpl<VideoPost>(this as VideoPost, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoPost&&(identical(other.id, id) || other.id == id)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.title, title) || other.title == title)&&(identical(other.location, location) || other.location == location)&&(identical(other.aspectRatio, aspectRatio) || other.aspectRatio == aspectRatio)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.authorUser, authorUser) || other.authorUser == authorUser)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.shareCount, shareCount) || other.shareCount == shareCount)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.isLikedByCurrentUser, isLikedByCurrentUser) || other.isLikedByCurrentUser == isLikedByCurrentUser)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.mentions, mentions)&&(identical(other.repostedPostId, repostedPostId) || other.repostedPostId == repostedPostId)&&(identical(other.repostedPostType, repostedPostType) || other.repostedPostType == repostedPostType)&&(identical(other.repostedMediaUrl, repostedMediaUrl) || other.repostedMediaUrl == repostedMediaUrl)&&(identical(other.repostedThumbnailUrl, repostedThumbnailUrl) || other.repostedThumbnailUrl == repostedThumbnailUrl)&&(identical(other.repostedCaption, repostedCaption) || other.repostedCaption == repostedCaption)&&(identical(other.repostedAuthorId, repostedAuthorId) || other.repostedAuthorId == repostedAuthorId)&&(identical(other.repostedAuthorName, repostedAuthorName) || other.repostedAuthorName == repostedAuthorName)&&(identical(other.repostedAuthorUsername, repostedAuthorUsername) || other.repostedAuthorUsername == repostedAuthorUsername)&&(identical(other.repostedAuthorAvatarUrl, repostedAuthorAvatarUrl) || other.repostedAuthorAvatarUrl == repostedAuthorAvatarUrl));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,videoUrl,thumbnailUrl,caption,title,location,aspectRatio,durationSeconds,createdAt,scheduledAt,publishedAt,status,authorId,authorUser,likes,commentCount,shareCount,viewCount,isLikedByCurrentUser,isFavorite,const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(mentions),repostedPostId,repostedPostType,repostedMediaUrl,repostedThumbnailUrl,repostedCaption,repostedAuthorId,repostedAuthorName,repostedAuthorUsername,repostedAuthorAvatarUrl]);

@override
String toString() {
  return 'VideoPost(id: $id, videoUrl: $videoUrl, thumbnailUrl: $thumbnailUrl, caption: $caption, title: $title, location: $location, aspectRatio: $aspectRatio, durationSeconds: $durationSeconds, createdAt: $createdAt, scheduledAt: $scheduledAt, publishedAt: $publishedAt, status: $status, authorId: $authorId, authorUser: $authorUser, likes: $likes, commentCount: $commentCount, shareCount: $shareCount, viewCount: $viewCount, isLikedByCurrentUser: $isLikedByCurrentUser, isFavorite: $isFavorite, tags: $tags, mentions: $mentions, repostedPostId: $repostedPostId, repostedPostType: $repostedPostType, repostedMediaUrl: $repostedMediaUrl, repostedThumbnailUrl: $repostedThumbnailUrl, repostedCaption: $repostedCaption, repostedAuthorId: $repostedAuthorId, repostedAuthorName: $repostedAuthorName, repostedAuthorUsername: $repostedAuthorUsername, repostedAuthorAvatarUrl: $repostedAuthorAvatarUrl)';
}


}

/// @nodoc
abstract mixin class $VideoPostCopyWith<$Res>  {
  factory $VideoPostCopyWith(VideoPost value, $Res Function(VideoPost) _then) = _$VideoPostCopyWithImpl;
@useResult
$Res call({
 String id, String videoUrl, String? thumbnailUrl, String? caption, String? title, String? location, double aspectRatio, int durationSeconds, DateTime? createdAt, DateTime? scheduledAt, DateTime? publishedAt, String? status, String? authorId, User? authorUser, int likes, int commentCount, int shareCount, int viewCount, bool isLikedByCurrentUser, bool isFavorite, List<String> tags, List<PostMention> mentions, String? repostedPostId, String? repostedPostType, String? repostedMediaUrl, String? repostedThumbnailUrl, String? repostedCaption, String? repostedAuthorId, String? repostedAuthorName, String? repostedAuthorUsername, String? repostedAuthorAvatarUrl
});


$UserCopyWith<$Res>? get authorUser;

}
/// @nodoc
class _$VideoPostCopyWithImpl<$Res>
    implements $VideoPostCopyWith<$Res> {
  _$VideoPostCopyWithImpl(this._self, this._then);

  final VideoPost _self;
  final $Res Function(VideoPost) _then;

/// Create a copy of VideoPost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? videoUrl = null,Object? thumbnailUrl = freezed,Object? caption = freezed,Object? title = freezed,Object? location = freezed,Object? aspectRatio = null,Object? durationSeconds = null,Object? createdAt = freezed,Object? scheduledAt = freezed,Object? publishedAt = freezed,Object? status = freezed,Object? authorId = freezed,Object? authorUser = freezed,Object? likes = null,Object? commentCount = null,Object? shareCount = null,Object? viewCount = null,Object? isLikedByCurrentUser = null,Object? isFavorite = null,Object? tags = null,Object? mentions = null,Object? repostedPostId = freezed,Object? repostedPostType = freezed,Object? repostedMediaUrl = freezed,Object? repostedThumbnailUrl = freezed,Object? repostedCaption = freezed,Object? repostedAuthorId = freezed,Object? repostedAuthorName = freezed,Object? repostedAuthorUsername = freezed,Object? repostedAuthorAvatarUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,videoUrl: null == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,aspectRatio: null == aspectRatio ? _self.aspectRatio : aspectRatio // ignore: cast_nullable_to_non_nullable
as double,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,authorId: freezed == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String?,authorUser: freezed == authorUser ? _self.authorUser : authorUser // ignore: cast_nullable_to_non_nullable
as User?,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,shareCount: null == shareCount ? _self.shareCount : shareCount // ignore: cast_nullable_to_non_nullable
as int,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,isLikedByCurrentUser: null == isLikedByCurrentUser ? _self.isLikedByCurrentUser : isLikedByCurrentUser // ignore: cast_nullable_to_non_nullable
as bool,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,mentions: null == mentions ? _self.mentions : mentions // ignore: cast_nullable_to_non_nullable
as List<PostMention>,repostedPostId: freezed == repostedPostId ? _self.repostedPostId : repostedPostId // ignore: cast_nullable_to_non_nullable
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
/// Create a copy of VideoPost
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


/// Adds pattern-matching-related methods to [VideoPost].
extension VideoPostPatterns on VideoPost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoPost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoPost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoPost value)  $default,){
final _that = this;
switch (_that) {
case _VideoPost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoPost value)?  $default,){
final _that = this;
switch (_that) {
case _VideoPost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String videoUrl,  String? thumbnailUrl,  String? caption,  String? title,  String? location,  double aspectRatio,  int durationSeconds,  DateTime? createdAt,  DateTime? scheduledAt,  DateTime? publishedAt,  String? status,  String? authorId,  User? authorUser,  int likes,  int commentCount,  int shareCount,  int viewCount,  bool isLikedByCurrentUser,  bool isFavorite,  List<String> tags,  List<PostMention> mentions,  String? repostedPostId,  String? repostedPostType,  String? repostedMediaUrl,  String? repostedThumbnailUrl,  String? repostedCaption,  String? repostedAuthorId,  String? repostedAuthorName,  String? repostedAuthorUsername,  String? repostedAuthorAvatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoPost() when $default != null:
return $default(_that.id,_that.videoUrl,_that.thumbnailUrl,_that.caption,_that.title,_that.location,_that.aspectRatio,_that.durationSeconds,_that.createdAt,_that.scheduledAt,_that.publishedAt,_that.status,_that.authorId,_that.authorUser,_that.likes,_that.commentCount,_that.shareCount,_that.viewCount,_that.isLikedByCurrentUser,_that.isFavorite,_that.tags,_that.mentions,_that.repostedPostId,_that.repostedPostType,_that.repostedMediaUrl,_that.repostedThumbnailUrl,_that.repostedCaption,_that.repostedAuthorId,_that.repostedAuthorName,_that.repostedAuthorUsername,_that.repostedAuthorAvatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String videoUrl,  String? thumbnailUrl,  String? caption,  String? title,  String? location,  double aspectRatio,  int durationSeconds,  DateTime? createdAt,  DateTime? scheduledAt,  DateTime? publishedAt,  String? status,  String? authorId,  User? authorUser,  int likes,  int commentCount,  int shareCount,  int viewCount,  bool isLikedByCurrentUser,  bool isFavorite,  List<String> tags,  List<PostMention> mentions,  String? repostedPostId,  String? repostedPostType,  String? repostedMediaUrl,  String? repostedThumbnailUrl,  String? repostedCaption,  String? repostedAuthorId,  String? repostedAuthorName,  String? repostedAuthorUsername,  String? repostedAuthorAvatarUrl)  $default,) {final _that = this;
switch (_that) {
case _VideoPost():
return $default(_that.id,_that.videoUrl,_that.thumbnailUrl,_that.caption,_that.title,_that.location,_that.aspectRatio,_that.durationSeconds,_that.createdAt,_that.scheduledAt,_that.publishedAt,_that.status,_that.authorId,_that.authorUser,_that.likes,_that.commentCount,_that.shareCount,_that.viewCount,_that.isLikedByCurrentUser,_that.isFavorite,_that.tags,_that.mentions,_that.repostedPostId,_that.repostedPostType,_that.repostedMediaUrl,_that.repostedThumbnailUrl,_that.repostedCaption,_that.repostedAuthorId,_that.repostedAuthorName,_that.repostedAuthorUsername,_that.repostedAuthorAvatarUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String videoUrl,  String? thumbnailUrl,  String? caption,  String? title,  String? location,  double aspectRatio,  int durationSeconds,  DateTime? createdAt,  DateTime? scheduledAt,  DateTime? publishedAt,  String? status,  String? authorId,  User? authorUser,  int likes,  int commentCount,  int shareCount,  int viewCount,  bool isLikedByCurrentUser,  bool isFavorite,  List<String> tags,  List<PostMention> mentions,  String? repostedPostId,  String? repostedPostType,  String? repostedMediaUrl,  String? repostedThumbnailUrl,  String? repostedCaption,  String? repostedAuthorId,  String? repostedAuthorName,  String? repostedAuthorUsername,  String? repostedAuthorAvatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _VideoPost() when $default != null:
return $default(_that.id,_that.videoUrl,_that.thumbnailUrl,_that.caption,_that.title,_that.location,_that.aspectRatio,_that.durationSeconds,_that.createdAt,_that.scheduledAt,_that.publishedAt,_that.status,_that.authorId,_that.authorUser,_that.likes,_that.commentCount,_that.shareCount,_that.viewCount,_that.isLikedByCurrentUser,_that.isFavorite,_that.tags,_that.mentions,_that.repostedPostId,_that.repostedPostType,_that.repostedMediaUrl,_that.repostedThumbnailUrl,_that.repostedCaption,_that.repostedAuthorId,_that.repostedAuthorName,_that.repostedAuthorUsername,_that.repostedAuthorAvatarUrl);case _:
  return null;

}
}

}

/// @nodoc


class _VideoPost extends VideoPost {
  const _VideoPost({required this.id, required this.videoUrl, this.thumbnailUrl, this.caption, this.title, this.location, this.aspectRatio = 9 / 16, this.durationSeconds = 0, this.createdAt, this.scheduledAt, this.publishedAt, this.status, this.authorId, this.authorUser, this.likes = 0, this.commentCount = 0, this.shareCount = 0, this.viewCount = 0, this.isLikedByCurrentUser = false, this.isFavorite = false, final  List<String> tags = const [], final  List<PostMention> mentions = const [], this.repostedPostId, this.repostedPostType, this.repostedMediaUrl, this.repostedThumbnailUrl, this.repostedCaption, this.repostedAuthorId, this.repostedAuthorName, this.repostedAuthorUsername, this.repostedAuthorAvatarUrl}): _tags = tags,_mentions = mentions,super._();
  

@override final  String id;
@override final  String videoUrl;
@override final  String? thumbnailUrl;
@override final  String? caption;
@override final  String? title;
@override final  String? location;
@override@JsonKey() final  double aspectRatio;
@override@JsonKey() final  int durationSeconds;
@override final  DateTime? createdAt;
@override final  DateTime? scheduledAt;
@override final  DateTime? publishedAt;
@override final  String? status;
@override final  String? authorId;
@override final  User? authorUser;
@override@JsonKey() final  int likes;
@override@JsonKey() final  int commentCount;
@override@JsonKey() final  int shareCount;
@override@JsonKey() final  int viewCount;
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

@override final  String? repostedPostId;
@override final  String? repostedPostType;
@override final  String? repostedMediaUrl;
@override final  String? repostedThumbnailUrl;
@override final  String? repostedCaption;
@override final  String? repostedAuthorId;
@override final  String? repostedAuthorName;
@override final  String? repostedAuthorUsername;
@override final  String? repostedAuthorAvatarUrl;

/// Create a copy of VideoPost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoPostCopyWith<_VideoPost> get copyWith => __$VideoPostCopyWithImpl<_VideoPost>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoPost&&(identical(other.id, id) || other.id == id)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.title, title) || other.title == title)&&(identical(other.location, location) || other.location == location)&&(identical(other.aspectRatio, aspectRatio) || other.aspectRatio == aspectRatio)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.authorUser, authorUser) || other.authorUser == authorUser)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.shareCount, shareCount) || other.shareCount == shareCount)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.isLikedByCurrentUser, isLikedByCurrentUser) || other.isLikedByCurrentUser == isLikedByCurrentUser)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._mentions, _mentions)&&(identical(other.repostedPostId, repostedPostId) || other.repostedPostId == repostedPostId)&&(identical(other.repostedPostType, repostedPostType) || other.repostedPostType == repostedPostType)&&(identical(other.repostedMediaUrl, repostedMediaUrl) || other.repostedMediaUrl == repostedMediaUrl)&&(identical(other.repostedThumbnailUrl, repostedThumbnailUrl) || other.repostedThumbnailUrl == repostedThumbnailUrl)&&(identical(other.repostedCaption, repostedCaption) || other.repostedCaption == repostedCaption)&&(identical(other.repostedAuthorId, repostedAuthorId) || other.repostedAuthorId == repostedAuthorId)&&(identical(other.repostedAuthorName, repostedAuthorName) || other.repostedAuthorName == repostedAuthorName)&&(identical(other.repostedAuthorUsername, repostedAuthorUsername) || other.repostedAuthorUsername == repostedAuthorUsername)&&(identical(other.repostedAuthorAvatarUrl, repostedAuthorAvatarUrl) || other.repostedAuthorAvatarUrl == repostedAuthorAvatarUrl));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,videoUrl,thumbnailUrl,caption,title,location,aspectRatio,durationSeconds,createdAt,scheduledAt,publishedAt,status,authorId,authorUser,likes,commentCount,shareCount,viewCount,isLikedByCurrentUser,isFavorite,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_mentions),repostedPostId,repostedPostType,repostedMediaUrl,repostedThumbnailUrl,repostedCaption,repostedAuthorId,repostedAuthorName,repostedAuthorUsername,repostedAuthorAvatarUrl]);

@override
String toString() {
  return 'VideoPost(id: $id, videoUrl: $videoUrl, thumbnailUrl: $thumbnailUrl, caption: $caption, title: $title, location: $location, aspectRatio: $aspectRatio, durationSeconds: $durationSeconds, createdAt: $createdAt, scheduledAt: $scheduledAt, publishedAt: $publishedAt, status: $status, authorId: $authorId, authorUser: $authorUser, likes: $likes, commentCount: $commentCount, shareCount: $shareCount, viewCount: $viewCount, isLikedByCurrentUser: $isLikedByCurrentUser, isFavorite: $isFavorite, tags: $tags, mentions: $mentions, repostedPostId: $repostedPostId, repostedPostType: $repostedPostType, repostedMediaUrl: $repostedMediaUrl, repostedThumbnailUrl: $repostedThumbnailUrl, repostedCaption: $repostedCaption, repostedAuthorId: $repostedAuthorId, repostedAuthorName: $repostedAuthorName, repostedAuthorUsername: $repostedAuthorUsername, repostedAuthorAvatarUrl: $repostedAuthorAvatarUrl)';
}


}

/// @nodoc
abstract mixin class _$VideoPostCopyWith<$Res> implements $VideoPostCopyWith<$Res> {
  factory _$VideoPostCopyWith(_VideoPost value, $Res Function(_VideoPost) _then) = __$VideoPostCopyWithImpl;
@override @useResult
$Res call({
 String id, String videoUrl, String? thumbnailUrl, String? caption, String? title, String? location, double aspectRatio, int durationSeconds, DateTime? createdAt, DateTime? scheduledAt, DateTime? publishedAt, String? status, String? authorId, User? authorUser, int likes, int commentCount, int shareCount, int viewCount, bool isLikedByCurrentUser, bool isFavorite, List<String> tags, List<PostMention> mentions, String? repostedPostId, String? repostedPostType, String? repostedMediaUrl, String? repostedThumbnailUrl, String? repostedCaption, String? repostedAuthorId, String? repostedAuthorName, String? repostedAuthorUsername, String? repostedAuthorAvatarUrl
});


@override $UserCopyWith<$Res>? get authorUser;

}
/// @nodoc
class __$VideoPostCopyWithImpl<$Res>
    implements _$VideoPostCopyWith<$Res> {
  __$VideoPostCopyWithImpl(this._self, this._then);

  final _VideoPost _self;
  final $Res Function(_VideoPost) _then;

/// Create a copy of VideoPost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? videoUrl = null,Object? thumbnailUrl = freezed,Object? caption = freezed,Object? title = freezed,Object? location = freezed,Object? aspectRatio = null,Object? durationSeconds = null,Object? createdAt = freezed,Object? scheduledAt = freezed,Object? publishedAt = freezed,Object? status = freezed,Object? authorId = freezed,Object? authorUser = freezed,Object? likes = null,Object? commentCount = null,Object? shareCount = null,Object? viewCount = null,Object? isLikedByCurrentUser = null,Object? isFavorite = null,Object? tags = null,Object? mentions = null,Object? repostedPostId = freezed,Object? repostedPostType = freezed,Object? repostedMediaUrl = freezed,Object? repostedThumbnailUrl = freezed,Object? repostedCaption = freezed,Object? repostedAuthorId = freezed,Object? repostedAuthorName = freezed,Object? repostedAuthorUsername = freezed,Object? repostedAuthorAvatarUrl = freezed,}) {
  return _then(_VideoPost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,videoUrl: null == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,aspectRatio: null == aspectRatio ? _self.aspectRatio : aspectRatio // ignore: cast_nullable_to_non_nullable
as double,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,authorId: freezed == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String?,authorUser: freezed == authorUser ? _self.authorUser : authorUser // ignore: cast_nullable_to_non_nullable
as User?,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,shareCount: null == shareCount ? _self.shareCount : shareCount // ignore: cast_nullable_to_non_nullable
as int,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,isLikedByCurrentUser: null == isLikedByCurrentUser ? _self.isLikedByCurrentUser : isLikedByCurrentUser // ignore: cast_nullable_to_non_nullable
as bool,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,mentions: null == mentions ? _self._mentions : mentions // ignore: cast_nullable_to_non_nullable
as List<PostMention>,repostedPostId: freezed == repostedPostId ? _self.repostedPostId : repostedPostId // ignore: cast_nullable_to_non_nullable
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

/// Create a copy of VideoPost
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

// dart format on
