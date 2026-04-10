import 'package:shared_preferences/shared_preferences.dart';

const String _keyShownUserIds = 'people_connect_shown_user_ids';
const int _maxShownUserIds = 50;

/// Persists user IDs that were recently shown in follow suggestions
/// so we avoid showing the same profiles again and again.
class PeopleConnectSuggestionStorageService {
  PeopleConnectSuggestionStorageService(this._prefs);

  final SharedPreferences _prefs;

  Set<String>? _cachedIds;

  /// Returns the set of user IDs that were recently shown.
  Future<Set<String>> getShownUserIds() async {
    if (_cachedIds != null) return _cachedIds!;
    final json = _prefs.getString(_keyShownUserIds);
    if (json == null || json.isEmpty) {
      _cachedIds = {};
      return _cachedIds!;
    }
    try {
      _cachedIds = (json.split(',').where((s) => s.isNotEmpty)).toSet();
      return _cachedIds!;
    } catch (_) {
      _cachedIds = {};
      return _cachedIds!;
    }
  }

  /// Records these user IDs as having been shown. Evicts oldest if over limit.
  Future<void> addShownUserIds(Iterable<String> ids) async {
    var current = await getShownUserIds();
    current = {...current, ...ids};
    if (current.length > _maxShownUserIds) {
      // Evict oldest by taking last N (order not preserved, but we cap size)
      final list = current.toList();
      final toKeep = list.sublist(list.length - _maxShownUserIds);
      current = toKeep.toSet();
    }
    _cachedIds = current;
    await _prefs.setString(
      _keyShownUserIds,
      current.join(','),
    );
  }

  /// Clears the stored shown IDs (e.g. for testing or reset).
  Future<void> clear() async {
    _cachedIds = {};
    await _prefs.remove(_keyShownUserIds);
  }
}
