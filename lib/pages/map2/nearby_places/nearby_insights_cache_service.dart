import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class NearbyInsightsCacheService {
  static const Duration defaultTtl = Duration(hours: 12);

  static String _storageKey(String cacheKey) => 'nearby_insights_cache::$cacheKey';

  Future<Map<String, dynamic>?> read(
    String cacheKey, {
    Duration ttl = defaultTtl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey(cacheKey));
    if (raw == null || raw.isEmpty) return null;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;

      final savedAtRaw = decoded['savedAt']?.toString();
      final data = decoded['data'];
      if (savedAtRaw == null || data is! Map) {
        await prefs.remove(_storageKey(cacheKey));
        return null;
      }

      final savedAt = DateTime.tryParse(savedAtRaw);
      if (savedAt == null || DateTime.now().difference(savedAt) > ttl) {
        await prefs.remove(_storageKey(cacheKey));
        return null;
      }

      return Map<String, dynamic>.from(data);
    } catch (_) {
      await prefs.remove(_storageKey(cacheKey));
      return null;
    }
  }

  Future<void> write(String cacheKey, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey(cacheKey),
      jsonEncode({
        'savedAt': DateTime.now().toIso8601String(),
        'data': data,
      }),
    );
  }

  Future<void> remove(String cacheKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey(cacheKey));
  }
}