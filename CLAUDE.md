# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MyItihas is a Flutter mobile app for cultural/historical stories from Indian scriptures. Features include social feeds, chat, AI story generation, and map features. Uses **Supabase** backend with offline-first local storage via **Hive**.

## Essential Commands

```bash
# Install dependencies
flutter pub get

# Code generation (CRITICAL - run after modifying @freezed, @injectable, routes, i18n, or .env)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for code generation
dart run build_runner watch --delete-conflicting-outputs

# Generate translations only
dart run slang

# Run app
flutter run

# Analyze code
flutter analyze

# Run tests
flutter test
```

## Environment Variables (Envied)

Sensitive configuration is managed using the `envied` package with obfuscation enabled.

### Setup (Required for first-time setup)
1. Copy `.env.example` to `.env` in the project root
2. Fill in your Supabase credentials:
   ```
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your-anon-key
   ```
3. Run code generation: `dart run build_runner build --delete-conflicting-outputs`

### How It Works
- Environment variables are defined in `.env` (git-ignored)
- The `Env` class in `lib/core/config/env.dart` provides type-safe access
- Generated code (`env.g.dart`) uses XOR obfuscation to prevent easy extraction from compiled binaries
- Access secrets via `Env.supabaseUrl` and `Env.supabaseAnonKey`

### Important Notes
- NEVER commit `.env` or `env.g.dart` to version control
- When `.env` changes, regenerate code with `dart run build_runner clean && dart run build_runner build --delete-conflicting-outputs`

## Architecture: Clean Architecture + DDD

### Feature Structure
```
lib/features/<feature_name>/
├── domain/           # Pure Dart, NO external dependencies
│   ├── entities/     # Immutable with @freezed (no fromJson)
│   ├── repositories/ # Abstract contracts only
│   └── usecases/     # Single-purpose, extends UseCase<T, Params>
├── data/
│   ├── models/       # @freezed with fromJson/toJson, toDomain() method
│   ├── datasources/  # Local (Hive) & Remote (Supabase) implementations
│   └── repositories/ # Implements domain interface, handles Either<Failure, T>
└── presentation/
    ├── bloc/         # @injectable, events/states use @freezed sealed classes
    ├── pages/
    └── widgets/
```

### Key Patterns

**Use Cases** - Always return `Future<Either<Failure, T>>` using fpdart:
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

**BLoC Events/States** - Use freezed sealed classes:
```dart
@freezed
sealed class StoriesEvent with _$StoriesEvent {
  const factory StoriesEvent.loadStories() = _LoadStories;
  const factory StoriesEvent.searchStories(String query) = _SearchStories;
}
```

**Error Handling** - Throw `AppException` subtypes in data layer → catch and return `Failure` subtypes from `lib/core/errors/`

## Dependency Injection

Uses **injectable** + **get_it** with auto-registration:
- `@injectable` (transient), `@lazySingleton`, `@LazySingleton(as: Interface)`
- Entry point: `lib/core/di/injection_container.dart`
- Third-party deps registered in `ThirdPartyModule`

## Internationalization (Slang)

- Translation files: `lib/i18n/strings_<locale>.i18n.json` (en, hi, ta, te)
- Uses `double_braces` interpolation: `{{name}}`
- Access: `context.t.key` or import `strings.g.dart` → `t.key`
- Config: `slang.yaml`

## Routing (go_router + TypedGoRoute)

Routes defined in `lib/config/routes.dart` using `@TypedGoRoute` annotations:
```dart
const HomeRoute().go(context)  // or context.go('/home')
```

## Logging

Use global `talker` instance from `lib/core/logging/talker_setup.dart`:
```dart
talker.info('Loading stories...');
talker.error('Failed to load', exception, stackTrace);
talker.warning('Possible issue detected');
```

## Supabase Edge Functions

Located in `supabase/functions/`. Deploy with:
```bash
supabase functions deploy <function-name>
```

Set secrets:
```bash
supabase secrets set OPENROUTER_API_KEY=your_key
```

### FCM Push Notifications Setup

The `send-push-notification` edge function requires Firebase credentials:

```bash
# Set Firebase project ID
supabase secrets set FIREBASE_PROJECT_ID=myitihas-app

# Set Firebase service account JSON (get from Firebase Console > Project Settings > Service Accounts)
supabase secrets set FIREBASE_SERVICE_ACCOUNT_JSON='{"type":"service_account",...}'
```

Database app settings (required for FCM trigger):
```sql
-- In Supabase SQL Editor or migrations
ALTER DATABASE postgres SET app.settings.supabase_url = 'https://your-project.supabase.co';
ALTER DATABASE postgres SET app.settings.service_role_key = 'your-service-role-key';
```

Deploy FCM function:
```bash
supabase functions deploy send-push-notification
```

Apply FCM migrations:
```bash
supabase db push
```

## File Naming Conventions

- Entities: `story.dart` → generates `story.freezed.dart`
- Models: `story_model.dart` → generates `*.freezed.dart`, `*.g.dart`
- BLoC: `stories_bloc.dart`, `stories_event.dart`, `stories_state.dart`
- Pages: `story_detail_page.dart`

## Core Layer Structure

```
lib/core/
├── config/              # Environment configuration (Envied)
├── di/                  # Dependency injection setup
├── errors/              # exceptions.dart, failures.dart
├── logging/             # talker_setup.dart
├── usecases/            # Base UseCase interface
├── network/             # Network info
└── storage/             # Hive setup
```

## Services Layer

Global services in `lib/services/` (not Clean Architecture features):
- `SupabaseService`: Static singleton, initialize in main before runApp
- `AuthService`: Handles auth flows, deep links
- `ProfileService`, `FollowService`: Social features
- `FCMService`: Push notifications via Firebase Cloud Messaging
- `NotificationService`: In-app notification management
