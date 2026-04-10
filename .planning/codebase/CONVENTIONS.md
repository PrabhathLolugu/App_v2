# Coding Conventions

**Analysis Date:** 2026-01-28

## Naming Patterns

**Files:**
- Entities: `story.dart`, `user.dart` (snake_case, no suffix)
- Models: `story_model.dart`, `user_model.dart` (snake_case with `_model` suffix)
- BLoC: `stories_bloc.dart`, `home_bloc.dart`, `feed_bloc.dart` (snake_case with `_bloc` suffix)
- Events: `home_event.dart`, `stories_event.dart` (snake_case with `_event` suffix)
- States: `home_state.dart`, `stories_state.dart` (snake_case with `_state` suffix)
- Pages: `home_screen_page.dart`, `story_detail_page.dart` (snake_case with `_page` suffix)
- Widgets: `quote_card.dart`, `feed_item_card.dart` (snake_case, descriptive)
- Repositories (impl): `post_repository_impl.dart`, `user_repository_impl.dart` (snake_case with `_impl` suffix)
- Datasources: `user_remote_data_source.dart`, `quote_local_datasource.dart` (snake_case with `_data_source` or `_datasource`)
- Use cases: `generate_story.dart`, `get_stories.dart` (snake_case, verb-based)

**Classes:**
- Entities: `Story`, `User`, `Quote` (PascalCase, no suffix)
- Models: `StoryModel`, `UserModel` (PascalCase with `Model` suffix)
- BLoC: `StoriesBloc`, `HomeBloc` (PascalCase with `Bloc` suffix)
- Events: Sealed classes like `HomeEvent`, `StoriesEvent` (PascalCase with `Event` suffix)
- States: `HomeState`, `StoriesState` (PascalCase with `State` suffix)
- Repositories: `PostRepositoryImpl`, `UserRepositoryImpl` (PascalCase with `Impl` suffix for implementations)
- Use cases: `GenerateStory`, `GetStories` (PascalCase, verb-based)
- Widgets: `QuoteCard`, `FeedItemCard` (PascalCase, descriptive)
- Exceptions: `ServerException`, `CacheException`, `NetworkException` (PascalCase with `Exception` suffix)
- Failures: `ServerFailure`, `CacheFailure`, `NetworkFailure` (PascalCase with `Failure` suffix)

**Functions:**
- Private BLoC handlers: `_onLoadStories`, `_onSearchStories` (camelCase with `_on` prefix)
- Helper methods: `_extractAuthor`, `_parseDateTime`, `_mapToFeedItem` (camelCase with `_` prefix for private)
- Public methods: `getUserById`, `getStories`, `likeContent` (camelCase, verb-based)
- Extension methods: `toEntity`, `toDomain`, `fromEntity` (camelCase)

**Variables:**
- Local variables: `result`, `stories`, `searchQuery`, `isLoading` (camelCase)
- Constants: Use `const` keyword, name in camelCase (e.g., `const HomeEvent.loadHome()`)
- Private fields: `_supabase`, `_postService`, `_controller` (camelCase with `_` prefix)

**Types:**
- Type parameters: `ReturnType`, `Params` (PascalCase)
- Generic types: `Either<Failure, Story>`, `List<FeedItem>` (standard Dart generics)

## Code Style

**Formatting:**
- Tool: Dart formatter (built-in, enforced by `dart format`)
- Line length: Default Dart (80 characters recommended, but flexible)
- Indentation: 2 spaces
- Trailing commas: Used consistently on multi-line parameter lists and collections
- Generated files: Use `// coverage:ignore-file` and `// ignore_for_file: type=lint`

**Linting:**
- Tool: `flutter_lints` v6.0.0 (package:flutter_lints/flutter.yaml)
- Lints: Default Flutter recommended lints
- Suppressions: Minimal use in source files, primarily in generated code (`.freezed.dart`, `.g.dart`)
- Config: `analysis_options.yaml` uses `include: package:flutter_lints/flutter.yaml`

## Import Organization

**Order:**
1. Dart SDK imports (`dart:ui`, `dart:convert`)
2. Flutter imports (`package:flutter/material.dart`, `package:flutter/services.dart`)
3. Third-party package imports (alphabetically):
   - `package:dartz/dartz.dart` or `package:fpdart/fpdart.dart`
   - `package:freezed_annotation/freezed_annotation.dart`
   - `package:go_router/go_router.dart`
   - `package:injectable/injectable.dart`
   - etc.
4. Project-relative imports (using relative paths):
   - Domain layer: `'../../domain/entities/story.dart'`
   - Cross-feature: `'package:myitihas/features/.../...dart'`
   - Core: `'package:myitihas/core/.../...dart'`
   - Services: `'package:myitihas/services/...dart'`
5. Generated imports (part statements):
   - `part 'file_name.freezed.dart';`
   - `part 'file_name.g.dart';`

**Example from `lib/features/stories/presentation/bloc/stories_bloc.dart`:**
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/logging/talker_setup.dart';
import '../../domain/usecases/get_stories.dart';
import '../../domain/usecases/toggle_favorite.dart';
import 'stories_event.dart';
import 'stories_state.dart';

export 'stories_event.dart';
export 'stories_state.dart';
```

**Path Aliases:**
- Package imports: `package:myitihas/...` for absolute paths within project
- Relative imports: `'../../domain/...'` for same-feature cross-layer imports
- No custom path aliases configured

## Error Handling

**Patterns:**
- Use `Either<Failure, T>` from fpdart for all repository and use case returns
- Throw `AppException` subtypes in data layer (datasources)
- Catch exceptions in repositories, convert to `Failure` subtypes
- BLoC consumes `Either` results using `.fold()`

**Exception Hierarchy (in `lib/core/errors/exceptions.dart`):**
```dart
abstract class AppException implements Exception {
  final String message;
  final String? code;
}

// Subtypes:
- ServerException
- CacheException
- NetworkException
- AuthException
- ValidationException
- NotFoundException
- TimeoutException
- ParsingException
```

**Failure Hierarchy (in `lib/core/errors/failures.dart`):**
```dart
abstract class Failure extends Equatable {
  final String message;
  final String? code;
}

// Subtypes:
- ServerFailure
- CacheFailure
- NetworkFailure
- AuthFailure
- ValidationFailure
- NotFoundFailure
- TimeoutFailure
- ParsingFailure
- UnexpectedFailure
```

**Repository Pattern:**
```dart
@override
Future<Either<Failure, List<FeedItem>>> getPosts({
  int limit = 10,
  int offset = 0,
}) async {
  try {
    final posts = await _postService.getFeed(
      limit: limit,
      offset: offset,
    );

    final feedItems = posts.map((p) => _mapToFeedItem(p)).toList();
    return Right(feedItems);
  } catch (e) {
    return Left(UnexpectedFailure(e.toString()));
  }
}
```

**BLoC Pattern:**
```dart
final result = await getStories(GetStoriesParams());

result.fold(
  (failure) {
    talker.error('Failed to load stories: ${failure.message}');
    emit(StoriesState.error(failure.message));
  },
  (stories) {
    talker.info('Loaded ${stories.length} stories');
    emit(StoriesState.loaded(stories: stories));
  },
);
```

**Datasource Pattern:**
```dart
try {
  final response = await _supabase
      .from('profiles')
      .select('id, username, full_name, avatar_url, bio')
      .eq('id', userId)
      .single();

  return UserModel(...);
} catch (e) {
  if (e.toString().contains('406') || e.toString().contains('not found')) {
    throw NotFoundException('User not found', 'USER_NOT_FOUND');
  }
  throw ServerException('Failed to fetch user: ${e.toString()}', 'FETCH_USER_ERROR');
}
```

## Logging

**Framework:** `talker` (v5.1.9) with `talker_flutter` and `talker_bloc_logger`

**Setup:** Global `talker` instance from `lib/core/logging/talker_setup.dart`

**Import Pattern:**
```dart
import 'package:myitihas/core/logging/talker_setup.dart';
```

**Usage Levels:**
```dart
talker.info('Loading stories...');           // General info
talker.debug('Raw response: $response');     // Debug details
talker.error('Failed to load', exception);   // Errors
talker.good('Successfully completed');       // Success messages
```

**BLoC Logging:**
- Automatic logging via `TalkerBlocObserver`
- Logs events, state transitions, and changes
- Configured in `lib/core/logging/talker_setup.dart`:
  ```dart
  TalkerBlocObserver(
    talker: talker,
    settings: const TalkerBlocLoggerSettings(
      enabled: true,
      printEventFullData: true,
      printStateFullData: true,
      printChanges: true,
      printEvents: true,
      printTransitions: true,
    ),
  )
  ```

**Patterns:**
- Log at entry to important operations
- Log error messages with context
- Include counts/sizes for collections
- Use emoji prefixes in datasources for visual scanning: `'🔍 [DataSource] Fetching...'`

## Comments

**When to Comment:**
- Public APIs: Use doc comments (`///`) for classes, methods, parameters
- Complex logic: Inline comments for non-obvious algorithms
- TODOs: `// TODO: description` for planned work
- Workarounds: Explain why a workaround exists

**Doc Comments:**
```dart
/// Events for HomeBloc
@freezed
sealed class HomeEvent with _$HomeEvent {
  /// Load all home screen data
  const factory HomeEvent.loadHome() = _LoadHome;

  /// Refresh home screen data
  const factory HomeEvent.refresh() = _Refresh;
}
```

```dart
/// Base class for all use cases in the application
///
/// ReturnType: The return type of the use case
/// Params: The parameters required for the use case
abstract class UseCase<ReturnType, Params> {
  /// Executes the use case with the given parameters
  ///
  /// Returns [Either<Failure, ReturnType>] to handle errors gracefully
  Future<Either<Failure, ReturnType>> call(Params params);
}
```

**Inline Comments:**
- Used sparingly in production code
- More common in datasources to explain mapping logic
- Example from `lib/features/social/data/datasources/user_remote_data_source.dart`:
  ```dart
  // Query profiles table - canonical source for profile data
  final response = await _supabase
      .from('profiles')
      .select('id, username, full_name, avatar_url, bio')
      .eq('id', userId)
      .single();
  ```

**Generated Code:**
- No manual comments in `.freezed.dart` or `.g.dart` files
- Header comment: `/// Generated file. Do not edit.`

## Function Design

**Size:**
- BLoC event handlers: 20-50 lines typical
- Repository methods: 10-30 lines
- Helper methods: 5-20 lines
- Extract private helpers when logic exceeds ~30 lines

**Parameters:**
- Use named parameters for methods with 2+ parameters
- Required parameters: Use `required` keyword
- Optional parameters: Provide defaults when sensible
- Use case params: Wrap in dedicated `Params` class

**Example - Named Parameters:**
```dart
Future<Either<Failure, List<ImagePost>>> getImagePosts({
  int limit = 10,
  int offset = 0,
}) async { ... }
```

**Example - Use Case Params:**
```dart
class GenerateStoryParams {
  final StoryPrompt prompt;
  final GeneratorOptions options;

  const GenerateStoryParams({required this.prompt, required this.options});
}

@override
Future<Either<Failure, Story>> call(GenerateStoryParams params) async {
  return await repository.generateStory(
    prompt: params.prompt,
    options: params.options,
  );
}
```

**Return Values:**
- Use cases and repositories: Return `Future<Either<Failure, T>>`
- Datasources: Return `Future<Model>` or throw exceptions
- Widgets: Return `Widget`
- BLoC: Return `Future<void>` for event handlers
- Entities/Models: Immutable with `@freezed`, use `copyWith` for modifications

**Async/Await:**
- Always use `async`/`await` for async operations
- Never use `.then()` chaining
- Pattern: `final result = await operation();`

## Module Design

**Exports:**
- BLoC files export their events and states:
  ```dart
  export 'stories_event.dart';
  export 'stories_state.dart';
  ```
- Use case bundles may export all use cases in a feature
- Widget barrel files (e.g., `widgets.dart`) export all widgets in directory

**Barrel Files:**
- Used in some features: `lib/features/story_generator/presentation/widgets/widgets.dart`
- Not universally applied
- Preference: Import specific files for clarity in most cases

**Feature Structure (Clean Architecture):**
```
lib/features/<feature_name>/
├── domain/
│   ├── entities/          # Immutable with @freezed, no fromJson
│   ├── repositories/      # Abstract interfaces only
│   └── usecases/          # Single-purpose, extends UseCase<T, Params>
├── data/
│   ├── models/            # @freezed with fromJson/toJson, toEntity() method
│   ├── datasources/       # Local (Hive) & Remote (Supabase)
│   └── repositories/      # Implements domain interface, @LazySingleton
└── presentation/
    ├── bloc/              # @injectable, events/states use @freezed sealed
    ├── pages/             # Stateless or Stateful widgets
    └── widgets/           # Reusable UI components
```

## Immutability & Code Generation

**Freezed:**
- All entities, models, events, states use `@freezed`
- Entities: No JSON serialization
  ```dart
  @freezed
  abstract class Story with _$Story {
    const factory Story({
      required String id,
      required String title,
      // ...
    }) = _Story;

    const Story._();
  }
  ```
- Models: With JSON serialization
  ```dart
  @freezed
  abstract class StoryModel with _$StoryModel {
    const factory StoryModel({
      required String id,
      required String title,
      // ...
    }) = _StoryModel;

    const StoryModel._();

    factory StoryModel.fromJson(Map<String, dynamic> json) =>
        _$StoryModelFromJson(json);

    Story toEntity() { ... }
  }
  ```
- Events/States: Sealed classes
  ```dart
  @freezed
  sealed class HomeEvent with _$HomeEvent {
    const factory HomeEvent.loadHome() = _LoadHome;
    const factory HomeEvent.refresh() = _Refresh;
  }
  ```

**Injectable:**
- Use cases: `@lazySingleton`
- Repositories: `@LazySingleton(as: InterfaceType)`
- BLoC: `@injectable` (transient)
- Datasources: `@LazySingleton(as: InterfaceType)`
- Entry point: `lib/core/di/injection_container.dart`

**Code Generation Commands:**
```bash
# Full build (after modifying @freezed, @injectable, routes, or i18n)
dart run build_runner build --delete-conflicting-outputs

# Watch mode
dart run build_runner watch --delete-conflicting-outputs

# Translations only
dart run slang
```

## Internationalization (i18n)

**Framework:** Slang v4.11.1 with `double_braces` interpolation

**Translation Files:**
- Location: `lib/i18n/strings_<locale>.i18n.json`
- Locales: `en`, `hi`, `ta`, `te`
- Generated: `lib/i18n/strings.g.dart`

**Usage Pattern:**
```dart
import 'package:myitihas/i18n/strings.g.dart';

// In widget
Text(context.t.home.greeting)
Text(context.t.stories.count(n: stories.length))

// Outside widget context
import 'package:myitihas/i18n/strings.g.dart';
final text = t.someKey.anotherKey;
```

**Interpolation:**
```json
{
  "greeting": "Hello {{name}}!",
  "count": "Found {{n}} stories"
}
```

**Config (`slang.yaml`):**
```yaml
base_locale: en
fallback_strategy: base_locale
string_interpolation: double_braces
key_case: camel
param_case: camel
```

## Routing

**Framework:** `go_router` v17.0.1 with `go_router_builder` for type-safe routes

**Route Definition:**
```dart
@TypedGoRoute<HomeRoute>(path: '/home')
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomePage();
  }
}
```

**Navigation:**
```dart
// Type-safe
const HomeRoute().go(context);
const StoryDetailRoute(storyId: '123').push(context);

// String-based
context.go('/home');
context.push('/stories/123');
```

**Config:** `lib/config/routes.dart` with generated `routes.g.dart`

## Dependency Injection

**Framework:** `injectable` v2.7.1 + `get_it` v9.2.0

**Registration:**
```dart
@injectable          // Transient (new instance each time)
@lazySingleton       // Lazy singleton
@LazySingleton(as: Interface)  // Singleton with interface binding

// Third-party
@module
abstract class ThirdPartyModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  SupabaseClient get supabaseClient => SupabaseService.client;
}
```

**Usage:**
```dart
import 'package:myitihas/core/di/injection_container.dart';

// In widget
BlocProvider(
  create: (context) => getIt<HomeBloc>()..add(const HomeEvent.loadHome()),
  child: const _HomeScreenView(),
)

// In class
@injectable
class StoriesBloc extends Bloc<StoriesEvent, StoriesState> {
  final GetStories getStories;
  final ToggleFavorite toggleFavorite;

  StoriesBloc({required this.getStories, required this.toggleFavorite})
    : super(const StoriesState.initial()) { ... }
}
```

**Setup:** `await configureDependencies()` in `main.dart` before `runApp()`

## State Management

**Pattern:** BLoC (flutter_bloc v9.1.1)

**Structure:**
- `*_bloc.dart`: Main BLoC class with event handlers
- `*_event.dart`: Freezed sealed class for events
- `*_state.dart`: Freezed class for state (union or single state)

**Event Pattern:**
```dart
@freezed
sealed class StoriesEvent with _$StoriesEvent {
  const factory StoriesEvent.loadStories() = _LoadStories;
  const factory StoriesEvent.searchStories(String query) = _SearchStories;
}
```

**State Patterns:**
- Union states (multiple variants):
  ```dart
  @freezed
  sealed class StoriesState with _$StoriesState {
    const factory StoriesState.initial() = _Initial;
    const factory StoriesState.loading() = _Loading;
    const factory StoriesState.loaded({required List<Story> stories}) = _Loaded;
    const factory StoriesState.error(String message) = _Error;
  }
  ```
- Single state with flags:
  ```dart
  @freezed
  abstract class HomeState with _$HomeState {
    const factory HomeState({
      @Default(false) bool isLoading,
      @Default([]) List<Story> stories,
      String? errorMessage,
    }) = _HomeState;
  }
  ```

**BLoC Handler Pattern:**
```dart
@injectable
class StoriesBloc extends Bloc<StoriesEvent, StoriesState> {
  final GetStories getStories;

  StoriesBloc({required this.getStories})
    : super(const StoriesState.initial()) {
    on<StoriesEvent>((event, emit) async {
      await event.when(
        loadStories: () => _onLoadStories(emit),
        searchStories: (query) => _onSearchStories(query, emit),
      );
    });
  }

  Future<void> _onLoadStories(Emitter<StoriesState> emit) async {
    emit(const StoriesState.loading());
    final result = await getStories(GetStoriesParams());

    result.fold(
      (failure) => emit(StoriesState.error(failure.message)),
      (stories) => emit(StoriesState.loaded(stories: stories)),
    );
  }
}
```

## Styling & Theming

**Framework:** Material Design with custom theme

**Setup:**
- Theme config: `lib/config/theme/app_theme.dart`
- Color schemes: `lib/config/theme/color_schemes.dart`
- Text theme: `lib/config/theme/text_theme.dart`
- Component themes: `lib/config/theme/component_themes.dart`

**Fonts:** Google Fonts (google_fonts v6.3.3)

**Responsive:** `flutter_screenutil` v5.9.3 for responsive sizing
```dart
height: 120.h,
width: 100.w,
fontSize: 16.sp,
```

**Gradients:** Custom extension in `lib/config/theme/gradient_extension.dart`

**Pattern:**
```dart
// Access theme
final theme = Theme.of(context);
final colorScheme = theme.colorScheme;

// Use context extensions
context.t.home.greeting  // i18n
```

---

*Convention analysis: 2026-01-28*
