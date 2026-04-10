import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:myitihas/models/conversation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// In-memory + SharedPreferences cache for chat conversations and Krishna history
/// so lists show immediately when reopening ChatItihas or Chatbot.
@lazySingleton
class ChatConversationCache {
  ChatConversationCache(SharedPreferences prefs) : _prefs = prefs;

  final SharedPreferences _prefs;

  static const _keyConversationsDm = 'chat_conversations_dm';
  static const _keyConversationsGroup = 'chat_conversations_group';
  static String _krishnaKey(String userId) => 'chat_krishna_$userId';

  /// Returns cached DM or group conversations, or null if none.
  List<Conversation>? getCachedConversations({bool? isGroup}) {
    final key = isGroup == true
        ? _keyConversationsGroup
        : isGroup == false
            ? _keyConversationsDm
            : null;
    if (key == null) return null;
    final json = _prefs.getString(key);
    if (json == null || json.isEmpty) return null;
    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list
          .map((e) => Conversation.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  /// Saves conversations for the given tab (DM or group).
  Future<void> saveConversations(
    List<Conversation> conversations, {
    bool? isGroup,
  }) async {
    if (isGroup == null) return;
    final key =
        isGroup ? _keyConversationsGroup : _keyConversationsDm;
    final list = conversations.map((c) => c.toJson()).toList();
    await _prefs.setString(key, jsonEncode(list));
  }

  /// Returns cached Krishna conversation list for the current user, or null.
  List<Map<String, dynamic>>? getCachedKrishnaConversations() {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return null;
    final json = _prefs.getString(_krishnaKey(userId));
    if (json == null || json.isEmpty) return null;
    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return null;
    }
  }

  /// Saves Krishna conversation list for the current user.
  Future<void> saveKrishnaConversations(
    List<Map<String, dynamic>> conversations,
  ) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    await _prefs.setString(
      _krishnaKey(userId),
      jsonEncode(conversations),
    );
  }
}
