---
phase: 03-story-generator-feature
plan: 02
subsystem: ui
completed: 2026-01-29
duration: 15min

requires:
  - 03-01 (StoryGeneratorBloc with cached repository queries)
  - 01-core-infrastructure (NetworkInfo service)

provides:
  - Network-aware StoryGeneratorBloc with connectivity tracking
  - Offline-aware UI with disabled generate button and hint text
  - Snackbar feedback for uncached story access attempts
  - Translated offline messages in all supported languages (en, hi, ta, te)

affects:
  - Future features requiring network-aware UI patterns
  - Any feature showing cached vs. uncached content offline

tech-stack:
  added:
    - None (uses existing internet_connection_checker_plus)
  patterns:
    - Connectivity state tracking in BLoC via InternetConnection().onStatusChange
    - Disabled button + hint text pattern for offline feature restrictions
    - BlocListener snackbar pattern for offline error feedback
    - Translated error messages for connectivity requirements

key-files:
  created:
    - None (modified existing files)
  modified:
    - lib/features/story_generator/presentation/bloc/story_generator_state.dart
    - lib/features/story_generator/presentation/bloc/story_generator_event.dart
    - lib/features/story_generator/presentation/bloc/story_generator_bloc.dart
    - lib/features/story_generator/presentation/pages/story_generator_page.dart
    - lib/features/story_generator/presentation/pages/generated_story_detail_page.dart
    - lib/i18n/strings_en.i18n.json
    - lib/i18n/strings_hi.i18n.json
    - lib/i18n/strings_ta.i18n.json
    - lib/i18n/strings_te.i18n.json

decisions:
  - decision: "Optimistic default for isOnline state"
    rationale: "State defaults to true on init, prevents flash of disabled UI before connectivity check completes"
    impact: "Pattern for network-aware features - assume online until proven offline"
  - decision: "Connectivity subscription in BLoC constructor"
    rationale: "Reactive connectivity tracking ensures UI updates immediately on network change without app restart"
    impact: "Future BLoCs can follow same pattern for network-dependent features"
  - decision: "Snackbar for uncached story access"
    rationale: "Non-blocking error feedback, dismissible action, follows Material Design guidelines"
    impact: "Pattern for offline access to uncached content across features"

tags: [network-awareness, offline-ui, connectivity, bloc, i18n, story-generator]
---

# Phase 03 Plan 02: Network-Aware UI Summary

**One-liner:** Added connectivity tracking to StoryGeneratorBloc with reactive UI disabling generation offline, showing hint text, and snackbar feedback for uncached story access.

## Performance

- **Duration:** ~15 min
- **Started:** 2026-01-29T13:40:43Z (approx)
- **Completed:** 2026-01-29T13:55:43Z
- **Tasks:** 3 (2 auto + 1 checkpoint)
- **Files modified:** 11

## Accomplishments

- StoryGeneratorBloc tracks connectivity state via InternetConnection stream subscription
- Generate button disables automatically when offline with explanatory hint text
- Story detail page shows snackbar when attempting to access uncached stories offline
- All offline messages translated to Hindi, Tamil, and Telugu
- Reactive network state - UI updates immediately on connectivity changes without app restart

## Task Commits

Each task was committed atomically:

1. **Task 1: Add Network Awareness to StoryGeneratorBloc** - `6b342f6` (feat)
   - Added `isOnline` field to state with `@Default(true)`
   - Created `checkConnectivity` event
   - Implemented connectivity subscription with `InternetConnection().onStatusChange`
   - Added connectivity check before story generation
   - Disposed subscription in `close()`

2. **Task 2: Update UI to Show Offline Feedback** - `db75b7c` (feat)
   - Wrapped generate button in BlocBuilder reading `state.isOnline`
   - Disabled button when offline with error-colored hint text
   - Added BlocListener to story detail page for NotFoundFailure snackbar
   - Created translation keys: `requiresInternet`, `notAvailableOffline`, `dismiss`
   - Translated to all supported languages and regenerated strings.g.dart

3. **Task 3: Human Verification** - User approved all 6 test scenarios

**Plan metadata:** (to be committed in this session)

## Files Created/Modified

- `lib/features/story_generator/presentation/bloc/story_generator_state.dart` - Added isOnline field
- `lib/features/story_generator/presentation/bloc/story_generator_event.dart` - Added checkConnectivity event
- `lib/features/story_generator/presentation/bloc/story_generator_bloc.dart` - Connectivity subscription, online checks
- `lib/features/story_generator/presentation/pages/story_generator_page.dart` - Disabled button + hint text when offline
- `lib/features/story_generator/presentation/pages/generated_story_detail_page.dart` - Snackbar for offline access
- `lib/i18n/strings_en.i18n.json` - English offline messages
- `lib/i18n/strings_hi.i18n.json` - Hindi translations
- `lib/i18n/strings_ta.i18n.json` - Tamil translations
- `lib/i18n/strings_te.i18n.json` - Telugu translations
- `lib/i18n/strings.g.dart` - Regenerated translation mappings
- `lib/core/di/injection_container.config.dart` - Auto-generated DI registration

## Decisions Made

**Pattern: Optimistic default for network state**
- State field `isOnline` defaults to `true` to prevent flash of disabled UI
- Connectivity check fires immediately in constructor to correct state
- Rationale: Better UX than showing disabled button momentarily on every load

**Pattern: Reactive connectivity tracking**
- BLoC subscribes to `InternetConnection().onStatusChange` stream
- Dispatches `checkConnectivity` event on every network state change
- UI updates automatically without requiring app restart
- Rationale: Seamless UX when user toggles airplane mode or WiFi

**Pattern: Non-blocking error feedback**
- Snackbar with dismissible action for offline story access errors
- Follows Material Design guidelines for transient messaging
- Error color from theme for consistency
- Rationale: Doesn't block user navigation, clear call-to-action

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None - all tasks completed without blocking issues.

## User Setup Required

None - no external service configuration required.

## Verification Results

User verified all 6 test scenarios successfully:

1. **Generate Story While Online** ✓
   - Generate button enabled
   - No hint text
   - Story generated and cached successfully

2. **Browse Generated Stories Offline** ✓
   - Story list loaded from cache instantly
   - Story details displayed correctly
   - No error messages

3. **Attempt Generation While Offline** ✓
   - Generate button grayed out (disabled)
   - Red hint text: "Story generation requires internet connection"
   - No error dialog

4. **Offline Story Access (Uncached)** ✓
   - Snackbar appeared with correct message
   - "Dismiss" action present
   - Story didn't load (expected behavior)

5. **Reconnect and Verify Sync** ✓
   - Hint text disappeared automatically
   - Generate button re-enabled
   - New stories generated and synced

6. **Chat Conversation Caching** ✓
   - Chat conversations loaded from cache offline
   - Previous messages visible
   - Send functionality correctly requires online connection

## Phase 3 Success Criteria - Complete

All Phase 3 goals achieved:

✅ User can view list of previously generated stories without internet
✅ User can read full content of any cached generated story while offline
✅ Generated stories sync automatically from Supabase when online
✅ Story generation correctly requires online connection (appropriate feedback shown)

## Next Phase Readiness

**Story Generator feature complete** - Full offline-first implementation with:
- Data layer caching via Brick (Plan 01)
- Network-aware UI with reactive connectivity (Plan 02)
- Translated offline messaging for all supported languages

**Ready for:** Phase 4 and beyond can reference these patterns for network-aware features.

**No blockers or concerns.**

---
*Phase: 03-story-generator-feature*
*Completed: 2026-01-29*
