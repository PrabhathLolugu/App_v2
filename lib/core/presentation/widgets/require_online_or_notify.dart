import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myitihas/core/presentation/bloc/connectivity_bloc.dart';
import 'package:myitihas/core/presentation/bloc/connectivity_event.dart';
import 'package:myitihas/core/presentation/bloc/connectivity_state.dart';

/// If [ConnectivityBloc] reports online, runs [whenOnline] immediately.
/// Otherwise shows a [SnackBar] with **Retry** (re-checks connectivity and runs
/// [whenOnline] when the bloc becomes online).
void requireOnlineOrNotify(
  BuildContext context,
  VoidCallback whenOnline, {
  String message = 'No internet connection',
}) {
  final bloc = context.read<ConnectivityBloc>();
  if (bloc.state is ConnectivityOnline) {
    whenOnline();
    return;
  }

  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 8),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () => unawaited(
            _retryConnectivityThenRun(context, bloc, whenOnline, messenger),
          ),
        ),
      ),
    );
}

Future<void> _retryConnectivityThenRun(
  BuildContext context,
  ConnectivityBloc bloc,
  VoidCallback whenOnline,
  ScaffoldMessengerState messenger,
) async {
  bloc.add(const ConnectivityEvent.checkConnectivity());
  if (bloc.state is ConnectivityOnline) {
    whenOnline();
    messenger.hideCurrentSnackBar();
    return;
  }
  try {
    await bloc.stream
        .firstWhere((s) => s is ConnectivityOnline)
        .timeout(const Duration(seconds: 20));
    if (!context.mounted) return;
    whenOnline();
    messenger.hideCurrentSnackBar();
  } on TimeoutException {
    // Still offline; snackbar remains until dismissed or another retry
  }
}
