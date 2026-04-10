import 'dart:math';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/features/stories/domain/entities/story_options.dart';
import 'package:myitihas/features/story_generator/domain/entities/quick_prompt.dart';
import 'package:myitihas/features/story_generator/domain/entities/story_prompt.dart';
import 'package:myitihas/features/story_generator/domain/entities/generator_options.dart';

/// Mock data source for story generation
/// This simulates API calls with realistic delays
class MockStoryGeneratorDataSource {
  final Random _random = Random();
  int? _lastRandomPresetIndex;

  /// Simulates story generation with a delay
  Future<Story> generateStory({
    required StoryPrompt prompt,
    required GeneratorOptions options,
  }) async {
    // Simulate network delay (2-4 seconds)
    await Future.delayed(Duration(milliseconds: 2000 + _random.nextInt(2000)));

    final storyId = 'generated_${DateTime.now().millisecondsSinceEpoch}';
    final scripture = prompt.scripture ?? 'Mahabharata';
    final storyType = prompt.storyType ?? 'Epic Adventure';
    final theme = prompt.theme ?? 'Dharma (Duty)';
    final mainCharacter = prompt.mainCharacter ?? 'Warrior/Kshatriya';
    final setting = prompt.setting ?? 'Ancient Kingdom';

    // Generate mock story content based on options
    final storyContent = _generateMockStoryContent(
      scripture: scripture,
      storyType: storyType,
      theme: theme,
      mainCharacter: mainCharacter,
      setting: setting,
      length: options.length,
      rawPrompt: prompt.rawPrompt,
    );

    return Story(
      id: storyId,
      title: storyContent['title']!,
      scripture: scripture,
      story: storyContent['story']!,
      quotes: storyContent['quote']!,
      trivia: storyContent['trivia']!,
      activity: storyContent['activity']!,
      lesson: storyContent['lesson']!,
      attributes: StoryAttributes(
        storyType: storyType,
        theme: theme,
        mainCharacterType: mainCharacter,
        storySetting: setting,
        timeEra: 'Ancient Era',
        narrativePerspective: 'Third Person',
        languageStyle: options.language.displayName,
        emotionalTone: 'Inspiring',
        narrativeStyle: options.format.displayName,
        plotStructure: 'Traditional',
        storyLength: options.length.displayName,
        tags: [scripture, storyType, theme],
      ),
      publishedAt: DateTime.now(),
      author: 'AI Story Generator',
    );
  }

  /// Get random story options
  Future<StoryPrompt> getRandomOptions() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final presets = QuickPrompt.defaultPrompts;
    if (presets.isEmpty) {
      throw StateError('No quick prompt presets available for randomization.');
    }

    var index = _random.nextInt(presets.length);
    if (presets.length > 1 && _lastRandomPresetIndex != null && index == _lastRandomPresetIndex) {
      index = (index + 1) % presets.length;
    }

    _lastRandomPresetIndex = index;
    return presets[index].presetOptions;
  }

  Map<String, String> _generateMockStoryContent({
    required String scripture,
    required String storyType,
    required String theme,
    required String mainCharacter,
    required String setting,
    required StoryLength length,
    String? rawPrompt,
  }) {
    // Generate contextual mock content based on the options
    final titles = _getTitles(scripture, theme, mainCharacter);
    final title = titles[_random.nextInt(titles.length)];

    final story = _getMockStory(
      scripture: scripture,
      theme: theme,
      mainCharacter: mainCharacter,
      setting: setting,
      length: length,
    );

    final quotes = _getQuotes(theme);
    final trivia = _getTrivia(scripture);
    final activity = _getActivity(theme);
    final lesson = _getLesson(theme);

    return {
      'title': title,
      'story': story,
      'quote': quotes,
      'trivia': trivia,
      'activity': activity,
      'lesson': lesson,
    };
  }

  List<String> _getTitles(String scripture, String theme, String character) {
    return [
      'The Path of $theme',
      'When $character Met Destiny',
      'Echoes of $scripture',
      'The Sacred Journey',
      'Wisdom of the Ages',
      'The Eternal Truth',
      'Beyond the Mortal Realm',
      'The Divine Revelation',
    ];
  }

  String _getMockStory({
    required String scripture,
    required String theme,
    required String mainCharacter,
    required String setting,
    required StoryLength length,
  }) {
    final baseStory =
        '''
In the ancient land where gods walked among mortals, there lived a $mainCharacter whose destiny was intertwined with the very fabric of dharma.

The story begins in the $setting, where the air itself seemed to pulse with divine energy. Our protagonist had spent years in contemplation, seeking the eternal truths that lay hidden in the sacred texts of the $scripture.

One fateful day, as the sun painted the sky in hues of saffron and gold, a celestial messenger appeared before them. "The time has come," spoke the divine being, "for you to understand the true meaning of $theme."

And so began a journey that would transform not just one soul, but echo through the ages, teaching generations to come about the sacred principles that bind the universe together.

Through trials of fire and water, through moments of doubt and revelation, our hero discovered that true wisdom lies not in the destination, but in the journey itself. The teachings of the ancient sages became clear: every action, every thought, every breath is an offering to the divine.

The $setting became a crucible of transformation, where the old self was burned away, and from the ashes arose a being of pure purpose and unwavering devotion.

As the story reached its crescendo, the $mainCharacter stood at the threshold of enlightenment, understanding at last that $theme was not merely a concept to be studied, but a living truth to be embodied.

And thus, the tale passed into legend, carried by the winds across the sacred rivers, whispered in the halls of temples, and etched into the hearts of all who heard it.

For in this story, as in all great tales of the $scripture, lies a mirror in which we see ourselves, our struggles, and our potential for greatness.

The end is but a new beginning, and the cycle continues, eternal and ever-renewing, like the cosmic dance of creation itself.
''';

    // Adjust length based on option
    switch (length) {
      case StoryLength.short:
        return baseStory.substring(0, (baseStory.length * 0.4).toInt());
      case StoryLength.medium:
        return baseStory.substring(0, (baseStory.length * 0.7).toInt());
      case StoryLength.long:
        return baseStory;
      case StoryLength.epic:
        return '$baseStory\n\n${baseStory.replaceAll('our hero', 'the seeker').replaceAll('Our protagonist', 'The awakened one')}';
    }
  }

  String _getQuotes(String theme) {
    final quotes = {
      'Dharma (Duty)':
          '"It is better to perform one\'s own duty imperfectly than to master the duty of another." - Bhagavad Gita',
      'Karma (Action)':
          '"You have the right to work, but never to the fruit of work." - Bhagavad Gita',
      'Bhakti (Devotion)':
          '"Whatever you do, whatever you eat, whatever you offer or give away, do it as an offering to Me." - Bhagavad Gita',
      'Moksha (Liberation)':
          '"The soul is neither born, and nor does it die." - Bhagavad Gita',
      'Knowledge & Wisdom':
          '"There is no purifier equal to knowledge in this world." - Bhagavad Gita',
    };
    return quotes[theme] ??
        '"Truth alone triumphs, not falsehood." - Mundaka Upanishad';
  }

  String _getTrivia(String scripture) {
    final trivia = {
      'Mahabharata':
          'The Mahabharata is one of the longest epic poems in the world, with over 100,000 shlokas (couplets).',
      'Ramayana':
          'The Ramayana was composed by Sage Valmiki, who is often called the "Adi Kavi" (first poet).',
      'Bhāgavata Purāṇa':
          'The Bhagavata Purana contains 18,000 verses and is considered the most popular of all Puranas.',
      'Upanishads':
          'The Upanishads are the philosophical core of the Vedas and form the basis of Vedanta philosophy.',
    };
    return trivia[scripture] ??
        'Ancient Indian scriptures were passed down orally for thousands of years before being written.';
  }

  String _getActivity(String theme) {
    return 'Reflect on how the theme of "$theme" manifests in your daily life. Journal about one instance where you practiced or witnessed this principle today.';
  }

  String _getLesson(String theme) {
    final lessons = {
      'Dharma (Duty)':
          'Understanding and fulfilling our duties without attachment to results leads to inner peace and spiritual growth.',
      'Karma (Action)':
          'Every action has consequences that shape our future. Act wisely and with pure intentions.',
      'Bhakti (Devotion)':
          'True devotion transforms every moment into a sacred offering, connecting us with the divine.',
      'Moksha (Liberation)':
          'Liberation comes through knowledge, devotion, and the realization of our true eternal nature.',
      'Knowledge & Wisdom':
          'Wisdom is not merely knowing facts, but understanding the deeper truths that guide righteous living.',
    };
    return lessons[theme] ??
        'Every story carries within it seeds of wisdom. Water these seeds with reflection, and watch understanding bloom.';
  }
}
