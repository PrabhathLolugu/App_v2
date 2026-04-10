import 'package:freezed_annotation/freezed_annotation.dart';

part 'cache_config.freezed.dart';
part 'cache_config.g.dart';

@freezed
abstract class CacheConfig with _$CacheConfig {
  const factory CacheConfig({
    @Default(500 * 1024 * 1024) int imageCacheSizeBytes, // 500 MB default
    @Default(300 * 1024 * 1024) int videoCacheSizeBytes, // 300 MB default
    @Default(200 * 1024 * 1024) int audioCacheSizeBytes, // 200 MB default
    @Default(false) bool wifiOnlyMode, // Download on cellular by default
  }) = _CacheConfig;

  factory CacheConfig.fromJson(Map<String, dynamic> json) =>
      _$CacheConfigFromJson(json);
}
