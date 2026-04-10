import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:myitihas/core/network/internet_reachability.dart';
import 'package:myitihas/core/presentation/bloc/connectivity_bloc.dart';
import 'package:myitihas/core/presentation/bloc/connectivity_event.dart';
import 'package:myitihas/core/presentation/bloc/connectivity_state.dart';

void main() {
  group('ConnectivityBloc', () {
    late StreamController<InternetStatus> statusController;
    late bool access;
    late InternetReachability reachability;

    setUp(() {
      statusController = StreamController<InternetStatus>.broadcast();
      access = true;
      reachability = InternetReachability.test(
        hasInternetAccess: () async => access,
        onStatusChange: statusController.stream,
      );
    });

    tearDown(() async {
      await statusController.close();
    });

    test(
      'ignores stream disconnected while app not resumed (no offline state)',
      () async {
        final bloc = ConnectivityBloc(reachability: reachability);
        await Future<void>.delayed(Duration.zero);

        bloc.add(
          const ConnectivityEvent.appLifecycleChanged(AppLifecycleState.paused),
        );
        bloc.add(
          ConnectivityEvent.connectivityChanged(InternetStatus.disconnected),
        );

        await Future<void>.delayed(const Duration(seconds: 4));

        expect(bloc.state, isA<ConnectivityOnline>());
        await bloc.close();
      },
    );

    test(
      'after resume, disconnected with no access eventually emits offline',
      () async {
        final bloc = ConnectivityBloc(reachability: reachability);
        await Future<void>.delayed(Duration.zero);

        bloc.add(
          const ConnectivityEvent.appLifecycleChanged(AppLifecycleState.paused),
        );
        bloc.add(
          const ConnectivityEvent.appLifecycleChanged(AppLifecycleState.resumed),
        );
        access = false;
        bloc.add(
          ConnectivityEvent.connectivityChanged(InternetStatus.disconnected),
        );

        await Future<void>.delayed(const Duration(seconds: 4));

        expect(bloc.state, isA<ConnectivityOffline>());
        await bloc.close();
      },
    );

    test('stale manual check does not emit after newer generation', () async {
      access = false;
      final bloc = ConnectivityBloc(reachability: reachability);

      bloc.add(const ConnectivityEvent.checkConnectivity());
      await Future<void>.delayed(const Duration(milliseconds: 100));
      access = true;
      bloc.add(const ConnectivityEvent.checkConnectivity());

      await Future<void>.delayed(const Duration(milliseconds: 1500));

      expect(bloc.state, isA<ConnectivityOnline>());
      await bloc.close();
    });
  });
}
