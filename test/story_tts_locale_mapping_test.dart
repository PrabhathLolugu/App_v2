import 'package:flutter_test/flutter_test.dart';
import 'package:myitihas/core/utils/language_voice_resolver.dart';

void main() {
  group('LanguageVoiceResolver.cloudLocaleForAny', () {
    test('maps language code to cloud locale', () {
      expect(LanguageVoiceResolver.cloudLocaleForAny('hi'), 'hi-IN');
      expect(LanguageVoiceResolver.cloudLocaleForAny('hi-IN'), 'hi-IN');
      expect(LanguageVoiceResolver.cloudLocaleForAny('ur-pk'), 'ur-IN');
      expect(LanguageVoiceResolver.cloudLocaleForAny('sa'), 'en-IN');
      expect(LanguageVoiceResolver.cloudLocaleForAny('unknown'), 'en-IN');
    });
  });
}
