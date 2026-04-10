import 'package:flutter_test/flutter_test.dart';
import 'package:myitihas/features/stories/domain/entities/story_options.dart';
import 'package:myitihas/features/story_generator/domain/entities/quick_prompt.dart';

void main() {
  group('QuickPrompt.defaultPrompts', () {
    test('contains exactly 150 deterministic presets', () {
      final prompts = QuickPrompt.defaultPrompts;
      expect(prompts.length, 150);

      final secondRead = QuickPrompt.defaultPrompts;
      expect(secondRead.length, 150);
      expect(
        secondRead.map((p) => p.id).toList(),
        equals(prompts.map((p) => p.id).toList()),
      );
    });

    test('keeps original curated presets at the top in order', () {
      final prompts = QuickPrompt.defaultPrompts;
      final expectedPrefix = [
        'warrior_quest',
        'krishna_wisdom',
        'sage_journey',
        'rama_devotion',
        'animal_wisdom',
        'divine_legend',
        'arjuna_dharma',
        'gita_on_field',
        'bheeshma_oath',
        'warrior_inner_shift',
        'forest_devotion',
        'hanuman_valor',
        'sita_resolve',
        'rama_duty_path',
        'narada_lessons',
        'prahlada_faith',
        'divine_play_forest',
        'upanishad_dialogue',
        'self_inquiry_ashram',
        'panchatantra_court',
        'forest_trickster',
        'cosmic_order',
        'rishi_of_cosmos',
      ];

      final actualPrefix = prompts
          .take(expectedPrefix.length)
          .map((prompt) => prompt.id)
          .toList();
      expect(actualPrefix, equals(expectedPrefix));
    });

    test('contains only complete and canonical combinations', () {
      final prompts = QuickPrompt.defaultPrompts;

      final storyTypes = (storyOptions['storyType']?['types'] as List<dynamic>)
          .map((e) => e.toString())
          .toSet();
      final themes = (storyOptions['theme']?['types'] as List<dynamic>)
          .map((e) => e.toString())
          .toSet();
      final mainCharacters =
          (storyOptions['mainCharacter']?['types'] as List<dynamic>)
              .map((e) => e.toString())
              .toSet();
      final settings = (storyOptions['setting']?['types'] as List<dynamic>)
          .map((e) => e.toString())
          .toSet();

      final scriptureMap = storyOptions['scripture']?['subtypes']
          as Map<String, dynamic>;
      final scriptures = scriptureMap.values
          .expand((list) => (list as List<dynamic>).map((e) => e.toString()))
          .toSet();

      for (final prompt in prompts) {
        final options = prompt.presetOptions;
        expect(options.scripture, isNotNull);
        expect(options.storyType, isNotNull);
        expect(options.theme, isNotNull);
        expect(options.mainCharacter, isNotNull);
        expect(options.setting, isNotNull);

        expect(scriptures.contains(options.scripture), isTrue);
        expect(storyTypes.contains(options.storyType), isTrue);
        expect(themes.contains(options.theme), isTrue);
        expect(mainCharacters.contains(options.mainCharacter), isTrue);
        expect(settings.contains(options.setting), isTrue);
      }
    });

    test('has no duplicate ids and unique generated combinations', () {
      final prompts = QuickPrompt.defaultPrompts;

      final ids = prompts.map((p) => p.id).toList();
      expect(ids.toSet().length, ids.length);

      const curatedCount = 23;
      final generatedPrompts = prompts.skip(curatedCount).toList();
      for (final prompt in generatedPrompts) {
        expect(prompt.id.startsWith('canonical_'), isTrue);
      }

      final keys = generatedPrompts
          .map(
            (p) => '${p.presetOptions.scripture}|${p.presetOptions.storyType}|'
                '${p.presetOptions.theme}|${p.presetOptions.mainCharacter}|'
                '${p.presetOptions.setting}',
          )
          .toList();
      expect(keys.toSet().length, keys.length);
    });

    test('generated presets use curated-style card copy', () {
      final prompts = QuickPrompt.defaultPrompts;
      const curatedCount = 23;
      final generatedPrompts = prompts.skip(curatedCount);

      for (final prompt in generatedPrompts) {
        expect(prompt.title.trim().isNotEmpty, isTrue);
        expect(prompt.subtitle.trim().isNotEmpty, isTrue);
        expect(prompt.title.startsWith('Story '), isFalse);
        expect(prompt.subtitle.contains('·'), isTrue);
      }
    });

    test('covers all canonical scripture values at least once', () {
      final prompts = QuickPrompt.defaultPrompts;
      final promptScriptures =
          prompts.map((p) => p.presetOptions.scripture).whereType<String>().toSet();

      final scriptureMap = storyOptions['scripture']?['subtypes']
          as Map<String, dynamic>;
      final canonicalScriptures = scriptureMap.values
          .expand((list) => (list as List<dynamic>).map((e) => e.toString()))
          .toSet();

      for (final scripture in canonicalScriptures) {
        expect(promptScriptures.contains(scripture), isTrue,
            reason: 'Missing scripture in presets: $scripture');
      }
    });
  });
}
