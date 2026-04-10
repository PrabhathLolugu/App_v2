# Architecture

**Analysis Date:** 2026-01-28

## Pattern Overview

**Overall:** Clean Architecture + Domain-Driven Design (DDD)

**Key Characteristics:**
- Strict separation of domain, data, and presentation layers per feature
- Offline-first architecture with Hive local storage and Supabase backend
- Dependency inversion via abstract repository contracts
- Unidirectional data flow using BLoC pattern
- Error handling with Either type from fpdart

## Layers

**Domain Layer:**
- Purpose: Pure business logic with no external dependencies
- Location: `lib/features/<feature>/domain/`
- Contains: Entities (freezed), Repository interfaces, Use cases
- Depends on: Nothing (pure Dart)
- Used by: Data layer (implements contracts), Presentation layer (via use cases)

**Data Layer:**
- Purpose: Data access and persistence logic
- Location: `lib/features/<feature>/data/`
- Contains: Models (freezed + JSON/Hive), DataSources (local/remote), Repository implementations
- Depends on: Domain layer contracts, External SDKs (Supabase, Hive)
- Used by: Domain layer use cases (via dependency injection)

**Presentation Layer:**
- Purpose: UI and user interaction logic
- Location: `lib/features/<feature>/presentation/`
- Contains: BLoCs (state management), Pages (screens), Widgets (components)
- Depends on: Domain layer (use cases, entities), flutter_bloc
- Used by: Router configuration in `lib/config/routes.dart`

**Core Layer:**
- Purpose: Shared infrastructure and utilities
- Location: `lib/core/`
- Contains: DI setup, Error types, Network utilities, Base UseCase interface, Logging
- Depends on: Nothing
- Used by: All layers

**Services Layer:**
- Purpose: Global singleton services outside Clean Architecture
- Location: `lib/services/`
- Contains: SupabaseService, AuthService, ProfileService, ChatService, RealtimeService
- Depends on: Supabase SDK
- Used by: All layers directly via static/singleton access

## Data Flow

**User Action to State Update:**

1. User interacts with Widget in Presentation layer
2. Widget dispatches Event to BLoC
3. BLoC calls UseCase with parameters
4. UseCase calls Repository contract method
5. Repository implementation queries DataSource (local Hive or remote Supabase)
6. DataSource returns Model objects
7. Repository maps Models to Entities, wraps in Either<Failure, T>
8. UseCase returns Either to BLoC
9. BLoC emits new State with Entities
10. Widget rebuilds based on new State

**State Management:**
- BLoC pattern via flutter_bloc for all feature state
- Events and States are freezed sealed classes
- Global theme state managed by ThemeBloc
- Real-time updates via RealtimeService subscriptions

## Key Abstractions

**UseCase:**
- Purpose: Single-responsibility business operation
- Examples: `lib/features/stories/domain/usecases/get_stories.dart`, `lib/features/story_generator/domain/usecases/generate_story.dart`
- Pattern: Implements `UseCase<ReturnType, Params>`, returns `Future<Either<Failure, ReturnType>>`

**Repository:**
- Purpose: Abstract data access contract
- Examples: `lib/features/stories/domain/repositories/story_repository.dart`
- Pattern: Interface in domain, implementation in data layer with `@LazySingleton(as: Interface)`

**Entity:**
- Purpose: Immutable domain model
- Examples: `lib/features/stories/domain/entities/story.dart`, `lib/features/social/domain/entities/user.dart`
- Pattern: Freezed classes with no fromJson/toJson methods

**Model:**
- Purpose: Data transfer object with serialization
- Examples: `lib/features/stories/data/models/story_model.dart`
- Pattern: Freezed with fromJson/toJson, Hive annotations, toDomain()/toEntity() converter

**DataSource:**
- Purpose: Single-responsibility data access
- Examples: `lib/features/stories/data/datasources/story_local_data_source.dart`, `lib/features/story_generator/data/datasources/remote_story_generator_datasource.dart`
- Pattern: Abstract interface with concrete LocalDataSource (Hive) and RemoteDataSource (Supabase) implementations

## Entry Points

**Application Entry:**
- Location: `lib/main.dart`
- Triggers: Flutter framework runApp
- Responsibilities: Initialize Hive, configure DI (get_it), initialize Supabase, setup router, start deep link listener

**Dependency Injection:**
- Location: `lib/core/di/injection_container.dart`
- Triggers: `configureDependencies()` called in main
- Responsibilities: Auto-register all @injectable/@lazySingleton classes via code generation, register third-party modules (SharedPreferences, SupabaseClient, Talker)

**Router:**
- Location: `lib/config/routes.dart`
- Triggers: MaterialApp.router with MyItihasRouter instance
- Responsibilities: Type-safe routing with @TypedGoRoute annotations, auth-based redirects, password recovery flow handling

**Supabase Initialization:**
- Location: `lib/services/supabase_service.dart`
- Triggers: `SupabaseService.initialize()` in main before runApp
- Responsibilities: Initialize Supabase client, setup AuthService singleton, register refresh stream for router

## Error Handling

**Strategy:** Railway-oriented programming with Either type

**Patterns:**
- Data layer throws AppException subtypes (ServerException, CacheException, NetworkException)
- Repository catches exceptions, returns Left(Failure subtype)
- Use cases return `Future<Either<Failure, T>>` to BLoC
- BLoC pattern matches on Either, emits success or error states
- Exceptions defined in `lib/core/errors/exceptions.dart`
- Failures defined in `lib/core/errors/failures.dart`

**Example Flow:**
```dart
// DataSource throws
throw CacheException('Failed to load from Hive');

// Repository catches and converts
try {
  final data = await dataSource.getData();
  return Right(data.toDomain());
} on CacheException catch (e) {
  return Left(CacheFailure(e.message));
}

// BLoC handles
result.fold(
  (failure) => emit(State.error(failure.message)),
  (data) => emit(State.loaded(data)),
);
```

## Cross-Cutting Concerns

**Logging:**
- Global `talker` instance from `lib/core/logging/talker_setup.dart`
- Usage: `talker.info()`, `talker.error()`, `talker.good()`
- BlocObserver integrated for automatic event/state logging

**Validation:**
- Domain entities enforce invariants via freezed constructors
- Form validation in presentation widgets
- Server-side validation via Supabase functions

**Authentication:**
- AuthService singleton in `lib/services/auth_service.dart`
- Session state via SupabaseService.getCurrentSession()
- Router redirects based on auth state
- Deep link handling for password recovery

**Code Generation:**
- Freezed for immutable classes (entities, models, events, states)
- Injectable for dependency injection
- Build runner for JSON serialization and routing
- Hive type adapters for local storage
- Slang for internationalization

**Offline-First:**
- Primary data source is Hive local storage
- Background sync with Supabase when online
- NetworkInfo checks connectivity
- Repository pattern abstracts online/offline logic

---

*Architecture analysis: 2026-01-28*
