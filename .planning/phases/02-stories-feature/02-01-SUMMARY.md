---
phase: 02-stories-feature
plan: 01
subsystem: database
tags: [brick, offline-first, supabase, sqlite, stories, flutter]

# Dependency graph
requires:
  - phase: 01-core-infrastructure
    provides: MyItihasRepository with Brick configuration and offline queue setup
provides:
  - Story and StoryAttributes Brick models with offline-first Supabase sync
  - StoryRepositoryImpl using Brick queries instead of Hive
  - Generated adapters for SQLite and Supabase serialization
  - SQLite migration for stories and story_attributes tables
affects: [03-profile-feature, 04-social-feed, 05-ai-stories]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Brick model pattern with @ConnectOfflineFirstWithSupabase for features"
    - "Repository.get<Model>() with OfflineFirstGetPolicy for offline-first queries"
    - "toDomain() method for converting Brick models to domain entities"

key-files:
  created:
    - lib/features/stories/data/models/story.model.dart
    - lib/features/stories/data/models/story_attributes.model.dart
    - lib/brick/adapters/story_model_adapter.g.dart
    - lib/brick/adapters/story_attributes_model_adapter.g.dart
    - lib/brick/db/20260129103441.migration.dart
  modified:
    - lib/features/stories/data/repositories/story_repository_impl.dart
    - lib/repository/my_itihas_repository.dart
    - lib/brick/brick.g.dart
    - lib/brick/db/schema.g.dart

key-decisions:
  - "Removed Hive annotations and replaced with Brick @ConnectOfflineFirstWithSupabase"
  - "Used alwaysHydrate policy for list queries to sync from Supabase when online"
  - "Used awaitRemoteWhenNoneExist for detail queries to fetch if not cached"
  - "Used localOnly policy for favorites (local state only, not synced)"

patterns-established:
  - "Pattern 1: Feature Brick models extend OfflineFirstWithSupabaseModel with tableName config"
  - "Pattern 2: Repository methods use repository.get<Model>() with appropriate OfflineFirstGetPolicy"
  - "Pattern 3: Models have toDomain() method for domain entity conversion (not fromEntity)"

# Metrics
duration: 13min
completed: 2026-01-29
---

# Phase 2 Plan 01: Create Brick Models and Migrate Repository Summary

**Stories feature migrated to Brick offline-first architecture with automatic Supabase sync and SQLite persistence**

## Performance

- **Duration:** 13 min
- **Started:** 2026-01-29T10:31:17Z
- **Completed:** 2026-01-29T10:44:24Z
- **Tasks:** 4 (3 auto + 1 checkpoint)
- **Files modified:** 9 (2 created, 4 modified, 3 generated)

## Accomplishments
- Brick models for Story and StoryAttributes replacing Hive-based storage
- StoryRepositoryImpl migrated to use MyItihasRepository Brick queries
- Generated 718 lines of adapter code for SQLite/Supabase serialization
- SQLite migration created for stories and story_attributes tables
- User verification confirmed app starts and renders stories without errors

## Task Commits

Each task was committed atomically:

1. **Task 1: Create Brick Models for Story and StoryAttributes** - `6fdf0bd` (feat)
2. **Task 2: Update StoryRepositoryImpl to Use Brick Queries** - `dec2c54` (feat)
3. **Task 3: Register Models and Generate Brick Adapters** - `9ca83ec` (feat)
4. **Task 4: Human Verification Checkpoint** - `0aef33e` (fix - import corrections after user testing)

**Plan metadata:** (to be committed)

## Files Created/Modified

**Created:**
- `lib/features/stories/data/models/story.model.dart` - Brick model for Story entity with 17 fields, @ConnectOfflineFirstWithSupabase annotation, toDomain() conversion
- `lib/features/stories/data/models/story_attributes.model.dart` - Brick model for StoryAttributes with 13 fields including story_type, theme, main_character_type, etc.
- `lib/brick/adapters/story_model_adapter.g.dart` - Generated adapter (409 lines) for SQLite and Supabase serialization
- `lib/brick/adapters/story_attributes_model_adapter.g.dart` - Generated adapter (309 lines) for nested attributes
- `lib/brick/db/20260129103441.migration.dart` - SQLite migration creating stories and story_attributes tables with indexes

**Modified:**
- `lib/features/stories/data/repositories/story_repository_impl.dart` - Replaced Hive datasource calls with repository.get<StoryModel>() queries using appropriate policies (alwaysHydrate, awaitRemoteWhenNoneExist, localOnly)
- `lib/repository/my_itihas_repository.dart` - Added StoryModel and StoryAttributesModel to modelDictionary
- `lib/brick/brick.g.dart` - Updated model registry with Story models
- `lib/brick/db/schema.g.dart` - Updated SQLite schema definition

## Decisions Made

**1. Offline-first policy selection:**
- Lists (getStories, getTrending, etc.): `alwaysHydrate` - Always sync from Supabase when online
- Details (getStoryById): `awaitRemoteWhenNoneExist` - Fetch if not cached, otherwise use cache
- Favorites: `localOnly` - Local state only, not synced to Supabase
- Rationale: Balances data freshness with offline availability

**2. Model structure:**
- Removed @freezed annotations (incompatible with Brick)
- Kept toDomain() conversion method (renamed from toEntity)
- Removed fromEntity() factory (not needed in Brick pattern)
- Rationale: Follows Brick best practices from 02-RESEARCH.md

**3. Import correction during verification:**
- Added brick_supabase and brick_sqlite imports to model files
- Required for proper code generation
- Fixed in Task 4 commit after user reported compilation errors

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Added missing imports to Brick models**
- **Found during:** Task 4 (Human verification checkpoint)
- **Issue:** User reported compilation errors after running app - brick_supabase and brick_sqlite imports missing from model files
- **Fix:** Added `import 'package:brick_supabase/brick_supabase.dart';` and `import 'package:brick_sqlite/brick_sqlite.dart';` to both story.model.dart and story_attributes.model.dart
- **Files modified:** lib/features/stories/data/models/story.model.dart, lib/features/stories/data/models/story_attributes.model.dart
- **Verification:** Re-ran build_runner, app compiled successfully, user confirmed "approved"
- **Committed in:** 0aef33e (fix commit)

---

**Total deviations:** 1 auto-fixed (1 blocking issue)
**Impact on plan:** Import fix required for compilation. No scope creep - essential for functionality.

## Issues Encountered

**Initial model creation attempts:**
- First attempt (commits 1bd7bca and eca5df9) had incorrect Brick model structure
- Deleted those models and recreated following exact pattern from 02-RESEARCH.md
- Final models (commit 6fdf0bd) followed correct OfflineFirstWithSupabaseModel pattern

**Import discovery during verification:**
- Initial models compiled during development but failed when user ran app
- User feedback identified missing brick_supabase and brick_sqlite imports
- Quick fix applied, regenerated adapters, user verification passed

## User Setup Required

None - no external service configuration required.

## Checkpoint Verification Results

**Checkpoint Type:** human-verify (blocking gate)

**User Testing:**
1. App startup: PASSED - User confirmed app started with MyItihas repository initialized
2. Story list loading: PASSED - Stories feature rendered without errors
3. Story detail view: Not explicitly tested (user focused on compilation and startup)
4. Compilation: INITIALLY FAILED - Import errors, FIXED with commit 0aef33e
5. Final verification: PASSED - User typed "approved" after import fix

**User Feedback:** "approved"

**Known limitations acknowledged:**
- No data sync from Supabase yet (planned for Phase 7)
- Images may not load (media caching is Phase 6)
- May show empty state if no Hive data exists

## Next Phase Readiness

**Ready for:**
- Phase 3 (Profile Feature) - Can follow same Brick model migration pattern
- Phase 4 (Social Feed) - Repository pattern established
- Phase 5 (AI Stories) - Story models in place for AI-generated content

**Blockers:** None

**Concerns:**
- Hive and Brick coexist in same codebase - may cause confusion until all features migrated
- Need to verify offline story browsing works for previously loaded content (requires data sync in Phase 7)
- SQLite migration only runs on fresh installs - existing users won't have migration applied (cleanup planned for Phase 8)

**Pattern established for future phases:**
1. Create Brick models with @ConnectOfflineFirstWithSupabase
2. Update repository to use repository.get<Model>() with appropriate policies
3. Register models in MyItihasRepository.modelDictionary
4. Run build_runner to generate adapters
5. Verify with user testing checkpoint

---
*Phase: 02-stories-feature*
*Completed: 2026-01-29*
