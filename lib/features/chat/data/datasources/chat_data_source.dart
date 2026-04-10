import 'dart:math';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/errors/exceptions.dart';
import 'package:myitihas/features/chat/domain/entities/message.dart';
import 'package:myitihas/features/social/data/datasources/user_remote_data_source.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

abstract class ChatDataSource {
  Future<List<ConversationModel>> getConversations(String currentUserId);
  Future<ConversationModel> getConversationById(String conversationId);
  Future<ConversationModel> getOrCreateConversation({
    required String currentUserId,
    required String otherUserId,
  });
  Future<List<MessageModel>> getMessages({
    required String conversationId,
    int limit = 50,
    int offset = 0,
  });
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
    String? sharedContentId,
    String? type,
  });
  Future<void> markAsRead({
    required String conversationId,
    required String userId,
    required List<String> messageIds,
  });
  Future<void> pruneOldMessages(String conversationId);
}

/// Mock implementation of chat data source
@LazySingleton(as: ChatDataSource)
class ChatDataSourceImpl implements ChatDataSource {
  final UserRemoteDataSource userDataSource;

  // In-memory storage
  final Map<String, ConversationModel> _conversations = {};
  final Map<String, List<MessageModel>> _messages = {};

  ChatDataSourceImpl(this.userDataSource);

  // Note: This is still a mock implementation. The UserRemoteDataSource
  // provides real user data from Supabase instead of hardcoded scriptural characters.

  @override
  Future<List<ConversationModel>> getConversations(String currentUserId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (_conversations.isEmpty) {
      await _createMockConversations(currentUserId);
    }

    final userConversations = _conversations.values
        .where((conv) => conv.participantIds.contains(currentUserId))
        .toList();

    userConversations.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return userConversations;
  }

  @override
  Future<ConversationModel> getConversationById(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final conversation = _conversations[conversationId];
    if (conversation == null) {
      throw const NotFoundException('Conversation not found');
    }

    return conversation;
  }

  @override
  Future<ConversationModel> getOrCreateConversation({
    required String currentUserId,
    required String otherUserId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final existing = _conversations.values.firstWhere(
      (conv) =>
          conv.participantIds.contains(currentUserId) &&
          conv.participantIds.contains(otherUserId) &&
          conv.participantIds.length == 2,
      orElse: () => ConversationModel(
        id: '',
        participantIds: [],
        participants: [],
        updatedAt: DateTime.now(),
      ),
    );

    if (existing.id.isNotEmpty) {
      return existing;
    }

    final currentUser = await userDataSource.getUserById(currentUserId);
    final otherUser = await userDataSource.getUserById(otherUserId);

    final newConversation = ConversationModel(
      id: 'conv_${DateTime.now().millisecondsSinceEpoch}',
      participantIds: [currentUserId, otherUser.id],
      participants: [currentUser, otherUser],
      updatedAt: DateTime.now(),
    );

    _conversations[newConversation.id] = newConversation;
    _messages[newConversation.id] = [];

    return newConversation;
  }

  @override
  Future<List<MessageModel>> getMessages({
    required String conversationId,
    int limit = 50,
    int offset = 0,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final messages = _messages[conversationId] ?? [];
    final paginated = messages.skip(offset).take(limit).toList();

    return paginated;
  }

  @override
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
    String? sharedContentId,
    String? type,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final sender = await userDataSource.getUserById(senderId);

    final message = MessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: senderId,
      senderName: sender.displayName,
      senderAvatar: sender.avatarUrl,
      text: text,
      timestamp: DateTime.now(),
      deliveryStatus: MessageDeliveryStatus.sent,
      sharedContentId: sharedContentId,
      type: type,
    );

    _messages.putIfAbsent(conversationId, () => []).insert(0, message);

    final conversation = _conversations[conversationId];
    if (conversation != null) {
      _conversations[conversationId] = conversation.copyWith(
        lastMessage: message,
        updatedAt: DateTime.now(),
        unreadCount: conversation.unreadCount + 1,
      );
    }

    await pruneOldMessages(conversationId);

    return message;
  }

  @override
  Future<void> markAsRead({
    required String conversationId,
    required String userId,
    required List<String> messageIds,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final messages = _messages[conversationId] ?? [];
    for (var i = 0; i < messages.length; i++) {
      if (messageIds.contains(messages[i].id)) {
        final updatedReadBy = List<String>.from(messages[i].readBy);
        if (!updatedReadBy.contains(userId)) {
          updatedReadBy.add(userId);
        }
        _messages[conversationId]![i] = messages[i].copyWith(
          readBy: updatedReadBy,
          deliveryStatus: MessageDeliveryStatus.read,
        );
      }
    }

    final conversation = _conversations[conversationId];
    if (conversation != null) {
      _conversations[conversationId] = conversation.copyWith(unreadCount: 0);
    }
  }

  @override
  Future<void> pruneOldMessages(String conversationId) async {
    final messages = _messages[conversationId] ?? [];
    if (messages.length > 200) {
      _messages[conversationId] = messages.take(200).toList();
    }
  }

  Future<void> _createMockConversations(String currentUserId) async {
    final allUsers = await userDataSource.getAllUsers();
    final otherUsers = allUsers.where((u) => u.id != currentUserId).toList();

    final random = Random();
    final numConversations = 3 + random.nextInt(3);

    for (var i = 0; i < numConversations && i < otherUsers.length; i++) {
      final otherUser = otherUsers[i];
      final currentUser = await userDataSource.getUserById(currentUserId);

      final conversationId = 'conv_${DateTime.now().millisecondsSinceEpoch}_$i';

      final mockMessages = _createMockMessages(
        conversationId: conversationId,
        currentUser: currentUser,
        otherUser: otherUser,
      );

      _messages[conversationId] = mockMessages;

      final conversation = ConversationModel(
        id: conversationId,
        participantIds: [currentUserId, otherUser.id],
        participants: [currentUser, otherUser],
        lastMessage: mockMessages.isNotEmpty ? mockMessages.first : null,
        unreadCount: random.nextInt(5),
        updatedAt: DateTime.now().subtract(Duration(minutes: i * 10)),
      );

      _conversations[conversationId] = conversation;
    }
  }

  List<MessageModel> _createMockMessages({
    required String conversationId,
    required currentUser,
    required otherUser,
  }) {
    final messages = <MessageModel>[];
    final random = Random();

    final mockTexts = [
      'Namaste! How are you?',
      'I loved your recent story about dharma.',
      'Would you like to discuss the teachings of Bhagavad Gita?',
      'Thank you for sharing such wisdom.',
      'Your insights are always enlightening.',
    ];

    final numMessages = 5 + random.nextInt(15);

    for (var i = 0; i < numMessages; i++) {
      final isFromCurrent = random.nextBool();
      final sender = isFromCurrent ? currentUser : otherUser;

      messages.insert(
        0,
        MessageModel(
          id: 'msg_mock_${conversationId}_$i',
          conversationId: conversationId,
          senderId: sender.id,
          senderName: sender.displayName,
          senderAvatar: sender.avatarUrl,
          text: mockTexts[random.nextInt(mockTexts.length)],
          timestamp: DateTime.now().subtract(Duration(hours: i + 1)),
          deliveryStatus: MessageDeliveryStatus.read,
          readBy: [currentUser.id, otherUser.id],
        ),
      );
    }

    return messages;
  }
}
