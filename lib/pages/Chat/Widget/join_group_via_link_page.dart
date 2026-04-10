import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/utils/app_error_message.dart';
import 'package:myitihas/services/chat_service.dart';
import 'package:sizer/sizer.dart';

class JoinGroupViaLinkPage extends StatefulWidget {
  final String inviteCode;

  const JoinGroupViaLinkPage({super.key, required this.inviteCode});

  @override
  State<JoinGroupViaLinkPage> createState() => _JoinGroupViaLinkPageState();
}

class _JoinGroupViaLinkPageState extends State<JoinGroupViaLinkPage> {
  final ChatService _chatService = getIt<ChatService>();

  GroupInviteLinkPreview? _preview;
  bool _isLoading = true;
  bool _isJoining = false;
  String? _stateMessage;

  @override
  void initState() {
    super.initState();
    _loadPreview();
  }

  Future<void> _loadPreview() async {
    setState(() {
      _isLoading = true;
      _stateMessage = null;
    });

    try {
      final preview = await _chatService.getGroupInviteLinkPreview(
        widget.inviteCode,
      );
      if (!mounted) return;
      setState(() {
        _preview = preview;
        _isLoading = false;
        if (preview == null) {
          _stateMessage = 'Invalid link';
        } else if (preview.isMember) {
          _stateMessage = 'Already a member';
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _stateMessage = 'Invalid link';
      });
    }
  }

  Future<void> _joinGroup() async {
    if (_preview == null || _isJoining) return;

    setState(() {
      _isJoining = true;
    });

    try {
      final status = await _chatService.joinGroupViaInviteLink(widget.inviteCode);
      if (!mounted) return;

      setState(() {
        _isJoining = false;
        _stateMessage = status == 'already_member' ? 'Already a member' : 'Joined successfully';
      });

      // Direct join flow: navigate to the group chat once the join succeeds.
      if (status == 'joined' || status == 'already_member') {
        context.push(
          '/chat_detail',
          extra: {
            'conversationId': _preview!.conversationId,
            'name': _preview!.groupName,
            'avatarUrl': _preview!.groupAvatarUrl,
            'isGroup': true,
            'userId': '',
          },
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isJoining = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            toUserFriendlyErrorMessage(
              e,
              fallback: 'Link expired or invalid. Please ask for a new invite.',
            ),
          ),
        ),
      );
    }
  }

  String _avatarFallbackText(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'GR';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.substring(0, parts.first.length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Invite'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _isLoading ? _buildLoadingState(colorScheme) : _buildContentState(colorScheme),
        ),
      ),
    );
  }

  Widget _buildLoadingState(ColorScheme colorScheme) {
    return Column(
      children: [
        _skeletonBox(height: 56, width: 56, radius: 28, colorScheme: colorScheme),
        const SizedBox(height: 16),
        _skeletonBox(height: 20, width: 58.w, radius: 6, colorScheme: colorScheme),
        const SizedBox(height: 8),
        _skeletonBox(height: 16, width: 70.w, radius: 6, colorScheme: colorScheme),
        const SizedBox(height: 8),
        _skeletonBox(height: 16, width: 75.w, radius: 6, colorScheme: colorScheme),
        const SizedBox(height: 24),
        _skeletonBox(height: 44, width: 100.w, radius: 12, colorScheme: colorScheme),
      ],
    );
  }

  Widget _buildContentState(ColorScheme colorScheme) {
    if (_preview == null) {
      return _buildMessageOnly(
        message: _stateMessage ?? 'Invalid link',
        colorScheme: colorScheme,
      );
    }

    final preview = _preview!;
    final stateText = _stateMessage;
    final formattedExpiry = DateFormat('dd MMM yyyy, hh:mm a').format(preview.expiresAt.toLocal());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.1)),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                label: 'Group avatar',
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: colorScheme.primaryContainer,
                  backgroundImage: preview.groupAvatarUrl != null && preview.groupAvatarUrl!.isNotEmpty
                      ? NetworkImage(preview.groupAvatarUrl!)
                      : null,
                  child: (preview.groupAvatarUrl == null || preview.groupAvatarUrl!.isEmpty)
                      ? Text(
                          _avatarFallbackText(preview.groupName),
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      preview.groupName,
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${preview.memberCount} members · Admin: ${preview.adminName}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (preview.groupDescription != null &&
                        preview.groupDescription!.trim().isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        preview.groupDescription!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      'Link valid till $formattedExpiry',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (stateText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              stateText,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: colorScheme.tertiary,
              ),
            ),
          ),
        SizedBox(
          height: 44,
          child: ElevatedButton(
            onPressed: (_isJoining || preview.isMember) ? null : _joinGroup,
            child: _isJoining
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Join Group'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 44,
          child: TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageOnly({required String message, required ColorScheme colorScheme}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          message,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 44,
          width: double.infinity,
          child: TextButton(
            onPressed: () => context.pop(),
            child: const Text('Close'),
          ),
        ),
      ],
    );
  }

  Widget _skeletonBox({
    required double height,
    required double width,
    required double radius,
    required ColorScheme colorScheme,
  }) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
