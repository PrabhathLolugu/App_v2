# Phase 8: Migration & Cleanup - Context

**Gathered:** 2026-01-31
**Status:** Ready for planning

<domain>
## Phase Boundary

Remove Hive completely and ensure clean user transition to Brick-based storage. This includes runtime cleanup of Hive data on user devices and complete removal of Hive packages and code from the codebase.

</domain>

<decisions>
## Implementation Decisions

### Migration Detection
- Check if Hive directory exists for quick detection, plus check individual box files for thorough cleanup
- Run cleanup in background after app launch (non-blocking)
- Track success/failure status in SharedPreferences so we can retry if cleanup failed

### Data Cleanup UX
- Silent cleanup — user should not see any indication
- Retry once on failure, then log and continue silently
- Full directory wipe — delete entire Hive directory recursively

### Rollback Safety
- No backup needed — server is source of truth, user can re-sync
- No old version warning — old builds won't be published after migration ships
- Ship directly — no dry-run or gradual rollout needed

### Code Removal Scope
- Deep cleanup — remove packages, all Hive-specific code, and any utilities that only served Hive
- Audit all Hive usage first, review, then remove systematically
- Replace DI bindings with Brick equivalents where Hive was being used
- Delete Hive-specific generated files, then regenerate with build_runner

### Claude's Discretion
- Deletion approach (batch vs sequential)
- Monitoring/tracking for migration process (local logging is sufficient)

</decisions>

<specifics>
## Specific Ideas

- Clean slate approach aligns with earlier project decisions — server is source of truth
- This is the final phase of the Hive → Brick migration

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 08-migration-cleanup*
*Context gathered: 2026-01-31*
