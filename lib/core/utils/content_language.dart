import 'package:shared_preferences/shared_preferences.dart';
import 'package:myitihas/features/story_generator/domain/entities/generator_options.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/core/utils/locale_mapper.dart';

/// Central helper for managing the app-wide content language preference.
///
/// This controls the language used for:
/// - Story generation
/// - Story-related chats (ChatItihas)
/// - Little Krishna chat
///
/// The preference is stored as the `StoryLanguage.code` (e.g. `en`, `hi`, `ta`).
class ContentLanguageSettings {
  static const String _prefsKey = 'content_language_code';

  /// Returns the currently selected content language.
  ///
  /// If no explicit preference has been saved, this falls back to a sensible
  /// default based on the current UI locale:
  /// - AppLocale.hi -> StoryLanguage.hindi
  /// - AppLocale.en (and any others) -> StoryLanguage.english
  static Future<StoryLanguage> getCurrentLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(_prefsKey);

    if (savedCode != null && savedCode.isNotEmpty) {
      final match = StoryLanguage.values.firstWhere(
        (lang) => lang.code == savedCode,
        orElse: () => _defaultForCurrentLocale(),
      );
      return match;
    }

    return _defaultForCurrentLocale();
  }

  /// Persists the given content language as the global preference.
  static Future<void> setCurrentLanguage(StoryLanguage language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, language.code);
  }

  /// Maps the saved [StoryLanguage] to the human-readable language string
  /// expected by the Supabase Edge prompts (e.g. "Hindi", "Tamil").
  ///
  /// This uses [StoryLanguage.displayName] so the mapping is kept in one place.
  static Future<String> getPromptLanguageName() async {
    final lang = await getCurrentLanguage();
    // For English we still want the explicit keyword the prompt templates expect.
    return lang.displayName;
  }

  static StoryLanguage _defaultForCurrentLocale() {
    final appLocale = LocaleSettings.currentLocale;
    return storyLanguageFromAppLocale(appLocale);
  }
}

