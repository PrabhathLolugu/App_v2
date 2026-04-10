import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/services/notification_service.dart';
import 'package:talker_flutter/talker_flutter.dart';

@lazySingleton
class NotificationCountCubit extends Cubit<int> {
  final NotificationService _notificationService;
  final Talker _logger;
  StreamSubscription<Map<String, dynamic>>? _realtimeSubscription;

  NotificationCountCubit(this._notificationService, this._logger) : super(0);

  bool _isHiddenChatNotificationType(String? type) {
    final normalized = (type ?? '').trim().toLowerCase();
    return normalized == 'message' ||
        normalized == 'group_message' ||
        normalized == 'groupmessage' ||
        normalized == 'group-message' ||
        normalized == 'group message' ||
        normalized == 'story_suggestion';
  }

  Future<void> initialize() async {
    try {
      final count = await _notificationService.getUnreadCount();
      emit(count);
      _logger.debug('[NotificationCountCubit] Initial unread count: $count');
    } catch (e) {
      _logger.error('[NotificationCountCubit] Failed to get unread count', e);
    }

    _realtimeSubscription?.cancel();
    _realtimeSubscription = _notificationService.subscribeToNotifications().listen(
      (notification) {
        final notificationType = notification['notification_type'] as String?;
        if (_isHiddenChatNotificationType(notificationType)) {
          _logger.debug(
            '[NotificationCountCubit] Ignored hidden chat notification in realtime count stream',
          );
          return;
        }
        emit(state + 1);
        _logger.debug(
          '[NotificationCountCubit] New notification, count: $state',
        );
      },
      onError: (e) {
        _logger.error(
          '[NotificationCountCubit] Realtime subscription error',
          e,
        );
      },
    );
  }

  void decrementCount() {
    if (state > 0) emit(state - 1);
  }

  void resetCount() => emit(0);

  Future<void> refresh() async {
    try {
      final count = await _notificationService.getUnreadCount();
      emit(count);
    } catch (e) {
      _logger.error('[NotificationCountCubit] Failed to refresh count', e);
    }
  }

  @override
  Future<void> close() {
    _realtimeSubscription?.cancel();
    return super.close();
  }
}
