import 'package:shared_preferences/shared_preferences.dart';

const String _keyCooldownUntil = 'people_connect_cooldown_until';

/// Tracks follow limit for "People to connect": after 10 follows from that
/// flow, user cannot follow again for 1 hour. Cooldown is persisted.
class PeopleConnectFollowLimitService {
  PeopleConnectFollowLimitService(this._prefs);

  final SharedPreferences _prefs;

  int _followCountThisSession = 0;
  DateTime? _cooldownUntil;

  /// Call when the suggestions sheet is opened. Resets session count if not in cooldown.
  void onSheetOpened() {
    _cooldownUntil = _loadCooldownUntil();
    if (!isInCooldown) {
      _followCountThisSession = 0;
    }
  }

  bool get isInCooldown {
    final until = _cooldownUntil ?? _loadCooldownUntil();
    if (until == null) return false;
    if (DateTime.now().isAfter(until)) {
      _clearCooldown();
      return false;
    }
    return true;
  }

  DateTime? get cooldownEnd => _cooldownUntil ?? _loadCooldownUntil();

  /// Minutes remaining in cooldown (0 if not in cooldown).
  int get cooldownMinutesRemaining {
    final until = cooldownEnd;
    if (until == null) return 0;
    final diff = until.difference(DateTime.now());
    if (diff.isNegative) return 0;
    return diff.inMinutes + (diff.inSeconds > 0 ? 1 : 0);
  }

  /// Call after user successfully follows someone from the sheet.
  /// Returns true if cooldown was just triggered (10th follow).
  Future<bool> recordFollow() async {
    _followCountThisSession++;
    if (_followCountThisSession >= 10) {
      final until = DateTime.now().add(const Duration(hours: 1));
      await _prefs.setString(_keyCooldownUntil, until.toIso8601String());
      _cooldownUntil = until;
      return true;
    }
    return false;
  }

  DateTime? _loadCooldownUntil() {
    final s = _prefs.getString(_keyCooldownUntil);
    if (s == null) return null;
    _cooldownUntil = DateTime.tryParse(s);
    return _cooldownUntil;
  }

  Future<void> _clearCooldown() async {
    await _prefs.remove(_keyCooldownUntil);
    _cooldownUntil = null;
  }
}
