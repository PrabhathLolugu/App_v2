import 'package:fpdart/fpdart.dart';
import 'package:myitihas/core/errors/failures.dart';
import '../entities/conversation.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  Future<Either<Failure, Message>> sendMessage({
    required String conversationId,
    required String text,
  });

  Future<Either<Failure, Message>> sendStoryMessage({
    required String conversationId,
    required String storyId,
  });

  Future<Either<Failure, List<Conversation>>> getConversations();

  Future<Either<Failure, List<Message>>> getMessages({
    required String conversationId,
    int limit = 50,
    int offset = 0,
  });

  Future<Either<Failure, void>> markMessagesAsRead({
    required String conversationId,
    required List<String> messageIds,
  });

  Future<Either<Failure, Conversation>> getOrCreateConversation({
    required String otherUserId,
  });

  Future<Either<Failure, void>> pruneOldMessages(String conversationId);

  Future<Either<Failure, Message>> forwardMessage({
    required String messageId,
    required String targetConversationId,
  });
}
