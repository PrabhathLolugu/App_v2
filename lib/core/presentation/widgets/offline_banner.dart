import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/core/presentation/bloc/connectivity_bloc.dart';
import 'package:myitihas/core/presentation/bloc/connectivity_event.dart';
import 'package:myitihas/core/presentation/bloc/connectivity_state.dart';

class OfflineBanner extends StatefulWidget {
  const OfflineBanner({super.key});

  @override
  State<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends State<OfflineBanner>
    with WidgetsBindingObserver {
  DateTime? _lastSnackbarTime;
  static const Duration _snackbarCooldown = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (mounted) {
      context.read<ConnectivityBloc>().add(
        ConnectivityEvent.appLifecycleChanged(state),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConnectivityBloc, ConnectivityState>(
      listenWhen: (previous, current) {
        return previous.runtimeType != current.runtimeType;
      },
      listener: (context, state) {
        state.when(
          online: () {
            final navContext = MyItihasRouter.rootNavigatorKey.currentContext;
            if (navContext != null) {
              final now = DateTime.now();
              if (_lastSnackbarTime == null ||
                  now.difference(_lastSnackbarTime!) >= _snackbarCooldown) {
                _lastSnackbarTime = now;
                ScaffoldMessenger.of(navContext).showSnackBar(
                  const SnackBar(
                    content: Text('Back online'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            }
          },
          offline: () {
            // No global blocking UI; use [requireOnlineOrNotify] on network actions.
          },
        );
      },
      builder: (context, state) {
        return const SizedBox.shrink();
      },
    );
  }
}
