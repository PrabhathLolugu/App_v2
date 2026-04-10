---
phase: 05-chat-feature
plan: 03
subsystem: chat
tags: [brick, realtime, offline-first, bloc, flutter]

# Dependency graph
requires:
  - phase: 05-01
    provides: Brick models (ConversationModel, MessageModel) with @ConnectOfflineFirstWithSupabase annotations
  - phase: 05-02
    provides: ChatRepositoryImpl using Brick with offline-first policies and participant loading
provides:
  - ChatDetailBloc with Brick realtime subscription for live message updates
  - Offline detection in send message flow with error state
  - Generated Brick adapters for ConversationModel and MessageModel in brick.g.dart
  - SQLite migration for chat_messages and conversations tables
affects: [06-map-feature, 07-ai-generator-feature, 08-final-polish]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Brick subscribe() with client-side filtering for realtime updates"
    - "InternetConnection.hasInternetAccess for offline write detection"
    - "isOfflineError flag in state for snackbar detection"
    - "Cancel subscriptions in BLoC close() to prevent memory leaks"

key-files:
  created:
    - lib/brick/adapters/conversation_model_adapter.g.dart
    - lib/brick/adapters/message_model_adapter.g.dart
    - lib/brick/db/20260130062644.migration.dart
  modified:
    - lib/features/chat/presentation/bloc/chat_detail_bloc.dart
    - lib/features/chat/presentation/bloc/chat_detail_event.dart
    - lib/features/chat/presentation/bloc/chat_detail_state.dart
    - lib/brick/brick.g.dart
    - lib/brick/db/schema.g.dart

key-decisions:
  - "Client-side filtering for conversation-specific messages since Brick subscribe() doesn't support query parameters"
  - "Filter in listener instead of repository to keep realtime logic in presentation layer"

patterns-established:
  - "Brick realtime pattern: subscribe<Model>() in BLoC, filter in listener, cancel in close()"
  - "Offline detection pattern: check hasInternetAccess before write operations, emit error with isOfflineError flag"
  - "State error fields: error (String?) and isOfflineError (bool) for distinguishing offline vs other errors"

# Metrics
duration: 10min
completed: 2026-01-30
---

# Phase 05 Plan 03: Chat BLoC Integration Summary

**Live message delivery via Brick subscribe() with offline detection blocking message sends**

## Performance

- **Duration:** 10 min
- **Started:** 2026-01-30T06:24:58Z
- **Completed:** 2026-01-30T06:34:18Z
- **Tasks:** 3
- **Files modified:** 10

## Accomplishments
- ChatDetailBloc subscribes to MessageModel realtime updates and filters by conversationId
- Send message checks internet connectivity and emits offline error before attempting write
- Brick adapters generated for ConversationModel and MessageModel with SQLite migration
- Subscription cleanup in close() prevents memory leaks when BLoC is disposed

## Task Commits

Each task was committed atomically:

1. **Task 1: Add realtime subscription to ChatDetailBloc** - `a9103dd` (feat)
2. **Task 2: Verify ChatListBloc compiles with updated repository** - `8afa123` (chore)
3. **Task 3: Generate Brick adapters for chat models** - `adbaa37` (feat)

## Files Created/Modified
- `lib/features/chat/presentation/bloc/chat_detail_bloc.dart` - Added Brick realtime subscription with conversationId filtering, offline detection in send message
- `lib/features/chat/presentation/bloc/chat_detail_event.dart` - Added RealtimeMessageReceivedEvent for incoming messages
- `lib/features/chat/presentation/bloc/chat_detail_state.dart` - Added error and isOfflineError fields to ChatDetailLoaded state
- `lib/brick/adapters/conversation_model_adapter.g.dart` - Generated Brick adapter for ConversationModel
- `lib/brick/adapters/message_model_adapter.g.dart` - Generated Brick adapter for MessageModel
- `lib/brick/brick.g.dart` - Updated with ConversationModelAdapter and MessageModelAdapter registrations
- `lib/brick/db/schema.g.dart` - Updated schema with chat tables
- `lib/brick/db/20260130062644.migration.dart` - New migration for conversations and chat_messages tables

## Decisions Made

**Client-side filtering for conversation messages**
- Brick's subscribe() method returns all MessageModel updates without query filtering
- Implemented filtering in listener: `messages.where((m) => m.conversationId == conversationId)`
- Alternative would be to add custom repository method, but client-side filtering keeps realtime logic in presentation layer
- Acceptable since Brick already filters by model type, only filtering one field client-side

**Offline detection in BLoC not repository**
- Check `internetConnection.hasInternetAccess` in ChatDetailBloc before calling repository.sendMessage()
- Emit state with `error` and `isOfflineError: true` for snackbar detection
- Keeps connectivity checking in presentation layer where UI feedback happens
- Repository remains agnostic to connectivity (focuses on data operations)

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Removed brick_offline_first import for Query**
- **Found during:** Task 1 (implementing realtime subscription)
- **Issue:** Plan specified `import 'package:brick_offline_first/brick_offline_first.dart'` for Query class, but this causes linter warning (not a direct dependency)
- **Fix:** Removed Query import since Brick's subscribe() doesn't accept query parameters. Implemented client-side filtering instead.
- **Files modified:** lib/features/chat/presentation/bloc/chat_detail_bloc.dart
- **Verification:** Code compiles without warnings, filtering works correctly
- **Committed in:** a9103dd (Task 1 commit)

**2. [Rule 1 - Bug] Changed subscribeToRealtime to subscribe**
- **Found during:** Task 1 (implementing realtime subscription)
- **Issue:** Plan specified `subscribeToRealtime<MessageModel>(query: Query.where(...))` but Brick's API is `subscribe<MessageModel>()` without query support
- **Fix:** Changed to `brickRepository.subscribe<MessageModel>()` and filter results in listener
- **Files modified:** lib/features/chat/presentation/bloc/chat_detail_bloc.dart
- **Verification:** Matches FeedBloc pattern (lines 584-614), compiles successfully
- **Committed in:** a9103dd (Task 1 commit)

---

**Total deviations:** 2 auto-fixed (1 blocking, 1 bug)
**Impact on plan:** Both deviations align with actual Brick API. Plan's subscribeToRealtime doesn't exist in Brick library. Client-side filtering is standard pattern used in FeedBloc. No scope creep.

## Issues Encountered
None - Brick adapters generated successfully on first build_runner execution.

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- Chat BLoCs ready for UI integration
- Realtime messaging works when online
- Offline state prevents message sends with clear error messaging
- Brick adapters enable SQLite caching for offline message viewing

**Ready for:** Phase 06 (Map Feature) - Chat foundation complete

---
*Phase: 05-chat-feature*
*Completed: 2026-01-30*
