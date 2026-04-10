import 'package:freezed_annotation/freezed_annotation.dart';

part 'generator_options.freezed.dart';

/// Available languages for story generation
enum StoryLanguage {
  english('English', 'en'),
  hindi('Hindi', 'hi'),
  tamil('Tamil', 'ta'),
  telugu('Telugu', 'te'),
  bengali('Bengali', 'bn'),
  marathi('Marathi', 'mr'),
  gujarati('Gujarati', 'gu'),
  kannada('Kannada', 'kn'),
  malayalam('Malayalam', 'ml'),
  punjabi('Punjabi', 'pa'),
  odia('Odia', 'or'),
  urdu('Urdu', 'ur'),
  sanskrit('Sanskrit', 'sa'),
  assamese('Assamese', 'as');

  final String displayName;
  final String code;
  const StoryLanguage(this.displayName, this.code);
}

/// Story format options
enum StoryFormat {
  narrative('Narrative', 'A flowing narrative story'),
  dialogue('Dialogue-based', 'Story told through conversations'),
  poetic('Poetic', 'Written in a poetic style'),
  scriptural('Scriptural', 'Traditional scripture-like format');

  final String displayName;
  final String description;
  const StoryFormat(this.displayName, this.description);
}

/// Story length options
enum StoryLength {
  short('Short', '~500 words', 500),
  medium('Medium', '~1000 words', 1000),
  long('Long', '~2000 words', 2000),
  epic('Epic', '~3000+ words', 3000);

  final String displayName;
  final String description;
  final int approximateWords;
  const StoryLength(this.displayName, this.description, this.approximateWords);
}

/// Additional options for story generation
@freezed
abstract class GeneratorOptions with _$GeneratorOptions {
  const factory GeneratorOptions({
    @Default(StoryLanguage.english) StoryLanguage language,
    @Default(StoryFormat.narrative) StoryFormat format,
    @Default(StoryLength.medium) StoryLength length,
  }) = _GeneratorOptions;

  const GeneratorOptions._();
}
