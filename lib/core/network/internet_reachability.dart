import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Abstraction over [InternetConnection] so [ConnectivityBloc] can be tested with
/// controlled streams and reachability results.
class InternetReachability {
  InternetReachability._({
    required Future<bool> Function() hasInternetAccessFn,
    required Stream<InternetStatus> onStatusChangeStream,
  }) : _hasInternetAccessFn = hasInternetAccessFn,
       _onStatusChangeStream = onStatusChangeStream;

  factory InternetReachability.fromConnection([
    InternetConnection? connection,
  ]) {
    final c = connection ?? InternetConnection();
    return InternetReachability._(
      hasInternetAccessFn: () => c.hasInternetAccess,
      onStatusChangeStream: c.onStatusChange,
    );
  }

  /// Test-only factory with explicit behavior.
  factory InternetReachability.test({
    required Future<bool> Function() hasInternetAccess,
    required Stream<InternetStatus> onStatusChange,
  }) => InternetReachability._(
    hasInternetAccessFn: hasInternetAccess,
    onStatusChangeStream: onStatusChange,
  );

  final Future<bool> Function() _hasInternetAccessFn;
  final Stream<InternetStatus> _onStatusChangeStream;

  Future<bool> get hasInternetAccess => _hasInternetAccessFn();

  Stream<InternetStatus> get onStatusChange => _onStatusChangeStream;
}
