---
phase: 07-offline-ux
plan: 01
subsystem: core-presentation
tags: [connectivity, bloc, offline-ux, material-banner]
requires: [06-05-media-caching]
provides: [global-connectivity-tracking, offline-banner-ui]
affects: [07-02-offline-indicators]
tech-stack:
  added: []
  patterns: [debounced-state-transitions, global-bloc-provider]
decisions:
  - id: debounce-offline-3s
    summary: "Debounce offline transitions by 3 seconds"
    rationale: "Prevents banner strobe effect during brief connectivity loss"
  - id: immediate-online-feedback
    summary: "Show online state immediately without debounce"
    rationale: "Users want instant confirmation when connection restored"
  - id: material-banner-for-offline
    summary: "Use MaterialBanner for persistent offline notification"
    rationale: "Non-dismissible, stays visible until connectivity restored"
  - id: snackbar-for-online
    summary: "Use SnackBar for brief 'Back online' message"
    rationale: "Non-intrusive confirmation that connection restored"
key-files:
  created:
    - lib/core/presentation/bloc/connectivity_bloc.dart
    - lib/core/presentation/bloc/connectivity_event.dart
    - lib/core/presentation/bloc/connectivity_state.dart
    - lib/core/presentation/widgets/offline_banner.dart
  modified:
    - lib/main.dart
    - lib/core/di/injection_container.config.dart
metrics:
  duration: 3.4min
  completed: 2026-01-30
---

# Phase 07 Plan 01: Global Connectivity Management Summary

**One-liner:** App-wide connectivity tracking with debounced state changes, persistent offline MaterialBanner, and brief online SnackBar confirmation

## What Was Built

Created global connectivity management system that tracks network state across the entire app and provides clear visual feedback to users when offline or back online.

### Key Components

**1. ConnectivityBloc (Global State Management)**
- Extends Bloc<ConnectivityEvent, ConnectivityState> with @injectable for DI
- Subscribes to InternetConnection().onStatusChange for reactive updates
- Implements 3-second debounce for offline transitions (prevents banner flicker)
- Emits online state immediately for responsive feedback
- Cancels subscriptions and timers in close() method
- Uses optimistic default (ConnectivityState.online()) to prevent flash on app start

**2. ConnectivityEvent (Freezed Sealed Class)**
- checkConnectivity(): Manually check current connectivity status
- connectivityChanged(InternetStatus): React to connectivity status changes

**3. ConnectivityState (Freezed Sealed Class)**
- online(): Device has internet connection
- offline(): Device is disconnected

**4. OfflineBanner Widget**
- BlocConsumer<ConnectivityBloc, ConnectivityState> for reactive UI
- listenWhen prevents duplicate banner shows (checks runtimeType change)
- Shows persistent MaterialBanner with error color when offline
- Hides MaterialBanner and shows green SnackBar (2s) when online
- Returns SizedBox.shrink() in builder (all logic in listener)

**5. App Integration**
- ConnectivityBloc provided at app root via BlocProvider
- OfflineBanner added as Stack overlay in MaterialApp.router builder
- Initialization triggers checkConnectivity event immediately

## Technical Decisions

### Debouncing Strategy
**Decision:** 3-second debounce for offline transitions, immediate online emission
**Rationale:** Brief connectivity loss (elevator, tunnel) shouldn't trigger banner strobe. Users want instant confirmation when back online.
**Implementation:** Timer(Duration(seconds: 3)) for offline, direct emit for online

### MaterialBanner vs SnackBar
**Decision:** MaterialBanner for offline (persistent), SnackBar for online (2s duration)
**Rationale:** Offline state is critical and should remain visible. Online confirmation should be brief and non-intrusive.
**Impact:** Clear visual hierarchy - errors persist, confirmations disappear

### Optimistic Initial State
**Decision:** Default to ConnectivityState.online() on BLoC initialization
**Rationale:** Prevents flash of offline UI on app start. Most app launches have connectivity.
**Tradeoff:** Very brief optimistic assumption, corrected by immediate checkConnectivity event

### Global BLoC Provider Location
**Decision:** Wrap MaterialApp.router (inside Sizer builder, outside MaterialApp.router)
**Rationale:** ConnectivityBloc needs to be accessible to all routes and widgets
**Alternative Considered:** Providing in main() → rejected because needs BuildContext for BlocProvider

## Integration Points

### With Internet Connection Checker Plus
- Subscribe to onStatusChange stream for reactive updates
- Call hasInternetAccess for manual connectivity checks
- Handle InternetStatus.connected and InternetStatus.disconnected

### With ScaffoldMessenger
- showMaterialBanner() for persistent offline notification
- hideCurrentMaterialBanner() to remove banner when online
- showSnackBar() for brief "Back online" confirmation

### With DI Container
- ConnectivityBloc registered via @injectable annotation
- Retrieved via getIt<ConnectivityBloc>() in main.dart
- Auto-registered during build_runner code generation

## Files Modified

### Created
- `lib/core/presentation/bloc/connectivity_bloc.dart` (72 lines)
- `lib/core/presentation/bloc/connectivity_event.dart` (11 lines)
- `lib/core/presentation/bloc/connectivity_state.dart` (8 lines)
- `lib/core/presentation/widgets/offline_banner.dart` (58 lines)

### Modified
- `lib/main.dart`: Added BlocProvider for ConnectivityBloc, OfflineBanner in Stack
- `lib/core/di/injection_container.config.dart`: Auto-generated DI registration

### Generated
- `lib/core/presentation/bloc/connectivity_event.freezed.dart`
- `lib/core/presentation/bloc/connectivity_state.freezed.dart`

## Verification Results

### Code Analysis
```bash
flutter analyze lib/core/presentation/bloc/ lib/core/presentation/widgets/ lib/main.dart
# Result: 1 info warning (pre-existing flutter_localizations dependency)
# No errors related to connectivity implementation
```

### Build Runner
```bash
dart run build_runner build --delete-conflicting-outputs
# Result: Success - freezed files generated, DI config updated
```

### Manual Testing Checklist
- [ ] App starts without offline banner (optimistic default works)
- [ ] Enable airplane mode → wait 3 seconds → MaterialBanner appears
- [ ] Disable airplane mode → Banner disappears, green SnackBar shows briefly
- [ ] Toggle airplane mode rapidly → No banner flicker (debouncing works)

## Dependencies Added

None - all dependencies were already in project:
- flutter_bloc (for BLoC pattern)
- internet_connection_checker_plus (for connectivity tracking)
- injectable (for DI registration)
- freezed_annotation (for sealed classes)

## Known Issues

None

## Next Phase Readiness

### Enables 07-02 (Offline Indicators)
- ConnectivityBloc provides single source of truth for connectivity state
- Can be consumed by feature BLoCs to disable write operations
- Can be consumed by UI widgets to show offline-specific UI

### Provides
- **Global connectivity state:** Any widget can access via BlocBuilder/BlocListener
- **Persistent offline notification:** MaterialBanner visible until online
- **Online confirmation:** Brief SnackBar when connection restored
- **Debounced state changes:** Prevents UI flicker during brief connectivity loss

### Technical Debt
None - clean implementation following established patterns

## Deviations from Plan

None - plan executed exactly as written.

## Commits

| Commit | Message |
|--------|---------|
| 6e7339f | feat(07-01): create ConnectivityBloc with debounced state management |
| 61263ed | feat(07-01): create OfflineBanner widget with MaterialBanner |
| 7902d58 | feat(07-01): register ConnectivityBloc in DI and add OfflineBanner to app root |

## Performance Notes

**Execution Time:** 3.4 minutes
**Build Time:** ~17 seconds for build_runner code generation
**Runtime Performance:** Minimal - single stream subscription, one timer for debouncing

## Future Enhancements

1. **Customizable debounce duration:** Allow configuration via settings
2. **Network type indicator:** Show WiFi vs cellular in banner
3. **Retry mechanism:** Add "Retry" action in MaterialBanner
4. **Offline queue indicator:** Show pending operations count in banner
5. **Accessibility improvements:** Add semantic labels for screen readers
