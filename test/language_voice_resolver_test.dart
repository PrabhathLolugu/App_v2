import 'package:flutter_test/flutter_test.dart';
import 'package:myitihas/core/utils/language_voice_resolver.dart';

void main() {
  group('LanguageVoiceResolver', () {
    test('normalizes language names, codes, and locales', () {
      expect(LanguageVoiceResolver.languageCodeFromAny('Hindi'), 'hi');
      expect(LanguageVoiceResolver.languageCodeFromAny('hi'), 'hi');
      expect(LanguageVoiceResolver.languageCodeFromAny('hi-IN'), 'hi');
      expect(LanguageVoiceResolver.languageCodeFromAny('UR-PK'), 'ur');
      expect(LanguageVoiceResolver.languageCodeFromAny('Odia'), 'or');
      expect(LanguageVoiceResolver.languageCodeFromAny('unknown'), 'en');
    });

    test('returns cloud locale for all app languages', () {
      const codes = [
        'en',
        'hi',
        'ta',
        'te',
        'bn',
        'mr',
        'gu',
        'kn',
        'ml',
        'pa',
        'or',
        'ur',
        'sa',
        'as',
      ];

      for (final code in codes) {
        final locale = LanguageVoiceResolver.cloudLocaleForAny(code);
        expect(locale, contains('-'));
      }
      expect(LanguageVoiceResolver.cloudLocaleForAny('sa'), 'en-IN');
    });

    test('provides stable device fallback chain', () {
      final chain = LanguageVoiceResolver.deviceLocaleFallbackChainForAny('as');
      expect(chain.first, 'as-IN');
      expect(chain, contains('en-IN'));
      expect(chain, contains('en-US'));
      expect(chain.toSet().length, chain.length);
    });
  });
}
