# Phase 5: Chat Feature - Research

**Researched:** 2026-01-30
**Domain:** Brick offline-first chat with conversations and messages, Supabase realtime sync
**Confidence:** HIGH

## Summary

Phase 5 adds offline chat viewing to the MyItihas app by migrating the existing chat feature from Hive to Brick offline-first caching. The core task is creating Brick models for conversations and messages, mapping to existing Supabase tables (`conversations` and `chat_messages`), and implementing lazy caching with realtime subscriptions for live message delivery.

The existing chat implementation uses in-memory mock data via ChatDataSourceImpl. This phase replaces it with Brick models that cache conversations and messages locally. Key architectural decisions from CONTEXT.md: (1) lazy chat caching - use `awaitRemoteWhenNoneExist` policy for conversations (cache on first access, not pre-emptively), (2) store last 100 messages per conversation with scroll-to-load for older messages, (3) cache conversations accessed in last 30 days, (4) use Brick realtime for live message sync.

The standard pattern follows Phase 2/4: create `conversation.model.dart` and `message.model.dart` extending `OfflineFirstWithSupabaseModel`, map to Supabase `conversations` and `chat_messages` tables with foreign keys, use `awaitRemoteWhenNoneExist` for conversation list (cache on access), `alwaysHydrate` for message history (background refresh), and subscribe to `chat_messages` table for realtime new messages. Sending messages offline is out of scope (Phase 7).

**Primary recommendation:** Create Conversation.model.dart with user association via `conversation_members` table join, Message.model.dart with conversation foreign key, map to Supabase schema with nullable author field for cache resilience, implement message pagination with 100-message limit, and use Brick `subscribeToRealtime<MessageModel>()` for automatic new message insertion. Disable send action when offline with error snackbar.

## Standard Stack

The established libraries/tools for offline-first chat with Brick:

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| brick_offline_first_with_supabase | ^2.1.0 | Model annotations and adapters | Already installed, handles conversation/message caching with Supabase sync |
| brick_offline_first_with_supabase_build | ^2.1.0 | Code generator for adapters | Already installed, generates SQLite schema from annotations |
| internet_connection_checker_plus | ^2.5.4 | Connectivity monitoring | Already installed, used for offline send detection |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| supabase_flutter | ^2.5.6 | Realtime subscriptions | Already installed, use .onPostgresChanges() or subscribeToRealtime() for new messages |
| fpdart | ^1.1.0 | Either monad for error handling | Already in project, repository methods return Either<Failure, T> |
| timeago | ^3.6.0 | Relative timestamps | Already in project, format "2m ago", "3h ago" for recent messages |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Lazy conversation caching | Pre-cache all conversations | Decision: Lazy = less storage, only cache viewed conversations |
| 100 messages per conversation | Unlimited message cache | Decision: 100 messages limit prevents unbounded growth, scroll-to-load for older |
| Brick subscribeToRealtime | Manual Supabase .onPostgresChanges | subscribeToRealtime auto-upserts to cache, eliminates boilerplate |
| Nullable author field | Always require author | Decision: Nullable handles cache misses gracefully (from Phase 4) |

**Installation:**
Already completed in Phase 1. No new packages required.

## Architecture Patterns

### Recommended Project Structure
```
lib/features/chat/
├── domain/
│   ├── entities/
│   │   ├── conversation.dart         # Existing pure Dart entity
│   │   └── message.dart              # Existing pure Dart entity
│   └── repositories/
│       └── chat_repository.dart      # Interface (no change)
├── data/
│   ├── models/
│   │   ├── conversation.model.dart   # NEW: Brick model with @ConnectOfflineFirstWithSupabase
│   │   └── message.model.dart        # NEW: Brick model for messages
│   └── repositories/
│       └── chat_repository_impl.dart # MODIFY: Use repository.get<ConversationModel>()
└── presentation/
    └── bloc/
        ├── chat_list_bloc.dart       # MODIFY: Add realtime subscription
        └── chat_detail_bloc.dart     # MODIFY: Add message realtime, pagination
```

### Pattern 1: Conversation Model with User Association
**What:** Brick model for conversations with many-to-many user relationship via conversation_members
**When to use:** For conversation list and detail views
**Example:**
```dart
// lib/features/chat/data/models/conversation.model.dart
// Source: Phase 4 research + Supabase conversations/conversation_members schema
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:myitihas/features/social/data/models/user.model.dart';
import 'package:myitihas/features/chat/domain/entities/conversation.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'conversations'),
  sqliteConfig: SqliteSerializable(),
)
class ConversationModel extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  final String id;

  @Supabase(name: 'is_group')
  final bool isGroup;

  @Supabase(name: 'group_name')
  final String? groupName;

  @Supabase(name: 'group_avatar_url')
  final String? groupAvatarUrl;

  @Supabase(name: 'group_description')
  final String? groupDescription;

  @Supabase(name: 'last_message')
  final String? lastMessage;

  @Supabase(name: 'last_message_at')
  final DateTime? lastMessageAt;

  @Supabase(name: 'last_message_sender_id')
  final String? lastMessageSenderId;

  @Supabase(name: 'created_at')
  final DateTime? createdAt;

  @Supabase(name: 'updated_at')
  final DateTime? updatedAt;

  // Participants - loaded separately via conversation_members table
  // Brick doesn't support many-to-many directly, so we'll load in repository
  @Supabase(ignore: true)
  @Sqlite()
  final List<String> participantIds;

  @Supabase(ignore: true)
  @Sqlite(ignore: true)
  final List<UserModel> participants;

  // Local-only unread count (computed from messages where is_read = false)
  @Supabase(ignore: true)
  @Sqlite()
  final int unreadCount;

  ConversationModel({
    required this.id,
    this.isGroup = false,
    this.groupName,
    this.groupAvatarUrl,
    this.groupDescription,
    this.lastMessage,
    this.lastMessageAt,
    this.lastMessageSenderId,
    this.createdAt,
    this.updatedAt,
    this.participantIds = const [],
    this.participants = const [],
    this.unreadCount = 0,
  });

  Conversation toDomain() {
    return Conversation(
      id: id,
      participantIds: participantIds,
      participants: participants.map((p) => p.toDomain()).toList(),
      lastMessage: lastMessage,
      lastMessageAt: lastMessageAt,
      unreadCount: unreadCount,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  factory ConversationModel.fromDomain(Conversation conversation) {
    return ConversationModel(
      id: conversation.id,
      participantIds: conversation.participantIds,
      participants: conversation.participants
          .map((p) => UserModel.fromDomain(p))
          .toList(),
      lastMessage: conversation.lastMessage,
      lastMessageAt: conversation.lastMessageAt,
      unreadCount: conversation.unreadCount,
      updatedAt: conversation.updatedAt,
    );
  }
}
```

### Pattern 2: Message Model with Read Receipts
**What:** Brick model for messages with delivery status and read tracking
**When to use:** For message history display in conversation
**Example:**
```dart
// lib/features/chat/data/models/message.model.dart
// Source: Phase 2/4 patterns + Supabase chat_messages schema
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:myitihas/features/chat/domain/entities/message.dart';
import 'package:myitihas/features/social/data/models/user.model.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'chat_messages'),
  sqliteConfig: SqliteSerializable(),
)
class MessageModel extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  final String id;

  @Supabase(name: 'conversation_id', foreignKey: 'conversation_id')
  final String conversationId;

  @Supabase(name: 'sender_id', foreignKey: 'sender_id')
  final String senderId;

  // Nullable author for cache resilience (Phase 4 pattern)
  @Supabase(foreignKey: 'sender_id')
  final UserModel? sender;

  @Supabase(name: 'content')
  final String text;

  @Supabase(name: 'type')
  final String? type;  // 'text', 'story_share', 'image', etc.

  @Supabase(name: 'created_at')
  final DateTime timestamp;

  // Local-only delivery status (not in Supabase)
  @Supabase(ignore: true)
  @Sqlite()
  final String deliveryStatus;  // 'sending', 'sent', 'delivered', 'read', 'failed'

  // Read tracking - not in Supabase chat_messages, stored locally
  @Supabase(ignore: true)
  @Sqlite()
  final List<String> readBy;

  // Shared story reference (optional)
  @Supabase(ignore: true)
  @Sqlite()
  final String? sharedStoryId;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.sender,
    required this.text,
    this.type = 'text',
    required this.timestamp,
    this.deliveryStatus = 'sent',
    this.readBy = const [],
    this.sharedStoryId,
  });

  Message toDomain() {
    // Map delivery status string to enum
    final status = _parseDeliveryStatus(deliveryStatus);

    return Message(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      senderName: sender?.displayName ?? 'Unknown',
      senderAvatar: sender?.avatarUrl ?? '',
      text: text,
      timestamp: timestamp,
      deliveryStatus: status,
      readBy: readBy,
      sharedStoryId: sharedStoryId,
    );
  }

  MessageDeliveryStatus _parseDeliveryStatus(String status) {
    switch (status) {
      case 'sending':
        return MessageDeliveryStatus.sending;
      case 'sent':
        return MessageDeliveryStatus.sent;
      case 'delivered':
        return MessageDeliveryStatus.delivered;
      case 'read':
        return MessageDeliveryStatus.read;
      case 'failed':
        return MessageDeliveryStatus.failed;
      default:
        return MessageDeliveryStatus.sent;
    }
  }

  factory MessageModel.fromDomain(Message message) {
    return MessageModel(
      id: message.id,
      conversationId: message.conversationId,
      senderId: message.senderId,
      text: message.text,
      timestamp: message.timestamp,
      deliveryStatus: message.deliveryStatus.name,
      readBy: message.readBy,
      sharedStoryId: message.sharedStoryId,
    );
  }
}
```

### Pattern 3: Conversation Repository with Lazy Caching
**What:** Repository using awaitRemoteWhenNoneExist for conversations, alwaysHydrate for messages
**When to use:** In ChatRepositoryImpl for conversation list and message history
**Example:**
```dart
// lib/features/chat/data/repositories/chat_repository_impl.dart
// Source: Phase 3 lazy caching pattern + existing ChatRepositoryImpl
@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final MyItihasRepository repository;
  final SupabaseClient supabase;

  ChatRepositoryImpl({
    required this.repository,
    required this.supabase,
  });

  @override
  Future<Either<Failure, List<Conversation>>> getConversations() async {
    try {
      // Lazy caching: fetch from server if not in cache
      final models = await repository.get<ConversationModel>(
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
        query: Query()
          .orderBy('updated_at', descending: true),
      );

      // Load participants for each conversation from conversation_members
      final conversationsWithParticipants = await Future.wait(
        models.map((model) => _loadParticipants(model))
      );

      return Right(conversationsWithParticipants.map((m) => m.toDomain()).toList());
    } on OfflineFirstException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Future<ConversationModel> _loadParticipants(ConversationModel conversation) async {
    try {
      // Query conversation_members table
      final membersResponse = await supabase
          .from('conversation_members')
          .select('user_id, profiles(*)')
          .eq('conversation_id', conversation.id);

      final participantIds = <String>[];
      final participants = <UserModel>[];

      for (final member in membersResponse as List) {
        final userId = member['user_id'] as String;
        participantIds.add(userId);

        final profileData = member['profiles'] as Map<String, dynamic>?;
        if (profileData != null) {
          // Check if user already in cache
          final cachedUsers = await repository.get<UserModel>(
            policy: OfflineFirstGetPolicy.localOnly,
            query: Query.where('id', userId),
          );

          if (cachedUsers.isNotEmpty) {
            participants.add(cachedUsers.first);
          } else {
            // Create from Supabase data
            final userModel = UserModel(
              id: profileData['id'] as String,
              username: profileData['username'] as String,
              displayName: profileData['full_name'] as String? ?? '',
              avatarUrl: profileData['avatar_url'] as String? ?? '',
              bio: profileData['bio'] as String? ?? '',
            );
            participants.add(userModel);
            // Cache user
            await repository.upsert<UserModel>(userModel);
          }
        }
      }

      return ConversationModel(
        id: conversation.id,
        isGroup: conversation.isGroup,
        groupName: conversation.groupName,
        groupAvatarUrl: conversation.groupAvatarUrl,
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
      talker.error('[ChatRepository] Error loading participants', e);
      return conversation;
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessages({
    required String conversationId,
    int limit = 100,
    int offset = 0,
  }) async {
    try {
      // Background refresh with cache-first
      final models = await repository.get<MessageModel>(
        policy: OfflineFirstGetPolicy.alwaysHydrate,
        query: Query.where('conversationId', conversationId)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .offset(offset),
      );

      return Right(models.map((m) => m.toDomain()).toList());
    } on OfflineFirstException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
```

### Pattern 4: Message Realtime Subscription
**What:** Subscribe to chat_messages table for automatic new message delivery
**When to use:** In ChatDetailBloc for live message updates
**Example:**
```dart
// lib/features/chat/presentation/bloc/chat_detail_bloc.dart
// Source: Phase 4 realtime pattern + existing ChatDetailBloc
import 'dart:async';
import 'package:myitihas/repository/my_itihas_repository.dart';

@injectable
class ChatDetailBloc extends Bloc<ChatDetailEvent, ChatDetailState> {
  final ChatRepository chatRepository;
  final MyItihasRepository brickRepository;

  StreamSubscription<List<MessageModel>>? _messageSubscription;

  ChatDetailBloc({
    required this.chatRepository,
    required this.brickRepository,
  }) : super(const ChatDetailState.initial()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<RealtimeMessageReceivedEvent>(_onRealtimeMessage);
  }

  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<ChatDetailState> emit,
  ) async {
    emit(const ChatDetailState.loading());

    final result = await chatRepository.getMessages(
      conversationId: event.conversationId,
      limit: 100,
    );

    result.fold(
      (failure) => emit(ChatDetailState.error(failure.message)),
      (messages) {
        emit(ChatDetailState.loaded(messages: messages));
        _startRealtimeSubscription(event.conversationId);
      },
    );
  }

  void _startRealtimeSubscription(String conversationId) {
    // Subscribe to new messages for this conversation
    _messageSubscription = brickRepository
        .subscribeToRealtime<MessageModel>(
          query: Query.where('conversationId', conversationId),
        )
        .listen((messages) {
          if (messages.isNotEmpty) {
            final newMessage = messages.first;
            add(ChatDetailEvent.realtimeMessageReceived(newMessage.toDomain()));
          }
        });
  }

  Future<void> _onRealtimeMessage(
    RealtimeMessageReceivedEvent event,
    Emitter<ChatDetailState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ChatDetailLoaded) return;

    // Insert new message at top (descending order)
    final updatedMessages = [event.message, ...currentState.messages];

    emit(currentState.copyWith(messages: updatedMessages));
  }

  @override
  Future<void> close() async {
    await _messageSubscription?.cancel();
    return super.close();
  }
}
```

### Pattern 5: Offline Send Detection with Snackbar
**What:** Check connectivity before sending message, show error when offline
**When to use:** In ChatDetailBloc send message event
**Example:**
```dart
// lib/features/chat/presentation/bloc/chat_detail_bloc.dart
// Source: Phase 3/4 offline error pattern
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

@injectable
class ChatDetailBloc extends Bloc<ChatDetailEvent, ChatDetailState> {
  final ChatRepository chatRepository;
  final InternetConnection internetConnection;

  ChatDetailBloc({
    required this.chatRepository,
    required this.internetConnection,
  }) : super(const ChatDetailState.initial()) {
    on<SendMessageEvent>(_onSendMessage);
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatDetailState> emit,
  ) async {
    // Check connectivity
    final isOnline = await internetConnection.hasInternetAccess;
    if (!isOnline) {
      final currentState = state;
      if (currentState is ChatDetailLoaded) {
        emit(currentState.copyWith(
          error: 'No internet connection. Try again later.',
          isOfflineError: true,
        ));
      }
      return;
    }

    // Optimistic UI: add message immediately with 'sending' status
    final currentState = state;
    if (currentState is! ChatDetailLoaded) return;

    final optimisticMessage = Message(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: event.conversationId,
      senderId: event.senderId,
      senderName: 'You',
      senderAvatar: '',
      text: event.text,
      timestamp: DateTime.now(),
      deliveryStatus: MessageDeliveryStatus.sending,
    );

    emit(currentState.copyWith(
      messages: [optimisticMessage, ...currentState.messages],
    ));

    // Send to server
    final result = await chatRepository.sendMessage(
      conversationId: event.conversationId,
      text: event.text,
    );

    result.fold(
      (failure) {
        // Remove optimistic message, show error
        final updatedMessages = currentState.messages
            .where((m) => m.id != optimisticMessage.id)
            .toList();
        emit(currentState.copyWith(
          messages: updatedMessages,
          error: failure.message,
        ));
      },
      (sentMessage) {
        // Replace optimistic with real message (realtime will also deliver it)
        final updatedMessages = currentState.messages
            .map((m) => m.id == optimisticMessage.id ? sentMessage : m)
            .toList();
        emit(currentState.copyWith(messages: updatedMessages));
      },
    );
  }
}

// In UI layer (chat_detail_page.dart)
BlocListener<ChatDetailBloc, ChatDetailState>(
  listener: (context, state) {
    if (state is ChatDetailLoaded && state.error != null && state.isOfflineError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.error!),
          backgroundColor: context.colorScheme.error,
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: context.colorScheme.onError,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  },
  child: // ... chat UI
)
```

### Anti-Patterns to Avoid
- **Pre-caching all conversations:** User decision is lazy caching (awaitRemoteWhenNoneExist) - only cache conversations the user opens
- **Unlimited message history:** Decision is 100 messages max per conversation to prevent unbounded growth
- **Caching read receipts as separate table:** Store read status locally as SQLite-only field, don't sync to Supabase
- **Using alwaysHydrate for conversation list:** Use awaitRemoteWhenNoneExist for lazy loading (Phase 3 decision)
- **Forgetting nullable author field:** Phase 4 pattern - make sender nullable to handle cache misses gracefully

## Don't Hand-Roll

Problems that look simple but have existing solutions:

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Many-to-many conversation participants | Custom junction table handling | Load separately via conversation_members query | Brick doesn't support M:N directly, manual query is simpler |
| Message pagination | Custom cursor-based pagination | Brick Query.offset() + .limit() | Built-in pagination with SQLite and Supabase |
| Realtime new message delivery | Manual Supabase .onPostgresChanges | Brick subscribeToRealtime<MessageModel>() | Auto-upserts to cache when messages arrive |
| Conversation unread count | Compute via COUNT(*) where is_read=false | Store as local SQLite field, update on message read | Avoids expensive count queries |
| Relative timestamps | Custom date formatting logic | timeago package | Already in project, handles "2m ago", "3h ago" automatically |

**Key insight:** Chat has complex relationships (conversations ↔ users M:N, messages → conversation 1:N, messages → sender M:1) and realtime requirements. Hand-rolling would require: junction table queries, foreign key management, realtime subscription setup, and optimistic UI updates. Brick handles the SQLite/Supabase sync automatically, repository layer loads associations manually for M:N, and subscribeToRealtime provides live updates.

## Common Pitfalls

### Pitfall 1: Not Handling conversation_members Many-to-Many
**What goes wrong:** Conversations have no participants, UI shows blank names/avatars
**Why it happens:** Brick doesn't auto-resolve many-to-many via junction tables
**How to avoid:** Query conversation_members table manually in repository, load UserModel for each participant
**Warning signs:**
- Conversations display with empty participant list
- "Unknown" displayed for all chat participants
- Only group_name shows, no user avatars

### Pitfall 2: Forgetting Message Limit per Conversation
**What goes wrong:** SQLite cache grows unbounded, thousands of old messages cached
**Why it happens:** Not implementing 100-message limit per conversation
**How to avoid:** Use Query.limit(100) and implement scroll-to-load for older messages
**Warning signs:**
- SQLite database grows rapidly
- Chat queries become slow
- App sluggish after weeks of use

### Pitfall 3: Wrong Policy for Conversation List
**What goes wrong:** Conversation list always waits for network, even when cached
**Why it happens:** Using alwaysHydrate instead of awaitRemoteWhenNoneExist
**How to avoid:** User decision (from CONTEXT.md): lazy caching with awaitRemoteWhenNoneExist
**Warning signs:**
- Conversation list shows loading spinner every time
- Cached conversations not displayed immediately
- Slow navigation to chat list page

### Pitfall 4: Not Cancelling Realtime Subscriptions
**What goes wrong:** Memory leak, messages received after navigating away
**Why it happens:** subscribeToRealtime returns StreamSubscription that must be cancelled
**How to avoid:** Store subscription in BLoC, cancel in close() method (same as Phase 4)
**Warning signs:**
- Memory usage grows over time
- Messages appear in wrong conversation
- Multiple subscriptions to same conversation

### Pitfall 5: Sending Messages Without Connectivity Check
**What goes wrong:** Silent failures when offline, no user feedback
**Why it happens:** Not checking InternetConnection before sendMessage call
**How to avoid:** Check hasInternetAccess, emit offline error with snackbar
**Warning signs:**
- Messages stuck in "sending" state
- No error shown when offline
- Users confused why messages don't send

### Pitfall 6: Conversation Updated_At Not Syncing
**What goes wrong:** Conversations not sorted correctly after new messages
**Why it happens:** Not updating conversation.updated_at when new message arrives
**How to avoid:** Update ConversationModel.updatedAt in realtime message handler
**Warning signs:**
- Active conversations buried below old ones
- Conversation order doesn't match last activity
- New messages don't bring conversation to top

### Pitfall 7: Read Receipts Not Persisting
**What goes wrong:** Unread badges reset on app restart
**Why it happens:** Read status stored in memory, not SQLite
**How to avoid:** Mark readBy and deliveryStatus with @Sqlite() annotation for local persistence
**Warning signs:**
- Unread counts always zero after restart
- Read receipts disappear when app reopens
- No offline tracking of message read status

## Code Examples

Verified patterns from official sources:

### Complete Conversation Model with Participants
```dart
// lib/features/chat/data/models/conversation.model.dart
// Source: Phase 2/4 Brick patterns + Supabase conversations schema
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:myitihas/features/social/data/models/user.model.dart';
import 'package:myitihas/features/chat/domain/entities/conversation.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'conversations'),
  sqliteConfig: SqliteSerializable(),
)
class ConversationModel extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  final String id;

  @Supabase(name: 'is_group')
  final bool isGroup;

  @Supabase(name: 'group_name')
  final String? groupName;

  @Supabase(name: 'group_avatar_url')
  final String? groupAvatarUrl;

  @Supabase(name: 'group_description')
  final String? groupDescription;

  @Supabase(name: 'last_message')
  final String? lastMessage;

  @Supabase(name: 'last_message_at')
  final DateTime? lastMessageAt;

  @Supabase(name: 'last_message_sender_id')
  final String? lastMessageSenderId;

  @Supabase(name: 'created_at')
  final DateTime? createdAt;

  @Supabase(name: 'updated_at')
  final DateTime? updatedAt;

  // Participants - SQLite only (loaded via conversation_members)
  @Supabase(ignore: true)
  @Sqlite()
  final List<String> participantIds;

  // Eager-loaded participants (not persisted, populated by repository)
  @Supabase(ignore: true)
  @Sqlite(ignore: true)
  final List<UserModel> participants;

  // Local unread count
  @Supabase(ignore: true)
  @Sqlite()
  final int unreadCount;

  ConversationModel({
    required this.id,
    this.isGroup = false,
    this.groupName,
    this.groupAvatarUrl,
    this.groupDescription,
    this.lastMessage,
    this.lastMessageAt,
    this.lastMessageSenderId,
    this.createdAt,
    this.updatedAt,
    this.participantIds = const [],
    this.participants = const [],
    this.unreadCount = 0,
  });

  Conversation toDomain() {
    return Conversation(
      id: id,
      participantIds: participantIds,
      participants: participants.map((p) => p.toDomain()).toList(),
      lastMessage: lastMessage,
      lastMessageAt: lastMessageAt,
      unreadCount: unreadCount,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  factory ConversationModel.fromDomain(Conversation entity) {
    return ConversationModel(
      id: entity.id,
      participantIds: entity.participantIds,
      participants: entity.participants.map((p) => UserModel.fromDomain(p)).toList(),
      lastMessage: entity.lastMessage,
      lastMessageAt: entity.lastMessageAt,
      unreadCount: entity.unreadCount,
      updatedAt: entity.updatedAt,
    );
  }
}
```

### Message Model with Read Tracking
```dart
// lib/features/chat/data/models/message.model.dart
// Source: Phase 4 nullable author pattern + chat_messages schema
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:myitihas/features/chat/domain/entities/message.dart';
import 'package:myitihas/features/social/data/models/user.model.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'chat_messages'),
  sqliteConfig: SqliteSerializable(),
)
class MessageModel extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  final String id;

  @Supabase(name: 'conversation_id')
  final String conversationId;

  @Supabase(name: 'sender_id')
  final String senderId;

  // Nullable for cache resilience (Phase 4 pattern)
  @Supabase(foreignKey: 'sender_id')
  final UserModel? sender;

  @Supabase(name: 'content')
  final String content;

  @Supabase(name: 'type')
  final String messageType;

  @Supabase(name: 'created_at')
  final DateTime createdAt;

  // Local-only delivery status
  @Supabase(ignore: true)
  @Sqlite()
  final String deliveryStatus;

  // Local-only read tracking
  @Supabase(ignore: true)
  @Sqlite()
  final List<String> readBy;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.sender,
    required this.content,
    this.messageType = 'text',
    required this.createdAt,
    this.deliveryStatus = 'sent',
    this.readBy = const [],
  });

  Message toDomain() {
    final status = _parseDeliveryStatus(deliveryStatus);

    return Message(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      senderName: sender?.displayName ?? 'Unknown',
      senderAvatar: sender?.avatarUrl ?? '',
      text: content,
      timestamp: createdAt,
      deliveryStatus: status,
      readBy: readBy,
    );
  }

  MessageDeliveryStatus _parseDeliveryStatus(String status) {
    return MessageDeliveryStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => MessageDeliveryStatus.sent,
    );
  }

  factory MessageModel.fromDomain(Message entity) {
    return MessageModel(
      id: entity.id,
      conversationId: entity.conversationId,
      senderId: entity.senderId,
      content: entity.text,
      createdAt: entity.timestamp,
      deliveryStatus: entity.deliveryStatus.name,
      readBy: entity.readBy,
    );
  }
}
```

### Repository with Participant Loading
```dart
// lib/features/chat/data/repositories/chat_repository_impl.dart
// Source: Phase 3 lazy caching + manual M:N association loading
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myitihas/repository/my_itihas_repository.dart';
import 'package:myitihas/core/errors/failures.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../models/conversation.model.dart';
import '../models/message.model.dart';

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final MyItihasRepository repository;
  final SupabaseClient supabase;

  ChatRepositoryImpl(this.repository, this.supabase);

  @override
  Future<Either<Failure, List<Conversation>>> getConversations() async {
    try {
      // Lazy caching: fetch if not cached
      final models = await repository.get<ConversationModel>(
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
        query: Query().orderBy('updated_at', descending: true),
      );

      // Load participants for each conversation
      final withParticipants = await Future.wait(
        models.map((m) => _enrichWithParticipants(m)),
      );

      return Right(withParticipants.map((m) => m.toDomain()).toList());
    } on OfflineFirstException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Future<ConversationModel> _enrichWithParticipants(
    ConversationModel conversation,
  ) async {
    try {
      final membersData = await supabase
          .from('conversation_members')
          .select('user_id, profiles(*)')
          .eq('conversation_id', conversation.id);

      final participantIds = <String>[];
      final participants = <UserModel>[];

      for (final member in membersData as List) {
        final userId = member['user_id'] as String;
        participantIds.add(userId);

        // Try cache first
        final cached = await repository.get<UserModel>(
          policy: OfflineFirstGetPolicy.localOnly,
          query: Query.where('id', userId),
        );

        if (cached.isNotEmpty) {
          participants.add(cached.first);
        } else {
          // Create from Supabase response
          final profile = member['profiles'] as Map<String, dynamic>?;
          if (profile != null) {
            final user = UserModel(
              id: profile['id'] as String,
              username: profile['username'] as String,
              displayName: profile['full_name'] as String? ?? '',
              avatarUrl: profile['avatar_url'] as String? ?? '',
              bio: profile['bio'] as String? ?? '',
            );
            participants.add(user);
            await repository.upsert<UserModel>(user);
          }
        }
      }

      return ConversationModel(
        id: conversation.id,
        isGroup: conversation.isGroup,
        groupName: conversation.groupName,
        lastMessage: conversation.lastMessage,
        lastMessageAt: conversation.lastMessageAt,
        updatedAt: conversation.updatedAt,
        participantIds: participantIds,
        participants: participants,
        unreadCount: conversation.unreadCount,
      );
    } catch (e) {
      talker.warning('[ChatRepository] Failed to load participants: $e');
      return conversation;
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessages({
    required String conversationId,
    int limit = 100,
    int offset = 0,
  }) async {
    try {
      final models = await repository.get<MessageModel>(
        policy: OfflineFirstGetPolicy.alwaysHydrate,
        query: Query.where('conversationId', conversationId)
            .orderBy('createdAt', descending: true)
            .limit(limit)
            .offset(offset),
      );

      return Right(models.map((m) => m.toDomain()).toList());
    } on OfflineFirstException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| In-memory mock chat data | Brick offline-first models | Phase 5 (this phase) | Persistent cache, offline viewing, realtime sync |
| Hive @HiveType models | Brick @ConnectOfflineFirstWithSupabase | Brick 2.1.0 (2024) | Auto Supabase sync, realtime subscriptions |
| Pre-cache all conversations | Lazy caching (awaitRemoteWhenNoneExist) | Phase 3 pattern | Reduced storage, cache-on-demand |
| Unlimited message history | 100 messages per conversation | Phase 5 decision | Prevents unbounded growth |
| Manual Supabase realtime | Brick subscribeToRealtime<MessageModel>() | Phase 4 pattern | Auto-upsert, less boilerplate |

**Deprecated/outdated:**
- **ChatDataSourceImpl mock data**: Replaced by Brick models with real Supabase sync
- **Hive ConversationModel/MessageModel**: Migrated to Brick offline-first models
- **Manual conversation caching**: Replaced by lazy caching policy

## Open Questions

Things that couldn't be fully resolved:

1. **How to handle pinned conversations?**
   - What we know: CONTEXT.md specifies "pinned conversations first" in ordering
   - What's unclear: Whether `conversations` table has `is_pinned` boolean column or separate table
   - Recommendation: Add `@Supabase(name: 'is_pinned') final bool isPinned;` field to ConversationModel, sort by isPinned DESC, updatedAt DESC. Verify schema during implementation.

2. **What triggers unread count reset?**
   - What we know: Unread badge should show count, UI requirement is unread tracking
   - What's unclear: When to mark messages as read (on open conversation, on scroll, on visibility?)
   - Recommendation: Mark all messages as read when conversation opened (call markMessagesAsRead in ChatDetailBloc.onLoadMessages). Update local unreadCount in ConversationModel.

3. **How to handle message deletion?**
   - What we know: Supabase chat_messages table exists, domain has Message entity
   - What's unclear: Whether messages can be deleted, soft vs hard delete
   - Recommendation: Defer to Phase 7 (write actions). For now, no delete functionality offline.

4. **What is 30-day conversation eviction strategy?**
   - What we know: CONTEXT.md says "cache conversations accessed in last 30 days"
   - What's unclear: How to track "last accessed" timestamp
   - Recommendation: Add `@Supabase(ignore: true) @Sqlite() final DateTime? lastAccessedAt` to ConversationModel. Update on getMessages() call. Implement eviction service that deletes conversations where lastAccessedAt < 30 days ago.

5. **Should video/image messages cache media files?**
   - What we know: CONTEXT.md says "uncached media: show placeholder with download option when online"
   - What's unclear: Whether to cache thumbnails or full media
   - Recommendation: Cache thumbnail URLs only, not media blobs. Phase 6 handles media caching limits.

## Sources

### Primary (HIGH confidence)
- Supabase Flutter Documentation via MCP (HIGH confidence)
  - conversations table schema: id, is_group, group_name, last_message, last_message_at, created_at, updated_at
  - conversation_members table: conversation_id, user_id, role, joined_at, last_read_at
  - chat_messages table: id, conversation_id, sender_id, content, type, created_at
- GitHub GetDutchie/Brick offline-first with Supabase
  - subscribeToRealtime method for message sync
  - OfflineFirstGetPolicy.awaitRemoteWhenNoneExist for lazy caching
- Phase 2 Research (.planning/phases/02-stories-feature/02-RESEARCH.md)
  - Brick model patterns, foreign key associations
  - toDomain() and fromDomain() conversion methods
- Phase 4 Research (.planning/phases/04-social-feed-feature/04-RESEARCH.md)
  - Nullable author pattern for cache resilience
  - Realtime subscription lifecycle management

### Secondary (MEDIUM confidence)
- Existing MyItihas codebase
  - Chat domain entities (lib/features/chat/domain/entities/*.dart)
  - ChatRepository interface (lib/features/chat/domain/repositories/chat_repository.dart)
  - Current mock implementation (lib/features/chat/data/datasources/chat_data_source.dart)
- Phase 3 Research (lazy caching pattern)
  - awaitRemoteWhenNoneExist policy for conversation list
  - Offline error snackbar implementation

### Tertiary (LOW confidence)
- None - all findings verified with codebase and official docs

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - Using existing Brick packages from Phase 1, no new dependencies
- Architecture: HIGH - Verified patterns from Phase 2/4, Supabase schema from MCP
- Pitfalls: MEDIUM - Based on Phase 2/4 learnings, chat-specific issues may emerge
- Realtime sync: HIGH - subscribeToRealtime documented and used in Phase 4
- Many-to-many handling: MEDIUM - Manual conversation_members loading required, not Brick built-in

**Research date:** 2026-01-30
**Valid until:** 2026-03-01 (30 days - stable packages, established patterns)
