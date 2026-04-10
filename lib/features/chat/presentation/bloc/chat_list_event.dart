import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_list_event.freezed.dart';

@freezed
sealed class ChatListEvent with _$ChatListEvent {
  const factory ChatListEvent.loadConversations() = LoadConversationsEvent;
  const factory ChatListEvent.refreshConversations() =
      RefreshConversationsEvent;
}
