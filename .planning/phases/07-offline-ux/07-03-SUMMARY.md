---
phase: 07-offline-ux
plan: 03
subsystem: offline
tags: [connectivity, bloc, offline-ux, internet-connection-checker-plus]

# Dependency graph
requires:
  - phase: 07-01
    provides: Global connectivity tracking with ConnectivityBloc
provides:
  - Offline write guards in CreatePostBloc, ChatDetailBloc, CommentBloc
  - User-friendly error messages with isOfflineError flag
  - Consistent write-disabled pattern across all write operations
affects: [07-04, future-features]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Offline write guard pattern: Check hasInternetAccess before write, emit error with isOfflineError flag"
    - "Optional InternetConnection constructor parameter for testability"

key-files:
  created: []
  modified:
    - lib/features/social/presentation/bloc/create_post_bloc.dart
    - lib/features/social/presentation/bloc/create_post_state.dart
    - lib/features/chat/presentation/bloc/chat_detail_bloc.dart
    - lib/features/social/presentation/bloc/comment_bloc.dart
    - lib/features/social/presentation/bloc/comment_state.dart

key-decisions:
  - "Consistent error message pattern: 'Cannot [action] while offline' for all write operations"

patterns-established:
  - "Write guard pattern: await _internetConnection.hasInternetAccess before write operations"
  - "Error state pattern: emit state.copyWith(error: message, isOfflineError: true) when offline"

# Metrics
duration: 4min
completed: 2026-01-30
---

# Phase 7 Plan 3: Write-Disabled BLoCs Summary

**All write operations now check connectivity first and emit user-friendly offline errors with isOfflineError flag**

## Performance

- **Duration:** 4 min
- **Started:** 2026-01-30T18:00:21Z
- **Completed:** 2026-01-30T18:04:12Z
- **Tasks:** 3
- **Files modified:** 7

## Accomplishments
- CreatePostBloc prevents post submission when offline
- ChatDetailBloc prevents message sending when offline (both text and story messages)
- CommentBloc prevents comment posting and liking when offline
- All BLoCs emit consistent error messages with isOfflineError flag

## Task Commits

Each task was committed atomically:

1. **Task 1: Add connectivity guard to CreatePostBloc** - `85dabe7` (feat)
2. **Task 2: Add connectivity guard to ChatDetailBloc** - `a381d7d` (feat)
3. **Task 3: Add connectivity guard to CommentBloc** - `027963b` (feat)

## Files Created/Modified
- `lib/features/social/presentation/bloc/create_post_bloc.dart` - Added InternetConnection field, connectivity check in _onSubmit
- `lib/features/social/presentation/bloc/create_post_state.dart` - Added isOfflineError field to state
- `lib/features/chat/presentation/bloc/chat_detail_bloc.dart` - Added connectivity check in _onSendStoryMessage (matched existing _onSendMessage pattern)
- `lib/features/social/presentation/bloc/comment_bloc.dart` - Added InternetConnection field, connectivity checks in _onAddComment and _onToggleLike
- `lib/features/social/presentation/bloc/comment_state.dart` - Added error and isOfflineError fields to CommentLoaded state

## Decisions Made
None - followed plan as specified. Extended the pattern from FeedBloc (07-01) to all write-operation BLoCs.

## Deviations from Plan
None - plan executed exactly as written.

## Issues Encountered
None - straightforward pattern application. ChatDetailBloc already had InternetConnection field and state structure, simplifying Task 2.

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- Write operations now consistently blocked when offline
- All BLoCs emit isOfflineError flag for UI to display appropriate offline messaging
- Ready for 07-04 (UI Offline Indicators) to consume isOfflineError flags and show user-facing offline states
- Pattern established can be extended to any future write operations

---
*Phase: 07-offline-ux*
*Completed: 2026-01-30*
