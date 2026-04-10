import 'package:flutter_test/flutter_test.dart';
import 'package:myitihas/features/story_generator/data/datasources/mock_story_generator_datasource.dart';
import 'package:myitihas/features/story_generator/domain/entities/quick_prompt.dart';
import 'package:myitihas/features/story_generator/domain/entities/story_prompt.dart';

void main() {
  group('MockStoryGeneratorDataSource.getRandomOptions', () {
    test('returns only combinations from QuickPrompt.defaultPrompts', () async {
      final dataSource = MockStoryGeneratorDataSource();

      final presetKeys = QuickPrompt.defaultPrompts
          .map((prompt) => prompt.presetOptions)
          .map(
            (options) =>
                '${options.scripture}|${options.storyType}|${options.theme}|${options.mainCharacter}|${options.setting}',
          )
          .toSet();

      for (var i = 0; i < 12; i++) {
        final prompt = await dataSource.getRandomOptions();
        final key =
            '${prompt.scripture}|${prompt.storyType}|${prompt.theme}|${prompt.mainCharacter}|${prompt.setting}';
        expect(presetKeys.contains(key), isTrue);
      }
    });

    test('returns complete prompt fields', () async {
      final dataSource = MockStoryGeneratorDataSource();

      for (var i = 0; i < 8; i++) {
        final prompt = await dataSource.getRandomOptions();
        expect(prompt.scripture, isNotNull);
        expect(prompt.storyType, isNotNull);
        expect(prompt.theme, isNotNull);
        expect(prompt.mainCharacter, isNotNull);
        expect(prompt.setting, isNotNull);
      }
    });

    test('avoids immediate repeats when more than one preset exists', () async {
      final dataSource = MockStoryGeneratorDataSource();
      StoryPrompt? previous;

      for (var i = 0; i < 10; i++) {
        final prompt = await dataSource.getRandomOptions();
        if (previous != null) {
          final previousKey =
              '${previous.scripture}|${previous.storyType}|${previous.theme}|${previous.mainCharacter}|${previous.setting}';
          final currentKey =
              '${prompt.scripture}|${prompt.storyType}|${prompt.theme}|${prompt.mainCharacter}|${prompt.setting}';
          expect(currentKey, isNot(equals(previousKey)));
        }
        previous = prompt;
      }
    });
  });
}
