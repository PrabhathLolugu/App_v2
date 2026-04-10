import 'package:injectable/injectable.dart';

/// Keeps the active Little Krishna chat session in memory for the app lifetime.
@lazySingleton
class KrishnaChatSessionHolder {
  List<Map<String, dynamic>> _messagesJson = <Map<String, dynamic>>[];
  String? _currentSessionId;
  String _mode = 'friend';
  List<String> _suggestions = <String>[];

  List<Map<String, dynamic>> get messagesJson =>
      _messagesJson.map((message) => Map<String, dynamic>.from(message)).toList();

  String? get currentSessionId => _currentSessionId;

  String get mode => _mode;

  List<String> get suggestions => List<String>.from(_suggestions);

  bool get hasSnapshot => _messagesJson.isNotEmpty;

  void saveSnapshot({
    required List<Map<String, dynamic>> messagesJson,
    required String? currentSessionId,
    required String mode,
    required List<String> suggestions,
  }) {
    _messagesJson = messagesJson
        .map((message) => Map<String, dynamic>.from(message))
        .toList();
    _currentSessionId = currentSessionId;
    _mode = mode;
    _suggestions = List<String>.from(suggestions);
  }

  void clear() {
    _messagesJson = <Map<String, dynamic>>[];
    _currentSessionId = null;
    _mode = 'friend';
    _suggestions = <String>[];
  }
}
