# MyItihas AI Coding Instructions

## Project Overview
Flutter mobile app for cultural/historical stories from Indian scriptures. Features social feeds, chat, AI story generation, and maps. Backend: **Supabase** with offline-first local storage via **Brick**.

## Essential Commands
```bash
# CRITICAL: Run after modifying @freezed, @injectable, routes, or i18n files
dart run build_runner build --delete-conflicting-outputs

# Generate translations only
dart run slang

# Standard workflow
flutter pub get && flutter run
```

## Architecture: Clean Architecture + DDD

### Feature Structure (`lib/features/<feature>/`)
- **domain/entities/** - Pure Dart `@freezed` classes (NO `fromJson`)
- **domain/repositories/** - Abstract contracts only
- **domain/usecases/** - Single-purpose, extend `UseCase<T, Params>`, return `Future<Either<Failure, T>>`
- **data/models/** - `@freezed` with `fromJson`/`toJson` + `toEntity()` method
- **data/repositories/** - Implements domain interface, handles `Either<Failure, T>`
- **presentation/bloc/** - `@injectable`, events/states use `@freezed sealed class`

### UseCase Pattern
```dart
@lazySingleton
class GetStories implements UseCase<List<Story>, GetStoriesParams> {
  final StoryRepository repository;
  GetStories(this.repository);
  
  @override
  Future<Either<Failure, List<Story>>> call(GetStoriesParams params) async {
    return await repository.getStories(...);
  }
}
```

### BLoC Events/States Pattern
```dart
@freezed
sealed class StoriesEvent with _$StoriesEvent {
  const factory StoriesEvent.loadStories() = _LoadStories;
}
```

## Error Handling
- **Data layer**: Throw `AppException` subtypes from `lib/core/errors/exceptions.dart`
- **Repository layer**: Catch exceptions, return `Failure` subtypes from `lib/core/errors/failures.dart`
- Always use `Either<Failure, T>` from `fpdart` for result handling

## Dependency Injection
- Uses **injectable** + **get_it** with auto-registration
- Entry point: [lib/core/di/injection_container.dart](lib/core/di/injection_container.dart)
- Annotations: `@injectable`, `@lazySingleton`, `@LazySingleton(as: Interface)`
- Third-party deps in `ThirdPartyModule`

## Internationalization (Slang)
- Files: `lib/i18n/<locale>.i18n.json` (en, hi, ta, te)
- Interpolation: `{{name}}` (double braces)
- Access: `context.t.key` or `t.key`
- Run `dart run slang` after modifying translation files

## Routing (go_router + TypedGoRoute)
- Routes: [lib/config/routes.dart](lib/config/routes.dart)
- Usage: `const HomeRoute().go(context)` or `context.go('/home')`

## Logging
```dart
talker.info('Loading...');
talker.error('Failed', exception, stackTrace);
talker.good('Success');
```

## Key Directories
- `lib/core/` - DI, errors, logging, base usecase, network
- `lib/services/` - Global services (Supabase, Auth, Profile, Follow)
- `lib/brick/` - Brick ORM adapters for offline-first sync
- `supabase/functions/` - Edge Functions (deploy: `supabase functions deploy <name>`)

## File Naming
- Entities: `story.dart` → `story.freezed.dart`
- Models: `story_model.dart` → `*.freezed.dart`, `*.g.dart`
- BLoC: `stories_bloc.dart`, `stories_event.dart`, `stories_state.dart`
- Pages: `story_detail_page.dart`
