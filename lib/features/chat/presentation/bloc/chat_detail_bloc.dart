import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/network/websocket_service.dart';
import 'package:myitihas/features/chat/domain/repositories/chat_repository.dart';
import 'package:myitihas/repository/my_itihas_repository.dart';
import 'package:myitihas/features/chat/data/models/message.model.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'chat_detail_event.dart';
import 'chat_detail_state.dart';

/// BLoC for managing individual chat conversation
@injectable
class ChatDetailBloc extends Bloc<ChatDetailEvent, ChatDetailState> {
  final ChatRepository chatRepository;
  final WebSocketService webSocketService;
  final MyItihasRepository brickRepository;
  final InternetConnection internetConnection;

  StreamSubscription? _webSocketSubscription;
  StreamSubscription<List<MessageModel>>? _messageSubscription;

  ChatDetailBloc({
    required this.chatRepository,
    required this.webSocketService,
    required this.brickRepository,
    required this.internetConnection,
  }) : super(const ChatDetailState.initial()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<SendStoryMessageEvent>(_onSendStoryMessage);
    on<MarkAsReadEvent>(_onMarkAsRead);
    on<TypingStartedEvent>(_onTypingStarted);
    on<TypingStoppedEvent>(_onTypingStopped);
    on<RealtimeMessageReceivedEvent>(_onRealtimeMessageReceived);
    on<ForwardMessageEvent>(_onForwardMessage);

    _initializeWebSocket();
  }

  void _initializeWebSocket() {
    _webSocketSubscription = webSocketService.eventStream.listen((event) {
      if (event.type == WebSocketEventType.typing) {
        final conversationId = event.data['conversationId'] as String?;

        final currentState = state;
        if (currentState is ChatDetailLoaded &&
            currentState.conversationId == conversationId) {
          add(ChatDetailEvent.loadMessages(currentState.conversationId));
        }
      }
    });
  }

  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<ChatDetailState> emit,
  ) async {
    emit(const ChatDetailState.loading());

    final result = await chatRepository.getMessages(
      conversationId: event.conversationId,
      limit: 50,
    );

    result.fold((failure) => emit(ChatDetailState.error(failure.message)), (
      messages,
    ) {
      emit(
        ChatDetailState.loaded(
          conversationId: event.conversationId,
          messages: messages,
        ),
      );
      // Start realtime subscription after successful load
      _startRealtimeSubscription(event.conversationId);
    });
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatDetailState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ChatDetailLoaded) return;

    // Check connectivity before attempting send
    final isOnline = await internetConnection.hasInternetAccess;
    if (!isOnline) {
      emit(
        currentState.copyWith(
          error: 'No internet connection. Try again later.',
          isOfflineError: true,
        ),
      );
      return;
    }

    emit(currentState.copyWith(isSending: true));

    final result = await chatRepository.sendMessage(
      conversationId: event.conversationId,
      text: event.text,
    );

    await result.fold(
      (failure) async {
        emit(currentState.copyWith(isSending: false));
      },
      (message) async {
        final messagesResult = await chatRepository.getMessages(
          conversationId: event.conversationId,
          limit: 50,
        );

        messagesResult.fold(
          (failure) {
            emit(currentState.copyWith(isSending: false));
          },
          (messages) {
            emit(currentState.copyWith(messages: messages, isSending: false));
          },
        );
      },
    );
  }

  Future<void> _onSendStoryMessage(
    SendStoryMessageEvent event,
    Emitter<ChatDetailState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ChatDetailLoaded) return;

    // Check connectivity before attempting send
    final isOnline = await internetConnection.hasInternetAccess;
    if (!isOnline) {
      emit(
        currentState.copyWith(
          error: 'No internet connection. Try again later.',
          isOfflineError: true,
        ),
      );
      return;
    }

    emit(currentState.copyWith(isSending: true));

    final result = await chatRepository.sendStoryMessage(
      conversationId: event.conversationId,
      storyId: event.storyId,
    );

    await result.fold(
      (failure) async {
        emit(currentState.copyWith(isSending: false));
      },
      (message) async {
        final messagesResult = await chatRepository.getMessages(
          conversationId: event.conversationId,
          limit: 50,
        );

        messagesResult.fold(
          (failure) {
            emit(currentState.copyWith(isSending: false));
          },
          (messages) {
            emit(currentState.copyWith(messages: messages, isSending: false));
          },
        );
      },
    );
  }

  Future<void> _onMarkAsRead(
    MarkAsReadEvent event,
    Emitter<ChatDetailState> emit,
  ) async {
    await chatRepository.markMessagesAsRead(
      conversationId: event.conversationId,
      messageIds: event.messageIds,
    );

    await webSocketService.sendReadReceipt(
      conversationId: event.conversationId,
      messageIds: event.messageIds,
    );
  }

  Future<void> _onTypingStarted(
    TypingStartedEvent event,
    Emitter<ChatDetailState> emit,
  ) async {
    await webSocketService.sendTypingIndicator(
      conversationId: event.conversationId,
      isTyping: true,
    );
  }

  Future<void> _onTypingStopped(
    TypingStoppedEvent event,
    Emitter<ChatDetailState> emit,
  ) async {
    await webSocketService.sendTypingIndicator(
      conversationId: event.conversationId,
      isTyping: false,
    );
  }

  void _startRealtimeSubscription(String conversationId) {
    // Cancel existing subscription if any
    _messageSubscription?.cancel();

    // Subscribe to new messages and filter for this conversation
    _messageSubscription = brickRepository.subscribe<MessageModel>().listen((
      messages,
    ) {
      // Filter messages for current conversation
      final relevantMessages = messages
          .where((m) => m.conversationId == conversationId)
          .toList();
      if (relevantMessages.isNotEmpty) {
        add(
          ChatDetailEvent.realtimeMessageReceived(
            relevantMessages.first.toDomain(),
          ),
        );
      }
    });
  }

  Future<void> _onRealtimeMessageReceived(
    RealtimeMessageReceivedEvent event,
    Emitter<ChatDetailState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ChatDetailLoaded) return;

    // Insert new message at top of list
    final updatedMessages = [event.message, ...currentState.messages];
    emit(currentState.copyWith(messages: updatedMessages));
  }

  Future<void> _onForwardMessage(
    ForwardMessageEvent event,
    Emitter<ChatDetailState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ChatDetailLoaded) return;

    // Check connectivity before attempting forward
    final isOnline = await internetConnection.hasInternetAccess;
    if (!isOnline) {
      emit(
        currentState.copyWith(
          error: 'No internet connection. Try again later.',
          isOfflineError: true,
        ),
      );
      return;
    }

    emit(currentState.copyWith(isSending: true));

    final result = await chatRepository.forwardMessage(
      messageId: event.messageId,
      targetConversationId: event.targetConversationId,
    );

    result.fold(
      (failure) {
        emit(currentState.copyWith(isSending: false, error: failure.message));
      },
      (_) {
        emit(currentState.copyWith(isSending: false));
      },
    );
  }

  @override
  Future<void> close() {
    _webSocketSubscription?.cancel();
    _messageSubscription?.cancel();
    return super.close();
  }
}
