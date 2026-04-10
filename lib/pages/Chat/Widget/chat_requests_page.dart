import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/network/network_info.dart';
import 'package:myitihas/core/utils/app_error_message.dart';
import 'package:myitihas/core/widgets/profile_avatar/profile_avatar.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/services/chat_service.dart';
import 'package:myitihas/services/supabase_service.dart';
import 'package:myitihas/services/user_block_service.dart';
import 'package:sizer/sizer.dart';
import 'package:talker_flutter/talker_flutter.dart';

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

class ChatRequestsPage extends StatefulWidget {
  final bool isEmbedded;

  const ChatRequestsPage({super.key, this.isEmbedded = false});

  @override
  State<ChatRequestsPage> createState() => _ChatRequestsPageState();
}

class _ChatRequestsPageState extends State<ChatRequestsPage>
    with SingleTickerProviderStateMixin {
  final ChatService _chatService = getIt<ChatService>();
  final NetworkInfo _networkInfo = getIt<NetworkInfo>();
  late TabController _tabController;

  List<Map<String, dynamic>> _messageRequests = [];
  List<Map<String, dynamic>> _groupRequests = [];
  List<Map<String, dynamic>> _outgoingMessageRequests = [];
  bool _loadingMessage = true;
  bool _loadingGroup = true;
  bool _loadingOutgoing = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadMessageRequests();
    _loadGroupRequests();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMessageRequests() async {
    setState(() {
      _loadingMessage = true;
      _loadingOutgoing = true;
    });
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      if (mounted) {
        setState(() => _loadingMessage = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(kConnectToInternetMessage)),
        );
      }
      return;
    }
    try {
      final incoming = await _chatService
          .getPendingMessageRequestsForCurrentUser();
      final outgoingRaw = await _chatService
          .getOutgoingMessageRequestsForCurrentUser();

      // Deduplicate sent requests per recipient so the same contact doesn’t
      // appear multiple times after resends. Keep the latest request by
      // created_at for each recipient_id.
      final Map<String, Map<String, dynamic>> latestByRecipient = {};
      for (final row in outgoingRaw) {
        final recipientId = row['recipient_id'] as String?;
        if (recipientId == null || recipientId.isEmpty) continue;

        final existing = latestByRecipient[recipientId];
        if (existing == null) {
          latestByRecipient[recipientId] = row;
          continue;
        }

        final existingCreated = existing['created_at'] as String?;
        final currentCreated = row['created_at'] as String?;
        if (existingCreated == null || currentCreated == null) {
          // If we can’t compare, prefer to keep the row we already have.
          continue;
        }

        final existingTime = DateTime.tryParse(existingCreated);
        final currentTime = DateTime.tryParse(currentCreated);
        if (existingTime == null || currentTime == null) {
          continue;
        }

        if (currentTime.isAfter(existingTime)) {
          latestByRecipient[recipientId] = row;
        }
      }

      final outgoing = latestByRecipient.values.toList()
        ..sort((a, b) {
          final aCreated = DateTime.tryParse(
            (a['created_at'] as String?) ?? '',
          );
          final bCreated = DateTime.tryParse(
            (b['created_at'] as String?) ?? '',
          );
          if (aCreated == null && bCreated == null) return 0;
          if (aCreated == null) return 1;
          if (bCreated == null) return -1;
          return bCreated.compareTo(aCreated);
        });
      if (mounted) {
        setState(() {
          _messageRequests = incoming;
          _outgoingMessageRequests = outgoing;
          _loadingMessage = false;
          _loadingOutgoing = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingMessage = false);
    }
  }

  Future<void> _loadGroupRequests() async {
    setState(() => _loadingGroup = true);
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      if (mounted) {
        setState(() => _loadingGroup = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(kConnectToInternetMessage)),
        );
      }
      return;
    }
    try {
      final list = await _chatService
          .getPendingGroupInviteRequestsForCurrentUser();
      if (mounted) {
        setState(() {
          _groupRequests = list;
          _loadingGroup = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingGroup = false);
    }
  }

  Future<void> _acceptMessageRequest(String requestId) async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(kConnectToInternetMessage)),
        );
      }
      return;
    }
    Map<String, dynamic>? req;
    for (final r in _messageRequests) {
      if (r['id'] == requestId) {
        req = r;
        break;
      }
    }
    if (req == null) return;
    final senderId = req['sender_id'] as String?;
    final senderName = req['sender_name'] as String? ?? 'User';
    final senderAvatarUrl = req['sender_avatar_url'] as String?;
    try {
      final conversationId = await _chatService.acceptMessageRequest(requestId);
      if (!mounted) return;
      await _loadMessageRequests();
      if (!mounted) return;
      if (!widget.isEmbedded && context.canPop()) context.pop();
      context.push(
        '/chat_detail',
        extra: {
          'conversationId': conversationId,
          'userId': senderId ?? '',
          'name': senderName,
          'avatarUrl': senderAvatarUrl,
          'isGroup': false,
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              toUserFriendlyErrorMessage(
                e,
                fallback: 'Unable to accept request right now.',
              ),
            ),
          ),
        );
      }
    }
  }

  Future<void> _rejectMessageRequest(String requestId) async {
    try {
      await _chatService.rejectMessageRequest(requestId);
      if (mounted) await _loadMessageRequests();
    } catch (_) {}
  }

  Future<void> _revokeOutgoingMessageRequest(String requestId) async {
    try {
      await _chatService.revokeMessageRequest(requestId);
      if (mounted) await _loadMessageRequests();
    } catch (_) {}
  }

  Future<void> _deleteOutgoingMessageRequest(String requestId) async {
    // Optimistically remove from UI for a snappier experience.
    setState(() {
      _outgoingMessageRequests.removeWhere((r) => r['id'] == requestId);
    });

    try {
      await _chatService.deleteMessageRequest(requestId);
    } catch (e) {
      if (!mounted) return;
      // Reload from backend to stay in sync and show an error.
      await _loadMessageRequests();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            toUserFriendlyErrorMessage(
              e,
              fallback: 'Unable to delete request right now.',
            ),
          ),
        ),
      );
    }
  }

  Future<void> _resendOutgoingMessageRequest(String recipientId) async {
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
      final directConvId = await _chatService.sendMessageRequest(recipientId);
      if (mounted) {
        await _loadMessageRequests();
        if (directConvId != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Direct chat is now available.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Request sent. Waiting for them to accept.'),
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            toUserFriendlyErrorMessage(
              e,
              fallback: 'Unable to resend request right now.',
            ),
          ),
        ),
      );
    }
  }

  Future<void> _acceptGroupRequest(String requestId) async {
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
      await _chatService.acceptGroupInviteRequest(requestId);
      if (!mounted) return;
      await _loadGroupRequests();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('You joined the group')));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              toUserFriendlyErrorMessage(
                e,
                fallback: 'Unable to join group right now.',
              ),
            ),
          ),
        );
      }
    }
  }

  Future<void> _rejectGroupRequest(String requestId) async {
    try {
      await _chatService.rejectGroupInviteRequest(requestId);
      if (mounted) await _loadGroupRequests();
    } catch (_) {}
  }

  Future<void> _showIncomingRequestActions(Map<String, dynamic> request) async {
    final id = request['id'] as String;
    final senderId = request['sender_id'] as String?;

    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('View profile'),
                onTap: () {
                  Navigator.of(context).pop();
                  if (senderId != null && senderId.isNotEmpty) {
                    _navigateToUserProfile(senderId);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: const Text('Accept request'),
                onTap: () {
                  Navigator.of(context).pop();
                  _acceptMessageRequest(id);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Delete request'),
                onTap: () {
                  Navigator.of(context).pop();
                  _rejectMessageRequest(id);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showOutgoingRequestActions(Map<String, dynamic> request) async {
    final id = request['id'] as String;
    final recipientId = request['recipient_id'] as String?;
    final status = (request['status'] as String?) ?? 'pending';

    final isPending = status == 'pending';
    final isExpired = status == 'expired';
    final isRevoked = status == 'revoked';
    final isAccepted = status == 'accepted';

    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('View profile'),
                onTap: () {
                  Navigator.of(context).pop();
                  if (recipientId != null && recipientId.isNotEmpty) {
                    _navigateToUserProfile(recipientId);
                  }
                },
              ),
              if (isPending)
                ListTile(
                  leading: const Icon(Icons.cancel_outlined),
                  title: const Text('Revoke request'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _revokeOutgoingMessageRequest(id);
                  },
                ),
              if (isExpired)
                ListTile(
                  leading: const Icon(Icons.refresh),
                  title: const Text('Resend request'),
                  onTap: () {
                    Navigator.of(context).pop();
                    if (recipientId != null && recipientId.isNotEmpty) {
                      _resendOutgoingMessageRequest(recipientId);
                    }
                  },
                ),
              if (isExpired || isRevoked || isAccepted)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text('Delete from list'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _deleteOutgoingMessageRequest(id);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final t = Translations.of(context);

    final body = Column(
      children: [
        if (widget.isEmbedded)
          Container(
            margin: const EdgeInsets.fromLTRB(0, 4, 0, 0),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(30),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurfaceVariant,
              indicator: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(30),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelStyle: GoogleFonts.inter(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.inter(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
              tabs: [
                Tab(text: t.chat.messageRequests),
                Tab(text: t.chat.groupRequests),
              ],
            ),
          ),
        const SizedBox(height: 8),
        Expanded(
          child: SafeArea(
            top: false,
            left: false,
            right: false,
            child: TabBarView(
              controller: _tabController,
              children: [
                // ── Message Requests ──────────────────────────────
                _loadingMessage && _loadingOutgoing
                    ? Center(
                        child: CircularProgressIndicator(
                          color: colorScheme.onSurface,
                        ),
                      )
                    : ListView(
                        padding: EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 2.w,
                        ),
                        children: [
                          // Incoming
                          Text(
                            'Incoming requests',
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 6),
                          if (_loadingMessage)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: CircularProgressIndicator(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            )
                          else if (_messageRequests.isEmpty)
                            _buildEmptyState(
                              icon: Icons.mail_outline_rounded,
                              label: t.chat.noMessageRequests,
                              colorScheme: colorScheme,
                            )
                          else
                            ..._messageRequests.map((r) {
                              final id = r['id'] as String;
                              final name =
                                  r['sender_name'] as String? ?? 'Someone';
                              final avatarUrl =
                                  r['sender_avatar_url'] as String?;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _buildRequestCard(
                                  isDark: isDark,
                                  colorScheme: colorScheme,
                                  avatarUrl: avatarUrl,
                                  name: name,
                                  subtitle: t.chat.wantsToChat,
                                  isGroup: false,
                                  onAccept: () => _acceptMessageRequest(id),
                                  onReject: () => _rejectMessageRequest(id),
                                  acceptLabel: t.chat.accept,
                                  rejectLabel: t.common.delete,
                                  onLongPress: () =>
                                      _showIncomingRequestActions(r),
                                ),
                              );
                            }),

                          const SizedBox(height: 16),
                          Divider(
                            color: colorScheme.outlineVariant.withValues(
                              alpha: 0.4,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Sent
                          Text(
                            'Sent requests',
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 6),
                          if (_loadingOutgoing)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: CircularProgressIndicator(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            )
                          else if (_outgoingMessageRequests.isEmpty)
                            _buildEmptyState(
                              icon: Icons.outgoing_mail,
                              label: 'No sent requests',
                              colorScheme: colorScheme,
                            )
                          else
                            ..._outgoingMessageRequests.map((r) {
                              final id = r['id'] as String;
                              final name =
                                  r['recipient_name'] as String? ?? 'Someone';
                              final avatarUrl =
                                  r['recipient_avatar_url'] as String?;
                              final status =
                                  (r['status'] as String?) ?? 'pending';
                              final statusLabel = _mapRequestStatusLabel(
                                status,
                              );

                              final canRevoke = status == 'pending';
                              final canDelete =
                                  status == 'expired' ||
                                  status == 'revoked' ||
                                  status == 'accepted';
                              final canResend = status == 'expired';

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _buildRequestCard(
                                  isDark: isDark,
                                  colorScheme: colorScheme,
                                  avatarUrl: avatarUrl,
                                  name: name,
                                  subtitle: statusLabel,
                                  isGroup: false,
                                  onAccept: () {},
                                  onReject: canRevoke
                                      ? () => _revokeOutgoingMessageRequest(id)
                                      : canResend
                                      ? () => _resendOutgoingMessageRequest(
                                          r['recipient_id'] as String,
                                        )
                                      : (canDelete
                                            ? () =>
                                                  _deleteOutgoingMessageRequest(
                                                    id,
                                                  )
                                            : () {}),
                                  acceptLabel: '',
                                  rejectLabel: canRevoke
                                      ? 'Revoke'
                                      : canResend
                                      ? 'Resend'
                                      : (canDelete ? 'Delete' : ''),
                                  onLongPress: () =>
                                      _showOutgoingRequestActions(r),
                                ),
                              );
                            }),
                        ],
                      ),

                // ── Group Requests ────────────────────────────────
                _loadingGroup
                    ? Center(
                        child: CircularProgressIndicator(
                          color: colorScheme.onSurface,
                        ),
                      )
                    : _groupRequests.isEmpty
                    ? _buildEmptyState(
                        icon: Icons.group_outlined,
                        label: t.chat.noGroupRequests,
                        colorScheme: colorScheme,
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 2.w,
                        ),
                        itemCount: _groupRequests.length,
                        itemBuilder: (context, index) {
                          final r = _groupRequests[index];
                          final id = r['id'] as String;
                          final groupName =
                              r['group_name'] as String? ?? 'Group';
                          final inviterName =
                              r['inviter_name'] as String? ?? 'Someone';
                          final inviteDisplayName = '$inviterName • $groupName';
                          final avatarUrl = r['group_avatar_url'] as String?;
                          return _buildRequestCard(
                            isDark: isDark,
                            colorScheme: colorScheme,
                            avatarUrl: avatarUrl,
                            name: groupName,
                            subtitle: t.chat.addedYouTo(
                              name: inviteDisplayName,
                            ),
                            isGroup: true,
                            onAccept: () => _acceptGroupRequest(id),
                            onReject: () => _rejectGroupRequest(id),
                            acceptLabel: t.chat.accept,
                            rejectLabel: t.common.delete,
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ],
    );

    if (widget.isEmbedded) {
      return body;
    }

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: Text(
          t.chat.requests,
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: t.chat.messageRequests),
            Tab(text: t.chat.groupRequests),
          ],
        ),
      ),
      body: SafeArea(child: body),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String label,
    required ColorScheme colorScheme,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 34,
              color: colorScheme.primary.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard({
    required bool isDark,
    required ColorScheme colorScheme,
    required String? avatarUrl,
    required String name,
    required String subtitle,
    required bool isGroup,
    required VoidCallback onAccept,
    required VoidCallback onReject,
    required String acceptLabel,
    required String rejectLabel,
    VoidCallback? onLongPress,
  }) {
    final hasAccept = acceptLabel.isNotEmpty;
    final hasReject = rejectLabel.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.7)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              ProfileAvatar(
                avatarUrl: avatarUrl,
                displayName: name,
                radius: 6.w,
                backgroundColor: colorScheme.primaryContainer,
                isGroup: isGroup,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.5.sp,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (hasAccept || hasReject)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (hasAccept)
                      SizedBox(
                        height: 32,
                        child: FilledButton(
                          onPressed: onAccept,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            textStyle: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: Text(acceptLabel),
                        ),
                      ),
                    if (hasAccept && hasReject) const SizedBox(height: 6),
                    if (hasReject)
                      SizedBox(
                        height: 28,
                        child: TextButton(
                          onPressed: onReject,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            foregroundColor: colorScheme.error,
                            textStyle: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          child: Text(rejectLabel),
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

  String _mapRequestStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'accepted':
        return 'Accepted';
      case 'rejected':
        return 'Rejected';
      case 'expired':
        return 'Expired';
      case 'revoked':
        return 'Revoked';
      default:
        return status;
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
        logger.info('[ChatRequests] Missing userId - account deleted');
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
          '[ChatRequests] User $normalizedUserId not found - account deleted',
        );
        return UserNavigationStatus.userDeleted;
      }

      // Check blocking status
      try {
        final blockService = getIt<UserBlockService>();
        final isBlocked = await blockService.isUserBlocked(normalizedUserId);
        if (isBlocked) {
          logger.info('[ChatRequests] We have blocked user $normalizedUserId');
          return UserNavigationStatus.blockedByUs;
        }

        final blockedMe = await blockService.getUsersWhoBlockedMe();
        if (blockedMe.contains(normalizedUserId)) {
          logger.info('[ChatRequests] User $normalizedUserId has blocked us');
          return UserNavigationStatus.blockedByThem;
        }
      } catch (e) {
        logger.warning('[ChatRequests] Error checking block status: $e');
        // On error checking blocks, allow navigation - profile page will handle it
      }

      return UserNavigationStatus.canNavigate;
    } catch (e) {
      final logger = getIt<Talker>();
      logger.warning('[ChatRequests] Error validating user: $e');
      // On network/validation error, allow navigation to be graceful
      return UserNavigationStatus.canNavigate;
    }
  }

  /// Navigate to user profile with validation
  Future<void> _navigateToUserProfile(String userId) async {
    if (userId.trim().isEmpty) {
      _showUserDeletedDialog();
      return;
    }

    final status = await _validateUserBeforeNavigation(userId);

    if (!mounted) return;

    switch (status) {
      case UserNavigationStatus.canNavigate:
        ProfileRoute(userId: userId).push(context);
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

  /// Show dialog when user account has been deleted
  void _showUserDeletedDialog() {
    final colorScheme = Theme.of(context).colorScheme;

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
    final colorScheme = Theme.of(context).colorScheme;

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
              // Unblock functionality would go here
              // For now, just show success message
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('User unblocked')));
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
    final colorScheme = Theme.of(context).colorScheme;

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
}
