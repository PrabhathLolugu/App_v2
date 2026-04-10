import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myitihas/core/errors/failures.dart';
import 'package:myitihas/core/network/network_info.dart';
import 'package:myitihas/core/usecases/usecase.dart';
import 'package:myitihas/features/home/data/datasources/activity_local_datasource.dart';
import 'package:myitihas/features/story_generator/domain/entities/generator_options.dart';
import 'package:myitihas/features/story_generator/domain/entities/story_prompt.dart';
import 'package:myitihas/features/story_generator/domain/usecases/generate_story.dart';
import 'package:myitihas/features/story_generator/domain/usecases/generate_story_image.dart';
import 'package:myitihas/features/story_generator/domain/usecases/get_generated_stories.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/features/story_generator/domain/usecases/randomize_options.dart';
import 'package:myitihas/features/story_generator/presentation/bloc/story_generator_bloc.dart';
import 'package:myitihas/features/story_generator/presentation/bloc/story_generator_state.dart';

class MockGenerateStory extends Mock implements GenerateStory {}

class MockGenerateStoryImage extends Mock implements GenerateStoryImage {}

class MockGetGeneratedStories extends Mock implements GetGeneratedStories {}

class MockRandomizeOptions extends Mock implements RandomizeOptions {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockActivityLocalDataSource extends Mock implements ActivityLocalDataSource {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockGenerateStory mockGenerateStory;
  late MockGenerateStoryImage mockGenerateStoryImage;
  late MockGetGeneratedStories mockGetGeneratedStories;
  late MockRandomizeOptions mockRandomizeOptions;
  late MockNetworkInfo mockNetworkInfo;
  late MockActivityLocalDataSource mockActivity;

  StoryGeneratorBloc buildBloc() {
    return StoryGeneratorBloc(
      generateStory: mockGenerateStory,
      generateStoryImage: mockGenerateStoryImage,
      getGeneratedStories: mockGetGeneratedStories,
      randomizeOptions: mockRandomizeOptions,
      networkInfo: mockNetworkInfo,
      activityDataSource: mockActivity,
    );
  }

  setUpAll(() {
    registerFallbackValue(
      GenerateStoryParams(
        prompt: const StoryPrompt(isRawPrompt: true),
        options: const GeneratorOptions(),
      ),
    );
    registerFallbackValue(const GetGeneratedStoriesParams());
    registerFallbackValue(
      GenerateStoryImageParams(title: 't', story: 's', moral: 'm'),
    );
    registerFallbackValue(NoParams());
  });

  setUp(() {
    mockGenerateStory = MockGenerateStory();
    mockGenerateStoryImage = MockGenerateStoryImage();
    mockGetGeneratedStories = MockGetGeneratedStories();
    mockRandomizeOptions = MockRandomizeOptions();
    mockNetworkInfo = MockNetworkInfo();
    mockActivity = MockActivityLocalDataSource();

    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(() => mockGenerateStory(any())).thenAnswer(
      (_) async => Left(NetworkFailure('unused')),
    );
    when(() => mockGenerateStoryImage(any())).thenAnswer(
      (_) async => Left(NetworkFailure('unused')),
    );
    when(() => mockGetGeneratedStories(any())).thenAnswer(
      (_) async => const Right(<Story>[]),
    );
    when(() => mockRandomizeOptions(any())).thenAnswer(
      (_) async => Left(NetworkFailure('unused')),
    );
  });

  group('StoryGeneratorBloc voice', () {
    blocTest<StoryGeneratorBloc, StoryGeneratorState>(
      'two final segments in raw mode keep isListening until engine stopped',
      build: buildBloc,
      seed: () => const StoryGeneratorState(
        isRawPromptMode: true,
        isListening: true,
        isOnline: true,
        rawPrompt: StoryPrompt(isRawPrompt: true, rawPrompt: ''),
      ),
      act: (bloc) {
        bloc.add(
          const StoryGeneratorEvent.updateVoiceResult(
            text: 'Hello',
            isFinal: true,
          ),
        );
        bloc.add(
          const StoryGeneratorEvent.updateVoiceResult(
            text: 'world',
            isFinal: true,
          ),
        );
        bloc.add(const StoryGeneratorEvent.voiceListenEngineStopped());
      },
      wait: const Duration(milliseconds: 50),
      expect: () => [
        predicate<StoryGeneratorState>(
          (s) =>
              s.isListening &&
              s.partialVoiceResult == 'Hello' &&
              (s.rawPrompt.rawPrompt ?? '').isEmpty,
        ),
        predicate<StoryGeneratorState>(
          (s) =>
              s.isListening &&
              s.partialVoiceResult == null &&
              s.rawPrompt.rawPrompt == 'Hello',
        ),
        predicate<StoryGeneratorState>(
          (s) =>
              s.isListening &&
              s.partialVoiceResult == 'world' &&
              s.rawPrompt.rawPrompt == 'Hello',
        ),
        predicate<StoryGeneratorState>(
          (s) =>
              s.isListening &&
              s.partialVoiceResult == null &&
              s.rawPrompt.rawPrompt == 'Hello world',
        ),
        predicate<StoryGeneratorState>(
          (s) =>
              !s.isListening &&
              s.partialVoiceResult == null &&
              s.rawPrompt.rawPrompt == 'Hello world',
        ),
      ],
    );

    blocTest<StoryGeneratorBloc, StoryGeneratorState>(
      'voiceListenEngineStopped clears listening and partial text',
      build: buildBloc,
      seed: () => const StoryGeneratorState(
        isListening: true,
        isOnline: true,
        partialVoiceResult: 'draft',
      ),
      act: (bloc) =>
          bloc.add(const StoryGeneratorEvent.voiceListenEngineStopped()),
      wait: const Duration(milliseconds: 20),
      expect: () => [
        predicate<StoryGeneratorState>(
          (s) => !s.isListening && s.partialVoiceResult == null && s.isOnline,
        ),
      ],
    );
  });
}
