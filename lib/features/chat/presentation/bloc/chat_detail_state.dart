import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myitihas/features/chat/domain/entities/message.dart';

part 'chat_detail_state.freezed.dart';

@Freezed(toStringOverride: true)
sealed class ChatDetailState with _$ChatDetailState {
  const factory ChatDetailState.initial() = ChatDetailInitial;

  const factory ChatDetailState.loading() = ChatDetailLoading;

  const factory ChatDetailState.loaded({
    required String conversationId,
    required List<Message> messages,
    @Default(false) bool isTyping,
    @Default(false) bool isSending,
    String? error,
    @Default(false) bool isOfflineError,
  }) = ChatDetailLoaded;

  const factory ChatDetailState.error(String message) = ChatDetailError;

  const ChatDetailState._();

  @override
  String toString() {
    return map(
      initial: (_) => 'ChatDetailState.initial()',
      loading: (_) => 'ChatDetailState.loading()',
      loaded: (state) =>
          'ChatDetailState.loaded(conversationId: ${state.conversationId}, messages: ${state.messages.length})',
      error: (state) => 'ChatDetailState.error(message: "${state.message}")',
    );
  }
}
