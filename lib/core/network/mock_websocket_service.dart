import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/network/websocket_service.dart';

/// Mock implementation of WebSocket service for development
@LazySingleton(as: WebSocketService)
class MockWebSocketService implements WebSocketService {
  final StreamController<WebSocketEvent> _eventController =
      StreamController<WebSocketEvent>.broadcast();

  bool _isConnected = false;
  Timer? _mockEventTimer;

  @override
  Future<void> connect() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _isConnected = true;

    _startMockEvents();
  }

  @override
  Future<void> disconnect() async {
    _isConnected = false;
    _mockEventTimer?.cancel();
    await _eventController.close();
  }

  @override
  Future<void> sendMessage(Map<String, dynamic> message) async {
    if (!_isConnected) {
      throw Exception('WebSocket not connected');
    }

    await Future.delayed(const Duration(milliseconds: 200));

    _eventController.add(
      WebSocketEvent(
        type: WebSocketEventType.message,
        data: {'status': 'delivered', 'messageId': message['id']},
      ),
    );
  }

  @override
  Stream<WebSocketEvent> get eventStream => _eventController.stream;

  @override
  bool get isConnected => _isConnected;

  @override
  Future<void> sendTypingIndicator({
    required String conversationId,
    required bool isTyping,
  }) async {
    if (!_isConnected) return;

    await Future.delayed(const Duration(milliseconds: 100));

    _eventController.add(
      WebSocketEvent(
        type: WebSocketEventType.typing,
        data: {'conversationId': conversationId, 'isTyping': isTyping},
      ),
    );
  }

  @override
  Future<void> sendReadReceipt({
    required String conversationId,
    required List<String> messageIds,
  }) async {
    if (!_isConnected) return;

    await Future.delayed(const Duration(milliseconds: 100));

    _eventController.add(
      WebSocketEvent(
        type: WebSocketEventType.readReceipt,
        data: {'conversationId': conversationId, 'messageIds': messageIds},
      ),
    );
  }

  void _startMockEvents() {
    _mockEventTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!_isConnected) {
        timer.cancel();
        return;
      }

      _eventController.add(
        WebSocketEvent(
          type: WebSocketEventType.typing,
          data: {
            'conversationId': 'conv_mock',
            'userId': 'user_002',
            'isTyping': true,
          },
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (_isConnected) {
          _eventController.add(
            WebSocketEvent(
              type: WebSocketEventType.typing,
              data: {
                'conversationId': 'conv_mock',
                'userId': 'user_002',
                'isTyping': false,
              },
            ),
          );
        }
      });
    });
  }
}
