import 'dart:async';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/errors/exceptions.dart';
import 'package:myitihas/core/utils/chat_url_parser.dart';
import 'package:myitihas/core/utils/group_system_message_formatter.dart';
import 'package:myitihas/models/chat_message.dart';
import 'package:myitihas/models/chat_poll_summary.dart';
import 'package:myitihas/models/conversation.dart';
import 'package:myitihas/models/message_reaction.dart';
import 'package:myitihas/services/follow_service.dart';
import 'package:myitihas/services/profile_service.dart';
import 'package:myitihas/services/user_block_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import 'package:talker_flutter/talker_flutter.dart';
import 'package:uuid/uuid.dart';

enum ChatRealtimeChangeType { insert, delete }

class ChatRealtimeEvent {
  final ChatRealtimeChangeType type;
  final ChatMessage? message;
  final String? messageId;

  const ChatRealtimeEvent.insert(this.message)
    : type = ChatRealtimeChangeType.insert,
      messageId = null;

  const ChatRealtimeEvent.delete(this.messageId)
    : type = ChatRealtimeChangeType.delete,
      message = null;
}

enum ChatRealtimeReactionChangeType { upsert, delete }

class GroupInviteLinkPreview {
  final String conversationId;
  final String groupName;
  final String? groupAvatarUrl;
  final String? groupDescription;
  final int memberCount;
  final String adminName;
  final DateTime expiresAt;
  final bool isMember;

  const GroupInviteLinkPreview({
    required this.conversationId,
    required this.groupName,
    required this.groupAvatarUrl,
    required this.groupDescription,
    required this.memberCount,
    required this.adminName,
    required this.expiresAt,
    required this.isMember,
  });
}

class ChatRealtimeReactionEvent {
  final ChatRealtimeReactionChangeType type;
  final String messageId;
  final String emoji;
  final String userId;

  const ChatRealtimeReactionEvent.upsert({
    required this.messageId,
    required this.emoji,
    required this.userId,
  }) : type = ChatRealtimeReactionChangeType.upsert;

  const ChatRealtimeReactionEvent.delete({
    required this.messageId,
    required this.emoji,
    required this.userId,
  }) : type = ChatRealtimeReactionChangeType.delete;
}

/// Emitted when a user votes (or changes vote) on a chat poll.
class ChatRealtimePollVoteEvent {
  final String messageId;

  const ChatRealtimePollVoteEvent({required this.messageId});
}

/// Service for managing chat conversations and messages.
///
/// Handles creation and retrieval of direct message (DM) conversations
/// and provides methods for chat-related operations.
///
/// All operations use auth.uid() to ensure users can only access
/// their own conversations.
@lazySingleton
class ChatService {
  final SupabaseClient _supabase;
  static const int _maxChatImageBytes = 5 * 1024 * 1024;
  static const int _maxChatDocumentBytes = 5 * 1024 * 1024;
  final StreamController<void> _localUnreadCountChanges =
      StreamController<void>.broadcast();

  // Rate limiting: prevent message spam and abuse
  static const int _maxMessagesPerMinute = 20; // Allow 20 messages per minute
  static const int _maxImagesPerMinute = 5; // Allow 5 images per minute
  static const int _maxDocumentsPerMinute = 10; // Allow 10 docs per minute
  static const int _rateLimitWindowSeconds = 60;
  static const int _maxPollQuestionLength = 500;
  static const int _maxPollOptionLength = 200;

  ChatService(this._supabase);

  Future<String> _resolveDisplayName(String userId) async {
    final profile = await _supabase
        .from('profiles')
        .select('full_name, username')
        .eq('id', userId)
        .maybeSingle();

    if (profile == null) return 'A member';
    final fullName = profile['full_name'] as String?;
    if (fullName != null && fullName.trim().isNotEmpty) {
      return fullName.trim();
    }
    final username = profile['username'] as String?;
    if (username != null && username.trim().isNotEmpty) {
      return username.trim();
    }
    return 'A member';
  }

  Future<void> _publishGroupMembershipEvent({
    required String conversationId,
    required String actorUserId,
    required String type,
    required String text,
  }) async {
    await _supabase.from('chat_messages').insert({
      'conversation_id': conversationId,
      'sender_id': actorUserId,
      'content': text,
      'type': type,
    });
  }

  /// Checks if a feature flag is enabled in the database.
  /// Returns true if enabled, false if disabled or not found.
  /// Errors default to false (fail-close) to prevent accidental exposure of incomplete features.
  Future<bool> _isFeatureFlagEnabled(String flagKey) async {
    try {
      final response = await _supabase
          .from('feature_flags')
          .select('enabled')
          .eq('key', flagKey)
          .limit(1)
          .maybeSingle();

      return response != null && (response['enabled'] as bool? ?? false);
    } catch (e) {
      final logger = getIt<Talker>();
      logger.warning('[ChatService] Error checking feature flag $flagKey: $e');
      // Fail-close: if we can't check the flag, disable the feature
      return false;
    }
  }

  /// Records an analytics event for chat media operations.
  /// Fire-and-forget operation; errors are logged but not thrown.
  Future<void> _recordMediaAnalyticsEvent({
    required String eventType,
    required String messageId,
    int? fileSizeBytes,
    int? durationMs,
    String? errorMessage,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _supabase.rpc(
        'record_chat_media_event',
        params: {
          'event_type': eventType,
          'message_id': messageId,
          'file_size_bytes': fileSizeBytes,
          'duration_ms': durationMs,
          'error_message': errorMessage,
          'metadata': metadata,
        },
      );
    } catch (e) {
      final logger = getIt<Talker>();
      logger.warning('[ChatService] Failed to record analytics event: $e');
      // Non-critical: don't throw, just log
    }
  }

  /// Gets or creates a direct message conversation with another user.
  ///
  /// [otherUserId] - The ID of the user to chat with.
  ///
  /// Returns the conversation ID (channel ID) for the DM.
  ///
  /// Uses auth.uid() as the current user ID.
  ///
  /// This method is idempotent and safe to call multiple times.
  /// Handles race conditions where concurrent requests attempt to create
  /// the same DM conversation.
  ///
  /// Throws [AuthException] if user is not authenticated or attempting self-DM.
  /// Throws [ServerException] on database errors.
  Future<String> getOrCreateDM(String otherUserId) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        logger.warning(
          '[ChatService] Unauthenticated user attempted to create DM',
        );
        throw AuthException('User must be authenticated to create DM');
      }

      // Prevent self-DM
      if (currentUserId == otherUserId) {
        logger.warning(
          '[ChatService] User $currentUserId attempted to create DM with self',
        );
        throw AuthException('Cannot create DM with yourself');
      }

      logger.debug(
        '[ChatService] getOrCreateDM called for users: $currentUserId <-> $otherUserId',
      );

      // Check if a DM conversation already exists between these two users
      final existingId = await _findExistingDM(currentUserId, otherUserId);
      if (existingId != null) {
        logger.info('[ChatService] Found existing DM: $existingId');
        return existingId;
      }

      // No existing DM found, attempt to create a new one
      logger.info(
        '[ChatService] No existing DM found, creating new conversation',
      );

      try {
        // Insert new conversation with is_group = false
        final conversationResponse = await _supabase
            .from('conversations')
            // Note: backend schema does not include `created_by` in all environments.
            .insert({'is_group': false})
            .select('id')
            .single();

        final conversationId = conversationResponse['id'] as String;
        logger.debug('[ChatService] Created conversation: $conversationId');

        // Insert conversation members for both users
        await _supabase.from('conversation_members').insert([
          {'conversation_id': conversationId, 'user_id': currentUserId},
          {'conversation_id': conversationId, 'user_id': otherUserId},
        ]);

        logger.info('[ChatService] Successfully created DM: $conversationId');
        return conversationId;
      } catch (createError) {
        // If creation failed (e.g., due to race condition), check again for existing DM
        // This makes the method idempotent and handles concurrent creation attempts
        logger.warning(
          '[ChatService] Error during DM creation, checking for existing DM again: $createError',
        );

        final retryExistingId = await _findExistingDM(
          currentUserId,
          otherUserId,
        );
        if (retryExistingId != null) {
          logger.info(
            '[ChatService] Found DM after creation conflict: $retryExistingId',
          );
          return retryExistingId;
        }

        // If still no DM found, rethrow the original error
        rethrow;
      }
    } catch (e, stackTrace) {
      logger.error('[ChatService] Error in getOrCreateDM', e, stackTrace);

      if (e is AuthException) {
        rethrow;
      }

      throw const ServerException('Failed to get or create DM');
    }
  }

  /// Returns all members of a conversation (for groups and DMs).
  ///
  /// Each map contains:
  /// - id
  /// - full_name
  /// - username
  /// - avatar_url
  Future<List<Map<String, dynamic>>> getConversationMembers(
    String conversationId,
  ) async {
    final logger = getIt<Talker>();
    try {
      final rows = await _supabase
          .from('conversation_members')
          .select('user_id, profiles(full_name, username, avatar_url)')
          .eq('conversation_id', conversationId);

      return (rows as List).map<Map<String, dynamic>>((row) {
        final userId = row['user_id'] as String;
        final profile = row['profiles'] as Map<String, dynamic>?;
        final fullName = profile?['full_name'] as String?;
        final username = profile?['username'] as String?;
        final avatarUrl = profile?['avatar_url'] as String?;
        return {
          'id': userId,
          'full_name': fullName,
          'username': username,
          'avatar_url': avatarUrl,
        };
      }).toList();
    } catch (e, stackTrace) {
      logger.error(
        '[ChatService] Failed to load conversation members for $conversationId',
        e,
        stackTrace,
      );
      return [];
    }
  }

  /// Creates a new group conversation.
  ///
  /// [groupName] - The name of the group.
  /// [memberUserIds] - List of user IDs to add as members (including creator).
  /// [avatarFile] - Optional group avatar image file. If null, no avatar is uploaded.
  ///
  /// Returns the conversation ID of the newly created group.
  ///
  /// This method:
  /// 1. Creates a new conversation with is_group = true
  /// 2. If [avatarFile] is non-null, uploads the avatar to Supabase Storage (group_avatar bucket)
  /// 3. Inserts conversation_members for all members
  /// 4. Sets last_read_at = now() for creator, null for others
  ///
  /// Throws [AuthException] if user is not authenticated.
  /// Throws [ServerException] on database or storage errors.
  Future<String> createGroupConversation({
    required String groupName,
    required List<String> memberUserIds,
    File? avatarFile,
  }) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        logger.warning(
          '[ChatService] Unauthenticated user attempted to create group',
        );
        throw AuthException('User must be authenticated to create group');
      }

      logger.info(
        '[ChatService] Creating group conversation: $groupName with ${memberUserIds.length} members',
      );

      // Generate a new conversation ID
      final conversationId = const Uuid().v4();
      logger.debug('[ChatService] Generated conversation ID: $conversationId');

      String? avatarUrl;
      if (avatarFile != null) {
        final avatarPath = '$conversationId/avatar.jpg';
        logger.debug('[ChatService] Uploading avatar to: $avatarPath');

        await _supabase.storage
            .from('group_avatar')
            .upload(
              avatarPath,
              avatarFile,
              fileOptions: const FileOptions(
                cacheControl: '3600',
                upsert: false,
              ),
            );

        avatarUrl = _supabase.storage
            .from('group_avatar')
            .getPublicUrl(avatarPath);

        logger.debug('[ChatService] Avatar uploaded, public URL: $avatarUrl');
      }

      // Insert into conversations table
      final now = DateTime.now().toUtc().toIso8601String();
      await _supabase.from('conversations').insert({
        'id': conversationId,
        'is_group': true,
        'group_name': groupName,
        'group_avatar_url': avatarUrl,
        'last_message': null,
        'last_message_sender_id': null,
        'last_message_at': now,
      });

      logger.debug('[ChatService] Conversation record created');

      // Insert conversation_members for all members
      final memberRows = memberUserIds.map((userId) {
        return {
          'conversation_id': conversationId,
          'user_id': userId,
          'role': userId == currentUserId ? 'owner' : 'member',
          // Creator gets last_read_at = now(), others get null
          'last_read_at': userId == currentUserId ? now : null,
        };
      }).toList();

      await _supabase.from('conversation_members').insert(memberRows);

      logger.info(
        '[ChatService] Successfully created group conversation: $conversationId',
      );

      return conversationId;
    } on AuthException {
      rethrow;
    } on StorageException catch (e, stackTrace) {
      logger.error(
        '[ChatService] Storage error creating group conversation',
        e,
        stackTrace,
      );
      throw ServerException(
        'Failed to upload group avatar: ${e.message}',
        e.statusCode,
      );
    } on PostgrestException catch (e, stackTrace) {
      logger.error(
        '[ChatService] Database error creating group conversation',
        e,
        stackTrace,
      );
      throw ServerException(
        'Failed to create group conversation: ${e.message}',
        e.code,
      );
    } catch (e, stackTrace) {
      logger.error(
        '[ChatService] Unexpected error creating group conversation',
        e,
        stackTrace,
      );
      throw const ServerException('Failed to create group conversation');
    }
  }

  /// Fetches all conversations for the current user.
  ///
  /// Returns a list of Conversation objects sorted by most recent message.
  /// Only includes direct messages (is_group = false) for now.
  ///
  /// Each conversation includes:
  /// - The other user's information (name, avatar)
  /// - The last message content and timestamp
  ///
  /// RLS policies ensure users only see their own conversations.
  ///
  /// Throws [AuthException] if user is not authenticated.
  /// Throws [ServerException] on database errors.
  ///
  Future<List<Conversation>> getMyConversations({bool? isGroup}) async {
    final uid = _supabase.auth.currentUser!.id;

    // Fetch conversations with join to conversation_members to get last_read_at and deleted_at
    var query = _supabase
        .from('conversations')
        .select('''
          id,
          is_group,
          group_name,
          group_avatar_url,
          last_message,
          last_message_at,
          last_message_sender_id,
          conversation_members!inner(
            user_id,
            last_read_at,
            deleted_at
          )
        ''')
        .eq('conversation_members.user_id', uid);

    // Apply is_group filter if specified
    if (isGroup != null) {
      query = query.eq('is_group', isGroup);
    }

    // Order by most recent message first and execute query
    final response = await query.order('last_message_at', ascending: false);

    // Map to Conversation objects and filter out deleted conversations
    return (response as List)
        .where((e) {
          // Extract deleted_at from conversation_members join
          final members = e['conversation_members'] as List;
          final userMember = members.firstWhere(
            (m) => m['user_id'] == uid,
            orElse: () => {'deleted_at': null},
          );

          final deletedAt = userMember['deleted_at'];
          final lastMessageAt = e['last_message_at'];

          // If never deleted, show conversation
          if (deletedAt == null) return true;

          // If deleted but no last message, hide conversation
          if (lastMessageAt == null) return false;

          // Show only if last message is after deletion
          final deletedTime = DateTime.parse(deletedAt as String);
          final lastMsgTime = DateTime.parse(lastMessageAt as String);
          return lastMsgTime.isAfter(deletedTime);
        })
        .map((e) {
          // Extract last_read_at from conversation_members join
          final members = e['conversation_members'] as List;
          final userMember = members.firstWhere(
            (m) => m['user_id'] == uid,
            orElse: () => {'last_read_at': null},
          );

          return Conversation(
            id: e['id'],
            isGroup: e['is_group'],
            title: e['is_group'] ? (e['group_name'] ?? 'Group') : 'Chat',
            avatarUrl: e['is_group'] ? e['group_avatar_url'] : null,
            lastMessage: e['last_message'] as String?,
            lastMessageAt: e['last_message_at'] != null
                ? DateTime.parse(e['last_message_at'] as String)
                : null,
            lastMessageSenderId: e['last_message_sender_id'] as String?,
            lastReadAt: userMember['last_read_at'] != null
                ? DateTime.parse(userMember['last_read_at'] as String)
                : null,
          );
        })
        .toList();
  }

  /// Returns the conversation ID if a DM already exists between the two users, null otherwise.
  /// Exposed for New Chat flow (check before sending message request).
  Future<String?> findExistingDM(String otherUserId) async {
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) return null;
    return _findExistingDM(currentUserId, otherUserId);
  }

  /// Returns an existing or newly created DM when direct messaging is allowed.
  ///
  /// Rules:
  /// - Existing DM always wins.
  /// - New DM creation is allowed only for mutual followers.
  /// - Returns null when mutual follow is missing.
  /// - Throws [AuthException] for unauthenticated/self target.
  /// - Throws [AuthException] when either side has blocked the other.
  Future<String?> getOrCreateDirectDMIfAllowed(String otherUserId) async {
    final logger = getIt<Talker>();
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      throw AuthException('User must be authenticated to message');
    }
    if (currentUserId == otherUserId) {
      throw AuthException('Cannot message yourself');
    }

    final existingDM = await _findExistingDM(currentUserId, otherUserId);
    if (existingDM != null) {
      return existingDM;
    }

    final blockService = getIt<UserBlockService>();
    final iBlockedOther = await blockService.isUserBlocked(otherUserId);
    if (iBlockedOther) {
      throw AuthException('You can\'t message this user');
    }

    final otherBlockedMe = await blockService.hasBlockedMe(otherUserId);
    if (otherBlockedMe) {
      throw AuthException('You can\'t message this user');
    }

    final followService = getIt<FollowService>();
    final mutualFollowers = await followService.areMutualFollowers(otherUserId);
    if (!mutualFollowers) {
      logger.debug(
        '[ChatService] Direct DM not allowed yet (not mutual followers): $currentUserId -> $otherUserId',
      );
      return null;
    }

    return getOrCreateDM(otherUserId);
  }

  /// Helper method to find an existing DM between two users.
  ///
  /// Returns the conversation ID if found, null otherwise.
  Future<String?> _findExistingDM(String userId1, String userId2) async {
    final logger = getIt<Talker>();

    try {
      // Query conversations with is_group = false that involve either user
      final existingConversation = await _supabase
          .from('conversations')
          .select('id, conversation_members!inner(user_id)')
          .eq('is_group', false)
          .or(
            'user_id.eq.$userId1,user_id.eq.$userId2',
            referencedTable: 'conversation_members',
          )
          .limit(100);

      // Filter conversations where both users are members and exactly 2 members total
      for (final conversation in existingConversation) {
        final members = (conversation['conversation_members'] as List)
            .map((m) => m['user_id'] as String)
            .toSet();

        if (members.contains(userId1) &&
            members.contains(userId2) &&
            members.length == 2) {
          return conversation['id'] as String;
        }
      }

      return null;
    } catch (e) {
      logger.debug('[ChatService] Error in _findExistingDM: $e');
      return null;
    }
  }

  /// Returns true if the current user is in a 1:1 DM conversation
  /// with another user where either side has blocked the other.
  ///
  /// For group conversations (is_group = true) this always returns false.
  Future<bool> _isBlockedDMConversationForCurrentUser(
    String conversationId,
  ) async {
    final logger = getIt<Talker>();
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      throw AuthException('User must be authenticated');
    }

    try {
      // Load conversation with its members so we can resolve the other user
      final response = await _supabase
          .from('conversations')
          .select('id, is_group, conversation_members!inner(user_id)')
          .eq('id', conversationId)
          .maybeSingle();

      if (response == null) {
        logger.debug(
          '[ChatService] _isBlockedDMConversationForCurrentUser: conversation not found: $conversationId',
        );
        return false;
      }

      final isGroup = response['is_group'] as bool? ?? false;
      if (isGroup) {
        // Blocking semantics for groups are handled elsewhere (e.g. invites);
        // do not block entire group conversations here.
        return false;
      }

      final members =
          (response['conversation_members'] as List?)
              ?.map((m) => m['user_id'] as String)
              .toSet() ??
          <String>{};

      if (!members.contains(currentUserId) || members.length != 2) {
        // Not a standard 1:1 DM; don't apply block guard here.
        return false;
      }

      final otherUserId = members.firstWhere(
        (id) => id != currentUserId,
        orElse: () => '',
      );
      if (otherUserId.isEmpty) {
        return false;
      }

      final blockService = getIt<UserBlockService>();

      // current user has blocked the other
      final iBlockedOther = await blockService.isUserBlocked(otherUserId);
      if (iBlockedOther) return true;

      // other user has blocked current user
      final otherBlockedMe = await blockService.hasBlockedMe(otherUserId);
      return otherBlockedMe;
    } catch (e, stackTrace) {
      logger.error(
        '[ChatService] Error in _isBlockedDMConversationForCurrentUser for conversation $conversationId',
        e,
        stackTrace,
      );
      // On error, fail open rather than blocking chat entirely.
      return false;
    }
  }

  /// Marks a conversation as read by updating the last_read_at timestamp
  /// for the current user in the conversation_members table.
  ///
  /// [conversationId] - The ID of the conversation to mark as read.
  ///
  /// This updates the backend state only and does not affect UI.
  /// Should be called when a user opens a conversation.
  ///
  /// Throws [AuthException] if user is not authenticated.
  Future<void> markConversationAsRead(String conversationId) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        logger.warning(
          '[ChatService] Cannot mark conversation as read: user not authenticated',
        );
        throw AuthException(
          'User must be authenticated to mark conversation as read',
        );
      }

      logger.debug(
        '[ChatService] Marking conversation as read: $conversationId for user: $currentUserId',
      );

      await _supabase
          .from('conversation_members')
          .update({'last_read_at': DateTime.now().toUtc().toIso8601String()})
          .eq('conversation_id', conversationId)
          .eq('user_id', currentUserId);

      logger.info(
        '[ChatService] Successfully marked conversation as read: $conversationId',
      );

      // Emit local unread-change tick so badge updates immediately even if
      // realtime update delivery is delayed/missed on some clients.
      if (!_localUnreadCountChanges.isClosed) {
        _localUnreadCountChanges.add(null);
      }
    } on AuthException {
      rethrow;
    } catch (e, stackTrace) {
      logger.error(
        '[ChatService] Failed to mark conversation as read: $conversationId',
        e,
        stackTrace,
      );
      // Don't throw - this is a non-critical operation
      // The conversation will still work even if marking as read fails
    }
  }

  /// Fetches all messages for a given conversation.
  ///
  /// [conversationId] - The ID of the conversation to fetch messages from.
  ///
  /// Returns a list of ChatMessage objects ordered by creation time (oldest first).
  ///
  /// RLS policies ensure users can only fetch messages from conversations
  /// they are members of. If the user is not a member, an empty list is returned.
  ///
  /// This method is idempotent and safe to retry.
  ///
  /// Throws [AuthException] if user is not authenticated.
  /// Throws [ServerException] on database errors.
  Future<List<ChatMessage>> getMessages(String conversationId) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        logger.warning(
          '[ChatService] Unauthenticated user attempted to fetch messages',
        );
        throw AuthException('User must be authenticated to fetch messages');
      }

      logger.debug(
        '[ChatService] Fetching messages for conversation: $conversationId (user: $currentUserId)',
      );

      // For 1:1 DMs where either user has blocked the other, do not return
      // any message history. The UI will show a blocked-state banner instead.
      final isBlockedDm = await _isBlockedDMConversationForCurrentUser(
        conversationId,
      );
      if (isBlockedDm) {
        logger.info(
          '[ChatService] Blocked DM conversation, returning no messages for user: $currentUserId, conversation: $conversationId',
        );
        return [];
      }

      // Get joined_at and deleted_at timestamps for current user
      final memberResponse = await _supabase
          .from('conversation_members')
          .select('joined_at, deleted_at')
          .eq('conversation_id', conversationId)
          .eq('user_id', currentUserId)
          .maybeSingle();

      DateTime? visibilityStartAt;
      if (memberResponse != null) {
        final joinedAt = memberResponse['joined_at'] != null
            ? DateTime.parse(memberResponse['joined_at'] as String)
            : null;
        final deletedAt = memberResponse['deleted_at'] != null
            ? DateTime.parse(memberResponse['deleted_at'] as String)
            : null;

        // Member can only see messages from when they joined, and if they
        // deleted the conversation later, visibility starts from that later time.
        if (joinedAt != null && deletedAt != null) {
          visibilityStartAt = joinedAt.isAfter(deletedAt)
              ? joinedAt
              : deletedAt;
        } else if (joinedAt != null) {
          visibilityStartAt = joinedAt;
        } else if (deletedAt != null) {
          visibilityStartAt = deletedAt;
        }

        if (visibilityStartAt != null) {
          logger.debug(
            '[ChatService] Conversation visibility starts at: $visibilityStartAt (joined: $joinedAt, deleted: $deletedAt), filtering messages',
          );
        }
      }

      // Fetch messages ordered by created_at ascending (oldest first)
      // RLS will automatically filter to only messages the user can access
      var query = _supabase
          .from('chat_messages')
          .select(
            'id, conversation_id, sender_id, content, type, created_at, shared_content_id, is_deleted_for_everyone, metadata',
          )
          .eq('conversation_id', conversationId)
          .eq(
            'is_deleted_for_everyone',
            false,
          ); // exclude soft-deleted messages

      // Filter messages: only show messages created at or after visibility start
      if (visibilityStartAt != null) {
        query = query.gte('created_at', visibilityStartAt.toIso8601String());
      }

      final response = await query.order('created_at', ascending: true);
      final rawMessages = response as List;
      final hiddenMessageIds = await _getHiddenMessageIds(conversationId);
      final messageIds = rawMessages
          .map((m) => m['id'] as String?)
          .whereType<String>()
          .toList();
      final attachmentsByMessage = await _getAttachmentsByMessageIds(
        messageIds,
      );
      final linkPreviewByMessage = await _getLinkPreviewsByMessageIds(
        messageIds,
      );

      // Fetch sender profiles for group chat display (sender name, avatar)
      final senderIds = rawMessages
          .map((m) => m['sender_id'] as String)
          .toSet()
          .toList();
      final Map<String, Map<String, dynamic>> profileMap = {};
      if (senderIds.isNotEmpty) {
        try {
          final profileResponse = await _supabase
              .from('profiles')
              .select('id, full_name, username, avatar_url')
              .inFilter('id', senderIds);
          for (final p in profileResponse as List) {
            final profile = p as Map<String, dynamic>;
            profileMap[profile['id'] as String] = profile;
          }
        } catch (e) {
          logger.warning('[ChatService] Failed to fetch sender profiles: $e');
        }
      }

      final messages = rawMessages
          .map((json) {
            try {
              final senderId = json['sender_id'] as String;
              final messageId = json['id'] as String;
              if (hiddenMessageIds.contains(messageId)) {
                return null;
              }
              final profile = profileMap[senderId];
              final enriched = Map<String, dynamic>.from(json);
              if (profile != null) {
                enriched['sender_name'] =
                    profile['full_name'] ?? profile['username'] ?? 'User';
                enriched['sender_avatar_url'] = profile['avatar_url'];
              }
              enriched['attachments'] =
                  attachmentsByMessage[messageId] ?? const [];
              enriched['link_preview'] = linkPreviewByMessage[messageId];
              return ChatMessage.fromJson(enriched);
            } catch (parseError) {
              logger.warning(
                '[ChatService] Failed to parse message: $parseError',
              );
              return null;
            }
          })
          .whereType<ChatMessage>()
          .toList();

      logger.info(
        '[ChatService] Fetched ${messages.length} messages for conversation $conversationId',
      );
      return messages;
    } on AuthException {
      rethrow;
    } on PostgrestException catch (e, stackTrace) {
      logger.error(
        '[ChatService] Database error in getMessages: ${e.message}',
        e,
        stackTrace,
      );
      throw ServerException('Failed to fetch messages: ${e.message}', e.code);
    } catch (e, stackTrace) {
      logger.error(
        '[ChatService] Unexpected error in getMessages',
        e,
        stackTrace,
      );
      throw const ServerException('Failed to fetch messages');
    }
  }

  /// Fetches all reactions for messages in a conversation, grouped by message and emoji.
  ///
  /// Returns a map: { messageId: { emoji: count } } and a map of the current
  /// user's active emoji per message.
  Future<
    ({
      Map<String, Map<String, int>> countsByMessage,
      Map<String, String> currentUserEmojiByMessage,
    })
  >
  getReactionsForConversation(String conversationId) async {
    final logger = getIt<Talker>();
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      throw AuthException('User must be authenticated to load reactions');
    }

    try {
      final response = await _supabase
          .from('message_reactions')
          .select('id, message_id, conversation_id, user_id, emoji, created_at')
          .eq('conversation_id', conversationId);

      final countsByMessage = <String, Map<String, int>>{};
      final currentUserEmojiByMessage = <String, String>{};

      for (final row in response as List) {
        final reaction = MessageReaction.fromJson(
          Map<String, dynamic>.from(row as Map),
        );

        final byEmoji = countsByMessage.putIfAbsent(
          reaction.messageId,
          () => {},
        );
        byEmoji[reaction.emoji] = (byEmoji[reaction.emoji] ?? 0) + 1;

        if (reaction.userId == currentUserId) {
          currentUserEmojiByMessage[reaction.messageId] = reaction.emoji;
        }
      }

      return (
        countsByMessage: countsByMessage,
        currentUserEmojiByMessage: currentUserEmojiByMessage,
      );
    } on PostgrestException catch (e, stackTrace) {
      logger.error(
        '[ChatService] Database error in getReactionsForConversation: ${e.message}',
        e,
        stackTrace,
      );
      throw ServerException('Failed to fetch reactions: ${e.message}', e.code);
    } catch (e, stackTrace) {
      logger.error(
        '[ChatService] Unexpected error in getReactionsForConversation',
        e,
        stackTrace,
      );
      throw const ServerException('Failed to fetch reactions');
    }
  }

  /// Sets/changes the current user's reaction for a message.
  ///
  /// This will upsert a row keyed by (message_id, user_id), effectively ensuring
  /// only one active reaction per user per message.
  Future<void> setReaction({
    required String conversationId,
    required String messageId,
    required String emoji,
  }) async {
    final logger = getIt<Talker>();
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      throw AuthException('User must be authenticated to react to messages');
    }
    if (emoji.isEmpty) return;

    try {
      await _supabase.from('message_reactions').upsert({
        'message_id': messageId,
        'conversation_id': conversationId,
        'user_id': currentUserId,
        'emoji': emoji,
      });
      logger.info(
        '[ChatService] Set reaction "$emoji" for message $messageId in $conversationId',
      );
    } on PostgrestException catch (e, stackTrace) {
      logger.error(
        '[ChatService] Database error in setReaction: ${e.message}',
        e,
        stackTrace,
      );
      throw ServerException('Failed to set reaction: ${e.message}', e.code);
    } catch (e, stackTrace) {
      logger.error(
        '[ChatService] Unexpected error in setReaction',
        e,
        stackTrace,
      );
      throw const ServerException('Failed to set reaction');
    }
  }

  /// Clears the current user's reaction for a message, if any.
  Future<void> clearReaction({required String messageId}) async {
    final logger = getIt<Talker>();
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      throw AuthException('User must be authenticated to clear reactions');
    }

    try {
      await _supabase
          .from('message_reactions')
          .delete()
          .eq('message_id', messageId)
          .eq('user_id', currentUserId);
      logger.info(
        '[ChatService] Cleared reaction for message $messageId for user $currentUserId',
      );
    } on PostgrestException catch (e, stackTrace) {
      logger.error(
        '[ChatService] Database error in clearReaction: ${e.message}',
        e,
        stackTrace,
      );
      throw ServerException('Failed to clear reaction: ${e.message}', e.code);
    } catch (e, stackTrace) {
      logger.error(
        '[ChatService] Unexpected error in clearReaction',
        e,
        stackTrace,
      );
      throw const ServerException('Failed to clear reaction');
    }
  }

  /// Subscribes to realtime reaction changes for a conversation.
  ///
  /// Emits upsert/delete events whenever a user adds/changes/removes a reaction.
  Stream<ChatRealtimeReactionEvent> subscribeToMessageReactions(
    String conversationId,
  ) {
    final logger = getIt<Talker>();
    final currentUserId = _supabase.auth.currentUser?.id;
    late StreamController<ChatRealtimeReactionEvent> controller;
    RealtimeChannel? channel;
    bool isSubscribed = false;

    final channelName =
        'message_reactions:$conversationId:${DateTime.now().millisecondsSinceEpoch}';

    logger.debug(
      '[ChatService] Setting up reaction subscription for $conversationId (channel: $channelName)',
    );

    controller = StreamController<ChatRealtimeReactionEvent>(
      onListen: () {
        if (isSubscribed) return;
        isSubscribed = true;
        try {
          channel = _supabase
              .channel(channelName)
              .onPostgresChanges(
                event: PostgresChangeEvent.insert,
                schema: 'public',
                table: 'message_reactions',
                filter: PostgresChangeFilter(
                  type: PostgresChangeFilterType.eq,
                  column: 'conversation_id',
                  value: conversationId,
                ),
                callback: (payload) {
                  if (controller.isClosed) return;
                  final record = Map<String, dynamic>.from(payload.newRecord);
                  final messageId = record['message_id'] as String?;
                  final emoji = record['emoji'] as String?;
                  final userId = record['user_id'] as String?;
                  if (messageId == null ||
                      emoji == null ||
                      userId == null ||
                      messageId.isEmpty ||
                      emoji.isEmpty ||
                      userId.isEmpty) {
                    return;
                  }
                  if (currentUserId != null && userId == currentUserId) {
                    // Still emit; UI can optimistically merge this.
                  }
                  controller.add(
                    ChatRealtimeReactionEvent.upsert(
                      messageId: messageId,
                      emoji: emoji,
                      userId: userId,
                    ),
                  );
                },
              )
              .onPostgresChanges(
                event: PostgresChangeEvent.update,
                schema: 'public',
                table: 'message_reactions',
                filter: PostgresChangeFilter(
                  type: PostgresChangeFilterType.eq,
                  column: 'conversation_id',
                  value: conversationId,
                ),
                callback: (payload) {
                  if (controller.isClosed) return;
                  final record = Map<String, dynamic>.from(payload.newRecord);
                  final messageId = record['message_id'] as String?;
                  final emoji = record['emoji'] as String?;
                  final userId = record['user_id'] as String?;
                  if (messageId == null ||
                      emoji == null ||
                      userId == null ||
                      messageId.isEmpty ||
                      emoji.isEmpty ||
                      userId.isEmpty) {
                    return;
                  }
                  controller.add(
                    ChatRealtimeReactionEvent.upsert(
                      messageId: messageId,
                      emoji: emoji,
                      userId: userId,
                    ),
                  );
                },
              )
              .onPostgresChanges(
                event: PostgresChangeEvent.delete,
                schema: 'public',
                table: 'message_reactions',
                filter: PostgresChangeFilter(
                  type: PostgresChangeFilterType.eq,
                  column: 'conversation_id',
                  value: conversationId,
                ),
                callback: (payload) {
                  if (controller.isClosed) return;
                  final oldRecord = Map<String, dynamic>.from(
                    payload.oldRecord,
                  );
                  final messageId = oldRecord['message_id'] as String?;
                  final emoji = oldRecord['emoji'] as String?;
                  final userId = oldRecord['user_id'] as String?;
                  if (messageId == null ||
                      emoji == null ||
                      userId == null ||
                      messageId.isEmpty ||
                      emoji.isEmpty ||
                      userId.isEmpty) {
                    return;
                  }
                  controller.add(
                    ChatRealtimeReactionEvent.delete(
                      messageId: messageId,
                      emoji: emoji,
                      userId: userId,
                    ),
                  );
                },
              )
              .subscribe();
        } catch (e, stackTrace) {
          logger.error(
            '[ChatService] Failed to setup reaction subscription: $channelName',
            e,
            stackTrace,
          );
          isSubscribed = false;
          if (!controller.isClosed) {
            controller.addError(e);
          }
        }
      },
      onCancel: () async {
        if (!isSubscribed) return;
        try {
          if (channel != null) {
            await channel!.unsubscribe();
            await _supabase.removeChannel(channel!);
          }
        } catch (e, stackTrace) {
          logger.error(
            '[ChatService] Error cleaning up reaction subscription: $channelName',
            e,
            stackTrace,
          );
        } finally {
          isSubscribed = false;
          channel = null;
        }
      },
    );

    return controller.stream;
  }

  Future<Set<String>> _getHiddenMessageIds(String conversationId) async {
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) return <String>{};
    try {
      final response = await _supabase
          .from('user_hidden_messages')
          .select('message_id')
          .eq('user_id', currentUserId)
          .eq('conversation_id', conversationId);
      return (response as List)
          .map((row) => row['message_id'] as String?)
          .whereType<String>()
          .toSet();
    } catch (_) {
      return <String>{};
    }
  }

  Future<Map<String, List<Map<String, dynamic>>>> _getAttachmentsByMessageIds(
    List<String> messageIds,
  ) async {
    if (messageIds.isEmpty) {
      return <String, List<Map<String, dynamic>>>{};
    }

    final rows = await _supabase
        .from('message_attachments')
        .select('id, message_id, bucket, object_path, mime_type, size_bytes')
        .inFilter('message_id', messageIds)
        .order('created_at', ascending: true);

    final result = <String, List<Map<String, dynamic>>>{};
    for (final row in rows as List) {
      final map = Map<String, dynamic>.from(row as Map);
      final messageId = map['message_id'] as String?;
      final bucket = map['bucket'] as String?;
      final objectPath = map['object_path'] as String?;
      if (messageId == null || bucket == null || objectPath == null) {
        continue;
      }

      try {
        final signedUrl = await _supabase.storage
            .from(bucket)
            .createSignedUrl(objectPath, 60 * 60);
        map['signed_url'] = signedUrl;
      } catch (_) {
        // If signed URL generation fails, keep metadata so UI can still show fallback text.
      }

      result.putIfAbsent(messageId, () => <Map<String, dynamic>>[]).add(map);
    }

    return result;
  }

  Future<Map<String, Map<String, dynamic>>> _getLinkPreviewsByMessageIds(
    List<String> messageIds,
  ) async {
    if (messageIds.isEmpty) {
      return <String, Map<String, dynamic>>{};
    }

    final rows = await _supabase
        .from('message_link_previews')
        .select('message_id, url, title, description, image_url, domain')
        .inFilter('message_id', messageIds);

    final result = <String, Map<String, dynamic>>{};
    for (final row in rows as List) {
      final map = Map<String, dynamic>.from(row as Map);
      final messageId = map['message_id'] as String?;
      if (messageId != null) {
        result[messageId] = map;
      }
    }
    return result;
  }

  /// Checks if the current user has exceeded the rate limit for a given message type.
  /// Returns the remaining count if rate limit has not been exceeded.
  /// Throws a ServerException if rate limit is exceeded.
  ///
  /// [userId] - The user ID to check rate limits for.
  /// [isImage] - If true, checks image-only rate limit.
  /// [isDocument] - If true, checks document-only rate limit.
  Future<void> _checkRateLimit(
    String userId, {
    bool isImage = false,
    bool isDocument = false,
  }) async {
    try {
      final logger = getIt<Talker>();
      final now = DateTime.now().toUtc();
      final oneMinuteAgo = now.subtract(
        Duration(seconds: _rateLimitWindowSeconds),
      );

      // Count messages sent by this user in the last minute
      var query = _supabase
          .from('chat_messages')
          .select('id')
          .eq('sender_id', userId)
          .gt('created_at', oneMinuteAgo.toIso8601String());

      if (isImage) {
        query = query.eq('type', 'image');
      } else if (isDocument) {
        query = query.eq('type', 'document');
      }

      final response = await query.limit(100); // Limit to avoid expensive counting

      final count = (response as List).length;
      final maxLimit = isImage
          ? _maxImagesPerMinute
          : isDocument
          ? _maxDocumentsPerMinute
          : _maxMessagesPerMinute;
      final messageType = isImage
          ? 'image'
          : isDocument
          ? 'document'
          : 'message';

      if (count >= maxLimit) {
        logger.warning(
          '[ChatService] Rate limit exceeded for $messageType: user=$userId, count=$count, limit=$maxLimit',
        );
        throw ServerException(
          'You are sending $messageType too fast. Please wait a moment.',
          'RATE_LIMIT_EXCEEDED',
        );
      }

      logger.debug(
        '[ChatService] Rate limit check passed for $messageType: user=$userId, count=$count/$maxLimit',
      );
    } on ServerException {
      rethrow;
    } catch (e, stackTrace) {
      final logger = getIt<Talker>();
      logger.error('[ChatService] Error checking rate limit', e, stackTrace);
      // On error, fail open - allow the operation to proceed
      // Better to have a false negative than block legitimate users
    }
  }

  String _guessMimeType(String path) {
    final lowerPath = path.toLowerCase();
    if (lowerPath.endsWith('.jpg') || lowerPath.endsWith('.jpeg')) {
      return 'image/jpeg';
    }
    if (lowerPath.endsWith('.png')) {
      return 'image/png';
    }
    if (lowerPath.endsWith('.webp')) {
      return 'image/webp';
    }
    if (lowerPath.endsWith('.gif')) {
      return 'image/gif';
    }
    if (lowerPath.endsWith('.pdf')) {
      return 'application/pdf';
    }
    if (lowerPath.endsWith('.doc')) {
      return 'application/msword';
    }
    if (lowerPath.endsWith('.docx')) {
      return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    }
    if (lowerPath.endsWith('.ppt')) {
      return 'application/vnd.ms-powerpoint';
    }
    if (lowerPath.endsWith('.pptx')) {
      return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
    }
    if (lowerPath.endsWith('.xls')) {
      return 'application/vnd.ms-excel';
    }
    if (lowerPath.endsWith('.xlsx')) {
      return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
    }
    if (lowerPath.endsWith('.csv')) {
      return 'text/csv';
    }
    return 'application/octet-stream';
  }

  bool _isSupportedDocumentMime(String mimeType) {
    return const {
      'application/pdf',
      'application/msword',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'application/vnd.ms-powerpoint',
      'application/vnd.openxmlformats-officedocument.presentationml.presentation',
      'application/vnd.ms-excel',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'text/csv',
    }.contains(mimeType);
  }

  String? _extractFirstMessageUrl(String input) {
    return ChatUrlParser.extractFirstNormalizedUrl(input);
  }

  String? _extractDomain(String? url) {
    return ChatUrlParser.extractDomain(url);
  }

  /// Invokes the link-preview edge function to asynchronously fetch OG metadata.
  /// This is a fire-and-forget operation; errors are logged but not thrown.
  Future<void> _invokeLinkPreviewFunction(String previewId, String url) async {
    try {
      await _supabase.functions.invoke(
        'link-preview',
        body: {
          'data': {'id': previewId, 'url': url},
        },
      );
    } catch (e) {
      // Log but don't throw - this is a non-critical background operation
      getIt<Talker>().warning(
        '[ChatService] Error invoking link-preview function: $e',
      );
    }
  }

  /// Sends a message to a conversation.
  ///
  /// [conversationId] - The ID of the conversation to send the message to.
  /// [content] - The text content of the message.
  ///
  /// Inserts a new message into the chat_messages table.
  /// RLS policies ensure users can only send messages to conversations
  /// they are members of. If the user is not a member, a ServerException
  /// is thrown.
  ///
  /// Note: This operation creates a new message on each call. If retried,
  /// it will create duplicate messages. This is expected behavior.
  ///
  /// Throws [AuthException] if user is not authenticated.
  /// Throws [ServerException] if content is empty, user is not a conversation
  /// member, or on database errors.
  Future<void> sendMessage({
    required String conversationId,
    required String content,
    String? type, // e.g., 'text', 'story', 'post', etc.
    String? sharedContentId,
  }) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        logger.warning(
          '[ChatService] Unauthenticated user attempted to send message',
        );
        throw AuthException('User must be authenticated to send messages');
      }

      // Check rate limit before processing
      await _checkRateLimit(currentUserId, isImage: false);

      // Validate non-empty content
      final trimmedContent = content.trim();
      if (trimmedContent.isEmpty) {
        logger.warning(
          '[ChatService] User $currentUserId attempted to send empty message',
        );
        throw const ServerException('Message content cannot be empty', '400');
      }

      final trimmedType = type?.trim();
      final normalizedType = (trimmedType == null || trimmedType.isEmpty)
          ? null
          : trimmedType;
      final trimmedSharedContentId = sharedContentId?.trim();
      var sharedContentIdForInsert =
          (trimmedSharedContentId == null || trimmedSharedContentId.isEmpty)
          ? null
          : trimmedSharedContentId;
      var typeForInsert = normalizedType;

      // shared_content_id is UUID in Supabase, but sacred site IDs are numeric.
      // Encode sacred site IDs in type so we can still resolve previews later.
      if (typeForInsert?.toLowerCase() == 'sacredsite' &&
          sharedContentIdForInsert != null) {
        final sacredSiteId = int.tryParse(sharedContentIdForInsert);
        if (sacredSiteId != null) {
          typeForInsert = 'sacredSite:$sacredSiteId';
          sharedContentIdForInsert = null;
        }
      }

      logger.debug(
        '[ChatService] Sending message to conversation: $conversationId (user: $currentUserId, length: ${trimmedContent.length})',
      );

      // Prevent sending messages in 1:1 DMs where either user has blocked the other.
      final isBlockedDm = await _isBlockedDMConversationForCurrentUser(
        conversationId,
      );
      if (isBlockedDm) {
        logger.warning(
          '[ChatService] Blocked DM conversation, denying send for user: $currentUserId, conversation: $conversationId',
        );
        throw const ServerException(
          'You cannot send messages in this conversation because one of you has blocked the other.',
          'USER_BLOCKED',
        );
      }

      // Insert new message into chat_messages
      // RLS will ensure user has access to this conversation
      // If user is not a member, insert will fail with RLS policy violation
      final inserted = await _supabase
          .from('chat_messages')
          .insert({
            'conversation_id': conversationId,
            'sender_id': currentUserId,
            'content': trimmedContent,
            if (typeForInsert != null) 'type': typeForInsert,
            if (sharedContentIdForInsert != null)
              'shared_content_id': sharedContentIdForInsert,
          })
          .select('id')
          .single();

      final firstUrl = _extractFirstMessageUrl(trimmedContent);
      final messageId = inserted['id'] as String?;
      if (firstUrl != null && messageId != null) {
        final linkPreviewEnabled = await _isFeatureFlagEnabled(
          'chat_link_preview_enabled',
        );
        if (linkPreviewEnabled) {
          try {
            final previewResponse = await _supabase
                .from('message_link_previews')
                .insert({
                  'message_id': messageId,
                  'url': firstUrl,
                  'normalized_url': firstUrl,
                  'domain': _extractDomain(firstUrl),
                })
                .select('id')
                .single();

            final previewId = previewResponse['id'] as String?;
            if (previewId != null) {
              // Invoke edge function asynchronously to fetch OG metadata
              // Fire-and-forget: don't await, log errors separately
              _invokeLinkPreviewFunction(previewId, firstUrl).onError((
                error,
                stack,
              ) {
                logger.warning(
                  '[ChatService] Link preview fetch failed: $error',
                );
              });
            }
          } catch (e) {
            logger.warning(
              '[ChatService] Failed to save link preview stub: $e',
            );
          }
        }
      }

      logger.info(
        '[ChatService] Message sent successfully to conversation $conversationId',
      );
    } on AuthException {
      rethrow;
    } on ServerException {
      rethrow;
    } on PostgrestException catch (e, stackTrace) {
      logger.error(
        '[ChatService] Database error in sendMessage: ${e.message}',
        e,
        stackTrace,
      );

      // Check for RLS policy violation (user not a member)
      if (e.code == '42501' || e.message.toLowerCase().contains('policy')) {
        throw const ServerException(
          'You do not have permission to send messages to this conversation',
          '403',
        );
      }

      throw ServerException('Failed to send message: ${e.message}', e.code);
    } catch (e, stackTrace) {
      logger.error(
        '[ChatService] Unexpected error in sendMessage',
        e,
        stackTrace,
      );
      throw const ServerException('Failed to send message');
    }
  }

  /// Sends an image message to a conversation.
  ///
  /// Stores the binary in `chat-media` and writes attachment metadata in
  /// `message_attachments` linked to the created chat message.
  Future<void> sendImageMessage({
    required String conversationId,
    required File imageFile,
    String caption = '',
  }) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw AuthException('User must be authenticated to send messages');
      }

      // Check if image feature is enabled
      final imageFeatureEnabled = await _isFeatureFlagEnabled(
        'chat_images_enabled',
      );
      if (!imageFeatureEnabled) {
        throw const ServerException(
          'Image sharing is not yet available. Please check back soon.',
          'FEATURE_DISABLED',
        );
      }

      // Check rate limit for images (stricter than text messages)
      await _checkRateLimit(currentUserId, isImage: true);

      final isBlockedDm = await _isBlockedDMConversationForCurrentUser(
        conversationId,
      );
      if (isBlockedDm) {
        throw const ServerException(
          'You cannot send messages in this conversation because one of you has blocked the other.',
          'USER_BLOCKED',
        );
      }

      if (!await imageFile.exists()) {
        throw const ServerException('Selected image no longer exists', '400');
      }

      final fileLength = await imageFile.length();
      if (fileLength > _maxChatImageBytes) {
        throw const ServerException(
          'Image exceeds 5 MB limit',
          'IMAGE_TOO_LARGE',
        );
      }

      final filePath = imageFile.path;
      final extension = filePath.split('.').last.toLowerCase();
      final fileName = '${const Uuid().v4()}.$extension';
      final objectPath = '$currentUserId/$conversationId/$fileName';
      final mimeType = _guessMimeType(filePath);

      await _supabase.storage
          .from('chat-media')
          .upload(
            objectPath,
            imageFile,
            fileOptions: FileOptions(
              cacheControl: '3600',
              upsert: false,
              contentType: mimeType,
            ),
          );

      final insertedMessage = await _supabase
          .from('chat_messages')
          .insert({
            'conversation_id': conversationId,
            'sender_id': currentUserId,
            'content': caption.trim(),
            'type': 'image',
          })
          .select('id')
          .single();

      final messageId = insertedMessage['id'] as String;

      await _supabase.from('message_attachments').insert({
        'message_id': messageId,
        'conversation_id': conversationId,
        'uploader_id': currentUserId,
        'bucket': 'chat-media',
        'object_path': objectPath,
        'mime_type': mimeType,
        'size_bytes': fileLength,
      });

      final firstUrl = _extractFirstMessageUrl(caption.trim());
      if (firstUrl != null) {
        final linkPreviewEnabled = await _isFeatureFlagEnabled(
          'chat_link_preview_enabled',
        );
        if (linkPreviewEnabled) {
          try {
            final previewResponse = await _supabase
                .from('message_link_previews')
                .insert({
                  'message_id': messageId,
                  'url': firstUrl,
                  'normalized_url': firstUrl,
                  'domain': _extractDomain(firstUrl),
                })
                .select('id')
                .single();

            final previewId = previewResponse['id'] as String?;
            if (previewId != null) {
              _invokeLinkPreviewFunction(previewId, firstUrl).onError((
                error,
                stack,
              ) {
                logger.warning(
                  '[ChatService] Link preview fetch failed for image caption: $error',
                );
              });
            }
          } catch (e) {
            logger.warning(
              '[ChatService] Failed to save image caption link preview stub: $e',
            );
          }
        }
      }

      logger.info(
        '[ChatService] Image message sent successfully to conversation $conversationId',
      );

      // Record analytics event asynchronously (fire-and-forget)
      _recordMediaAnalyticsEvent(
        eventType: 'image_sent',
        messageId: messageId,
        fileSizeBytes: fileLength,
        metadata: {'mime_type': mimeType, 'conversation_id': conversationId},
      );
    } on AuthException {
      rethrow;
    } on ServerException {
      rethrow;
    } on PostgrestException catch (e, stackTrace) {
      logger.error(
        '[ChatService] Database error in sendImageMessage: ${e.message}',
        e,
        stackTrace,
      );
      throw ServerException('Failed to send image: ${e.message}', e.code);
    } on StorageException catch (e, stackTrace) {
      logger.error(
        '[ChatService] Storage error in sendImageMessage: ${e.message}',
        e,
        stackTrace,
      );
      throw ServerException('Failed to upload image: ${e.message}');
    } catch (e, stackTrace) {
      logger.error(
        '[ChatService] Unexpected error in sendImageMessage',
        e,
        stackTrace,
      );
      throw const ServerException('Failed to send image');
    }
  }

  /// Sends a document message to a conversation.
  ///
  /// Supports institute-focused file types with a strict 5 MB limit.
  Future<void> sendDocumentMessage({
    required String conversationId,
    required File documentFile,
    required String fileName,
  }) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw AuthException('User must be authenticated to send messages');
      }

      final docsFeatureEnabled = await _isFeatureFlagEnabled(
        'chat_documents_enabled',
      );
      if (!docsFeatureEnabled) {
        throw const ServerException(
          'Document sharing is not yet available. Please check back soon.',
          'FEATURE_DISABLED',
        );
      }

      await _checkRateLimit(currentUserId, isDocument: true);

      final isBlockedDm = await _isBlockedDMConversationForCurrentUser(
        conversationId,
      );
      if (isBlockedDm) {
        throw const ServerException(
          'You cannot send messages in this conversation because one of you has blocked the other.',
          'USER_BLOCKED',
        );
      }

      if (!await documentFile.exists()) {
        throw const ServerException('Selected file no longer exists', '400');
      }

      final fileLength = await documentFile.length();
      if (fileLength > _maxChatDocumentBytes) {
        throw const ServerException(
          'Document exceeds 5 MB limit',
          'DOCUMENT_TOO_LARGE',
        );
      }

      final sourcePath = documentFile.path;
      final extension = sourcePath.split('.').last.toLowerCase();
      final generatedName = '${const Uuid().v4()}.$extension';
      final objectPath = '$currentUserId/$conversationId/$generatedName';
      final mimeType = _guessMimeType(sourcePath);
      if (!_isSupportedDocumentMime(mimeType)) {
        throw const ServerException(
          'This file type is not supported yet.',
          'UNSUPPORTED_DOCUMENT_TYPE',
        );
      }

      await _supabase.storage
          .from('chat-media')
          .upload(
            objectPath,
            documentFile,
            fileOptions: FileOptions(
              cacheControl: '3600',
              upsert: false,
              contentType: mimeType,
            ),
          );

      final insertedMessage = await _supabase
          .from('chat_messages')
          .insert({
            'conversation_id': conversationId,
            'sender_id': currentUserId,
            'content': fileName.trim(),
            'type': 'document',
          })
          .select('id')
          .single();

      final messageId = insertedMessage['id'] as String;

      await _supabase.from('message_attachments').insert({
        'message_id': messageId,
        'conversation_id': conversationId,
        'uploader_id': currentUserId,
        'bucket': 'chat-media',
        'object_path': objectPath,
        'mime_type': mimeType,
        'size_bytes': fileLength,
      });

      logger.info(
        '[ChatService] Document message sent successfully to conversation $conversationId',
      );

      _recordMediaAnalyticsEvent(
        eventType: 'document_sent',
        messageId: messageId,
        fileSizeBytes: fileLength,
        metadata: {
          'mime_type': mimeType,
          'conversation_id': conversationId,
          'file_name': fileName,
        },
      );
    } on AuthException {
      rethrow;
    } on ServerException {
      rethrow;
    } on PostgrestException catch (e, stackTrace) {
      logger.error(
        '[ChatService] Database error in sendDocumentMessage: ${e.message}',
        e,
        stackTrace,
      );
      throw ServerException('Failed to send document: ${e.message}', e.code);
    } on StorageException catch (e, stackTrace) {
      logger.error(
        '[ChatService] Storage error in sendDocumentMessage: ${e.message}',
        e,
        stackTrace,
      );
      throw ServerException('Failed to upload document: ${e.message}');
    } catch (e, stackTrace) {
      logger.error(
        '[ChatService] Unexpected error in sendDocumentMessage',
        e,
        stackTrace,
      );
      throw const ServerException('Failed to send document');
    }
  }

  /// Sends a poll message (2–4 options, max length enforced).
  Future<void> sendPollMessage({
    required String conversationId,
    required String question,
    required List<String> options,
  }) async {
    final logger = getIt<Talker>();
    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw AuthException('User must be authenticated to send messages');
      }

      final pollsEnabled = await _isFeatureFlagEnabled('chat_polls_enabled');
      if (!pollsEnabled) {
        throw const ServerException(
          'Polls are not available right now.',
          'FEATURE_DISABLED',
        );
      }

      await _checkRateLimit(currentUserId, isImage: false);

      final isBlockedDm = await _isBlockedDMConversationForCurrentUser(
        conversationId,
      );
      if (isBlockedDm) {
        throw const ServerException(
          'You cannot send messages in this conversation because one of you has blocked the other.',
          'USER_BLOCKED',
        );
      }

      final q = question.trim();
      if (q.isEmpty || q.length > _maxPollQuestionLength) {
        throw const ServerException('Invalid poll question', '400');
      }

      final cleaned = options
          .map((o) => o.trim())
          .where((o) => o.isNotEmpty)
          .toList();
      if (cleaned.length < 2 || cleaned.length > 4) {
        throw const ServerException(
          'Poll must have between 2 and 4 options',
          '400',
        );
      }
      for (final o in cleaned) {
        if (o.length > _maxPollOptionLength) {
          throw const ServerException('Poll option is too long', '400');
        }
      }

      await _supabase.from('chat_messages').insert({
        'conversation_id': conversationId,
        'sender_id': currentUserId,
        'content': q,
        'type': 'poll',
        'metadata': {'question': q, 'options': cleaned},
      });

      logger.info('[ChatService] Poll sent to conversation $conversationId');
    } on AuthException {
      rethrow;
    } on ServerException {
      rethrow;
    } on PostgrestException catch (e, stackTrace) {
      logger.error(
        '[ChatService] Database error in sendPollMessage: ${e.message}',
        e,
        stackTrace,
      );
      if (e.code == '42501' || e.message.toLowerCase().contains('policy')) {
        throw const ServerException(
          'You do not have permission to send messages to this conversation',
          '403',
        );
      }
      throw ServerException('Failed to send poll: ${e.message}', e.code);
    } catch (e, stackTrace) {
      logger.error(
        '[ChatService] Unexpected error in sendPollMessage',
        e,
        stackTrace,
      );
      throw const ServerException('Failed to send poll');
    }
  }

  /// Sends a location pin (coordinates stored in [metadata]).
  Future<void> sendLocationMessage({
    required String conversationId,
    required double latitude,
    required double longitude,
    double? accuracyMeters,
    required String contentLine,
  }) async {
    final logger = getIt<Talker>();
    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw AuthException('User must be authenticated to send messages');
      }

      final locationEnabled = await _isFeatureFlagEnabled(
        'chat_location_enabled',
      );
      if (!locationEnabled) {
        throw const ServerException(
          'Location sharing is not available right now.',
          'FEATURE_DISABLED',
        );
      }

      await _checkRateLimit(currentUserId, isImage: false);

      final isBlockedDm = await _isBlockedDMConversationForCurrentUser(
        conversationId,
      );
      if (isBlockedDm) {
        throw const ServerException(
          'You cannot send messages in this conversation because one of you has blocked the other.',
          'USER_BLOCKED',
        );
      }

      final line = contentLine.trim();
      if (line.isEmpty) {
        throw const ServerException('Invalid location label', '400');
      }

      await _supabase.from('chat_messages').insert({
        'conversation_id': conversationId,
        'sender_id': currentUserId,
        'content': line,
        'type': 'location',
        'metadata': {
          'lat': latitude,
          'lng': longitude,
          if (accuracyMeters != null) 'accuracy_m': accuracyMeters,
        },
      });

      logger.info(
        '[ChatService] Location sent to conversation $conversationId',
      );
    } on AuthException {
      rethrow;
    } on ServerException {
      rethrow;
    } on PostgrestException catch (e, stackTrace) {
      logger.error(
        '[ChatService] Database error in sendLocationMessage: ${e.message}',
        e,
        stackTrace,
      );
      if (e.code == '42501' || e.message.toLowerCase().contains('policy')) {
        throw const ServerException(
          'You do not have permission to send messages to this conversation',
          '403',
        );
      }
      throw ServerException('Failed to send location: ${e.message}', e.code);
    } catch (e, stackTrace) {
      logger.error(
        '[ChatService] Unexpected error in sendLocationMessage',
        e,
        stackTrace,
      );
      throw const ServerException('Failed to send location');
    }
  }

  /// Resolves GPS and sends a `location` message.
  Future<void> sendCurrentLocationMessage({
    required String conversationId,
    required String contentLine,
  }) async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      throw const ServerException(
        'Location services are disabled. Enable them in device settings.',
        'LOCATION_DISABLED',
      );
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw const ServerException(
        'Location permission is required to share your position.',
        'LOCATION_PERMISSION',
      );
    }
    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    await sendLocationMessage(
      conversationId: conversationId,
      latitude: pos.latitude,
      longitude: pos.longitude,
      accuracyMeters: pos.accuracy,
      contentLine: contentLine,
    );
  }

  Future<void> submitChatPollVote({
    required String messageId,
    required int optionIndex,
  }) async {
    final logger = getIt<Talker>();
    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw AuthException('User must be authenticated to vote');
      }
      final pollsEnabled = await _isFeatureFlagEnabled('chat_polls_enabled');
      if (!pollsEnabled) {
        throw const ServerException(
          'Polls are not available right now.',
          'FEATURE_DISABLED',
        );
      }
      await _supabase.rpc(
        'submit_chat_poll_vote',
        params: {'p_message_id': messageId, 'p_option_index': optionIndex},
      );
    } on AuthException {
      rethrow;
    } on ServerException {
      rethrow;
    } on PostgrestException catch (e, stackTrace) {
      logger.error(
        '[ChatService] submitChatPollVote failed: ${e.message}',
        e,
        stackTrace,
      );
      throw ServerException(
        e.message.isNotEmpty ? e.message : 'Could not submit vote',
        e.code,
      );
    } catch (e, stackTrace) {
      logger.error(
        '[ChatService] Unexpected error in submitChatPollVote',
        e,
        stackTrace,
      );
      throw const ServerException('Could not submit vote');
    }
  }

  Future<List<ChatPollSummary>> getChatPollSummaries(
    List<String> messageIds,
  ) async {
    if (messageIds.isEmpty) return [];
    final logger = getIt<Talker>();
    try {
      final raw = await _supabase.rpc(
        'get_chat_poll_summaries',
        params: {'p_message_ids': messageIds},
      );
      if (raw == null) return [];
      final list = raw as List;
      return list
          .map(
            (row) =>
                ChatPollSummary.fromJson(Map<String, dynamic>.from(row as Map)),
          )
          .toList();
    } catch (e, stackTrace) {
      logger.warning('[ChatService] getChatPollSummaries: $e', e, stackTrace);
      return [];
    }
  }

  /// Soft-deletes one or more messages for everyone.
  ///
  /// [messageIds] - List of message IDs to delete
  ///
  /// Sets is_deleted_for_everyone = true on each message.
  /// Only the sender of the message can delete it.
  ///
  /// Throws [AuthException] if user is not authenticated.
  /// Throws [ServerException] on database errors.
  Future<void> deleteMessages(List<String> messageIds) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        logger.warning(
          '[ChatService] Unauthenticated user attempted to delete messages',
        );
        throw AuthException('User must be authenticated to delete messages');
      }

      if (messageIds.isEmpty) {
        logger.warning('[ChatService] Empty message IDs list provided');
        return;
      }

      logger.info(
        '[ChatService] Soft-deleting ${messageIds.length} messages for user: $currentUserId',
      );

      // Soft-delete: set is_deleted_for_everyone = true for messages owned by this user.
      // The realtime UPDATE event will fire and all connected clients will remove
      // the message from their UI automatically.
      await _supabase
          .from('chat_messages')
          .update({'is_deleted_for_everyone': true})
          .inFilter('id', messageIds)
          .eq('sender_id', currentUserId);

      logger.info(
        '[ChatService] Successfully soft-deleted ${messageIds.length} messages',
      );
    } on AuthException {
      rethrow;
    } on PostgrestException catch (e, stackTrace) {
      logger.error(
        '[ChatService] Database error deleting messages: ${e.message}',
        e,
        stackTrace,
      );
      throw ServerException('Failed to delete messages: ${e.message}', e.code);
    } catch (e, stackTrace) {
      logger.error(
        '[ChatService] Unexpected error deleting messages',
        e,
        stackTrace,
      );
      throw const ServerException('Failed to delete messages');
    }
  }

  /// Hides one or more messages for current user only.
  /// This powers persisted "Delete for me" behavior.
  Future<void> hideMessagesForCurrentUser({
    required String conversationId,
    required List<String> messageIds,
  }) async {
    final logger = getIt<Talker>();
    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw AuthException('User must be authenticated to hide messages');
      }
      if (messageIds.isEmpty) return;

      final rows = messageIds
          .map(
            (messageId) => {
              'user_id': currentUserId,
              'message_id': messageId,
              'conversation_id': conversationId,
            },
          )
          .toList();

      await _supabase.from('user_hidden_messages').upsert(rows);
      logger.info(
        '[ChatService] Hidden ${messageIds.length} message(s) for user: $currentUserId',
      );
    } on AuthException {
      rethrow;
    } on PostgrestException catch (e, stackTrace) {
      logger.error(
        '[ChatService] Database error hiding messages: ${e.message}',
        e,
        stackTrace,
      );
      throw ServerException('Failed to hide messages: ${e.message}', e.code);
    } catch (e, stackTrace) {
      logger.error(
        '[ChatService] Unexpected error hiding messages',
        e,
        stackTrace,
      );
      throw const ServerException('Failed to hide messages');
    }
  }

  /// Subscribes to realtime message insertions for a conversation.
  ///
  /// [conversationId] - The ID of the conversation to listen to.
  ///
  /// Returns a stream of ChatMessage objects as new messages are inserted.
  /// Only emits INSERT events - does not fetch existing messages.
  ///
  /// RLS policies ensure users only receive messages from conversations
  /// they are members of. If the user is not a member, no messages will
  /// be received through the subscription.
  ///
  /// **Optimistic UI support**: Messages sent by the current user are filtered
  /// out from the realtime stream, assuming they are already optimistically
  /// displayed in the UI. This prevents duplicate messages from appearing.
  ///
  /// **Important**: Always cancel the subscription when done (e.g., when
  /// the chat screen is disposed) to prevent memory leaks. Each call to
  /// this method creates a new independent subscription.
  ///
  /// If the same conversation is opened multiple times, each will have
  /// its own channel subscription. Proper disposal ensures no duplicate
  /// listeners remain active.
  ///
  /// Channel is scoped to the conversation ID with a timestamp to ensure
  /// uniqueness and prevent collisions.
  ///
  /// Example usage:
  /// ```dart
  /// final subscription = chatService.subscribeToMessages(conversationId).listen(
  ///   (message) => print(message),
  /// );
  /// // Later, in dispose():
  /// subscription.cancel();
  /// ```
  Stream<ChatRealtimeEvent> subscribeToMessages(String conversationId) {
    final logger = getIt<Talker>();
    late StreamController<ChatRealtimeEvent> controller;
    RealtimeChannel? channel;
    bool isSubscribed = false;

    // Get current user ID for filtering own messages
    final currentUserId = _supabase.auth.currentUser?.id;

    // Create unique channel name to prevent collisions on multiple subscriptions
    final channelName =
        'chat_messages:$conversationId:${DateTime.now().millisecondsSinceEpoch}';

    logger.debug(
      '[ChatService] Setting up realtime subscription for conversation: $conversationId (channel: $channelName)',
    );

    controller = StreamController<ChatRealtimeEvent>(
      onListen: () async {
        if (isSubscribed) {
          logger.warning(
            '[ChatService] Attempted to subscribe to already active channel: $channelName',
          );
          return;
        }

        // For blocked 1:1 DMs, do not deliver realtime messages at all.
        try {
          final isBlockedDm = await _isBlockedDMConversationForCurrentUser(
            conversationId,
          );
          if (isBlockedDm) {
            logger.info(
              '[ChatService] Blocked DM conversation, not subscribing to realtime messages for conversation: $conversationId',
            );
            // Leave stream open but never emit any events.
            return;
          }
        } catch (e, stackTrace) {
          logger.error(
            '[ChatService] Error checking block status before subscribing to messages',
            e,
            stackTrace,
          );
          // On error, continue and attempt to subscribe rather than breaking chat.
        }

        logger.info(
          '[ChatService] Subscribing to realtime messages: $channelName (user: $currentUserId)',
        );
        isSubscribed = true;

        // Create and subscribe to realtime channel scoped to this conversation
        try {
          channel = _supabase
              .channel(channelName)
              .onPostgresChanges(
                event: PostgresChangeEvent.insert,
                schema: 'public',
                table: 'chat_messages',
                filter: PostgresChangeFilter(
                  type: PostgresChangeFilterType.eq,
                  column: 'conversation_id',
                  value: conversationId,
                ),
                callback: (payload) async {
                  if (!controller.isClosed) {
                    try {
                      // Validate payload structure
                      if (payload.newRecord.isEmpty) {
                        logger.debug(
                          '[ChatService] Received empty payload, ignoring',
                        );
                        return;
                      }

                      final record = Map<String, dynamic>.from(
                        payload.newRecord,
                      );

                      // Validate required fields exist
                      if (!record.containsKey('id') ||
                          !record.containsKey('sender_id') ||
                          !record.containsKey('content')) {
                        logger.warning(
                          '[ChatService] Malformed payload missing required fields: ${record.keys.join(', ')}',
                        );
                        return;
                      }

                      // Fetch sender profile for group chat display
                      try {
                        final senderId = record['sender_id'] as String;
                        final profileRes = await _supabase
                            .from('profiles')
                            .select('full_name, username, avatar_url')
                            .eq('id', senderId)
                            .maybeSingle();
                        if (profileRes != null) {
                          record['sender_name'] =
                              profileRes['full_name'] ??
                              profileRes['username'] ??
                              'User';
                          record['sender_avatar_url'] =
                              profileRes['avatar_url'];
                        }
                      } catch (e) {
                        logger.warning(
                          '[ChatService] Failed to fetch sender profile: $e',
                        );
                      }

                      final message = ChatMessage.fromJson(record);

                      // Filter out messages from current user (optimistic UI assumption)
                      // The UI should already show messages sent by the current user
                      if (currentUserId != null &&
                          message.senderId == currentUserId) {
                        logger.debug(
                          '[ChatService] Ignoring own message (optimistically added): ${message.id}',
                        );
                        return;
                      }

                      logger.debug(
                        '[ChatService] Emitting realtime message: ${message.id} from ${message.senderId}',
                      );
                      controller.add(ChatRealtimeEvent.insert(message));
                    } on FormatException catch (e) {
                      logger.warning(
                        '[ChatService] Invalid data format in payload: $e',
                      );
                    } on TypeError catch (e) {
                      logger.warning(
                        '[ChatService] Type mismatch in payload: $e',
                      );
                    } catch (e) {
                      logger.warning(
                        '[ChatService] Failed to process realtime message: $e',
                      );
                    }
                  }
                },
              )
              .onPostgresChanges(
                event: PostgresChangeEvent.update,
                schema: 'public',
                table: 'chat_messages',
                filter: PostgresChangeFilter(
                  type: PostgresChangeFilterType.eq,
                  column: 'conversation_id',
                  value: conversationId,
                ),
                callback: (payload) {
                  if (controller.isClosed) return;
                  final newRecord = Map<String, dynamic>.from(
                    payload.newRecord,
                  );
                  // Emit a delete event when a message is soft-deleted for everyone
                  final deletedForEveryone =
                      newRecord['is_deleted_for_everyone'] as bool? ?? false;
                  if (deletedForEveryone) {
                    final msgId = newRecord['id'] as String?;
                    if (msgId != null && msgId.isNotEmpty) {
                      logger.debug(
                        '[ChatService] Message soft-deleted for everyone (realtime): $msgId',
                      );
                      controller.add(ChatRealtimeEvent.delete(msgId));
                    }
                  }
                },
              )
              .onPostgresChanges(
                event: PostgresChangeEvent.delete,
                schema: 'public',
                table: 'chat_messages',
                filter: PostgresChangeFilter(
                  type: PostgresChangeFilterType.eq,
                  column: 'conversation_id',
                  value: conversationId,
                ),
                callback: (payload) {
                  if (controller.isClosed) return;
                  final oldRecord = Map<String, dynamic>.from(
                    payload.oldRecord,
                  );
                  final deletedId = oldRecord['id'] as String?;
                  if (deletedId == null || deletedId.isEmpty) return;
                  logger.debug(
                    '[ChatService] Emitting realtime delete for message: $deletedId',
                  );
                  controller.add(ChatRealtimeEvent.delete(deletedId));
                },
              )
              .subscribe();

          logger.info(
            '[ChatService] Successfully subscribed to channel: $channelName',
          );
        } catch (e, stackTrace) {
          logger.error(
            '[ChatService] Failed to setup realtime subscription: $channelName',
            e,
            stackTrace,
          );
          isSubscribed = false;
          if (!controller.isClosed) {
            controller.addError(e);
          }
        }
      },
      onCancel: () async {
        if (!isSubscribed) {
          logger.debug(
            '[ChatService] Channel already unsubscribed: $channelName',
          );
          return;
        }

        logger.info(
          '[ChatService] Unsubscribing from realtime messages: $channelName',
        );

        try {
          // Properly unsubscribe and remove channel to prevent memory leaks
          if (channel != null) {
            await channel!.unsubscribe();
            logger.debug('[ChatService] Channel unsubscribed: $channelName');

            await _supabase.removeChannel(channel!);
            logger.debug(
              '[ChatService] Channel removed from client: $channelName',
            );
          }
          logger.info(
            '[ChatService] Successfully cleaned up subscription: $channelName',
          );
        } catch (e, stackTrace) {
          logger.error(
            '[ChatService] Error during channel cleanup: $channelName',
            e,
            stackTrace,
          );
        } finally {
          isSubscribed = false;
          channel = null;
        }
      },
    );

    return controller.stream;
  }

  /// Realtime updates when anyone votes on a poll in this conversation.
  Stream<ChatRealtimePollVoteEvent> subscribeToChatPollVotes(
    String conversationId,
  ) {
    final logger = getIt<Talker>();
    late StreamController<ChatRealtimePollVoteEvent> controller;
    RealtimeChannel? channel;
    bool isSubscribed = false;

    final channelName =
        'chat_poll_votes:$conversationId:${DateTime.now().millisecondsSinceEpoch}';

    controller = StreamController<ChatRealtimePollVoteEvent>(
      onListen: () {
        if (isSubscribed) return;
        isSubscribed = true;
        try {
          channel = _supabase
              .channel(channelName)
              .onPostgresChanges(
                event: PostgresChangeEvent.insert,
                schema: 'public',
                table: 'chat_message_poll_votes',
                filter: PostgresChangeFilter(
                  type: PostgresChangeFilterType.eq,
                  column: 'conversation_id',
                  value: conversationId,
                ),
                callback: (payload) {
                  if (controller.isClosed) return;
                  final record = Map<String, dynamic>.from(payload.newRecord);
                  final messageId = record['message_id'] as String?;
                  if (messageId == null || messageId.isEmpty) return;
                  controller.add(
                    ChatRealtimePollVoteEvent(messageId: messageId),
                  );
                },
              )
              .onPostgresChanges(
                event: PostgresChangeEvent.update,
                schema: 'public',
                table: 'chat_message_poll_votes',
                filter: PostgresChangeFilter(
                  type: PostgresChangeFilterType.eq,
                  column: 'conversation_id',
                  value: conversationId,
                ),
                callback: (payload) {
                  if (controller.isClosed) return;
                  final record = Map<String, dynamic>.from(payload.newRecord);
                  final messageId = record['message_id'] as String?;
                  if (messageId == null || messageId.isEmpty) return;
                  controller.add(
                    ChatRealtimePollVoteEvent(messageId: messageId),
                  );
                },
              )
              .subscribe();
        } catch (e, stackTrace) {
          logger.error(
            '[ChatService] Failed to setup poll vote subscription: $channelName',
            e,
            stackTrace,
          );
          isSubscribed = false;
          if (!controller.isClosed) {
            controller.addError(e);
          }
        }
      },
      onCancel: () async {
        if (!isSubscribed) return;
        try {
          if (channel != null) {
            await channel!.unsubscribe();
            await _supabase.removeChannel(channel!);
          }
        } catch (e, stackTrace) {
          logger.error(
            '[ChatService] Error cleaning up poll vote subscription',
            e,
            stackTrace,
          );
        } finally {
          isSubscribed = false;
          channel = null;
        }
      },
    );

    return controller.stream;
  }

  /// Soft deletes a conversation for the current user.
  ///
  /// Sets deleted_at timestamp in conversation_members.
  /// Messages sent after this timestamp will still be visible.
  ///
  /// [conversationId] - The ID of the conversation to delete.
  ///
  /// Throws [AuthException] if user is not authenticated.
  /// Throws [ServerException] on database errors.
  Future<void> deleteConversation(String conversationId) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        logger.warning(
          '[ChatService] Unauthenticated user attempted to delete conversation',
        );
        throw AuthException(
          'User must be authenticated to delete conversation',
        );
      }

      logger.debug(
        '[ChatService] Soft deleting conversation: $conversationId for user: $currentUserId',
      );

      await _supabase
          .from('conversation_members')
          .update({'deleted_at': DateTime.now().toUtc().toIso8601String()})
          .eq('conversation_id', conversationId)
          .eq('user_id', currentUserId);

      logger.info(
        '[ChatService] Successfully soft deleted conversation: $conversationId',
      );
    } on AuthException {
      rethrow;
    } on PostgrestException catch (e, stackTrace) {
      logger.error(
        '[ChatService] Database error deleting conversation: ${e.message}',
        e,
        stackTrace,
      );
      throw ServerException(
        'Failed to delete conversation: ${e.message}',
        e.code,
      );
    } catch (e, stackTrace) {
      logger.error(
        '[ChatService] Unexpected error deleting conversation',
        e,
        stackTrace,
      );
      throw const ServerException('Failed to delete conversation');
    }
  }

  /// Leaves a group conversation and writes a system tag message.
  Future<void> leaveGroupConversation(String conversationId) async {
    final logger = getIt<Talker>();
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      throw AuthException('User must be authenticated');
    }

    try {
      final member = await _supabase
          .from('conversation_members')
          .select('user_id')
          .eq('conversation_id', conversationId)
          .eq('user_id', currentUserId)
          .maybeSingle();
      if (member == null) {
        throw const ServerException(
          'You are not a member of this group',
          '403',
        );
      }

      final displayName = await _resolveDisplayName(currentUserId);

      // Insert before membership deletion so the current user still has
      // permission to write this final system message.
      await _publishGroupMembershipEvent(
        conversationId: conversationId,
        actorUserId: currentUserId,
        type: GroupSystemMessageFormatter.typeLeft,
        text: '$displayName left the group',
      );

      await _supabase
          .from('conversation_members')
          .delete()
          .eq('conversation_id', conversationId)
          .eq('user_id', currentUserId);
    } on AuthException {
      rethrow;
    } on ServerException {
      rethrow;
    } on PostgrestException catch (e, stackTrace) {
      logger.error(
        '[ChatService] Failed to leave group: ${e.message}',
        e,
        stackTrace,
      );
      throw ServerException('Failed to leave group: ${e.message}', e.code);
    } catch (e, stackTrace) {
      logger.error('[ChatService] Failed to leave group', e, stackTrace);
      throw const ServerException('Failed to leave group');
    }
  }

  /// Removes a member from a group conversation and writes a system tag.
  Future<void> removeGroupMember({
    required String conversationId,
    required String memberUserId,
  }) async {
    final logger = getIt<Talker>();
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      throw AuthException('User must be authenticated');
    }
    if (memberUserId == currentUserId) {
      throw const ServerException(
        'Use leaveGroupConversation for self-removal',
        '400',
      );
    }

    try {
      final actorMembership = await _supabase
          .from('conversation_members')
          .select('role')
          .eq('conversation_id', conversationId)
          .eq('user_id', currentUserId)
          .maybeSingle();

      if (actorMembership == null) {
        throw const ServerException(
          'You are not a member of this group',
          '403',
        );
      }

      final actorRole = (actorMembership['role'] as String? ?? 'member')
          .toLowerCase();
      final canRemove = actorRole == 'owner' || actorRole == 'admin';
      if (!canRemove) {
        throw const ServerException(
          'Only owner/admin can remove members',
          '403',
        );
      }

      final targetMembership = await _supabase
          .from('conversation_members')
          .select('user_id')
          .eq('conversation_id', conversationId)
          .eq('user_id', memberUserId)
          .maybeSingle();

      if (targetMembership == null) return;

      final removedDisplayName = await _resolveDisplayName(memberUserId);

      await _supabase
          .from('conversation_members')
          .delete()
          .eq('conversation_id', conversationId)
          .eq('user_id', memberUserId);

      await _publishGroupMembershipEvent(
        conversationId: conversationId,
        actorUserId: currentUserId,
        type: GroupSystemMessageFormatter.typeRemoved,
        text: '$removedDisplayName was removed',
      );
    } on AuthException {
      rethrow;
    } on ServerException {
      rethrow;
    } on PostgrestException catch (e, stackTrace) {
      logger.error(
        '[ChatService] Failed to remove group member: ${e.message}',
        e,
        stackTrace,
      );
      throw ServerException('Failed to remove member: ${e.message}', e.code);
    } catch (e, stackTrace) {
      logger.error(
        '[ChatService] Failed to remove group member',
        e,
        stackTrace,
      );
      throw const ServerException('Failed to remove member');
    }
  }

  // -------------------------------------------------------------------------
  // Message requests (DM consent flow)
  // -------------------------------------------------------------------------

  /// Sends a message request to [recipientId]. Recipient must accept before a DM exists.
  ///
  /// Returns a DM conversation ID when direct chat is already allowed
  /// (existing DM or users are mutual followers), otherwise returns null after
  /// creating or reusing a pending request.
  /// Throws [AuthException] if not authenticated; throws if recipient has blocked current user.
  Future<String?> sendMessageRequest(String recipientId) async {
    final logger = getIt<Talker>();
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      throw AuthException('User must be authenticated to send message request');
    }
    if (currentUserId == recipientId) {
      throw AuthException('Cannot send message request to yourself');
    }

    final directDmId = await getOrCreateDirectDMIfAllowed(recipientId);
    if (directDmId != null) {
      logger.info(
        '[ChatService] Direct DM available for $currentUserId <-> $recipientId, skipping request',
      );
      return directDmId;
    }

    final existing = await _supabase
        .from('message_requests')
        .select('id')
        .eq('sender_id', currentUserId)
        .eq('recipient_id', recipientId)
        .eq('status', 'pending')
        .maybeSingle();
    if (existing != null) return null;
    final inserted = await _supabase
        .from('message_requests')
        .insert({
          'sender_id': currentUserId,
          'recipient_id': recipientId,
          'status': 'pending',
        })
        .select('id')
        .single();

    final requestId = inserted['id'] as String;

    // Create in-app + push notification for recipient.
    try {
      await _supabase.from('notifications').insert({
        'recipient_id': recipientId,
        'actor_id': currentUserId,
        'notification_type': 'message_request',
        'title': 'New message request',
        'body': 'Someone wants to chat with you.',
        'entity_type': 'message_request',
        'entity_id': requestId,
      });
    } catch (e) {
      logger.debug(
        '[ChatService] Failed to create notification for message request: $e',
      );
    }

    logger.info('[ChatService] Message request sent to $recipientId');
    return null;
  }

  /// Pending message requests where current user is the recipient. Includes sender profile info.
  Future<List<Map<String, dynamic>>>
  getPendingMessageRequestsForCurrentUser() async {
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      throw AuthException('User must be authenticated');
    }
    final response = await _supabase
        .from('message_requests')
        .select('id, sender_id, recipient_id, status, created_at')
        .eq('recipient_id', currentUserId)
        .eq('status', 'pending')
        .order('created_at', ascending: false);
    final list = response as List;
    final profiles = getIt<ProfileService>();
    final out = <Map<String, dynamic>>[];
    for (final row in list) {
      final senderId = row['sender_id'] as String;
      Map<String, dynamic>? profile;
      try {
        profile = await profiles.getProfileById(senderId);
      } catch (_) {}
      out.add({
        'id': row['id'],
        'sender_id': senderId,
        'created_at': row['created_at'],
        'sender_name':
            profile?['full_name'] ?? profile?['username'] ?? 'Unknown',
        'sender_avatar_url': profile?['avatar_url'],
      });
    }
    return out;
  }

  /// Accepts a message request: creates DM and adds both members, returns conversationId.
  Future<String> acceptMessageRequest(String requestId) async {
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      throw AuthException('User must be authenticated');
    }
    final row = await _supabase
        .from('message_requests')
        .select('id, sender_id, recipient_id, status')
        .eq('id', requestId)
        .eq('recipient_id', currentUserId)
        .maybeSingle();
    if (row == null) throw ServerException('Request not found', 'NOT_FOUND');
    if (row['status'] != 'pending') {
      final existingId = await _findExistingDM(
        row['sender_id'] as String,
        currentUserId,
      );
      if (existingId != null) return existingId;
      throw ServerException('Request already handled', 'ALREADY_HANDLED');
    }
    final senderId = row['sender_id'] as String;
    await _supabase
        .from('message_requests')
        .update({'status': 'accepted'})
        .eq('id', requestId);
    return getOrCreateDM(senderId);
  }

  /// Rejects (deletes) a message request so sender can resend later.
  Future<void> rejectMessageRequest(String requestId) async {
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      throw AuthException('User must be authenticated');
    }
    await _supabase
        .from('message_requests')
        .update({'status': 'rejected'})
        .eq('id', requestId)
        .eq('recipient_id', currentUserId);
  }

  /// Returns pending message request from current user to [recipientId], if any.
  Future<Map<String, dynamic>?> getSentMessageRequest(
    String recipientId,
  ) async {
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) return null;
    final row = await _supabase
        .from('message_requests')
        .select('id, created_at')
        .eq('sender_id', currentUserId)
        .eq('recipient_id', recipientId)
        .eq('status', 'pending')
        .maybeSingle();
    return row != null ? Map<String, dynamic>.from(row) : null;
  }

  /// Pending message request from [senderId] to current user (for "them to me" check).
  Future<Map<String, dynamic>?> getIncomingMessageRequest(
    String senderId,
  ) async {
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) return null;
    final row = await _supabase
        .from('message_requests')
        .select('id, created_at')
        .eq('sender_id', senderId)
        .eq('recipient_id', currentUserId)
        .eq('status', 'pending')
        .maybeSingle();
    return row != null ? Map<String, dynamic>.from(row) : null;
  }

  /// Outgoing message requests sent by the current user (all statuses).
  ///
  /// Each map contains:
  /// - id
  /// - recipient_id
  /// - recipient_name
  /// - recipient_avatar_url
  /// - status
  /// - created_at
  /// - expires_at
  Future<List<Map<String, dynamic>>>
  getOutgoingMessageRequestsForCurrentUser() async {
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      throw AuthException('User must be authenticated');
    }

    final response = await _supabase
        .from('message_requests')
        .select('id, sender_id, recipient_id, status, created_at, expires_at')
        .eq('sender_id', currentUserId)
        .order('created_at', ascending: false);

    final rows = response as List;
    if (rows.isEmpty) return [];

    final profiles = getIt<ProfileService>();
    final out = <Map<String, dynamic>>[];

    for (final row in rows) {
      final recipientId = row['recipient_id'] as String;
      Map<String, dynamic>? profile;
      try {
        profile = await profiles.getProfileById(recipientId);
      } catch (_) {}

      out.add({
        'id': row['id'],
        'recipient_id': recipientId,
        'status': row['status'],
        'created_at': row['created_at'],
        'expires_at': row['expires_at'],
        'recipient_name':
            profile?['full_name'] ?? profile?['username'] ?? 'Unknown',
        'recipient_avatar_url': profile?['avatar_url'],
      });
    }

    return out;
  }

  /// Revokes a pending message request sent by the current user.
  Future<void> revokeMessageRequest(String requestId) async {
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      throw AuthException('User must be authenticated');
    }

    await _supabase
        .from('message_requests')
        .update({'status': 'revoked'})
        .eq('id', requestId)
        .eq('sender_id', currentUserId)
        .eq('status', 'pending');
  }

  /// Permanently deletes a message request row created by the current user.
  ///
  /// Intended for cleaning up expired/revoked requests from the sender's view.
  Future<void> deleteMessageRequest(String requestId) async {
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      throw AuthException('User must be authenticated');
    }

    await _supabase
        .from('message_requests')
        .delete()
        .eq('id', requestId)
        .eq('sender_id', currentUserId);
  }

  /// Count of pending message + group requests for current user (for badge).
  Future<int> getPendingRequestsCount() async {
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) return 0;
    final msg = await _supabase
        .from('message_requests')
        .select('id')
        .eq('recipient_id', currentUserId)
        .eq('status', 'pending');
    final grp = await _supabase
        .from('group_invite_requests')
        .select('id')
        .eq('invitee_id', currentUserId)
        .eq('status', 'pending');
    return (msg as List).length + (grp as List).length;
  }

  // -------------------------------------------------------------------------
  // Group invite requests
  // -------------------------------------------------------------------------

  /// Creates or rotates a single active invite link for a group.
  Future<Map<String, dynamic>> generateGroupInviteLink(
    String conversationId,
  ) async {
    final logger = getIt<Talker>();
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      throw AuthException('User must be authenticated to generate invite link');
    }

    final membership = await _supabase
        .from('conversation_members')
        .select('role')
        .eq('conversation_id', conversationId)
        .eq('user_id', currentUserId)
        .maybeSingle();

    if (membership == null) {
      throw const ServerException('You are not a member of this group', 'NOT_MEMBER');
    }

    final role = (membership['role'] as String?) ?? 'member';
    if (role != 'owner' && role != 'admin') {
      throw const ServerException(
        'Only group owner or admins can generate invite links',
        'FORBIDDEN',
      );
    }

    Future<void> revokeActiveLinks() async {
      await _supabase
        .from('group_invite_links')
        .update({'revoked_at': DateTime.now().toUtc().toIso8601String()})
        .eq('conversation_id', conversationId)
        .isFilter('revoked_at', null);
    }

    await revokeActiveLinks();

    String? code;
    String? expiresAt;

    for (var i = 0; i < 5; i++) {
      final candidate = const Uuid().v4().replaceAll('-', '').substring(0, 10).toUpperCase();
      try {
        final inserted = await _supabase
            .from('group_invite_links')
            .insert({
              'conversation_id': conversationId,
              'invite_code': candidate,
              'created_by': currentUserId,
              'expires_at': DateTime.now()
                  .toUtc()
                  .add(const Duration(days: 30))
                  .toIso8601String(),
            })
            .select('invite_code, expires_at')
            .single();
        code = inserted['invite_code'] as String?;
        expiresAt = inserted['expires_at'] as String?;
        break;
      } on PostgrestException catch (e) {
        if (e.code == '23505') {
          // Handle both invite_code and single-active-link unique conflicts.
          await revokeActiveLinks();
          continue;
        }
        rethrow;
      }
    }

    if (code == null || expiresAt == null) {
      throw const ServerException('Failed to generate invite link', 'INVITE_CODE_FAILED');
    }

    final conversation = await _supabase
        .from('conversations')
        .select('group_name, group_avatar_url')
        .eq('id', conversationId)
        .maybeSingle();

    final link = 'https://myitihas.com/group/$code';
    logger.info(
      '[ChatService] Generated group invite link for $conversationId by $currentUserId',
    );

    return {
      'link': link,
      'invite_code': code,
      'expires_at': expiresAt,
      'group_name': conversation?['group_name'] ?? 'Group',
      'group_avatar_url': conversation?['group_avatar_url'],
    };
  }

  Future<GroupInviteLinkPreview?> getGroupInviteLinkPreview(
    String inviteCode,
  ) async {
    final response = await _supabase.rpc(
      'get_group_invite_link_preview',
      params: {'p_invite_code': inviteCode},
    );

    if (response == null) return null;

    final rows = response as List;
    if (rows.isEmpty) return null;

    final row = rows.first as Map<String, dynamic>;
    return GroupInviteLinkPreview(
      conversationId: row['conversation_id'] as String,
      groupName: (row['group_name'] as String?) ?? 'Group',
      groupAvatarUrl: row['group_avatar_url'] as String?,
      groupDescription: row['group_description'] as String?,
      memberCount: (row['member_count'] as num?)?.toInt() ?? 0,
      adminName: (row['admin_name'] as String?) ?? 'Group admin',
      expiresAt: DateTime.parse(row['expires_at'] as String),
      isMember: row['is_member'] as bool? ?? false,
    );
  }

  /// Joins current user into a group directly through invite code.
  /// Returns one of: joined, already_member.
  Future<String> joinGroupViaInviteLink(String inviteCode) async {
    final preview = await getGroupInviteLinkPreview(inviteCode);
    if (preview == null) {
      throw const ServerException('Invite link is invalid or expired', 'INVALID_INVITE');
    }

    final result = await _supabase.rpc(
      'join_group_via_invite_link',
      params: {'p_invite_code': inviteCode},
    );

    final status = (result as String?) ?? 'invalid_or_expired';
    if (status == 'joined') {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId != null) {
        final joinedDisplayName = await _resolveDisplayName(currentUserId);
        await _publishGroupMembershipEvent(
          conversationId: preview.conversationId,
          actorUserId: currentUserId,
          type: GroupSystemMessageFormatter.typeJoined,
          text: '$joinedDisplayName joined the group',
        );
      }
      return status;
    }

    if (status == 'already_member') {
      return status;
    }
    if (status == 'blocked') {
      throw AuthException('You cannot join this group due to privacy settings');
    }
    throw const ServerException('Invite link is invalid or expired', 'INVALID_INVITE');
  }

  /// Sends a group invite request. Invitee must accept before being added to conversation_members.
  Future<void> sendGroupInviteRequest(
    String conversationId,
    String inviteeId,
  ) async {
    final logger = getIt<Talker>();
    final blockService = getIt<UserBlockService>();
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      throw AuthException('User must be authenticated to send group invite');
    }
    if (currentUserId == inviteeId) return;

    // Do not allow inviting a user into a group when a block exists in either
    // direction between the inviter and invitee.
    final iBlockedInvitee = await blockService.isUserBlocked(inviteeId);
    if (iBlockedInvitee) {
      throw AuthException('You can\'t add this user to the group');
    }

    final blocked = await blockService.hasBlockedMe(inviteeId);
    if (blocked) {
      throw AuthException('You can\'t add this user to the group');
    }
    final memberRows = await _supabase
        .from('conversation_members')
        .select('user_id')
        .eq('conversation_id', conversationId)
        .eq('user_id', currentUserId);
    if ((memberRows as List).isEmpty) {
      throw ServerException('You are not a member of this group', 'NOT_MEMBER');
    }
    final existingMember = await _supabase
        .from('conversation_members')
        .select('user_id')
        .eq('conversation_id', conversationId)
        .eq('user_id', inviteeId)
        .maybeSingle();
    if (existingMember != null) return;
    final existingInvite = await _supabase
        .from('group_invite_requests')
        .select('id')
        .eq('conversation_id', conversationId)
        .eq('invitee_id', inviteeId)
        .eq('status', 'pending')
        .maybeSingle();
    if (existingInvite != null) return;
    final now = DateTime.now().toUtc();
    final inserted = await _supabase
        .from('group_invite_requests')
        .insert({
          'conversation_id': conversationId,
          'inviter_id': currentUserId,
          'invitee_id': inviteeId,
          'status': 'pending',
          // Keep TTL aligned with the SQL migration (48 hours from creation).
          'expires_at': now.add(const Duration(hours: 48)).toIso8601String(),
        })
        .select('id')
        .single();

    final inviteId = inserted['id'] as String;

    // Fetch group name for notification context.
    String groupName = 'Group';
    try {
      final conv = await _supabase
          .from('conversations')
          .select('group_name')
          .eq('id', conversationId)
          .maybeSingle();
      if (conv != null && (conv['group_name'] as String?)?.isNotEmpty == true) {
        groupName = conv['group_name'] as String;
      }
    } catch (_) {}

    // Create in-app + push notification for invitee.
    try {
      await _supabase.from('notifications').insert({
        'recipient_id': inviteeId,
        'actor_id': currentUserId,
        'notification_type': 'group_invite',
        'title': 'Group invitation',
        'body': 'You have been invited to join $groupName.',
        'entity_type': 'group_invite',
        'entity_id': inviteId,
      });
    } catch (e) {
      logger.debug(
        '[ChatService] Failed to create notification for group invite: $e',
      );
    }

    logger.info(
      '[ChatService] Group invite sent to $inviteeId for conversation $conversationId',
    );
  }

  /// Pending group invite requests for current user. Includes conversation and inviter info.
  Future<List<Map<String, dynamic>>>
  getPendingGroupInviteRequestsForCurrentUser() async {
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      throw AuthException('User must be authenticated');
    }
    final response = await _supabase
        .from('group_invite_requests')
        .select('id, conversation_id, inviter_id, created_at')
        .eq('invitee_id', currentUserId)
        .eq('status', 'pending')
        .order('created_at', ascending: false);
    final list = response as List;
    final profiles = getIt<ProfileService>();
    final out = <Map<String, dynamic>>[];
    for (final row in list) {
      final convId = row['conversation_id'] as String;
      final inviterId = row['inviter_id'] as String;
      Map<String, dynamic>? conv;
      Map<String, dynamic>? inviterProfile;
      try {
        conv = await _supabase
            .from('conversations')
            .select('group_name, group_avatar_url')
            .eq('id', convId)
            .maybeSingle();
      } catch (_) {}
      try {
        inviterProfile = await profiles.getProfileById(inviterId);
      } catch (_) {}
      out.add({
        'id': row['id'],
        'conversation_id': convId,
        'inviter_id': inviterId,
        'created_at': row['created_at'],
        'group_name': conv?['group_name'] ?? 'Group',
        'group_avatar_url': conv?['group_avatar_url'],
        'inviter_name':
            inviterProfile?['full_name'] ??
            inviterProfile?['username'] ??
            'Someone',
      });
    }
    return out;
  }

  /// All group invite requests for a conversation, for owners/admins to manage.
  ///
  /// Returns a list of maps with:
  /// - id
  /// - conversation_id
  /// - inviter_id
  /// - invitee_id
  /// - invitee_name
  /// - invitee_avatar_url
  /// - status
  /// - created_at
  /// - expires_at
  Future<List<Map<String, dynamic>>> getGroupInvitesForConversation(
    String conversationId,
  ) async {
    final logger = getIt<Talker>();
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      throw AuthException('User must be authenticated');
    }

    try {
      // Ensure current user is a member and has owner/admin privileges.
      final membership = await _supabase
          .from('conversation_members')
          .select('role')
          .eq('conversation_id', conversationId)
          .eq('user_id', currentUserId)
          .maybeSingle();

      if (membership == null) {
        throw const ServerException(
          'You are not a member of this group',
          'NOT_MEMBER',
        );
      }

      final role = (membership['role'] as String?) ?? 'member';
      if (role != 'owner' && role != 'admin') {
        throw const ServerException(
          'Only group owner or admins can manage invitations',
          'FORBIDDEN',
        );
      }

      // Only load invites that are still pending. Older accepted/rejected/
      // revoked/expired invites are not relevant for the "Pending invitations"
      // section in the Group Info screen.
      final response = await _supabase
          .from('group_invite_requests')
          .select(
            'id, conversation_id, inviter_id, invitee_id, status, created_at, expires_at',
          )
          .eq('conversation_id', conversationId)
          .eq('status', 'pending')
          .order('created_at', ascending: false);

      final rows = response as List;
      if (rows.isEmpty) return [];

      final profiles = getIt<ProfileService>();
      final out = <Map<String, dynamic>>[];

      for (final row in rows) {
        final inviteeId = row['invitee_id'] as String;
        Map<String, dynamic>? inviteeProfile;
        try {
          inviteeProfile = await profiles.getProfileById(inviteeId);
        } catch (e) {
          logger.debug(
            '[ChatService] Failed to load profile for invitee $inviteeId: $e',
          );
        }

        out.add({
          'id': row['id'],
          'conversation_id': row['conversation_id'],
          'inviter_id': row['inviter_id'],
          'invitee_id': inviteeId,
          'status': row['status'],
          'created_at': row['created_at'],
          'expires_at': row['expires_at'],
          'invitee_name':
              inviteeProfile?['full_name'] ??
              inviteeProfile?['username'] ??
              'Unknown',
          'invitee_avatar_url': inviteeProfile?['avatar_url'],
        });
      }

      return out;
    } on AuthException {
      rethrow;
    } on ServerException {
      rethrow;
    } on PostgrestException catch (e, stackTrace) {
      logger.error(
        '[ChatService] Database error in getGroupInvitesForConversation: ${e.message}',
        e,
        stackTrace,
      );
      throw ServerException(
        'Failed to load group invitations: ${e.message}',
        e.code,
      );
    } catch (e, stackTrace) {
      logger.error(
        '[ChatService] Unexpected error in getGroupInvitesForConversation',
        e,
        stackTrace,
      );
      throw const ServerException('Failed to load group invitations');
    }
  }

  /// Revokes a pending group invite. Can be called by inviter or group owner/admin.
  Future<void> revokeGroupInvite(String inviteId) async {
    final logger = getIt<Talker>();
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      throw AuthException('User must be authenticated');
    }

    try {
      final row = await _supabase
          .from('group_invite_requests')
          .select('id, conversation_id, inviter_id, status')
          .eq('id', inviteId)
          .maybeSingle();

      if (row == null) {
        throw const ServerException('Invite not found', 'NOT_FOUND');
      }

      if (row['status'] != 'pending') {
        return;
      }

      // RLS already ensures that only inviter or owner/admin can update this row.
      await _supabase
          .from('group_invite_requests')
          .update({'status': 'revoked'})
          .eq('id', inviteId)
          .eq('status', 'pending');

      logger.info('[ChatService] Revoked group invite $inviteId');
    } on AuthException {
      rethrow;
    } on ServerException {
      rethrow;
    } on PostgrestException catch (e, stackTrace) {
      logger.error(
        '[ChatService] Database error in revokeGroupInvite: ${e.message}',
        e,
        stackTrace,
      );
      throw ServerException(
        'Failed to revoke invitation: ${e.message}',
        e.code,
      );
    } catch (e, stackTrace) {
      logger.error(
        '[ChatService] Unexpected error in revokeGroupInvite',
        e,
        stackTrace,
      );
      throw const ServerException('Failed to revoke invitation');
    }
  }

  /// Resends a group invite by creating a new pending invite for the same user.
  ///
  /// This uses the existing sendGroupInviteRequest logic, which will:
  /// - Ensure the current user is a member of the group
  /// - Ensure the invitee is not already a member
  /// - Ensure there is no existing pending invite
  Future<void> resendGroupInvite(
    String conversationId,
    String inviteeId,
  ) async {
    await sendGroupInviteRequest(conversationId, inviteeId);
  }

  /// Accepts a group invite: adds current user to conversation_members.
  Future<void> acceptGroupInviteRequest(String requestId) async {
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      throw AuthException('User must be authenticated');
    }
    final row = await _supabase
        .from('group_invite_requests')
        .select('id, conversation_id, status')
        .eq('id', requestId)
        .eq('invitee_id', currentUserId)
        .maybeSingle();
    if (row == null) throw ServerException('Request not found', 'NOT_FOUND');
    if (row['status'] != 'pending') return;
    final conversationId = row['conversation_id'] as String;
    await _supabase
        .from('group_invite_requests')
        .update({'status': 'accepted'})
        .eq('id', requestId);
    final existing = await _supabase
        .from('conversation_members')
        .select('user_id')
        .eq('conversation_id', conversationId)
        .eq('user_id', currentUserId)
        .maybeSingle();
    if (existing != null) return;
    final now = DateTime.now().toUtc().toIso8601String();
    await _supabase.from('conversation_members').insert({
      'conversation_id': conversationId,
      'user_id': currentUserId,
      'role': 'member',
      'joined_at': now,
    });

    final joinedDisplayName = await _resolveDisplayName(currentUserId);
    await _publishGroupMembershipEvent(
      conversationId: conversationId,
      actorUserId: currentUserId,
      type: GroupSystemMessageFormatter.typeJoined,
      text: '$joinedDisplayName joined the group',
    );
  }

  /// Rejects a group invite request.
  Future<void> rejectGroupInviteRequest(String requestId) async {
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      throw AuthException('User must be authenticated');
    }
    await _supabase
        .from('group_invite_requests')
        .update({'status': 'rejected'})
        .eq('id', requestId)
        .eq('invitee_id', currentUserId);
  }

  /// Fetches all Krishna chatbot conversations for the current user
  ///
  /// Returns list of conversations from chat_conversations table
  /// where app_section = 'krishna_chat'
  ///
  /// Throws [AuthException] if user is not authenticated.
  /// Throws [ServerException] on database errors.
  Future<List<Map<String, dynamic>>> fetchKrishnaConversations() async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        logger.warning(
          '[ChatService] Unauthenticated user attempted to fetch Krishna conversations',
        );
        throw AuthException('User must be authenticated');
      }

      logger.debug(
        '[ChatService] Fetching Krishna conversations for user: $currentUserId',
      );

      final response = await _supabase
          .from('chat_conversations')
          .select('id, title, messages, created_at, updated_at')
          .eq('user_id', currentUserId)
          .eq('app_section', 'krishna_chat')
          .order('updated_at', ascending: false);

      logger.info(
        '[ChatService] Fetched ${response.length} Krishna conversations',
      );
      return List<Map<String, dynamic>>.from(response);
    } catch (e, stackTrace) {
      logger.error(
        '[ChatService] Error fetching Krishna conversations',
        e,
        stackTrace,
      );

      if (e is SocketException) {
        throw NetworkException('Network error while fetching conversations');
      }

      throw const ServerException('Failed to fetch conversations');
    }
  }

  /// Saves or updates a Krishna chatbot conversation
  ///
  /// [conversationId] - Optional UUID, creates new if null
  /// [title] - Title/preview of the conversation
  /// [messages] - List of message maps with 'sender' and 'text'
  ///
  /// Returns the conversation ID (new or existing)
  ///
  /// Throws [AuthException] if user is not authenticated.
  /// Throws [ServerException] on database errors.
  Future<String> saveKrishnaConversation({
    String? conversationId,
    required String title,
    required List<Map<String, dynamic>> messages,
  }) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        logger.warning(
          '[ChatService] Unauthenticated user attempted to save Krishna conversation',
        );
        throw AuthException('User must be authenticated');
      }

      logger.debug(
        '[ChatService] Saving Krishna conversation. ID: $conversationId, Messages: ${messages.length}',
      );

      if (conversationId == null) {
        // Create new conversation
        final response = await _supabase
            .from('chat_conversations')
            .insert({
              'user_id': currentUserId,
              'title': title,
              'messages': messages,
              'app_section': 'krishna_chat',
            })
            .select('id')
            .single();

        final newId = response['id'] as String;
        logger.info('[ChatService] Created new Krishna conversation: $newId');
        return newId;
      } else {
        // Update existing conversation
        await _supabase
            .from('chat_conversations')
            .update({
              'title': title,
              'messages': messages,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', conversationId)
            .eq('user_id', currentUserId);

        logger.info(
          '[ChatService] Updated Krishna conversation: $conversationId',
        );
        return conversationId;
      }
    } catch (e, stackTrace) {
      logger.error(
        '[ChatService] Error saving Krishna conversation',
        e,
        stackTrace,
      );

      if (e is SocketException) {
        throw NetworkException('Network error while saving conversation');
      }

      throw const ServerException('Failed to save conversation');
    }
  }

  /// Deletes a Krishna chatbot conversation
  ///
  /// [conversationId] - UUID of the conversation to delete
  ///
  /// Throws [AuthException] if user is not authenticated.
  /// Throws [ServerException] on database errors.
  Future<void> deleteKrishnaConversation(String conversationId) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        logger.warning(
          '[ChatService] Unauthenticated user attempted to delete Krishna conversation',
        );
        throw AuthException('User must be authenticated');
      }

      logger.debug(
        '[ChatService] Deleting Krishna conversation: $conversationId',
      );

      await _supabase
          .from('chat_conversations')
          .delete()
          .eq('id', conversationId)
          .eq('user_id', currentUserId);

      logger.info(
        '[ChatService] Deleted Krishna conversation: $conversationId',
      );
    } catch (e, stackTrace) {
      logger.error(
        '[ChatService] Error deleting Krishna conversation',
        e,
        stackTrace,
      );

      if (e is SocketException) {
        throw NetworkException('Network error while deleting conversation');
      }

      throw const ServerException('Failed to delete conversation');
    }
  }

  /// Sends a message to the Krishna chatbot and gets a response
  ///
  /// [message] - The user's message
  /// [mode] - Chat mode: 'friend' or 'philosophical'
  /// [chatId] - Optional chat ID for continuing a conversation
  ///
  /// Returns a Map with 'response' and 'chat_id'
  /// [language] - Optional. When null, defaults to 'English'. Pass 'Hindi' for Hindi responses.
  Future<Map<String, dynamic>> sendChatbotMessage({
    required String message,
    required String mode,
    String? chatId,
    String? language,
  }) async {
    final logger = getIt<Talker>();
    String? displayName;

    try {
      logger.debug(
        '[ChatService] Sending chatbot message. Mode: $mode, ChatId: $chatId',
      );

      // Try to fetch current user's display name for personalized prompts
      try {
        final profiles = getIt<ProfileService>();
        final profile = await profiles.getCurrentUserProfile();
        if (profile != null) {
          final fullName = (profile['full_name'] as String?)?.trim();
          final username = (profile['username'] as String?)?.trim();
          displayName = (fullName != null && fullName.isNotEmpty)
              ? fullName
              : (username != null && username.isNotEmpty ? username : null);
        }
      } catch (_) {
        // Non-fatal if profile/name lookup fails
      }

      final response = await _supabase.functions.invoke(
        'chat-service',
        body: {
          'message': message,
          'mode': mode,
          'chat_id': chatId,
          'language': language ?? 'English',
          if (displayName != null && displayName.trim().isNotEmpty)
            'user_name': displayName.trim(),
        },
      );

      if (response.status != 200) {
        throw ServerException(
          'Failed to get chatbot response: ${response.data}',
          response.status.toString(),
        );
      }

      logger.info('[ChatService] Received chatbot response');
      return response.data as Map<String, dynamic>;
    } catch (e, stackTrace) {
      logger.error('[ChatService] Error calling chat-service', e, stackTrace);

      if (e is SocketException) {
        throw NetworkException('Network error while chatting with Krishna');
      }

      rethrow;
    }
  }

  /// Forwards a message to another conversation
  ///
  /// [messageId] - The ID of the message to forward
  /// [targetConversationId] - The ID of the conversation to forward to
  ///
  /// Throws [AuthException] if user is not authenticated.
  /// Throws [ServerException] on database errors.
  Future<void> forwardMessage({
    required String messageId,
    required String targetConversationId,
  }) async {
    final logger = getIt<Talker>();

    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        logger.warning(
          '[ChatService] Unauthenticated user attempted to forward message',
        );
        throw AuthException('User must be authenticated to forward message');
      }

      logger.debug(
        '[ChatService] Forwarding message $messageId to conversation $targetConversationId',
      );

      // Prevent forwarding into a 1:1 DM where either user has blocked the other.
      final isBlockedDm = await _isBlockedDMConversationForCurrentUser(
        targetConversationId,
      );
      if (isBlockedDm) {
        logger.warning(
          '[ChatService] Blocked DM conversation, denying forward for user: $currentUserId, targetConversation: $targetConversationId',
        );
        throw const ServerException(
          'You cannot send messages in this conversation because one of you has blocked the other.',
          'USER_BLOCKED',
        );
      }

      // Get the original message (include metadata for poll/location forwards)
      final messageResponse = await _supabase
          .from('chat_messages')
          .select('content, type, metadata')
          .eq('id', messageId)
          .single();

      final row = <String, dynamic>{
        'conversation_id': targetConversationId,
        'sender_id': currentUserId,
        'content': messageResponse['content'],
        'type': messageResponse['type'],
      };
      final meta = messageResponse['metadata'];
      if (meta is Map && meta.isNotEmpty) {
        row['metadata'] = meta;
      }

      final inserted = await _supabase
          .from('chat_messages')
          .insert(row)
          .select('id')
          .single();
      final newMessageId = inserted['id'] as String;

      // Re-attach image rows so forwarded photos keep the same storage object.
      final msgType = (messageResponse['type'] as String?)?.toLowerCase();
      if (msgType == 'image') {
        final attRows = await _supabase
            .from('message_attachments')
            .select('bucket, object_path, mime_type, size_bytes')
            .eq('message_id', messageId);
        for (final raw in attRows as List) {
          final a = Map<String, dynamic>.from(raw as Map);
          final path = a['object_path'] as String?;
          if (path == null || path.isEmpty) continue;
          await _supabase.from('message_attachments').insert({
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

      logger.info('[ChatService] Successfully forwarded message');
    } on AuthException {
      rethrow;
    } on PostgrestException catch (e, stackTrace) {
      logger.error(
        '[ChatService] Database error forwarding message: ${e.message}',
        e,
        stackTrace,
      );
      throw ServerException('Failed to forward message: ${e.message}', e.code);
    } catch (e, stackTrace) {
      logger.error(
        '[ChatService] Unexpected error forwarding message',
        e,
        stackTrace,
      );
      throw const ServerException('Failed to forward message');
    }
  }

  /// Subscribes to events that can affect chat/group conversation list ordering
  /// and previews for the current user.
  ///
  /// Emits a void tick when:
  /// - chat messages are inserted/updated/deleted
  /// - conversation rows are updated
  /// - current user's conversation membership changes
  /// - local unread state changes are emitted
  ///
  /// Caller should refresh conversation list on each emission.
  Stream<void> subscribeToConversationListChanges() {
    final logger = getIt<Talker>();
    late StreamController<void> controller;
    RealtimeChannel? channel;
    StreamSubscription<void>? localSubscription;
    bool isSubscribed = false;

    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      logger.warning(
        '[ChatService] Cannot subscribe to conversation list changes: user not authenticated',
      );
      return const Stream.empty();
    }

    final channelName =
        'conversation_list:$currentUserId:${DateTime.now().millisecondsSinceEpoch}';

    logger.debug(
      '[ChatService] Setting up conversation list realtime subscription: $channelName',
    );

    controller = StreamController<void>(
      onListen: () {
        if (isSubscribed) {
          logger.warning(
            '[ChatService] Attempted to subscribe to already active channel: $channelName',
          );
          return;
        }

        isSubscribed = true;
        logger.info(
          '[ChatService] Subscribing to conversation list changes: $channelName (user: $currentUserId)',
        );

        localSubscription = _localUnreadCountChanges.stream.listen((_) {
          if (!controller.isClosed) {
            controller.add(null);
          }
        });

        try {
          channel = _supabase
              .channel(channelName)
              .onPostgresChanges(
                event: PostgresChangeEvent.insert,
                schema: 'public',
                table: 'chat_messages',
                callback: (_) {
                  if (!controller.isClosed) controller.add(null);
                },
              )
              .onPostgresChanges(
                event: PostgresChangeEvent.update,
                schema: 'public',
                table: 'chat_messages',
                callback: (_) {
                  if (!controller.isClosed) controller.add(null);
                },
              )
              .onPostgresChanges(
                event: PostgresChangeEvent.delete,
                schema: 'public',
                table: 'chat_messages',
                callback: (_) {
                  if (!controller.isClosed) controller.add(null);
                },
              )
              .onPostgresChanges(
                event: PostgresChangeEvent.update,
                schema: 'public',
                table: 'conversations',
                callback: (_) {
                  if (!controller.isClosed) controller.add(null);
                },
              )
              .onPostgresChanges(
                event: PostgresChangeEvent.insert,
                schema: 'public',
                table: 'conversation_members',
                filter: PostgresChangeFilter(
                  type: PostgresChangeFilterType.eq,
                  column: 'user_id',
                  value: currentUserId,
                ),
                callback: (_) {
                  if (!controller.isClosed) controller.add(null);
                },
              )
              .onPostgresChanges(
                event: PostgresChangeEvent.update,
                schema: 'public',
                table: 'conversation_members',
                filter: PostgresChangeFilter(
                  type: PostgresChangeFilterType.eq,
                  column: 'user_id',
                  value: currentUserId,
                ),
                callback: (_) {
                  if (!controller.isClosed) controller.add(null);
                },
              )
              .onPostgresChanges(
                event: PostgresChangeEvent.delete,
                schema: 'public',
                table: 'conversation_members',
                filter: PostgresChangeFilter(
                  type: PostgresChangeFilterType.eq,
                  column: 'user_id',
                  value: currentUserId,
                ),
                callback: (_) {
                  if (!controller.isClosed) controller.add(null);
                },
              )
              .subscribe();

          logger.info(
            '[ChatService] Successfully subscribed to conversation list changes: $channelName',
          );
        } catch (e, stackTrace) {
          logger.error(
            '[ChatService] Failed to setup conversation list subscription: $channelName',
            e,
            stackTrace,
          );
          isSubscribed = false;
          if (!controller.isClosed) {
            controller.addError(e);
          }
        }
      },
      onCancel: () async {
        await localSubscription?.cancel();
        localSubscription = null;

        if (!isSubscribed) {
          return;
        }

        try {
          if (channel != null) {
            await channel!.unsubscribe();
            await _supabase.removeChannel(channel!);
          }
        } catch (e, stackTrace) {
          logger.error(
            '[ChatService] Error during conversation list channel cleanup: $channelName',
            e,
            stackTrace,
          );
        } finally {
          isSubscribed = false;
          channel = null;
        }
      },
    );

    return controller.stream;
  }

  /// Gets the total count of unread conversations (DMs + Groups).
  ///
  /// A conversation is considered unread if the current user has not seen
  /// the latest message (based on last_read_at vs last_message_at).
  ///
  /// Returns 0 if user is not authenticated.
  /// Returns a count with no limit; consider capping UI display at 99+.
  Future<int> getUnreadConversationCount() async {
    final logger = getIt<Talker>();
    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        return 0;
      }

      logger.debug(
        '[ChatService] Fetching unread conversation count for user: $currentUserId',
      );

      final conversations = await getMyConversations(isGroup: null);

      // Count conversations where isUnread returns true
      final unreadCount = conversations
          .where((c) => c.isUnread(currentUserId))
          .length;

      logger.debug('[ChatService] Unread conversation count: $unreadCount');

      return unreadCount;
    } catch (e, stackTrace) {
      logger.error(
        '[ChatService] Error getting unread conversation count',
        e,
        stackTrace,
      );
      // Return 0 on error rather than throwing to keep UI functional
      return 0;
    }
  }

  /// Subscribes to unread conversation count changes via realtime events.
  ///
  /// Emits a void tick whenever an event that could affect unread status occurs:
  /// - New message inserted (chat_messages INSERT)
  /// - Conversation member read state updated (conversation_members UPDATE on last_read_at)
  ///
  /// Caller should refresh the unread count on each emission.
  ///
  /// **Important**: Always cancel the subscription when done to prevent
  /// memory leaks (e.g., when the home screen is disposed).
  ///
  /// Example usage:
  /// ```dart
  /// final subscription = chatService.subscribeToUnreadCountChanges().listen(
  ///   (_) async {
  ///     final count = await chatService.getUnreadConversationCount();
  ///     setState(() => unreadCount = count);
  ///   },
  /// );
  /// // Later, in dispose():
  /// subscription.cancel();
  /// ```
  Stream<void> subscribeToUnreadCountChanges() {
    final logger = getIt<Talker>();
    late StreamController<void> controller;
    RealtimeChannel? channel;
    StreamSubscription<void>? localSubscription;
    bool isSubscribed = false;

    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      logger.warning(
        '[ChatService] Cannot subscribe to unread count changes: user not authenticated',
      );
      return const Stream.empty();
    }

    final channelName =
        'unread_count:$currentUserId:${DateTime.now().millisecondsSinceEpoch}';

    logger.debug(
      '[ChatService] Setting up unread count realtime subscription: $channelName',
    );

    controller = StreamController<void>(
      onListen: () {
        if (isSubscribed) {
          logger.warning(
            '[ChatService] Attempted to subscribe to already active channel: $channelName',
          );
          return;
        }

        logger.info(
          '[ChatService] Subscribing to unread count changes: $channelName (user: $currentUserId)',
        );
        isSubscribed = true;

        localSubscription = _localUnreadCountChanges.stream.listen((_) {
          if (!controller.isClosed) {
            logger.debug(
              '[ChatService] Local unread change emitted, refreshing count',
            );
            controller.add(null);
          }
        });

        try {
          channel = _supabase
              .channel(channelName)
              // Listen for new messages in all conversations for current user
              .onPostgresChanges(
                event: PostgresChangeEvent.insert,
                schema: 'public',
                table: 'chat_messages',
                callback: (payload) {
                  if (!controller.isClosed) {
                    logger.debug(
                      '[ChatService] New message received, emitting unread count refresh',
                    );
                    controller.add(null);
                  }
                },
              )
              // Listen for read state updates (when messages are marked as read)
              .onPostgresChanges(
                event: PostgresChangeEvent.update,
                schema: 'public',
                table: 'conversation_members',
                filter: PostgresChangeFilter(
                  type: PostgresChangeFilterType.eq,
                  column: 'user_id',
                  value: currentUserId,
                ),
                callback: (payload) {
                  if (!controller.isClosed) {
                    // Emit on any membership update for this user.
                    // Some realtime payloads may omit old/new non-key fields,
                    // so diffing last_read_at can miss legitimate updates.
                    logger.debug(
                      '[ChatService] Conversation membership updated, emitting unread count refresh',
                    );
                    controller.add(null);
                  }
                },
              )
              .subscribe();

          logger.info(
            '[ChatService] Successfully subscribed to unread count changes: $channelName',
          );
        } catch (e, stackTrace) {
          logger.error(
            '[ChatService] Failed to setup unread count subscription: $channelName',
            e,
            stackTrace,
          );
          isSubscribed = false;
          if (!controller.isClosed) {
            controller.addError(e);
          }
        }
      },
      onCancel: () async {
        await localSubscription?.cancel();
        localSubscription = null;

        if (!isSubscribed) {
          logger.debug(
            '[ChatService] Channel already unsubscribed: $channelName',
          );
          return;
        }

        logger.info(
          '[ChatService] Unsubscribing from unread count changes: $channelName',
        );

        try {
          if (channel != null) {
            await channel!.unsubscribe();
            logger.debug('[ChatService] Channel unsubscribed: $channelName');

            await _supabase.removeChannel(channel!);
            logger.debug(
              '[ChatService] Channel removed from client: $channelName',
            );
          }
          logger.info(
            '[ChatService] Successfully cleaned up unread count subscription: $channelName',
          );
        } catch (e, stackTrace) {
          logger.error(
            '[ChatService] Error during unread count channel cleanup: $channelName',
            e,
            stackTrace,
          );
        } finally {
          isSubscribed = false;
          channel = null;
        }
      },
    );

    return controller.stream;
  }
}
