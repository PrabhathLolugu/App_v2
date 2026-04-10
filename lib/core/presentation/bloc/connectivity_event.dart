import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

part 'connectivity_event.freezed.dart';

@freezed
sealed class ConnectivityEvent with _$ConnectivityEvent {
  const factory ConnectivityEvent.checkConnectivity() = CheckConnectivityEvent;
  const factory ConnectivityEvent.connectivityChanged(InternetStatus status) =
      ConnectivityChangedEvent;
  const factory ConnectivityEvent.appLifecycleChanged(
    AppLifecycleState state,
  ) = AppLifecycleChangedEvent;
}
