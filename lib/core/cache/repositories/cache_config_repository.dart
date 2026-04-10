import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myitihas/core/cache/models/cache_config.dart';
import 'package:myitihas/core/logging/talker_setup.dart';

@lazySingleton
class CacheConfigRepository {
  static const String _cacheConfigKey = 'cache_config';

  final SharedPreferences _prefs;

  CacheConfigRepository(this._prefs);

  /// Load cache configuration from SharedPreferences
  /// Returns default config if not found
  CacheConfig loadConfig() {
    try {
      final jsonString = _prefs.getString(_cacheConfigKey);
      if (jsonString == null) {
        talker.info('No cache config found, using defaults');
        return const CacheConfig();
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return CacheConfig.fromJson(json);
    } catch (e) {
      talker.error('Failed to load cache config, using defaults', e);
      return const CacheConfig();
    }
  }

  /// Save cache configuration to SharedPreferences
  Future<void> saveConfig(CacheConfig config) async {
    try {
      final jsonString = jsonEncode(config.toJson());
      await _prefs.setString(_cacheConfigKey, jsonString);
      talker.info('Cache config saved');
    } catch (e) {
      talker.error('Failed to save cache config', e);
    }
  }

  /// Reset to default configuration
  Future<void> resetConfig() async {
    await _prefs.remove(_cacheConfigKey);
    talker.info('Cache config reset to defaults');
  }
}
