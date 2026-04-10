# Phase 7: Offline UX - Research

**Researched:** 2026-01-30
**Domain:** Flutter offline-first UX with connectivity monitoring and sync
**Confidence:** HIGH

## Summary

Phase 7 implements clear offline feedback and sync for a Flutter app using Supabase backend with Hive local storage. The app already uses `internet_connection_checker_plus` (v2.9.1) and `connectivity_plus` (v7.0.0), and has established patterns for BLoC-based connectivity tracking (see FeedBloc lines 36, 71-76, 121-130, 299-307).

The standard approach combines:
1. **Dual connectivity monitoring**: `internet_connection_checker_plus` for actual internet access checking (not just WiFi/cellular connection state)
2. **BLoC state integration**: `isOnline` flag in loaded states with reactive updates via `onStatusChange` stream subscription
3. **Flutter Material widgets**: `MaterialBanner` for persistent offline indicator, standard disabled button styling
4. **Debouncing**: Dart's built-in `Timer` for 2-3 second delays before showing offline UI
5. **Smart sync**: Manual pull-to-refresh triggers sync, with Supabase realtime subscriptions for automatic updates when online

**Primary recommendation:** Build on existing patterns (FeedBloc already implements connectivity checking before writes and `isOnline` state tracking). Add global connectivity BLoC, MaterialBanner widget, debounced state updates, and extend write-disabled pattern to all BLoCs.

## Standard Stack

The established libraries/tools for this domain:

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| internet_connection_checker_plus | ^2.9.1 | True internet connectivity detection | Already in use; checks actual internet access, not just network interface state. Sub-second response times. |
| connectivity_plus | ^7.0.0 | Network type detection (WiFi/cellular/none) | Already in use; complements internet checker by providing network type info for diagnostics. |
| flutter_bloc | ^9.1.1 | State management for connectivity state | Already in use; BLoC pattern established for reactive UI updates across the app. |
| Timer (dart:async) | Built-in | Debouncing connectivity changes | No external dependency needed; standard Dart approach for delays. |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| MaterialBanner | Flutter SDK | Persistent offline banner | Built-in Material widget; shows persistent messages that require user awareness. |
| RefreshIndicator | Flutter SDK | Pull-to-refresh for manual sync | Built-in widget; standard pattern for triggering data refresh. |
| LinearProgressIndicator | Flutter SDK | Subtle sync progress feedback | Built-in; shows indeterminate progress during background operations. |
| SnackBar | Flutter SDK | Transient feedback (online/offline transitions, errors) | Built-in; dismissible messages for non-critical updates. |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| internet_connection_checker_plus | connectivity_plus alone | connectivity_plus only detects network interface state (WiFi/cellular), not actual internet access. Device can show "connected" but have no internet. |
| MaterialBanner | Custom widget | MaterialBanner is Material Design compliant, handles safe area, built-in animations. Custom widget requires more maintenance. |
| Timer debounce | rxdart debounceTime | rxdart adds dependency for single feature. Dart Timer is sufficient for simple delay. |

**Installation:**
```bash
# All packages already in pubspec.yaml
flutter pub get
```

## Architecture Patterns

### Recommended Project Structure
```
lib/
├── core/
│   ├── connectivity/        # NEW: Global connectivity management
│   │   ├── connectivity_bloc.dart
│   │   ├── connectivity_event.dart
│   │   └── connectivity_state.dart
│   └── widgets/             # NEW: Reusable offline widgets
│       ├── offline_banner.dart
│       └── offline_aware_button.dart
├── features/
│   └── [feature]/
│       └── presentation/
│           ├── bloc/        # EXTEND: Add connectivity checks to write operations
│           └── widgets/     # EXTEND: Wrap actions in offline-aware widgets
```

### Pattern 1: Global Connectivity BLoC
**What:** Single source of truth for connectivity state, consumed by all features
**When to use:** App-wide state that needs to be accessible everywhere
**Example:**
```dart
// Source: Verified pattern from existing FeedBloc (feed_bloc.dart:36,71-76)
@injectable
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final InternetConnection _internetConnection;
  StreamSubscription<InternetStatus>? _subscription;
  Timer? _debounceTimer;

  ConnectivityBloc({
    InternetConnection? internetConnection,
  }) : _internetConnection = internetConnection ?? InternetConnection(),
       super(const ConnectivityState.online()) {
    on<CheckConnectivityEvent>(_onCheckConnectivity);
    on<ConnectivityChangedEvent>(_onConnectivityChanged);

    // Subscribe to connectivity changes with debouncing
    _subscription = _internetConnection.onStatusChange.listen((status) {
      // Cancel existing timer
      _debounceTimer?.cancel();

      // For offline transitions, debounce 2-3 seconds
      if (status == InternetStatus.disconnected) {
        _debounceTimer = Timer(const Duration(seconds: 3), () {
          add(ConnectivityEvent.connectivityChanged(status));
        });
      } else {
        // For online transitions, immediate feedback
        add(ConnectivityEvent.connectivityChanged(status));
      }
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _debounceTimer?.cancel();
    return super.close();
  }
}
```

### Pattern 2: Offline-Aware Button Widget
**What:** Button wrapper that shows disabled state when offline and explains why on tap
**When to use:** All write actions (post, like, comment, send message)
**Example:**
```dart
// Source: Context7 BLoC patterns + Material disabled button styling
class OfflineAwareButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final String offlineMessage;

  const OfflineAwareButton({
    required this.onPressed,
    required this.child,
    this.offlineMessage = 'Not available offline',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (context, state) {
        final isOnline = state is ConnectivityOnline;

        return ElevatedButton(
          onPressed: isOnline ? onPressed : () {
            // Show snackbar explaining why disabled
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(offlineMessage),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            // Greyscale + opacity for offline state
            backgroundColor: isOnline
              ? null
              : Colors.grey.withOpacity(0.5),
          ),
          child: Opacity(
            opacity: isOnline ? 1.0 : 0.5,
            child: child,
          ),
        );
      },
    );
  }
}
```

### Pattern 3: Persistent Offline Banner
**What:** Full-width banner at top showing offline status, dismissed automatically when back online
**When to use:** App-level feedback about connectivity state
**Example:**
```dart
// Source: Flutter MaterialBanner API documentation
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConnectivityBloc, ConnectivityState>(
      listenWhen: (previous, current) =>
        previous.runtimeType != current.runtimeType,
      listener: (context, state) {
        if (state is ConnectivityOffline) {
          // Show persistent banner
          ScaffoldMessenger.of(context).showMaterialBanner(
            MaterialBanner(
              content: const Text('No internet connection'),
              backgroundColor: Theme.of(context).colorScheme.error,
              leading: const Icon(Icons.wifi_off, color: Colors.white),
              actions: [
                // Empty action required by MaterialBanner API
                const SizedBox.shrink(),
              ],
            ),
          );
        } else if (state is ConnectivityOnline) {
          // Remove banner
          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();

          // Show brief success toast
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Back online'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      builder: (context, state) => const SizedBox.shrink(),
    );
  }
}
```

### Pattern 4: Write-Action Connectivity Check
**What:** Check `hasInternetAccess` before executing write operations, emit error with `isOfflineError` flag
**When to use:** All BLoC event handlers that perform writes
**Example:**
```dart
// Source: Existing pattern from FeedBloc (feed_bloc.dart:299-307)
Future<void> _onToggleLike(
  ToggleLikeEvent event,
  Emitter<FeedState> emit,
) async {
  final currentState = state;
  if (currentState is! FeedLoaded) return;

  // Check connectivity before attempting write action
  final isOnline = await _internetConnection.hasInternetAccess;
  if (!isOnline) {
    emit(currentState.copyWith(
      error: 'No internet connection. Try again later.',
      isOfflineError: true,
    ));
    return;
  }

  // Proceed with optimistic UI update + network call
  // ... rest of implementation
}
```

### Pattern 5: Smart Sync with Pull-to-Refresh
**What:** RefreshIndicator triggers manual sync, shows linear progress during background sync
**When to use:** List screens (feed, stories, messages)
**Example:**
```dart
// Source: Flutter RefreshIndicator API + Context7 BLoC patterns
class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
        // Subtle sync indicator at top
        bottom: BlocBuilder<FeedBloc, FeedState>(
          builder: (context, state) {
            if (state is FeedRefreshing) {
              return const PreferredSize(
                preferredSize: Size.fromHeight(2),
                child: LinearProgressIndicator(),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<FeedBloc>().add(const FeedEvent.refreshFeed());
          // Wait for refresh to complete
          await context.read<FeedBloc>().stream.firstWhere(
            (state) => state is! FeedRefreshing,
          );
        },
        child: BlocBuilder<FeedBloc, FeedState>(
          builder: (context, state) {
            return state.map(
              // ... build UI based on state
            );
          },
        ),
      ),
    );
  }
}
```

### Anti-Patterns to Avoid
- **Using connectivity_plus alone for online/offline checks:** connectivity_plus reports network interface state (WiFi connected), not actual internet access. Device can show "WiFi connected" with no internet. Always use `internet_connection_checker_plus.hasInternetAccess` for write-action guards.
- **No debouncing on connectivity changes:** Flaky connections cause rapid state transitions, creating "strobe light" effect. Always debounce offline transitions by 2-3 seconds.
- **Showing intrusive dialogs for offline state:** Use persistent banner instead of blocking dialogs. User should be able to browse cached content while offline.
- **Optimistic UI updates for offline writes:** Per user decision, disabled writes have clearer UX than silent queuing. Don't update UI optimistically if write will fail.

## Don't Hand-Roll

Problems that look simple but have existing solutions:

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Debouncing stream events | Custom debounce logic with Timer | Dart Timer for simple delay | Built-in Timer is sufficient for 2-3 second delays. Only need rxdart for complex stream operators. |
| Connectivity monitoring | Custom network reachability checker | internet_connection_checker_plus | Handles edge cases: captive portals, DNS issues, timeout tuning. Already integrated. |
| Offline banner UI | Custom banner widget | MaterialBanner | Handles safe area, animations, dismissal, Material Design compliance out of box. |
| Pull-to-refresh | Custom scroll listener + loading indicator | RefreshIndicator | Standard Flutter widget, handles overscroll physics, loading state, platform conventions. |
| Button disabled state | Manual opacity/color changes | ElevatedButton.styleFrom + onPressed: null | Platform-native disabled styling, accessibility support, haptic feedback. |

**Key insight:** Flutter SDK provides robust Material widgets for offline UX patterns. Custom solutions lose platform consistency, accessibility, and animation polish.

## Common Pitfalls

### Pitfall 1: Connectivity State Flash on App Start
**What goes wrong:** UI briefly shows offline banner on app start before connectivity check completes
**Why it happens:** BLoC initializes with default state before stream subscription fires
**How to avoid:** Default `isOnline` to true (optimistic), as seen in FeedState (feed_state.dart:20)
**Warning signs:** User reports seeing offline banner flash when app starts with good connection

### Pitfall 2: Strobe Effect on Flaky Connections
**What goes wrong:** Banner rapidly appears/disappears on unstable connections, disorienting user
**Why it happens:** No debouncing on connectivity state changes
**How to avoid:** Debounce offline transitions by 2-3 seconds using Timer (see Pattern 1 example)
**Warning signs:** QA reports banner "flickering" on cellular data with poor signal

### Pitfall 3: Write Actions Silently Fail
**What goes wrong:** User taps like button, nothing happens, no feedback
**Why it happens:** Connectivity check in BLoC but UI doesn't react to error state
**How to avoid:** BLoC emits error with `isOfflineError: true`, UI shows SnackBar via BlocListener
**Warning signs:** User confusion about whether action succeeded, repeated taps

### Pitfall 4: MaterialBanner Requires Actions Array
**What goes wrong:** MaterialBanner crashes with "actions must not be empty" error
**Why it happens:** MaterialBanner API requires at least one action widget, even if not visible
**How to avoid:** Provide `[const SizedBox.shrink()]` as actions if no actual action needed
**Warning signs:** Runtime exception when showing banner

### Pitfall 5: Sync Doesn't Prioritize Visible Content
**What goes wrong:** User pulls to refresh, sees old data while background tables sync first
**Why it happens:** Sync runs in database insertion order, not screen relevance order
**How to avoid:** Sync current screen's data first, then background tables. RefreshIndicator calls screen-specific BLoC event.
**Warning signs:** User reports "refresh doesn't work" when visible data updates slowly

### Pitfall 6: Memory Leak from Uncancelled Subscriptions
**What goes wrong:** App memory grows over time, especially after navigating between screens
**Why it happens:** StreamSubscription to connectivity changes not cancelled in BLoC.close()
**How to avoid:** Always cancel subscriptions and timers in close() (see Pattern 1 and FeedBloc:112-119)
**Warning signs:** Memory profiler shows growing subscription count, app crashes after extended use

## Code Examples

Verified patterns from official sources:

### Listen to Connectivity Changes (Debounced)
```dart
// Source: internet_connection_checker_plus README + custom debounce logic
class ConnectivityService {
  final InternetConnection _connection;
  final StreamController<bool> _controller = StreamController<bool>.broadcast();
  StreamSubscription<InternetStatus>? _subscription;
  Timer? _debounceTimer;

  ConnectivityService({InternetConnection? connection})
    : _connection = connection ?? InternetConnection() {
    _startListening();
  }

  void _startListening() {
    _subscription = _connection.onStatusChange.listen((status) {
      _debounceTimer?.cancel();

      if (status == InternetStatus.disconnected) {
        // Debounce offline: wait 3 seconds before emitting
        _debounceTimer = Timer(const Duration(seconds: 3), () {
          _controller.add(false);
        });
      } else {
        // Online: emit immediately
        _controller.add(true);
      }
    });
  }

  Stream<bool> get onlineStream => _controller.stream;

  Future<bool> get isOnline => _connection.hasInternetAccess;

  void dispose() {
    _subscription?.cancel();
    _debounceTimer?.cancel();
    _controller.close();
  }
}
```

### Show Persistent MaterialBanner
```dart
// Source: Flutter MaterialBanner API documentation
void showOfflineBanner(BuildContext context) {
  ScaffoldMessenger.of(context).showMaterialBanner(
    MaterialBanner(
      content: const Text('No internet connection'),
      backgroundColor: Colors.red.shade700,
      leading: const Icon(Icons.wifi_off, color: Colors.white),
      actions: [
        // Required by API, use empty widget if no action needed
        const SizedBox.shrink(),
      ],
    ),
  );
}

void hideOfflineBanner(BuildContext context) {
  ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
}
```

### Check Internet Before Write Action
```dart
// Source: FeedBloc implementation (feed_bloc.dart:299-307)
Future<void> _onCreatePost(
  CreatePostEvent event,
  Emitter<PostState> emit,
) async {
  // Guard: check connectivity before write
  final isOnline = await _internetConnection.hasInternetAccess;
  if (!isOnline) {
    emit(currentState.copyWith(
      error: 'Cannot create post while offline',
      isOfflineError: true,
    ));
    return;
  }

  // Proceed with write operation
  final result = await postRepository.createPost(event.content);
  // ... handle result
}
```

### Disabled Button with Offline Feedback
```dart
// Source: Flutter ElevatedButton + Material Design disabled state
class PostButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isOnline ? onPressed : () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Offline mode'),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isOnline ? null : Colors.grey.shade400,
        foregroundColor: isOnline ? null : Colors.grey.shade700,
      ),
      child: Opacity(
        opacity: isOnline ? 1.0 : 0.5,
        child: const Text('Post'),
      ),
    );
  }
}
```

### Pull-to-Refresh with Sync Progress
```dart
// Source: Flutter RefreshIndicator API + LinearProgressIndicator
class SyncableFeedList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sync progress indicator
        BlocBuilder<FeedBloc, FeedState>(
          buildWhen: (prev, curr) =>
            prev is FeedRefreshing != curr is FeedRefreshing,
          builder: (context, state) {
            if (state is FeedRefreshing) {
              return const LinearProgressIndicator(minHeight: 2);
            }
            return const SizedBox(height: 2);
          },
        ),
        // Refreshable list
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              final bloc = context.read<FeedBloc>();
              bloc.add(const FeedEvent.refreshFeed());
              await bloc.stream.firstWhere((s) => s is! FeedRefreshing);
            },
            child: BlocBuilder<FeedBloc, FeedState>(
              builder: (context, state) {
                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.items.length,
                  itemBuilder: (context, index) => FeedItemWidget(
                    item: state.items[index],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| connectivity_plus alone | internet_connection_checker_plus for actual internet, connectivity_plus for diagnostics | 2023+ | More accurate offline detection; catches captive portals, DNS failures |
| Global connectivity flag | BLoC-based reactive connectivity state | BLoC adoption | Automatic UI updates, testable, follows app architecture |
| Blocking dialogs for offline | Persistent banner + disabled actions | Material Design 3 | Less intrusive, user can still browse cached content |
| Manual retry buttons | Automatic sync on reconnect | Realtime subscriptions | Seamless UX, data appears when connection restored |

**Deprecated/outdated:**
- `connectivity` (without _plus): Unmaintained, replaced by connectivity_plus
- `data_connection_checker`: Replaced by internet_connection_checker_plus
- Showing AlertDialog for offline state: Use MaterialBanner instead (non-blocking, persistent)

## Open Questions

Things that couldn't be fully resolved:

1. **Supabase realtime subscription behavior during reconnect**
   - What we know: Supabase Flutter SDK has built-in reconnection logic for realtime channels
   - What's unclear: Whether reconnection automatically re-fetches missed updates or needs manual sync
   - Recommendation: Test reconnection behavior; may need to trigger manual sync on reconnect to ensure data consistency

2. **Conflict resolution for last-write-wins**
   - What we know: Requirement SYNC-02 specifies last-write-wins for conflicts
   - What's unclear: Supabase handles this at database level (timestamps), but needs verification for local Hive → Supabase sync
   - Recommendation: Verify that Hive updates don't overwrite newer Supabase data. Likely need to compare `updated_at` timestamps before syncing.

3. **Sync operation logging granularity**
   - What we know: SYNC-03 requires logging sync operations for debugging
   - What's unclear: Whether to log at row level or table level, and performance impact
   - Recommendation: Start with table-level logging (`talker.info('Synced posts: 15 items')`), add row-level if debugging issues arise

## Sources

### Primary (HIGH confidence)
- `/outdatedguy/internet_connection_checker_plus` (Context7) - Connectivity checking, stream listening, hasInternetAccess API
- `/websites/pub_dev_packages_connectivity_plus` (Context7) - Network type detection, onConnectivityChanged stream
- `/felangel/bloc` (Context7) - BLoC patterns, BlocListener, BlocConsumer, state management
- https://api.flutter.dev/flutter/material/MaterialBanner-class.html - MaterialBanner API, showMaterialBanner usage
- https://api.flutter.dev/flutter/material/RefreshIndicator-class.html - RefreshIndicator API, programmatic refresh
- FeedBloc implementation (feed_bloc.dart) - Existing connectivity patterns in codebase

### Secondary (MEDIUM confidence)
- pubspec.yaml - Current package versions and dependencies

### Tertiary (LOW confidence)
- General Flutter offline UX best practices from WebSearch (2026) - Marked for validation with official docs

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - All packages already in use, versions verified from pubspec.yaml
- Architecture: HIGH - Patterns verified from existing FeedBloc implementation and Context7 documentation
- Pitfalls: MEDIUM - Common issues identified from package docs and existing code, but not exhaustively tested in this codebase

**Research date:** 2026-01-30
**Valid until:** 2026-03-01 (30 days - stable Flutter packages, established patterns)
