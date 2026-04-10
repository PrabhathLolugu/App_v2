---
phase: 05-chat-feature
plan: 01
subsystem: chat
tags: [brick, offline-first, supabase, sqlite, chat, messaging]

# Dependency graph
requires:
  - phase: 01-core-infrastructure
    provides: Brick repository setup and offline-first infrastructure
  - phase: 04-social-feed-feature
    provides: UserModel pattern with nullable foreign keys for cache resilience
provides:
  - ConversationModel and MessageModel Brick models for offline chat
  - Supabase conversations and chat_messages table mapping
  - toDomain/fromDomain conversion methods for chat entities
  - Nullable sender pattern for cache-resilient message loading
affects: [05-chat-feature (later plans), offline-chat-ui]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Nullable sender field in MessageModel for cache resilience"
    - "String? lastMessage in ConversationModel (entity expects Message?)"
    - "Content-to-text field mapping in toDomain()"
    - "Local-only fields (deliveryStatus, readBy, unreadCount) with @Supabase(ignore: true) @Sqlite()"

key-files:
  created:
    - lib/features/chat/data/models/conversation.model.dart
    - lib/features/chat/data/models/message.model.dart
  modified: []

key-decisions:
  - "Pass null for lastMessage in ConversationModel.toDomain() (model stores String?, entity expects Message?)"
  - "Use 'content' as Dart field name, map to entity's 'text' field in conversion methods"
  - "Store participantIds in SQLite, participants loaded manually by repository via conversation_members"
  - "Local-only delivery status tracking (not synced to Supabase)"

patterns-established:
  - "Pattern: Mismatched field types between model and entity (lastMessage String? vs Message?) handled by passing null in toDomain()"
  - "Pattern: Field name mapping in conversion methods (model.content → entity.text)"
  - "Pattern: Junction table relationships loaded manually in repository layer (Brick doesn't auto-resolve M:N)"

# Metrics
duration: 5min
completed: 2026-01-30
---

# Phase 05 Plan 01: Chat Models Migration Summary

**Brick offline-first ConversationModel and MessageModel with Supabase sync, nullable sender for cache resilience, and local-only delivery tracking**

## Performance

- **Duration:** 5 min
- **Started:** 2026-01-30T21:21:25Z
- **Completed:** 2026-01-30T21:26:45Z
- **Tasks:** 2
- **Files modified:** 2

## Accomplishments
- Created ConversationModel extending OfflineFirstWithSupabaseModel with conversations table mapping
- Created MessageModel extending OfflineFirstWithSupabaseModel with chat_messages table mapping
- Implemented nullable sender pattern for cache-resilient message loading (Phase 4 pattern)
- Added local-only fields (deliveryStatus, readBy, unreadCount) for offline tracking
- Established content-to-text field mapping pattern in conversion methods

## Task Commits

Each task was committed atomically:

1. **Task 1: Replace ConversationModel with Brick version** - `0dffc6c` (feat)
2. **Task 2: Replace MessageModel with Brick version** - `2596d30` (feat)

## Files Created/Modified
- `lib/features/chat/data/models/conversation.model.dart` - Brick model for conversations with Supabase sync, maps to conversations table, stores participantIds locally
- `lib/features/chat/data/models/message.model.dart` - Brick model for messages with Supabase sync, maps to chat_messages table, nullable sender field, local delivery status

## Decisions Made

1. **Pass null for lastMessage in ConversationModel.toDomain()**: Model stores lastMessage as String? (from Supabase last_message column) but domain entity expects Message?. Since we can't construct full Message from just text, pass null. Repository can populate this field separately if needed.

2. **Use 'content' field name, map to 'text' in entity**: Supabase schema uses 'content' column name, domain entity uses 'text' field. Model follows database naming, conversion methods handle the mapping.

3. **Store participantIds locally, participants loaded by repository**: Brick doesn't support many-to-many relationships directly. Store participant IDs in SQLite, repository loads UserModel instances via conversation_members table query.

4. **Local-only delivery status tracking**: deliveryStatus, readBy, and sharedStoryId are stored in SQLite only (not synced to Supabase). These are client-side tracking fields.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None - models created successfully following Phase 4 Brick pattern.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

Models ready for adapter generation in Wave 2. Repository implementation can use these models with:
- `repository.get<ConversationModel>()` for conversation list
- `repository.get<MessageModel>()` for message history
- Manual participant loading via conversation_members table query
- Realtime subscription via `subscribeToRealtime<MessageModel>()`

No blockers. Adapters will be generated in next plan (05-02).

---
*Phase: 05-chat-feature*
*Completed: 2026-01-30*
