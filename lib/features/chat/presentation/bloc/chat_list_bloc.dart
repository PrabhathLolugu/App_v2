import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/features/chat/domain/repositories/chat_repository.dart';
import 'chat_list_event.dart';
import 'chat_list_state.dart';

@injectable
class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final ChatRepository chatRepository;

  ChatListBloc({required this.chatRepository})
    : super(const ChatListState.initial()) {
    on<LoadConversationsEvent>(_onLoadConversations);
    on<RefreshConversationsEvent>(_onRefreshConversations);
  }

  Future<void> _onLoadConversations(
    LoadConversationsEvent event,
    Emitter<ChatListState> emit,
  ) async {
    emit(const ChatListState.loading());

    final result = await chatRepository.getConversations();

    result.fold(
      (failure) => emit(ChatListState.error(failure.message)),
      (conversations) => emit(ChatListState.loaded(conversations)),
    );
  }

  Future<void> _onRefreshConversations(
    RefreshConversationsEvent event,
    Emitter<ChatListState> emit,
  ) async {
    final result = await chatRepository.getConversations();

    result.fold(
      (failure) {},
      (conversations) => emit(ChatListState.loaded(conversations)),
    );
  }
}
