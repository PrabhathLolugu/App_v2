import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myitihas/core/cache/models/cache_config.dart';

part 'cache_settings_state.freezed.dart';

@freezed
abstract class CacheSettingsState with _$CacheSettingsState {
  const factory CacheSettingsState({
    required CacheConfig config,
    required int imageUsageBytes,
    required int videoUsageBytes,
    required int audioUsageBytes,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _CacheSettingsState;

  factory CacheSettingsState.initial() => const CacheSettingsState(
        config: CacheConfig(),
        imageUsageBytes: 0,
        videoUsageBytes: 0,
        audioUsageBytes: 0,
      );
}
