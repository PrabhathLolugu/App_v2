import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:myitihas/core/errors/failures.dart';
import 'package:myitihas/core/logging/talker_setup.dart';
import 'package:myitihas/repository/my_itihas_repository.dart';
import 'package:myitihas/features/chat/data/models/conversation.model.dart';
import 'package:myitihas/features/chat/data/models/message.model.dart';
import 'package:myitihas/features/social/data/models/user.model.dart';
import 'package:myitihas/features/chat/domain/entities/conversation.dart';
import 'package:myitihas/features/chat/domain/entities/message.dart';
import 'package:myitihas/features/chat/domain/repositories/chat_repository.dart';

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final MyItihasRepository repository;
  final SupabaseClient supabase;
  final InternetConnection internetConnection;

  ChatRepositoryImpl(this.repository, this.supabase, this.internetConnection);

  @override
  Future<Either<Failure, List<Conversation>>> getConversations() async {
    try {
      final models = await repository.get<ConversationModel>(
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
      );

      // Sort by updated_at descending (most recent first)
      final sorted = models.toList();
      sorted.sort((a, b) {
        return b.updatedAt.compareTo(a.updatedAt);
      });

      // Enrich each conversation with participants
      final enrichedModels = <ConversationModel>[];
      for (final model in sorted) {
        final enriched = await _enrichWithParticipants(model);
        enrichedModels.add(enriched);
      }

      return Right(enrichedModels.map((m) => m.toDomain()).toList());
    } on OfflineFirstException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  /// Manually load participants from conversation_members junction table
  /// since Brick doesn't support many-to-many relationships
  Future<ConversationModel> _enrichWithParticipants(
    ConversationModel conversation,
  ) async {
    try {
      // Query conversation_members junction table
      final response = await supabase
          .from('conversation_members')
          .select('user_id, profiles(*)')
          .eq('conversation_id', conversation.id);

      final participantIds = <String>[];
      final participants = <UserModel>[];

      for (final member in response as List<dynamic>) {
        final userId = member['user_id'] as String;
        participantIds.add(userId);

        // Try to get user from local cache first
        final cachedUsers = await repository.get<UserModel>(
          policy: OfflineFirstGetPolicy.localOnly,
          query: Query.where('id', userId),
        );

        UserModel user;
        if (cachedUsers.isNotEmpty) {
          user = cachedUsers.first;
        } else {
          // Create UserModel from profiles data
          final profileData = member['profiles'] as Map<String, dynamic>?;
          if (profileData != null) {
            user = UserModel(
              id: userId,
              username: profileData['username'] as String? ?? 'user_$userId',
              displayName: profileData['full_name'] as String? ?? 'Unknown',
              avatarUrl: profileData['avatar_url'] as String?,
              bio: profileData['bio'] as String?,
            );

            // Cache the user for future lookups
            await repository.upsert<UserModel>(user);
          } else {
            // Fallback if profiles data is missing
            user = UserModel(
              id: userId,
              username: 'user_$userId',
              displayName: 'Unknown',
            );
            await repository.upsert<UserModel>(user);
          }
        }
        participants.add(user);
      }

      // Return new ConversationModel with enriched participants
      return ConversationModel(
        id: conversation.id,
        isGroup: conversation.isGroup,
        groupName: conversation.groupName,
        groupAvatarUrl: conversation.groupAvatarUrl,
        groupDescription: conversation.groupDescription,
        lastMessage: conversation.lastMessage,
        lastMessageAt: conversation.lastMessageAt,
        lastMessageSenderId: conversation.lastMessageSenderId,
        createdAt: conversation.createdAt,
        updatedAt: conversation.updatedAt,
        participantIds: participantIds,
        participants: participants,
        unreadCount: conversation.unreadCount,
      );
    } catch (e) {
      talker.warning('[ChatRepository] Failed to load participants: $e');
      // Return original conversation if participant loading fails
      return conversation;
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessages({
    required String conversationId,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final models = await repository.get<MessageModel>(
        policy: OfflineFirstGetPolicy.alwaysHydrate,
        query: Query.where('conversationId', conversationId),
      );

      // Sort by created_at descending (most recent first)
      final sorted = models.toList();
      sorted.sort((a, b) {
        return b.createdAt.compareTo(a.createdAt);
      });

      // Apply pagination
      final startIndex = offset.clamp(0, sorted.length);
      final endIndex = (offset + limit).clamp(0, sorted.length);
      final paginated = sorted.sublist(startIndex, endIndex);

      return Right(paginated.map((m) => m.toDomain()).toList());
    } on OfflineFirstException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessage({
    required String conversationId,
    required String text,
  }) async {
    try {
      // Check connectivity before attempting
      final isOnline = await internetConnection.hasInternetAccess;
      if (!isOnline) {
        return const Left(NetworkFailure('No internet connection'));
      }

      // Get current user ID
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        return const Left(AuthFailure('User not authenticated'));
      }

      // Insert message via Supabase
      final response = await supabase
          .from('chat_messages')
          .insert({
            'conversation_id': conversationId,
            'sender_id': currentUserId,
            'content': text,
            'type': 'text',
          })
          .select()
          .single();

      // Create MessageModel from response
      final message = MessageModel(
        id: response['id'] as String,
        conversationId: conversationId,
        senderId: currentUserId,
        content: text,
        type: 'text',
        createdAt: DateTime.parse(response['created_at'] as String),
      );

      // Cache the message
      await repository.upsert<MessageModel>(message);

      return Right(message.toDomain());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Message>> sendStoryMessage({
    required String conversationId,
    required String storyId,
  }) async {
    try {
      // Check connectivity before attempting
      final isOnline = await internetConnection.hasInternetAccess;
      if (!isOnline) {
        return const Left(NetworkFailure('No internet connection'));
      }

      // Get current user ID
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        return const Left(AuthFailure('User not authenticated'));
      }

      // Insert message via Supabase
      final response = await supabase
          .from('chat_messages')
          .insert({
            'conversation_id': conversationId,
            'sender_id': currentUserId,
            'content': 'Shared a story',
            'type': 'story_share',
            'shared_content_id': storyId,
          })
          .select()
          .single();

      // Create MessageModel from response with sharedStoryId
      final message = MessageModel(
        id: response['id'] as String,
        conversationId: conversationId,
        senderId: currentUserId,
        content: 'Shared a story',
        type: 'story_share',
        createdAt: DateTime.parse(response['created_at'] as String),
        sharedContentId: storyId,
      );

      // Cache the message
      await repository.upsert<MessageModel>(message);

      return Right(message.toDomain());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markMessagesAsRead({
    required String conversationId,
    required List<String> messageIds,
  }) async {
    try {
      // Get current user ID
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        return const Left(AuthFailure('User not authenticated'));
      }

      // Query local MessageModels for all message IDs
      for (final messageId in messageIds) {
        final messages = await repository.get<MessageModel>(
          policy: OfflineFirstGetPolicy.localOnly,
          query: Query.where('id', messageId),
        );

        if (messages.isNotEmpty) {
          final message = messages.first;

          // Update delivery status and readBy list
          final updatedReadBy = List<String>.from(message.readBy);
          if (!updatedReadBy.contains(currentUserId)) {
            updatedReadBy.add(currentUserId);
          }

          final updatedMessage = MessageModel(
            id: message.id,
            conversationId: message.conversationId,
            senderId: message.senderId,
            sender: message.sender,
            content: message.content,
            type: message.type,
            createdAt: message.createdAt,
            deliveryStatus: 'read',
            readBy: updatedReadBy,
            sharedContentId: message.sharedContentId,
            metadata: message.metadata,
          );

          // Upsert updated message to cache
          await repository.upsert<MessageModel>(updatedMessage);
        }
      }

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Conversation>> getOrCreateConversation({
    required String otherUserId,
  }) async {
    try {
      // Get current user ID
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        return const Left(AuthFailure('User not authenticated'));
      }

      // Query Supabase for existing conversation between the two users
      // This requires a custom RPC function or complex query
      // For now, we'll use a simplified approach: query conversation_members
      final response = await supabase.rpc(
        'get_or_create_conversation',
        params: {'user_id_1': currentUserId, 'user_id_2': otherUserId},
      );

      final conversationId = response as String;

      // Fetch the conversation from cache/remote
      final conversations = await repository.get<ConversationModel>(
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
        query: Query.where('id', conversationId),
      );

      if (conversations.isEmpty) {
        return const Left(NotFoundFailure('Conversation not found'));
      }

      // Enrich with participants
      final enriched = await _enrichWithParticipants(conversations.first);

      return Right(enriched.toDomain());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> pruneOldMessages(String conversationId) async {
    // TODO: Implement in Phase 6 - delete messages older than 30 days
    // This will query messages by conversationId and createdAt < (now - 30 days)
    // and delete them from both local cache and remote database
    return const Right(null);
  }

  @override
  Future<Either<Failure, Message>> forwardMessage({
    required String messageId,
    required String targetConversationId,
  }) async {
    try {
      // Check connectivity before attempting
      final isOnline = await internetConnection.hasInternetAccess;
      if (!isOnline) {
        return const Left(NetworkFailure('No internet connection'));
      }

      // Get current user ID
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        return const Left(AuthFailure('User not authenticated'));
      }

      // Get the original message
      final messages = await repository.get<MessageModel>(
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
        query: Query.where('id', messageId),
      );

      if (messages.isEmpty) {
        return const Left(NotFoundFailure('Message not found'));
      }

      final originalMessage = messages.first;

      final insertRow = <String, dynamic>{
        'conversation_id': targetConversationId,
        'sender_id': currentUserId,
        'content': originalMessage.content,
        'type': originalMessage.type,
      };
      final meta = originalMessage.metadata;
      if (meta != null && meta.isNotEmpty) {
        insertRow['metadata'] = meta;
      }

      final response = await supabase
          .from('chat_messages')
          .insert(insertRow)
          .select()
          .single();

      final newMessageId = response['id'] as String;

      if (originalMessage.type?.toLowerCase() == 'image') {
        final attRows = await supabase
            .from('message_attachments')
            .select('bucket, object_path, mime_type, size_bytes')
            .eq('message_id', messageId);
        for (final raw in attRows as List) {
          final a = Map<String, dynamic>.from(raw as Map);
          final path = a['object_path'] as String?;
          if (path == null || path.isEmpty) continue;
          await supabase.from('message_attachments').insert({
            'message_id': newMessageId,
            'conversation_id': targetConversationId,
            'uploader_id': currentUserId,
            'bucket': (a['bucket'] as String?)?.trim().isNotEmpty == true
                ? a['bucket'] as String
                : 'chat-media',
            'object_path': path,
            if (a['mime_type'] != null) 'mime_type': a['mime_type'],
            if (a['size_bytes'] != null) 'size_bytes': a['size_bytes'],
          });
        }
      }

      final forwardedMessage = MessageModel(
        id: newMessageId,
        conversationId: targetConversationId,
        senderId: currentUserId,
        content: originalMessage.content,
        type: originalMessage.type,
        createdAt: DateTime.parse(response['created_at'] as String),
        metadata: originalMessage.metadata,
      );

      // Cache the message
      await repository.upsert<MessageModel>(forwardedMessage);

      return Right(forwardedMessage.toDomain());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
