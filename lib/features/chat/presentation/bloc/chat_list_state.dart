import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myitihas/features/chat/domain/entities/conversation.dart';

part 'chat_list_state.freezed.dart';

@Freezed(toStringOverride: true)
sealed class ChatListState with _$ChatListState {
  const factory ChatListState.initial() = ChatListInitial;
  const factory ChatListState.loading() = ChatListLoading;
  const factory ChatListState.loaded(List<Conversation> conversations) =
      ChatListLoaded;
  const factory ChatListState.error(String message) = ChatListError;

  const ChatListState._();

  @override
  String toString() {
    return map(
      initial: (_) => 'ChatListState.initial()',
      loading: (_) => 'ChatListState.loading()',
      loaded: (state) =>
          'ChatListState.loaded(conversations: ${state.conversations.length})',
      error: (state) => 'ChatListState.error(message: "${state.message}")',
    );
  }
}
