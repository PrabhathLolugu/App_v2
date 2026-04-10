// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FeedItem {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedItem);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedItem()';
}


}

/// @nodoc
class $FeedItemCopyWith<$Res>  {
$FeedItemCopyWith(FeedItem _, $Res Function(FeedItem) __);
}


/// Adds pattern-matching-related methods to [FeedItem].
extension FeedItemPatterns on FeedItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( StoryFeedItem value)?  story,TResult Function( ImagePostFeedItem value)?  imagePost,TResult Function( TextPostFeedItem value)?  textPost,TResult Function( VideoPostFeedItem value)?  videoPost,required TResult orElse(),}){
final _that = this;
switch (_that) {
case StoryFeedItem() when story != null:
return story(_that);case ImagePostFeedItem() when imagePost != null:
return imagePost(_that);case TextPostFeedItem() when textPost != null:
return textPost(_that);case VideoPostFeedItem() when videoPost != null:
return videoPost(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( StoryFeedItem value)  story,required TResult Function( ImagePostFeedItem value)  imagePost,required TResult Function( TextPostFeedItem value)  textPost,required TResult Function( VideoPostFeedItem value)  videoPost,}){
final _that = this;
switch (_that) {
case StoryFeedItem():
return story(_that);case ImagePostFeedItem():
return imagePost(_that);case TextPostFeedItem():
return textPost(_that);case VideoPostFeedItem():
return videoPost(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( StoryFeedItem value)?  story,TResult? Function( ImagePostFeedItem value)?  imagePost,TResult? Function( TextPostFeedItem value)?  textPost,TResult? Function( VideoPostFeedItem value)?  videoPost,}){
final _that = this;
switch (_that) {
case StoryFeedItem() when story != null:
return story(_that);case ImagePostFeedItem() when imagePost != null:
return imagePost(_that);case TextPostFeedItem() when textPost != null:
return textPost(_that);case VideoPostFeedItem() when videoPost != null:
return videoPost(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Story story)?  story,TResult Function( ImagePost imagePost)?  imagePost,TResult Function( TextPost textPost)?  textPost,TResult Function( VideoPost videoPost)?  videoPost,required TResult orElse(),}) {final _that = this;
switch (_that) {
case StoryFeedItem() when story != null:
return story(_that.story);case ImagePostFeedItem() when imagePost != null:
return imagePost(_that.imagePost);case TextPostFeedItem() when textPost != null:
return textPost(_that.textPost);case VideoPostFeedItem() when videoPost != null:
return videoPost(_that.videoPost);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Story story)  story,required TResult Function( ImagePost imagePost)  imagePost,required TResult Function( TextPost textPost)  textPost,required TResult Function( VideoPost videoPost)  videoPost,}) {final _that = this;
switch (_that) {
case StoryFeedItem():
return story(_that.story);case ImagePostFeedItem():
return imagePost(_that.imagePost);case TextPostFeedItem():
return textPost(_that.textPost);case VideoPostFeedItem():
return videoPost(_that.videoPost);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Story story)?  story,TResult? Function( ImagePost imagePost)?  imagePost,TResult? Function( TextPost textPost)?  textPost,TResult? Function( VideoPost videoPost)?  videoPost,}) {final _that = this;
switch (_that) {
case StoryFeedItem() when story != null:
return story(_that.story);case ImagePostFeedItem() when imagePost != null:
return imagePost(_that.imagePost);case TextPostFeedItem() when textPost != null:
return textPost(_that.textPost);case VideoPostFeedItem() when videoPost != null:
return videoPost(_that.videoPost);case _:
  return null;

}
}

}

/// @nodoc


class StoryFeedItem extends FeedItem {
  const StoryFeedItem(this.story): super._();
  

 final  Story story;

/// Create a copy of FeedItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryFeedItemCopyWith<StoryFeedItem> get copyWith => _$StoryFeedItemCopyWithImpl<StoryFeedItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryFeedItem&&(identical(other.story, story) || other.story == story));
}


@override
int get hashCode => Object.hash(runtimeType,story);

@override
String toString() {
  return 'FeedItem.story(story: $story)';
}


}

/// @nodoc
abstract mixin class $StoryFeedItemCopyWith<$Res> implements $FeedItemCopyWith<$Res> {
  factory $StoryFeedItemCopyWith(StoryFeedItem value, $Res Function(StoryFeedItem) _then) = _$StoryFeedItemCopyWithImpl;
@useResult
$Res call({
 Story story
});


$StoryCopyWith<$Res> get story;

}
/// @nodoc
class _$StoryFeedItemCopyWithImpl<$Res>
    implements $StoryFeedItemCopyWith<$Res> {
  _$StoryFeedItemCopyWithImpl(this._self, this._then);

  final StoryFeedItem _self;
  final $Res Function(StoryFeedItem) _then;

/// Create a copy of FeedItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? story = null,}) {
  return _then(StoryFeedItem(
null == story ? _self.story : story // ignore: cast_nullable_to_non_nullable
as Story,
  ));
}

/// Create a copy of FeedItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoryCopyWith<$Res> get story {
  
  return $StoryCopyWith<$Res>(_self.story, (value) {
    return _then(_self.copyWith(story: value));
  });
}
}

/// @nodoc


class ImagePostFeedItem extends FeedItem {
  const ImagePostFeedItem(this.imagePost): super._();
  

 final  ImagePost imagePost;

/// Create a copy of FeedItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImagePostFeedItemCopyWith<ImagePostFeedItem> get copyWith => _$ImagePostFeedItemCopyWithImpl<ImagePostFeedItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImagePostFeedItem&&(identical(other.imagePost, imagePost) || other.imagePost == imagePost));
}


@override
int get hashCode => Object.hash(runtimeType,imagePost);

@override
String toString() {
  return 'FeedItem.imagePost(imagePost: $imagePost)';
}


}

/// @nodoc
abstract mixin class $ImagePostFeedItemCopyWith<$Res> implements $FeedItemCopyWith<$Res> {
  factory $ImagePostFeedItemCopyWith(ImagePostFeedItem value, $Res Function(ImagePostFeedItem) _then) = _$ImagePostFeedItemCopyWithImpl;
@useResult
$Res call({
 ImagePost imagePost
});


$ImagePostCopyWith<$Res> get imagePost;

}
/// @nodoc
class _$ImagePostFeedItemCopyWithImpl<$Res>
    implements $ImagePostFeedItemCopyWith<$Res> {
  _$ImagePostFeedItemCopyWithImpl(this._self, this._then);

  final ImagePostFeedItem _self;
  final $Res Function(ImagePostFeedItem) _then;

/// Create a copy of FeedItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? imagePost = null,}) {
  return _then(ImagePostFeedItem(
null == imagePost ? _self.imagePost : imagePost // ignore: cast_nullable_to_non_nullable
as ImagePost,
  ));
}

/// Create a copy of FeedItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImagePostCopyWith<$Res> get imagePost {
  
  return $ImagePostCopyWith<$Res>(_self.imagePost, (value) {
    return _then(_self.copyWith(imagePost: value));
  });
}
}

/// @nodoc


class TextPostFeedItem extends FeedItem {
  const TextPostFeedItem(this.textPost): super._();
  

 final  TextPost textPost;

/// Create a copy of FeedItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextPostFeedItemCopyWith<TextPostFeedItem> get copyWith => _$TextPostFeedItemCopyWithImpl<TextPostFeedItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextPostFeedItem&&(identical(other.textPost, textPost) || other.textPost == textPost));
}


@override
int get hashCode => Object.hash(runtimeType,textPost);

@override
String toString() {
  return 'FeedItem.textPost(textPost: $textPost)';
}


}

/// @nodoc
abstract mixin class $TextPostFeedItemCopyWith<$Res> implements $FeedItemCopyWith<$Res> {
  factory $TextPostFeedItemCopyWith(TextPostFeedItem value, $Res Function(TextPostFeedItem) _then) = _$TextPostFeedItemCopyWithImpl;
@useResult
$Res call({
 TextPost textPost
});


$TextPostCopyWith<$Res> get textPost;

}
/// @nodoc
class _$TextPostFeedItemCopyWithImpl<$Res>
    implements $TextPostFeedItemCopyWith<$Res> {
  _$TextPostFeedItemCopyWithImpl(this._self, this._then);

  final TextPostFeedItem _self;
  final $Res Function(TextPostFeedItem) _then;

/// Create a copy of FeedItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? textPost = null,}) {
  return _then(TextPostFeedItem(
null == textPost ? _self.textPost : textPost // ignore: cast_nullable_to_non_nullable
as TextPost,
  ));
}

/// Create a copy of FeedItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TextPostCopyWith<$Res> get textPost {
  
  return $TextPostCopyWith<$Res>(_self.textPost, (value) {
    return _then(_self.copyWith(textPost: value));
  });
}
}

/// @nodoc


class VideoPostFeedItem extends FeedItem {
  const VideoPostFeedItem(this.videoPost): super._();
  

 final  VideoPost videoPost;

/// Create a copy of FeedItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoPostFeedItemCopyWith<VideoPostFeedItem> get copyWith => _$VideoPostFeedItemCopyWithImpl<VideoPostFeedItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoPostFeedItem&&(identical(other.videoPost, videoPost) || other.videoPost == videoPost));
}


@override
int get hashCode => Object.hash(runtimeType,videoPost);

@override
String toString() {
  return 'FeedItem.videoPost(videoPost: $videoPost)';
}


}

/// @nodoc
abstract mixin class $VideoPostFeedItemCopyWith<$Res> implements $FeedItemCopyWith<$Res> {
  factory $VideoPostFeedItemCopyWith(VideoPostFeedItem value, $Res Function(VideoPostFeedItem) _then) = _$VideoPostFeedItemCopyWithImpl;
@useResult
$Res call({
 VideoPost videoPost
});


$VideoPostCopyWith<$Res> get videoPost;

}
/// @nodoc
class _$VideoPostFeedItemCopyWithImpl<$Res>
    implements $VideoPostFeedItemCopyWith<$Res> {
  _$VideoPostFeedItemCopyWithImpl(this._self, this._then);

  final VideoPostFeedItem _self;
  final $Res Function(VideoPostFeedItem) _then;

/// Create a copy of FeedItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? videoPost = null,}) {
  return _then(VideoPostFeedItem(
null == videoPost ? _self.videoPost : videoPost // ignore: cast_nullable_to_non_nullable
as VideoPost,
  ));
}

/// Create a copy of FeedItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VideoPostCopyWith<$Res> get videoPost {
  
  return $VideoPostCopyWith<$Res>(_self.videoPost, (value) {
    return _then(_self.copyWith(videoPost: value));
  });
}
}

// dart format on
