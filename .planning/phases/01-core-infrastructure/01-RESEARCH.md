# Phase 1: Core Infrastructure - Research

**Researched:** 2026-01-28
**Domain:** Flutter offline-first persistence with Brick and Supabase
**Confidence:** HIGH

## Summary

Phase 1 establishes the foundation for migrating MyItihas from Hive to Brick's offline-first architecture with Supabase integration. The core task is initializing a singleton `MyItihasRepository` that coordinates SQLite local storage with Supabase backend, configured before app startup.

Brick provides a proven pattern for Flutter offline-first apps: **SQLite-first queries** with automatic Supabase sync and an **offline request queue** that retries failed network operations. The `brick_offline_first_with_supabase` package (v2.1.0) offers first-class Supabase integration with built-in realtime subscriptions and code-generated adapters.

Key architectural insight: Brick repositories follow a **configure-once, access-globally** pattern where initialization happens in `main.dart` before `runApp()`, similar to the existing `SupabaseService.initialize()` pattern already used in MyItihas. The repository becomes the single source of truth for all data access, replacing the current Hive datasources.

**Primary recommendation:** Initialize `MyItihasRepository` singleton immediately after Hive init and before dependency injection configuration, ensuring the repository is available when injectable tries to register datasources. Use the `clientQueue()` helper to automatically configure the HTTP client with offline queueing capabilities.

## Standard Stack

The established libraries/tools for Brick offline-first with Supabase:

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| brick_offline_first_with_supabase | ^2.1.0 | Core offline-first repository with Supabase integration | Official Brick package for Supabase, maintained by GetDutchie |
| sqflite | ^2.4.2 | SQLite database for Flutter | Already in project, required by Brick for databaseFactory |
| supabase_flutter | ^2.5.6 | Supabase client | Already in project, Brick wraps this for offline-first behavior |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| brick_offline_first_with_supabase_build | ^2.1.0 | Code generation for models and adapters | Dev dependency, required for build_runner |
| build_runner | ^2.10.4 | Code generation orchestrator | Already in project, triggers Brick codegen |
| path | latest | Path manipulation for database location | Already transitive via sqflite |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Brick | Drift (formerly Moor) | Drift has better SQL type safety but no built-in Supabase integration, would require manual sync logic |
| Brick | Isar + manual Supabase sync | Isar is faster but requires custom offline queue and realtime subscription logic |
| Brick offline queue | Supabase client directly | Loses offline queueing, app would fail immediately when offline |

**Installation:**
```bash
# Add to pubspec.yaml dependencies
brick_offline_first_with_supabase: ^2.1.0

# Add to dev_dependencies
brick_offline_first_with_supabase_build: ^2.1.0

# Run to install
flutter pub get

# Generate code after models are created
dart run build_runner build --delete-conflicting-outputs
```

## Architecture Patterns

### Recommended Project Structure
```
lib/
├── brick/                          # Brick-generated files
│   ├── brick.g.dart                # Model dictionaries (generated)
│   ├── db/
│   │   └── schema.g.dart           # SQLite migrations (generated)
│   └── adapters/                   # Serialization adapters (generated)
│       ├── story_adapter.g.dart
│       └── user_adapter.g.dart
├── repository/
│   └── my_itihas_repository.dart   # Main Brick repository singleton
├── features/                       # Existing Clean Architecture
│   └── stories/
│       ├── domain/
│       │   └── entities/story.dart # Pure domain entity (no change)
│       ├── data/
│       │   ├── models/             # Will become Brick models (.model.dart)
│       │   └── repositories/       # Will call repository.get<Story>()
│       └── presentation/
└── core/
    └── di/
        └── injection_container.dart # Register repository in ThirdPartyModule
```

### Pattern 1: Repository Singleton Configuration
**What:** Static singleton with private constructor and configure() method
**When to use:** Required for Brick repositories to ensure single database connection
**Example:**
```dart
// Source: https://github.com/GetDutchie/brick/tree/main/packages/brick_offline_first_with_supabase
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:sqflite/sqflite.dart' show databaseFactory;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'brick/brick.g.dart'; // Generated

class MyItihasRepository extends OfflineFirstWithSupabaseRepository {
  static late MyItihasRepository _singleton;

  MyItihasRepository._({
    required super.supabaseProvider,
    required super.sqliteProvider,
    required super.migrations,
    required super.offlineRequestQueue,
  });

  static void configure({
    required String supabaseUrl,
    required String supabaseAnonKey,
  }) {
    // clientQueue helper creates HTTP client + offline queue
    final (client, queue) = OfflineFirstWithSupabaseRepository.clientQueue(
      databaseFactory: databaseFactory,
      ignorePaths: {'/auth/v1', '/storage/v1', '/functions/v1'}, // Don't queue these
    );

    _singleton = MyItihasRepository._(
      supabaseProvider: SupabaseProvider(
        SupabaseClient(supabaseUrl, supabaseAnonKey, httpClient: client),
        modelDictionary: supabaseModelDictionary, // Generated
      ),
      sqliteProvider: SqliteProvider(
        'myitihas.sqlite', // Database filename
        databaseFactory: databaseFactory,
        modelDictionary: sqliteModelDictionary, // Generated
      ),
      migrations: migrations, // Generated
      offlineRequestQueue: queue,
    );
  }

  static MyItihasRepository get instance => _singleton;
}
```

### Pattern 2: Initialization Order in main.dart
**What:** Sequence of async initializations before runApp()
**When to use:** Always - order matters for dependencies
**Example:**
```dart
// Source: Existing MyItihas main.dart + Brick documentation
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Logging (no dependencies)
  initTalker();
  talker.info('Starting MyItihas app...');

  Bloc.observer = createBlocObserver();

  // 2. Hive (will be removed in later phases, but keep for now)
  await initHive();

  // 3. BRICK REPOSITORY (new) - Initialize before DI
  MyItihasRepository.configure(
    supabaseUrl: 'https://xmbygaeixvzlyhbtkbnp.supabase.co',
    anonKey: 'your-anon-key',
  );
  talker.info('Brick repository initialized');

  // 4. Dependency Injection (can now access repository)
  await configureDependencies();
  talker.info('Dependencies configured');

  // 5. Translations
  LocaleSettings.useDeviceLocale();

  // 6. Supabase (already exists, keep as-is for auth)
  await SupabaseService.initialize(...);

  // 7. Other services
  final realtimeService = getIt<RealtimeService>();
  realtimeService.initialize();

  // 8. Router and app
  final router = MyItihasRouter().router;
  SupabaseService.authService.startDeepLinkListener();

  runApp(TranslationProvider(...));
}
```

### Pattern 3: Dependency Injection Registration
**What:** Register repository singleton in injectable ThirdPartyModule
**When to use:** To make repository available for injection into repositories/datasources
**Example:**
```dart
// Source: Context7 injectable documentation + existing injection_container.dart
@module
abstract class ThirdPartyModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  SupabaseClient get supabaseClient => SupabaseService.client;

  @lazySingleton
  Talker get logger => talker;

  // NEW: Register Brick repository
  @lazySingleton
  MyItihasRepository get repository => MyItihasRepository.instance;
}
```

### Pattern 4: Offline Queue Configuration
**What:** Configure which Supabase API paths should NOT be queued for retry
**When to use:** Always - prevents retrying auth/storage/functions requests
**Example:**
```dart
// Source: https://github.com/GetDutchie/brick/tree/main/packages/brick_offline_first_with_supabase
final (client, queue) = OfflineFirstWithSupabaseRepository.clientQueue(
  databaseFactory: databaseFactory,
  ignorePaths: {
    '/auth/v1',      // Don't retry auth requests (session already handled)
    '/storage/v1',   // Don't retry file uploads/downloads
    '/functions/v1', // Don't retry edge functions (story generation)
  },
);

// Empty set would queue everything (not recommended)
// ignorePaths: {},

// This aligns with user decision: "Disable offline writes — Clearer UX than silent queuing"
// Users see immediate feedback when offline instead of silent queue
```

### Anti-Patterns to Avoid
- **Multiple repository instances:** Never call `configure()` more than once or create multiple instances - causes database lock conflicts
- **Late initialization:** Don't initialize repository after `runApp()` or inside a widget - app will crash when trying to query
- **Forgetting databaseFactory import:** Must import from `sqflite` package exactly: `import 'package:sqflite/sqflite.dart' show databaseFactory;`
- **Using Supabase client directly:** After Brick is set up, always use `repository.get<T>()` instead of `SupabaseService.client.from()` for data models
- **Skipping code generation:** Repository won't compile without running `dart run build_runner build` first

## Don't Hand-Roll

Problems that look simple but have existing solutions:

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| HTTP client with offline retry | Custom queue with SharedPreferences | `OfflineFirstWithSupabaseRepository.clientQueue()` | Handles complex edge cases: request deduplication, exponential backoff, database corruption, memory pressure |
| SQLite migrations | Manual ALTER TABLE scripts | Brick's generated `migrations` | Automatically detects schema changes from model annotations, handles version conflicts, supports rollback |
| Model serialization | Hand-written fromJson/toJson | Brick code generation with `@ConnectOfflineFirstWithSupabase` | Generates bidirectional adapters for SQLite ↔ Supabase, handles type conversions, foreign keys, enums |
| Offline/online sync logic | if/else with NetworkInfo | Repository's automatic SQLite-first queries | Brick checks SQLite first, then Supabase, handles race conditions, prevents data loss |
| Database connection pooling | Singleton with manual mutex | sqflite's `databaseFactory` | Manages connection lifecycle, prevents SQLITE_BUSY errors, handles app backgrounding |

**Key insight:** Offline-first is deceptively complex. The "simple" approach of wrapping API calls with try/catch breaks down with: partial network failures, request reordering, database version conflicts, memory pressure during sync, and auth token expiration mid-sync. Brick's 6+ years of production use at GetDutchie (cannabis delivery, mission-critical inventory) has hardened these edge cases.

## Common Pitfalls

### Pitfall 1: Initializing Repository After DI Configuration
**What goes wrong:** `configureDependencies()` runs code generation that may try to reference the repository, causing null exceptions
**Why it happens:** Injectable scans all `@injectable` classes during configuration, some may have repository dependencies
**How to avoid:** Always call `MyItihasRepository.configure()` BEFORE `await configureDependencies()` in main.dart
**Warning signs:**
- Error: "LateInitializationError: Field '_singleton' has not been initialized"
- Error during DI configuration phase
- Repository works in some features but not others (initialization race condition)

### Pitfall 2: Missing databaseFactory Import
**What goes wrong:** Compilation error: "Undefined name 'databaseFactory'"
**Why it happens:** Must explicitly import from sqflite, not available globally
**How to avoid:** Add exact import at top of repository file: `import 'package:sqflite/sqflite.dart' show databaseFactory;`
**Warning signs:**
- Red underline in IDE under `databaseFactory` parameter
- Build fails with "Undefined name" error

### Pitfall 3: Forgetting to Run Build Runner
**What goes wrong:** Import errors for `brick.g.dart`, `schema.g.dart`, model dictionaries don't exist
**Why it happens:** Brick relies heavily on code generation, files don't exist until build_runner creates them
**How to avoid:** Run `dart run build_runner build --delete-conflicting-outputs` AFTER creating repository skeleton
**Warning signs:**
- Error: "Target of URI doesn't exist: 'brick/brick.g.dart'"
- Error: "Undefined name 'supabaseModelDictionary'"
- No `lib/brick/` directory exists

### Pitfall 4: Including Auth/Storage/Functions in Offline Queue
**What goes wrong:** Auth requests get queued and retried, causing duplicate login attempts or token refresh loops
**Why it happens:** Default ignorePaths may be empty or incorrectly configured
**How to avoid:** Always set `ignorePaths: {'/auth/v1', '/storage/v1', '/functions/v1'}` in clientQueue()
**Warning signs:**
- Multiple auth requests in network logs
- Users see "already logged in" errors
- File uploads happen twice
- Story generation (Edge Function) runs multiple times

### Pitfall 5: Supabase Client Mismatch
**What goes wrong:** Repository uses different SupabaseClient than SupabaseService, causing auth state mismatches
**Why it happens:** Creating new SupabaseClient in repository instead of reusing existing one
**How to avoid:** Pass same supabaseUrl/anonKey to both, or refactor to use single client initialization
**Warning signs:**
- User is authenticated in UI but repository queries return "not authenticated"
- RLS policies reject queries even when logged in
- Two Supabase instances in memory (check Flutter DevTools)

### Pitfall 6: Build Runner Formatting Conflicts
**What goes wrong:** Build fails with "formatter breaks lines after long class names"
**Why it happens:** Dart formatter splits long lines, confusing build_runner's code parser
**How to avoid:** Use shorter class names, or disable formatting for generated files
**Warning signs:**
- Build succeeds sometimes but fails after running `dart format`
- Error mentions "part directive" or "unexpected token"

## Code Examples

Verified patterns from official sources:

### Repository Skeleton (Before Models Exist)
```dart
// lib/repository/my_itihas_repository.dart
// Source: https://github.com/GetDutchie/brick/tree/main/packages/brick_offline_first_with_supabase
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:sqflite/sqflite.dart' show databaseFactory;
import 'package:supabase_flutter/supabase_flutter.dart';

// These will be generated after running build_runner
// Comment out initially, uncomment after first build
// import 'brick/brick.g.dart';

class MyItihasRepository extends OfflineFirstWithSupabaseRepository {
  static late MyItihasRepository _singleton;

  MyItihasRepository._({
    required super.supabaseProvider,
    required super.sqliteProvider,
    required super.migrations,
    required super.offlineRequestQueue,
  });

  static void configure({
    required String supabaseUrl,
    required String supabaseAnonKey,
  }) {
    final (client, queue) = OfflineFirstWithSupabaseRepository.clientQueue(
      databaseFactory: databaseFactory,
      ignorePaths: {'/auth/v1', '/storage/v1', '/functions/v1'},
    );

    _singleton = MyItihasRepository._(
      supabaseProvider: SupabaseProvider(
        SupabaseClient(supabaseUrl, supabaseAnonKey, httpClient: client),
        modelDictionary: {}, // Empty until models exist
      ),
      sqliteProvider: SqliteProvider(
        'myitihas.sqlite',
        databaseFactory: databaseFactory,
        modelDictionary: {}, // Empty until models exist
      ),
      migrations: {}, // Empty until models exist
      offlineRequestQueue: queue,
    );
  }

  static MyItihasRepository get instance => _singleton;
}
```

### Main.dart Integration
```dart
// lib/main.dart
// Source: Existing MyItihas main.dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initTalker();
  talker.info('Starting MyItihas app...');
  Bloc.observer = createBlocObserver();

  await initHive();

  // NEW: Initialize Brick repository
  MyItihasRepository.configure(
    supabaseUrl: 'https://xmbygaeixvzlyhbtkbnp.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
  );
  talker.info('Brick repository initialized');

  await configureDependencies();
  talker.info('Dependencies configured');

  LocaleSettings.useDeviceLocale();

  await SupabaseService.initialize(
    url: 'https://xmbygaeixvzlyhbtkbnp.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
  );

  final realtimeService = getIt<RealtimeService>();
  realtimeService.initialize();
  talker.info('RealtimeService initialized');

  final SharedPreferences storage = await SharedPreferences.getInstance();
  final GoRouter router = MyItihasRouter().router;
  SupabaseService.authService.startDeepLinkListener();

  runApp(
    TranslationProvider(
      child: BlocProvider<ThemeBloc>(
        create: (context) => ThemeBloc(storage: storage)..loadSavedTheme(),
        child: MyItihas(router: router),
      ),
    ),
  );
}
```

### Dependency Injection Module Update
```dart
// lib/core/di/injection_container.dart
// Source: Context7 injectable documentation
@module
abstract class ThirdPartyModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  SupabaseClient get supabaseClient => SupabaseService.client;

  @lazySingleton
  Talker get logger => talker;

  // NEW: Register Brick repository
  @lazySingleton
  MyItihasRepository get repository => MyItihasRepository.instance;
}
```

### Testing the Setup (Verification Script)
```dart
// test/repository_test.dart
// Source: Basic verification pattern
import 'package:flutter_test/flutter_test.dart';
import 'package:myitihas/repository/my_itihas_repository.dart';

void main() {
  test('Repository initializes successfully', () {
    MyItihasRepository.configure(
      supabaseUrl: 'https://test.supabase.co',
      anonKey: 'test-key',
    );

    final repo = MyItihasRepository.instance;
    expect(repo, isNotNull);
    expect(repo, isA<MyItihasRepository>());
  });
}
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Manual SQLite queries | Code-generated adapters | Brick 2.0 (2021) | Eliminates 90% of serialization boilerplate, reduces bugs |
| Custom HTTP retry logic | OfflineFirstRepository.clientQueue() | Brick 1.0 (2020) | Built-in exponential backoff, deduplication |
| Separate Supabase realtime | Integrated subscribeToRealtime<T>() | brick_offline_first_with_supabase 2.1.0 (2024) | Single API for all data access, auto-updates local SQLite |
| Nullable foreign keys | @Supabase(foreignKey: 'id') annotation | Current | Prevents over-fetching bug where null associations return all records |
| Manual schema versioning | Auto-generated migrations | Current | Detects model changes, generates ALTER TABLE scripts |

**Deprecated/outdated:**
- **OfflineFirstWithRestRepository**: Older pattern, use OfflineFirstWithSupabaseRepository for Supabase apps
- **Manual HTTP client configuration**: Old pattern passed custom client, use clientQueue() helper instead
- **Hive for caching + Supabase for backend**: Pattern MyItihas currently uses, replaced by Brick's unified offline-first approach

## Open Questions

Things that couldn't be fully resolved:

1. **Should we keep SupabaseService.initialize() or consolidate with Brick repository?**
   - What we know: SupabaseService is currently used for auth, and Brick creates its own SupabaseClient
   - What's unclear: Whether auth should go through Brick or stay separate
   - Recommendation: Keep SupabaseService for auth in Phase 1, evaluate consolidation in later phase after models are migrated. Auth flow is complex and shouldn't be changed alongside storage migration.

2. **How to handle existing Hive data during migration?**
   - What we know: User decided "clean slate migration — Simpler than data migration, server is source of truth"
   - What's unclear: Should we delete Hive boxes in Phase 1 or wait until all models are migrated?
   - Recommendation: Keep Hive intact in Phase 1 (coexist with Brick), delete in Phase 5 after all features migrated. Allows rollback if issues discovered.

3. **Should we use same Supabase credentials for both SupabaseService and Brick?**
   - What we know: Currently credentials hardcoded in main.dart, will be duplicated for Brick
   - What's unclear: Best practice for credential management
   - Recommendation: Use same credentials in Phase 1 (pass same values to both initialize calls), refactor to env variables or secure storage in separate task outside this migration.

## Sources

### Primary (HIGH confidence)
- GitHub GetDutchie/Brick repository - Official documentation
  - README: https://github.com/GetDutchie/brick
  - Supabase package README: https://github.com/GetDutchie/brick/tree/main/packages/brick_offline_first_with_supabase
- Context7 sqflite documentation - databaseFactory usage patterns
  - Library ID: /tekartik/sqflite
  - Topics: Database initialization, version management, CRUD patterns
- Context7 injectable documentation - Singleton registration patterns
  - Library ID: /milad-akarie/injectable
  - Topics: @module, @lazySingleton, third-party registration

### Secondary (MEDIUM confidence)
- Existing MyItihas codebase patterns
  - main.dart initialization sequence
  - injection_container.dart ThirdPartyModule pattern
  - Repository implementation with @LazySingleton(as: Interface)

### Tertiary (LOW confidence)
- GitHub Issues for Brick - Common pitfalls
  - Build runner formatting conflicts
  - Migration crashes with removed columns
  - Note: Issues may be outdated or specific to certain versions

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - Official Brick documentation, package maintained by GetDutchie
- Architecture: HIGH - Verified patterns from official README and Context7 sources
- Pitfalls: MEDIUM - Based on GitHub issues (may be version-specific) and general Flutter patterns

**Research date:** 2026-01-28
**Valid until:** 2026-02-28 (30 days - stable package, slow-moving ecosystem)
