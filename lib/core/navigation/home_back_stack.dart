import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Tracks `/home` tab/map transitions so hardware back can replay exact history.
class HomeBackStack {
  HomeBackStack._();

  static const int _maxHistory = 80;
  static const String _homeRoot = '/home';

  static final List<String> _history = <String>[];
  static String? _currentHomeLocation;
  static bool _skipNextTrack = false;

  static void track(Uri uri) {
    final normalized = _normalizeHomeLocation(uri);
    if (normalized == null) return;

    if (_skipNextTrack) {
      _skipNextTrack = false;
      _currentHomeLocation = normalized;
      return;
    }

    if (_currentHomeLocation == null) {
      _currentHomeLocation = normalized;
      return;
    }

    if (_currentHomeLocation == normalized) return;

    _history.add(_currentHomeLocation!);
    if (_history.length > _maxHistory) {
      _history.removeAt(0);
    }
    _currentHomeLocation = normalized;
  }

  static bool goBack(BuildContext context) {
    if (_history.isEmpty) return false;

    final previous = _history.removeLast();
    _skipNextTrack = true;
    _currentHomeLocation = previous;
    context.go(previous);
    return true;
  }

  static void goBackOrHome(BuildContext context, {String fallback = '/home?tab=2'}) {
    if (context.canPop()) {
      context.pop();
      return;
    }

    if (goBack(context)) {
      return;
    }

    context.go(fallback);
  }

  static bool isAtHomeRoot(Uri uri) {
    final normalized = _normalizeHomeLocation(uri);
    return normalized == _homeRoot;
  }

  static String? _normalizeHomeLocation(Uri uri) {
    if (uri.path != '/home') return null;

    final tab = uri.queryParameters['tab'];
    final map = uri.queryParameters['map'];
    final normalizedTab = (tab != null && tab.isNotEmpty) ? tab : null;
    final normalizedMap = (map != null && map.isNotEmpty) ? map : null;

    if (normalizedTab == null && normalizedMap == null) {
      return _homeRoot;
    }

    final queryParams = <String, String>{};
    if (normalizedTab != null) {
      queryParams['tab'] = normalizedTab;
    }
    if (normalizedMap != null) {
      queryParams['map'] = normalizedMap;
    }

    final query = Uri(queryParameters: queryParams).query;
    return query.isEmpty ? _homeRoot : '/home?$query';
  }
}
