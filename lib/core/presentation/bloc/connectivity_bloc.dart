import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:myitihas/core/logging/talker_setup.dart';
import 'package:myitihas/core/network/internet_reachability.dart';

import 'connectivity_event.dart';
import 'connectivity_state.dart';

@injectable
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final InternetReachability _reachability;
  StreamSubscription<InternetStatus>? _subscription;
  int _debounceGeneration = 0;

  /// When false, stream `disconnected` events are ignored (OS often reports them while backgrounded).
  bool _appLifecycleResumed = true;

  ConnectivityBloc({InternetReachability? reachability})
    : _reachability = reachability ?? InternetReachability.fromConnection(),
      super(const ConnectivityState.online()) {
    // Register event handlers
    on<CheckConnectivityEvent>(_onCheckConnectivity);
    on<ConnectivityChangedEvent>(_onConnectivityChanged);
    on<AppLifecycleChangedEvent>(_onAppLifecycleChanged);

    // Subscribe to connectivity changes
    _subscription = _reachability.onStatusChange.listen((status) {
      add(ConnectivityEvent.connectivityChanged(status));
    });

    // Check connectivity immediately
    add(const ConnectivityEvent.checkConnectivity());
  }

  void _onAppLifecycleChanged(
    AppLifecycleChangedEvent event,
    Emitter<ConnectivityState> emit,
  ) {
    _appLifecycleResumed = event.state == AppLifecycleState.resumed;
    if (event.state == AppLifecycleState.resumed) {
      add(const ConnectivityEvent.checkConnectivity());
    }
  }

  Future<void> _onCheckConnectivity(
    CheckConnectivityEvent event,
    Emitter<ConnectivityState> emit,
  ) async {
    // Invalidate any pending debounced transition from status stream events.
    // This prevents stale delayed "offline" emissions from overriding a fresh check
    // (e.g. app resumed after device sleep with internet already restored).
    _debounceGeneration++;
    final checkGeneration = _debounceGeneration;

    final hasInternet = await _reachability.hasInternetAccess;
    if (hasInternet) {
      emit(const ConnectivityState.online());
      return;
    }

    // Devices can briefly report no internet right after unlock/resume while
    // radios and DNS are warming up. Re-check once before showing offline UI.
    await Future.delayed(const Duration(milliseconds: 1200));
    if (isClosed || emit.isDone) return;
    if (_debounceGeneration != checkGeneration) return;

    final stillOffline = !(await _reachability.hasInternetAccess);
    if (stillOffline) {
      emit(const ConnectivityState.offline());
    } else {
      emit(const ConnectivityState.online());
      talker.info(
        '[ConnectivityBloc] Ignored transient offline result during manual check',
      );
    }
  }

  Future<void> _onConnectivityChanged(
    ConnectivityChangedEvent event,
    Emitter<ConnectivityState> emit,
  ) async {
    // Increment generation to invalidate any pending debounce
    _debounceGeneration++;

    if (event.status == InternetStatus.disconnected) {
      if (!_appLifecycleResumed) return;

      // Debounce offline transitions by 3 seconds to prevent strobe effect
      final myGeneration = _debounceGeneration;
      await Future.delayed(const Duration(seconds: 3));
      if (!isClosed && !emit.isDone && _debounceGeneration == myGeneration) {
        // Re-validate connectivity before emitting offline to avoid false negatives
        // from transient disconnect callbacks after resume/background transitions.
        final hasInternet = await _reachability.hasInternetAccess;
        if (hasInternet) {
          emit(const ConnectivityState.online());
          talker.info(
            '[ConnectivityBloc] Skipped stale offline event; internet is available',
          );
        } else {
          emit(const ConnectivityState.offline());
          talker.warning('[ConnectivityBloc] Device is offline');
        }
      }
    } else {
      // Short debounce: recover quickly after background without strobing on flaky links
      final myGeneration = _debounceGeneration;
      await Future.delayed(const Duration(milliseconds: 400));
      if (!isClosed && !emit.isDone && _debounceGeneration == myGeneration) {
        emit(const ConnectivityState.online());
        talker.info('[ConnectivityBloc] Device is online');
      }
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
