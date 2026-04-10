# Testing Patterns

**Analysis Date:** 2026-01-28

## Test Framework

**Runner:**
- `flutter_test` (Flutter SDK built-in)
- Config: No custom test config file detected
- Test directory: `test/` at project root

**Assertion Library:**
- Flutter's built-in `expect()` function from `flutter_test`
- Matchers: `findsOneWidget`, `findsNothing`, standard Dart matchers

**Run Commands:**
```bash
flutter test              # Run all tests
flutter test --watch      # Watch mode (not configured by default)
flutter test --coverage   # Generate coverage (requires setup)
```

## Test File Organization

**Location:**
- Single test file found: `test/widget_test.dart`
- Pattern: Tests are expected to mirror source structure (not currently implemented)
- Recommended structure:
  ```
  test/
  ├── unit/
  │   ├── domain/
  │   │   └── usecases/
  │   │       └── get_stories_test.dart
  │   └── data/
  │       └── repositories/
  │           └── story_repository_test.dart
  ├── widget/
  │   └── features/
  │       └── home/
  │           └── quote_card_test.dart
  └── integration/
      └── story_flow_test.dart
  ```

**Naming:**
- Test files: `<feature_name>_test.dart`
- Pattern: Mirror source file name with `_test` suffix
- Example: `lib/features/stories/domain/usecases/get_stories.dart` → `test/unit/domain/usecases/get_stories_test.dart`

**Current Structure:**
```
test/
└── widget_test.dart
```

**Note:** Minimal test coverage currently implemented. The codebase is production-ready but lacks comprehensive test suite.

## Test Structure

**Suite Organization (based on `test/widget_test.dart`):**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final GoRouter router = MyItihasRouter().router;
    await tester.pumpWidget(MyItihas(router: router));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
```

**Patterns (Expected for future tests):**
- Widget tests use `testWidgets()`
- Unit tests use `test()`
- Group related tests with `group()`
- Setup: Use `setUp()` for common initialization
- Teardown: Use `tearDown()` for cleanup
- Arrange-Act-Assert pattern within each test

**Recommended Structure:**
```dart
void main() {
  group('GetStories UseCase', () {
    late GetStories useCase;
    late MockStoryRepository mockRepository;

    setUp(() {
      mockRepository = MockStoryRepository();
      useCase = GetStories(mockRepository);
    });

    test('should return stories when repository succeeds', () async {
      // Arrange
      final tStories = [Story(...)];
      when(() => mockRepository.getStories())
          .thenAnswer((_) async => Right(tStories));

      // Act
      final result = await useCase(GetStoriesParams());

      // Assert
      expect(result, Right(tStories));
      verify(() => mockRepository.getStories()).called(1);
    });
  });
}
```

## Mocking

**Framework:**
- Not currently configured in `pubspec.yaml`
- Recommended: `mockito` or `mocktail` for Dart mocking
- For BLoC testing: `bloc_test` package

**Expected Patterns:**

**Mocktail Pattern (Recommended):**
```dart
import 'package:mocktail/mocktail.dart';

class MockStoryRepository extends Mock implements StoryRepository {}
class MockGetStories extends Mock implements GetStories {}
class MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  late MockStoryRepository mockRepository;

  setUp(() {
    mockRepository = MockStoryRepository();
  });

  test('should fetch stories from repository', () async {
    // Arrange
    when(() => mockRepository.getStories(limit: any(named: 'limit')))
        .thenAnswer((_) async => Right([Story(...)]));

    // Act
    final result = await mockRepository.getStories(limit: 10);

    // Assert
    verify(() => mockRepository.getStories(limit: 10)).called(1);
  });
}
```

**BLoC Testing Pattern:**
```dart
import 'package:bloc_test/bloc_test.dart';

void main() {
  group('StoriesBloc', () {
    late StoriesBloc bloc;
    late MockGetStories mockGetStories;

    setUp(() {
      mockGetStories = MockGetStories();
      bloc = StoriesBloc(getStories: mockGetStories);
    });

    blocTest<StoriesBloc, StoriesState>(
      'emits [loading, loaded] when loadStories succeeds',
      build: () {
        when(() => mockGetStories(any()))
            .thenAnswer((_) async => Right([Story(...)]));
        return bloc;
      },
      act: (bloc) => bloc.add(const StoriesEvent.loadStories()),
      expect: () => [
        const StoriesState.loading(),
        StoriesState.loaded(stories: [Story(...)]),
      ],
    );
  });
}
```

**What to Mock:**
- External services: `SupabaseClient`, HTTP clients
- Repositories in use case tests
- Use cases in BLoC tests
- Datasources in repository tests
- Time-dependent functions: `DateTime.now()`
- File system operations
- Network calls

**What NOT to Mock:**
- Entities and models (use real instances)
- Simple data classes
- Value objects
- Freezed classes (use factory constructors)
- Flutter framework classes (use fakes when needed)

## Fixtures and Factories

## High-Priority Chat Blocking Scenarios (Manual QA)

- **1: 1:1 DM – User A blocks User B**
  - Create a 1:1 DM between User A and User B.
  - From User A, open the DM and block User B.
  - Verify:
    - User A cannot send messages in that DM (composer disabled or send fails with a clear error).
    - User B cannot send messages in that DM (send fails; messages are not created).
    - Neither user sees any messages in that DM after the block is in place (history is empty or replaced by a blocked banner).
- **2: 1:1 DM – User B blocks User A (reverse order)**
  - Repeat the above steps with the block initiated from User B.
  - Expectations are identical: no sending in either direction and no visible history.
- **3: Message requests and group invites with blocks**
  - Attempt to send a message request to a user who has blocked you.
    - Expectation: request cannot be created; user-friendly error is shown.
  - Attempt to send a message request to a user you have blocked.
    - Expectation: request cannot be created; user-friendly error is shown.
  - Attempt to invite a user to a group when:
    - They have blocked you, or
    - You have blocked them.
    - Expectation: invite cannot be created; user-friendly error is shown.

**Test Data (Recommended Pattern):**

**Location:**
```
test/
└── fixtures/
    ├── story_fixtures.dart
    ├── user_fixtures.dart
    └── json/
        ├── story.json
        └── user.json
```

**Factory Pattern:**
```dart
// test/fixtures/story_fixtures.dart
import 'package:myitihas/features/stories/domain/entities/story.dart';

class StoryFixtures {
  static Story createStory({
    String? id,
    String? title,
    String? content,
  }) {
    return Story(
      id: id ?? 'test-story-1',
      title: title ?? 'Test Story',
      scripture: 'Mahabharata',
      story: content ?? 'Once upon a time...',
      quotes: 'Test quote',
      trivia: 'Test trivia',
      activity: 'Test activity',
      lesson: 'Test lesson',
      attributes: StoryAttributes(
        storyType: 'Scriptural',
        theme: 'Dharma',
        mainCharacterType: 'Hero',
        storySetting: 'Ancient India',
        timeEra: 'Vedic',
        narrativePerspective: 'Third Person',
        languageStyle: 'English',
        emotionalTone: 'Inspirational',
        narrativeStyle: 'Epic',
        plotStructure: 'Linear',
        storyLength: 'Medium',
      ),
    );
  }

  static List<Story> createStoryList(int count) {
    return List.generate(
      count,
      (i) => createStory(id: 'story-$i', title: 'Story $i'),
    );
  }
}
```

**JSON Fixtures:**
```dart
// test/fixtures/json_reader.dart
import 'dart:io';

String fixture(String name) =>
    File('test/fixtures/json/$name').readAsStringSync();

// Usage
final jsonString = fixture('story.json');
final story = StoryModel.fromJson(jsonDecode(jsonString));
```

## Coverage

**Requirements:**
- No coverage requirements currently enforced
- No CI/CD pipeline detected with coverage checks

**View Coverage:**
```bash
# Generate coverage
flutter test --coverage

# View HTML report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

**Recommended Targets:**
- Domain layer (use cases, entities): 80%+
- Data layer (repositories): 70%+
- Presentation layer (BLoC): 70%+
- Widgets: 60%+ (focus on critical paths)

## Test Types

**Unit Tests:**
- Scope: Test individual classes in isolation
- Focus: Domain layer (use cases, entities), data layer (repositories, models)
- Dependencies: Mocked
- Example targets:
  - `lib/features/stories/domain/usecases/get_stories.dart`
  - `lib/features/stories/data/repositories/story_repository_impl.dart`
  - `lib/features/stories/data/models/story_model.dart` (JSON serialization)

**Widget Tests:**
- Scope: Test widget rendering and interactions
- Focus: Individual widgets and pages
- Dependencies: May use real or mock data
- Example from `test/widget_test.dart`:
  ```dart
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final GoRouter router = MyItihasRouter().router;
    await tester.pumpWidget(MyItihas(router: router));

    expect(find.text('0'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
  });
  ```
- Example targets:
  - `lib/features/home/presentation/widgets/quote_card.dart`
  - `lib/features/social/presentation/widgets/feed_item_card.dart`
  - `lib/features/home/presentation/pages/home_screen_page.dart`

**Integration Tests:**
- Scope: Test feature flows end-to-end
- Location: `integration_test/` directory (not currently present)
- Framework: `integration_test` package
- Example: User story flow (generate → view → share)
- Dependencies: Real services or mocked backend

**E2E Tests:**
- Framework: Not currently configured
- Options: `integration_test` (Flutter's solution) or `patrol` for advanced scenarios
- Scope: Full app flows across multiple features

## Common Patterns

**Async Testing:**
```dart
test('async operation completes successfully', () async {
  // Arrange
  final useCase = GetStories(mockRepository);
  when(() => mockRepository.getStories())
      .thenAnswer((_) async => Right([Story(...)]));

  // Act
  final result = await useCase(GetStoriesParams());

  // Assert
  expect(result.isRight(), true);
  result.fold(
    (failure) => fail('Should not return failure'),
    (stories) => expect(stories.length, greaterThan(0)),
  );
});
```

**Error Testing (Either Pattern):**
```dart
test('returns failure when repository fails', () async {
  // Arrange
  final failure = ServerFailure('Connection failed');
  when(() => mockRepository.getStories())
      .thenAnswer((_) async => Left(failure));

  // Act
  final result = await useCase(GetStoriesParams());

  // Assert
  expect(result.isLeft(), true);
  result.fold(
    (f) => expect(f, isA<ServerFailure>()),
    (s) => fail('Should not return success'),
  );
});
```

**Widget Testing with BLoC:**
```dart
testWidgets('displays stories when loaded', (WidgetTester tester) async {
  // Arrange
  final mockBloc = MockStoriesBloc();
  final stories = [StoryFixtures.createStory()];

  whenListen(
    mockBloc,
    Stream.fromIterable([
      const StoriesState.loading(),
      StoriesState.loaded(stories: stories),
    ]),
    initialState: const StoriesState.initial(),
  );

  // Act
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider.value(
        value: mockBloc,
        child: const StoriesPage(),
      ),
    ),
  );
  await tester.pump(); // Initial state
  await tester.pump(); // Loading state
  await tester.pump(); // Loaded state

  // Assert
  expect(find.text(stories.first.title), findsOneWidget);
  expect(find.byType(CircularProgressIndicator), findsNothing);
});
```

**Golden Tests (Recommended for Widgets):**
```dart
testWidgets('QuoteCard golden test', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: QuoteCard(
          quote: Quote(
            id: '1',
            text: 'Test quote',
            author: 'Test author',
            scripture: 'Bhagavad Gita',
          ),
        ),
      ),
    ),
  );

  await expectLater(
    find.byType(QuoteCard),
    matchesGoldenFile('goldens/quote_card.png'),
  );
});
```

**Dependency Injection in Tests:**
```dart
void main() {
  late GetIt getIt;

  setUp(() {
    getIt = GetIt.instance;
    getIt.registerLazySingleton<StoryRepository>(
      () => MockStoryRepository(),
    );
  });

  tearDown(() {
    getIt.reset();
  });

  test('uses injected dependencies', () {
    final repository = getIt<StoryRepository>();
    expect(repository, isA<MockStoryRepository>());
  });
}
```

**Testing Freezed Classes:**
```dart
test('Story equality works correctly', () {
  final story1 = Story(id: '1', title: 'Test', ...);
  final story2 = Story(id: '1', title: 'Test', ...);
  final story3 = Story(id: '2', title: 'Different', ...);

  expect(story1, equals(story2)); // Freezed provides value equality
  expect(story1, isNot(equals(story3)));
});

test('copyWith creates new instance with updated values', () {
  final original = Story(id: '1', title: 'Original', ...);
  final updated = original.copyWith(title: 'Updated');

  expect(updated.id, equals(original.id));
  expect(updated.title, equals('Updated'));
  expect(original.title, equals('Original')); // Immutability
});
```

**Stream Testing (for BLoC):**
```dart
test('bloc emits expected state sequence', () {
  final bloc = StoriesBloc(getStories: mockGetStories);

  when(() => mockGetStories(any()))
      .thenAnswer((_) async => Right([Story(...)]));

  expectLater(
    bloc.stream,
    emitsInOrder([
      const StoriesState.loading(),
      isA<StoriesStateLoaded>(),
    ]),
  );

  bloc.add(const StoriesEvent.loadStories());
});
```

## Current Test Status

**Existing Tests:**
- `test/widget_test.dart`: Single smoke test for basic widget functionality

**Test Coverage:**
- Minimal test coverage implemented
- Production codebase lacks comprehensive test suite
- Recommended areas to prioritize:
  1. Domain layer use cases (business logic)
  2. Data layer repositories (error handling)
  3. BLoC state management (state transitions)
  4. Critical widgets (QuoteCard, FeedItemCard, StoryCard)

**Dependencies to Add for Testing:**
```yaml
dev_dependencies:
  mocktail: ^1.0.0           # Mocking framework
  bloc_test: ^9.1.0          # BLoC testing utilities
  golden_toolkit: ^0.15.0    # Golden file testing
```

## Best Practices

**Test Independence:**
- Each test should be independent
- Use `setUp()` to reset state
- Don't rely on test execution order

**Descriptive Names:**
```dart
test('should return ServerFailure when Supabase throws exception', () {});
test('emits [loading, loaded] when stories are fetched successfully', () {});
testWidgets('displays error message when story load fails', () {});
```

**AAA Pattern:**
```dart
test('description', () async {
  // Arrange - Set up test data and mocks
  final mockRepo = MockRepository();
  when(() => mockRepo.getData()).thenAnswer((_) async => Right(data));

  // Act - Execute the code under test
  final result = await useCase(Params());

  // Assert - Verify the outcome
  expect(result, Right(data));
});
```

**Test Only Public APIs:**
- Don't test private methods directly
- Test public behavior that uses private methods
- Focus on contracts, not implementation details

**Use Type Matchers:**
```dart
expect(result, isA<ServerFailure>());
expect(widget, isA<QuoteCard>());
expect(state, isA<StoriesStateLoaded>());
```

## Post scheduling (manual QA and tests, up to 1 month)

**Feature:** Scheduled posts (text, image, video) with "Post now" vs "Schedule" (IST), cron-based publish, and profile management.

**Manual QA checklist:**
1. **Create post – immediate:** Create post with "Post now" selected; confirm it appears in feed immediately and has `status = 'published'` in DB.
2. **Create post – scheduled:** Select "Schedule", pick date/time (e.g. 10 minutes ahead), tap "Schedule post"; confirm success snackbar and that the post does **not** appear in the main feed.
3. **Scheduling validation:** With "Schedule" selected, tap "Schedule post" without picking a time → expect "Please choose a date and time". Pick a time in the past or &lt; 5 minutes ahead → expect "Scheduled time must be at least 5 minutes from now." Try times beyond 1 month ahead and confirm you see the \"up to 1 month in advance\" validation.
4. **Cron publishing:** In Supabase SQL editor run `SELECT publish_scheduled_posts();` for a post with `status = 'scheduled'` and `scheduled_at <= now()`. Confirm the row becomes `status = 'published'`, `published_at` set, and the post appears in the feed.
5. **Profile – scheduled section:** On own profile, with at least one scheduled post, confirm a "Scheduled" section appears with "Goes live at … IST" and menu (Post now, Edit schedule, Cancel schedule).
6. **Post now from profile:** Use "Post now" on a scheduled post; confirm it disappears from Scheduled and appears in the feed.
7. **Cancel schedule:** Use "Cancel schedule"; confirm it disappears from Scheduled and does not appear in the feed.
8. **Edit schedule:** Change date/time for a scheduled post; confirm "Schedule updated" and the new time is shown.
9. **Feed visibility:** Confirm public/following feeds only show posts where `status = 'published'` (scheduled posts never appear for others).

**Unit test ideas (when bloc_test/mocktail are in use):**
- `CreatePostBloc`: On submit with `isScheduled: true` and `scheduledAtLocal: null`, expect no `createPost` call and state has `schedulingErrorMessage` and `showValidationError: true`.
- `CreatePostBloc`: On submit with `isScheduled: true` and `scheduledAtLocal` &lt; now + 5 min, expect no `createPost` call and validation message.
- `CreatePostBloc`: On submit with `isScheduled: true` and valid `scheduledAtLocal`, expect `createPost` called with `status: 'scheduled'` and `scheduledAtUtc` set.
- `CreatePostBloc`: On submit with `isScheduled: false`, expect `createPost` called with `status: 'published'` and no `scheduledAtUtc`.

---

*Testing analysis: 2026-01-28*
