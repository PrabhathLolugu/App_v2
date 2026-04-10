# Phase 5: Chat Feature - Context

**Gathered:** 2026-01-30
**Status:** Ready for planning

<domain>
## Phase Boundary

Enable offline viewing of conversations and message history. Users can see their conversation list and read cached messages while offline. Sending messages while offline is out of scope (Phase 7 handles disabled actions). Media caching limits handled in Phase 6.

</domain>

<decisions>
## Implementation Decisions

### Conversation list
- Ordering: Pinned conversations first, then by last activity
- Each row shows: avatar, name, last message preview (1 line truncated), timestamp, unread badge count
- Timestamps: Hybrid format — relative for last 24h ("2m ago", "3h ago"), absolute for older ("Jan 15")

### Message display
- Time grouping: Date separators ("Today", "Yesterday", "January 15") between message groups
- Read receipts: Full checkmark system (sent, delivered, read)
- Uncached media: Show placeholder with download option when online

### Cache strategy
- Cache conversations accessed in last 30 days
- Store last 100 messages per conversation
- Real-time sync: Update cache immediately as new messages arrive via Brick realtime
- Scroll-to-load: Scrolling past cached messages fetches more when online

### Offline states
- Empty list: Illustration + "Start a conversation to see it here"
- Loading: Skeleton shimmer while fetching
- Offline indicator: Global "Offline" label in header/app bar
- Uncached conversation: Show message with "Connect to see more" prompt

### Claude's Discretion
- Message bubble styling (colors, alignment, shape)
- Exact skeleton shimmer design
- Date separator visual styling
- Specific illustration for empty state

</decisions>

<specifics>
## Specific Ideas

No specific requirements — open to standard approaches

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 05-chat-feature*
*Context gathered: 2026-01-30*
