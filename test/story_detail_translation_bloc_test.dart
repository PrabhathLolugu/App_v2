import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myitihas/core/logging/talker_setup.dart';
import 'package:myitihas/features/home/data/datasources/activity_local_datasource.dart';
import 'package:myitihas/features/home/domain/entities/activity_item.dart';
import 'package:myitihas/features/home/domain/repositories/continue_reading_repository.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/features/story_generator/domain/entities/story_translation.dart';
import 'package:myitihas/features/story_generator/domain/repositories/story_generator_repository.dart';
import 'package:myitihas/features/story_generator/presentation/bloc/story_detail_bloc.dart';

class _MockStoryGeneratorRepository extends Mock
    implements StoryGeneratorRepository {}

class _MockContinueReadingRepository extends Mock
    implements ContinueReadingRepository {}

class _MockActivityLocalDataSource extends Mock
    implements ActivityLocalDataSource {}

Story _dummyStory() {
  return Story(
    id: 'dummy-id',
    title: 'Dummy',
    scripture: 'Dummy',
    story: 'Dummy story',
    quotes: '',
    trivia: '',
    activity: '',
    lesson: '',
    attributes: const StoryAttributes(
      storyType: 'dummy',
      theme: 'dummy',
      mainCharacterType: 'dummy',
      storySetting: 'dummy',
      timeEra: 'dummy',
      narrativePerspective: 'dummy',
      languageStyle: 'English',
      emotionalTone: 'dummy',
      narrativeStyle: 'dummy',
      plotStructure: 'dummy',
      storyLength: 'dummy',
    ),
  );
}

ActivityItem _dummyActivity() {
  return ActivityItem(
    id: 'activity-id',
    type: ActivityType.storyRead,
    storyId: 'story-id',
    storyTitle: 'Dummy',
    timestamp: DateTime(2026, 1, 1),
  );
}

void main() {
  late StoryGeneratorRepository repo;
  late ContinueReadingRepository continueRepo;
  late ActivityLocalDataSource activityLocalDataSource;

  setUpAll(() {
    initTalker();
    registerFallbackValue(_dummyStory());
    registerFallbackValue(_dummyActivity());
  });

  Story buildStory({Map<String, TranslatedStory> translations = const {}}) {
    return Story(
      id: 'story-id',
      title: 'कहानी',
      scripture: 'Ramayana',
      story: 'यह एक सुंदर कथा है जिसमें धर्म की विजय होती है।',
      quotes: '',
      trivia: '',
      activity: '',
      lesson: 'सत्य की जीत होती है',
      attributes: StoryAttributes(
        storyType: 'mythology',
        theme: 'dharma',
        mainCharacterType: 'hero',
        storySetting: 'ancient',
        timeEra: 'vedic',
        narrativePerspective: 'third-person',
        languageStyle: 'Hindi',
        emotionalTone: 'inspiring',
        narrativeStyle: 'descriptive',
        plotStructure: 'linear',
        storyLength: 'medium',
        translations: translations,
      ),
    );
  }

  setUp(() {
    repo = _MockStoryGeneratorRepository();
    continueRepo = _MockContinueReadingRepository();
    activityLocalDataSource = _MockActivityLocalDataSource();

    when(
      () => continueRepo.addStoryToContinueReading(any()),
    ).thenAnswer((_) async => const Right(null));
    when(
      () => activityLocalDataSource.recordActivity(any()),
    ).thenAnswer((_) async {});
  });

  blocTest<StoryDetailBloc, StoryDetailState>(
    'translates when source is non-English and target is English',
    build: () {
      when(
        () => repo.translateStory(
          story: any(named: 'story'),
          targetLang: 'en',
        ),
      ).thenAnswer(
        (_) async => const Right(
          TranslatedStory(
            title: 'The Story',
            story: 'This is the translated story.',
            moral: 'Truth wins.',
            lang: 'en',
          ),
        ),
      );

      return StoryDetailBloc(repo, continueRepo, activityLocalDataSource);
    },
    act: (bloc) async {
      bloc.add(StoryDetailStarted(buildStory()));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      bloc.add(const StoryDetailLanguageChanged('English'));
    },
    wait: const Duration(milliseconds: 50),
    verify: (_) {
      verify(
        () => repo.translateStory(
          story: any(named: 'story'),
          targetLang: 'en',
        ),
      ).called(1);
    },
  );

  blocTest<StoryDetailBloc, StoryDetailState>(
    'uses cached English translation by default and refresh bypasses cache',
    build: () {
      when(
        () => repo.translateStory(
          story: any(named: 'story'),
          targetLang: 'en',
        ),
      ).thenAnswer(
        (_) async => const Right(
          TranslatedStory(
            title: 'Fresh English Title',
            story: 'Fresh translated story from API.',
            moral: 'Fresh moral',
            lang: 'en',
          ),
        ),
      );

      return StoryDetailBloc(repo, continueRepo, activityLocalDataSource);
    },
    act: (bloc) async {
      final storyWithCache = buildStory(
        translations: const {
          'en': TranslatedStory(
            title: 'Cached English Title',
            story: 'Cached translated story.',
            moral: 'Cached moral',
            lang: 'en',
          ),
        },
      );

      bloc.add(StoryDetailStarted(storyWithCache));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      bloc.add(const StoryDetailLanguageChanged('English'));
      await Future<void>.delayed(const Duration(milliseconds: 20));
      bloc.add(const StoryDetailTranslationRefreshRequested());
    },
    wait: const Duration(milliseconds: 80),
    verify: (_) {
      verify(
        () => repo.translateStory(
          story: any(named: 'story'),
          targetLang: 'en',
        ),
      ).called(1);
    },
  );

  blocTest<StoryDetailBloc, StoryDetailState>(
    'rejects stale English cache that mirrors original non-English content',
    build: () {
      when(
        () => repo.translateStory(
          story: any(named: 'story'),
          targetLang: 'en',
        ),
      ).thenAnswer(
        (_) async => const Right(
          TranslatedStory(
            title: 'Fresh English Title',
            story: 'A freshly translated English story.',
            moral: 'Fresh moral',
            lang: 'en',
          ),
        ),
      );

      return StoryDetailBloc(repo, continueRepo, activityLocalDataSource);
    },
    act: (bloc) async {
      const originalHindiStory =
          'यह एक सुंदर कथा है जिसमें धर्म की विजय होती है।';
      final storyWithStaleEnglishCache = buildStory(
        translations: const {
          'en': TranslatedStory(
            title: 'Stale English Title',
            story: originalHindiStory,
            moral: 'Cached moral',
            lang: 'en',
          ),
        },
      );

      bloc.add(StoryDetailStarted(storyWithStaleEnglishCache));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      bloc.add(const StoryDetailLanguageChanged('English'));
    },
    wait: const Duration(milliseconds: 50),
    verify: (_) {
      verify(
        () => repo.translateStory(
          story: any(named: 'story'),
          targetLang: 'en',
        ),
      ).called(1);
    },
  );
}
