# Phase 8: Migration & Cleanup - Research

**Researched:** 2026-01-31
**Domain:** Flutter package migration - Hive removal with clean user transition
**Confidence:** HIGH

## Summary

Phase 8 completes the Hive → Brick migration by removing all Hive dependencies and cleaning up legacy data on user devices. The project is a Flutter app using Clean Architecture with `injectable` DI, and Hive is currently used for local storage across 8 box types (stories, users, conversations, messages, comments, likes, shares, notifications) with 15 registered adapters in `hive_registrar.g.dart`.

The standard approach for package removal with data cleanup:
1. **Migration detection**: Use `SharedPreferences` to track completion status, check Hive directory existence with `path_provider`
2. **Background cleanup**: Run directory deletion non-blocking after app launch (pattern established in `CacheCleanupService`)
3. **Code removal**: Remove `@HiveType`/`@HiveField` annotations, delete Hive imports, remove DI bindings, then regenerate with `build_runner`
4. **Package removal**: Remove from `pubspec.yaml` dependencies and dev_dependencies, run `flutter pub get`

The app already has a non-blocking cleanup service pattern (`CacheCleanupService` in main.dart:49-53) that can be extended for Hive cleanup.

**Primary recommendation:** Create a `HiveMigrationService` following the existing `CacheCleanupService` pattern with SharedPreferences tracking, background directory deletion via `path_provider` + `Directory.delete(recursive: true)`, and systematic code cleanup removing all `@HiveType`/`@HiveField` annotations before running `build_runner build --delete-conflicting-outputs`.

## Standard Stack

The established libraries/tools for this domain:

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| shared_preferences | ^2.5.4 | Migration status tracking | Already in use; persistent key-value storage, supports `containsKey()` for migration detection (added in v2.1.0), reliable cross-platform |
| path_provider | ^2.1.5 | Locating Hive directory path | Already in use; provides `getApplicationDocumentsDirectory()` where `Hive.initFlutter()` stores data, official Flutter plugin |
| dart:io Directory | Built-in | Recursive directory deletion | Native Dart; `delete(recursive: true)` async method removes entire directory tree safely |
| build_runner | ^2.10.4 | Regenerating DI after code changes | Already in use; required to regenerate `injection_container.config.dart` after removing `@lazySingleton` for `HiveService` |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| talker | ^5.1.9 | Logging cleanup progress | Already in use; provides structured logging for migration tracking (info, error, debug levels) |
| injectable_generator | ^2.12.0 | DI code generation | Already in use; auto-regenerates bindings when annotations change |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| SharedPreferences | Hive itself for migration flag | Hive is being removed; using it for migration detection creates circular dependency |
| Background cleanup | Synchronous blocking cleanup | Would delay app launch by 50-200ms; established pattern (CacheCleanupService) uses `.catchError()` for non-blocking |
| Directory.delete(recursive: true) | Manual box deletion via Hive API | Hive API requires Hive to be initialized; full directory wipe is simpler and more thorough |

**Installation:**
```bash
# All packages already in pubspec.yaml
# No new dependencies needed
```

## Architecture Patterns

### Recommended Project Structure
```
lib/
├── core/
│   ├── migration/                    # NEW: Migration logic
│   │   └── hive_migration_service.dart
│   ├── storage/
│   │   └── hive_service.dart        # DELETE: Remove this file
│   └── di/
│       ├── injection_container.dart  # NO CHANGE: Keep as-is
│       └── injection_container.config.dart  # REGENERATE: After removing HiveService
├── hive_registrar.g.dart            # DELETE: Remove this file
└── features/
    └── [feature]/
        └── data/
            ├── models/               # MODIFY: Remove @HiveType, @HiveField, hive imports
            └── datasources/          # MODIFY: Remove HiveService dependency from local data sources
```

### Pattern 1: Migration Detection with SharedPreferences
**What:** Check if Hive cleanup has been completed, with retry logic for failures
**When to use:** First launch after migration to new version
**Example:**
```dart
// Source: Context7 shared_preferences package - containsKey method
@lazySingleton
class HiveMigrationService {
  static const String _migrationCompleteKey = 'hive_migration_complete';
  static const String _migrationFailedKey = 'hive_migration_failed';

  Future<bool> needsMigration() async {
    final prefs = await SharedPreferences.getInstance();

    // Already completed successfully
    if (prefs.getBool(_migrationCompleteKey) == true) {
      return false;
    }

    // Check if Hive directory exists (quick detection)
    final appDocDir = await getApplicationDocumentsDirectory();
    final hiveDir = Directory('${appDocDir.path}/hive');

    return await hiveDir.exists();
  }
}
```

### Pattern 2: Background Non-Blocking Cleanup
**What:** Run migration cleanup after app launch without blocking UI
**When to use:** App initialization in main.dart
**Example:**
```dart
// Source: Verified pattern from CacheCleanupService (main.dart:49-53)
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ... other initialization ...

  await configureDependencies();

  // Non-blocking migration cleanup
  final migrationService = getIt<HiveMigrationService>();
  migrationService.runMigration().catchError((e) {
    talker.error('Hive migration failed', e);
  });

  runApp(MyApp());
}
```

### Pattern 3: Safe Recursive Directory Deletion
**What:** Delete entire Hive directory with error handling and retry logic
**When to use:** Cleanup operation in migration service
**Example:**
```dart
// Source: Dart SDK Directory class - delete(recursive: true)
Future<void> _cleanupHiveData() async {
  try {
    final appDocDir = await getApplicationDocumentsDirectory();
    final hiveDir = Directory('${appDocDir.path}/hive');

    if (await hiveDir.exists()) {
      await hiveDir.delete(recursive: true);
      talker.info('Hive directory deleted: ${hiveDir.path}');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_migrationCompleteKey, true);
    await prefs.remove(_migrationFailedKey);
  } catch (e, stack) {
    talker.error('Failed to delete Hive directory', e, stack);

    final prefs = await SharedPreferences.getInstance();
    final failCount = prefs.getInt(_migrationFailedKey) ?? 0;

    if (failCount < 1) {
      // Retry once
      await prefs.setInt(_migrationFailedKey, failCount + 1);
      return _cleanupHiveData();
    } else {
      // Give up after one retry, mark as complete to avoid infinite retries
      await prefs.setBool(_migrationCompleteKey, true);
      talker.error('Hive migration abandoned after retry');
    }
  }
}
```

### Pattern 4: Injectable DI Removal and Regeneration
**What:** Remove `@lazySingleton` annotation, delete file, regenerate DI config
**When to use:** Removing services from dependency injection
**Example:**
```dart
// Source: Context7 injectable package - build_runner clean and build

// BEFORE: lib/core/storage/hive_service.dart
@lazySingleton
class HiveService {
  // ...
}

// AFTER: DELETE the entire file

// Then regenerate DI:
// flutter packages pub run build_runner clean
// dart run build_runner build --delete-conflicting-outputs
```

### Pattern 5: Model Annotation Removal
**What:** Remove `@HiveType` and `@HiveField` annotations from all models
**When to use:** Cleaning up freezed models that had Hive support
**Example:**
```dart
// BEFORE: lib/features/stories/data/models/story_model.dart
import 'package:hive_ce/hive.dart';

@freezed
@HiveType(typeId: 0)
abstract class StoryModel with _$StoryModel {
  const factory StoryModel({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    // ...
  }) = _StoryModel;
}

// AFTER: Remove Hive import and all Hive annotations
import 'package:freezed_annotation/freezed_annotation.dart';

@freezed
abstract class StoryModel with _$StoryModel {
  const factory StoryModel({
    required String id,
    required String title,
    // ...
  }) = _StoryModel;
}
```

### Anti-Patterns to Avoid
- **Initializing Hive for cleanup:** Don't call `Hive.initFlutter()` or `Hive.deleteBoxFromDisk()` — just delete the directory. Initialization adds complexity and can fail if adapters are missing.
- **Blocking main() on cleanup:** Don't `await` the migration service — use `.catchError()` pattern to keep app launch fast
- **Manual DI config editing:** Don't manually edit `injection_container.config.dart` — always regenerate with build_runner
- **Partial annotation removal:** Don't leave some `@HiveField` annotations — remove all or regeneration will fail

## Don't Hand-Roll

Problems that look simple but have existing solutions:

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Migration tracking | Custom file flags | SharedPreferences with `containsKey()` | Platform-optimized, handles edge cases (app kill during write, permission issues), same pattern used for user preferences |
| Hive directory location | Hardcoded paths | `path_provider.getApplicationDocumentsDirectory()` | Cross-platform (iOS/Android/Desktop have different paths), matches what `Hive.initFlutter()` uses |
| Non-blocking tasks | Manual threading/isolates | Future with `.catchError()` | Dart's event loop handles scheduling, established pattern in codebase (CacheCleanupService) |
| Code generation cleanup | Manual file deletion | `build_runner clean` + `build --delete-conflicting-outputs` | Handles dependency graph, removes orphaned generated files, clears cache correctly |

**Key insight:** Flutter ecosystem has mature patterns for these operations. Using standard tools prevents edge cases (e.g., path_provider handles iOS app container migrations, SharedPreferences handles atomic writes).

## Common Pitfalls

### Pitfall 1: Forgetting to Remove Generated Files
**What goes wrong:** Old `.freezed.dart` and `.g.dart` files with Hive code remain, causing compilation errors
**Why it happens:** Generated files aren't automatically deleted when source annotations change
**How to avoid:** Always run `build_runner clean` before `build` when removing code generators
**Warning signs:** Compilation errors referencing `HiveType`, `HiveField` in `.freezed.dart` files after you removed them from source

### Pitfall 2: DI Bindings Reference Deleted Classes
**What goes wrong:** `injection_container.config.dart` still has `gh.lazySingleton<HiveService>()`, causes compilation error
**Why it happens:** Generated DI config is cached; removing source files doesn't trigger regeneration
**How to avoid:** Delete `HiveService` from all data source constructors FIRST, then delete the file, then regenerate
**Warning signs:** Errors like `Undefined class 'HiveService'` in `.config.dart` file

### Pitfall 3: Hive Directory Path Mismatch
**What goes wrong:** Cleanup deletes wrong directory, Hive data remains
**Why it happens:** Assuming path without checking what `Hive.initFlutter()` actually uses
**How to avoid:** Use `path_provider.getApplicationDocumentsDirectory()` - Hive stores data at `${appDocDir.path}/hive` by default
**Warning signs:** Migration runs successfully but app still shows old cached data

### Pitfall 4: Race Condition on First Launch
**What goes wrong:** User opens screen needing data before migration cleanup finishes
**Why it happens:** Migration runs in background, UI assumes data is ready
**How to avoid:** This is acceptable — server is source of truth, UI will re-sync. Log the scenario but don't block.
**Warning signs:** Logs showing "Failed to load" on first launch after migration

### Pitfall 5: Circular Dependency During Migration
**What goes wrong:** Migration service tries to use Hive APIs to clean up Hive
**Why it happens:** Instinct to use `Hive.deleteBoxFromDisk()` for "proper" cleanup
**How to avoid:** Never initialize Hive in this phase — use raw file system operations (`Directory.delete`)
**Warning signs:** Errors during migration about missing Hive adapters or initialization

### Pitfall 6: Removing Packages Too Early
**What goes wrong:** Code still imports `hive_ce`, fails to compile before cleanup
**Why it happens:** Removing packages from `pubspec.yaml` before removing code usage
**How to avoid:**
  1. First: Remove all code references (imports, annotations, usages)
  2. Then: Regenerate with build_runner
  3. Finally: Remove from pubspec.yaml
**Warning signs:** Compilation errors about missing package imports

## Code Examples

Verified patterns from official sources:

### Complete Migration Service
```dart
// Source: Synthesized from Context7 patterns
import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:myitihas/core/logging/talker_setup.dart';

@lazySingleton
class HiveMigrationService {
  static const String _migrationCompleteKey = 'hive_migration_complete';
  static const String _migrationFailedKey = 'hive_migration_failed_count';

  Future<void> runMigration() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if already completed
    if (prefs.getBool(_migrationCompleteKey) == true) {
      talker.debug('Hive migration already completed');
      return;
    }

    // Check if Hive directory exists
    final appDocDir = await getApplicationDocumentsDirectory();
    final hiveDir = Directory('${appDocDir.path}/hive');

    if (!await hiveDir.exists()) {
      talker.info('No Hive data found, marking migration complete');
      await prefs.setBool(_migrationCompleteKey, true);
      return;
    }

    talker.info('Starting Hive data cleanup...');
    await _cleanupHiveData(hiveDir, prefs);
  }

  Future<void> _cleanupHiveData(Directory hiveDir, SharedPreferences prefs) async {
    try {
      await hiveDir.delete(recursive: true);
      talker.good('Hive directory deleted successfully');

      await prefs.setBool(_migrationCompleteKey, true);
      await prefs.remove(_migrationFailedKey);
    } catch (e, stack) {
      talker.error('Failed to delete Hive directory', e, stack);

      final failCount = prefs.getInt(_migrationFailedKey) ?? 0;

      if (failCount < 1) {
        talker.info('Retrying Hive cleanup (attempt 2/2)');
        await prefs.setInt(_migrationFailedKey, failCount + 1);

        // Wait a bit before retry
        await Future.delayed(const Duration(seconds: 2));

        if (await hiveDir.exists()) {
          return _cleanupHiveData(hiveDir, prefs);
        }
      } else {
        talker.error('Hive migration abandoned after retry - continuing silently');
        await prefs.setBool(_migrationCompleteKey, true);
      }
    }
  }
}
```

### Integration in main.dart
```dart
// Source: Verified pattern from CacheCleanupService integration
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initTalker();
  talker.info('Starting MyItihas app...');

  // Initialize Brick (NOT Hive)
  MyItihasRepository.configure(/* ... */);
  await MyItihasRepository.instance.initialize();

  await configureDependencies();

  // Run Hive migration cleanup (non-blocking)
  final migrationService = getIt<HiveMigrationService>();
  migrationService.runMigration().catchError((e) {
    talker.error('Hive migration failed', e);
  });

  // Existing cache cleanup
  final cleanupService = getIt<CacheCleanupService>();
  cleanupService.runCleanup().catchError((e) {
    talker.error('Cache cleanup failed', e);
  });

  // ... rest of initialization ...
  runApp(MyApp());
}
```

### SharedPreferences Migration Flag Check
```dart
// Source: Context7 shared_preferences - getBool and setBool
final prefs = await SharedPreferences.getInstance();

// Check completion
final isComplete = prefs.getBool('hive_migration_complete') ?? false;

// Mark complete
await prefs.setBool('hive_migration_complete', true);

// Remove retry counter
await prefs.remove('hive_migration_failed_count');
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Hive for offline storage | Brick (brick_offline_first_with_supabase) | Phase 1-7 (2026) | Brick provides Supabase sync, automatic query-based caching, no manual adapter registration |
| Manual box management | Repository pattern with auto-sync | Phase 1-7 (2026) | Less boilerplate, server as source of truth |
| Generated Hive adapters | Brick's automatic serialization | Phase 1-7 (2026) | Fewer generated files, cleaner models |

**Deprecated/outdated:**
- `hive_ce` / `hive_ce_flutter`: Being removed in this phase
- `hive_ce_generator`: Being removed from dev_dependencies
- `@HiveType` / `@HiveField`: Being removed from all models
- `HiveService`: Being deleted from codebase
- `hive_registrar.g.dart`: Being deleted

## Open Questions

Things that couldn't be fully resolved:

1. **Exact Hive directory name**
   - What we know: `Hive.initFlutter()` uses `path_provider.getApplicationDocumentsDirectory()` and creates subdirectory
   - What's unclear: Whether it's named `hive`, `Hive`, or something else
   - Recommendation: Test in development by checking actual directory after `Hive.initFlutter()`, or check for both common names

2. **iOS app container migration impact**
   - What we know: iOS can migrate app containers between OS updates
   - What's unclear: Whether old Hive data persists in new container
   - Recommendation: Silent failure is acceptable — server re-sync handles edge cases

3. **Generated file cleanup scope**
   - What we know: `build_runner clean` removes cached files
   - What's unclear: Whether it removes ALL `.freezed.dart` files or just the ones with broken references
   - Recommendation: Run `--delete-conflicting-outputs` to force regeneration of all files

## Sources

### Primary (HIGH confidence)
- Context7: `/websites/pub_dev_packages_shared_preferences` - Migration detection with `getBool()`, `setBool()`, `containsKey()` methods
- Context7: `/websites/pub_dev_path_provider` - `getApplicationDocumentsDirectory()` for Hive location
- Context7: `/milad-akarie/injectable` - DI regeneration with build_runner
- Dart SDK: `dart:io Directory` class - `delete(recursive: true)` async method
- Codebase: `lib/core/cache/services/cache_cleanup_service.dart` - Non-blocking cleanup pattern
- Codebase: `lib/main.dart:49-53` - `.catchError()` pattern for background tasks
- Codebase: `lib/core/storage/hive_service.dart` - Current Hive usage (8 box types)
- Codebase: `lib/hive_registrar.g.dart` - 15 registered adapters to remove

### Secondary (MEDIUM confidence)
- Phase 7 RESEARCH.md: Established patterns for background services and non-blocking operations

### Tertiary (LOW confidence)
- Web search results did not return detailed technical information

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - All packages already in use, verified via Context7 and codebase inspection
- Architecture: HIGH - Patterns verified in existing codebase (CacheCleanupService, injectable DI)
- Pitfalls: HIGH - Based on common Flutter build_runner and DI issues, verified with codebase structure
- Code examples: HIGH - Synthesized from verified Context7 documentation and existing codebase patterns

**Research date:** 2026-01-31
**Valid until:** 30 days (stable ecosystem - SharedPreferences, path_provider, injectable are mature packages)

---

**Critical implementation order:**
1. Create `HiveMigrationService` with background cleanup
2. Integrate into `main.dart` before `runApp()`
3. Remove Hive from all data sources (constructor dependencies)
4. Remove `@HiveType` and `@HiveField` from all models
5. Delete `lib/core/storage/hive_service.dart`
6. Delete `lib/hive_registrar.g.dart`
7. Run `flutter packages pub run build_runner clean`
8. Run `dart run build_runner build --delete-conflicting-outputs`
9. Remove `hive_ce`, `hive_ce_flutter`, `hive_ce_generator` from `pubspec.yaml`
10. Run `flutter pub get`
11. Remove unused imports and verify compilation
