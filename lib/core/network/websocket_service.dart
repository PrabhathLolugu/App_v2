import 'dart:async';

enum WebSocketEventType {
  message,
  typing,
  readReceipt,
  userOnline,
  userOffline,
}

class WebSocketEvent {
  final WebSocketEventType type;
  final Map<String, dynamic> data;

  WebSocketEvent({required this.type, required this.data});
}

/// Abstract WebSocket service for real-time communication
abstract class WebSocketService {
  Future<void> connect();

  Future<void> disconnect();

  Future<void> sendMessage(Map<String, dynamic> message);

  Stream<WebSocketEvent> get eventStream;

  bool get isConnected;

  Future<void> sendTypingIndicator({
    required String conversationId,
    required bool isTyping,
  });

  Future<void> sendReadReceipt({
    required String conversationId,
    required List<String> messageIds,
  });
}
