// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_generator_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StoryGeneratorState {

/// Interactive prompt configuration (used when isRawPrompt is false)
 StoryPrompt get interactivePrompt;/// Raw prompt configuration (used when isRawPrompt is true)
 StoryPrompt get rawPrompt;/// Whether the current mode is raw prompt
 bool get isRawPromptMode;/// Generator options (language, format, length)
 GeneratorOptions get options;/// Whether the generator is currently loading options
 bool get isLoadingOptions;/// Whether a story is being generated
 bool get isGenerating;/// Progress message during generation
 String? get generatingMessage;/// The generated story (if any)
 Story? get generatedStory;/// Error message (if any)
 String? get errorMessage;/// Current quick prompt index in carousel
 int get currentQuickPromptIndex;/// Whether an image is being generated
 bool get isGeneratingImage;/// The generated story image URL
 String? get storyImageUrl;/// Error message for image generation
 String? get imageGenerationError;/// List of generated stories history
 List<Story> get history;/// Whether history is being loaded
 bool get isLoadingHistory;/// Whether there are more stories to load
 bool get hasMoreHistory;/// Whether device is currently online
 bool get isOnline;/// Whether the voice input is active
 bool get isListening;/// Partial text from voice input
 String? get partialVoiceResult;
/// Create a copy of StoryGeneratorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryGeneratorStateCopyWith<StoryGeneratorState> get copyWith => _$StoryGeneratorStateCopyWithImpl<StoryGeneratorState>(this as StoryGeneratorState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryGeneratorState&&(identical(other.interactivePrompt, interactivePrompt) || other.interactivePrompt == interactivePrompt)&&(identical(other.rawPrompt, rawPrompt) || other.rawPrompt == rawPrompt)&&(identical(other.isRawPromptMode, isRawPromptMode) || other.isRawPromptMode == isRawPromptMode)&&(identical(other.options, options) || other.options == options)&&(identical(other.isLoadingOptions, isLoadingOptions) || other.isLoadingOptions == isLoadingOptions)&&(identical(other.isGenerating, isGenerating) || other.isGenerating == isGenerating)&&(identical(other.generatingMessage, generatingMessage) || other.generatingMessage == generatingMessage)&&(identical(other.generatedStory, generatedStory) || other.generatedStory == generatedStory)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.currentQuickPromptIndex, currentQuickPromptIndex) || other.currentQuickPromptIndex == currentQuickPromptIndex)&&(identical(other.isGeneratingImage, isGeneratingImage) || other.isGeneratingImage == isGeneratingImage)&&(identical(other.storyImageUrl, storyImageUrl) || other.storyImageUrl == storyImageUrl)&&(identical(other.imageGenerationError, imageGenerationError) || other.imageGenerationError == imageGenerationError)&&const DeepCollectionEquality().equals(other.history, history)&&(identical(other.isLoadingHistory, isLoadingHistory) || other.isLoadingHistory == isLoadingHistory)&&(identical(other.hasMoreHistory, hasMoreHistory) || other.hasMoreHistory == hasMoreHistory)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.isListening, isListening) || other.isListening == isListening)&&(identical(other.partialVoiceResult, partialVoiceResult) || other.partialVoiceResult == partialVoiceResult));
}


@override
int get hashCode => Object.hashAll([runtimeType,interactivePrompt,rawPrompt,isRawPromptMode,options,isLoadingOptions,isGenerating,generatingMessage,generatedStory,errorMessage,currentQuickPromptIndex,isGeneratingImage,storyImageUrl,imageGenerationError,const DeepCollectionEquality().hash(history),isLoadingHistory,hasMoreHistory,isOnline,isListening,partialVoiceResult]);

@override
String toString() {
  return 'StoryGeneratorState(interactivePrompt: $interactivePrompt, rawPrompt: $rawPrompt, isRawPromptMode: $isRawPromptMode, options: $options, isLoadingOptions: $isLoadingOptions, isGenerating: $isGenerating, generatingMessage: $generatingMessage, generatedStory: $generatedStory, errorMessage: $errorMessage, currentQuickPromptIndex: $currentQuickPromptIndex, isGeneratingImage: $isGeneratingImage, storyImageUrl: $storyImageUrl, imageGenerationError: $imageGenerationError, history: $history, isLoadingHistory: $isLoadingHistory, hasMoreHistory: $hasMoreHistory, isOnline: $isOnline, isListening: $isListening, partialVoiceResult: $partialVoiceResult)';
}


}

/// @nodoc
abstract mixin class $StoryGeneratorStateCopyWith<$Res>  {
  factory $StoryGeneratorStateCopyWith(StoryGeneratorState value, $Res Function(StoryGeneratorState) _then) = _$StoryGeneratorStateCopyWithImpl;
@useResult
$Res call({
 StoryPrompt interactivePrompt, StoryPrompt rawPrompt, bool isRawPromptMode, GeneratorOptions options, bool isLoadingOptions, bool isGenerating, String? generatingMessage, Story? generatedStory, String? errorMessage, int currentQuickPromptIndex, bool isGeneratingImage, String? storyImageUrl, String? imageGenerationError, List<Story> history, bool isLoadingHistory, bool hasMoreHistory, bool isOnline, bool isListening, String? partialVoiceResult
});


$StoryPromptCopyWith<$Res> get interactivePrompt;$StoryPromptCopyWith<$Res> get rawPrompt;$GeneratorOptionsCopyWith<$Res> get options;$StoryCopyWith<$Res>? get generatedStory;

}
/// @nodoc
class _$StoryGeneratorStateCopyWithImpl<$Res>
    implements $StoryGeneratorStateCopyWith<$Res> {
  _$StoryGeneratorStateCopyWithImpl(this._self, this._then);

  final StoryGeneratorState _self;
  final $Res Function(StoryGeneratorState) _then;

/// Create a copy of StoryGeneratorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? interactivePrompt = null,Object? rawPrompt = null,Object? isRawPromptMode = null,Object? options = null,Object? isLoadingOptions = null,Object? isGenerating = null,Object? generatingMessage = freezed,Object? generatedStory = freezed,Object? errorMessage = freezed,Object? currentQuickPromptIndex = null,Object? isGeneratingImage = null,Object? storyImageUrl = freezed,Object? imageGenerationError = freezed,Object? history = null,Object? isLoadingHistory = null,Object? hasMoreHistory = null,Object? isOnline = null,Object? isListening = null,Object? partialVoiceResult = freezed,}) {
  return _then(_self.copyWith(
interactivePrompt: null == interactivePrompt ? _self.interactivePrompt : interactivePrompt // ignore: cast_nullable_to_non_nullable
as StoryPrompt,rawPrompt: null == rawPrompt ? _self.rawPrompt : rawPrompt // ignore: cast_nullable_to_non_nullable
as StoryPrompt,isRawPromptMode: null == isRawPromptMode ? _self.isRawPromptMode : isRawPromptMode // ignore: cast_nullable_to_non_nullable
as bool,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as GeneratorOptions,isLoadingOptions: null == isLoadingOptions ? _self.isLoadingOptions : isLoadingOptions // ignore: cast_nullable_to_non_nullable
as bool,isGenerating: null == isGenerating ? _self.isGenerating : isGenerating // ignore: cast_nullable_to_non_nullable
as bool,generatingMessage: freezed == generatingMessage ? _self.generatingMessage : generatingMessage // ignore: cast_nullable_to_non_nullable
as String?,generatedStory: freezed == generatedStory ? _self.generatedStory : generatedStory // ignore: cast_nullable_to_non_nullable
as Story?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,currentQuickPromptIndex: null == currentQuickPromptIndex ? _self.currentQuickPromptIndex : currentQuickPromptIndex // ignore: cast_nullable_to_non_nullable
as int,isGeneratingImage: null == isGeneratingImage ? _self.isGeneratingImage : isGeneratingImage // ignore: cast_nullable_to_non_nullable
as bool,storyImageUrl: freezed == storyImageUrl ? _self.storyImageUrl : storyImageUrl // ignore: cast_nullable_to_non_nullable
as String?,imageGenerationError: freezed == imageGenerationError ? _self.imageGenerationError : imageGenerationError // ignore: cast_nullable_to_non_nullable
as String?,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<Story>,isLoadingHistory: null == isLoadingHistory ? _self.isLoadingHistory : isLoadingHistory // ignore: cast_nullable_to_non_nullable
as bool,hasMoreHistory: null == hasMoreHistory ? _self.hasMoreHistory : hasMoreHistory // ignore: cast_nullable_to_non_nullable
as bool,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,isListening: null == isListening ? _self.isListening : isListening // ignore: cast_nullable_to_non_nullable
as bool,partialVoiceResult: freezed == partialVoiceResult ? _self.partialVoiceResult : partialVoiceResult // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of StoryGeneratorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoryPromptCopyWith<$Res> get interactivePrompt {
  
  return $StoryPromptCopyWith<$Res>(_self.interactivePrompt, (value) {
    return _then(_self.copyWith(interactivePrompt: value));
  });
}/// Create a copy of StoryGeneratorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoryPromptCopyWith<$Res> get rawPrompt {
  
  return $StoryPromptCopyWith<$Res>(_self.rawPrompt, (value) {
    return _then(_self.copyWith(rawPrompt: value));
  });
}/// Create a copy of StoryGeneratorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeneratorOptionsCopyWith<$Res> get options {
  
  return $GeneratorOptionsCopyWith<$Res>(_self.options, (value) {
    return _then(_self.copyWith(options: value));
  });
}/// Create a copy of StoryGeneratorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoryCopyWith<$Res>? get generatedStory {
    if (_self.generatedStory == null) {
    return null;
  }

  return $StoryCopyWith<$Res>(_self.generatedStory!, (value) {
    return _then(_self.copyWith(generatedStory: value));
  });
}
}


/// Adds pattern-matching-related methods to [StoryGeneratorState].
extension StoryGeneratorStatePatterns on StoryGeneratorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoryGeneratorState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoryGeneratorState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoryGeneratorState value)  $default,){
final _that = this;
switch (_that) {
case _StoryGeneratorState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoryGeneratorState value)?  $default,){
final _that = this;
switch (_that) {
case _StoryGeneratorState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StoryPrompt interactivePrompt,  StoryPrompt rawPrompt,  bool isRawPromptMode,  GeneratorOptions options,  bool isLoadingOptions,  bool isGenerating,  String? generatingMessage,  Story? generatedStory,  String? errorMessage,  int currentQuickPromptIndex,  bool isGeneratingImage,  String? storyImageUrl,  String? imageGenerationError,  List<Story> history,  bool isLoadingHistory,  bool hasMoreHistory,  bool isOnline,  bool isListening,  String? partialVoiceResult)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoryGeneratorState() when $default != null:
return $default(_that.interactivePrompt,_that.rawPrompt,_that.isRawPromptMode,_that.options,_that.isLoadingOptions,_that.isGenerating,_that.generatingMessage,_that.generatedStory,_that.errorMessage,_that.currentQuickPromptIndex,_that.isGeneratingImage,_that.storyImageUrl,_that.imageGenerationError,_that.history,_that.isLoadingHistory,_that.hasMoreHistory,_that.isOnline,_that.isListening,_that.partialVoiceResult);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StoryPrompt interactivePrompt,  StoryPrompt rawPrompt,  bool isRawPromptMode,  GeneratorOptions options,  bool isLoadingOptions,  bool isGenerating,  String? generatingMessage,  Story? generatedStory,  String? errorMessage,  int currentQuickPromptIndex,  bool isGeneratingImage,  String? storyImageUrl,  String? imageGenerationError,  List<Story> history,  bool isLoadingHistory,  bool hasMoreHistory,  bool isOnline,  bool isListening,  String? partialVoiceResult)  $default,) {final _that = this;
switch (_that) {
case _StoryGeneratorState():
return $default(_that.interactivePrompt,_that.rawPrompt,_that.isRawPromptMode,_that.options,_that.isLoadingOptions,_that.isGenerating,_that.generatingMessage,_that.generatedStory,_that.errorMessage,_that.currentQuickPromptIndex,_that.isGeneratingImage,_that.storyImageUrl,_that.imageGenerationError,_that.history,_that.isLoadingHistory,_that.hasMoreHistory,_that.isOnline,_that.isListening,_that.partialVoiceResult);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StoryPrompt interactivePrompt,  StoryPrompt rawPrompt,  bool isRawPromptMode,  GeneratorOptions options,  bool isLoadingOptions,  bool isGenerating,  String? generatingMessage,  Story? generatedStory,  String? errorMessage,  int currentQuickPromptIndex,  bool isGeneratingImage,  String? storyImageUrl,  String? imageGenerationError,  List<Story> history,  bool isLoadingHistory,  bool hasMoreHistory,  bool isOnline,  bool isListening,  String? partialVoiceResult)?  $default,) {final _that = this;
switch (_that) {
case _StoryGeneratorState() when $default != null:
return $default(_that.interactivePrompt,_that.rawPrompt,_that.isRawPromptMode,_that.options,_that.isLoadingOptions,_that.isGenerating,_that.generatingMessage,_that.generatedStory,_that.errorMessage,_that.currentQuickPromptIndex,_that.isGeneratingImage,_that.storyImageUrl,_that.imageGenerationError,_that.history,_that.isLoadingHistory,_that.hasMoreHistory,_that.isOnline,_that.isListening,_that.partialVoiceResult);case _:
  return null;

}
}

}

/// @nodoc


class _StoryGeneratorState extends StoryGeneratorState {
  const _StoryGeneratorState({this.interactivePrompt = const StoryPrompt(), this.rawPrompt = const StoryPrompt(isRawPrompt: true), this.isRawPromptMode = false, this.options = const GeneratorOptions(), this.isLoadingOptions = false, this.isGenerating = false, this.generatingMessage, this.generatedStory, this.errorMessage, this.currentQuickPromptIndex = 0, this.isGeneratingImage = false, this.storyImageUrl, this.imageGenerationError, final  List<Story> history = const [], this.isLoadingHistory = false, this.hasMoreHistory = true, this.isOnline = true, this.isListening = false, this.partialVoiceResult}): _history = history,super._();
  

/// Interactive prompt configuration (used when isRawPrompt is false)
@override@JsonKey() final  StoryPrompt interactivePrompt;
/// Raw prompt configuration (used when isRawPrompt is true)
@override@JsonKey() final  StoryPrompt rawPrompt;
/// Whether the current mode is raw prompt
@override@JsonKey() final  bool isRawPromptMode;
/// Generator options (language, format, length)
@override@JsonKey() final  GeneratorOptions options;
/// Whether the generator is currently loading options
@override@JsonKey() final  bool isLoadingOptions;
/// Whether a story is being generated
@override@JsonKey() final  bool isGenerating;
/// Progress message during generation
@override final  String? generatingMessage;
/// The generated story (if any)
@override final  Story? generatedStory;
/// Error message (if any)
@override final  String? errorMessage;
/// Current quick prompt index in carousel
@override@JsonKey() final  int currentQuickPromptIndex;
/// Whether an image is being generated
@override@JsonKey() final  bool isGeneratingImage;
/// The generated story image URL
@override final  String? storyImageUrl;
/// Error message for image generation
@override final  String? imageGenerationError;
/// List of generated stories history
 final  List<Story> _history;
/// List of generated stories history
@override@JsonKey() List<Story> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}

/// Whether history is being loaded
@override@JsonKey() final  bool isLoadingHistory;
/// Whether there are more stories to load
@override@JsonKey() final  bool hasMoreHistory;
/// Whether device is currently online
@override@JsonKey() final  bool isOnline;
/// Whether the voice input is active
@override@JsonKey() final  bool isListening;
/// Partial text from voice input
@override final  String? partialVoiceResult;

/// Create a copy of StoryGeneratorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryGeneratorStateCopyWith<_StoryGeneratorState> get copyWith => __$StoryGeneratorStateCopyWithImpl<_StoryGeneratorState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoryGeneratorState&&(identical(other.interactivePrompt, interactivePrompt) || other.interactivePrompt == interactivePrompt)&&(identical(other.rawPrompt, rawPrompt) || other.rawPrompt == rawPrompt)&&(identical(other.isRawPromptMode, isRawPromptMode) || other.isRawPromptMode == isRawPromptMode)&&(identical(other.options, options) || other.options == options)&&(identical(other.isLoadingOptions, isLoadingOptions) || other.isLoadingOptions == isLoadingOptions)&&(identical(other.isGenerating, isGenerating) || other.isGenerating == isGenerating)&&(identical(other.generatingMessage, generatingMessage) || other.generatingMessage == generatingMessage)&&(identical(other.generatedStory, generatedStory) || other.generatedStory == generatedStory)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.currentQuickPromptIndex, currentQuickPromptIndex) || other.currentQuickPromptIndex == currentQuickPromptIndex)&&(identical(other.isGeneratingImage, isGeneratingImage) || other.isGeneratingImage == isGeneratingImage)&&(identical(other.storyImageUrl, storyImageUrl) || other.storyImageUrl == storyImageUrl)&&(identical(other.imageGenerationError, imageGenerationError) || other.imageGenerationError == imageGenerationError)&&const DeepCollectionEquality().equals(other._history, _history)&&(identical(other.isLoadingHistory, isLoadingHistory) || other.isLoadingHistory == isLoadingHistory)&&(identical(other.hasMoreHistory, hasMoreHistory) || other.hasMoreHistory == hasMoreHistory)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.isListening, isListening) || other.isListening == isListening)&&(identical(other.partialVoiceResult, partialVoiceResult) || other.partialVoiceResult == partialVoiceResult));
}


@override
int get hashCode => Object.hashAll([runtimeType,interactivePrompt,rawPrompt,isRawPromptMode,options,isLoadingOptions,isGenerating,generatingMessage,generatedStory,errorMessage,currentQuickPromptIndex,isGeneratingImage,storyImageUrl,imageGenerationError,const DeepCollectionEquality().hash(_history),isLoadingHistory,hasMoreHistory,isOnline,isListening,partialVoiceResult]);

@override
String toString() {
  return 'StoryGeneratorState(interactivePrompt: $interactivePrompt, rawPrompt: $rawPrompt, isRawPromptMode: $isRawPromptMode, options: $options, isLoadingOptions: $isLoadingOptions, isGenerating: $isGenerating, generatingMessage: $generatingMessage, generatedStory: $generatedStory, errorMessage: $errorMessage, currentQuickPromptIndex: $currentQuickPromptIndex, isGeneratingImage: $isGeneratingImage, storyImageUrl: $storyImageUrl, imageGenerationError: $imageGenerationError, history: $history, isLoadingHistory: $isLoadingHistory, hasMoreHistory: $hasMoreHistory, isOnline: $isOnline, isListening: $isListening, partialVoiceResult: $partialVoiceResult)';
}


}

/// @nodoc
abstract mixin class _$StoryGeneratorStateCopyWith<$Res> implements $StoryGeneratorStateCopyWith<$Res> {
  factory _$StoryGeneratorStateCopyWith(_StoryGeneratorState value, $Res Function(_StoryGeneratorState) _then) = __$StoryGeneratorStateCopyWithImpl;
@override @useResult
$Res call({
 StoryPrompt interactivePrompt, StoryPrompt rawPrompt, bool isRawPromptMode, GeneratorOptions options, bool isLoadingOptions, bool isGenerating, String? generatingMessage, Story? generatedStory, String? errorMessage, int currentQuickPromptIndex, bool isGeneratingImage, String? storyImageUrl, String? imageGenerationError, List<Story> history, bool isLoadingHistory, bool hasMoreHistory, bool isOnline, bool isListening, String? partialVoiceResult
});


@override $StoryPromptCopyWith<$Res> get interactivePrompt;@override $StoryPromptCopyWith<$Res> get rawPrompt;@override $GeneratorOptionsCopyWith<$Res> get options;@override $StoryCopyWith<$Res>? get generatedStory;

}
/// @nodoc
class __$StoryGeneratorStateCopyWithImpl<$Res>
    implements _$StoryGeneratorStateCopyWith<$Res> {
  __$StoryGeneratorStateCopyWithImpl(this._self, this._then);

  final _StoryGeneratorState _self;
  final $Res Function(_StoryGeneratorState) _then;

/// Create a copy of StoryGeneratorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? interactivePrompt = null,Object? rawPrompt = null,Object? isRawPromptMode = null,Object? options = null,Object? isLoadingOptions = null,Object? isGenerating = null,Object? generatingMessage = freezed,Object? generatedStory = freezed,Object? errorMessage = freezed,Object? currentQuickPromptIndex = null,Object? isGeneratingImage = null,Object? storyImageUrl = freezed,Object? imageGenerationError = freezed,Object? history = null,Object? isLoadingHistory = null,Object? hasMoreHistory = null,Object? isOnline = null,Object? isListening = null,Object? partialVoiceResult = freezed,}) {
  return _then(_StoryGeneratorState(
interactivePrompt: null == interactivePrompt ? _self.interactivePrompt : interactivePrompt // ignore: cast_nullable_to_non_nullable
as StoryPrompt,rawPrompt: null == rawPrompt ? _self.rawPrompt : rawPrompt // ignore: cast_nullable_to_non_nullable
as StoryPrompt,isRawPromptMode: null == isRawPromptMode ? _self.isRawPromptMode : isRawPromptMode // ignore: cast_nullable_to_non_nullable
as bool,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as GeneratorOptions,isLoadingOptions: null == isLoadingOptions ? _self.isLoadingOptions : isLoadingOptions // ignore: cast_nullable_to_non_nullable
as bool,isGenerating: null == isGenerating ? _self.isGenerating : isGenerating // ignore: cast_nullable_to_non_nullable
as bool,generatingMessage: freezed == generatingMessage ? _self.generatingMessage : generatingMessage // ignore: cast_nullable_to_non_nullable
as String?,generatedStory: freezed == generatedStory ? _self.generatedStory : generatedStory // ignore: cast_nullable_to_non_nullable
as Story?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,currentQuickPromptIndex: null == currentQuickPromptIndex ? _self.currentQuickPromptIndex : currentQuickPromptIndex // ignore: cast_nullable_to_non_nullable
as int,isGeneratingImage: null == isGeneratingImage ? _self.isGeneratingImage : isGeneratingImage // ignore: cast_nullable_to_non_nullable
as bool,storyImageUrl: freezed == storyImageUrl ? _self.storyImageUrl : storyImageUrl // ignore: cast_nullable_to_non_nullable
as String?,imageGenerationError: freezed == imageGenerationError ? _self.imageGenerationError : imageGenerationError // ignore: cast_nullable_to_non_nullable
as String?,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<Story>,isLoadingHistory: null == isLoadingHistory ? _self.isLoadingHistory : isLoadingHistory // ignore: cast_nullable_to_non_nullable
as bool,hasMoreHistory: null == hasMoreHistory ? _self.hasMoreHistory : hasMoreHistory // ignore: cast_nullable_to_non_nullable
as bool,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,isListening: null == isListening ? _self.isListening : isListening // ignore: cast_nullable_to_non_nullable
as bool,partialVoiceResult: freezed == partialVoiceResult ? _self.partialVoiceResult : partialVoiceResult // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of StoryGeneratorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoryPromptCopyWith<$Res> get interactivePrompt {
  
  return $StoryPromptCopyWith<$Res>(_self.interactivePrompt, (value) {
    return _then(_self.copyWith(interactivePrompt: value));
  });
}/// Create a copy of StoryGeneratorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoryPromptCopyWith<$Res> get rawPrompt {
  
  return $StoryPromptCopyWith<$Res>(_self.rawPrompt, (value) {
    return _then(_self.copyWith(rawPrompt: value));
  });
}/// Create a copy of StoryGeneratorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeneratorOptionsCopyWith<$Res> get options {
  
  return $GeneratorOptionsCopyWith<$Res>(_self.options, (value) {
    return _then(_self.copyWith(options: value));
  });
}/// Create a copy of StoryGeneratorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoryCopyWith<$Res>? get generatedStory {
    if (_self.generatedStory == null) {
    return null;
  }

  return $StoryCopyWith<$Res>(_self.generatedStory!, (value) {
    return _then(_self.copyWith(generatedStory: value));
  });
}
}

// dart format on
