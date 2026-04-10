import 'package:myitihas/features/story_generator/domain/entities/generator_options.dart';
import 'package:myitihas/i18n/strings.g.dart';

/// Maps the app's current locale to the story generator language.
/// When the user has selected a language in app settings, story generation
/// defaults to that language. Users can still override via "More Options".
StoryLanguage storyLanguageFromAppLocale(AppLocale locale) {
  switch (locale) {
    case AppLocale.en:
      return StoryLanguage.english;
    case AppLocale.hi:
      return StoryLanguage.hindi;
    case AppLocale.ta:
      return StoryLanguage.tamil;
    case AppLocale.te:
      return StoryLanguage.telugu;
    case AppLocale.bn:
      return StoryLanguage.bengali;
    case AppLocale.mr:
      return StoryLanguage.marathi;
    case AppLocale.gu:
      return StoryLanguage.gujarati;
    case AppLocale.kn:
      return StoryLanguage.kannada;
    case AppLocale.ml:
      return StoryLanguage.malayalam;
    case AppLocale.pa:
      return StoryLanguage.punjabi;
    case AppLocale.or:
      return StoryLanguage.odia;
    case AppLocale.ur:
      return StoryLanguage.urdu;
    case AppLocale.sa:
      return StoryLanguage.sanskrit;
    case AppLocale.as:
      return StoryLanguage.assamese;
  }
}
