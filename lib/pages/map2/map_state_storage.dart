import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MapStateStorage {
  static const _intentsKey = 'map.selected_intents';
  static const _filtersKey = 'map.active_filters';

  static Future<void> saveSelectedIntents(List<String> intents) async {
    final prefs = await SharedPreferences.getInstance();
    final normalized = intents
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
    await prefs.setString(_intentsKey, jsonEncode(normalized));
  }

  static Future<List<String>> loadSelectedIntents() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_intentsKey);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded
          .map((e) => e?.toString().trim() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  static Future<void> saveActiveFilters(List<String> filters) async {
    final prefs = await SharedPreferences.getInstance();
    final normalized = filters
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
    await prefs.setString(_filtersKey, jsonEncode(normalized));
  }

  static Future<List<String>> loadActiveFilters() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_filtersKey);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded
          .map((e) => e?.toString().trim() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    } catch (_) {
      return const [];
    }
  }
}
