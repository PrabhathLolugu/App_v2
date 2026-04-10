---
phase: 01-core-infrastructure
plan: 01
subsystem: infra
tags: [brick, sqlite, offline-first, supabase, repository-pattern]

# Dependency graph
requires:
  - phase: 00-preparation
    provides: Initial project setup with Hive and Supabase
provides:
  - Brick offline-first infrastructure with SQLite database
  - MyItihasRepository singleton configured and initialized
  - Offline request queue with auth/storage/functions path filtering
  - Dependency injection registration for repository access
affects: [02-models, 03-adapters, 04-providers, all-future-phases]

# Tech tracking
tech-stack:
  added: [brick_offline_first_with_supabase ^2.1.0, brick_offline_first_with_supabase_build ^2.1.0]
  patterns: [Repository singleton pattern, Offline-first architecture, SQLite-first with auto-sync]

key-files:
  created:
    - lib/repository/my_itihas_repository.dart
  modified:
    - pubspec.yaml
    - lib/main.dart
    - lib/core/di/injection_container.dart

key-decisions:
  - "Use clientQueue with ignorePaths for /auth/v1, /storage/v1, /functions/v1 to prevent offline queuing of authentication and storage operations"
  - "Initialize repository in main.dart before configureDependencies() to ensure availability during DI registration"
  - "Use show databaseFactory on sqflite import to avoid namespace conflicts"
  - "Empty modelDictionary and migrations for initial setup - will populate when models are created"

patterns-established:
  - "Repository initialization pattern: configure() static method sets up singleton before app startup"
  - "Offline queue configuration: explicitly ignore Supabase auth/storage/functions paths"
  - "DI registration pattern: @lazySingleton getter accessing pre-configured singleton instance"

# Metrics
duration: 10min
completed: 2026-01-28
---

# Phase 01 Plan 01: Brick Infrastructure Setup Summary

**Brick offline-first repository with SQLite database, Supabase sync, and offline queue configured to ignore auth/storage/functions paths**

## Performance

- **Duration:** 10 min
- **Started:** 2026-01-28T02:40:16+05:30
- **Completed:** 2026-01-28T02:47:00+05:30
- **Tasks:** 4 (3 implementation + 1 checkpoint)
- **Files modified:** 4

## Accomplishments

- Installed Brick offline-first packages with Supabase integration
- Created MyItihasRepository singleton extending OfflineFirstWithSupabaseRepository
- Configured SQLite database (myitihas.sqlite) and offline request queue
- Integrated repository initialization in main.dart before dependency injection setup
- Verified app startup with successful repository initialization and database creation

## Task Commits

Each task was committed atomically:

1. **Task 1: Install Brick Packages** - `69d6020` (feat)
2. **Task 2: Create MyItihasRepository Singleton** - `aabb120` (feat)
3. **Task 3: Initialize Repository in main.dart and Register in DI** - `122b03e` (feat)
4. **Task 4: Human Verification Checkpoint** - (approved)

**Plan metadata:** (this commit)

## Files Created/Modified

- `lib/repository/my_itihas_repository.dart` - Repository singleton extending OfflineFirstWithSupabaseRepository with configure() method for initialization
- `pubspec.yaml` - Added brick_offline_first_with_supabase ^2.1.0 and brick_offline_first_with_supabase_build ^2.1.0
- `lib/main.dart` - Added MyItihasRepository.configure() call between initHive() and configureDependencies()
- `lib/core/di/injection_container.dart` - Registered repository as @lazySingleton getter

## Decisions Made

**1. Offline queue path filtering**
- Configured clientQueue with ignorePaths: {'/auth/v1', '/storage/v1', '/functions/v1'}
- Rationale: Authentication, storage operations, and edge functions should fail fast rather than queue offline, preventing confusing UX where users think they're authenticated but requests are queued

**2. Repository initialization order**
- MyItihasRepository.configure() called AFTER initHive() but BEFORE configureDependencies()
- Rationale: Repository must be fully initialized before injectable tries to register it as a dependency, preventing runtime access errors

**3. Import statement specificity**
- Used `import 'package:sqflite/sqflite.dart' show databaseFactory;`
- Rationale: Prevents namespace conflicts between sqflite and Brick's internal types while providing only the required databaseFactory symbol

**4. Empty modelDictionary and migrations**
- Both initialized as empty {} in configure() method
- Rationale: Models don't exist yet - will be populated in Phase 2 (Model Creation) when build_runner generates brick.g.dart

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None - all tasks completed successfully without issues.

## User Setup Required

None - no external service configuration required. Supabase credentials already exist in codebase.

## Next Phase Readiness

**Ready for Phase 01 Plan 02 (Model Creation):**
- Repository infrastructure is initialized and verified working
- SQLite database is created and accessible
- Offline queue is configured with proper path filtering
- Repository is registered in dependency injection and accessible app-wide
- Code generation infrastructure (build_runner) is ready for model generation

**No blockers or concerns.**

Next phase will create @ConnectOfflineFirstWithSupabase models for Story, Comment, and User entities, configure adapters, and generate migrations.

---
*Phase: 01-core-infrastructure*
*Completed: 2026-01-28*
