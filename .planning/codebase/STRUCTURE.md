# Codebase Structure

**Analysis Date:** 2026-01-28

## Directory Layout

```
MyItihas/
├── lib/
│   ├── core/                    # Shared infrastructure
│   ├── config/                  # App-wide configuration
│   ├── features/                # Feature modules (Clean Architecture)
│   ├── services/                # Global singleton services
│   ├── utils/                   # Shared utilities
│   ├── models/                  # Legacy shared models
│   ├── pages/                   # Legacy pages (pre-feature migration)
│   ├── i18n/                    # Internationalization (slang)
│   ├── main.dart                # Application entry point
│   └── hive_registrar.g.dart    # Generated Hive adapters
├── supabase/                    # Backend infrastructure
│   └── functions/               # Edge functions
├── test/                        # Unit and widget tests
├── docs/                        # Documentation
└── [platform dirs]              # android/, ios/, web/, etc.
```

## Directory Purposes

**lib/core/**
- Purpose: Shared infrastructure and base abstractions
- Contains: DI setup, error types, network utilities, base use case, logging, storage service
- Key files:
  - `lib/core/di/injection_container.dart` - Dependency injection configuration
  - `lib/core/errors/exceptions.dart` - AppException hierarchy
  - `lib/core/errors/failures.dart` - Failure types for Either
  - `lib/core/usecases/usecase.dart` - Base UseCase interface
  - `lib/core/logging/talker_setup.dart` - Global talker instance
  - `lib/core/storage/hive_service.dart` - Hive box management
  - `lib/core/network/network_info.dart` - Connectivity checking

**lib/config/**
- Purpose: Application-wide configuration
- Contains: Routing, theming, app constants
- Key files:
  - `lib/config/routes.dart` - TypedGoRoute definitions
  - `lib/config/routes.g.dart` - Generated routing code
  - `lib/config/theme/app_theme.dart` - Light/dark theme configuration
  - `lib/config/go_router_refresh.dart` - Router refresh stream

**lib/features/<feature>/**
- Purpose: Isolated feature modules following Clean Architecture
- Contains: domain/, data/, presentation/ subdirectories per feature
- Feature modules:
  - `lib/features/stories/` - Story browsing and detail
  - `lib/features/story_generator/` - AI story generation
  - `lib/features/social/` - Social feed, posts, profiles
  - `lib/features/chat/` - Real-time messaging
  - `lib/features/home/` - Home screen, activity history
  - `lib/features/notifications/` - Notification system

**lib/features/<feature>/domain/**
- Purpose: Pure business logic for a feature
- Contains:
  - `entities/` - Freezed immutable domain models (no JSON)
  - `repositories/` - Abstract repository interfaces
  - `usecases/` - Single-purpose business operations
- Example: `lib/features/stories/domain/entities/story.dart`, `lib/features/stories/domain/usecases/get_stories.dart`

**lib/features/<feature>/data/**
- Purpose: Data access and persistence
- Contains:
  - `models/` - Freezed models with JSON/Hive serialization
  - `datasources/` - Local (Hive) and remote (Supabase) data sources
  - `repositories/` - Repository implementations
- Example: `lib/features/stories/data/models/story_model.dart`, `lib/features/stories/data/repositories/story_repository_impl.dart`

**lib/features/<feature>/presentation/**
- Purpose: UI and state management
- Contains:
  - `bloc/` - BLoC state management (events, states, blocs)
  - `pages/` - Full-screen UI components
  - `widgets/` - Reusable UI components
  - `utils/` - Feature-specific UI utilities (optional)
- Example: `lib/features/stories/presentation/bloc/stories_bloc.dart`, `lib/features/stories/presentation/pages/story_detail_page.dart`

**lib/services/**
- Purpose: Global singleton services outside Clean Architecture
- Contains: Static/singleton services for backend integration
- Key files:
  - `lib/services/supabase_service.dart` - Supabase client wrapper
  - `lib/services/auth_service.dart` - Authentication flows
  - `lib/services/profile_service.dart` - User profile management
  - `lib/services/chat_service.dart` - Real-time chat operations
  - `lib/services/realtime_service.dart` - Supabase realtime subscriptions
  - `lib/services/notification_service.dart` - Push notifications

**lib/i18n/**
- Purpose: Internationalization using slang
- Contains: Translation JSON files and generated code
- Files:
  - `lib/i18n/strings_en.i18n.json` - English translations
  - `lib/i18n/strings_hi.i18n.json` - Hindi translations
  - `lib/i18n/strings_ta.i18n.json` - Tamil translations
  - `lib/i18n/strings_te.i18n.json` - Telugu translations
  - `lib/i18n/strings.g.dart` - Generated translation access

**lib/pages/**
- Purpose: Legacy pages not yet migrated to features
- Contains: Original page implementations
- Status: Gradually being migrated to feature modules
- Example: `lib/pages/home_page.dart`, `lib/pages/discover_page.dart`

**lib/utils/**
- Purpose: Shared utilities across features
- Contains: Helper functions, extensions, constants
- Example: `lib/utils/theme.dart`

**lib/models/**
- Purpose: Legacy shared models
- Contains: Models used before feature-based organization
- Status: Being migrated to feature modules

**supabase/functions/**
- Purpose: Serverless edge functions
- Contains: Deno-based backend logic
- Example: `supabase/functions/generate-story/` - AI story generation endpoint

## Key File Locations

**Entry Points:**
- `lib/main.dart`: Application initialization and runApp

**Configuration:**
- `pubspec.yaml`: Dependencies and assets
- `slang.yaml`: i18n configuration
- `lib/config/routes.dart`: Route definitions

**Core Logic:**
- `lib/core/di/injection_container.dart`: Dependency injection
- `lib/core/usecases/usecase.dart`: Base use case interface
- `lib/core/errors/failures.dart`: Error handling types

**Testing:**
- `test/`: Unit and widget tests (co-located with lib structure)

## Naming Conventions

**Files:**
- Entities: `story.dart` → generates `story.freezed.dart`
- Models: `story_model.dart` → generates `story_model.freezed.dart` + `story_model.g.dart`
- BLoC: `stories_bloc.dart`, `stories_event.dart`, `stories_state.dart`
- Pages: `story_detail_page.dart`
- Widgets: `story_card_widget.dart` or `story_card.dart`
- Repositories: Interface `story_repository.dart`, Implementation `story_repository_impl.dart`
- DataSources: `story_local_data_source.dart`, `story_remote_data_source.dart`
- Use cases: `get_stories.dart`, `toggle_favorite.dart`

**Directories:**
- Features: Lowercase with underscores (e.g., `story_generator`)
- Clean Architecture layers: Lowercase (e.g., `domain`, `data`, `presentation`)
- BLoC subdirectory: `bloc/` within presentation

**Classes:**
- Entities: PascalCase (e.g., `Story`, `StoryAttributes`)
- Models: PascalCase with Model suffix (e.g., `StoryModel`)
- BLoCs: PascalCase with Bloc suffix (e.g., `StoriesBloc`)
- Events: Sealed freezed class (e.g., `StoriesEvent`)
- States: Freezed class (e.g., `StoriesState`)
- Repositories: PascalCase with Repository suffix (e.g., `StoryRepository`)
- Use cases: PascalCase describing action (e.g., `GetStories`)

## Where to Add New Code

**New Feature:**
- Primary code: `lib/features/<feature_name>/`
- Create subdirectories: `domain/`, `data/`, `presentation/`
- Register route in `lib/config/routes.dart`
- Tests: `test/features/<feature_name>/`

**New Use Case:**
- Implementation: `lib/features/<feature>/domain/usecases/<action>.dart`
- Implements: `UseCase<ReturnType, Params>`
- Register: Annotate with `@lazySingleton` or `@injectable`

**New Entity:**
- Domain entity: `lib/features/<feature>/domain/entities/<entity>.dart`
- Use `@freezed` annotation, no JSON serialization
- Data model: `lib/features/<feature>/data/models/<entity>_model.dart`
- Use `@freezed` with `fromJson`/`toJson`, add `toEntity()` method

**New BLoC:**
- BLoC: `lib/features/<feature>/presentation/bloc/<feature>_bloc.dart`
- Event: `lib/features/<feature>/presentation/bloc/<feature>_event.dart`
- State: `lib/features/<feature>/presentation/bloc/<feature>_state.dart`
- Annotate BLoC with `@injectable`

**New Page:**
- Page: `lib/features/<feature>/presentation/pages/<page_name>_page.dart`
- Route: Add `@TypedGoRoute` in `lib/config/routes.dart`
- Run: `dart run build_runner build --delete-conflicting-outputs`

**New Widget:**
- Reusable component: `lib/features/<feature>/presentation/widgets/<widget_name>.dart`
- Shared across features: `lib/utils/widgets/<widget_name>.dart` (if truly shared)

**New Service:**
- Global service: `lib/services/<service_name>_service.dart`
- Pattern: Static singleton or injectable
- Initialize in `lib/main.dart` if needed before runApp

**New Repository:**
- Interface: `lib/features/<feature>/domain/repositories/<entity>_repository.dart`
- Implementation: `lib/features/<feature>/data/repositories/<entity>_repository_impl.dart`
- Annotate implementation with `@LazySingleton(as: InterfaceType)`

**New DataSource:**
- Local: `lib/features/<feature>/data/datasources/<entity>_local_data_source.dart`
- Remote: `lib/features/<feature>/data/datasources/<entity>_remote_data_source.dart`
- Annotate with `@lazySingleton`

**Utilities:**
- Shared helpers: `lib/utils/<utility_name>.dart`
- Core utilities: `lib/core/<category>/<utility_name>.dart`

**Translations:**
- Add keys to: `lib/i18n/strings_<locale>.i18n.json`
- Run: `dart run slang`
- Access: `context.t.key` or `t.key`

## Special Directories

**build/**
- Purpose: Build artifacts
- Generated: Yes (by flutter build)
- Committed: No

**.dart_tool/**
- Purpose: Dart tooling metadata
- Generated: Yes
- Committed: No

**Generated Files:**
- Purpose: Code generation output
- Patterns: `*.g.dart`, `*.freezed.dart`, `routes.g.dart`, `hive_registrar.g.dart`
- Generated: Yes (by build_runner)
- Committed: Yes (for routes/hive, team preference)
- Regenerate: `dart run build_runner build --delete-conflicting-outputs`

**supabase/.temp/**
- Purpose: Supabase local development temp files
- Generated: Yes
- Committed: No

**Platform Directories:**
- `android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/`
- Purpose: Platform-specific native code and configuration
- Generated: Partially (flutter create)
- Committed: Yes

---

*Structure analysis: 2026-01-28*
