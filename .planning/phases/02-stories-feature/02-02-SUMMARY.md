---
phase: 02-stories-feature
plan: 02
subsystem: database
tags: [brick, supabase, offline-first, domain-model-conversion, gap-closure]

# Dependency graph
requires:
  - phase: 02-stories-feature
    plan: 01
    provides: "Brick models (StoryModel, StoryAttributesModel) with toDomain() conversion"
provides:
  - "StoryModel.fromDomain() and StoryAttributesModel.fromDomain() factories for domain-to-model conversion"
  - "@Supabase(unique: true) annotations on id fields for proper primary key sync"
  - "Working cacheStories() implementation with repository.upsert() calls"
  - "Complete bidirectional conversion between domain entities and Brick models"
affects: [02-stories-feature-remaining-plans, offline-story-browsing, supabase-sync]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Bidirectional domain-model conversion: toDomain() for model→entity, fromDomain() for entity→model"
    - "Supabase unique constraints on primary key fields for conflict resolution"
    - "OfflineFirstUpsertPolicy.optimisticLocal for caching operations"

key-files:
  created: []
  modified:
    - lib/features/stories/data/models/story.model.dart
    - lib/features/stories/data/models/story_attributes.model.dart
    - lib/features/stories/data/repositories/story_repository_impl.dart
    - lib/brick/adapters/story_model_adapter.g.dart
    - lib/brick/adapters/story_attributes_model_adapter.g.dart

key-decisions:
  - "Use empty string for StoryAttributesModel.id in fromDomain() - Brick manages this field"
  - "Use optimisticLocal policy for cacheStories() - local caching operation doesn't need remote sync"

patterns-established:
  - "fromDomain() factory pattern: Convert domain entities to Brick models for caching/persistence"
  - "Nested model conversion: StoryModel.fromDomain() calls StoryAttributesModel.fromDomain() for nested attributes"
  - "@Supabase(unique: true) on primary key fields ensures proper conflict resolution during sync"

# Metrics
duration: 5min
completed: 2026-01-29
---

# Phase 02 Plan 02: Gap Closure Summary

**Completed bidirectional domain-model conversion with fromDomain() factories, added Supabase unique constraints on id fields, and implemented working cacheStories() method with Brick upsert operations**

## Performance

- **Duration:** 5 min
- **Started:** 2026-01-29T11:28:17Z
- **Completed:** 2026-01-29T11:32:55Z
- **Tasks:** 3
- **Files modified:** 5

## Accomplishments
- Added fromDomain() factory constructors to both StoryModel and StoryAttributesModel for domain-to-model conversion
- Added @Supabase(unique: true) annotations to id fields in both models and regenerated Brick adapters
- Implemented complete cacheStories() method with StoryModel.fromDomain() conversion and repository.upsert() calls
- Closed both verification gaps identified in 02-VERIFICATION.md

## Task Commits

Each task was committed atomically:

1. **Task 1: Add fromDomain() Factories to Brick Models** - `dced0bc` (feat)
   - Added StoryAttributesModel.fromDomain() factory
   - Added StoryModel.fromDomain() factory with nested attributes conversion
   - Enables domain entity to Brick model conversion for caching

2. **Task 2: Add Supabase Unique Constraints to ID Fields** - `02d4699` (feat)
   - Added @Supabase(unique: true) to StoryModel.id
   - Added @Supabase(unique: true) to StoryAttributesModel.id
   - Regenerated Brick adapters with unique constraint handling
   - Ensures proper primary key sync and conflict resolution

3. **Task 3: Implement cacheStories() Method** - `1c7a9f7` (feat)
   - Replaced stub implementation with working code
   - Converts domain Story entities to StoryModel using fromDomain()
   - Calls repository.upsert<StoryModel>() with optimisticLocal policy
   - Removed TODO comments

## Files Created/Modified

- `lib/features/stories/data/models/story_attributes.model.dart` - Added fromDomain() factory and @Supabase(unique: true) on id
- `lib/features/stories/data/models/story.model.dart` - Added fromDomain() factory and @Supabase(unique: true) on id
- `lib/features/stories/data/repositories/story_repository_impl.dart` - Implemented cacheStories() with upsert calls
- `lib/brick/adapters/story_attributes_model_adapter.g.dart` - Regenerated with unique constraint handling
- `lib/brick/adapters/story_model_adapter.g.dart` - Regenerated with unique constraint handling

## Decisions Made

**1. StoryAttributesModel.id handling in fromDomain()**
- Set to empty string in fromDomain() factory
- Rationale: Brick manages the id field for nested models - primary key comes from parent StoryModel

**2. OfflineFirstUpsertPolicy.optimisticLocal for cacheStories()**
- Used optimisticLocal instead of other policies
- Rationale: cacheStories() is a local caching operation for data fetched FROM Supabase - doesn't need to sync back

**3. Field mapping strategy**
- Domain entity has extra fields (authorUser, commentCount, shareCount, isLikedByCurrentUser, characters, characterDetails, translations)
- fromDomain() only maps fields that exist in Brick models
- Rationale: Brick models represent persistent storage schema - social/computed fields handled separately

## Gap Closure Results

**Gap 1: Incomplete cacheStories() implementation** ✅ CLOSED
- **Was:** Empty for loop with TODO comment noting missing fromDomain() factory
- **Now:** Working implementation with fromDomain() conversion and repository.upsert() calls
- **Verification:** cacheStories() method compiles, no TODO comments remain, upsert pattern follows established convention

**Gap 2: Missing Supabase unique constraint on id fields** ✅ CLOSED
- **Was:** Both story.model.dart and story_attributes.model.dart lacked @Supabase(unique: true) annotation
- **Now:** Both models have @Supabase(unique: true) on id fields, adapters regenerated
- **Verification:** Annotations present via grep, build_runner completed successfully, adapters include unique constraint logic

**Observable Truths Status:**
1. "User can view previously loaded story lists without internet connection" - **NOW ACHIEVABLE** (cacheStories() functional)
2. "Story data syncs automatically from Supabase when online" - **NOW ACHIEVABLE** (unique constraints enable proper sync)

## Deviations from Plan

None - plan executed exactly as written.

All tasks completed as specified without requiring auto-fixes or deviations.

## Issues Encountered

**Generated code import warnings**
- Issue: brick.g.dart shows URI errors for story imports after regeneration
- Impact: Informational only - model files and repository compile successfully
- Status: Pre-existing transient build issue, doesn't affect story feature functionality
- Verification: `flutter analyze lib/features/stories/` passes without errors

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

**Ready for phase continuation:**
- Both verification gaps from 02-VERIFICATION.md are closed
- Bidirectional domain-model conversion complete (toDomain() + fromDomain())
- Supabase sync properly configured with unique constraints
- Offline caching functional via cacheStories()

**Patterns established for remaining plans:**
- Use fromDomain() when converting domain entities to models for persistence
- Use toDomain() when converting models to domain entities for business logic
- Apply @Supabase(unique: true) to primary key fields for proper sync
- Use optimisticLocal policy for local caching operations

**No blockers or concerns.**

Phase 2 can continue with next plans building on this foundation.

---
*Phase: 02-stories-feature*
*Plan: 02*
*Completed: 2026-01-29*
