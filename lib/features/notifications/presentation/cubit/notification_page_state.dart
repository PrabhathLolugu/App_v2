import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myitihas/features/notifications/presentation/models/notification_item.dart';

part 'notification_page_state.freezed.dart';

@freezed
sealed class NotificationPageState with _$NotificationPageState {
  const factory NotificationPageState.initial() = NotificationPageInitial;
  const factory NotificationPageState.loading() = NotificationPageLoading;
  const factory NotificationPageState.loaded({
    required List<NotificationItem> notifications,
    required bool hasMore,
    @Default(false) bool isLoadingMore,
  }) = NotificationPageLoaded;
  const factory NotificationPageState.error(String message) =
      NotificationPageError;
}
