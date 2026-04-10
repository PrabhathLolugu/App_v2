import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages
  // Note: This runs in a separate isolate, so we can't access the main app state
  debugPrint('[FCM] Background message received: ${message.messageId}');
}

/// Service for managing Firebase Cloud Messaging push notifications
///
/// Handles:
/// - FCM token registration and refresh
/// - Foreground, background, and terminated message handling
/// - Token storage in Supabase user_devices table
/// - Local notification display for foreground messages
@lazySingleton
class FCMService {
  final FirebaseMessaging _messaging;
  final SupabaseClient _supabase;
  final Talker _logger;
  final FlutterLocalNotificationsPlugin _localNotifications;

  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<String>? _tokenRefreshSubscription;
  bool _isInitialized = false;
  Future<void>? _initializationFuture;
  String? _initializedUserId;
  bool _tapHandlersInitialized = false;
  bool _iosTapBridgeInitialized = false;
  final Map<String, DateTime> _recentOpenEvents = <String, DateTime>{};
  static const Duration _openDedupeWindow = Duration(seconds: 2);

  final StreamController<Map<String, String>> _notificationOpenController =
      StreamController<Map<String, String>>.broadcast();

  // Android notification channel
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'myitihas_notifications',
    'MyItihas Notifications',
    description: 'Notifications for likes, comments, follows, and messages',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
  );
  static const int _chatNotificationIdSeed = 730000;

  FCMService(this._messaging, this._supabase, this._logger)
    : _localNotifications = FlutterLocalNotificationsPlugin();

  /// Initialize FCM service
  ///
  /// Should be called after user authentication in main.dart.
  /// Sets up message handlers, requests permissions, and registers FCM token.
  Future<void> initialize() async {
    // Always wire up tap handlers, even if auth/token setup is skipped.
    await initializeTapHandlers();

    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) {
      _logger.warning('[FCM] Cannot initialize: user not authenticated');
      return;
    }

    if (_initializationFuture != null) {
      _logger.debug('[FCM] Initialization already in progress, waiting');
      await _initializationFuture;
      return;
    }

    if (_isInitialized) {
      if (_initializedUserId != currentUser.id) {
        _logger.info('[FCM] Auth user changed, refreshing token registration');
      }
      _initializedUserId = currentUser.id;
      await _saveTokenToDatabase();
      return;
    }

    _initializationFuture = _initializeForAuthenticatedUser(currentUser.id);
    try {
      await _initializationFuture;
    } finally {
      _initializationFuture = null;
    }
  }

  Future<void> _initializeForAuthenticatedUser(String userId) async {
    try {
      _logger.info('[FCM] Initializing...');

      // Set background message handler
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      // Request notification permissions
      final settings = await _requestPermissions();
      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        _logger.warning('[FCM] Notifications not authorized');
        return;
      }

      // Local notifications are initialized in initializeTapHandlers().

      // Get and save FCM token
      await _saveTokenToDatabase();

      // Listen for token refresh
      _tokenRefreshSubscription = _messaging.onTokenRefresh.listen((newToken) {
        _logger.info('[FCM] Token refreshed');
        _saveTokenToDatabase(token: newToken);
      });

      // Handle foreground messages
      _foregroundSubscription = FirebaseMessaging.onMessage.listen(
        _handleForegroundMessage,
      );

      _isInitialized = true;
      _initializedUserId = userId;
      _logger.info('[FCM] Initialized successfully');
    } catch (e, stackTrace) {
      _logger.error('[FCM] Initialization failed', e, stackTrace);
    }
  }

  /// Initialize notification tap handling.
  ///
  /// This must NOT depend on authentication so that tapping a notification
  /// always routes correctly, even from a terminated state.
  Future<void> initializeTapHandlers() async {
    if (_tapHandlersInitialized) return;
    _tapHandlersInitialized = true;

    try {
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Required so foreground notifications (local) can deep-link on tap.
      await _initializeLocalNotifications();

      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpened);

      // iOS simulator `simctl push` can deliver taps without triggering
      // firebase_messaging open callbacks. Bridge native tap payloads.
      if (Platform.isIOS) {
        _initializeIosNotificationTapBridge();
      }
    } catch (e, stackTrace) {
      _logger.error('[FCM] Tap-handler initialization failed', e, stackTrace);
    }
  }

  void _initializeIosNotificationTapBridge() {
    if (_iosTapBridgeInitialized) return;
    _iosTapBridgeInitialized = true;

    const channel = MethodChannel('com.sachit.myitihas/notification_tap');
    channel.setMethodCallHandler((call) async {
      if (call.method != 'notification_tap') return;
      final args = call.arguments;
      if (args is! Map) return;

      final map = <String, dynamic>{};
      for (final entry in args.entries) {
        map[entry.key.toString()] = entry.value;
      }

      // Strip APS envelope if present; keep custom keys alongside.
      map.remove('aps');

      final data = _coerceToStringMap(map);
      if (data.isEmpty) return;
      _logger.debug('[FCM] iOS tap bridge payload: $data');
      _emitNotificationOpen(data, source: 'ios_tap_bridge');
    });
  }

  /// Must be called after the app/router is ready to navigate.
  ///
  /// `getInitialMessage()` represents the notification that opened the app from
  /// a terminated (cold start) state. If we emit this before listeners attach,
  /// the event is lost (broadcast streams do not replay).
  Future<void> handleInitialNotificationIfAny() async {
    try {
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage == null) return;
      _logger.info('[FCM] Handling initial notification (cold start)');
      _handleMessageOpened(initialMessage);
    } catch (e, stackTrace) {
      _logger.error('[FCM] Failed to handle initial notification', e, stackTrace);
    }
  }

  /// Request notification permissions
  Future<NotificationSettings> _requestPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    _logger.debug(
      '[FCM] Permission status: ${settings.authorizationStatus.name}',
    );

    // On iOS, get APNs token
    if (Platform.isIOS) {
      final apnsToken = await _messaging.getAPNSToken();
      _logger.debug('[FCM] APNs token available: ${apnsToken != null}');
    }

    return settings;
  }

  /// Initialize local notifications for foreground display
  Future<void> _initializeLocalNotifications() async {
    // Android: use launcher icon resource so drawer branding matches app icon
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS initialization - comprehensive setup for notifications
    final iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      requestProvisionalPermission: false,
      notificationCategories: [
        DarwinNotificationCategory(
          'REPLY_CATEGORY',
          actions: [
            DarwinNotificationAction.plain(
              'REPLY',
              'Reply',
              options: {DarwinNotificationActionOption.authenticationRequired},
            ),
          ],
        ),
      ],
    );

    final initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create Android notification channel
    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(_channel);
    }

    // Configure iOS UNUserNotificationCenter delegate for foreground notifications
    if (Platform.isIOS) {
      // Attempt to set up iOS notification center for custom handling
      final iosNotifications = _localNotifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();

      if (iosNotifications != null) {
        await iosNotifications.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    }

    _logger.debug('[FCM] Local notifications initialized');
  }

  /// Handle local notification tap (foreground notification or from background)
  void _onNotificationTap(NotificationResponse response) {
    _logger.debug('[FCM] Local notification tapped: ${response.payload}');
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    final data = _parsePayloadString(payload);
    if (data.isNotEmpty) {
      _notificationOpenController.add(data);
    }
  }

  /// Parse payload string "type=x&entity=y&id=z" into map for navigation
  Map<String, String> _parsePayloadString(String payload) {
    final map = <String, String>{};
    for (final part in payload.split('&')) {
      final idx = part.indexOf('=');
      if (idx > 0) {
        final key = part.substring(0, idx).trim();
        final value = Uri.decodeComponent(part.substring(idx + 1).trim());
        map[key] = value;
      }
    }
    // Map 'entity' -> entity_type, 'id' -> entity_id for consistency
    if (map.containsKey('entity')) map['entity_type'] = map['entity']!;
    if (map.containsKey('id')) map['entity_id'] = map['id']!;
    return map;
  }

  String _readDataValue(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value == null) continue;
      final asString = value.toString().trim();
      if (asString.isNotEmpty) return asString;
    }
    return '';
  }

  bool _isChatNotification(Map<String, dynamic> data) {
    final notificationType = _readDataValue(data, const [
      'notification_type',
      'type',
    ]).toLowerCase();
    if (notificationType == 'message' || notificationType == 'group_message') {
      return true;
    }

    final entityType = _readDataValue(data, const [
      'entity_type',
      'entity',
    ]).toLowerCase();
    return entityType == 'conversation';
  }

  String _extractConversationId(Map<String, dynamic> data) {
    return _readDataValue(data, const ['conversation_id']);
  }

  int _chatNotificationIdForConversation(String conversationId) {
    var hash = 0;
    for (final codeUnit in conversationId.codeUnits) {
      hash = (hash * 31 + codeUnit) & 0x7fffffff;
    }
    return _chatNotificationIdSeed + (hash % 1000000);
  }

  int _resolveNotificationId(Map<String, dynamic> data, RemoteMessage message) {
    if (_isChatNotification(data)) {
      final conversationId = _extractConversationId(data);
      if (conversationId.isNotEmpty) {
        final id = _chatNotificationIdForConversation(conversationId);
        _logger.debug(
          '[FCM] Using conversation-scoped notification id $id for conversation $conversationId',
        );
        return id;
      }
    }
    return message.hashCode;
  }

  /// Save FCM token to Supabase user_devices table
  Future<void> _saveTokenToDatabase({String? token}) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        _logger.warning('[FCM] Cannot save token: user not authenticated');
        return;
      }

      final fcmToken = token ?? await _messaging.getToken();
      if (fcmToken == null) {
        _logger.warning('[FCM] No FCM token available');
        return;
      }

      _logger.debug('[FCM] Saving token to database...');

      // Determine device type
      String deviceType;
      if (Platform.isIOS) {
        deviceType = 'ios';
      } else if (Platform.isAndroid) {
        deviceType = 'android';
      } else if (kIsWeb) {
        deviceType = 'web';
      } else {
        deviceType = 'android'; // Default fallback
      }

      // Build device info
      final deviceInfo = <String, dynamic>{
        'platform': Platform.operatingSystem,
        'version': Platform.operatingSystemVersion,
      };

      // Upsert device record (insert or update if token exists)
      await _supabase.from('user_devices').upsert({
        'user_id': currentUser.id,
        'fcm_token': fcmToken,
        'device_type': deviceType,
        'device_info': deviceInfo,
        'is_active': true,
        'last_active_at': DateTime.now().toUtc().toIso8601String(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }, onConflict: 'fcm_token');

      _logger.info('[FCM] Token saved successfully');
    } catch (e, stackTrace) {
      _logger.error('[FCM] Failed to save token', e, stackTrace);
    }
  }

  /// Handle foreground message - display as local notification
  /// Supports both notification payload and data-only (e.g. chat) messages.
  void _handleForegroundMessage(RemoteMessage message) {
    _logger.debug('[FCM] Foreground message: ${message.messageId}');

    String title;
    String body;
    final notification = message.notification;
    final data = message.data;

    if (notification != null) {
      title = notification.title ?? 'New Notification';
      body = notification.body ?? '';
    } else {
      // Data-only message (e.g. chat): build title/body from data so it shows as notification
      title =
          (data['title'] ?? data['sender_name'] ?? 'New message') as String? ??
          'New message';
      body =
          (data['body'] ?? data['content'] ?? data['message'] ?? '')
              as String? ??
          '';
      if (body.isEmpty && data.isNotEmpty) body = 'Tap to open';
    }

    final notificationId = _resolveNotificationId(data, message);

    _localNotifications.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF2244CF),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: _buildPayload(data),
    );
  }

  /// Build payload string from message data for navigation
  String _buildPayload(Map<String, dynamic> data) {
    // Create a simple payload that can be parsed for navigation
    final parts = <String>[];
    final payloadMap = <String, dynamic>{
      'type': data['notification_type'],
      'entity': data['entity_type'],
      'id': data['entity_id'],
      'conversation_id': data['conversation_id'],
      'sender_id': data['sender_id'],
      'sender_name': data['sender_name'],
      'sender_avatar_url': data['sender_avatar_url'] ?? data['avatar_url'],
      'is_group': data['is_group'],
      'content_type': data['content_type'],
      'target_comment_id': data['target_comment_id'],
      'parent_entity_type': data['parent_entity_type'],
      'parent_entity_id': data['parent_entity_id'],
      'actor_id': data['actor_id'],
      'url': data['action_url'],
    };

    for (final entry in payloadMap.entries) {
      final value = entry.value;
      if (value == null) continue;
      final asString = value.toString().trim();
      if (asString.isEmpty) continue;
      parts.add('${entry.key}=${Uri.encodeComponent(asString)}');
    }
    return parts.join('&');
  }

  /// Handle message opened (tap) when app is in background or terminated
  void _handleMessageOpened(RemoteMessage message) {
    _logger.info('[FCM] Message opened: ${message.messageId}');
    _logger.debug('[FCM] Data: ${message.data}');

    final data = _coerceToStringMap(message.data);
    if (data.isNotEmpty) {
      _emitNotificationOpen(
        data,
        source: 'firebase',
        messageId: message.messageId,
      );
      return;
    }

    _logger.warning(
      '[FCM] Notification opened but no data payload was present; cannot deep-link',
    );
  }

  void _emitNotificationOpen(
    Map<String, String> data, {
    required String source,
    String? messageId,
  }) {
    final key = _dedupeKeyForOpen(data, messageId: messageId);
    final now = DateTime.now();

    _recentOpenEvents.removeWhere(
      (_, ts) => now.difference(ts) > _openDedupeWindow,
    );

    final last = _recentOpenEvents[key];
    if (last != null && now.difference(last) <= _openDedupeWindow) {
      _logger.debug('[FCM] Dropping duplicate open ($source): $key');
      return;
    }

    _recentOpenEvents[key] = now;
    _logger.debug('[FCM] Emitting notification open ($source): $data');
    _notificationOpenController.add(data);
  }

  String _dedupeKeyForOpen(Map<String, String> data, {String? messageId}) {
    final mid = (messageId ?? '').trim();
    if (mid.isNotEmpty) return 'mid:$mid';

    String pick(List<String> keys) {
      for (final k in keys) {
        final v = data[k];
        if (v == null) continue;
        final t = v.trim();
        if (t.isNotEmpty) return t;
      }
      return '';
    }

    final type = pick(['notification_type', 'type', 'notificationType']);
    final entityType = pick(['entity_type', 'entity', 'entityType']);
    final entityId = pick(['entity_id', 'id', 'entityId']);
    final convoId = pick(['conversation_id', 'conversationId', 'chat_id', 'thread_id']);

    return 'data:t=$type|e=$entityType|id=$entityId|c=$convoId';
  }

  Map<String, String> _coerceToStringMap(Map<String, dynamic> raw) {
    if (raw.isEmpty) return const {};

    // Some backends wrap the payload as a JSON string under common keys.
    final wrapped = raw['data'] ?? raw['payload'] ?? raw['meta'];
    if (wrapped is String) {
      final trimmed = wrapped.trim();
      if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
        try {
          final decoded = jsonDecode(trimmed);
          if (decoded is Map) {
            return _coerceToStringMap(decoded.cast<String, dynamic>());
          }
        } catch (_) {
          // Fall through to raw map coercion below.
        }
      }
    }

    final out = <String, String>{};
    for (final entry in raw.entries) {
      final key = entry.key.toString().trim();
      if (key.isEmpty) continue;
      final dynamic v = entry.value;
      final value = (v is Map || v is List) ? jsonEncode(v) : v?.toString();
      final trimmed = value?.trim() ?? '';
      if (trimmed.isEmpty) continue;
      out[key] = trimmed;
    }
    return out;
  }

  /// Stream of notification open events (tap from background/terminated or local notification).
  /// Listeners can use entity_type and entity_id to navigate (e.g. to story).
  Stream<Map<String, String>> get notificationOpenStream =>
      _notificationOpenController.stream;

  /// Clears chat notification for a specific conversation from the device tray.
  Future<void> clearChatNotificationForConversation(
    String conversationId,
  ) async {
    final normalizedConversationId = conversationId.trim();
    if (normalizedConversationId.isEmpty) return;

    final notificationId = _chatNotificationIdForConversation(
      normalizedConversationId,
    );

    try {
      await _localNotifications.cancel(id: notificationId);
      _logger.debug(
        '[FCM] Cleared chat notification for conversation $normalizedConversationId (id: $notificationId)',
      );
    } catch (e, stackTrace) {
      _logger.warning(
        '[FCM] Failed to clear chat notification for conversation $normalizedConversationId: $e',
      );
      _logger.debug('[FCM] Clear notification stacktrace: $stackTrace');
    }
  }

  /// Mark FCM token as inactive (call on logout)
  Future<void> deleteToken() async {
    try {
      final fcmToken = await _messaging.getToken();
      if (fcmToken != null) {
        final currentUser = _supabase.auth.currentUser;
        if (currentUser != null) {
          _logger.debug('[FCM] Marking token as inactive...');

          await _supabase
              .from('user_devices')
              .update({
                'is_active': false,
                'updated_at': DateTime.now().toUtc().toIso8601String(),
              })
              .eq('fcm_token', fcmToken);

          _logger.info('[FCM] Token marked as inactive');
        } else {
          _logger.debug(
            '[FCM] Skipping DB token deactivation: no authenticated user',
          );
        }
      }

      // Delete token from Firebase
      await _messaging.deleteToken();
      _initializedUserId = null;
    } catch (e, stackTrace) {
      _logger.error('[FCM] Failed to delete token', e, stackTrace);
    }
  }

  /// Clean up subscriptions
  Future<void> dispose() async {
    await _foregroundSubscription?.cancel();
    await _tokenRefreshSubscription?.cancel();
    await _notificationOpenController.close();
    _initializationFuture = null;
    _initializedUserId = null;
    _isInitialized = false;
    _logger.debug('[FCM] Disposed');
  }

  /// Get current FCM token (for debugging)
  Future<String?> getToken() => _messaging.getToken();

  /// Check if FCM is initialized
  bool get isInitialized => _isInitialized;
}
