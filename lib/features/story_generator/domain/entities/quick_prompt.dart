import 'package:flutter/material.dart';
import 'package:myitihas/features/stories/domain/entities/story_options.dart';
import 'story_prompt.dart';

/// Represents a pre-defined quick prompt for the carousel.
class QuickPrompt {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final StoryPrompt presetOptions;
  final List<Color> gradientColors;

  const QuickPrompt({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.presetOptions,
    required this.gradientColors,
  });

  static const int _targetPresetCount = 150;

  /// Deterministic list of presets: curated first, then canonical combinations.
  static final List<QuickPrompt> defaultPrompts = _buildDefaultPrompts();

  static List<QuickPrompt> _buildDefaultPrompts() {
    final canonical = _CanonicalPresetValues.fromStoryOptions();

    final prompts = <QuickPrompt>[];
    final seenIds = <String>{};
    final seenCombinations = <String>{};

    // Keep curated prompts first while filtering invalid/duplicate tuples.
    for (final prompt in _curatedPrompts) {
      if (!_isCanonicalPrompt(prompt, canonical)) {
        continue;
      }
      if (!seenIds.add(prompt.id)) {
        continue;
      }
      prompts.add(prompt);
      seenCombinations.add(_combinationKey(prompt.presetOptions));
    }

    final scriptures = canonical.scriptures;
    final storyTypes = canonical.storyTypes;
    final themes = canonical.themes;
    final mainCharacters = canonical.mainCharacters;
    final settings = canonical.settings;

    var i = 0;
    var safety = 0;
    final maxAttempts = _targetPresetCount * 400;

    while (prompts.length < _targetPresetCount && safety < maxAttempts) {
      final scripture = scriptures[i % scriptures.length];
      final storyType = storyTypes[(i * 5 + 1) % storyTypes.length];
      final theme = themes[(i * 7 + 2) % themes.length];
      final mainCharacter =
          mainCharacters[(i * 11 + 3) % mainCharacters.length];
      final setting = settings[(i * 13 + 5) % settings.length];

      final options = StoryPrompt(
        scripture: scripture,
        storyType: storyType,
        theme: theme,
        mainCharacter: mainCharacter,
        setting: setting,
      );

      final comboKey = _combinationKey(options);
      if (seenCombinations.contains(comboKey)) {
        i++;
        safety++;
        continue;
      }

      final ordinal = prompts.length + 1;
      final icon = _generatedIcons[i % _generatedIcons.length];
      final gradient = _generatedGradients[i % _generatedGradients.length];
      final title = _buildGeneratedTitle(
        ordinal: ordinal,
        scripture: scripture,
        storyType: storyType,
        theme: theme,
        mainCharacter: mainCharacter,
        setting: setting,
      );
      final subtitle = _buildGeneratedSubtitle(
        ordinal: ordinal,
        scripture: scripture,
        storyType: storyType,
        theme: theme,
        mainCharacter: mainCharacter,
        setting: setting,
      );

      final prompt = QuickPrompt(
        id: 'canonical_${ordinal.toString().padLeft(3, '0')}',
        title: title,
        subtitle: subtitle,
        icon: icon,
        gradientColors: gradient,
        presetOptions: options,
      );

      seenCombinations.add(comboKey);
      seenIds.add(prompt.id);
      prompts.add(prompt);
      i++;
      safety++;
    }

    if (prompts.length != _targetPresetCount) {
      throw StateError(
        'Failed to build $_targetPresetCount deterministic presets. Built ${prompts.length}.',
      );
    }

    final promptScriptures = prompts
        .map((p) => p.presetOptions.scripture)
        .whereType<String>()
        .toSet();
    if (!canonical.scriptures.every(promptScriptures.contains)) {
      throw StateError(
        'Deterministic presets do not cover all canonical scriptures.',
      );
    }

    return List.unmodifiable(prompts);
  }

  static bool _isCanonicalPrompt(
    QuickPrompt prompt,
    _CanonicalPresetValues canonical,
  ) {
    final options = prompt.presetOptions;
    return options.scripture != null &&
        options.storyType != null &&
        options.theme != null &&
        options.mainCharacter != null &&
        options.setting != null &&
        canonical.scriptures.contains(options.scripture) &&
        canonical.storyTypes.contains(options.storyType) &&
        canonical.themes.contains(options.theme) &&
        canonical.mainCharacters.contains(options.mainCharacter) &&
        canonical.settings.contains(options.setting);
  }

  static String _combinationKey(StoryPrompt options) {
    return '${options.scripture}|${options.storyType}|${options.theme}|'
        '${options.mainCharacter}|${options.setting}';
  }

  static String _buildGeneratedTitle({
    required int ordinal,
    required String scripture,
    required String storyType,
    required String theme,
    required String mainCharacter,
    required String setting,
  }) {
    final openers = [
      'Whispers of',
      'Oath of',
      'Pilgrimage to',
      'Chronicle of',
      'Legacy of',
      'Covenant of',
      'Flame of',
      'Song of',
      'Trials of',
      'Revelation of',
      'Vow of',
      'Guardians of',
    ];

    final focus = [
      _themeAnchor(theme),
      _scriptureAnchor(scripture),
      _storyTypeAnchor(storyType),
      _characterAnchor(mainCharacter),
      _settingAnchor(setting),
    ];

    final opener = openers[(ordinal * 3 + 1) % openers.length];
    final lead = focus[(ordinal * 5 + 2) % focus.length];
    final tail = focus[(ordinal * 7 + 3) % focus.length];

    if (lead == tail) {
      return '$opener $lead';
    }
    return '$opener $lead: $tail';
  }

  static String _buildGeneratedSubtitle({
    required int ordinal,
    required String scripture,
    required String storyType,
    required String theme,
    required String mainCharacter,
    required String setting,
  }) {
    final lines = [
      '$storyType in ${_settingAnchor(setting)} · ${_themeAnchor(theme)}',
      '${_characterAnchor(mainCharacter)} centered $storyType · ${_scriptureAnchor(scripture)}',
      '${_themeAnchor(theme)} through $storyType · ${_settingAnchor(setting)}',
      '${_scriptureAnchor(scripture)} retold as $storyType · ${_characterAnchor(mainCharacter)}',
    ];
    return lines[(ordinal * 11 + 4) % lines.length];
  }

  static String _themeAnchor(String theme) {
    const map = {
      'Dharma (Duty)': 'Sacred Duty',
      'Karma (Action)': 'Karmic Resolve',
      'Bhakti (Devotion)': 'Devotion Eternal',
      'Moksha (Liberation)': 'Inner Liberation',
      'Knowledge & Wisdom': 'Ancient Wisdom',
      'Cosmic Harmony': 'Cosmic Order',
      'Power & Leadership': 'Noble Leadership',
      'Spiritual Transformation': 'Awakened Spirit',
      'Divine Justice': 'Divine Justice',
      'Destiny & Fate': 'Sacred Destiny',
      'Good vs Evil': 'Light and Shadow',
      'Self-Discovery': 'Inner Truth',
      'Perseverance': 'Steadfast Spirit',
      'Forgiveness': 'Compassionate Heart',
      'Duty vs Desire': 'Duty and Desire',
      'Faith Under Trial': 'Faith Under Trial',
      'Wisdom in Adversity': 'Wisdom in Adversity',
      'Service & Sacrifice': 'Service and Sacrifice',
      'Truthful Leadership': 'Truthful Leadership',
      'Divine Grace': 'Divine Grace',
      'Ethical Courage': 'Ethical Courage',
      'Balance of Nature': 'Balance of Nature',
      'Discipline & Restraint': 'Discipline and Restraint',
      'Unity in Diversity': 'Unity in Diversity',
      'Righteous Victory': 'Righteous Victory',
      'Humane Governance': 'Humane Governance',
      'Mindfulness & Presence': 'Mindful Presence',
      'Justice with Compassion': 'Compassionate Justice',
      'Loyalty & Betrayal': 'Loyalty and Betrayal',
    };
    return map[theme] ?? theme;
  }

  static String _scriptureAnchor(String scripture) {
    if (scripture.contains('Ramayana')) return 'Ayodhya Legacy';
    if (scripture.contains('Mahabharata')) return 'Kurukshetra Oath';
    if (scripture.contains('Panchatantra')) return 'Forest Wisdom';
    if (scripture.contains('Upanishad')) return 'Rishi Insight';
    if (scripture.contains('Purāṇa') || scripture.contains('Purana')) {
      return 'Puranic Fire';
    }
    return scripture;
  }

  static String _storyTypeAnchor(String storyType) {
    const map = {
      'Epic Adventure': 'Heroic Journey',
      'Moral Tale': 'Moral Compass',
      'Devotional Story': 'Sacred Devotion',
      'Philosophical Journey': 'Seeking Truth',
      'Historical Legend': 'Legend of Ages',
      'Divine Intervention': 'Divine Turning Point',
      'Creation Myth': 'Origins of Creation',
      'Spiritual Transformation': 'Soul Awakening',
      'Sacred Quest': 'Sacred Quest',
      'Wisdom Tale': 'Circle of Wisdom',
      'Heroic Journey': 'Path of Valor',
      'Redemption Story': 'Path to Redemption',
      'Battle Epic': 'Warrior Resolve',
    };
    return map[storyType] ?? storyType;
  }

  static String _characterAnchor(String mainCharacter) {
    const map = {
      'Divine Being': 'Divine Presence',
      'Sage/Rishi': 'Rishi Insight',
      'Warrior/Kshatriya': 'Warrior Resolve',
      'Royal Family Member': 'Royal Legacy',
      'Devoted Seeker': 'Devoted Seeker',
      'Common Person': 'Humble Hero',
      'Celestial Being': 'Celestial Witness',
      'Divine Animal': 'Sacred Creature',
      'Asura/Rakshasa': 'Asuric Force',
      'Temple Priest': 'Temple Keeper',
      'Mystic/Yogi': 'Mystic Path',
      'Epic Hero': 'Epic Hero',
      'Epic Villain': 'Shadowed Foe',
      'Clever Courtier': 'Clever Courtier',
      'Talking Animal': 'Speaking Beast',
      'Ghost/Spirit': 'Restless Spirit',
    };
    return map[mainCharacter] ?? mainCharacter;
  }

  static String _settingAnchor(String setting) {
    const map = {
      'Sacred Forest': 'Sacred Forest',
      'Ancient Kingdom': 'Ancient Kingdom',
      "Sage's Ashram": 'Rishi Ashram',
      'Epic Battlefield': 'Epic Battlefield',
      'Celestial Realm': 'Celestial Realm',
      'Holy Pilgrimage Site': 'Pilgrimage Path',
      'Ancient Village': 'Ancient Village',
      'Royal Palace': 'Royal Palace',
      'Sacred Mountain': 'Sacred Mountain',
      'Holy River': 'Holy River',
      'Ancient Temple': 'Ancient Temple',
      'Mystical Cave': 'Mystic Cave',
      'Ancient City': 'Ancient City',
      'Magical Realm': 'Magical Realm',
      'Sky Palace': 'Sky Palace',
    };
    return map[setting] ?? setting;
  }

  static const List<IconData> _generatedIcons = [
    Icons.auto_stories,
    Icons.temple_hindu,
    Icons.menu_book,
    Icons.local_fire_department,
    Icons.travel_explore,
    Icons.psychology,
    Icons.balance,
    Icons.self_improvement,
    Icons.forest,
    Icons.auto_awesome,
  ];

  static const List<List<Color>> _generatedGradients = [
    [Color(0xFF0f766e), Color(0xFF0ea5e9)],
    [Color(0xFF1d4ed8), Color(0xFF2563eb)],
    [Color(0xFF7c3aed), Color(0xFF9333ea)],
    [Color(0xFFb45309), Color(0xFFd97706)],
    [Color(0xFFbe123c), Color(0xFFdb2777)],
    [Color(0xFF166534), Color(0xFF16a34a)],
    [Color(0xFF1A1A1A), Color(0xFF4A4A4A)],
    [Color(0xFF7f1d1d), Color(0xFFdc2626)],
  ];

  /// Curated list of quick prompts kept at the top of the carousel.
  static List<QuickPrompt> get _curatedPrompts => [
    QuickPrompt(
      id: 'warrior_quest',
      title: "A Warrior's Quest",
      subtitle: 'Epic adventure from Mahabharata',
      icon: Icons.shield,
      gradientColors: [const Color(0xFF667eea), const Color(0xFF764ba2)],
      presetOptions: const StoryPrompt(
        scripture: 'Mahabharata',
        storyType: 'Epic Adventure',
        theme: 'Dharma (Duty)',
        mainCharacter: 'Warrior/Kshatriya',
        setting: 'Epic Battlefield',
      ),
    ),
    QuickPrompt(
      id: 'krishna_wisdom',
      title: "Krishna's Wisdom",
      subtitle: 'Divine teachings and philosophy',
      icon: Icons.auto_awesome,
      gradientColors: [const Color(0xFF11998e), const Color(0xFF38ef7d)],
      presetOptions: const StoryPrompt(
        scripture: 'Bhāgavata Purāṇa',
        storyType: 'Philosophical Journey',
        theme: 'Knowledge & Wisdom',
        mainCharacter: 'Divine Being',
        setting: 'Royal Palace',
      ),
    ),
    QuickPrompt(
      id: 'sage_journey',
      title: "A Sage's Journey",
      subtitle: 'Spiritual transformation story',
      icon: Icons.self_improvement,
      gradientColors: [const Color(0xFFf093fb), const Color(0xFFf5576c)],
      presetOptions: const StoryPrompt(
        scripture: 'Upanishads',
        storyType: 'Spiritual Transformation',
        theme: 'Moksha (Liberation)',
        mainCharacter: 'Sage/Rishi',
        setting: "Sage's Ashram",
      ),
    ),
    QuickPrompt(
      id: 'rama_devotion',
      title: 'Path of Devotion',
      subtitle: 'Devotional tale from Ramayana',
      icon: Icons.favorite,
      gradientColors: [const Color(0xFFff9a9e), const Color(0xFFfecfef)],
      presetOptions: const StoryPrompt(
        scripture: 'Ramayana',
        storyType: 'Devotional Story',
        theme: 'Bhakti (Devotion)',
        mainCharacter: 'Devoted Seeker',
        setting: 'Sacred Forest',
      ),
    ),
    QuickPrompt(
      id: 'animal_wisdom',
      title: 'Tales of Wisdom',
      subtitle: 'Clever stories from Panchatantra',
      icon: Icons.pets,
      gradientColors: [const Color(0xFFa8edea), const Color(0xFFfed6e3)],
      presetOptions: const StoryPrompt(
        scripture: 'Panchatantra',
        storyType: 'Animal Fable',
        theme: 'Cleverness & Wit',
        mainCharacter: 'Talking Animal',
        setting: 'Sacred Forest',
      ),
    ),
    QuickPrompt(
      id: 'divine_legend',
      title: 'Divine Legend',
      subtitle: 'Cosmic tales of creation',
      icon: Icons.blur_on,
      gradientColors: [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
      presetOptions: const StoryPrompt(
        scripture: 'Brahma Purāṇa',
        storyType: 'Creation Myth',
        theme: 'Cosmic Harmony',
        mainCharacter: 'Divine Being',
        setting: 'Celestial Realm',
      ),
    ),
    QuickPrompt(
      id: 'arjuna_dharma',
      title: "Arjuna's Dharma",
      subtitle: 'A duty-bound turning point',
      icon: Icons.balance,
      gradientColors: [const Color(0xFF00c6ff), const Color(0xFF0072ff)],
      presetOptions: const StoryPrompt(
        scripture: 'Mahabharata',
        storyType: 'Philosophical Journey',
        theme: 'Dharma (Duty)',
        mainCharacter: 'Warrior/Kshatriya',
        setting: 'Epic Battlefield',
      ),
    ),
    QuickPrompt(
      id: 'gita_on_field',
      title: 'Song on the Battlefield',
      subtitle: 'Wisdom spoken amidst conflict',
      icon: Icons.psychology,
      gradientColors: [const Color(0xFFf7971e), const Color(0xFFffd200)],
      presetOptions: const StoryPrompt(
        scripture: 'Mahabharata',
        storyType: 'Philosophical Journey',
        theme: 'Knowledge & Wisdom',
        mainCharacter: 'Divine Being',
        setting: 'Epic Battlefield',
      ),
    ),
    QuickPrompt(
      id: 'bheeshma_oath',
      title: "Bheeshma's Oath",
      subtitle: 'A vow that shapes a kingdom',
      icon: Icons.gavel,
      gradientColors: [const Color(0xFF232526), const Color(0xFF414345)],
      presetOptions: const StoryPrompt(
        scripture: 'Mahabharata',
        storyType: 'Epic Adventure',
        theme: 'Dharma (Duty)',
        mainCharacter: 'Warrior/Kshatriya',
        setting: 'Royal Palace',
      ),
    ),
    QuickPrompt(
      id: 'warrior_inner_shift',
      title: 'The Warrior Within',
      subtitle: 'From struggle to liberation',
      icon: Icons.self_improvement,
      gradientColors: [const Color(0xFFDA4453), const Color(0xFF89216B)],
      presetOptions: const StoryPrompt(
        scripture: 'Mahabharata',
        storyType: 'Spiritual Transformation',
        theme: 'Moksha (Liberation)',
        mainCharacter: 'Warrior/Kshatriya',
        setting: 'Epic Battlefield',
      ),
    ),
    QuickPrompt(
      id: 'forest_devotion',
      title: 'Forest of Devotion',
      subtitle: 'Faith tested in the wilds',
      icon: Icons.park,
      gradientColors: [const Color(0xFF56ab2f), const Color(0xFFa8e063)],
      presetOptions: const StoryPrompt(
        scripture: 'Ramayana',
        storyType: 'Devotional Story',
        theme: 'Bhakti (Devotion)',
        mainCharacter: 'Devoted Seeker',
        setting: 'Sacred Forest',
      ),
    ),
    QuickPrompt(
      id: 'hanuman_valor',
      title: "Hanuman's Valor",
      subtitle: 'A leap of courage and faith',
      icon: Icons.flight_takeoff,
      gradientColors: [const Color(0xFF2193b0), const Color(0xFF6dd5ed)],
      presetOptions: const StoryPrompt(
        scripture: 'Ramayana',
        storyType: 'Epic Adventure',
        theme: 'Bhakti (Devotion)',
        mainCharacter: 'Devoted Seeker',
        setting: 'Sacred Forest',
      ),
    ),
    QuickPrompt(
      id: 'sita_resolve',
      title: "Sita's Resolve",
      subtitle: 'Strength through inner freedom',
      icon: Icons.wb_sunny,
      gradientColors: [const Color(0xFFee0979), const Color(0xFFff6a00)],
      presetOptions: const StoryPrompt(
        scripture: 'Ramayana',
        storyType: 'Spiritual Transformation',
        theme: 'Moksha (Liberation)',
        mainCharacter: 'Devoted Seeker',
        setting: 'Sacred Forest',
      ),
    ),
    QuickPrompt(
      id: 'rama_duty_path',
      title: "Rama's Duty",
      subtitle: 'Choosing dharma over comfort',
      icon: Icons.assistant_direction,
      gradientColors: [const Color(0xFF614385), const Color(0xFF516395)],
      presetOptions: const StoryPrompt(
        scripture: 'Ramayana',
        storyType: 'Epic Adventure',
        theme: 'Dharma (Duty)',
        mainCharacter: 'Warrior/Kshatriya',
        setting: 'Royal Palace',
      ),
    ),
    QuickPrompt(
      id: 'narada_lessons',
      title: "Narada's Lessons",
      subtitle: 'A sage guides kings and gods',
      icon: Icons.temple_hindu,
      gradientColors: [const Color(0xFF30cfd0), const Color(0xFF330867)],
      presetOptions: const StoryPrompt(
        scripture: 'Bhāgavata Purāṇa',
        storyType: 'Philosophical Journey',
        theme: 'Knowledge & Wisdom',
        mainCharacter: 'Sage/Rishi',
        setting: 'Celestial Realm',
      ),
    ),
    QuickPrompt(
      id: 'prahlada_faith',
      title: "Prahlada's Faith",
      subtitle: 'Devotion that cannot be broken',
      icon: Icons.favorite_border,
      gradientColors: [const Color(0xFFff512f), const Color(0xFFdd2476)],
      presetOptions: const StoryPrompt(
        scripture: 'Bhāgavata Purāṇa',
        storyType: 'Devotional Story',
        theme: 'Bhakti (Devotion)',
        mainCharacter: 'Devoted Seeker',
        setting: 'Royal Palace',
      ),
    ),
    QuickPrompt(
      id: 'divine_play_forest',
      title: 'Divine Play',
      subtitle: 'Mystery and grace in the forest',
      icon: Icons.auto_awesome_motion,
      gradientColors: [const Color(0xFF8360c3), const Color(0xFF2ebf91)],
      presetOptions: const StoryPrompt(
        scripture: 'Bhāgavata Purāṇa',
        storyType: 'Devotional Story',
        theme: 'Bhakti (Devotion)',
        mainCharacter: 'Divine Being',
        setting: 'Sacred Forest',
      ),
    ),
    QuickPrompt(
      id: 'upanishad_dialogue',
      title: 'Upanishadic Dialogue',
      subtitle: 'Questions that open the self',
      icon: Icons.question_answer,
      gradientColors: [const Color(0xFF1f4037), const Color(0xFF99f2c8)],
      presetOptions: const StoryPrompt(
        scripture: 'Upanishads',
        storyType: 'Philosophical Journey',
        theme: 'Knowledge & Wisdom',
        mainCharacter: 'Sage/Rishi',
        setting: "Sage's Ashram",
      ),
    ),
    QuickPrompt(
      id: 'self_inquiry_ashram',
      title: 'Self-Inquiry',
      subtitle: 'A path toward liberation',
      icon: Icons.travel_explore,
      gradientColors: [const Color(0xFF0f2027), const Color(0xFF2c5364)],
      presetOptions: const StoryPrompt(
        scripture: 'Upanishads',
        storyType: 'Spiritual Transformation',
        theme: 'Moksha (Liberation)',
        mainCharacter: 'Devoted Seeker',
        setting: "Sage's Ashram",
      ),
    ),
    QuickPrompt(
      id: 'panchatantra_court',
      title: 'Court of Beasts',
      subtitle: 'Wit and strategy in a royal court',
      icon: Icons.account_balance,
      gradientColors: [const Color(0xFFf46b45), const Color(0xFFeea849)],
      presetOptions: const StoryPrompt(
        scripture: 'Panchatantra',
        storyType: 'Animal Fable',
        theme: 'Cleverness & Wit',
        mainCharacter: 'Talking Animal',
        setting: 'Royal Palace',
      ),
    ),
    QuickPrompt(
      id: 'forest_trickster',
      title: 'Forest Trickster',
      subtitle: 'A clever animal outsmarts danger',
      icon: Icons.emoji_nature,
      gradientColors: [const Color(0xFF43cea2), const Color(0xFF185a9d)],
      presetOptions: const StoryPrompt(
        scripture: 'Panchatantra',
        storyType: 'Animal Fable',
        theme: 'Cleverness & Wit',
        mainCharacter: 'Talking Animal',
        setting: 'Sacred Forest',
      ),
    ),
    QuickPrompt(
      id: 'cosmic_order',
      title: 'Cosmic Order',
      subtitle: 'Harmony written into creation',
      icon: Icons.public,
      gradientColors: [const Color(0xFF3a7bd5), const Color(0xFF3a6073)],
      presetOptions: const StoryPrompt(
        scripture: 'Brahma Purāṇa',
        storyType: 'Creation Myth',
        theme: 'Cosmic Harmony',
        mainCharacter: 'Divine Being',
        setting: 'Celestial Realm',
      ),
    ),
    QuickPrompt(
      id: 'rishi_of_cosmos',
      title: 'Rishi of the Cosmos',
      subtitle: 'A sage witnesses the universe unfold',
      icon: Icons.hub,
      gradientColors: [const Color(0xFF41295a), const Color(0xFF2F0743)],
      presetOptions: const StoryPrompt(
        scripture: 'Brahma Purāṇa',
        storyType: 'Philosophical Journey',
        theme: 'Cosmic Harmony',
        mainCharacter: 'Sage/Rishi',
        setting: 'Celestial Realm',
      ),
    ),
  ];
}

class _CanonicalPresetValues {
  final List<String> scriptures;
  final List<String> storyTypes;
  final List<String> themes;
  final List<String> mainCharacters;
  final List<String> settings;

  const _CanonicalPresetValues({
    required this.scriptures,
    required this.storyTypes,
    required this.themes,
    required this.mainCharacters,
    required this.settings,
  });

  factory _CanonicalPresetValues.fromStoryOptions() {
    List<String> readTypes(String category) {
      final categoryData = storyOptions[category];
      if (categoryData == null) {
        throw StateError('Missing category: $category');
      }
      final types = categoryData['types'] as List<dynamic>?;
      if (types == null || types.isEmpty) {
        throw StateError('Missing types for category: $category');
      }
      return types.map((item) => item.toString()).toList(growable: false);
    }

    final scriptureData = storyOptions['scripture'];
    if (scriptureData == null) {
      throw StateError('Missing scripture category in story options.');
    }
    final subtypes = scriptureData['subtypes'] as Map<String, dynamic>?;
    if (subtypes == null || subtypes.isEmpty) {
      throw StateError('Missing scripture subtypes in story options.');
    }

    final scriptures = <String>[];
    final seen = <String>{};
    for (final subtypeList in subtypes.values) {
      final values = subtypeList as List<dynamic>;
      for (final value in values) {
        final scripture = value.toString();
        if (seen.add(scripture)) {
          scriptures.add(scripture);
        }
      }
    }

    return _CanonicalPresetValues(
      scriptures: scriptures,
      storyTypes: readTypes('storyType'),
      themes: readTypes('theme'),
      mainCharacters: readTypes('mainCharacter'),
      settings: readTypes('setting'),
    );
  }
}
