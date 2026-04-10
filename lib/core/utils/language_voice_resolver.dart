import 'package:myitihas/features/story_generator/domain/entities/generator_options.dart';

/// Canonical language + TTS locale resolver used by story translation and audio.
class LanguageVoiceResolver {
  static const String defaultLanguageCode = 'en';
  static const String defaultCloudLocale = 'en-IN';

  static const Map<String, String> _languageCodeToDisplayName = {
    'en': 'English',
    'hi': 'Hindi',
    'ta': 'Tamil',
    'te': 'Telugu',
    'bn': 'Bengali',
    'mr': 'Marathi',
    'gu': 'Gujarati',
    'kn': 'Kannada',
    'ml': 'Malayalam',
    'pa': 'Punjabi',
    'or': 'Odia',
    'ur': 'Urdu',
    'sa': 'Sanskrit',
    'as': 'Assamese',
  };

  static const Map<String, String> _languageCodeToCloudLocale = {
    'en': 'en-IN',
    'hi': 'hi-IN',
    'ta': 'ta-IN',
    'te': 'te-IN',
    'bn': 'bn-IN',
    'mr': 'mr-IN',
    'gu': 'gu-IN',
    'kn': 'kn-IN',
    'ml': 'ml-IN',
    'pa': 'pa-IN',
    'or': 'or-IN',
    'ur': 'ur-IN',
    // No stable Sanskrit voice in Edge TTS; use Indian English fallback.
    'sa': 'en-IN',
    'as': 'as-IN',
  };

  static const Map<String, String> _aliasToLanguageCode = {
    'english': 'en',
    'en': 'en',
    'en-in': 'en',
    'en-us': 'en',
    'hindi': 'hi',
    'hi': 'hi',
    'hi-in': 'hi',
    'tamil': 'ta',
    'ta': 'ta',
    'ta-in': 'ta',
    'telugu': 'te',
    'te': 'te',
    'te-in': 'te',
    'bengali': 'bn',
    'bn': 'bn',
    'bn-in': 'bn',
    'marathi': 'mr',
    'mr': 'mr',
    'mr-in': 'mr',
    'gujarati': 'gu',
    'gu': 'gu',
    'gu-in': 'gu',
    'kannada': 'kn',
    'kn': 'kn',
    'kn-in': 'kn',
    'malayalam': 'ml',
    'ml': 'ml',
    'ml-in': 'ml',
    'punjabi': 'pa',
    'pa': 'pa',
    'pa-in': 'pa',
    'odia': 'or',
    'oriya': 'or',
    'or': 'or',
    'or-in': 'or',
    'urdu': 'ur',
    'ur': 'ur',
    'ur-in': 'ur',
    'ur-pk': 'ur',
    'sanskrit': 'sa',
    'sa': 'sa',
    'assamese': 'as',
    'as': 'as',
    'as-in': 'as',
  };

  static String normalizeLanguageCode(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized.isEmpty) return defaultLanguageCode;

    final direct = _aliasToLanguageCode[normalized];
    if (direct != null) return direct;

    if (normalized.contains('-')) {
      final head = normalized.split('-').first;
      final headDirect = _aliasToLanguageCode[head];
      if (headDirect != null) return headDirect;
    }

    final tokens = normalized
        .split(RegExp(r'[^a-z]+'))
        .map((token) => token.trim())
        .where((token) => token.isNotEmpty);
    for (final token in tokens) {
      final mapped = _aliasToLanguageCode[token];
      if (mapped != null) {
        return mapped;
      }
    }
    return defaultLanguageCode;
  }

  static String languageCodeFromAny(String value) {
    return normalizeLanguageCode(value);
  }

  static String displayNameForCode(String code) {
    final normalized = normalizeLanguageCode(code);
    return _languageCodeToDisplayName[normalized] ??
        _languageCodeToDisplayName[defaultLanguageCode]!;
  }

  static String cloudLocaleForAny(String value) {
    final code = normalizeLanguageCode(value);
    return _languageCodeToCloudLocale[code] ?? defaultCloudLocale;
  }

  static List<String> deviceLocaleFallbackChainForAny(String value) {
    final code = normalizeLanguageCode(value);
    final primary = _languageCodeToCloudLocale[code] ?? defaultCloudLocale;
    final shared = <String>[
      primary,
      '$code-${primary.split('-').last}',
      code,
      defaultCloudLocale,
      'en-US',
      'en-GB',
      'en',
    ];
    return _dedupe(shared);
  }

  static List<String> _dedupe(List<String> values) {
    final seen = <String>{};
    final result = <String>[];
    for (final value in values) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) continue;
      if (seen.add(trimmed.toLowerCase())) {
        result.add(trimmed);
      }
    }
    return result;
  }

  static String codeFromStoryLanguage(StoryLanguage language) => language.code;
}
