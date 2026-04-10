import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/errors/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import 'package:talker_flutter/talker_flutter.dart';

enum NotificationType {
  like,
  comment,
  reply,
  follow,
  mention,
  share,
  repost,
  newPost,
  storySuggestion,
  message,
  groupMessage,
}

@lazySingleton
class NotificationService {
  final SupabaseClient _supabase;
  static const String _messageType = 'message';
  static const String _groupMessageType = 'group_message';
  static const String _storySuggestionType = 'story_suggestion';

  NotificationService(this._supabase);

  String _normalizeNotificationType(String? type) {
    if (type == null) return '';

    final normalized = type.trim().toLowerCase();
    if (normalized == 'groupmessage' ||
        normalized == 'group-message' ||
        normalized == 'group message') {
      return _groupMessageType;
    }
    return normalized;
  }

  bool _isHiddenNotificationType(String? type) {
    final normalized = _normalizeNotificationType(type);
    return normalized == _messageType ||
        normalized == _groupMessageType ||
        normalized == _storySuggestionType;
  }

  /// Gets notifications for the current user.
  ///
  /// [limit] - Maximum notifications to fetch
  /// [offset] - Number to skip for pagination
  /// [unreadOnly] - If true, only returns unread notifications
  ///
  /// Returns notifications with actor profile info.
  Future<List<Map<String, dynamic>>> getNotifications({
    int limit = 20,
    int offset = 0,
    bool unreadOnly = false,
  }) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        return [];
      }

      // Build base query with filters first, then transformations
      var query = _supabase
          .from('notifications')
          .select('''
            *,
            actor:profiles!notifications_actor_id_fkey(id, username, full_name, avatar_url)
          ''')
          .eq('recipient_id', currentUserId)
          .neq('notification_type', _messageType)
          .neq('notification_type', _groupMessageType)
          .neq('notification_type', _storySuggestionType);

      if (unreadOnly) {
        query = query.eq('is_read', false);
      }

      final response = await query
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      logger.debug(
        '[NotificationService] Fetched ${response.length} notifications',
      );
      return List<Map<String, dynamic>>.from(response);
    } catch (e, stackTrace) {
      logger.error(
        '[NotificationService] Error fetching notifications',
        e,
        stackTrace,
      );
      throw ServerException('Failed to fetch notifications: ${e.toString()}');
    }
  }

  /// Gets the count of unread notifications.
  Future<int> getUnreadCount() async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        return 0;
      }

      final response = await _supabase
          .from('notifications')
          .select()
          .eq('recipient_id', currentUserId)
          .eq('is_read', false)
          .neq('notification_type', _messageType)
          .neq('notification_type', _groupMessageType)
          .neq('notification_type', _storySuggestionType)
          .count(CountOption.exact);

      return response.count;
    } catch (e, stackTrace) {
      logger.error(
        '[NotificationService] Error getting unread count',
        e,
        stackTrace,
      );
      return 0;
    }
  }

  /// Marks a single notification as read.
  Future<void> markAsRead(String notificationId) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw AuthException('User must be authenticated');
      }

      await _supabase
          .from('notifications')
          .update({
            'is_read': true,
            'read_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', notificationId)
          .eq('recipient_id', currentUserId);

      logger.debug(
        '[NotificationService] Marked notification $notificationId as read',
      );
    } on AuthException {
      rethrow;
    } catch (e, stackTrace) {
      logger.error(
        '[NotificationService] Error marking notification as read',
        e,
        stackTrace,
      );
      throw ServerException('Failed to mark notification as read');
    }
  }

  /// Marks all notifications as read for the current user.
  Future<void> markAllAsRead() async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw AuthException('User must be authenticated');
      }

      await _supabase
          .from('notifications')
          .update({
            'is_read': true,
            'read_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('recipient_id', currentUserId)
          .eq('is_read', false)
          .neq('notification_type', _messageType)
          .neq('notification_type', _groupMessageType)
          .neq('notification_type', _storySuggestionType);

      logger.info('[NotificationService] Marked all notifications as read');
    } on AuthException {
      rethrow;
    } catch (e, stackTrace) {
      logger.error(
        '[NotificationService] Error marking all notifications as read',
        e,
        stackTrace,
      );
      throw ServerException('Failed to mark all notifications as read');
    }
  }

  /// Deletes a notification.
  Future<void> deleteNotification(String notificationId) async {
    final logger = getIt<Talker>();

    try {
      await _supabase.from('notifications').delete().eq('id', notificationId);
      logger.debug(
        '[NotificationService] Deleted notification $notificationId',
      );
    } catch (e, stackTrace) {
      logger.error(
        '[NotificationService] Error deleting notification',
        e,
        stackTrace,
      );
      throw ServerException('Failed to delete notification');
    }
  }

  /// Deletes all notifications for the current user.
  Future<void> clearAllNotifications() async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw AuthException('User must be authenticated');
      }

      await _supabase
          .from('notifications')
          .delete()
          .eq('recipient_id', currentUserId);

      logger.info('[NotificationService] Cleared all notifications');
    } on AuthException {
      rethrow;
    } catch (e, stackTrace) {
      logger.error(
        '[NotificationService] Error clearing notifications',
        e,
        stackTrace,
      );
      throw ServerException('Failed to clear notifications');
    }
  }

  /// Subscribes to real-time notification updates.
  ///
  /// Returns a stream that emits new notifications as they arrive.
  /// The stream filters to only show notifications for the current user.
  ///
  /// **Important**: Always cancel the subscription when done to prevent
  /// memory leaks (e.g., when the notification screen is disposed).
  ///
  /// Example usage:
  /// ```dart
  /// final subscription = notificationService.subscribeToNotifications().listen(
  ///   (notification) => print('New notification: ${notification['title']}'),
  /// );
  /// // Later, in dispose():
  /// subscription.cancel();
  /// ```
  Stream<Map<String, dynamic>> subscribeToNotifications() {
    final logger = getIt<Talker>();
    late StreamController<Map<String, dynamic>> controller;
    RealtimeChannel? channel;
    bool isSubscribed = false;

    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      logger.warning(
        '[NotificationService] Cannot subscribe: user not authenticated',
      );
      return const Stream.empty();
    }

    final channelName =
        'notifications:$currentUserId:${DateTime.now().millisecondsSinceEpoch}';

    logger.debug(
      '[NotificationService] Setting up real-time subscription: $channelName',
    );

    controller = StreamController<Map<String, dynamic>>(
      onListen: () {
        if (isSubscribed) return;

        logger.info(
          '[NotificationService] Subscribing to real-time notifications',
        );
        isSubscribed = true;

        try {
          channel = _supabase
              .channel(channelName)
              .onPostgresChanges(
                event: PostgresChangeEvent.insert,
                schema: 'public',
                table: 'notifications',
                filter: PostgresChangeFilter(
                  type: PostgresChangeFilterType.eq,
                  column: 'recipient_id',
                  value: currentUserId,
                ),
                callback: (payload) {
                  if (!controller.isClosed && payload.newRecord.isNotEmpty) {
                    final notificationType =
                        payload.newRecord['notification_type'] as String?;
                    if (_isHiddenNotificationType(notificationType)) {
                      logger.debug(
                        '[NotificationService] Ignoring hidden chat notification type: $notificationType',
                      );
                      return;
                    }
                    logger.debug(
                      '[NotificationService] New notification received',
                    );
                    controller.add(payload.newRecord);
                  }
                },
              )
              .subscribe();

          logger.info(
            '[NotificationService] Successfully subscribed to notifications',
          );
        } catch (e, stackTrace) {
          logger.error(
            '[NotificationService] Failed to subscribe to notifications',
            e,
            stackTrace,
          );
          isSubscribed = false;
          if (!controller.isClosed) {
            controller.addError(e);
          }
        }
      },
      onCancel: () async {
        if (!isSubscribed) return;

        logger.info('[NotificationService] Unsubscribing from notifications');

        try {
          if (channel != null) {
            await channel!.unsubscribe();
            await _supabase.removeChannel(channel!);
          }
          logger.info(
            '[NotificationService] Successfully unsubscribed from notifications',
          );
        } catch (e, stackTrace) {
          logger.error(
            '[NotificationService] Error during cleanup',
            e,
            stackTrace,
          );
        } finally {
          isSubscribed = false;
          channel = null;
        }
      },
    );

    return controller.stream;
  }

  /// Gets a grouped summary of recent notifications.
  ///
  /// Groups similar notifications (e.g., "5 people liked your post")
  /// to reduce notification noise.
  Future<List<Map<String, dynamic>>> getGroupedNotifications({
    int limit = 20,
    int offset = 0,
  }) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        return [];
      }

      // Get raw notifications
      final notifications = await getNotifications(
        limit: limit * 2,
        offset: offset,
      );

      // Group by entity and type
      final grouped = <String, Map<String, dynamic>>{};

      for (final notification in notifications) {
        final entityId = notification['entity_id'] as String?;
        final type = notification['notification_type'] as String?;

        if (entityId != null && type != null) {
          final key = '$type:$entityId';

          if (grouped.containsKey(key)) {
            // Add to existing group
            final group = grouped[key]!;
            final actors = group['actors'] as List<Map<String, dynamic>>;
            final actor = notification['actor'] as Map<String, dynamic>?;

            if (actor != null && actors.length < 5) {
              actors.add(actor);
            }
            group['count'] = (group['count'] as int) + 1;

            // Update read status - group is unread if any notification is unread
            if (notification['is_read'] == false) {
              group['is_read'] = false;
            }
          } else {
            // Create new group
            grouped[key] = {
              'id': notification['id'],
              'notification_type': type,
              'entity_type': notification['entity_type'],
              'entity_id': entityId,
              'title': notification['title'],
              'body': notification['body'],
              'actors': [
                if (notification['actor'] != null) notification['actor'],
              ],
              'count': 1,
              'is_read': notification['is_read'],
              'created_at': notification['created_at'],
            };
          }
        } else {
          // Non-groupable notification
          grouped[notification['id'] as String] = notification;
        }
      }

      // Convert to list and limit
      final result = grouped.values.take(limit).toList();

      logger.debug(
        '[NotificationService] Grouped ${notifications.length} notifications into ${result.length}',
      );
      return result;
    } catch (e, stackTrace) {
      logger.error(
        '[NotificationService] Error getting grouped notifications',
        e,
        stackTrace,
      );
      throw ServerException('Failed to fetch notifications: ${e.toString()}');
    }
  }

  /// Helper to convert notification type string to enum
  NotificationType? parseNotificationType(String? type) {
    if (type == null) return null;

    switch (type) {
      case 'like':
        return NotificationType.like;
      case 'comment':
        return NotificationType.comment;
      case 'reply':
        return NotificationType.reply;
      case 'follow':
        return NotificationType.follow;
      case 'mention':
        return NotificationType.mention;
      case 'share':
        return NotificationType.share;
      case 'repost':
        return NotificationType.repost;
      case 'new_post':
        return NotificationType.newPost;
      case 'story_suggestion':
        return NotificationType.storySuggestion;
      case 'message':
        return NotificationType.message;
      case 'group_message':
        return NotificationType.groupMessage;
      default:
        return null;
    }
  }
}
