import 'package:freezed_annotation/freezed_annotation.dart';

part 'connectivity_state.freezed.dart';

@freezed
sealed class ConnectivityState with _$ConnectivityState {
  const factory ConnectivityState.online() = ConnectivityOnline;
  const factory ConnectivityState.offline() = ConnectivityOffline;
}
