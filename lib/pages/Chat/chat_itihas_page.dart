// ignore_for_file: avoid_print
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/core/cache/chat_conversation_cache.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/network/network_info.dart';
import 'package:myitihas/core/utils/app_error_message.dart';
import 'package:myitihas/core/widgets/glass/glass_background.dart';
import 'package:myitihas/core/widgets/profile_avatar/profile_avatar.dart';
import 'package:myitihas/core/widgets/voice_input/voice_input_button.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/models/conversation.dart';
import 'package:myitihas/pages/Chat/Widget/chat_requests_page.dart';
import 'package:myitihas/services/chat_service.dart';
import 'package:myitihas/services/profile_service.dart';
import 'package:myitihas/services/supabase_service.dart';
import 'package:myitihas/services/user_block_service.dart';
import 'package:myitihas/services/user_report_service.dart';
import 'package:sizer/sizer.dart';

class ChatItihasPage extends StatefulWidget {
  const ChatItihasPage({super.key});

  @override
  State<ChatItihasPage> createState() => _ChatItihasPageState();
}

class _ChatItihasPageState extends State<ChatItihasPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final ChatService _chatService = getIt<ChatService>();
  final NetworkInfo _networkInfo = getIt<NetworkInfo>();
  final ProfileService _profileService = getIt<ProfileService>();
  final UserBlockService _blockService = getIt<UserBlockService>();
  final UserReportService _reportService = getIt<UserReportService>();
  final ChatConversationCache _conversationCache =
      getIt<ChatConversationCache>();
  final TextEditingController _searchController = TextEditingController();

  /// Conversation IDs for which notifications are muted (local only).
  final Set<String> _mutedConversationIds = {};

  int _selectedTabIndex = 0;
  late List<String> _tabs;
  late PageController _pageController;
  late AnimationController _tabAnimController;

  // Selection State
  final Set<int> _selectedIndices = {};
  bool get _isSelectionMode => _selectedIndices.isNotEmpty;

  // Real conversation data
  List<Conversation> _conversations = [];
  List<Conversation> _filteredDms = [];
  List<Conversation> _filteredGroups = [];
  final Map<String, Map<String, dynamic>> _userProfiles =
      {}; // conversationId -> user profile
  bool _isLoading = true;
  String? _currentUserId;
  String _searchQuery = '';
  int _pendingRequestsCount = 0;
  StreamSubscription<void>? _conversationListSubscription;
  Timer? _realtimeRefreshDebounce;
  bool _isFetchingConversations = false;
  bool _queuedConversationRefresh = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _currentUserId = SupabaseService.client.auth.currentUser?.id;
    _pageController = PageController(initialPage: _selectedTabIndex);
    _tabAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _subscribeToConversationListChanges();
    _loadConversations();
    _loadPendingRequestsCount();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final t = Translations.of(context);
    _tabs = [t.chat.chatsTab, t.chat.groupsTab, t.chat.requests];
  }

  Future<void> _loadPendingRequestsCount() async {
    try {
      final count = await _chatService.getPendingRequestsCount();
      if (mounted) setState(() => _pendingRequestsCount = count);
    } catch (_) {}
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _conversationListSubscription?.cancel();
    _realtimeRefreshDebounce?.cancel();
    _searchController.dispose();
    _pageController.dispose();
    _tabAnimController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _scheduleConversationRefresh(immediate: true);
    }
  }

  void _subscribeToConversationListChanges() {
    _conversationListSubscription?.cancel();
    _conversationListSubscription = _chatService
        .subscribeToConversationListChanges()
        .listen(
          (_) => _scheduleConversationRefresh(),
          onError: (_) => _scheduleConversationRefresh(),
        );
  }

  void _scheduleConversationRefresh({bool immediate = false}) {
    if (!mounted) return;

    _realtimeRefreshDebounce?.cancel();

    if (immediate) {
      unawaited(_loadConversations(showCache: false));
      return;
    }

    _realtimeRefreshDebounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      unawaited(_loadConversations(showCache: false));
    });
  }

  Future<void> _onPullToRefresh() async {
    await _loadConversations(showCache: false);
    await _loadPendingRequestsCount();
  }

  Future<void> _loadConversations({bool showCache = true}) async {
    if (_isFetchingConversations) {
      _queuedConversationRefresh = true;
      return;
    }

    _isFetchingConversations = true;

    try {
      if (showCache) {
        // Load both DMs and Groups from cache initially.
        final cachedDm =
            _conversationCache.getCachedConversations(isGroup: false) ?? [];
        final cachedGroup =
            _conversationCache.getCachedConversations(isGroup: true) ?? [];
        final cached = [...cachedDm, ...cachedGroup];

        if (cached.isNotEmpty) {
          setState(() {
            _conversations = cached;
            _filterConversations();
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = true;
          });
        }
      } else {
        setState(() {
          _isLoading = _conversations.isEmpty;
        });
      }

      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) {
        if (mounted) setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(kConnectToInternetMessage)),
          );
        }
        return;
      }

      final conversations = await _chatService.getMyConversations(
        isGroup: null,
      );

      // Fetch other user profiles for DM conversations only.
      for (final conversation in conversations) {
        if (!conversation.isGroup) {
          try {
            final otherUserId = await _getOtherUserId(conversation.id);
            if (otherUserId != null &&
                !_userProfiles.containsKey(conversation.id)) {
              final profile = await _profileService.getProfileById(otherUserId);
              _userProfiles[conversation.id] = profile;
            }
          } catch (e) {
            print(
              'Error fetching profile for conversation ${conversation.id}: $e',
            );
          }
        }
      }

      if (!mounted) return;
      setState(() {
        _conversations = conversations;
        _filterConversations();
        _isLoading = false;
      });

      final dms = conversations.where((c) => !c.isGroup).toList();
      final groups = conversations.where((c) => c.isGroup).toList();

      await _conversationCache.saveConversations(dms, isGroup: false);
      await _conversationCache.saveConversations(groups, isGroup: true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              toUserFriendlyErrorMessage(
                e,
                fallback: 'Unable to load conversations right now.',
              ),
            ),
          ),
        );
      }
    } finally {
      _isFetchingConversations = false;
      if (_queuedConversationRefresh) {
        _queuedConversationRefresh = false;
        unawaited(_loadConversations(showCache: false));
      }
    }
  }

  Future<String?> _getOtherUserId(String conversationId) async {
    try {
      final members = await SupabaseService.client
          .from('conversation_members')
          .select('user_id')
          .eq('conversation_id', conversationId);

      for (final member in members as List) {
        final userId = member['user_id'] as String;
        if (userId != _currentUserId) {
          return userId;
        }
      }
    } catch (e) {
      print('Error getting other user ID: $e');
    }
    return null;
  }

  String _formatTimestamp(DateTime timestamp) {
    final localTime = timestamp.toLocal();
    final now = DateTime.now();
    final difference = now.difference(localTime);

    if (difference.inDays == 0) {
      final hour = localTime.hour;
      final minute = localTime.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    }

    if (difference.inDays == 1) return 'Yesterday';

    if (difference.inDays < 7) {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[localTime.weekday - 1];
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
    return '${localTime.day} ${months[localTime.month - 1]}';
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _selectedIndices.clear();
    });
  }

  void _filterConversations() {
    final query = _searchQuery.toLowerCase();

    final dms = _conversations.where((c) => !c.isGroup).toList();
    final groups = _conversations.where((c) => c.isGroup).toList();

    if (_searchQuery.isEmpty) {
      _filteredDms = dms;
      _filteredGroups = groups;
    } else {
      _filteredGroups = groups.where((conversation) {
        final groupName = conversation.title.toLowerCase();
        return groupName.contains(query);
      }).toList();

      _filteredDms = dms.where((conversation) {
        final profile = _userProfiles[conversation.id];
        if (profile != null) {
          final fullName =
              (profile['full_name'] as String?)?.toLowerCase() ?? '';
          final username =
              (profile['username'] as String?)?.toLowerCase() ?? '';
          return fullName.contains(query) || username.contains(query);
        }
        return false;
      }).toList();
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filterConversations();
      _selectedIndices.clear();
    });
  }

  String _messagePreview(String raw) {
    const separator = '\n---\n';
    if (!raw.startsWith('[reply:') || !raw.contains(separator)) return raw;
    final idx = raw.indexOf(separator);
    if (idx < 0) return raw;
    return raw.substring(idx + separator.length).trim();
  }

  Future<void> _deleteSelectedConversations() async {
    if (_selectedIndices.isEmpty) return;

    final count = _selectedIndices.length;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Chat${count > 1 ? 's' : ''}?'),
        content: Text(
          count > 1
              ? 'Are you sure you want to delete $count conversations?'
              : 'Are you sure you want to delete this conversation?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(kConnectToInternetMessage)),
        );
      }
      return;
    }

    try {
      final conversationIds = _selectedIndices
          .map((displayIndex) {
            final bool hasChatbot =
                _selectedTabIndex == 0 && _searchQuery.isEmpty;
            final conversationIndex = hasChatbot
                ? displayIndex - 1
                : displayIndex;

            final targetList = _selectedTabIndex == 0
                ? _filteredDms
                : _filteredGroups;
            if (conversationIndex >= 0 &&
                conversationIndex < targetList.length) {
              return targetList[conversationIndex].id;
            }
            return null;
          })
          .whereType<String>()
          .toList();

      for (final conversationId in conversationIds) {
        await _chatService.deleteConversation(conversationId);
      }

      _exitSelectionMode();
      await _loadConversations();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${conversationIds.length} conversation(s) deleted'),
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
                fallback: 'Unable to delete conversations right now.',
              ),
            ),
          ),
        );
      }
    }
  }

  void _showChatActionsSheet(
    BuildContext context,
    Conversation conversation,
    int listIndex,
    String? otherUserId,
    String displayName,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMuted = _mutedConversationIds.contains(conversation.id);
    final isDm =
        !conversation.isGroup && otherUserId != null && otherUserId.isNotEmpty;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            if (isDm) ...[
              ListTile(
                leading: Icon(Icons.block_rounded, color: colorScheme.error),
                title: const Text('Block user'),
                onTap: () async {
                  HapticFeedback.selectionClick();
                  Navigator.pop(ctx);
                  await _handleBlockUser(otherUserId, displayName);
                },
              ),
              ListTile(
                leading: Icon(Icons.flag_outlined, color: colorScheme.primary),
                title: const Text('Report user'),
                onTap: () async {
                  HapticFeedback.selectionClick();
                  Navigator.pop(ctx);
                  await _handleReportUser(ctx, otherUserId, displayName);
                },
              ),
            ],
            ListTile(
              leading: Icon(
                isMuted
                    ? Icons.notifications_rounded
                    : Icons.notifications_off_rounded,
                color: colorScheme.primary,
              ),
              title: Text(
                isMuted ? 'Unmute notifications' : 'Mute notifications',
              ),
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.pop(ctx);
                setState(() {
                  if (isMuted) {
                    _mutedConversationIds.remove(conversation.id);
                  } else {
                    _mutedConversationIds.add(conversation.id);
                  }
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isMuted
                          ? 'Notifications enabled for $displayName'
                          : 'Notifications muted for $displayName',
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.done_all_rounded, color: colorScheme.primary),
              title: const Text('Mark as read'),
              onTap: () async {
                HapticFeedback.selectionClick();
                Navigator.pop(ctx);
                try {
                  await _chatService.markConversationAsRead(conversation.id);
                  if (!mounted) return;
                  setState(() {
                    final idx = _conversations.indexWhere(
                      (c) => c.id == conversation.id,
                    );
                    if (idx >= 0) {
                      _conversations[idx] = Conversation(
                        id: conversation.id,
                        isGroup: conversation.isGroup,
                        title: conversation.title,
                        avatarUrl: conversation.avatarUrl,
                        lastMessage: conversation.lastMessage,
                        lastMessageAt: conversation.lastMessageAt,
                        lastMessageSenderId: conversation.lastMessageSenderId,
                        lastReadAt: DateTime.now(),
                      );
                      _filterConversations();
                    }
                  });
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Marked as read')),
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        toUserFriendlyErrorMessage(
                          e,
                          fallback: 'Could not mark as read.',
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(
                Icons.delete_outline_rounded,
                color: colorScheme.error,
              ),
              title: const Text('Delete / Clear chat'),
              onTap: () async {
                HapticFeedback.selectionClick();
                Navigator.pop(ctx);
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (dialogCtx) => AlertDialog(
                    title: const Text('Delete Conversation'),
                    content: const Text(
                      'Are you sure you want to delete this conversation?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogCtx).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(dialogCtx).pop(true),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true && mounted) {
                  try {
                    await _chatService.deleteConversation(conversation.id);
                    if (!mounted) return;
                    setState(() {
                      _conversations.removeWhere(
                        (c) => c.id == conversation.id,
                      );
                      _filterConversations();
                      _mutedConversationIds.remove(conversation.id);
                    });
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Conversation deleted')),
                    );
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          toUserFriendlyErrorMessage(
                            e,
                            fallback: 'Unable to delete conversation.',
                          ),
                        ),
                      ),
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _handleBlockUser(String otherUserId, String displayName) async {
    try {
      await _blockService.blockUser(otherUserId);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$displayName has been blocked')));
      await _loadConversations();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              toUserFriendlyErrorMessage(e, fallback: 'Could not block user.'),
            ),
          ),
        );
      }
    }
  }

  Future<void> _handleReportUser(
    BuildContext sheetContext,
    String otherUserId,
    String displayName,
  ) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Report user'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Why are you reporting $displayName?',
                style: GoogleFonts.inter(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Reason (required)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onSubmitted: (v) => Navigator.of(ctx).pop(v),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final text = controller.text.trim();
                if (text.isNotEmpty) Navigator.of(ctx).pop(text);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
    if (reason == null || reason.isEmpty) return;
    try {
      await _reportService.reportUser(otherUserId, reason);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User reported. Thank you.')),
      );
      await _loadConversations();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              toUserFriendlyErrorMessage(
                e,
                fallback: 'Could not submit report.',
              ),
            ),
          ),
        );
      }
    }
  }

  int _getBadgeCount(int tabIndex) {
    if (tabIndex == 0) {
      return _filteredDms
          .where((c) => _currentUserId != null && c.isUnread(_currentUserId!))
          .length;
    }
    if (tabIndex == 1) {
      return _filteredGroups
          .where((c) => _currentUserId != null && c.isUnread(_currentUserId!))
          .length;
    }
    if (tabIndex == 2) return _pendingRequestsCount;
    return 0;
  }

  void _switchTab(int index) {
    if (_selectedTabIndex == index) return;
    setState(() {
      _selectedTabIndex = index;
      _exitSelectionMode();
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    if (index != 2) _loadConversations();
    if (index == 2) _loadPendingRequestsCount();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final gradients = theme.extension<GradientExtension>();
    final glassBaseColor = isDark
      ? (gradients?.glassBlackSurface ?? const Color(0xFF0A0A14))
        : Color.alphaBlend(
            gradients?.glassBackground ?? Colors.white.withValues(alpha: 0.9),
            Colors.white,
          );
    final t = Translations.of(context);

    return Container(
      color: glassBaseColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 7.h),

            // ── HEADER ──────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.chat.title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                      letterSpacing: -0.5,
                      fontSize: 22.sp,
                    ),
                  ),
                  // Online indicator / subtitle
                  Text(
                    '${_filteredDms.length + _filteredGroups.length} conversations',
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            if (_isSelectionMode) ...[
              SizedBox(height: 1.h),
              _buildSelectionHeader(isDark),
            ] else
              SizedBox(height: 2.h),

            // ── SEARCH BAR ──────────────────────────────────────────
            GlassOverlay(
              borderRadius: 24,
              blurSigma: 12,
              child: SizedBox(
                height: 48,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 12),
                    Icon(
                      Icons.search_rounded,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.7)
                          : Colors.black54,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        style: TextStyle(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.9)
                              : Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        cursorColor: colorScheme.primary,
                        decoration: InputDecoration(
                          hintText: "Search conversations...",
                          hintStyle: TextStyle(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.45)
                                : Colors.black38,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 0,
                          ),
                          isDense: true,
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.close_rounded,
                                    size: 18,
                                    color: isDark
                                        ? Colors.white54
                                        : Colors.black45,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    _onSearchChanged('');
                                  },
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: VoiceInputButton(
                                    controller: _searchController,
                                    compact: true,
                                  ),
                                ),
                          suffixIconConstraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                        ),
                      ),
                    ),
                    // AI button inside search bar
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => const ChatbotRoute().push(context),
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: ShaderMask(
                            shaderCallback: (bounds) =>
                                (gradients?.brandTextGradient ??
                                        LinearGradient(
                                          colors: [
                                            colorScheme.primary,
                                            colorScheme.secondary,
                                          ],
                                        ))
                                    .createShader(bounds),
                            child: const Icon(
                              Icons.auto_awesome,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // ── TAB BAR ─────────────────────────────────────────────
            _buildTabBar(colorScheme, isDark, gradients),

            SizedBox(height: 1.5.h),

            // ── CONTENT AREA (always rendered, loading indicator on top) ──
            Expanded(
              child: Stack(
                children: [
                  // PageView always rendered so controller can always animate
                  PageView(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _selectedTabIndex = index;
                        _exitSelectionMode();
                      });
                      if (index != 2) _loadConversations();
                      if (index == 2) _loadPendingRequestsCount();
                    },
                    children: [
                      _buildConversationList(isDark, false),
                      _buildConversationList(isDark, true),
                      const ChatRequestsPage(isEmbedded: true),
                    ],
                  ),

                  // Loading overlay on top (doesn't prevent PageView from existing)
                  if (_isLoading)
                    Container(
                      color: Colors.transparent,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              color: colorScheme.onSurface,
                              strokeWidth: 2.5,
                            ),
                            SizedBox(height: 14),
                            Text(
                              'Loading...',
                              style: GoogleFonts.inter(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // ── FAB (bottom-right) ───────────────────────────
                  if (!_isSelectionMode)
                    Positioned(
                      bottom: MediaQuery.paddingOf(context).bottom + 16,
                      right: 16,
                      child: _buildFab(context, colorScheme, isDark, gradients),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewChatSheet(
    BuildContext context,
    ColorScheme colorScheme,
    bool isDark,
    GradientExtension? gradients,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.fromLTRB(6.w, 2.h, 6.w, 4.h),
        decoration: BoxDecoration(
          color: isDark
              ? colorScheme.surfaceContainerHigh
              : colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            Text(
              'Start a conversation',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            _buildSheetOption(
              icon: Icons.person_add_outlined,
              label: 'New Chat',
              subtitle: 'Message someone directly',
              colorScheme: colorScheme,
              isDark: isDark,
              gradients: gradients,
              onTap: () async {
                Navigator.pop(ctx);
                await context.push('/new-chat');
                _loadConversations();
                _loadPendingRequestsCount();
              },
            ),
            SizedBox(height: 1.h),
            _buildSheetOption(
              icon: Icons.group_add_outlined,
              label: 'New Group',
              subtitle: 'Create a group conversation',
              colorScheme: colorScheme,
              isDark: isDark,
              gradients: gradients,
              onTap: () async {
                Navigator.pop(ctx);
                await context.push('/new-group');
                _loadConversations();
                _loadPendingRequestsCount();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSheetOption({
    required IconData icon,
    required String label,
    required String subtitle,
    required ColorScheme colorScheme,
    required bool isDark,
    required GradientExtension? gradients,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 11.w,
              height: 11.w,
              decoration: BoxDecoration(
                gradient:
                    gradients?.brandTextGradient ??
                    LinearGradient(
                      colors: [colorScheme.primary, colorScheme.secondary],
                    ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 11.5.sp,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFab(
    BuildContext context,
    ColorScheme colorScheme,
    bool isDark,
    GradientExtension? gradients,
  ) {
    return GestureDetector(
      onTap: () => _showNewChatSheet(context, colorScheme, isDark, gradients),
      child: Container(
        width: 14.w,
        height: 14.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient:
              gradients?.brandTextGradient ??
              LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colorScheme.primary, colorScheme.secondary],
              ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.45),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildTabBar(
    ColorScheme colorScheme,
    bool isDark,
    GradientExtension? gradients,
  ) {
    return Row(
      children: [
        Expanded(
          child: GlassOverlay(
            borderRadius: 30,
            blurSigma: 14,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                children: List.generate(_tabs.length, (index) {
                  final isSelected = _selectedTabIndex == index;
                  final badgeCount = _getBadgeCount(index);

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => _switchTab(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 2,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 1.1.h),
                        decoration: isSelected
                            ? BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [Color(0xFF2B2B2B), Color(0xFF111111)],
                                ),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.25),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              )
                            : null,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            Text(
                              _tabs[index],
                              style: GoogleFonts.inter(
                                fontSize: 15.sp,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (badgeCount > 0)
                              Positioned(
                                top: -4,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 1,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.white
                                        : colorScheme.primary,
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                  child: Text(
                                    badgeCount > 99 ? '99+' : '$badgeCount',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: isSelected
                                          ? colorScheme.primary
                                          : Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConversationList(bool isDark, bool isGroup) {
    // Only show chatbot tile in the Chats tab (not Groups, not Requests)
    final bool showChatbot = !isGroup && _searchQuery.isEmpty;
    final list = isGroup ? _filteredGroups : _filteredDms;
    final colorScheme = Theme.of(context).colorScheme;
    final gradients = Theme.of(context).extension<GradientExtension>();

    // Empty state for Groups
    if (list.isEmpty && isGroup) {
      return RefreshIndicator(
        onRefresh: _onPullToRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(
            top: 4,
            bottom: MediaQuery.paddingOf(context).bottom + 80,
          ),
          children: [
            SizedBox(height: 12.h),
            _buildEmptyState(
              icon: Icons.group_outlined,
              title: 'No groups yet',
              subtitle: 'Tap + to create or join a group',
              colorScheme: colorScheme,
            ),
          ],
        ),
      );
    }

    // Empty state for Chats
    if (list.isEmpty && !isGroup) {
      return RefreshIndicator(
        onRefresh: _onPullToRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(
            top: 4,
            bottom: MediaQuery.paddingOf(context).bottom + 80,
          ),
          children: [
            if (showChatbot) _buildChatbotTile(isDark, gradients, colorScheme),
            SizedBox(height: 12.h),
            _buildEmptyState(
              icon: Icons.chat_bubble_outline_rounded,
              title: 'No chats yet',
              subtitle: 'Tap + to start a new conversation',
              colorScheme: colorScheme,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onPullToRefresh,
      child: ListView.builder(
        padding: EdgeInsets.only(
          top: 4,
          bottom: MediaQuery.paddingOf(context).bottom + 80,
        ),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: showChatbot ? list.length + 1 : list.length,
        itemBuilder: (context, index) {
          final bool isChatbotIndex = showChatbot && index == 0;

          if (isChatbotIndex) {
            return _buildChatbotTile(isDark, gradients, colorScheme);
          }

          final conversationIndex = showChatbot ? index - 1 : index;
          final conversation = list[conversationIndex];
          final profile = _userProfiles[conversation.id];
          final isSelected = _selectedIndices.contains(index);

          final userName = conversation.isGroup
              ? conversation.title
              : (profile != null
                    ? (profile['full_name'] as String? ??
                          profile['username'] as String? ??
                          'Unknown User')
                    : 'Unknown User');
          final avatarUrl = conversation.isGroup
              ? conversation.avatarUrl
              : (profile?['avatar_url'] as String?);
          final otherUserId = conversation.isGroup
              ? null
              : (profile?['id'] as String? ?? '');

          final bool isUnread =
              _currentUserId != null && conversation.isUnread(_currentUserId!);
          final bool isMuted = _mutedConversationIds.contains(conversation.id);

          return Dismissible(
            key: ValueKey(conversation.id),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                return await showDialog<bool>(
                  context: context,
                  builder: (BuildContext ctx) {
                    return AlertDialog(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      title: const Text("Delete Conversation"),
                      content: const Text(
                        "Are you sure you want to delete this conversation?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (_currentUserId != null) {
                              try {
                                await _chatService.deleteConversation(
                                  conversation.id,
                                );
                                setState(() {
                                  _conversations.removeWhere(
                                    (c) => c.id == conversation.id,
                                  );
                                  _filterConversations();
                                });
                              } catch (e) {
                                print("Failed to delete swipe chat");
                              }
                            }
                            if (ctx.mounted) Navigator.of(ctx).pop(true);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: const Text("Delete"),
                        ),
                      ],
                    );
                  },
                );
              }
              return false;
            },
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              decoration: BoxDecoration(
                color: colorScheme.error,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                color: colorScheme.onError,
                size: 24.sp,
              ),
            ),
            child: GestureDetector(
              onLongPress: () {
                HapticFeedback.mediumImpact();
                _toggleSelection(index);
                _showChatActionsSheet(
                  context,
                  conversation,
                  index,
                  otherUserId,
                  userName,
                );
              },
              onTap: () async {
                if (_isSelectionMode) {
                  _toggleSelection(index);
                } else {
                  // Mark as read immediately when opening chat so unread badge
                  // updates without waiting for screen lifecycle callbacks.
                  await _chatService.markConversationAsRead(conversation.id);

                  await context
                      .push<Object?>(
                        '/chat_detail',
                        extra: {
                          'conversationId': conversation.id,
                          'userId': otherUserId,
                          'name': userName,
                          'avatarUrl': avatarUrl,
                          'isGroup': conversation.isGroup,
                        },
                      )
                      .then((result) {
                        if (result is Map &&
                            result['conversationCleared'] == true) {
                          final cid = result['conversationId'] as String?;
                          if (cid != null && mounted) {
                            setState(() {
                              _conversations = _conversations.map((c) {
                                if (c.id == cid) {
                                  return Conversation(
                                    id: c.id,
                                    isGroup: c.isGroup,
                                    title: c.title,
                                    avatarUrl: c.avatarUrl,
                                    lastMessage: null,
                                    lastMessageAt: null,
                                    lastMessageSenderId: null,
                                    lastReadAt: c.lastReadAt,
                                  );
                                }
                                return c;
                              }).toList();
                              _filterConversations();
                            });
                          }
                        }
                      });
                  _loadConversations();
                  _loadPendingRequestsCount();
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.only(
                  bottom: 0.3.h,
                  left: 0.5.w,
                  right: 0.5.w,
                ),
                padding: EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 2.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary.withValues(alpha: 0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    // Avatar with online / unread indicator
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SizedBox(
                          width: 13.w,
                          height: 13.w,
                          child: ProfileAvatar(
                            avatarUrl: avatarUrl,
                            displayName: userName,
                            radius: 6.5.w,
                            userId:
                                conversation.isGroup ||
                                    otherUserId == null ||
                                    otherUserId.isEmpty
                                ? null
                                : otherUserId,
                            isGroup: conversation.isGroup,
                          ),
                        ),
                        if (isSelected)
                          Positioned(
                            bottom: -1,
                            right: -1,
                            child: Container(
                              width: 5.w,
                              height: 5.w,
                              decoration: BoxDecoration(
                                color: colorScheme.tertiary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colorScheme.surface,
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(
                                Icons.check,
                                size: 11,
                                color: Colors.white,
                              ),
                            ),
                          )
                        else if (isUnread)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 3.w,
                              height: 3.w,
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colorScheme.surface,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  userName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 17.sp,
                                    fontWeight: isUnread
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              if (isMuted) ...[
                                Icon(
                                  Icons.notifications_off_rounded,
                                  size: 16.sp,
                                  color: colorScheme.outline,
                                ),
                                const SizedBox(width: 4),
                              ],
                              if (conversation.lastMessageAt != null) ...[
                                const SizedBox(width: 8),
                                Text(
                                  _formatTimestamp(conversation.lastMessageAt!),
                                  style: GoogleFonts.inter(
                                    fontSize: 13.sp,
                                    fontWeight: isUnread
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: isUnread
                                        ? colorScheme.primary
                                        : colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: 0.3.h),
                          Text(
                            _messagePreview(
                              conversation.lastMessage ?? 'Tap to chat',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: isUnread
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                              color: isUnread
                                  ? colorScheme.onSurface
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required ColorScheme colorScheme,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 38,
              color: colorScheme.primary.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatbotTile(
    bool isDark,
    GradientExtension? gradients,
    ColorScheme colorScheme,
  ) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isTabletUp = screenWidth >= 600;
    final accent = const Color(0xFF3B82F6);
    final accent2 = const Color(0xFF1D4ED8);
    final gradientColors = isDark
        ? [
            HSLColor.fromColor(
              accent,
            ).withLightness(0.04).withSaturation(0.90).toColor(),
            HSLColor.fromColor(
              accent,
            ).withLightness(0.09).withSaturation(0.84).toColor(),
            HSLColor.fromColor(
              accent2,
            ).withLightness(0.14).withSaturation(0.80).toColor(),
          ]
        : [
            HSLColor.fromColor(
              accent,
            ).withLightness(0.96).withSaturation(0.64).toColor(),
            HSLColor.fromColor(
              accent2,
            ).withLightness(0.88).withSaturation(0.72).toColor(),
          ];
    final textPrimary = isDark
        ? Colors.white.withValues(alpha: 0.96)
        : HSLColor.fromColor(accent).withLightness(0.12).toColor();
    final tileMargin = isTabletUp
        ? const EdgeInsets.fromLTRB(6, 0, 6, 8)
        : EdgeInsets.only(bottom: 0.8.h, left: 0.5.w, right: 0.5.w);
    final tilePadding = isTabletUp
        ? const EdgeInsets.symmetric(vertical: 14, horizontal: 18)
        : EdgeInsets.symmetric(vertical: 1.4.h, horizontal: 2.2.w);
    final avatarSize = isTabletUp ? 56.0 : 13.w;
    final avatarTextSpacing = isTabletUp ? 12.0 : 3.w;
    final titleFontSize = isTabletUp ? 20.0 : 16.8.sp;
    final subtitleFontSize = isTabletUp ? 12.85 : 12.45.sp;

    return GestureDetector(
      onTap: () => const ChatbotRoute().push(context),
      child: Container(
        margin: tileMargin,
        padding: tilePadding,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: accent.withValues(alpha: isDark ? 0.30 : 0.38),
            width: 0.9,
          ),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: isDark ? 0.30 : 0.20),
              blurRadius: 18,
              spreadRadius: -3,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          children: [
            // Krishna avatar — same ring treatment as Map Guide (primary + glow)
            Container(
              width: avatarSize,
              height: avatarSize,
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
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/littlekrishna.png'),
                backgroundColor: Colors.transparent,
              ),
            ),
            SizedBox(width: avatarTextSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          t.chat.littleKrishnaName,
                          style: GoogleFonts.inter(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.w800,
                            color: textPrimary,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.verified,
                        color: Color.fromARGB(255, 16, 159, 248),
                        size: 16,
                      ),
                    ],
                  ),
                  SizedBox(height: 0.25.h),
                  SizedBox(height: 0.45.h),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(21),
                      color: accent.withValues(alpha: isDark ? 0.12 : 0.14),
                      border: Border.all(
                        color: accent.withValues(alpha: isDark ? 0.30 : 0.38),
                        width: 0.7,
                      ),
                    ),
                    child: Text(
                      'Chat with Krishna',
                      style: GoogleFonts.inter(
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.7,
                        color: isDark
                            ? accent
                            : HSLColor.fromColor(
                                accent,
                              ).withLightness(0.18).toColor(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionHeader(bool isDark) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.close_rounded,
              color: isDark ? Colors.white : Colors.black87,
              size: 20.sp,
            ),
            onPressed: _exitSelectionMode,
          ),
          SizedBox(width: 1.w),
          Text(
            "${_selectedIndices.length} selected",
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              Icons.delete_outline_rounded,
              color: colorScheme.error,
              size: 20.sp,
            ),
            onPressed: () => _deleteSelectedConversations(),
          ),
        ],
      ),
    );
  }
}
