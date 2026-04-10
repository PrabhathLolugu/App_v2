import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/theme/chat_message_typography.dart';
import 'package:myitihas/core/network/network_info.dart';
import 'package:myitihas/core/presentation/widgets/require_online_or_notify.dart';
import 'package:myitihas/core/utils/app_error_message.dart';
import 'package:myitihas/core/utils/chat_mention_parser.dart';
import 'package:myitihas/core/utils/chat_url_parser.dart';
import 'package:myitihas/core/utils/group_system_message_formatter.dart';
import 'package:myitihas/core/widgets/profile_avatar/profile_avatar.dart';
import 'package:myitihas/core/widgets/voice_input/voice_input_button.dart';
import 'package:myitihas/features/chat/presentation/widgets/shared_content_preview_widget.dart';
import 'package:myitihas/models/chat_message.dart';
import 'package:myitihas/models/chat_poll_summary.dart';
import 'package:myitihas/models/message_reaction.dart';
import 'package:myitihas/pages/Chat/Widget/chat_special_message_widgets.dart';
import 'package:myitihas/pages/Chat/Widget/forward_message_sheet.dart';
import 'package:myitihas/profile/profile_image_viewer.dart';
import 'package:myitihas/services/chat_service.dart';
import 'package:myitihas/services/fcm_service.dart';
import 'package:myitihas/services/supabase_service.dart';
import 'package:myitihas/services/user_block_service.dart';
import 'package:myitihas/services/user_report_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// Enum to represent the validation status before navigating to a user's profile
enum UserNavigationStatus {
  /// User exists and no blocking restrictions - safe to navigate
  canNavigate,

  /// User account has been deleted
  userDeleted,

  /// Current user has blocked this user
  blockedByUs,

  /// This user has blocked the current user
  blockedByThem,
}

class _ResolvedMentionMatch {
  final int start;
  final int end;
  final String display;
  final String? userId;

  const _ResolvedMentionMatch({
    required this.start,
    required this.end,
    required this.display,
    required this.userId,
  });

  bool get canNavigate => userId != null && userId!.trim().isNotEmpty;
}

class _LegacyMentionAlias {
  final String display;
  final String displayLower;
  final Set<String> userIds;

  _LegacyMentionAlias({
    required this.display,
    required this.displayLower,
    required this.userIds,
  });
}

class _MessageTextToken {
  final int start;
  final int end;
  final ChatUrlMatch? urlMatch;
  final _ResolvedMentionMatch? mentionMatch;

  const _MessageTextToken._({
    required this.start,
    required this.end,
    this.urlMatch,
    this.mentionMatch,
  });

  factory _MessageTextToken.url(ChatUrlMatch match) {
    return _MessageTextToken._(
      start: match.start,
      end: match.end,
      urlMatch: match,
    );
  }

  factory _MessageTextToken.mention(_ResolvedMentionMatch match) {
    return _MessageTextToken._(
      start: match.start,
      end: match.end,
      mentionMatch: match,
    );
  }

  bool get isMention => mentionMatch != null;
}

class ChatDetailPage extends StatefulWidget {
  final String? conversationId; // Now nullable
  final String userId;
  final String name;
  final String? avatarUrl;
  final String? avatarColor;
  final bool isGroup; // Added parameter

  const ChatDetailPage({
    super.key,
    this.conversationId, // Optional
    required this.userId,
    required this.name,
    this.avatarUrl,
    this.avatarColor,
    this.isGroup = false, // Default false
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final ChatService _chatService = getIt<ChatService>();
  final FCMService _fcmService = getIt<FCMService>();
  final NetworkInfo _networkInfo = getIt<NetworkInfo>();
  final UserBlockService _blockService = getIt<UserBlockService>();
  final UserReportService _reportService = getIt<UserReportService>();
  final TextEditingController _messageController = TextEditingController();
  final Set<int> _selectedMessageIndices = {};
  bool get _isSelectionMode => _selectedMessageIndices.isNotEmpty;

  // Group mention state
  List<Map<String, dynamic>> _groupMembers = [];
  List<Map<String, dynamic>> _mentionSuggestions = [];
  bool _showMentionSuggestions = false;

  List<ChatMessage> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;
  StreamSubscription<ChatRealtimeEvent>? _messageSubscription;
  StreamSubscription<ChatRealtimeReactionEvent>? _reactionSubscription;
  StreamSubscription<ChatRealtimePollVoteEvent>? _pollVoteSubscription;
  String? _currentUserId;
  bool _messageSent = false;
  String? _conversationId; // Mutable conversation ID
  bool _isBlocked = false; // Track if user is blocked
  ChatMessage? _replyToMessage;
  bool _conversationCleared =
      false; // True when user deleted all messages for themselves
  Timer?
  _markAsReadDebounce; // Debounce timer for auto-read on incoming messages

  // Reactions state: messageId -> summary
  final Map<String, MessageReactionsSummary> _reactions = {};
  final Map<String, ChatPollSummary> _pollSummariesByMessageId = {};
  String? _pollVoteSubmittingMessageId;
  final ImagePicker _imagePicker = ImagePicker();
  static const int _maxImageBytes = 5 * 1024 * 1024;
  static const int _maxDocumentBytes = 5 * 1024 * 1024;
  static const Set<String> _allowedDocumentExtensions = {
    'pdf',
    'doc',
    'docx',
    'ppt',
    'pptx',
    'xls',
    'xlsx',
    'csv',
  };

  /// WhatsApp-style quick reactions in order: 👍❤️😂😮😢🙏
  static const List<String> _quickReactions = [
    '👍',
    '❤️',
    '😂',
    '😮',
    '😢',
    '🙏',
  ];

  @override
  void initState() {
    super.initState();
    _currentUserId = SupabaseService.client.auth.currentUser?.id;
    _conversationId = widget.conversationId; // Initialize from widget
    _messageController.addListener(_handleMessageTextChanged);
    _checkBlockStatus(); // Check if user is blocked
    if (_conversationId != null) {
      _loadMessages();
      _subscribeToMessages();
      _loadReactions();
      _subscribeToReactions();
      _subscribeToPollVotes();
      // Mark conversation as read when user opens the chat
      _chatService.markConversationAsRead(_conversationId!);
      unawaited(
        _fcmService.clearChatNotificationForConversation(_conversationId!),
      );
      if (widget.isGroup) {
        _loadGroupMembers();
      }
    } else {
      // No conversation yet, just show empty state
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _reactionSubscription?.cancel();
    _pollVoteSubscription?.cancel();
    _markAsReadDebounce?.cancel();
    _messageController.removeListener(_handleMessageTextChanged);
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    if (_conversationId == null) return; // No conversation yet
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(kConnectToInternetMessage)),
        );
      }
      setState(() => _isLoading = false);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final messages = await _chatService.getMessages(_conversationId!);
      setState(() {
        _messages = messages;
        _isLoading = false;
      });
      unawaited(_syncPollSummaries(messages));
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              toUserFriendlyErrorMessage(
                e,
                fallback: 'Unable to load messages right now.',
              ),
            ),
          ),
        );
      }
    }
  }

  Future<void> _loadReactions() async {
    if (_conversationId == null) return;
    try {
      final result = await _chatService.getReactionsForConversation(
        _conversationId!,
      );
      if (!mounted) return;
      setState(() {
        _reactions.clear();
        result.countsByMessage.forEach((messageId, counts) {
          _reactions[messageId] = MessageReactionsSummary(
            messageId: messageId,
            counts: Map<String, int>.from(counts),
            currentUserEmoji: result.currentUserEmojiByMessage[messageId],
          );
        });
      });
    } catch (_) {
      // Safe to ignore; chat still works without reactions.
    }
  }

  void _subscribeToMessages() {
    if (_conversationId == null) return; // No conversation yet

    _messageSubscription = _chatService
        .subscribeToMessages(_conversationId!)
        .listen((event) {
          setState(() {
            if (event.type == ChatRealtimeChangeType.insert &&
                event.message != null) {
              _messages.add(event.message!);
              if (event.message!.type?.toLowerCase() == 'poll') {
                unawaited(_refetchPollSummary(event.message!.id));
              }

              // Auto-mark incoming messages from other users as read (debounced)
              // This keeps the home badge accurate while conversation is open
              if (event.message!.senderId != _currentUserId) {
                _debounceMarkAsRead();
              }
            } else if (event.type == ChatRealtimeChangeType.delete &&
                event.messageId != null) {
              _messages.removeWhere((m) => m.id == event.messageId);
            }
          });
        });
  }

  void _subscribeToPollVotes() {
    if (_conversationId == null) return;
    _pollVoteSubscription?.cancel();
    _pollVoteSubscription = _chatService
        .subscribeToChatPollVotes(_conversationId!)
        .listen((event) {
          unawaited(_refetchPollSummary(event.messageId));
        });
  }

  Future<void> _syncPollSummaries(List<ChatMessage> messages) async {
    final pollIds = messages
        .where((m) => m.type?.toLowerCase() == 'poll')
        .map((m) => m.id)
        .where((id) => !id.startsWith('temp_'))
        .toList();
    final messageIdSet = messages.map((m) => m.id).toSet();
    if (pollIds.isEmpty) {
      if (!mounted) return;
      setState(() {
        _pollSummariesByMessageId.removeWhere(
          (k, _) => !messageIdSet.contains(k),
        );
      });
      return;
    }
    final summaries = await _chatService.getChatPollSummaries(pollIds);
    if (!mounted) return;
    setState(() {
      for (final s in summaries) {
        _pollSummariesByMessageId[s.messageId] = s;
      }
      _pollSummariesByMessageId.removeWhere(
        (k, _) => !messageIdSet.contains(k),
      );
    });
  }

  Future<void> _refetchPollSummary(String messageId) async {
    final summaries = await _chatService.getChatPollSummaries([messageId]);
    if (!mounted || summaries.isEmpty) return;
    setState(() {
      _pollSummariesByMessageId[messageId] = summaries.first;
    });
  }

  Future<void> _submitPollVote(ChatMessage msg, int optionIndex) async {
    if (_pollVoteSubmittingMessageId != null) return;
    setState(() => _pollVoteSubmittingMessageId = msg.id);
    try {
      await _chatService.submitChatPollVote(
        messageId: msg.id,
        optionIndex: optionIndex,
      );
      await _refetchPollSummary(msg.id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              toUserFriendlyErrorMessage(
                e,
                fallback: 'Could not record your vote.',
              ),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _pollVoteSubmittingMessageId = null);
      }
    }
  }

  Future<void> _openLocationInMaps(ChatLocationPayload loc) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${loc.lat},${loc.lng}',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.t.chat.composerAttachments.mapsUnavailable),
        ),
      );
    }
  }

  BoxDecoration _standardMessageBubbleDecoration(
    BuildContext context,
    bool isMe,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isMe
          ? (isDark ? const Color(0xFF1E6FE8) : const Color(0xFF0B78FF))
          : colorScheme.surfaceContainerHigh.withValues(alpha: 0.9),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.sp),
        topRight: Radius.circular(16.sp),
        bottomLeft: isMe ? Radius.circular(16.sp) : Radius.circular(0),
        bottomRight: isMe ? Radius.circular(0) : Radius.circular(16.sp),
      ),
    );
  }

  void _showChatAttachmentMenu() {
    if (_conversationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You can only share after the chat request is accepted.',
          ),
        ),
      );
      return;
    }
    final t = context.t.chat.composerAttachments;
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.poll_outlined, color: colorScheme.primary),
                title: Text(t.poll),
                onTap: () {
                  Navigator.pop(ctx);
                  _openPollComposer();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: Text(t.camera),
                onTap: () {
                  Navigator.pop(ctx);
                  unawaited(
                    _pickAndSendImage(source: ImageSource.camera),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(t.photos),
                onTap: () {
                  Navigator.pop(ctx);
                  unawaited(
                    _pickAndSendImage(source: ImageSource.gallery),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file_outlined),
                title: const Text('Documents'),
                onTap: () {
                  Navigator.pop(ctx);
                  unawaited(_pickAndSendDocument());
                },
              ),
              ListTile(
                leading: const Icon(Icons.location_on_outlined),
                title: Text(t.location),
                onTap: () {
                  Navigator.pop(ctx);
                  unawaited(_confirmAndSendLocation());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmAndSendLocation() async {
    if (_conversationId == null || _isSending) return;
    final t = context.t.chat.composerAttachments;
    final go = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.locationPreviewTitle),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t.sendLocation),
          ),
        ],
      ),
    );
    if (go != true || !mounted) return;

    setState(() => _isSending = true);
    try {
      await _chatService.sendCurrentLocationMessage(
        conversationId: _conversationId!,
        contentLine: t.sharedLocationTitle,
      );
      _messageSent = true;
      await _refreshMessagesSilently();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              toUserFriendlyErrorMessage(
                e,
                fallback: 'Unable to send location.',
              ),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<void> _openPollComposer() async {
    if (_conversationId == null || _isSending) return;
    final t = context.t.chat.composerAttachments;
    final questionCtrl = TextEditingController();
    final optionCtrls = [
      TextEditingController(),
      TextEditingController(),
    ];

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        final bottomInset = MediaQuery.viewInsetsOf(sheetCtx).bottom;
        final colorScheme = Theme.of(sheetCtx).colorScheme;
        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        t.pollTitle,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w800,
                          fontSize: 16.sp,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 1.5.h),
                      TextField(
                        controller: questionCtrl,
                        decoration: InputDecoration(
                          labelText: t.pollQuestionHint,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      SizedBox(height: 1.2.h),
                      ...List.generate(optionCtrls.length, (i) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 1.h),
                          child: TextField(
                            controller: optionCtrls[i],
                            decoration: InputDecoration(
                              labelText: t.pollOptionHint(n: i + 1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        );
                      }),
                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: optionCtrls.length >= 4
                                ? null
                                : () {
                                    setModalState(() {
                                      optionCtrls.add(TextEditingController());
                                    });
                                  },
                            icon: const Icon(Icons.add),
                            label: Text(t.addOption),
                          ),
                          if (optionCtrls.length > 2)
                            TextButton.icon(
                              onPressed: () {
                                setModalState(() {
                                  optionCtrls.removeLast().dispose();
                                });
                              },
                              icon: const Icon(Icons.remove),
                              label: Text(t.removeOption),
                            ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      FilledButton(
                        onPressed: () async {
                          final q = questionCtrl.text.trim();
                          final opts = optionCtrls
                              .map((c) => c.text.trim())
                              .where((s) => s.isNotEmpty)
                              .toList();
                          if (q.isEmpty || opts.length < 2) {
                            ScaffoldMessenger.of(sheetCtx).showSnackBar(
                              SnackBar(content: Text(t.pollNeedTwoOptions)),
                            );
                            return;
                          }
                          if (opts.length > 4) {
                            ScaffoldMessenger.of(sheetCtx).showSnackBar(
                              SnackBar(content: Text(t.pollMaxOptions)),
                            );
                            return;
                          }
                          Navigator.pop(sheetCtx);
                          setState(() => _isSending = true);
                          try {
                            await _chatService.sendPollMessage(
                              conversationId: _conversationId!,
                              question: q,
                              options: opts,
                            );
                            _messageSent = true;
                            await _refreshMessagesSilently();
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    toUserFriendlyErrorMessage(
                                      e,
                                      fallback: 'Unable to send poll.',
                                    ),
                                  ),
                                ),
                              );
                            }
                          } finally {
                            if (mounted) setState(() => _isSending = false);
                          }
                        },
                        child: Text(t.sendPoll),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );

    questionCtrl.dispose();
    for (final c in optionCtrls) {
      c.dispose();
    }
  }

  /// Debounced mark-as-read to avoid excessive database writes.
  /// Cancels previous timer and schedules a new one for 500ms.
  void _debounceMarkAsRead() {
    _markAsReadDebounce?.cancel();
    _markAsReadDebounce = Timer(const Duration(milliseconds: 500), () {
      if (_conversationId != null && mounted) {
        _chatService.markConversationAsRead(_conversationId!);
        unawaited(
          _fcmService.clearChatNotificationForConversation(_conversationId!),
        );
      }
    });
  }

  void _subscribeToReactions() {
    if (_conversationId == null) return;
    _reactionSubscription = _chatService
        .subscribeToMessageReactions(_conversationId!)
        .listen((event) {
          setState(() {
            final messageId = event.messageId;
            final existing =
                _reactions[messageId] ??
                MessageReactionsSummary(
                  messageId: messageId,
                  counts: const {},
                  currentUserEmoji: _reactions[messageId]?.currentUserEmoji,
                );
            final counts = Map<String, int>.from(existing.counts);

            if (event.type == ChatRealtimeReactionChangeType.upsert) {
              counts[event.emoji] = (counts[event.emoji] ?? 0) + 1;
            } else if (event.type == ChatRealtimeReactionChangeType.delete) {
              final current = counts[event.emoji] ?? 0;
              if (current <= 1) {
                counts.remove(event.emoji);
              } else {
                counts[event.emoji] = current - 1;
              }
            }

            _reactions[messageId] = existing.copyWith(counts: counts);
          });
        });
  }

  void _insertEmoji(String emoji) {
    final controller = _messageController;
    final text = controller.text;
    final offset = controller.selection.baseOffset.clamp(0, text.length);
    final newText = text.substring(0, offset) + emoji + text.substring(offset);
    controller.text = newText;
    controller.selection = TextSelection.collapsed(
      offset: offset + emoji.length,
    );
  }

  Future<void> _handleReactionTap(ChatMessage message, String emoji) async {
    final currentSummary = _reactions[message.id];
    final currentUserEmoji = currentSummary?.currentUserEmoji;

    // Tapping same emoji again removes reaction.
    if (currentUserEmoji == emoji) {
      setState(() {
        if (currentSummary != null) {
          final counts = Map<String, int>.from(currentSummary.counts);
          final current = counts[emoji] ?? 0;
          if (current <= 1) {
            counts.remove(emoji);
          } else {
            counts[emoji] = current - 1;
          }
          _reactions[message.id] = currentSummary.copyWith(
            counts: counts,
            currentUserEmoji: null,
          );
        }
      });
      await _chatService.clearReaction(messageId: message.id);
      return;
    }

    // Selecting a new emoji replaces previous reaction.
    setState(() {
      final counts = Map<String, int>.from(
        currentSummary?.counts ?? <String, int>{},
      );
      if (currentUserEmoji != null && counts.containsKey(currentUserEmoji)) {
        final prev = counts[currentUserEmoji] ?? 0;
        if (prev <= 1) {
          counts.remove(currentUserEmoji);
        } else {
          counts[currentUserEmoji] = prev - 1;
        }
      }
      counts[emoji] = (counts[emoji] ?? 0) + 1;
      _reactions[message.id] = MessageReactionsSummary(
        messageId: message.id,
        counts: counts,
        currentUserEmoji: emoji,
      );
    });

    await _chatService.setReaction(
      conversationId: message.conversationId,
      messageId: message.id,
      emoji: emoji,
    );
  }

  /// Shows reactions and message options; uses bottom sheet so it works without overlay positioning.
  void _showMessageContextMenuWithFallback(
    BuildContext context,
    ChatMessage message,
    int index,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMine = message.senderId == _currentUserId;
    final canDeleteForEveryone = isMine;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colorScheme.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'React',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  for (final emoji in _quickReactions)
                    Padding(
                      padding: EdgeInsets.only(right: 2.w),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.of(ctx).pop();
                          _handleReactionTap(message, emoji);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(emoji, style: TextStyle(fontSize: 22.sp)),
                        ),
                      ),
                    ),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      _showMoreReactions(context, message);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primary.withValues(alpha: 0.08),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 18.sp,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                'Message options',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 0.5.h),
              _buildMessageContextAction(
                icon: Icons.reply_rounded,
                label: 'Reply',
                onTap: () {
                  Navigator.of(ctx).pop();
                  _setReplyMessage(message);
                },
                colorScheme: colorScheme,
              ),
              _buildMessageContextAction(
                icon: Icons.reply_rounded,
                label: 'Forward',
                onTap: () async {
                  Navigator.of(ctx).pop();
                  await _forwardSingleMessage(message);
                },
                colorScheme: colorScheme,
                flipIcon: true,
              ),
              _buildMessageContextAction(
                icon: Icons.copy_rounded,
                label: 'Copy',
                onTap: () {
                  Navigator.of(ctx).pop();
                  _copySingleMessage(message);
                },
                colorScheme: colorScheme,
              ),
              _buildMessageContextAction(
                icon: Icons.info_outline_rounded,
                label: 'Info',
                onTap: () {
                  Navigator.of(ctx).pop();
                  _showMessageInfo(message);
                },
                colorScheme: colorScheme,
              ),
              _buildMessageContextAction(
                icon: Icons.delete_outline_rounded,
                label: 'Delete for me',
                onTap: () async {
                  Navigator.of(ctx).pop();
                  await _deleteMessageForMe(index);
                },
                colorScheme: colorScheme,
              ),
              if (canDeleteForEveryone)
                _buildMessageContextAction(
                  icon: Icons.delete_forever_outlined,
                  label: 'Delete for everyone',
                  onTap: () async {
                    Navigator.of(ctx).pop();
                    await _deleteMessageForEveryone(index);
                  },
                  colorScheme: colorScheme,
                  isDestructive: true,
                ),
              _buildMessageContextAction(
                icon: Icons.select_all_outlined,
                label: 'Select',
                onTap: () {
                  Navigator.of(ctx).pop();
                  _toggleSelection(index);
                },
                colorScheme: colorScheme,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageContextAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
    bool isDestructive = false,
    bool flipIcon = false,
  }) {
    final color = isDestructive ? colorScheme.error : colorScheme.onSurface;
    final iconWidget = flipIcon
        ? Transform.flip(flipX: true, child: Icon(icon, size: 20, color: color))
        : Icon(icon, size: 20, color: color);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget,
            SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessageInfo(ChatMessage message) {
    final payload = _parseReplyPayload(message.content);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Message info',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 12),
              _infoRow('Time', _formatTime(message.createdAt)),
              if (message.senderId != _currentUserId && widget.isGroup)
                _infoRow('From', message.senderName ?? 'Unknown'),
              _infoRow('Preview', _previewText(payload.body, max: 120)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
          Expanded(child: Text(value, style: GoogleFonts.inter(fontSize: 13))),
        ],
      ),
    );
  }

  void _showReactionPicker(BuildContext context, ChatMessage message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 4.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'React to message',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (final emoji in _quickReactions)
                      Padding(
                        padding: EdgeInsets.only(right: 2.w),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            Navigator.of(ctx).pop();
                            _handleReactionTap(message, emoji);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(
                              emoji,
                              style: TextStyle(fontSize: 22.sp),
                            ),
                          ),
                        ),
                      ),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.of(ctx).pop();
                        _showMoreReactions(context, message);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.primary.withValues(alpha: 0.08),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 18.sp,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMoreReactions(BuildContext context, ChatMessage message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    const moreEmojis = [
      '😀',
      '😃',
      '😄',
      '😁',
      '😅',
      '😂',
      '🤣',
      '😊',
      '😇',
      '🙂',
      '😉',
      '😍',
      '🥰',
      '😘',
      '😗',
      '😋',
      '😛',
      '😜',
      '🤪',
      '😝',
      '👏',
      '🙌',
      '🤝',
      '🔥',
      '💯',
      '✅',
      '❌',
      '❗',
      '❓',
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surfaceContainerHighest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'More reactions',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 1.h),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: moreEmojis
                    .map(
                      (e) => GestureDetector(
                        onTap: () {
                          Navigator.of(ctx).pop();
                          _handleReactionTap(message, e);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(e, style: TextStyle(fontSize: 24.sp)),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEmojiPicker(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    const emojis = [
      '😀',
      '😃',
      '😄',
      '😁',
      '😅',
      '😂',
      '🤣',
      '😊',
      '😇',
      '🙂',
      '😉',
      '😍',
      '🥰',
      '😘',
      '😗',
      '😋',
      '😛',
      '😜',
      '🤪',
      '😝',
      '👍',
      '👎',
      '👏',
      '🙌',
      '🤝',
      '🙏',
      '❤️',
      '🧡',
      '💛',
      '💚',
      '💙',
      '💜',
      '🖤',
      '🤍',
      '💕',
      '💖',
      '💗',
      '💘',
      '✨',
      '⭐',
      '🔥',
      '💯',
      '✅',
      '❌',
      '❗',
      '❓',
      '💬',
      '📝',
      '📌',
      '🔔',
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surfaceContainerHighest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose emoji',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12.h),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: emojis.map((emoji) {
                  return GestureDetector(
                    onTap: () {
                      _insertEmoji(emoji);
                      Navigator.of(ctx).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(emoji, style: const TextStyle(fontSize: 28)),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _checkBlockStatus() async {
    if (widget.isGroup) return; // Don't check for groups

    try {
      // Consider the DM blocked if either:
      // - the current user has blocked the other user, or
      // - the other user has blocked the current user.
      final iBlockedOther = await _blockService.isUserBlocked(widget.userId);
      final otherBlockedMe = await _blockService.hasBlockedMe(widget.userId);
      final blocked = iBlockedOther || otherBlockedMe;
      setState(() {
        _isBlocked = blocked;
      });
    } catch (e) {
      // Silently fail, assume not blocked
      setState(() {
        _isBlocked = false;
      });
    }
  }

  Future<void> _loadGroupMembers() async {
    if (!widget.isGroup || _conversationId == null) return;
    try {
      final members = await _chatService.getConversationMembers(
        _conversationId!,
      );
      if (!mounted) return;
      setState(() {
        _groupMembers = members
            .where(
              (m) =>
                  m['id'] is String &&
                  m['id'] != null &&
                  m['id'] != _currentUserId,
            )
            .toList();
      });
    } catch (_) {
      // Safe to ignore – mentions are an enhancement
    }
  }

  void _handleMessageTextChanged() {
    if (!widget.isGroup ||
        _groupMembers.isEmpty ||
        !_messageController.selection.isValid) {
      if (_showMentionSuggestions) {
        setState(() {
          _showMentionSuggestions = false;
          _mentionSuggestions = [];
        });
      }
      return;
    }

    final text = _messageController.text;
    final cursor = _messageController.selection.baseOffset;
    if (cursor <= 0 || cursor > text.length) {
      if (_showMentionSuggestions) {
        setState(() {
          _showMentionSuggestions = false;
          _mentionSuggestions = [];
        });
      }
      return;
    }

    final beforeCursor = text.substring(0, cursor);
    final atIndex = beforeCursor.lastIndexOf('@');
    if (atIndex == -1) {
      if (_showMentionSuggestions) {
        setState(() {
          _showMentionSuggestions = false;
          _mentionSuggestions = [];
        });
      }
      return;
    }

    // Ensure '@' starts a token (start of text or preceded by whitespace)
    if (atIndex > 0) {
      final prevChar = beforeCursor[atIndex - 1];
      if (prevChar.trim().isNotEmpty) {
        if (_showMentionSuggestions) {
          setState(() {
            _showMentionSuggestions = false;
            _mentionSuggestions = [];
          });
        }
        return;
      }
    }

    final query = beforeCursor.substring(atIndex + 1);
    // Stop if query already contains whitespace (user finished the mention)
    if (query.contains(' ') || query.contains('\n') || query.contains('\t')) {
      if (_showMentionSuggestions) {
        setState(() {
          _showMentionSuggestions = false;
          _mentionSuggestions = [];
        });
      }
      return;
    }

    final lowerQuery = query.toLowerCase();
    final suggestions = _groupMembers.where((member) {
      final fullName = (member['full_name'] as String?) ?? '';
      final username = (member['username'] as String?) ?? '';
      if (lowerQuery.isEmpty) {
        return true;
      }
      return fullName.toLowerCase().contains(lowerQuery) ||
          username.toLowerCase().contains(lowerQuery);
    }).toList();

    setState(() {
      _mentionSuggestions = suggestions;
      _showMentionSuggestions = suggestions.isNotEmpty;
    });
  }

  void _insertMention(Map<String, dynamic> member) {
    final text = _messageController.text;
    final selection = _messageController.selection;
    if (!selection.isValid) return;
    final cursor = selection.baseOffset;
    if (cursor < 0 || cursor > text.length) return;

    final beforeCursor = text.substring(0, cursor);
    final afterCursor = text.substring(cursor);
    final atIndex = beforeCursor.lastIndexOf('@');
    if (atIndex == -1) return;

    final prefix = beforeCursor.substring(0, atIndex);
    final displayName = (member['full_name'] as String?)?.trim();
    final username = (member['username'] as String?)?.trim();
    final mentionedUserId = (member['id'] as String?)?.trim();
    final name = (displayName != null && displayName.isNotEmpty)
        ? displayName
        : (username != null && username.isNotEmpty ? username : 'user');

    final mentionText = mentionedUserId != null && mentionedUserId.isNotEmpty
        ? ChatMentionParser.encode(display: name, userId: mentionedUserId)
        : '@$name';
    final newText = '$prefix$mentionText $afterCursor';
    final newCursor = (prefix + mentionText + ' ').length;

    _messageController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursor),
    );

    setState(() {
      _showMentionSuggestions = false;
      _mentionSuggestions = [];
    });
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty || _isSending) return;

    // Dismiss keyboard when user sends
    FocusScope.of(context).unfocus();

    setState(() {
      _isSending = true;
    });

    try {
      // For DMs, conversation only exists after the other user accepts the message request
      if (_conversationId == null) {
        setState(() {
          _isSending = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'You can only chat after they accept your request. Send a request from New Chat.',
              ),
            ),
          );
        }
        return;
      }

      final payload = _buildReplyPayload(content, _replyToMessage);

      // Optimistically add message to UI
      final optimisticId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
      final optimisticMessage = ChatMessage(
        id: optimisticId,
        conversationId: _conversationId!,
        senderId: _currentUserId!,
        content: payload,
        createdAt: DateTime.now(), // Local time for display
      );

      setState(() {
        _messages.add(optimisticMessage);
      });

      _messageController.clear();

      await _chatService.sendMessage(
        conversationId: _conversationId!,
        content: payload,
      );
      _messageSent = true;
      setState(() {
        _messages.removeWhere((msg) => msg.id == optimisticId);
        _replyToMessage = null;
      });
      await _refreshMessagesSilently();
    } catch (e) {
      // Remove optimistic message on error
      if (_messages.isNotEmpty) {
        setState(() {
          _messages.removeWhere((msg) => msg.id.startsWith('temp_'));
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              toUserFriendlyErrorMessage(
                e,
                fallback: 'Unable to send message right now.',
              ),
            ),
          ),
        );
      }
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  Future<void> _pickAndSendImage({ImageSource source = ImageSource.gallery}) async {
    if (_isSending) return;

    if (_conversationId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'You can only share images after the chat request is accepted.',
            ),
          ),
        );
      }
      return;
    }

    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 90,
      );
      if (picked == null) return;

      final file = File(picked.path);
      final size = await file.length();
      if (size > _maxImageBytes) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image must be 5 MB or smaller.')),
          );
        }
        return;
      }

      if (!mounted) return;
      final caption = await _showImageCaptionSheet(
        file,
        initialCaption: _messageController.text.trim(),
      );
      if (caption == null) {
        return;
      }

      setState(() {
        _isSending = true;
      });

      await _chatService.sendImageMessage(
        conversationId: _conversationId!,
        imageFile: file,
        caption: caption,
      );

      _messageController.clear();
      _replyToMessage = null;
      _messageSent = true;
      await _refreshMessagesSilently();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              toUserFriendlyErrorMessage(
                e,
                fallback: 'Unable to send image right now.',
              ),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  Future<void> _pickAndSendDocument() async {
    if (_isSending) return;

    if (_conversationId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'You can only share documents after the chat request is accepted.',
            ),
          ),
        );
      }
      return;
    }

    try {
      final picked = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: _allowedDocumentExtensions.toList(),
      );

      if (picked == null || picked.files.isEmpty) {
        return;
      }

      final fileMeta = picked.files.single;
      final filePath = fileMeta.path;
      if (filePath == null || filePath.trim().isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unable to access selected file.')),
          );
        }
        return;
      }

      final extension = p.extension(fileMeta.name).replaceFirst('.', '').toLowerCase();
      if (!_allowedDocumentExtensions.contains(extension)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('This file format is not supported yet.'),
            ),
          );
        }
        return;
      }

      final fileSize = fileMeta.size;
      if (fileSize > _maxDocumentBytes) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Document must be 5 MB or smaller.')),
          );
        }
        return;
      }

      final file = File(filePath);
      if (!await file.exists()) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Selected file no longer exists.')),
          );
        }
        return;
      }

      setState(() {
        _isSending = true;
      });

      await _chatService.sendDocumentMessage(
        conversationId: _conversationId!,
        documentFile: file,
        fileName: fileMeta.name,
      );

      _messageController.clear();
      _replyToMessage = null;
      _messageSent = true;
      await _refreshMessagesSilently();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              toUserFriendlyErrorMessage(
                e,
                fallback: 'Unable to send document right now.',
              ),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  bool _isImageAttachment(ChatMessage message, ChatAttachment attachment) {
    final mime = (attachment.mimeType ?? '').toLowerCase();
    if (mime.startsWith('image/')) {
      return true;
    }
    return mime.isEmpty && (message.type?.toLowerCase() == 'image');
  }

  String _documentDisplayName(ChatMessage message, ChatAttachment attachment) {
    final content = message.content.trim();
    if (content.isNotEmpty) return content;
    return p.basename(attachment.objectPath);
  }

  String _formatAttachmentSize(int? sizeBytes) {
    if (sizeBytes == null || sizeBytes <= 0) return '';
    if (sizeBytes < 1024) return '$sizeBytes B';
    final kb = sizeBytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(1)} MB';
  }

  Future<void> _showDocumentActions(
    ChatMessage message,
    ChatAttachment attachment,
  ) async {
    final signedUrl = attachment.signedUrl;
    if (signedUrl == null || signedUrl.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Document link is unavailable.')),
        );
      }
      return;
    }

    final docName = _documentDisplayName(message, attachment);

    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetCtx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.open_in_new_outlined),
              title: const Text('Open document'),
              onTap: () async {
                Navigator.pop(sheetCtx);
                final uri = Uri.tryParse(signedUrl);
                if (uri == null) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid document link.')),
                  );
                  return;
                }
                final opened = await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication,
                );
                if (!opened && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open document.')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: const Text('Share document link'),
              onTap: () async {
                Navigator.pop(sheetCtx);
                await SharePlus.instance.share(
                  ShareParams(text: signedUrl, subject: docName),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showImageCaptionSheet(
    File imageFile, {
    String initialCaption = '',
  }) async {
    final captionController = TextEditingController(text: initialCaption);

    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final colorScheme = Theme.of(sheetContext).colorScheme;
        final textColor = colorScheme.onSurface;
        // iOS: use viewPadding for home indicator safe area
        // Android: use viewInsets for keyboard height
        final bottomInset = Platform.isIOS
            ? MediaQuery.of(sheetContext).viewPadding.bottom
            : MediaQuery.of(sheetContext).viewInsets.bottom;

        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(4.w, 1.5.h, 4.w, 2.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10.w,
                      height: 0.5.h,
                      decoration: BoxDecoration(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.8,
                        ),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.file(imageFile, fit: BoxFit.cover),
                      ),
                    ),
                    SizedBox(height: 1.6.h),
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 3.5.w),
                      child: TextField(
                        controller: captionController,
                        minLines: 1,
                        maxLines: 4,
                        style: GoogleFonts.inter(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Add a caption',
                          hintStyle: GoogleFonts.inter(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 1.4.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(sheetContext).pop(),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 1.2.h),
                              side: BorderSide(
                                color: colorScheme.outlineVariant,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 2.5.w),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(
                                sheetContext,
                              ).pop(captionController.text.trim());
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 1.2.h),
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            icon: Icon(Icons.send_rounded, size: 16.sp),
                            label: Text(
                              'Send',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    captionController.dispose();
    return result;
  }

  Iterable<InlineSpan> _buildMessageTextSpans(
    String text,
    bool isMe,
    Color textColor,
  ) {
    final spans = <InlineSpan>[];
    final baseStyle = GoogleFonts.inter(
      color: textColor,
      fontWeight: FontWeight.w400,
      fontSize: 15.sp,
      height: ChatMessageTypography.lineHeight,
      letterSpacing: ChatMessageTypography.letterSpacing,
    );
    final mentionMatches = widget.isGroup
        ? _extractMentionMatches(text)
        : const <_ResolvedMentionMatch>[];
    final urlMatches = ChatUrlParser.extractMatches(text)
        .where(
          (url) => !mentionMatches.any(
            (mention) =>
                _rangesOverlap(url.start, url.end, mention.start, mention.end),
          ),
        )
        .toList();
    final tokens =
        <_MessageTextToken>[
          ...mentionMatches.map(_MessageTextToken.mention),
          ...urlMatches.map(_MessageTextToken.url),
        ]..sort((a, b) {
          if (a.start != b.start) {
            return a.start.compareTo(b.start);
          }
          if (a.isMention == b.isMention) {
            return 0;
          }
          return a.isMention ? -1 : 1;
        });
    var currentIndex = 0;

    for (final token in tokens) {
      if (token.start > currentIndex) {
        spans.add(
          TextSpan(
            text: text.substring(currentIndex, token.start),
            style: baseStyle,
          ),
        );
      }

      if (token.isMention) {
        final mention = token.mentionMatch!;
        final mentionForeground = isMe
          ? Colors.white
            : Theme.of(context).colorScheme.primary;
        final mentionBackground = isMe
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.24)
            : Theme.of(context).colorScheme.primary.withValues(alpha: 0.16);

        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: GestureDetector(
              onTap: mention.canNavigate
                  ? () => _onMentionTap(mention.userId)
                  : null,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 0.8.w,
                  vertical: 0.15.h,
                ),
                decoration: BoxDecoration(
                  color: mentionBackground,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  '@${mention.display}',
                  style: GoogleFonts.inter(
                    color: mentionForeground,
                    fontWeight: FontWeight.w700,
                    fontSize: 15.sp,
                    height: ChatMessageTypography.lineHeight,
                  ),
                ),
              ),
            ),
          ),
        );
      } else {
        final match = token.urlMatch!;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final linkColor = isMe
            ? const Color(0xFFBBF7D0)
            : (isDark ? const Color(0xFF4ADE80) : const Color(0xFF15803D));
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: GestureDetector(
              onTap: () => _openMessageUrl(match.cleaned),
              child: Text(
                match.cleaned,
                style: GoogleFonts.inter(
                  color: linkColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                  height: ChatMessageTypography.lineHeight,
                  decoration: TextDecoration.underline,
                  decorationColor: linkColor,
                ),
              ),
            ),
          ),
        );

        if (match.trailing.isNotEmpty) {
          spans.add(TextSpan(text: match.trailing, style: baseStyle));
        }
      }

      currentIndex = token.end;
    }

    if (currentIndex < text.length) {
      spans.add(TextSpan(text: text.substring(currentIndex), style: baseStyle));
    }

    if (spans.isEmpty) {
      spans.add(
        TextSpan(text: ChatMentionParser.toDisplayText(text), style: baseStyle),
      );
    }

    return spans;
  }

  bool _rangesOverlap(int startA, int endA, int startB, int endB) {
    return startA < endB && startB < endA;
  }

  bool _isInsideMatch(int index, List<_ResolvedMentionMatch> matches) {
    for (final match in matches) {
      if (index >= match.start && index < match.end) {
        return true;
      }
    }
    return false;
  }

  bool _isMentionPrefixBoundary(String text, int mentionStart) {
    if (mentionStart == 0) {
      return true;
    }
    const boundaryChars = ' \n\r\t([{"\'';
    return boundaryChars.contains(text[mentionStart - 1]);
  }

  bool _isMentionSuffixBoundary(String text, int mentionEnd) {
    if (mentionEnd >= text.length) {
      return true;
    }
    const boundaryChars = ' \n\r\t.,!?;:)]}"\'';
    return boundaryChars.contains(text[mentionEnd]);
  }

  List<_LegacyMentionAlias> _buildLegacyMentionAliases() {
    final byDisplayLower = <String, _LegacyMentionAlias>{};

    for (final member in _groupMembers) {
      final userId = (member['id'] as String?)?.trim();
      if (userId == null || userId.isEmpty) {
        continue;
      }

      final candidateDisplays = <String>[
        ((member['full_name'] as String?) ?? '').trim(),
        ((member['username'] as String?) ?? '').trim(),
      ];

      for (final candidate in candidateDisplays) {
        if (candidate.isEmpty) {
          continue;
        }

        final key = candidate.toLowerCase();
        final existing = byDisplayLower[key];
        if (existing == null) {
          byDisplayLower[key] = _LegacyMentionAlias(
            display: candidate,
            displayLower: key,
            userIds: {userId},
          );
        } else {
          existing.userIds.add(userId);
        }
      }
    }

    final aliases = byDisplayLower.values.toList()
      ..sort((a, b) => b.display.length.compareTo(a.display.length));
    return aliases;
  }

  List<_ResolvedMentionMatch> _extractMentionMatches(String text) {
    final matches = <_ResolvedMentionMatch>[];

    for (final encoded in ChatMentionParser.extractEncodedMatches(text)) {
      matches.add(
        _ResolvedMentionMatch(
          start: encoded.start,
          end: encoded.end,
          display: encoded.display,
          userId: encoded.userId,
        ),
      );
    }

    if (_groupMembers.isEmpty) {
      matches.sort((a, b) => a.start.compareTo(b.start));
      return matches;
    }

    final aliases = _buildLegacyMentionAliases();
    if (aliases.isEmpty) {
      matches.sort((a, b) => a.start.compareTo(b.start));
      return matches;
    }

    var searchFrom = 0;
    while (searchFrom < text.length) {
      final atIndex = text.indexOf('@', searchFrom);
      if (atIndex == -1) {
        break;
      }

      if (_isInsideMatch(atIndex, matches)) {
        searchFrom = atIndex + 1;
        continue;
      }

      if (!_isMentionPrefixBoundary(text, atIndex)) {
        searchFrom = atIndex + 1;
        continue;
      }

      _ResolvedMentionMatch? resolved;
      for (final alias in aliases) {
        final displayStart = atIndex + 1;
        final displayEnd = displayStart + alias.display.length;
        if (displayEnd > text.length) {
          continue;
        }

        final candidateDisplay = text.substring(displayStart, displayEnd);
        if (candidateDisplay.toLowerCase() != alias.displayLower) {
          continue;
        }

        if (!_isMentionSuffixBoundary(text, displayEnd)) {
          continue;
        }

        final resolvedUserId = alias.userIds.length == 1
            ? alias.userIds.first
            : null;
        resolved = _ResolvedMentionMatch(
          start: atIndex,
          end: displayEnd,
          display: candidateDisplay,
          userId: resolvedUserId,
        );
        break;
      }

      if (resolved != null &&
          !matches.any(
            (existing) => _rangesOverlap(
              resolved!.start,
              resolved.end,
              existing.start,
              existing.end,
            ),
          )) {
        matches.add(resolved);
        searchFrom = resolved.end;
      } else {
        searchFrom = atIndex + 1;
      }
    }

    matches.sort((a, b) => a.start.compareTo(b.start));
    return matches;
  }

  Future<void> _onMentionTap(String? userId) async {
    final normalizedUserId = userId?.trim() ?? '';
    if (normalizedUserId.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile unavailable for this mention.')),
      );
      return;
    }

    final status = await _validateUserBeforeNavigation(normalizedUserId);
    if (!mounted) return;

    switch (status) {
      case UserNavigationStatus.canNavigate:
        ProfileRoute(userId: normalizedUserId).push(context);
        break;
      case UserNavigationStatus.userDeleted:
        _showUserDeletedDialog();
        break;
      case UserNavigationStatus.blockedByUs:
        _showBlockedByUsDialog();
        break;
      case UserNavigationStatus.blockedByThem:
        _showBlockedByThemDialog();
        break;
    }
  }

  Future<void> _openMessageUrl(String value) async {
    final uri = ChatUrlParser.normalizeUrl(value);
    if (uri == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open this link.')),
        );
      }
      return;
    }

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open this link.')),
      );
    }
  }

  Future<void> _showImagePreview(String imageUrl) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        const closeThreshold = 120.0;
        var dragOffsetY = 0.0;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.black,
              insetPadding: EdgeInsets.zero,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onVerticalDragUpdate: (details) {
                  final nextOffset = (dragOffsetY + details.delta.dy).clamp(
                    0.0,
                    280.0,
                  );
                  setDialogState(() => dragOffsetY = nextOffset);
                },
                onVerticalDragEnd: (details) {
                  final velocity = details.primaryVelocity ?? 0;
                  if (dragOffsetY > closeThreshold || velocity > 950) {
                    Navigator.of(context).pop();
                    return;
                  }
                  setDialogState(() => dragOffsetY = 0.0);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  transform: Matrix4.translationValues(0, dragOffsetY, 0),
                  child: Stack(
                    children: [
                      InteractiveViewer(
                        minScale: 0.8,
                        maxScale: 4,
                        child: Center(
                          child: Image.network(imageUrl, fit: BoxFit.contain),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: IconButton(
                          icon: const Icon(
                            Icons.download_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _saveImageToGallery(imageUrl);
                          },
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _saveImageToGallery(String imageUrl) async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      final permissionGranted = await _requestGalleryPermission();
      if (!permissionGranted) {
        if (!mounted) return;
        messenger.showSnackBar(
          const SnackBar(content: Text('Storage permission is required.')),
        );
        return;
      }

      final uri = Uri.tryParse(imageUrl);
      if (uri == null) {
        if (!mounted) return;
        messenger.showSnackBar(
          const SnackBar(content: Text('Invalid image URL.')),
        );
        return;
      }

      final request = await HttpClient().getUrl(uri);
      final response = await request.close();
      if (response.statusCode < 200 || response.statusCode >= 300) {
        if (!mounted) return;
        messenger.showSnackBar(
          const SnackBar(content: Text('Could not download image.')),
        );
        return;
      }

      final bytes = await consolidateHttpClientResponseBytes(response);
      final fileName = _deriveImageFileName(uri);
      final result = await ImageGallerySaverPlus.saveImage(
        Uint8List.fromList(bytes),
        quality: 100,
        name: p.basenameWithoutExtension(fileName),
      );

      final success = result['isSuccess'] == true ||
          result['isSuccess']?.toString() == 'true';

      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Image saved to gallery.'
                : 'Unable to save image to gallery.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Failed to save image.')),
      );
    }
  }

  Future<bool> _requestGalleryPermission() async {
    if (Platform.isAndroid) {
      final photosStatus = await Permission.photos.request();
      if (photosStatus.isGranted || photosStatus.isLimited) {
        return true;
      }
      final storageStatus = await Permission.storage.request();
      return storageStatus.isGranted || storageStatus.isLimited;
    }

    if (Platform.isIOS) {
      final status = await Permission.photosAddOnly.request();
      return status.isGranted || status.isLimited;
    }

    return true;
  }

  String _deriveImageFileName(Uri uri) {
    final lastSegment = uri.pathSegments.isNotEmpty
        ? uri.pathSegments.last
        : '';
    final sanitized = lastSegment.split('?').first;
    if (sanitized.isNotEmpty) {
      return sanitized;
    }
    return 'chat_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
  }

  Future<void> _refreshMessagesSilently() async {
    if (_conversationId == null) return;
    try {
      final messages = await _chatService.getMessages(_conversationId!);
      if (!mounted) return;
      setState(() => _messages = messages);
      await _syncPollSummaries(messages);
    } catch (_) {}
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedMessageIndices.contains(index)) {
        _selectedMessageIndices.remove(index);
      } else {
        _selectedMessageIndices.add(index);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedMessageIndices.clear();
    });
  }

  void _forwardSelectedMessages() async {
    if (_selectedMessageIndices.isEmpty) return;

    // Get all selected messages sorted in chronological order
    final sortedIndices = _selectedMessageIndices.toList()..sort();
    final messagesToForward = sortedIndices
        .map((index) => _messages[index])
        .toList();

    // Capture the ScaffoldMessenger before showing bottom sheet
    final messenger = ScaffoldMessenger.of(context);

    // Show bottom sheet to select conversation
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ForwardMessageSheet(
        messageId: messagesToForward.first.id,
        onForward: (targetConversationId) async {
          int successCount = 0;
          int failCount = 0;

          // Forward all selected messages
          for (final message in messagesToForward) {
            try {
              await _chatService.forwardMessage(
                messageId: message.id,
                targetConversationId: targetConversationId,
              );
              successCount++;
            } catch (e) {
              failCount++;
            }
          }

          // Show result message using captured messenger
          if (failCount == 0) {
            messenger.showSnackBar(
              SnackBar(
                content: Text(
                  messagesToForward.length == 1
                      ? 'Message forwarded'
                      : '$successCount messages forwarded',
                ),
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            messenger.showSnackBar(
              SnackBar(
                content: Text(
                  successCount > 0
                      ? '$successCount forwarded, $failCount failed'
                      : 'Failed to forward messages',
                ),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
      ),
    );

    // Clear selection after bottom sheet is dismissed
    _clearSelection();
  }

  void _copySelectedMessages() {
    if (_selectedMessageIndices.isEmpty) return;

    // Sort indices to copy in chronological order
    final sortedIndices = _selectedMessageIndices.toList()..sort();

    // Build the text to copy
    final textToCopy = sortedIndices
        .map((index) {
          final msg = _messages[index];
          final payload = _parseReplyPayload(msg.content);
          final sender = msg.senderId == _currentUserId ? 'You' : widget.name;
          final time = _formatTime(msg.createdAt);
          final visibleBody = ChatMentionParser.toDisplayText(payload.body);
          return '[$time] $sender: $visibleBody';
        })
        .join('\n');

    // Copy to clipboard
    Clipboard.setData(ClipboardData(text: textToCopy));

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _selectedMessageIndices.length == 1
              ? 'Message copied'
              : '${_selectedMessageIndices.length} messages copied',
        ),
        duration: Duration(seconds: 2),
      ),
    );

    // Clear selection
    _clearSelection();
  }

  String _buildReplyPayload(String text, ChatMessage? replyTo) {
    if (replyTo == null) return text;
    return '[reply:${replyTo.id}] ${replyTo.content}\n---\n$text';
  }

  ({String? repliedSnippet, String body}) _parseReplyPayload(String content) {
    const separator = '\n---\n';
    if (!content.startsWith('[reply:') || !content.contains(separator)) {
      return (repliedSnippet: null, body: content);
    }
    final end = content.indexOf(']');
    if (end < 0) return (repliedSnippet: null, body: content);
    final rest = content.substring(end + 1);
    final split = rest.indexOf(separator);
    if (split < 0) return (repliedSnippet: null, body: content);
    final snippet = rest.substring(0, split).trim();
    final body = rest.substring(split + separator.length).trim();
    return (repliedSnippet: snippet, body: body);
  }

  void _setReplyMessage(ChatMessage message) {
    setState(() => _replyToMessage = message);
  }

  Future<void> _forwardSingleMessage(ChatMessage message) async {
    final messenger = ScaffoldMessenger.of(context);
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ForwardMessageSheet(
        messageId: message.id,
        onForward: (targetConversationId) async {
          try {
            await _chatService.forwardMessage(
              messageId: message.id,
              targetConversationId: targetConversationId,
            );
            messenger.showSnackBar(
              const SnackBar(content: Text('Message forwarded')),
            );
          } catch (e) {
            messenger.showSnackBar(
              SnackBar(
                content: Text(
                  toUserFriendlyErrorMessage(
                    e,
                    fallback: 'Unable to forward message.',
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _copySingleMessage(ChatMessage message) {
    final payload = _parseReplyPayload(message.content);
    Clipboard.setData(
      ClipboardData(text: ChatMentionParser.toDisplayText(payload.body)),
    );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Message copied')));
  }

  String _previewText(String text, {int max = 80}) {
    final compact = ChatMentionParser.toDisplayText(
      text,
    ).replaceAll('\n', ' ').trim();
    if (compact.length <= max) return compact;
    return '${compact.substring(0, max).trimRight()}...';
  }

  Future<void> _deleteMessageForMe(int index) async {
    if (_conversationId == null) return;
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(kConnectToInternetMessage)),
        );
      }
      return;
    }
    var target = _messages[index];
    if (target.id.startsWith('temp_')) {
      await _refreshMessagesSilently();
      final syncedIndex = _messages.indexWhere(
        (m) =>
            m.senderId == target.senderId &&
            m.content == target.content &&
            DateTime.now().difference(m.createdAt).inMinutes < 3,
      );
      if (syncedIndex >= 0) {
        target = _messages[syncedIndex];
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Message is still syncing. Please try again in a moment.',
            ),
          ),
        );
        return;
      }
    }

    try {
      await _chatService.hideMessagesForCurrentUser(
        conversationId: _conversationId!,
        messageIds: [target.id],
      );
      setState(() {
        _messages.removeWhere((m) => m.id == target.id);
        if (_messages.isEmpty) {
          _conversationCleared = true;
        }
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Deleted for you')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            toUserFriendlyErrorMessage(
              e,
              fallback: 'Unable to delete message for you right now.',
            ),
          ),
        ),
      );
    }
  }

  Future<void> _deleteMessageForEveryone(int index) async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(kConnectToInternetMessage)),
        );
      }
      return;
    }
    var message = _messages[index];
    var targetIndex = index;

    if (message.id.startsWith('temp_')) {
      await _refreshMessagesSilently();
      final syncedIndex = _messages.indexWhere(
        (m) =>
            m.senderId == message.senderId &&
            m.content == message.content &&
            DateTime.now().difference(m.createdAt).inMinutes < 3,
      );
      if (syncedIndex >= 0) {
        targetIndex = syncedIndex;
        message = _messages[syncedIndex];
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Message is still syncing. Please try again in a moment.',
            ),
          ),
        );
        return;
      }
    }

    final isMine = message.senderId == _currentUserId;
    if (!isMine) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can only delete your own messages.')),
      );
      return;
    }
    try {
      await _chatService.deleteMessages([message.id]);
      setState(() => _messages.removeAt(targetIndex));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Deleted for everyone')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            toUserFriendlyErrorMessage(
              e,
              fallback: 'Unable to delete for everyone.',
            ),
          ),
        ),
      );
    }
  }

  Future<void> _showMessageOptions(int index) async {
    final msg = _messages[index];
    final isMine = msg.senderId == _currentUserId;
    final canDeleteForEveryone = isMine;

    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.message_outlined,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _previewText(_parseReplyPayload(msg.content).body),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            ListTile(
              leading: const Icon(Icons.reply_rounded),
              title: const Text('Reply'),
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context, 'reply');
              },
            ),
            ListTile(
              leading: const Icon(Icons.emoji_emotions_outlined),
              title: const Text('React'),
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context, 'react');
              },
            ),
            ListTile(
              leading: Transform.flip(
                flipX: true,
                child: const Icon(Icons.reply_rounded),
              ),
              title: const Text('Forward'),
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context, 'forward');
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy_rounded),
              title: const Text('Copy'),
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context, 'copy');
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded),
              title: const Text('Delete for me'),
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context, 'delete_me');
              },
            ),
            if (canDeleteForEveryone)
              ListTile(
                leading: const Icon(
                  Icons.delete_forever_outlined,
                  color: Colors.red,
                ),
                title: const Text('Delete for everyone'),
                onTap: () {
                  HapticFeedback.heavyImpact();
                  Navigator.pop(context, 'delete_everyone');
                },
              ),
            ListTile(
              leading: const Icon(Icons.select_all_outlined),
              title: const Text('Select messages'),
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context, 'select');
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (choice == 'reply') _setReplyMessage(msg);
    if (choice == 'react') _showReactionPicker(context, msg);
    if (choice == 'forward') await _forwardSingleMessage(msg);
    if (choice == 'copy') _copySingleMessage(msg);
    if (choice == 'delete_me') await _deleteMessageForMe(index);
    if (choice == 'delete_everyone') await _deleteMessageForEveryone(index);
    if (choice == 'select') _toggleSelection(index);
  }

  bool _canDeleteSelectedMessages() {
    if (_selectedMessageIndices.isEmpty) return false;

    // Check if all selected messages are sent by current user
    return _selectedMessageIndices.every((index) {
      final msg = _messages[index];
      return msg.senderId == _currentUserId;
    });
  }

  Future<void> _deleteSelectedMessages() async {
    if (_selectedMessageIndices.isEmpty) return;

    // Show confirmation dialog
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        final textColor = colorScheme.onSurface;
        return AlertDialog(
          backgroundColor: colorScheme.surfaceContainerHigh,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Unsend Messages',
            style: GoogleFonts.inter(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            _selectedMessageIndices.length == 1
                ? 'Are you sure you want to unsend this message?'
                : 'Are you sure you want to unsend ${_selectedMessageIndices.length} messages?',
            style: GoogleFonts.inter(color: textColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(color: colorScheme.onSurfaceVariant),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Unsend',
                style: GoogleFonts.inter(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    final logger = getIt<Talker>();

    try {
      logger.info(
        '[ChatDetailPage] Deleting ${_selectedMessageIndices.length} messages',
      );

      // Get message IDs to delete
      final messageIdsToDelete = _selectedMessageIndices
          .map((index) => _messages[index].id)
          .toList();

      // Delete from database
      await _chatService.deleteMessages(messageIdsToDelete);

      logger.info(
        '[ChatDetailPage] Successfully deleted messages from database',
      );

      // Remove from local state
      setState(() {
        final sortedIndices = _selectedMessageIndices.toList()
          ..sort((a, b) => b.compareTo(a));
        for (final index in sortedIndices) {
          _messages.removeAt(index);
        }
        _selectedMessageIndices.clear();
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${messageIdsToDelete.length} message(s) unsent'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e, stackTrace) {
      logger.error('[ChatDetailPage] Error deleting messages', e, stackTrace);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to unsend messages'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // --- Block User Logic ---
  Future<void> _showBlockConfirmation() async {
    final bool? shouldBlock = await showDialog<bool>(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        final textColor = colorScheme.onSurface;
        final subTextColor = colorScheme.onSurfaceVariant;

        return AlertDialog(
          backgroundColor: colorScheme.surfaceContainerHigh,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Block ${widget.name}?',
            style: GoogleFonts.inter(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Blocked users won\'t be able to message you or see your posts. You can unblock them anytime from settings.',
            style: GoogleFonts.inter(color: subTextColor, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: subTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Block',
                style: GoogleFonts.inter(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldBlock == true) {
      await _blockUser();
    }
  }

  Future<void> _blockUser() async {
    try {
      await _blockService.blockUser(widget.userId);

      setState(() {
        _isBlocked = true; // Update blocked status
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.name} has been blocked'),
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate back after blocking
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              toUserFriendlyErrorMessage(
                e,
                fallback: 'Unable to block user right now.',
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _unblockUser() async {
    try {
      await _blockService.unblockUser(widget.userId);

      setState(() {
        _isBlocked = false; // Update blocked status
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.name} has been unblocked'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              toUserFriendlyErrorMessage(
                e,
                fallback: 'Unable to unblock user right now.',
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // --- Report User Logic ---
  Future<void> _showReportDialog() async {
    final TextEditingController reasonController = TextEditingController();
    String? selectedReason;

    final List<String> reportReasons = [
      'Spam or misleading',
      'Harassment or bullying',
      'Hate speech',
      'Violence or threats',
      'Inappropriate content',
      'Fake account',
      'Other',
    ];

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        final textColor = colorScheme.onSurface;
        final subTextColor = colorScheme.onSurfaceVariant;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: colorScheme.surfaceContainerHigh,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Report ${widget.isGroup ? 'Group' : widget.name}',
                style: GoogleFonts.inter(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Why are you reporting this ${widget.isGroup ? 'group' : 'user'}?',
                      style: GoogleFonts.inter(
                        color: subTextColor,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    ...reportReasons.map((reason) {
                      return RadioListTile<String>(
                        title: Text(
                          reason,
                          style: GoogleFonts.inter(
                            color: textColor,
                            fontSize: 14,
                          ),
                        ),
                        value: reason,
                        groupValue: selectedReason,
                        activeColor: colorScheme.error,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          setDialogState(() {
                            selectedReason = value;
                          });
                        },
                      );
                    }).toList(),
                    if (selectedReason == 'Other') ...[
                      SizedBox(height: 1.h),
                      TextField(
                        controller: reasonController,
                        maxLines: 3,
                        style: GoogleFonts.inter(color: textColor),
                        decoration: InputDecoration(
                          hintText: 'Please specify...',
                          suffixIcon: VoiceInputButton(
                            controller: reasonController,
                          ),
                          hintStyle: GoogleFonts.inter(color: subTextColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: subTextColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: subTextColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: colorScheme.error),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(
                      color: subTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (selectedReason == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please select a reason'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }

                    String finalReason = selectedReason!;
                    if (selectedReason == 'Other' &&
                        reasonController.text.trim().isNotEmpty) {
                      finalReason = reasonController.text.trim();
                    }

                    Navigator.of(context).pop(finalReason);
                  },
                  child: Text(
                    'Report',
                    style: GoogleFonts.inter(
                      color: colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      await _reportUser(result);
    }
  }

  Future<void> _reportUser(String reason) async {
    try {
      // Show loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Submitting report...'),
            duration: Duration(seconds: 1),
          ),
        );
      }

      await _reportService.reportUser(widget.userId, reason);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Report submitted. Thank you.'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              toUserFriendlyErrorMessage(
                e,
                fallback: 'Unable to submit report right now.',
              ),
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // --- Navigation to profile ---
  Future<void> _navigateToProfile() async {
    if (widget.isGroup) {
      if (_conversationId != null) {
        context.push(
          '/group_profile',
          extra: {'conversationId': _conversationId},
        );
      }
    } else {
      if (widget.userId.trim().isEmpty) {
        _showUserDeletedDialog();
        return;
      }

      // Validate user before navigation
      final status = await _validateUserBeforeNavigation(widget.userId);

      if (!mounted) return;

      switch (status) {
        case UserNavigationStatus.canNavigate:
          ProfileRoute(userId: widget.userId).push(context);
          break;
        case UserNavigationStatus.userDeleted:
          _showUserDeletedDialog();
          break;
        case UserNavigationStatus.blockedByUs:
          _showBlockedByUsDialog();
          break;
        case UserNavigationStatus.blockedByThem:
          _showBlockedByThemDialog();
          break;
      }
    }
  }

  /// Validates if we can navigate to a user's profile
  /// Returns the appropriate status enum indicating why we can or can't navigate
  Future<UserNavigationStatus> _validateUserBeforeNavigation(
    String userId,
  ) async {
    try {
      final logger = getIt<Talker>();
      final normalizedUserId = userId.trim();

      if (normalizedUserId.isEmpty) {
        logger.info('[ChatDetail] Missing userId - account deleted');
        return UserNavigationStatus.userDeleted;
      }

      // Check if user exists in profiles table
      final userExists = await SupabaseService.client
          .from('profiles')
          .select('id')
          .eq('id', normalizedUserId)
          .maybeSingle();

      if (userExists == null) {
        logger.info(
          '[ChatDetail] User $normalizedUserId not found - account deleted',
        );
        return UserNavigationStatus.userDeleted;
      }

      // Check blocking status
      try {
        final isBlocked = await _blockService.isUserBlocked(normalizedUserId);
        if (isBlocked) {
          logger.info('[ChatDetail] We have blocked user $normalizedUserId');
          return UserNavigationStatus.blockedByUs;
        }

        final blockedMe = await _blockService.getUsersWhoBlockedMe();
        if (blockedMe.contains(normalizedUserId)) {
          logger.info('[ChatDetail] User $normalizedUserId has blocked us');
          return UserNavigationStatus.blockedByThem;
        }
      } catch (e) {
        logger.warning('[ChatDetail] Error checking block status: $e');
        // On error checking blocks, allow navigation - profile page will handle it
      }

      return UserNavigationStatus.canNavigate;
    } catch (e) {
      final logger = getIt<Talker>();
      logger.warning('[ChatDetail] Error validating user: $e');
      // On network/validation error, allow navigation to be graceful
      return UserNavigationStatus.canNavigate;
    }
  }

  /// Show dialog when user account has been deleted
  void _showUserDeletedDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surfaceContainerHigh,
        title: Text(
          'Account Unavailable',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        content: Text(
          'This account has been deleted. You can\'t view the profile.',
          style: GoogleFonts.inter(color: colorScheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Back',
              style: GoogleFonts.inter(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show dialog when we have blocked this user
  void _showBlockedByUsDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surfaceContainerHigh,
        title: Text(
          'User Blocked',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        content: Text(
          'You have blocked this user. Unblock to view their profile.',
          style: GoogleFonts.inter(color: colorScheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: colorScheme.onSurfaceVariant),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _unblockUser();
            },
            child: Text(
              'Unblock',
              style: GoogleFonts.inter(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show dialog when user has blocked us
  void _showBlockedByThemDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surfaceContainerHigh,
        title: Text(
          'Profile Unavailable',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        content: Text(
          'This account is no longer available.',
          style: GoogleFonts.inter(color: colorScheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Back',
              style: GoogleFonts.inter(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gradients = theme.extension<GradientExtension>();
    final isDark = theme.brightness == Brightness.dark;
    final textColor = colorScheme.onSurface;
    final subTextColor = colorScheme.onSurfaceVariant;
    final highlightColor = colorScheme.primary.withValues(alpha: 0.08);
    final glassBaseColor = isDark
      ? (gradients?.glassBlackSurface ?? const Color(0xFF0A0A14))
        : Color.alphaBlend(
            gradients?.glassBackground ?? Colors.white.withValues(alpha: 0.9),
            Colors.white,
          );

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop && _messageSent) {
          // Navigation already happened, just set the result
          // This is handled by the back button pop already
        }
      },
      child: Scaffold(
        backgroundColor: glassBaseColor,

        appBar: PreferredSize(
          preferredSize: Size.fromHeight(8.h),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow.withValues(alpha: 0.8),
                  border: Border(
                    bottom: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                    ),
                  ),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _isSelectionMode
                      ? _buildSelectionHeader(context)
                      : _buildNormalHeader(context, textColor, subTextColor),
                ),
              ),
            ),
          ),
        ),

        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.translucent,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Stable glass surface to avoid shifting gradients.
              Container(decoration: BoxDecoration(color: glassBaseColor)),
              // Glass overlay
              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          isDark
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.white.withValues(alpha: 0.32),
                          isDark
                              ? colorScheme.primary.withValues(alpha: 0.05)
                              : colorScheme.primary.withValues(alpha: 0.015),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Content
              Column(
                children: [
                  Expanded(
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: colorScheme.onSurface,
                            ),
                          )
                        : ListView.builder(
                            reverse: true,
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            itemCount: _messages.length,
                            itemBuilder: (context, index) {
                              // Reverse the index to display newest at bottom
                              final reversedIndex =
                                  _messages.length - 1 - index;
                              final msg = _messages[reversedIndex];
                              final isGroupSystemTag =
                                  _isGroupMembershipSystemMessage(msg);
                              bool isMe = msg.senderId == _currentUserId;
                              bool isSelected = _selectedMessageIndices
                                  .contains(reversedIndex);
                              final showDateSeparator =
                                  reversedIndex == 0 ||
                                  !_isSameCalendarDay(
                                    msg.createdAt,
                                    _messages[reversedIndex - 1].createdAt,
                                  );

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (showDateSeparator)
                                    _buildDateSeparator(
                                      msg.createdAt,
                                      subTextColor,
                                      colorScheme.outlineVariant,
                                      isDark,
                                    ),
                                  if (isGroupSystemTag)
                                    _buildGroupSystemTag(
                                      msg,
                                      textColor: subTextColor,
                                      borderColor: colorScheme.outlineVariant,
                                      isDark: isDark,
                                    )
                                  else
                                    GestureDetector(
                                      onLongPress: () {
                                        HapticFeedback.mediumImpact();
                                        if (_isSelectionMode) {
                                          _toggleSelection(reversedIndex);
                                        } else {
                                          _showMessageContextMenuWithFallback(
                                            context,
                                            msg,
                                            reversedIndex,
                                          );
                                        }
                                      },
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        if (_isSelectionMode) {
                                          _toggleSelection(reversedIndex);
                                        }
                                      },
                                      child: Dismissible(
                                        key: ValueKey(msg.id),
                                        direction: DismissDirection.horizontal,
                                        confirmDismiss: (direction) async {
                                          if (direction ==
                                              DismissDirection.endToStart) {
                                            // Swipe left to delete options
                                            HapticFeedback.heavyImpact();
                                            _showMessageOptions(reversedIndex);
                                            return false; // Don't actually dismiss
                                          } else if (direction ==
                                              DismissDirection.startToEnd) {
                                            // Swipe right to reply
                                            HapticFeedback.mediumImpact();
                                            _setReplyMessage(msg);
                                            return false; // Don't actually dismiss
                                          }
                                          return false;
                                        },
                                        background: Container(
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 4.w,
                                          ),
                                          child: Icon(
                                            Icons.reply_rounded,
                                            color: colorScheme.primary,
                                            size: 24.sp,
                                          ),
                                        ),
                                        secondaryBackground: Container(
                                          alignment: Alignment.centerRight,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 4.w,
                                          ),
                                          child: Icon(
                                            Icons.delete_outline_rounded,
                                            color: colorScheme.error,
                                            size: 24.sp,
                                          ),
                                        ),
                                        child: Container(
                                          color: isSelected
                                              ? highlightColor
                                              : Colors.transparent,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 4.w,
                                            vertical: 1.h,
                                          ),
                                          child: Row(
                                            mainAxisAlignment: isMe
                                                ? MainAxisAlignment.end
                                                : MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              if (!isMe) ...[
                                                _buildAvatar(
                                                  15.sp,
                                                  13.sp,
                                                  avatarUrlOverride:
                                                      widget.isGroup
                                                      ? msg.senderAvatarUrl
                                                      : null,
                                                  usePersonIcon: widget.isGroup,
                                                ),
                                                SizedBox(width: 2.w),
                                              ],
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: isMe
                                                      ? CrossAxisAlignment.end
                                                      : CrossAxisAlignment
                                                            .start,
                                                  children: [
                                                    if (msg.sharedContentId !=
                                                            null &&
                                                        msg
                                                            .sharedContentId!
                                                            .isNotEmpty)
                                                      SharedContentPreviewWidget(
                                                        sharedContentId: msg
                                                            .sharedContentId!,
                                                        contentType: msg.type,
                                                      )
                                                    else if (msg.pollPayload !=
                                                        null)
                                                      Container(
                                                        constraints:
                                                            BoxConstraints(
                                                              maxWidth: 70.w,
                                                            ),
                                                        decoration:
                                                            _standardMessageBubbleDecoration(
                                                              context,
                                                              isMe,
                                                            ),
                                                        child: Builder(
                                                          builder: (context) {
                                                            final colorSchemeMsg =
                                                                Theme.of(
                                                                  context,
                                                                ).colorScheme;
                                                            final messageTextColor =
                                                                isMe
                                                                ? Colors.white
                                                                : ChatMessageTypography.incomingMessageForeground(
                                                                    colorSchemeMsg,
                                                                  );
                                                            final secondaryMsg =
                                                                isMe
                                                                ? messageTextColor
                                                                      .withValues(
                                                                        alpha:
                                                                            0.72,
                                                                      )
                                                                : subTextColor;
                                                            return ChatPollBubble(
                                                              payload: msg
                                                                  .pollPayload!,
                                                              summary:
                                                                  _pollSummariesByMessageId[msg
                                                                      .id],
                                                              isMe: isMe,
                                                              primaryTextColor:
                                                                  messageTextColor,
                                                              secondaryTextColor:
                                                                  secondaryMsg,
                                                              onOptionTap: (i) =>
                                                                  _submitPollVote(
                                                                    msg,
                                                                    i,
                                                                  ),
                                                              voteBusy:
                                                                  _pollVoteSubmittingMessageId ==
                                                                  msg.id,
                                                            );
                                                          },
                                                        ),
                                                      )
                                                    else if (msg
                                                            .locationPayload !=
                                                        null)
                                                      GestureDetector(
                                                        onTap: () =>
                                                            _openLocationInMaps(
                                                              msg
                                                                  .locationPayload!,
                                                            ),
                                                        child: Container(
                                                          constraints:
                                                              BoxConstraints(
                                                                maxWidth: 70.w,
                                                              ),
                                                          decoration:
                                                              _standardMessageBubbleDecoration(
                                                                context,
                                                                isMe,
                                                              ),
                                                          child: Builder(
                                                            builder: (context) {
                                                              final colorSchemeMsg =
                                                                  Theme.of(
                                                                    context,
                                                                  ).colorScheme;
                                                              final messageTextColor =
                                                                  isMe
                                                                  ? Colors.white
                                                                  : ChatMessageTypography.incomingMessageForeground(
                                                                      colorSchemeMsg,
                                                                    );
                                                              final secondaryMsg =
                                                                  isMe
                                                                  ? messageTextColor
                                                                        .withValues(
                                                                          alpha:
                                                                              0.72,
                                                                        )
                                                                  : subTextColor;
                                                              final t = context
                                                                  .t
                                                                  .chat
                                                                  .composerAttachments;
                                                              return ChatLocationBubble(
                                                                payload: msg
                                                                    .locationPayload!,
                                                                primaryTextColor:
                                                                    messageTextColor,
                                                                secondaryTextColor:
                                                                    secondaryMsg,
                                                                title: msg
                                                                        .content
                                                                        .trim()
                                                                        .isNotEmpty
                                                                    ? msg.content
                                                                    : t.sharedLocationTitle,
                                                                openMapsLabel:
                                                                    t.openInMaps,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      )
                                                    else
                                                      Container(
                                                        constraints:
                                                            BoxConstraints(
                                                              maxWidth: 70.w,
                                                            ),
                                                        padding: EdgeInsets.symmetric(
                                                          horizontal:
                                                              msg
                                                                  .attachments
                                                                  .isNotEmpty
                                                              ? 0
                                                              : 3.6.w,
                                                          vertical:
                                                              msg
                                                                  .attachments
                                                                  .isNotEmpty
                                                              ? 0
                                                              : 1.35.h,
                                                        ),
                                                        decoration:
                                                            _standardMessageBubbleDecoration(
                                                              context,
                                                              isMe,
                                                            ),
                                                        child: Builder(
                                                          builder: (context) {
                                                            final colorSchemeMsg =
                                                                Theme.of(
                                                                  context,
                                                                ).colorScheme;
                                                            final messageTextColor =
                                                                isMe
                                                                ? Colors.white
                                                                : ChatMessageTypography.incomingMessageForeground(
                                                                    colorSchemeMsg,
                                                                  );
                                                            final payload =
                                                                _parseReplyPayload(
                                                                  msg.content,
                                                                );
                                                            final previewUrl =
                                                                (msg
                                                                        .linkPreview
                                                                        ?.url
                                                                        .isNotEmpty ==
                                                                    true)
                                                                ? msg
                                                                      .linkPreview!
                                                                      .url
                                                                : ChatUrlParser.extractFirstNormalizedUrl(
                                                                    payload
                                                                        .body,
                                                                  );
                                                            final previewDomain =
                                                                (msg
                                                                        .linkPreview
                                                                        ?.domain
                                                                        ?.isNotEmpty ==
                                                                    true)
                                                                ? msg
                                                                      .linkPreview!
                                                                      .domain
                                                                : ChatUrlParser.extractDomain(
                                                                    previewUrl,
                                                                  );
                                                            final previewTitle =
                                                                msg
                                                                    .linkPreview
                                                                    ?.title;
                                                            final previewDescription =
                                                                msg
                                                                    .linkPreview
                                                                    ?.description;
                                                            final previewImageUrl =
                                                                msg
                                                                    .linkPreview
                                                                    ?.imageUrl;
                                                            final shouldShowLinkCard =
                                                                previewUrl !=
                                                                    null &&
                                                                previewUrl
                                                                    .isNotEmpty;
                                                            return Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                if (payload
                                                                        .repliedSnippet !=
                                                                    null)
                                                                  Container(
                                                                    width: double
                                                                        .infinity,
                                                                    margin:
                                                                        const EdgeInsets.only(
                                                                          bottom:
                                                                              8,
                                                                        ),
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                          8,
                                                                        ),
                                                                    decoration: BoxDecoration(
                                                                      color: Theme.of(
                                                                        context,
                                                                      ).colorScheme.surfaceContainerHighest,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            8,
                                                                          ),
                                                                      border: Border(
                                                                        left: BorderSide(
                                                                          color:
                                                                              isMe
                                                                              ? Theme.of(
                                                                                  context,
                                                                                ).colorScheme.primary.withValues(
                                                                                  alpha: 0.6,
                                                                                )
                                                                              : Theme.of(
                                                                                  context,
                                                                                ).colorScheme.primary,
                                                                          width:
                                                                              3,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    child: Text(
                                                                      _previewText(
                                                                        payload
                                                                            .repliedSnippet!,
                                                                        max:
                                                                            120,
                                                                      ),
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: GoogleFonts.inter(
                                                                        color: colorSchemeMsg
                                                                            .onSurface,
                                                                        fontSize:
                                                                            12.sp,
                                                                        height:
                                                                            1.35,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                if (msg
                                                                    .attachments
                                                                    .isNotEmpty)
                                                                  Builder(
                                                                    builder: (
                                                                      context,
                                                                    ) {
                                                                      final attachment =
                                                                          msg
                                                                              .attachments
                                                                              .first;
                                                                      final isImageAttachment =
                                                                          _isImageAttachment(
                                                                            msg,
                                                                            attachment,
                                                                          );

                                                                      if (isImageAttachment) {
                                                                        return GestureDetector(
                                                                          onTap: () {
                                                                            final imageUrl =
                                                                                attachment
                                                                                    .signedUrl;
                                                                            if (imageUrl !=
                                                                                    null &&
                                                                                imageUrl
                                                                                    .isNotEmpty) {
                                                                              _showImagePreview(
                                                                                imageUrl,
                                                                              );
                                                                            }
                                                                          },
                                                                          child: ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(
                                                                                  14,
                                                                                ),
                                                                            child: ConstrainedBox(
                                                                              constraints: BoxConstraints(
                                                                                maxWidth:
                                                                                    56.w,
                                                                                maxHeight:
                                                                                    42.h,
                                                                              ),
                                                                              child:
                                                                                  attachment.signedUrl !=
                                                                                      null
                                                                                  ? Image.network(
                                                                                      attachment.signedUrl!,
                                                                                      fit: BoxFit.contain,
                                                                                      alignment: Alignment.center,
                                                                                      loadingBuilder:
                                                                                          (
                                                                                            context,
                                                                                            child,
                                                                                            loadingProgress,
                                                                                          ) {
                                                                                            if (loadingProgress ==
                                                                                                null) {
                                                                                              return child;
                                                                                            }
                                                                                            return SizedBox(
                                                                                              width:
                                                                                                  56.w,
                                                                                              height:
                                                                                                  20.h,
                                                                                              child: Center(
                                                                                                child: SizedBox(
                                                                                                  width:
                                                                                                      22,
                                                                                                  height:
                                                                                                      22,
                                                                                                  child: CircularProgressIndicator(
                                                                                                    strokeWidth:
                                                                                                        2,
                                                                                                    value:
                                                                                                        loadingProgress.expectedTotalBytes !=
                                                                                                            null
                                                                                                        ? loadingProgress.cumulativeBytesLoaded /
                                                                                                              loadingProgress.expectedTotalBytes!
                                                                                                        : null,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                      errorBuilder:
                                                                                          (
                                                                                            context,
                                                                                            error,
                                                                                            stackTrace,
                                                                                          ) {
                                                                                            return SizedBox(
                                                                                              width:
                                                                                                  56.w,
                                                                                              height:
                                                                                                  20.h,
                                                                                              child: Container(
                                                                                                color:
                                                                                                    Colors.black12,
                                                                                                alignment:
                                                                                                    Alignment.center,
                                                                                                child: Icon(
                                                                                                  Icons.broken_image_outlined,
                                                                                                  color: isMe
                                                                                                      ? messageTextColor.withValues(
                                                                                                          alpha:
                                                                                                              0.72,
                                                                                                        )
                                                                                                      : textColor,
                                                                                                ),
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                    )
                                                                                  : SizedBox(
                                                                                      width:
                                                                                          56.w,
                                                                                      height:
                                                                                          20.h,
                                                                                      child: Container(
                                                                                        color: Colors.black12,
                                                                                        alignment: Alignment.center,
                                                                                        child: Icon(
                                                                                          Icons.image_outlined,
                                                                                          color: isMe
                                                                                              ? messageTextColor.withValues(
                                                                                                  alpha:
                                                                                                      0.72,
                                                                                                )
                                                                                              : textColor,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }

                                                                      return InkWell(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              12,
                                                                            ),
                                                                        onTap: () {
                                                                          unawaited(
                                                                            _showDocumentActions(
                                                                              msg,
                                                                              attachment,
                                                                            ),
                                                                          );
                                                                        },
                                                                        child: Container(
                                                                          width:
                                                                              64.w,
                                                                          padding: const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                12,
                                                                            vertical:
                                                                                10,
                                                                          ),
                                                                          decoration: BoxDecoration(
                                                                            color: isMe
                                                                                ? colorSchemeMsg.onSurface.withValues(
                                                                                    alpha: 0.10,
                                                                                  )
                                                                                : colorSchemeMsg.surfaceContainerHighest,
                                                                            borderRadius: BorderRadius.circular(
                                                                              12,
                                                                            ),
                                                                          ),
                                                                          child: Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Icon(
                                                                                Icons.description_outlined,
                                                                                color: isMe
                                                                                    ? messageTextColor
                                                                                    : textColor,
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              Expanded(
                                                                                child: Column(
                                                                                  crossAxisAlignment:
                                                                                      CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      _documentDisplayName(
                                                                                        msg,
                                                                                        attachment,
                                                                                      ),
                                                                                      maxLines:
                                                                                          2,
                                                                                      overflow:
                                                                                          TextOverflow.ellipsis,
                                                                                      style: GoogleFonts.inter(
                                                                                        color: isMe
                                                                                            ? messageTextColor
                                                                                            : textColor,
                                                                                        fontWeight:
                                                                                            FontWeight.w600,
                                                                                        fontSize:
                                                                                            11.5.sp,
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      height:
                                                                                          4,
                                                                                    ),
                                                                                    Text(
                                                                                      [
                                                                                        (attachment.mimeType ?? 'Document')
                                                                                            .split('/')
                                                                                            .last
                                                                                            .toUpperCase(),
                                                                                        _formatAttachmentSize(
                                                                                          attachment.sizeBytes,
                                                                                        ),
                                                                                      ].where((part) => part.isNotEmpty).join(' • '),
                                                                                      style: GoogleFonts.inter(
                                                                                        color: isMe
                                                                                            ? messageTextColor.withValues(
                                                                                                alpha:
                                                                                                    0.72,
                                                                                              )
                                                                                            : textColor.withValues(
                                                                                                alpha:
                                                                                                    0.72,
                                                                                              ),
                                                                                        fontSize:
                                                                                            10.2.sp,
                                                                                        fontWeight:
                                                                                            FontWeight.w500,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                if (msg
                                                                        .attachments
                                                                        .isNotEmpty &&
                                                                    payload
                                                                        .body
                                                                        .isNotEmpty)
                                                                  SizedBox(
                                                                    height: 1.h,
                                                                  ),
                                                                if (payload
                                                                    .body
                                                                    .isNotEmpty)
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                      left:
                                                                          msg
                                                                              .attachments
                                                                              .isNotEmpty
                                                                          ? 3.2.w
                                                                          : 0,
                                                                      right:
                                                                          msg
                                                                              .attachments
                                                                              .isNotEmpty
                                                                          ? 3.2.w
                                                                          : 0,
                                                                      bottom:
                                                                          msg
                                                                              .attachments
                                                                              .isNotEmpty
                                                                          ? 1.2.h
                                                                          : 0,
                                                                    ),
                                                                    child: RichText(
                                                                      text: TextSpan(
                                                                        children: _buildMessageTextSpans(
                                                                          payload
                                                                              .body,
                                                                          isMe,
                                                                          messageTextColor,
                                                                        ).toList(),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                if (shouldShowLinkCard)
                                                                  GestureDetector(
                                                                    onTap: () =>
                                                                        _openMessageUrl(
                                                                          previewUrl,
                                                                        ),
                                                                    child: Container(
                                                                      margin: EdgeInsets.only(
                                                                        top:
                                                                            1.h,
                                                                      ),
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                            2.5.w,
                                                                          ),
                                                                      decoration: BoxDecoration(
                                                                        color: Theme.of(
                                                                          context,
                                                                        ).colorScheme.surface,
                                                                        border: Border.all(
                                                                          color:
                                                                              Theme.of(
                                                                                context,
                                                                              ).colorScheme.outlineVariant.withValues(
                                                                                alpha: 0.5,
                                                                              ),
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              10,
                                                                            ),
                                                                      ),
                                                                      child: Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          if (msg.linkPreview !=
                                                                                  null &&
                                                                              previewImageUrl?.isNotEmpty ==
                                                                                  true)
                                                                            Padding(
                                                                              padding: EdgeInsets.only(
                                                                                bottom: 1.h,
                                                                              ),
                                                                              child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(
                                                                                  8,
                                                                                ),
                                                                                child: Image.network(
                                                                                  previewImageUrl!,
                                                                                  width: double.infinity,
                                                                                  height: 18.h,
                                                                                  fit: BoxFit.cover,
                                                                                  errorBuilder:
                                                                                      (
                                                                                        context,
                                                                                        error,
                                                                                        stackTrace,
                                                                                      ) {
                                                                                        return Container(
                                                                                          width: double.infinity,
                                                                                          height: 18.h,
                                                                                          color: Colors.black12,
                                                                                          alignment: Alignment.center,
                                                                                          child: Icon(
                                                                                            Icons.link,
                                                                                            color: isMe
                                                                                                ? messageTextColor.withValues(
                                                                                                    alpha: 0.72,
                                                                                                  )
                                                                                                : subTextColor,
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          if (msg.linkPreview !=
                                                                                  null &&
                                                                              previewDomain?.isNotEmpty ==
                                                                                  true)
                                                                            Text(
                                                                              previewDomain!,
                                                                              style: GoogleFonts.inter(
                                                                                fontSize: 10.sp,
                                                                                color: subTextColor,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                          if (previewTitle?.isNotEmpty ==
                                                                              true)
                                                                            Text(
                                                                              previewTitle!,
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: GoogleFonts.inter(
                                                                                fontSize: 12.5.sp,
                                                                                color: textColor,
                                                                                fontWeight: FontWeight.w700,
                                                                              ),
                                                                            ),
                                                                          if (previewTitle?.isNotEmpty !=
                                                                              true)
                                                                            Text(
                                                                              previewUrl,
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: GoogleFonts.inter(
                                                                                fontSize: 12.sp,
                                                                                color: textColor,
                                                                                fontWeight: FontWeight.w700,
                                                                              ),
                                                                            ),
                                                                          if (previewDescription?.isNotEmpty ==
                                                                              true)
                                                                            Text(
                                                                              previewDescription!,
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: GoogleFonts.inter(
                                                                                fontSize: 11.5.sp,
                                                                                color: subTextColor,
                                                                              ),
                                                                            ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    SizedBox(height: 0.4.h),
                                                    // --- Reactions row ---
                                                    if (_reactions[msg.id]
                                                            ?.counts
                                                            .isNotEmpty ==
                                                        true)
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                              bottom: 0.2.h,
                                                            ),
                                                        child: Wrap(
                                                          spacing: 4,
                                                          runSpacing: 2,
                                                          alignment: isMe
                                                              ? WrapAlignment
                                                                    .end
                                                              : WrapAlignment
                                                                    .start,
                                                          children: _reactions[msg.id]!
                                                              .counts
                                                              .entries
                                                              .map(
                                                                (
                                                                  entry,
                                                                ) => GestureDetector(
                                                                  onTap: () =>
                                                                      _handleReactionTap(
                                                                        msg,
                                                                        entry
                                                                            .key,
                                                                      ),
                                                                  child: Container(
                                                                    padding: const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          6,
                                                                      vertical:
                                                                          2,
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                      color:
                                                                          _reactions[msg.id]!.currentUserEmoji ==
                                                                              entry.key
                                                                          ? colorScheme.primary.withValues(
                                                                              alpha: 0.18,
                                                                            )
                                                                          : colorScheme.surfaceContainerHigh.withValues(
                                                                              alpha: 0.7,
                                                                            ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            12,
                                                                          ),
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        Text(
                                                                          entry
                                                                              .key,
                                                                          style: TextStyle(
                                                                            fontSize:
                                                                                12.sp,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              2.w,
                                                                        ),
                                                                        Text(
                                                                          entry
                                                                              .value
                                                                              .toString(),
                                                                          style: GoogleFonts.inter(
                                                                            fontSize:
                                                                                10.sp,
                                                                            fontWeight:
                                                                                _reactions[msg.id]!.currentUserEmoji ==
                                                                                    entry.key
                                                                                ? FontWeight.w700
                                                                                : FontWeight.w500,
                                                                            color:
                                                                                colorScheme.onSurface,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                              .toList(),
                                                        ),
                                                      ),
                                                    SizedBox(height: 0.3.h),
                                                    // --- Time + Sender ---
                                                    Text(
                                                      "${_formatTime(msg.createdAt)} ${isMe ? 'You' : (widget.isGroup ? (msg.senderName ?? 'User') : widget.name)}",
                                                      style: GoogleFonts.inter(
                                                        fontSize: 12.sp,
                                                        color: subTextColor
                                                            .withValues(
                                                              alpha: 0.7,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                  ),

                  if (!_isSelectionMode)
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerLow.withValues(
                              alpha: 0.85,
                            ),
                            border: Border(
                              top: BorderSide(
                                color: colorScheme.outlineVariant.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                          ),
                          child: _isBlocked
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.red.shade900.withValues(
                                            alpha: 0.3,
                                          )
                                        : Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: isDark
                                          ? Colors.red.shade700
                                          : Colors.red.shade200,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.block,
                                        color: isDark
                                            ? Colors.red.shade300
                                            : Colors.red.shade700,
                                        size: 20.sp,
                                      ),
                                      SizedBox(width: 3.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'You blocked ${widget.name}',
                                              style: GoogleFonts.inter(
                                                color: textColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13.sp,
                                              ),
                                            ),
                                            SizedBox(height: 0.5.h),
                                            Text(
                                              'Unblock to send messages',
                                              style: GoogleFonts.inter(
                                                color: subTextColor,
                                                fontSize: 11.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: _unblockUser,
                                        style: TextButton.styleFrom(
                                          backgroundColor: isDark
                                              ? Colors.red.shade700
                                              : Colors.red.shade600,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 4.w,
                                            vertical: 1.h,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Unblock',
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (_replyToMessage != null)
                                      Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(bottom: 1.h),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 3.w,
                                          vertical: 1.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colorScheme
                                              .surfaceContainerHighest,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border(
                                            left: BorderSide(
                                              color: colorScheme.primary,
                                              width: 3,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.reply_rounded,
                                              size: 16,
                                              color: colorScheme.primary,
                                            ),
                                            SizedBox(width: 2.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'Replying to',
                                                    style: GoogleFonts.inter(
                                                      color:
                                                          colorScheme.primary,
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    _previewText(
                                                      _replyToMessage!.content,
                                                      max: 90,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.inter(
                                                      color: subTextColor,
                                                      fontSize: 12.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              tooltip: 'Cancel reply',
                                              onPressed: () => setState(
                                                () => _replyToMessage = null,
                                              ),
                                              icon: Icon(
                                                Icons.close,
                                                size: 18,
                                                color: subTextColor,
                                              ),
                                              visualDensity:
                                                  VisualDensity.compact,
                                            ),
                                          ],
                                        ),
                                      ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (_showMentionSuggestions &&
                                            _mentionSuggestions.isNotEmpty)
                                          Container(
                                            margin: EdgeInsets.only(
                                              left: 4.w,
                                              right: 4.w,
                                              bottom: 0.8.h,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              vertical: 0.8.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isDark
                                                  ? Colors.black.withValues(
                                                      alpha: 0.9,
                                                    )
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withValues(alpha: 0.15),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            constraints: BoxConstraints(
                                              maxHeight: 24.h,
                                            ),
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  _mentionSuggestions.length,
                                              itemBuilder: (context, index) {
                                                final member =
                                                    _mentionSuggestions[index];
                                                final fullName =
                                                    (member['full_name']
                                                        as String?) ??
                                                    '';
                                                final username =
                                                    (member['username']
                                                        as String?) ??
                                                    '';
                                                final display =
                                                    fullName.isNotEmpty
                                                    ? fullName
                                                    : (username.isNotEmpty
                                                          ? username
                                                          : 'User');
                                                final avatarUrl =
                                                    member['avatar_url']
                                                        as String?;
                                                return ListTile(
                                                  dense: true,
                                                  onTap: () =>
                                                      _insertMention(member),
                                                  leading: CircleAvatar(
                                                    radius: 16,
                                                    backgroundImage:
                                                        avatarUrl != null
                                                        ? NetworkImage(
                                                            avatarUrl,
                                                          )
                                                        : null,
                                                    child: avatarUrl == null
                                                        ? Text(
                                                            display.isNotEmpty
                                                                ? display[0]
                                                                      .toUpperCase()
                                                                : '@',
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 14,
                                                                ),
                                                          )
                                                        : null,
                                                  ),
                                                  title: Text(
                                                    display,
                                                    style: GoogleFonts.inter(
                                                      color: textColor,
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  subtitle:
                                                      username.isNotEmpty &&
                                                          username != display
                                                      ? Text(
                                                          '@$username',
                                                          style:
                                                              GoogleFonts.inter(
                                                                color:
                                                                    subTextColor,
                                                                fontSize: 11.sp,
                                                              ),
                                                        )
                                                      : null,
                                                );
                                              },
                                            ),
                                          ),
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: _isSending
                                                  ? null
                                                  : () =>
                                                      requireOnlineOrNotify(
                                                        context,
                                                        _showChatAttachmentMenu,
                                                        message:
                                                            kConnectToInternetMessage,
                                                      ),
                                              icon: Icon(
                                                Icons.add,
                                                color: subTextColor,
                                                size: 22.sp,
                                              ),
                                              padding: EdgeInsets.zero,
                                              constraints: BoxConstraints(
                                                minWidth: 10.w,
                                                minHeight: 10.w,
                                              ),
                                            ),
                                            SizedBox(width: 0.5.w),
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 3.2.w,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: colorScheme
                                                      .surfaceContainerHigh,
                                                  border: Border.all(
                                                    color: colorScheme
                                                        .outlineVariant
                                                        .withValues(
                                                          alpha: 0.55,
                                                        ),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(26),
                                                ),
                                                child: TextField(
                                                  controller:
                                                      _messageController,
                                                  style: GoogleFonts.inter(
                                                    color: textColor,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Type your message",
                                                    hintStyle:
                                                        GoogleFonts.inter(
                                                          color: subTextColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                    border: InputBorder.none,
                                                    suffixIcon: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        VoiceInputButton(
                                                          controller:
                                                              _messageController,
                                                          compact: true,
                                                        ),
                                                        SizedBox(width: 2.w),
                                                        GestureDetector(
                                                          onTap: () =>
                                                              _showEmojiPicker(
                                                                context,
                                                              ),
                                                          child: Icon(
                                                            Icons
                                                                .emoji_emotions_outlined,
                                                            size: 18,
                                                            color: subTextColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    filled: false,
                                                    fillColor:
                                                        Colors.transparent,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    disabledBorder:
                                                        InputBorder.none,
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                          vertical: 1.5.h,
                                                          horizontal: 0,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 2.w),
                                            GestureDetector(
                                              onTap: () => requireOnlineOrNotify(
                                                context,
                                                _sendMessage,
                                                message:
                                                    kConnectToInternetMessage,
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.all(2.9.w),
                                                decoration: BoxDecoration(
                                                  color: _isSending
                                                      ? colorScheme.primary
                                                            .withValues(
                                                              alpha: 0.5,
                                                            )
                                                      : colorScheme.primary,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: colorScheme.primary
                                                          .withValues(
                                                            alpha: 0.25,
                                                          ),
                                                      blurRadius: 12,
                                                      offset: const Offset(
                                                        0,
                                                        5,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: _isSending
                                                    ? SizedBox(
                                                        width: 16.sp,
                                                        height: 16.sp,
                                                        child:
                                                            CircularProgressIndicator(
                                                              color: colorScheme
                                                                  .onPrimary,
                                                              strokeWidth: 2,
                                                            ),
                                                      )
                                                    : Icon(
                                                        Icons.send_rounded,
                                                        color: colorScheme
                                                            .onPrimary,
                                                        size: 16.sp,
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNormalHeader(
    BuildContext context,
    Color textColor,
    Color subTextColor,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      key: const ValueKey("NormalHeader"),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  size: 16.sp,
                  color: textColor,
                ),
                onPressed: () => context.pop({
                  'messageSent': _messageSent,
                  'conversationCleared': _conversationCleared,
                  'conversationId': _conversationId,
                }),
              ),
              SizedBox(width: 2.w),

              GestureDetector(
                onTap: () {
                  // Tap avatar: show image viewer if avatar exists, else go to profile
                  if (!widget.isGroup &&
                      widget.avatarUrl != null &&
                      widget.avatarUrl!.isNotEmpty) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ProfileImageViewer(
                          imageUrl: widget.avatarUrl,
                          username: widget.name,
                        ),
                      ),
                    );
                  } else {
                    _navigateToProfile();
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: _buildAvatar(18.sp, 14.sp),
                ),
              ),
              SizedBox(width: 3.w),

              Expanded(
                child: GestureDetector(
                  onTap: _navigateToProfile,
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: textColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      // Show indicator if user is unknown (potentially deleted)
                      if (widget.name == 'Unknown User' || widget.name.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            '(Account deleted)',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              color: subTextColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              PopupMenuButton<String>(
                icon: Icon(Icons.more_horiz, color: subTextColor, size: 20.sp),
                color: colorScheme.surfaceContainerHigh,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                onSelected: (value) {
                  if (value == 'view') {
                    _navigateToProfile();
                  } else if (value == 'block' && !widget.isGroup) {
                    _showBlockConfirmation();
                  } else if (value == 'unblock' && !widget.isGroup) {
                    _unblockUser();
                  } else if (value == 'report') {
                    _showReportDialog();
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem(
                    value: 'view',
                    child: Text(
                      widget.isGroup ? 'Group Info' : 'View Contact',
                      style: TextStyle(color: textColor),
                    ),
                  ),
                  if (!widget.isGroup)
                    PopupMenuItem(
                      value: _isBlocked ? 'unblock' : 'block',
                      child: Text(
                        _isBlocked ? 'Unblock' : 'Block',
                        style: TextStyle(color: colorScheme.error),
                      ),
                    ),
                  if (widget.isGroup)
                    PopupMenuItem(
                      value: 'block',
                      child: Text(
                        'Exit Group',
                        style: TextStyle(color: colorScheme.error),
                      ),
                    ),
                  PopupMenuItem(
                    value: 'report',
                    child: Text(
                      'Report',
                      style: TextStyle(color: colorScheme.error),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconColor = colorScheme.onSurface;
    return Container(
      key: const ValueKey("SelectionHeader"),
      color: colorScheme.surfaceContainerLow,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: iconColor),
                onPressed: _clearSelection,
              ),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                child: Text(
                  "${_selectedMessageIndices.length}",
                  key: ValueKey(_selectedMessageIndices.length),
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
              ),
              Spacer(),
              if (_canDeleteSelectedMessages())
                IconButton(
                  icon: Icon(Icons.delete_outline, color: iconColor),
                  onPressed: _deleteSelectedMessages,
                ),
              IconButton(
                icon: Icon(Icons.copy, color: iconColor),
                onPressed: _copySelectedMessages,
              ),
              IconButton(
                icon: Icon(Icons.forward_rounded, color: iconColor),
                onPressed: _forwardSelectedMessages,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  bool _isSameCalendarDay(DateTime first, DateTime second) {
    final firstLocal = first.toLocal();
    final secondLocal = second.toLocal();
    return firstLocal.year == secondLocal.year &&
        firstLocal.month == secondLocal.month &&
        firstLocal.day == secondLocal.day;
  }

  String _formatDateSeparatorLabel(DateTime dateTime) {
    final localTime = dateTime.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(
      localTime.year,
      localTime.month,
      localTime.day,
    );

    if (_isSameCalendarDay(messageDate, today)) {
      return 'Today';
    }

    final yesterday = today.subtract(const Duration(days: 1));
    if (_isSameCalendarDay(messageDate, yesterday)) {
      return 'Yesterday';
    }

    final daysDiff = today.difference(messageDate).inDays;
    if (daysDiff > 1 && daysDiff < 7) {
      const weekdays = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];
      return weekdays[messageDate.weekday - 1];
    }

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final day = messageDate.day.toString().padLeft(2, '0');
    return '$day ${months[messageDate.month - 1]} ${messageDate.year}';
  }

  Widget _buildDateSeparator(
    DateTime dateTime,
    Color textColor,
    Color borderColor,
    bool isDark,
  ) {
    final label = _formatDateSeparatorLabel(dateTime);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.1.h),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.55.h),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF12161F).withValues(alpha: 0.82)
                : Colors.white.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: borderColor.withValues(alpha: isDark ? 0.28 : 0.18),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: textColor.withValues(alpha: 0.9),
            ),
          ),
        ),
      ),
    );
  }

  bool _isGroupMembershipSystemMessage(ChatMessage message) {
    if (!widget.isGroup) return false;
    return GroupSystemMessageFormatter.isMembershipEventType(message.type);
  }

  Widget _buildGroupSystemTag(
    ChatMessage message, {
    required Color textColor,
    required Color borderColor,
    required bool isDark,
  }) {
    final label = GroupSystemMessageFormatter.formatDisplayText(
      type: message.type,
      content: message.content,
    );

    if (label.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0.4.h),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.8.w, vertical: 0.7.h),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF12161F).withValues(alpha: 0.7)
                : Colors.white.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: borderColor.withValues(alpha: isDark ? 0.24 : 0.2),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 10.7.sp,
              fontWeight: FontWeight.w600,
              color: textColor.withValues(alpha: 0.92),
            ),
          ),
        ),
      ),
    );
  }

  // Build avatar: image when set, else person/group icon (uniform across app)
  // [avatarUrlOverride] when set (e.g. sender in group) uses that URL instead of widget.avatarUrl
  // [usePersonIcon] when true shows person icon for placeholder (e.g. message sender in group)
  Widget _buildAvatar(
    double radius,
    double fontSize, {
    String? avatarUrlOverride,
    bool usePersonIcon = false,
  }) {
    final avatarUrl = avatarUrlOverride ?? widget.avatarUrl;
    final colorScheme = Theme.of(context).colorScheme;
    final fallbackColor = widget.avatarColor != null
        ? Color(int.parse(widget.avatarColor!))
        : colorScheme.primary;

    final isGroupAvatar = !usePersonIcon && widget.isGroup;

    return ProfileAvatar(
      avatarUrl: avatarUrl,
      displayName: widget.name,
      radius: radius,
      userId: isGroupAvatar || widget.userId.trim().isEmpty
          ? null
          : widget.userId,
      backgroundColor: fallbackColor.withValues(alpha: 0.2),
      isGroup: isGroupAvatar,
    );
  }
}
