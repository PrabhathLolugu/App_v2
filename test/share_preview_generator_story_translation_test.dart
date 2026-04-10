import 'package:flutter_test/flutter_test.dart';
import 'package:myitihas/features/social/presentation/utils/share_preview_generator.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/features/story_generator/domain/entities/story_translation.dart';

Story _buildStory({Map<String, TranslatedStory> translations = const {}}) {
  return Story(
    id: 'story-id',
    title: 'মূল গল্প',
    scripture: 'Valmiki Ramayana',
    story: 'এটি একটি মূল বাংলা গল্প।',
    quotes: 'মূল উক্তি',
    trivia: '',
    activity: '',
    lesson: 'মূল নৈতিক শিক্ষা',
    attributes: StoryAttributes(
      storyType: 'mythology',
      theme: 'dharma',
      mainCharacterType: 'hero',
      storySetting: 'ancient',
      timeEra: 'vedic',
      narrativePerspective: 'third-person',
      languageStyle: 'Bengali',
      emotionalTone: 'inspiring',
      narrativeStyle: 'descriptive',
      plotStructure: 'linear',
      storyLength: 'medium',
      translations: translations,
    ),
  );
}

void main() {
  test('resolveStoryForLanguage returns translated fields when available', () {
    final story = _buildStory(
      translations: const {
        'en': TranslatedStory(
          title: 'Translated Title',
          story: 'Translated story content.',
          moral: 'Translated moral.',
          lang: 'en',
        ),
      },
    );

    final resolved = SharePreviewGenerator.resolveStoryForLanguage(
      story,
      'English',
    );

    expect(resolved.title, 'Translated Title');
    expect(resolved.story, 'Translated story content.');
    expect(resolved.lesson, 'Translated moral.');
  });

  test(
    'resolveStoryForLanguage falls back to original when translation missing',
    () {
      final story = _buildStory();

      final resolved = SharePreviewGenerator.resolveStoryForLanguage(
        story,
        'English',
      );

      expect(resolved.title, story.title);
      expect(resolved.story, story.story);
      expect(resolved.lesson, story.lesson);
    },
  );

  test(
    'resolveStoryForLanguage falls back field-wise when translation fields are empty',
    () {
      final story = _buildStory(
        translations: const {
          'en': TranslatedStory(
            title: '',
            story: 'Translated story content.',
            moral: '',
            lang: 'en',
          ),
        },
      );

      final resolved = SharePreviewGenerator.resolveStoryForLanguage(
        story,
        'English',
      );

      expect(resolved.title, story.title);
      expect(resolved.story, 'Translated story content.');
      expect(resolved.lesson, story.lesson);
    },
  );
}
