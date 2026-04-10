import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/core/cache/chat_conversation_cache.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/utils/app_error_message.dart';
import 'package:myitihas/core/widgets/markdown/app_markdown.dart';
import 'package:myitihas/core/widgets/markdown/markdown_link_handler.dart';
import 'package:myitihas/core/widgets/voice_input/voice_input_button.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/pages/Chat/Widget/typing_Indicator.dart';
import 'package:myitihas/services/chat_service.dart';
import 'package:myitihas/services/krishna_chat_session_holder.dart';
import 'package:myitihas/services/profile_service.dart';
import 'package:sizer/sizer.dart';
import 'package:talker_flutter/talker_flutter.dart';

class Message {
  final String text;
  final bool isMe;
  final String time;

  Message({required this.text, required this.isMe, required this.time});

  // Convert to backend format
  Map<String, dynamic> toJson() => {
    'sender': isMe ? 'user' : 'bot',
    'text': text,
    'timestamp': time,
  };

  // Create from backend format
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'] as String,
      isMe: json['sender'] == 'user',
      time: json['timestamp'] as String? ?? _getCurrentTime(),
    );
  }

  static String _getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }
}

class ChatSession {
  final String id;
  final String title;
  final List<Message> messages;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ChatSession({
    required this.id,
    required this.title,
    required this.messages,
    this.createdAt,
    this.updatedAt,
  });

  // Convert to backend format
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'messages': messages.map((m) => m.toJson()).toList(),
  };

  // Create from backend format
  factory ChatSession.fromBackend(Map<String, dynamic> json) {
    final messagesJson = json['messages'] as List<dynamic>? ?? [];
    final messages = messagesJson
        .map((m) => Message.fromJson(m as Map<String, dynamic>))
        .toList();

    return ChatSession(
      id: json['id'] as String,
      title: json['title'] as String? ?? t.chat.newConversation,
      messages: messages,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

String _chatLanguageFromLocale(AppLocale locale) {
  switch (locale) {
    case AppLocale.en:
      return 'English';
    case AppLocale.hi:
      return 'Hindi';
    case AppLocale.ta:
      return 'Tamil';
    case AppLocale.te:
      return 'Telugu';
    case AppLocale.bn:
      return 'Bengali';
    case AppLocale.mr:
      return 'Marathi';
    case AppLocale.gu:
      return 'Gujarati';
    case AppLocale.kn:
      return 'Kannada';
    case AppLocale.ml:
      return 'Malayalam';
    case AppLocale.pa:
      return 'Punjabi';
    case AppLocale.or:
      return 'Odia';
    case AppLocale.ur:
      return 'Urdu';
    case AppLocale.sa:
      return 'Sanskrit';
    case AppLocale.as:
      return 'Assamese';
  }
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _mode = 'friend'; // 'friend' | 'philosophical' | 'auto'
  bool _isBotTyping = false;
  final List<ChatSession> _history = [];
  String? _currentSessionId;
  final ChatService _chatService = getIt<ChatService>();
  final ChatConversationCache _conversationCache =
      getIt<ChatConversationCache>();
  final Talker _talker = getIt<Talker>();
  bool _isLoadingHistory = true;
  final ProfileService _profileService = getIt<ProfileService>();
  final KrishnaChatSessionHolder _sessionHolder =
      getIt<KrishnaChatSessionHolder>();
  String? _userDisplayName;
  List<String> _suggestions = [];

  List<String> _localizedDefaultSuggestions() {
    return [
      t.chat.suggestions.greeting,
      t.chat.suggestions.dharma,
      t.chat.suggestions.stress,
      t.chat.suggestions.karma,
      t.chat.suggestions.story,
      t.chat.suggestions.wisdom,
    ];
  }

  @override
  void initState() {
    super.initState();
    _suggestions = _localizedDefaultSuggestions();
    _restoreSessionFromMemory();
    _loadUserName();
    _loadConversationsFromBackend();
  }

  @override
  void dispose() {
    _syncSessionToMemory();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _restoreSessionFromMemory() {
    if (!_sessionHolder.hasSnapshot) return;

    final restoredMessages = _sessionHolder.messagesJson
        .map((messageJson) => Message.fromJson(messageJson))
        .toList();
    if (restoredMessages.isEmpty) return;

    _messages
      ..clear()
      ..addAll(restoredMessages);
    _currentSessionId = _sessionHolder.currentSessionId;
    _mode = _sessionHolder.mode;
    _suggestions = _sessionHolder.suggestions.isEmpty
        ? _localizedDefaultSuggestions()
        : _sessionHolder.suggestions;
  }

  void _syncSessionToMemory() {
    _sessionHolder.saveSnapshot(
      messagesJson: _messages.map((message) => message.toJson()).toList(),
      currentSessionId: _currentSessionId,
      mode: _mode,
      suggestions: _suggestions,
    );
  }

  Future<void> _loadUserName() async {
    try {
      final profile = await _profileService.getCurrentUserProfile();
      if (!mounted) return;
      if (profile != null) {
        final fullName = (profile['full_name'] as String?)?.trim();
        final username = (profile['username'] as String?)?.trim();
        final resolvedName = (fullName != null && fullName.isNotEmpty)
            ? fullName
            : (username != null && username.isNotEmpty ? username : null);
        setState(() {
          _userDisplayName = resolvedName;
        });
      }
    } catch (_) {
      // Ignore profile load errors for chat personalization
    }
  }

  /// Load all previous conversations from backend (cache-first for instant list)
  Future<void> _loadConversationsFromBackend() async {
    // Show cached history immediately if available
    final cached = _conversationCache.getCachedKrishnaConversations();
    if (cached != null && cached.isNotEmpty) {
      setState(() {
        _history.clear();
        _history.addAll(
          cached.map((conv) => ChatSession.fromBackend(conv)).toList(),
        );
        _isLoadingHistory = false;
      });
      _talker.debug(
        '[ChatPage] Loaded ${_history.length} conversations from cache',
      );
      if (_messages.isEmpty) {
        await _startNewChat();
      }
    } else {
      setState(() => _isLoadingHistory = true);
    }

    try {
      _talker.debug('[ChatPage] Loading conversations from backend');
      final conversations = await _chatService.fetchKrishnaConversations();

      if (!mounted) return;

      setState(() {
        _history.clear();
        _history.addAll(
          conversations.map((conv) => ChatSession.fromBackend(conv)).toList(),
        );
        _isLoadingHistory = false;
      });

      await _conversationCache.saveKrishnaConversations(conversations);
      _talker.info('[ChatPage] Loaded ${_history.length} conversations');

      if (_messages.isEmpty) {
        await _startNewChat();
      }
    } catch (e, stackTrace) {
      _talker.error('[ChatPage] Error loading conversations', e, stackTrace);
      if (!mounted) return;
      setState(() {
        _isLoadingHistory = false;
      });
      if (_messages.isEmpty) {
        await _startNewChat();
      }
    }
  }

  Future<void> _startNewChat() async {
    await _saveCurrentToBackend(); // Wait for save to complete
    _sessionHolder.clear();
    setState(() {
      _currentSessionId = null; // Reset for new conversation
      _messages.clear();
      _suggestions = _localizedDefaultSuggestions();
      final name = _userDisplayName;
      final welcomeText = (name != null && name.isNotEmpty)
          ? t.chat.krishnaWelcomeWithName(name: 'my dear $name')
          : t.chat.krishnaWelcomeFriend;
      _messages.add(
        Message(text: welcomeText, isMe: false, time: _getCurrentTime()),
      );
    });
    _syncSessionToMemory();
  }

  /// Save current conversation to backend
  Future<void> _saveCurrentToBackend() async {
    if (_messages.isEmpty) return;

    try {
      // Skip if only welcome message exists
      final hasUserMessages = _messages.any((m) => m.isMe);
      if (!hasUserMessages) return;

      // Create title from first user message
      String title = t.chat.newConversation;
      final firstUserMsg = _messages.firstWhere(
        (m) => m.isMe,
        orElse: () => _messages[0],
      );
      title = firstUserMsg.text;
      if (title.length > 30) title = "${title.substring(0, 27)}...";

      // Convert messages to backend format
      final messagesJson = _messages.map((m) => m.toJson()).toList();

      // Save to backend - will create new if _currentSessionId is null
      final savedId = await _chatService.saveKrishnaConversation(
        conversationId: _currentSessionId,
        title: title,
        messages: messagesJson,
      );

      // Update session ID if it was created
      if (_currentSessionId == null) {
        _currentSessionId = savedId;
        _talker.info(
          '[ChatPage] Created new backend conversation: $_currentSessionId',
        );
      }

      // Update local history with setState to refresh drawer UI
      setState(() {
        final session = ChatSession(
          id: savedId,
          title: title,
          messages: List.from(_messages),
        );

        final index = _history.indexWhere((s) => s.id == savedId);
        if (index != -1) {
          _history[index] = session;
        } else {
          _history.insert(0, session);
        }
      });

      _talker.debug('[ChatPage] Saved conversation to backend: $savedId');
      _syncSessionToMemory();
    } catch (e, stackTrace) {
      _talker.error('[ChatPage] Error saving conversation', e, stackTrace);
    }
  }

  Future<void> _loadChatFromHistory(ChatSession session) async {
    await _saveCurrentToBackend();
    if (!mounted) return;
    setState(() {
      _currentSessionId = session.id;
      _messages.clear();
      _messages.addAll(session.messages);
      _suggestions = _localizedDefaultSuggestions();
    });
    _syncSessionToMemory();
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void _deleteCurrentChat() async {
    final bool? confirm = await showDeleteConfirmDialog(
      context: context,
      title: "this conversation",
    );

    if (confirm == true) {
      try {
        // Delete from backend
        if (_currentSessionId != null) {
          await _chatService.deleteKrishnaConversation(_currentSessionId!);
        }

        setState(() {
          _history.removeWhere((session) => session.id == _currentSessionId);
        });
        await _startNewChat();

        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.chat.conversationDeleted)));
      } catch (e, stackTrace) {
        _talker.error('[ChatPage] Error deleting conversation', e, stackTrace);
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.chat.deleteFailed)));
      }
    }
  }

  void _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;
    if (_isBotTyping) {
      HapticFeedback.selectionClick();
      return;
    }
    _textController.clear();

    // Dismiss keyboard when user sends
    FocusScope.of(context).unfocus();

    setState(() {
      _messages.add(Message(text: text, isMe: true, time: _getCurrentTime()));
      _isBotTyping = true;
    });
    _syncSessionToMemory();
    _scrollToBottom();

    try {
      // Call the actual chat service API
      final mode = _mode;
      final language = _chatLanguageFromLocale(LocaleSettings.currentLocale);
      final response = await _chatService.sendChatbotMessage(
        message: text,
        mode: mode,
        chatId: _currentSessionId,
        language: language,
      );

      if (!mounted) return;
      final rawSuggestions = response['suggestions'];
      final suggestionsList = rawSuggestions is List<dynamic>
          ? rawSuggestions
                .map((e) => e?.toString() ?? '')
                .where((s) => s.isNotEmpty)
                .toList()
          : null;
      setState(() {
        _isBotTyping = false;
        _messages.add(
          Message(
            text: response['response'] as String,
            isMe: false,
            time: _getCurrentTime(),
          ),
        );
        if (suggestionsList != null && suggestionsList.isNotEmpty) {
          _suggestions = suggestionsList;
        }
      });
      _syncSessionToMemory();
      _scrollToBottom();

      // Save to backend (will create new conversation if needed)
      await _saveCurrentToBackend();
    } catch (e, stackTrace) {
      _talker.error('Error getting chatbot response', e, stackTrace);
      if (!mounted) return;
      setState(() {
        _isBotTyping = false;
        _messages.add(
          Message(
            text: toUserFriendlyErrorMessage(
              e,
              fallback: t.chat.connectionErrorFallback,
            ),
            isMe: false,
            time: _getCurrentTime(),
          ),
        );
      });
      _syncSessionToMemory();
      _scrollToBottom();
    }
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }

  bool _isTabletUp(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 600;

  double _tabletContentMaxWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= 1200 ? 980.0 : 860.0;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _copyFullChat() {
    if (_messages.isEmpty) return;
    String fullChat = _messages
        .map((m) {
          return "[${m.time}] ${m.isMe ? t.chat.copyYouLabel : t.chat.copyKrishnaLabel}: ${m.text}";
        })
        .join("\n\n");

    Clipboard.setData(ClipboardData(text: fullChat)).then((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.chat.fullChatCopied)));
    });
  }

  Future<bool?> showDeleteConfirmDialog({
    required BuildContext context,
    required String title,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.chat.confirmDeletion),
        content: Text(t.chat.deleteConversationConfirm(title: title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final textColor = colorScheme.onSurface;
    final isTabletUp = _isTabletUp(context);
    final tabletMaxWidth = _tabletContentMaxWidth(context);

    // Modern deep background — dark navy with subtle gradient
    final bgColor = isDark ? const Color(0xFF0D1117) : const Color(0xFFF4F6FF);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bgColor,
      drawer: _buildHistoryDrawer(context, isDark, textColor),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // ── HEADER ──────────────────────────────────────────
              _header(isDark, textColor, colorScheme),

              // ── MODE SELECTOR ────────────────────────────────────
              _buildModeSelector(isDark, textColor, colorScheme),
              SizedBox(height: 0.5.h),

              // ── SUGGESTION CHIPS (always visible; update from API after each reply) ──
              _buildSuggestions(isDark, textColor, colorScheme),

              // ── MESSAGES ─────────────────────────────────────────
              Expanded(
                child: _isLoadingHistory
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: colorScheme.onSurface,
                              strokeWidth: 2,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Loading...',
                              style: GoogleFonts.inter(
                                color: textColor.withValues(alpha: 0.5),
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: isTabletUp
                                ? tabletMaxWidth
                                : double.infinity,
                          ),
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: isTabletUp
                                ? const EdgeInsets.fromLTRB(16, 8, 16, 16)
                                : EdgeInsets.fromLTRB(3.w, 1.h, 3.w, 2.h),
                            physics: const BouncingScrollPhysics(),
                            itemCount:
                                _messages.length + (_isBotTyping ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == _messages.length) {
                                return _buildTypingIndicator(
                                  isDark,
                                  textColor,
                                  colorScheme,
                                );
                              }
                              final msg = _messages[index];
                              return _buildMessageTile(
                                msg: msg,
                                isMe: msg.isMe,
                                isDark: isDark,
                                textColor: textColor,
                                colorScheme: colorScheme,
                              );
                            },
                          ),
                        ),
                      ),
              ),

              // ── INPUT ────────────────────────────────────────────
              SafeArea(
                top: false,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isTabletUp ? tabletMaxWidth : double.infinity,
                    ),
                    child: _buildInputArea(isDark, textColor),
                  ),
                ),
              ),
              SizedBox(height: 1.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageTile({
    required Message msg,
    required bool isMe,
    required bool isDark,
    required Color textColor,
    required ColorScheme colorScheme,
  }) {
    final isTabletUp = _isTabletUp(context);
    final bubbleMaxWidth = isTabletUp
        ? (MediaQuery.sizeOf(context).width * 0.52)
              .clamp(360.0, 520.0)
              .toDouble()
        : 72.w;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTabletUp ? 16.0 : 2.h,
        vertical: 3,
      ),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            Container(
              width: 9.w,
              height: 9.w,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colorScheme.primary, width: 1),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    spreadRadius: 3,
                    color: colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundImage: const AssetImage(
                  'assets/images/littlekrishna.png',
                ),
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: bubbleMaxWidth),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    gradient: !isMe
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              colorScheme.primary,
                              colorScheme.secondary,
                              colorScheme.tertiary,
                            ],
                            stops: const [0.2, 0.75, 1.0],
                          )
                        : null,
                    color: isMe
                        ? (isDark
                              ? Colors.white.withValues(alpha: 0.12)
                              : Colors.black.withValues(alpha: 0.07))
                        : null,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: isMe
                          ? const Radius.circular(18)
                          : Radius.zero,
                      bottomRight: isMe
                          ? Radius.zero
                          : const Radius.circular(18),
                    ),
                  ),
                  child: isMe
                      ? Text(
                          msg.text,
                          style: GoogleFonts.merriweather(
                            color: textColor,
                            fontSize: 14.5.sp,
                            height: 1.45,
                          ),
                        )
                      : _buildMarkdownBotMessage(msg.text),
                ),
                const SizedBox(height: 4),
                Text(
                  '${msg.time} · ${isMe ? 'You' : 'Krishna'}',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: textColor.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Preprocesses bot text: strips raw markers, normalizes newlines.
  String _preprocessChatText(String text) {
    if (text.isEmpty) return text;
    String s = text
        .replaceAll(RegExp(r'\{#'), '')
        .replaceAll(RegExp(r'\*\}'), '')
        .replaceAll('\\n', '\n')
        .replaceAll('<br>', '\n')
        .replaceAll('<br/>', '\n')
        .replaceAll('<br />', '\n')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
    s = s.replaceAll(r'\*', '*');
    s = s.replaceAll(RegExp(r'\*{3,}'), '**');
    return s;
  }

  /// Builds bot message with map_guide-style markdown (golden headings/emphasis).
  Widget _buildMarkdownBotMessage(String text) {
    final processed = _preprocessChatText(text);
    const goldenColor = Color(0xFFFFE99C);
    const quoteBackground = Color(0x3D0B132B);
    return AppMarkdown(
      data: processed,
      shrinkWrap: true,
      selectable: true,
      styleSheetOverride: MarkdownStyleSheet(
        p: GoogleFonts.merriweather(
          color: const Color(0xFFF7FAFF),
          fontSize: 14.5.sp,
          height: 1.4,
        ),
        strong: GoogleFonts.merriweather(
          color: goldenColor,
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
        ),
        em: GoogleFonts.merriweather(
          color: goldenColor,
          fontStyle: FontStyle.italic,
          fontSize: 14.5.sp,
        ),
        h1: GoogleFonts.merriweather(
          color: goldenColor,
          fontWeight: FontWeight.bold,
          fontSize: 20.sp,
        ),
        h2: GoogleFonts.merriweather(
          color: goldenColor,
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
        ),
        h3: GoogleFonts.merriweather(
          color: goldenColor,
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
        ),
        listBullet: GoogleFonts.merriweather(
          color: Colors.white70,
          fontSize: 14.5.sp,
        ),
        blockquote: GoogleFonts.merriweather(
          color: Colors.white,
          fontStyle: FontStyle.italic,
          fontSize: 14.5.sp,
          height: 1.55,
        ),
        blockquoteDecoration: BoxDecoration(
          color: quoteBackground,
          borderRadius: BorderRadius.circular(10),
          border: const Border(left: BorderSide(color: goldenColor, width: 4)),
        ),
        blockquotePadding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      ),
      onTapLink: (text, href, title) {
        if (href != null && href.isNotEmpty) {
          MarkdownLinkHandler.handleLinkTap(context, text, href, title);
        }
      },
    );
  }

  Widget _buildHistoryDrawer(
    BuildContext context,
    bool isDark,
    Color textColor,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final gradients = Theme.of(context).extension<GradientExtension>();
    final bgColor = isDark ? const Color(0xFF161B22) : colorScheme.surface;
    return Drawer(
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(4.w, 6.h, 4.w, 2.h),
            decoration: BoxDecoration(
              gradient:
                  gradients?.screenBackgroundGradient ??
                  LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.25),
                      colorScheme.secondary.withValues(alpha: 0.15),
                    ],
                  ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.chat.chatHistory,
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  "${_history.length} conversation${_history.length == 1 ? '' : 's'}",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: textColor.withValues(alpha: 0.6),
                  ),
                ),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: () {
                    _startNewChat();
                    Navigator.pop(context);
                  },

                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 1.2.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient:
                          gradients?.brandTextGradient ??
                          const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xFF6EC6FF), Color(0xFF9B8CFF)],
                          ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6EC6FF).withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_rounded, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          t.chat.newConversation,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _history.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 40,
                          color: colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          t.chat.noConversationsYet,
                          style: GoogleFonts.inter(
                            fontSize: 14.5.sp,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    itemCount: _history.length,
                    separatorBuilder: (_, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final session = _history[index];
                      final isCurrentSession = session.id == _currentSessionId;
                      return ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        tileColor: isCurrentSession
                            ? colorScheme.primary.withValues(alpha: 0.08)
                            : null,
                        leading: Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 22,
                          color: isCurrentSession
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant.withValues(
                                  alpha: 0.6,
                                ),
                        ),
                        title: Text(
                          session.title,
                          style: GoogleFonts.inter(
                            color: isCurrentSession
                                ? colorScheme.primary
                                : textColor,
                            fontSize: 16.sp,
                            fontWeight: isCurrentSession
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: colorScheme.onSurfaceVariant.withValues(
                              alpha: 0.5,
                            ),
                            size: 22,
                          ),
                          onPressed: () async {
                            final bool? confirm = await showDeleteConfirmDialog(
                              context: context,
                              title: session.title,
                            );
                            if (confirm == true) {
                              final messenger = ScaffoldMessenger.of(context);
                              try {
                                await _chatService.deleteKrishnaConversation(
                                  session.id,
                                );
                                setState(() => _history.removeAt(index));
                                if (!mounted) return;
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(t.chat.conversationDeleted),
                                  ),
                                );
                              } catch (e) {
                                if (!mounted) return;
                                messenger.showSnackBar(
                                  SnackBar(content: Text(t.chat.deleteFailed)),
                                );
                              }
                            }
                          },
                        ),
                        onTap: () => _loadChatFromHistory(session),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _header(bool isDark, Color textColor, ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: (isDark ? Colors.white : Colors.black).withValues(
                  alpha: 0.08,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: textColor,
                size: 16.sp,
              ),
            ),
          ),

          SizedBox(width: 2.w),

          // Tappable profile (avatar + name) opens Little Krishna intro/about
          Expanded(
            child: GestureDetector(
              onTap: () => const LittleKrishnaIntroRoute().push(context),
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10.w,
                    height: 10.w,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: colorScheme.primary, width: 1),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          spreadRadius: 3,
                          color: colorScheme.primary.withValues(alpha: 0.2),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundImage: const AssetImage(
                        'assets/images/littlekrishna.png',
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              t.chat.littleKrishnaName,
                              style: GoogleFonts.inter(
                                color: textColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: 1.5.w),

          _circleIcon(
            icon: Icons.copy_outlined,
            onTap: _copyFullChat,
            isDark: isDark,
            textColor: textColor,
          ),

          SizedBox(width: 1.w),

          _circleIcon(
            icon: Icons.delete_outline_rounded,
            onTap: _deleteCurrentChat,
            isDark: isDark,
            textColor: textColor,
          ),
          SizedBox(width: 1.w),
          _circleIcon(
            icon: Icons.menu_rounded,
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            isDark: isDark,
            textColor: textColor,
          ),
        ],
      ),
    );
  }

  Widget _circleIcon({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: isDark
              ? Colors.black.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.3),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: Center(child: Icon(icon, color: textColor, size: 20)),
      ),
    );
  }

  Widget _buildModeSelector(
    bool isDark,
    Color textColor,
    ColorScheme colorScheme,
  ) {
    final gradients = Theme.of(context).extension<GradientExtension>();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
        ),
        color: isDark
            ? Colors.black.withValues(alpha: 0.25)
            : Colors.white.withValues(alpha: 0.7),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                _buildModeButton(
                  "Friend",
                  Icons.favorite_border_rounded,
                  _mode == 'friend',
                  () => setState(() => _mode = 'friend'),
                  isDark,
                  textColor,
                  colorScheme,
                  gradients,
                ),
                const SizedBox(width: 4),
                _buildModeButton(
                  "Wisdom",
                  Icons.auto_stories_rounded,
                  _mode == 'philosophical',
                  () => setState(() => _mode = 'philosophical'),
                  isDark,
                  textColor,
                  colorScheme,
                  gradients,
                ),
                const SizedBox(width: 4),
                _buildModeButton(
                  "Auto",
                  Icons.auto_awesome_rounded,
                  _mode == 'auto',
                  () => setState(() => _mode = 'auto'),
                  isDark,
                  textColor,
                  colorScheme,
                  gradients,
                ),
              ],
            ),
          ),
          // New chat button
          GestureDetector(
            onTap: () => _startNewChat(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded, color: colorScheme.onSurface, size: 16),
                  const SizedBox(width: 3),
                  Text(
                    'New',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(
    String text,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
    bool isDark,
    Color textColor,
    ColorScheme colorScheme,
    GradientExtension? gradients,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF2D2D2D), Color(0xFF121212)],
                  )
                : null,
            color: isSelected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.24),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : textColor.withValues(alpha: 0.6),
                size: 15,
              ),
              const SizedBox(width: 4),
              Text(
                text,
                style: GoogleFonts.inter(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 14.sp,
                  color: isSelected
                      ? Colors.white
                      : textColor.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestions(
    bool isDark,
    Color textColor,
    ColorScheme colorScheme,
  ) {
    final suggestions = _suggestions;
    return SizedBox(
      height: 4.2.h,
      child: IgnorePointer(
        ignoring: _isBotTyping,
        child: Opacity(
          opacity: _isBotTyping ? 0.5 : 1.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final label = suggestions[index];
              final textToSend = label
                  .replaceAll(RegExp(r'^[^a-zA-Z0-9]+'), '')
                  .trim();
              return GestureDetector(
                onTap: () =>
                    _handleSubmitted(textToSend.isEmpty ? label : textToSend),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.09)
                        : Colors.black.withValues(alpha: 0.05),
                    border: Border.all(
                      color: colorScheme.onSurface.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      color: colorScheme.onSurface,
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(
    bool isDark,
    Color textColor,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary.withValues(alpha: 0.15),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/littlekrishna.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : colorScheme.primary.withValues(alpha: 0.07),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
            child: const TypingIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(bool isDark, Color textColor) {
    final colorScheme = Theme.of(context).colorScheme;
    final gradients = Theme.of(context).extension<GradientExtension>();
    final isTabletUp = _isTabletUp(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isTabletUp ? 16.0 : 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.white,
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.12)
                      : Colors.black.withValues(alpha: 0.08),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      readOnly: _isBotTyping,
                      maxLines: 4,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      style: GoogleFonts.merriweather(
                        color: textColor,
                        fontSize: 16.sp,
                        height: 1.4,
                      ),
                      decoration: InputDecoration(
                        hintText: "Message Krishna...",
                        hintStyle: GoogleFonts.merriweather(
                          color: isDark ? Colors.white38 : Colors.black38,
                          fontSize: 16.sp,
                        ),
                        border: InputBorder.none,
                        filled: false,
                        fillColor: Colors.transparent,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 1.5.h,
                          horizontal: 0,
                        ),
                      ),
                      onSubmitted: _handleSubmitted,
                    ),
                  ),
                  IgnorePointer(
                    ignoring: _isBotTyping,
                    child: Opacity(
                      opacity: _isBotTyping ? 0.5 : 1.0,
                      child: VoiceInputButton(
                        controller: _textController,
                        compact: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _isBotTyping
                ? null
                : () => _handleSubmitted(_textController.text),
            child: Opacity(
              opacity: _isBotTyping ? 0.6 : 1.0,
              child: Container(
                width: 11.w,
                height: 11.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient:
                      gradients?.brandTextGradient ??
                      LinearGradient(
                        colors: [colorScheme.primary, colorScheme.secondary],
                      ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
