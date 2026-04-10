import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myitihas/core/widgets/markdown/app_markdown.dart';
import 'package:myitihas/core/widgets/voice_input/voice_input_button.dart';
import 'package:myitihas/pages/map2/typing_Indicator.dart';

import 'dart:async';

import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class Message {
  final String text;
  final bool isMe;
  final String time;
  final bool isSystem;

  Message({
    required this.text,
    required this.isMe,
    required this.time,
    this.isSystem = false,
  });
}

class ChatSession {
  final String id;
  final String title;
  final List<Message> messages;

  ChatSession({required this.id, required this.title, required this.messages});
}

class MapGuide extends StatefulWidget {
  final Map<String, dynamic>?
  initialLocation; // Accept site data from SiteDetail
  final String? initialMessage; // Pre-sent prompt (e.g. from Plan tab)
  const MapGuide({super.key, this.initialLocation, this.initialMessage});

  @override
  State<MapGuide> createState() => _MapGuideState();
}

const List<String> _defaultGuideSuggestions = [
  "Tell me about Dwarka",
  "What happened at Kurukshetra?",
  "Why is Varanasi sacred?",
  "Tell me about the significance of Mathura",
  "What is the history of Hastinapur?",
  "Explain the importance of Ayodhya",
];

class _MapGuideState extends State<MapGuide> {
  final TextEditingController _textController = TextEditingController();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isBotTyping = false;
  final List<ChatSession> _history = [];
  String? _currentSessionId;
  final _supabase = Supabase.instance.client;
  List<String> _suggestions = List.from(_defaultGuideSuggestions);

  @override
  void initState() {
    super.initState();
    _fetchHistory();
    _startNewChat();
    if (widget.initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleSubmitted(widget.initialMessage!);
      });
    } else if (widget.initialLocation != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final siteName = widget.initialLocation!['name'] ?? "this sacred site";
        _handleSubmitted(
          "Tell me about the significance of $siteName",
          initialContext: widget.initialLocation,
        );
      });
    }
  }

  // ... inside _MapGuideState ...

  Future<void> _handleSubmitted(
    String text, {
    Map<String, dynamic>? initialContext,
  }) async {
    if (text.trim().isEmpty) return;
    _textController.clear();

    setState(() {
      _messages.add(Message(text: text, isMe: true, time: _getCurrentTime()));
      _isBotTyping = true; // This shows the indicator from your screenshot
    });
    _scrollToBottom();

    try {
      // Use Supabase Edge Function for chat service
      final user = _supabase.auth.currentUser;
      final userId = user?.id ?? 'anonymous';

      final response = await _supabase.functions.invoke(
        'chat-service',
        body: {
          'chat_id': _currentSessionId,
          'message': text,
          'mode': 'tourist_guide',
          'language': 'English',
          'user_id': userId,
          'title': initialContext?['title'] ?? widget.initialLocation?['title'],
          'story_content': initialContext?['story_content'] ??
              widget.initialLocation?['story_content'] ??
              initialContext?['details'] ??
              widget.initialLocation?['details'],
          'moral': initialContext?['moral'] ?? widget.initialLocation?['moral'],
        },
      );

      if (response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final rawResponse = data['response'] ?? "";

        // Ensure line breaks are handled correctly for the HtmlWidget
        final formattedResponse = rawResponse.replaceAll('\n', '<br>').trim();

        final rawSuggestions = data['suggestions'];
        final suggestionsList = rawSuggestions is List<dynamic>
            ? rawSuggestions.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList()
            : null;

        setState(() {
          _isBotTyping = false; // Stop the indicator
          _messages.add(
            Message(
              text: formattedResponse,
              isMe: false,
              time: _getCurrentTime(),
            ),
          );
          if (suggestionsList != null && suggestionsList.isNotEmpty) {
            _suggestions = suggestionsList;
          }
        });
        await _saveCurrentToHistory();
      } else {
        throw Exception("No response from chat service");
      }
    } catch (e) {
      debugPrint("Chat Error: $e");
      setState(() {
        _isBotTyping = false;
        _messages.add(
          Message(
            text:
                "Sorry, I'm having trouble connecting to the server. Please try again.",
            isMe: false,
            time: _getCurrentTime(),
          ),
        );
      });
    }
    _scrollToBottom();
  }

  // inside _MapGuideState in MapGuide.dart

  List<Map<String, dynamic>> _historyData = [];
  Future<void> _fetchHistory() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      final data = await _supabase
          .from('map_chats')
          .select('id, title, messages')
          .eq('user_id', user.id)
          .order('updated_at', ascending: false);

      if (mounted) {
        setState(() {
          _historyData = List<Map<String, dynamic>>.from(data);
        });
      }
    } catch (e) {
      debugPrint("Fetch History Error: $e");
    }
  }

  // 1. SAVE CONVERSATION TO BACKEND
  Future<void> _saveCurrentToHistory() async {
    final user = _supabase.auth.currentUser;
    if (user == null || _messages.isEmpty || _currentSessionId == null) return;

    // Generate a title from the first user message
    String title = "New Conversation";
    var firstUserMsg = _messages.firstWhere(
      (m) => m.isMe,
      orElse: () => _messages[0],
    );
    title = firstUserMsg.text.length > 30
        ? "${firstUserMsg.text.substring(0, 27)}..."
        : firstUserMsg.text;

    try {
      await _supabase.from('map_chats').upsert({
        'id': _currentSessionId,
        'user_id': user.id,
        'title': title,
        'messages': _messages
            .map(
              (m) => {
                'sender': m.isMe ? 'user' : 'bot',
                'text': m.text,
                'timestamp': DateTime.now().toIso8601String(),
              },
            )
            .toList(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      // Refresh local history list after saving
      _fetchHistory();
    } catch (e) {
      debugPrint("Save History Error: $e");
    }
  }

  // 2. DELETE CONVERSATION FROM BACKEND
  void _deleteCurrentChat() async {
    final bool? confirm = await showDeleteConfirmDialog(
      context: context,
      title: "this conversation",
    );

    if (confirm == true && _currentSessionId != null) {
      try {
        await _supabase.from('map_chats').delete().eq('id', _currentSessionId!);

        setState(() {
          _history.removeWhere((session) => session.id == _currentSessionId);
          _messages.clear();
          _startNewChat(); // Start fresh after deletion
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Conversation permanently deleted")),
        );
      } catch (e) {
        debugPrint("Delete Error: $e");
      }
    }
  }

  void _startNewChat() {
    setState(() {
      // Generate a proper UUID instead of a timestamp string
      _currentSessionId = const Uuid().v4();
      _messages.clear();
      _suggestions = List.from(_defaultGuideSuggestions);
      _messages.add(
        Message(
          text: "Hey there! I'm Krishna, your friend. How are you doing today?",
          isMe: false,
          time: _getCurrentTime(),
        ),
      );
    });
  }

  void _loadChatFromHistory(ChatSession session) {
    setState(() {
      _saveCurrentToHistory();
      _currentSessionId = session.id;
      _messages.clear();
      _messages.addAll(session.messages);
    });
    context.pop();
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
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
          return "[${m.time}] ${m.isMe ? 'You' : 'Krishna'}: ${m.text}";
        })
        .join("\n\n");

    Clipboard.setData(ClipboardData(text: fullChat)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Full chat copied to clipboard!")),
      );
    });
  }

  Future<bool?> showDeleteConfirmDialog({
    required BuildContext context,
    required String title,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Deletion"),
        content: Text("Are you sure you want to delete $title?"),
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
    bool isDark = theme.brightness == Brightness.dark;
    Color textColor = colorScheme.onSurface;
    final gradientExt = theme.extension<GradientExtension>();
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildHistoryDrawer(isDark, textColor),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: gradientExt?.screenBackgroundGradient ??
              LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.surface,
                  colorScheme.primary.withValues(alpha: 0.3),
                  colorScheme.secondary.withValues(alpha: 0.2),
                  colorScheme.secondary.withValues(alpha: 0.1),
                ],
                stops: const [0.0, 0.35, 0.55, 1.0],
              ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              SizedBox(height: 0.5.h),
              _header(isDark, textColor),
              Divider(color: textColor.withOpacity(0.2)),

              SizedBox(height: 0.5.h),

              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      width: 96.w,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHigh.withValues(alpha: isDark ? 0.4 : 0.85),
                        border: Border.all(
                          color: colorScheme.outline.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SizedBox(height: 6.h),
                          // _header(),
                          // _buildModeSelector(),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              SizedBox(width: 2.5.h),
                              Text(
                                "Start a Conversation",
                                style: GoogleFonts.merriweather(
                                  color: textColor,
                                  fontSize: 16.sp,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          _buildSuggestions(isDark, textColor),
                          SizedBox(height: 0.5.h),
                          Divider(color: textColor.withOpacity(0.2)),
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,

                              itemCount:
                                  _messages.length + (_isBotTyping ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == _messages.length) {
                                  return _buildTypingIndicator(
                                    isDark,
                                    textColor,
                                  );
                                }

                                final msg = _messages[index];
                                final bool isMe = msg.isMe;
                                // final bool isSelected = _selectedMessageIndices.contains(index);

                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.h,
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: isMe
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      if (!isMe) ...[
                                        Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: colorScheme.primary,
                                              width: 1,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 10,
                                                spreadRadius: 3,
                                                color: colorScheme.primary
                                                    .withValues(alpha: 0.2),
                                              ),
                                            ],
                                          ),

                                          child: CircleAvatar(
                                            radius: 16,
                                            backgroundColor: Theme.of(
                                              context,
                                            ).colorScheme.surface,
                                            backgroundImage: const AssetImage(
                                              'assets/logo.png',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                      Column(
                                        crossAxisAlignment: isMe
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            constraints: BoxConstraints(
                                              maxWidth: 70.w,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: !isMe
                                                  ? LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                      colors: [
                                                        colorScheme.primary,
                                                        colorScheme.secondary,
                                                        colorScheme.tertiary,
                                                      ],
                                                      stops: const [0.2, 0.8, 1.0],
                                                    )
                                                  : null,

                                              color: isMe
                                                  ? colorScheme.surfaceContainerHigh
                                                  : null,
                                              borderRadius: BorderRadius.only(
                                                topLeft: const Radius.circular(
                                                  16,
                                                ),
                                                topRight: const Radius.circular(
                                                  16,
                                                ),
                                                bottomLeft: isMe
                                                    ? const Radius.circular(16)
                                                    : Radius.zero,
                                                bottomRight: isMe
                                                    ? Radius.zero
                                                    : const Radius.circular(16),
                                              ),
                                            ),
                                            child: isMe
                                                ? Text(
                                                    msg.text,
                                                    style:
                                                        GoogleFonts.merriweather(
                                                          color: colorScheme.onSurface,
                                                          fontSize: 14.5.sp,
                                                        ),
                                                  )
                                                : AppMarkdown(
                                                    data: msg.text
                                                        .replaceAll(
                                                          '<br>',
                                                          '\n',
                                                        )
                                                        .replaceAll(
                                                          '<br/>',
                                                          '\n',
                                                        )
                                                        .replaceAll(
                                                          '<br />',
                                                          '\n',
                                                        ),
                                                    shrinkWrap: true,
                                                    selectable: true,
                                                    styleSheetOverride: MarkdownStyleSheet(
                                                      p: GoogleFonts.merriweather(
                                                        color: Colors.white,
                                                        fontSize: 14.5.sp,
                                                        height: 1.4,
                                                      ),
                                                      strong:
                                                          GoogleFonts.merriweather(
                                                            color: const Color(
                                                              0xFFFFE99C,
                                                            ),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16.sp,
                                                          ),
                                                      em: GoogleFonts.merriweather(
                                                        color: const Color(
                                                          0xFFFFE99C,
                                                        ),
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontSize: 14.5.sp,
                                                      ),
                                                      h1: GoogleFonts.merriweather(
                                                        color: const Color(
                                                          0xFFFFE99C,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20.sp,
                                                      ),
                                                      h2: GoogleFonts.merriweather(
                                                        color: const Color(
                                                          0xFFFFE99C,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18.sp,
                                                      ),
                                                      h3: GoogleFonts.merriweather(
                                                        color: const Color(
                                                          0xFFFFE99C,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16.sp,
                                                      ),
                                                      listBullet:
                                                          GoogleFonts.merriweather(
                                                            color:
                                                                Colors.white70,
                                                            fontSize: 14.5.sp,
                                                          ),
                                                    ),
                                                  ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "${msg.time} ${isMe ? 'You' : 'Krishna'}",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: textColor.withOpacity(0.6),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 1.5.h),
              SafeArea(child: _buildInputArea(isDark, textColor)),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryDrawer(bool isDark, Color textColor) {
    final colorScheme = Theme.of(context).colorScheme;
    return Drawer(
      backgroundColor: colorScheme.surface,
      child: Column(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "History",
                  style: GoogleFonts.merriweather(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: () {
                    _startNewChat();
         // If we're at the top, just pop
    context.pop();
                  },

                  child: Container(
                    width: 50.w,
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF6EC6FF), // light blue
                          Color(0xFF9B8CFF), // soft purple
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF6EC6FF).withOpacity(0.4),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "New Conversation",
                          style: GoogleFonts.merriweather(
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
            child: ListView.builder(
              itemCount: _historyData.length,
              itemBuilder: (context, index) {
                final mapSession = _historyData[index];

                // Convert stored message maps into Message objects
                final messagesList = <Message>[];
                if (mapSession['messages'] != null &&
                    mapSession['messages'] is List) {
                  for (var m in mapSession['messages']) {
                    try {
                      messagesList.add(
                        Message(
                          text: m['text']?.toString() ?? '',
                          isMe: (m['sender'] ?? '') == 'user',
                          time: m['timestamp']?.toString() ?? '',
                        ),
                      );
                    } catch (_) {
                      // ignore malformed message entries
                    }
                  }
                }

                final session = ChatSession(
                  id: mapSession['id']?.toString() ?? const Uuid().v4(),
                  title: mapSession['title']?.toString() ?? "New Conversation",
                  messages: messagesList,
                );

                return ListTile(
                  title: Text(
                    session.title,
                    style: GoogleFonts.merriweather(color: textColor),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.grey),
                    onPressed: () async {
                      final bool? confirm = await showDeleteConfirmDialog(
                        context: context,
                        title: "this conversation",
                      );
                      if (confirm == true) {
                        try {
                          await _supabase
                              .from('map_chats')
                              .delete()
                              .eq('id', session.id);
                          setState(() {
                            _historyData.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Conversation permanently deleted"),
                            ),
                          );
                        } catch (e) {
                          debugPrint("Delete Error: $e");
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

  Widget _header(bool isDark, Color textColor) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: textColor,
              size: 18.sp,
            ),
          ),

          SizedBox(width: 2.w),

          Container(
            width: 36,
            height: 36,
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
              backgroundColor: colorScheme.surface,
              backgroundImage: const AssetImage('assets/logo.png'),
            ),
          ),

          SizedBox(width: 2.w),

          Text(
            "MyItihas Guide",
            style: GoogleFonts.inter(
              color: textColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(width: 1.w),

          const Icon(Icons.verified, color: Colors.green, size: 18),

          const Spacer(),

          _circleIcon(
            icon: Icons.copy,
            onTap: _copyFullChat,
            isDark: isDark,
            textColor: textColor,
          ),

          SizedBox(width: 2.w),

          _circleIcon(
            icon: Icons.delete_outline,
            onTap: _deleteCurrentChat,
            isDark: isDark,
            textColor: textColor,
          ),
          SizedBox(width: 2.w),
          _circleIcon(
            icon: Icons.menu,
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
        height: 5.h,
        width: 4.h,
        decoration: BoxDecoration(
          color: isDark
              ? Colors.black.withOpacity(0.1)
              : Colors.white.withOpacity(0.3),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Center(
          child: Icon(icon, color: textColor, size: 18.sp),
        ),
      ),
    );
  }

  Widget _buildSuggestions(bool isDark, Color textColor) {
    final suggestions = _suggestions;
    return SizedBox(
      height: 4.5.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _handleSubmitted(suggestions[index]);
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                ),
                color: Theme.of(context).colorScheme.surfaceContainerHigh.withValues(alpha: isDark ? 0.4 : 0.7),
              ),
              child: Center(
                child: Text(
                  suggestions[index],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTypingIndicator(bool isDark, Color textColor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.h),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  spreadRadius: 3,
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.surface,
              backgroundImage: const AssetImage(
                'assets/logo.png',
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const TypingIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(bool isDark, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.h),

      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: isDark ? Colors.white.withOpacity(0.1) : Colors.white,
                border: Border.all(
                  color: isDark ? Colors.white.withOpacity(0.15) : Colors.white,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // shadow color
                    blurRadius: 12, // softness
                    spreadRadius: 2, // size
                    offset: const Offset(0, 6), // vertical elevation
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: "Hey Krishna! What's up?",
                        hintStyle: TextStyle(
                          color: isDark
                              ? Colors.white54
                              : Colors.black.withOpacity(0.5),
                        ),
                        suffixIcon: VoiceInputButton(
                          controller: _textController,
                          compact: true,
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
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _handleSubmitted(_textController.text),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF00B0FF),
                    Color(0xFF0080FF),
                  ], // Send button gradient
                ),
              ),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
