import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/utils/app_error_mapper.dart';
import 'package:myitihas/features/notifications/presentation/cubit/notification_count_cubit.dart';
import 'package:myitihas/features/notifications/presentation/cubit/notification_page_state.dart';
import 'package:myitihas/features/notifications/presentation/models/notification_item.dart';
import 'package:myitihas/services/notification_service.dart';
import 'package:talker_flutter/talker_flutter.dart';

@injectable
class NotificationPageCubit extends Cubit<NotificationPageState> {
  final NotificationService _notificationService;
  final NotificationCountCubit _countCubit;
  final Talker _logger;

  static const int _pageSize = 20;
  int _currentOffset = 0;
  StreamSubscription<Map<String, dynamic>>? _realtimeSubscription;

  NotificationPageCubit(
    this._notificationService,
    this._countCubit,
    this._logger,
  ) : super(const NotificationPageState.initial());

  Future<void> loadNotifications() async {
    emit(const NotificationPageState.loading());
    _currentOffset = 0;

    try {
      final rawList = await _notificationService.getNotifications(
        limit: _pageSize,
        offset: 0,
      );
      final notifications = rawList
          .map((m) => NotificationItem.fromMap(m))
          .toList();

      _currentOffset = notifications.length;
      emit(
        NotificationPageState.loaded(
          notifications: notifications,
          hasMore: notifications.length >= _pageSize,
        ),
      );

      _subscribeToRealtime();
    } catch (e) {
      _logger.error('[NotificationPageCubit] Failed to load notifications', e);
      final message = AppErrorMapper.getUserMessage(
        e,
        fallbackMessage:
            'We couldn\'t load your notifications. Please try again in a moment.',
      );
      emit(NotificationPageState.error(message));
    }
  }

  Future<void> loadMore() async {
    final s = state;
    if (s is! NotificationPageLoaded || !s.hasMore || s.isLoadingMore) return;

    emit(s.copyWith(isLoadingMore: true));

    try {
      final rawList = await _notificationService.getNotifications(
        limit: _pageSize,
        offset: _currentOffset,
      );
      final newItems = rawList.map((m) => NotificationItem.fromMap(m)).toList();

      _currentOffset += newItems.length;
      emit(
        s.copyWith(
          notifications: [...s.notifications, ...newItems],
          hasMore: newItems.length >= _pageSize,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      _logger.error('[NotificationPageCubit] Failed to load more', e);
      final current = state;
      if (current is NotificationPageLoaded) {
        emit(current.copyWith(isLoadingMore: false));
      }
    }
  }

  Future<void> markAsRead(String notificationId) async {
    final s = state;
    if (s is! NotificationPageLoaded) return;

    final updated = s.notifications.map((n) {
      if (n.id == notificationId && !n.isRead) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();

    final wasUnread = s.notifications.any(
      (n) => n.id == notificationId && !n.isRead,
    );

    emit(s.copyWith(notifications: updated));

    if (wasUnread) {
      _countCubit.decrementCount();
    }

    try {
      await _notificationService.markAsRead(notificationId);
    } catch (e) {
      _logger.error('[NotificationPageCubit] Failed to mark as read', e);
    }
  }

  Future<void> markAllAsRead() async {
    final s = state;
    if (s is! NotificationPageLoaded) return;

    final updated = s.notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
    emit(s.copyWith(notifications: updated));
    _countCubit.resetCount();

    try {
      await _notificationService.markAllAsRead();
    } catch (e) {
      _logger.error('[NotificationPageCubit] Failed to mark all as read', e);
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    final s = state;
    if (s is! NotificationPageLoaded) return;

    final removedIndex = s.notifications.indexWhere(
      (n) => n.id == notificationId,
    );
    if (removedIndex == -1) {
      _logger.warning(
        '[NotificationPageCubit] Notification not found during delete: $notificationId',
      );
      return;
    }
    final removed = s.notifications[removedIndex];
    final updated = s.notifications
        .where((n) => n.id != notificationId)
        .toList();

    emit(s.copyWith(notifications: updated));

    if (!removed.isRead) {
      _countCubit.decrementCount();
    }

    try {
      await _notificationService.deleteNotification(notificationId);
    } catch (e) {
      _logger.error('[NotificationPageCubit] Failed to delete notification', e);
    }
  }

  void _subscribeToRealtime() {
    _realtimeSubscription?.cancel();
    _realtimeSubscription = _notificationService.subscribeToNotifications().listen(
      (newRecord) {
        final s = state;
        if (s is! NotificationPageLoaded) return;

        try {
          final item = NotificationItem.fromMap(newRecord);
          if (item.parsedType == NotificationType.message ||
              item.parsedType == NotificationType.groupMessage ||
              item.parsedType == NotificationType.storySuggestion) {
            _logger.debug(
              '[NotificationPageCubit] Ignored hidden notification in realtime stream',
            );
            return;
          }
          emit(s.copyWith(notifications: [item, ...s.notifications]));
        } catch (e) {
          _logger.error(
            '[NotificationPageCubit] Failed to parse realtime notification',
            e,
          );
        }
      },
      onError: (e) {
        _logger.error('[NotificationPageCubit] Realtime subscription error', e);
      },
    );
  }

  @override
  Future<void> close() {
    _realtimeSubscription?.cancel();
    return super.close();
  }
}
