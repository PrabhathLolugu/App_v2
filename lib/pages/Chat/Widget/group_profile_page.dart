// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/utils/app_error_message.dart';
import 'package:myitihas/core/widgets/profile_avatar/profile_avatar.dart';
import 'package:myitihas/core/widgets/voice_input/voice_input_button.dart';
import 'package:myitihas/services/chat_service.dart';
import 'package:myitihas/services/profile_service.dart';
import 'package:myitihas/services/supabase_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

class GroupProfilePage extends StatefulWidget {
  final String conversationId;

  const GroupProfilePage({super.key, required this.conversationId});

  @override
  State<GroupProfilePage> createState() => _GroupProfilePageState();
}

class _GroupProfilePageState extends State<GroupProfilePage> {
  final ProfileService _profileService = getIt<ProfileService>();
  final TextEditingController _searchController = TextEditingController();
  final ChatService _chatService = getIt<ChatService>();

  bool _isLoading = true;
  bool _isSearching = false;
  String _groupName = '';
  String? _groupAvatarUrl;
  String? _groupDescription;
  List<Map<String, dynamic>> _members = [];
  List<Map<String, dynamic>> _filteredMembers = [];
  String? _currentUserId;
  String? _groupOwnerId;
  List<Map<String, dynamic>> _pendingInvites = [];

  @override
  void initState() {
    super.initState();
    _currentUserId = SupabaseService.client.auth.currentUser?.id;
    _loadGroupData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _currentUserCanEditGroup {
    if (_currentUserId == null) return false;
    for (final m in _members) {
      if (m['user_id'] == _currentUserId) {
        final isOwner = m['is_owner'] == true;
        final role = m['role'] as String? ?? 'member';
        return isOwner || role == 'owner' || role == 'admin';
      }
    }
    return false;
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredMembers = _members;
      } else {
        _filteredMembers = _members.where((member) {
          final name = (member['name'] as String? ?? '').toLowerCase();
          return name.contains(query);
        }).toList();
      }
    });
  }

  Future<void> _loadGroupData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final conversationData = await SupabaseService.client
          .from('conversations')
          .select('group_name, group_avatar_url, group_description, created_by')
          .eq('id', widget.conversationId)
          .single();

      _groupName = conversationData['group_name'] ?? 'Group';
      _groupAvatarUrl = conversationData['group_avatar_url'];
      _groupDescription = conversationData['group_description'];
      _groupOwnerId = conversationData['created_by'];

      final membersData = await SupabaseService.client
          .from('conversation_members')
          .select('user_id, role')
          .eq('conversation_id', widget.conversationId);

      final List<Map<String, dynamic>> membersList = [];
      for (final memberData in membersData) {
        try {
          final userId = memberData['user_id'] as String;
          final role = memberData['role'] as String? ?? 'member';

          final profile = await _profileService.getProfileById(userId);

          membersList.add({
            'user_id': userId,
            'name': profile['full_name'] ?? profile['username'] ?? 'Unknown',
            'avatar_url': profile['avatar_url'],
            'role': role,
            'is_current_user': userId == _currentUserId,
            'is_owner': userId == _groupOwnerId,
          });
        } catch (e) {
          print('Error fetching profile for member: $e');
        }
      }

      membersList.sort((a, b) {
        final aIsOwner = a['is_owner'] == true;
        final bIsOwner = b['is_owner'] == true;
        final aIsCurrentUser = a['is_current_user'] == true;
        final bIsCurrentUser = b['is_current_user'] == true;
        final aIsAdmin = a['role'] == 'admin';
        final bIsAdmin = b['role'] == 'admin';

        if (aIsOwner && !bIsOwner) return -1;
        if (!aIsOwner && bIsOwner) return 1;
        if (aIsCurrentUser && !bIsCurrentUser) return -1;
        if (!aIsCurrentUser && bIsCurrentUser) return 1;
        if (aIsAdmin && !bIsAdmin) return -1;
        if (!aIsAdmin && bIsAdmin) return 1;
        return 0;
      });

      setState(() {
        _members = membersList;
        _filteredMembers = membersList;
      });

      if (_currentUserCanEditGroup) {
        await _loadPendingInvites();
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading group data: $e');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              toUserFriendlyErrorMessage(
                e,
                fallback: 'Failed to load group data. Please try again.',
              ),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = colorScheme.surface;
    final textColor = colorScheme.onSurface;
    final subTextColor = colorScheme.onSurfaceVariant;
    final accentColor = colorScheme.primary;
    final groupColor = colorScheme.secondary;
    final dangerColor = colorScheme.error;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 18.sp),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 18.sp),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (_currentUserCanEditGroup)
            IconButton(
              icon: Icon(Icons.edit, color: textColor, size: 20.sp),
              onPressed: () async {
                final result = await context.push(
                  '/edit_group',
                  extra: {'conversationId': widget.conversationId},
                );
                if (result == true) {
                  _loadGroupData();
                }
              },
            ),
          if (_currentUserCanEditGroup)
            IconButton(
              icon: Icon(Icons.link, color: textColor, size: 20.sp),
              onPressed: () => _showInviteLinkSheet(context),
            ),
          if (_currentUserCanEditGroup)
            IconButton(
              icon: Icon(Icons.person_add_alt_1, color: textColor, size: 20.sp),
              onPressed: () async {
                final memberIds = _members
                    .map((m) => m['user_id'] as String)
                    .toList();

                final result = await context.push(
                  '/add_group_members',
                  extra: {
                    'conversationId': widget.conversationId,
                    'existingMemberIds': memberIds,
                  },
                );

                if (result == true) {
                  _loadGroupData();
                }
              },
            ),
          SizedBox(width: 2.w),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 2.h),

              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 42.w,
                      height: 42.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: groupColor.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                    ),
                    _groupAvatarUrl != null && _groupAvatarUrl!.isNotEmpty
                        ? Container(
                            width: 38.w,
                            height: 38.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                _groupAvatarUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildFallbackAvatar(groupColor);
                                },
                              ),
                            ),
                          )
                        : _buildFallbackAvatar(groupColor),
                  ],
                ),
              ),

              SizedBox(height: 2.h),

              Text(
                _groupName,
                style: GoogleFonts.inter(
                  color: textColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 1.h),

              Text(
                "Group · ${_members.length} members",
                style: GoogleFonts.inter(color: subTextColor, fontSize: 14.sp),
              ),

              SizedBox(height: 2.h),

              if (_groupDescription != null && _groupDescription!.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    _groupDescription!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: textColor,
                      fontSize: 14.sp,
                      height: 1.5,
                    ),
                  ),
                ),
              if (_groupDescription != null && _groupDescription!.isNotEmpty)
                SizedBox(height: 1.h),

              SizedBox(height: 3.h),
              Divider(color: subTextColor.withValues(alpha: 0.1), thickness: 1),

              if (_currentUserCanEditGroup) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pending invitations',
                        style: GoogleFonts.inter(
                          color: subTextColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_pendingInvites.isNotEmpty)
                        Text(
                          '${_pendingInvites.length}',
                          style: GoogleFonts.inter(
                            color: subTextColor,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
                if (_pendingInvites.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'No pending invitations',
                        style: GoogleFonts.inter(
                          color: subTextColor,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: _pendingInvites.length,
                    itemBuilder: (context, index) {
                      final invite = _pendingInvites[index];
                      final inviteeName =
                          invite['invitee_name'] as String? ?? 'User';
                      final avatarUrl = invite['invitee_avatar_url'] as String?;
                      final status = (invite['status'] as String?) ?? 'pending';
                      final createdAt = invite['created_at'] as String?;
                      final expiresAt = invite['expires_at'] as String?;

                      final statusLabel = _mapInviteStatusLabel(status);

                      String? subtitle;
                      if (expiresAt != null && status == 'pending') {
                        subtitle = _formatInviteTimestamp(
                          expiresAt,
                          prefix: 'Expires',
                        );
                      } else if (createdAt != null) {
                        subtitle = _formatInviteTimestamp(
                          createdAt,
                          prefix: 'Invited',
                        );
                      }

                      final canRevoke = status == 'pending';
                      final canResend =
                          status == 'pending' ||
                          status == 'expired' ||
                          status == 'revoked';

                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 0.5.h,
                        ),
                        leading: ProfileAvatar(
                          avatarUrl: avatarUrl?.toString(),
                          displayName: inviteeName,
                          radius: 18.sp,
                          backgroundColor: accentColor.withValues(alpha: 0.2),
                        ),
                        title: Text(
                          inviteeName,
                          style: GoogleFonts.inter(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                        subtitle: Text(
                          subtitle ?? statusLabel,
                          style: GoogleFonts.inter(
                            color: subTextColor,
                            fontSize: 12.sp,
                          ),
                        ),
                        trailing: (canRevoke || canResend)
                            ? Wrap(
                                spacing: 8,
                                children: [
                                  if (canRevoke)
                                    TextButton(
                                      onPressed: () => _revokeInvite(
                                        context,
                                        invite['id'] as String,
                                        inviteeName,
                                        dangerColor,
                                      ),
                                      style: TextButton.styleFrom(
                                        foregroundColor: dangerColor,
                                      ),
                                      child: const Text('Revoke'),
                                    ),
                                  if (canResend)
                                    TextButton(
                                      onPressed: () => _resendInvite(
                                        context,
                                        invite['conversation_id'] as String,
                                        invite['invitee_id'] as String,
                                        inviteeName,
                                        accentColor,
                                      ),
                                      child: const Text('Resend'),
                                    ),
                                ],
                              )
                            : Text(
                                statusLabel,
                                style: GoogleFonts.inter(
                                  color: subTextColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      );
                    },
                  ),

                Divider(
                  color: subTextColor.withValues(alpha: 0.1),
                  thickness: 1,
                ),
              ],

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${_members.length} members",
                      style: GoogleFonts.inter(
                        color: subTextColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isSearching ? Icons.close : Icons.search,
                        color: subTextColor,
                        size: 18.sp,
                      ),
                      onPressed: () {
                        setState(() {
                          _isSearching = !_isSearching;
                          if (!_isSearching) {
                            _searchController.clear();
                            _filteredMembers = _members;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),

              if (_isSearching)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: GoogleFonts.inter(color: textColor),
                    decoration: InputDecoration(
                      hintText: 'Search members...',
                      suffixIcon: VoiceInputButton(
                        controller: _searchController,
                        compact: true,
                      ),
                      hintStyle: GoogleFonts.inter(color: subTextColor),
                      prefixIcon: Icon(Icons.search, color: subTextColor),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerLow,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.h,
                      ),
                    ),
                  ),
                ),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: _filteredMembers.length,
                itemBuilder: (context, index) {
                  final user = _filteredMembers[index];
                  final isOwner = user['is_owner'] == true;
                  final isAdmin = user['role'] == 'admin';
                  final isCurrentUser = user['is_current_user'] == true;
                  final currentUserIsOwner = _currentUserId == _groupOwnerId;

                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 0.5.h,
                    ),
                    leading: ProfileAvatar(
                      avatarUrl: user['avatar_url']?.toString(),
                      displayName: isCurrentUser
                          ? 'You'
                          : (user['name'] ?? 'User'),
                      radius: 20.sp,
                      backgroundColor: accentColor.withValues(alpha: 0.2),
                    ),
                    title: Text(
                      isCurrentUser ? 'You' : user['name'],
                      style: GoogleFonts.inter(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                      ),
                    ),
                    subtitle: Text(
                      isOwner ? 'Owner' : (isAdmin ? 'Admin' : 'Member'),
                      style: GoogleFonts.inter(
                        color: subTextColor,
                        fontSize: 14.sp,
                      ),
                    ),
                    trailing: isOwner
                        ? Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 0.5.h,
                            ),
                            decoration: BoxDecoration(
                              color: groupColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: groupColor.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Text(
                              "Group Owner",
                              style: TextStyle(
                                color: groupColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : isAdmin
                        ? Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 0.5.h,
                            ),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: accentColor.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              "Group Admin",
                              style: TextStyle(
                                color: accentColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : null,
                    onTap: () {
                      if (!isCurrentUser && _currentUserCanEditGroup) {
                        _showMemberOptions(
                          context,
                          user['user_id']!,
                          user['name']!,
                          isAdmin,
                          isOwner,
                          currentUserIsOwner,
                          isDark,
                          textColor,
                          subTextColor,
                          accentColor,
                          dangerColor,
                        );
                      }
                    },
                  );
                },
              ),

              Divider(color: subTextColor.withValues(alpha: 0.1), thickness: 1),

              if (_currentUserCanEditGroup &&
                  _groupAvatarUrl != null &&
                  _groupAvatarUrl!.isNotEmpty)
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
                  leading: Icon(Icons.delete_outline, color: dangerColor),
                  title: Text(
                    "Remove Group Icon",
                    style: TextStyle(
                      color: dangerColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () => _removeGroupIcon(context, dangerColor),
                ),

              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
                leading: Icon(Icons.exit_to_app, color: dangerColor),
                title: Text(
                  "Exit Group",
                  style: TextStyle(
                    color: dangerColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () => _exitGroup(context, dangerColor),
              ),

              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
                leading: Icon(
                  Icons.thumb_down_alt_outlined,
                  color: dangerColor,
                ),
                title: Text(
                  "Report Group",
                  style: TextStyle(
                    color: dangerColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {},
              ),

              SizedBox(height: 3.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showMemberOptions(
    BuildContext context,
    String userId,
    String memberName,
    bool isAdmin,
    bool isOwner,
    bool currentUserIsOwner,
    bool isDark,
    Color textColor,
    Color subTextColor,
    Color accentColor,
    Color dangerColor,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 2.h),
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: subTextColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Text(
                  memberName,
                  style: GoogleFonts.inter(
                    color: textColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Divider(color: subTextColor.withValues(alpha: 0.1), height: 1),
              ListTile(
                leading: Icon(
                  Icons.person_outline,
                  color: accentColor,
                  size: 20.sp,
                ),
                title: Text(
                  'View Profile',
                  style: GoogleFonts.inter(
                    color: textColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  context.pop();
                },
              ),
              if (currentUserIsOwner && !isOwner)
                ListTile(
                  leading: Icon(
                    isAdmin
                        ? Icons.remove_moderator_outlined
                        : Icons.admin_panel_settings_outlined,
                    color: accentColor,
                    size: 20.sp,
                  ),
                  title: Text(
                    isAdmin ? 'Dismiss as Admin' : 'Make Group Admin',
                    style: GoogleFonts.inter(
                      color: textColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    context.pop();
                    _toggleAdminStatus(
                      context,
                      userId,
                      memberName,
                      isAdmin,
                      accentColor,
                    );
                  },
                ),
              if (!isOwner)
                ListTile(
                  leading: Icon(
                    Icons.person_remove_outlined,
                    color: dangerColor,
                    size: 20.sp,
                  ),
                  title: Text(
                    'Remove from Group',
                    style: GoogleFonts.inter(
                      color: dangerColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    context.pop();
                    _removeMember(context, userId, memberName, dangerColor);
                  },
                ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  Future<void> _removeGroupIcon(BuildContext context, Color dangerColor) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Group Icon'),
        content: const Text('Are you sure you want to remove the group icon?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: dangerColor),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      if (_groupAvatarUrl != null && _groupAvatarUrl!.isNotEmpty) {
        final oldPath = '${widget.conversationId}/avatar.jpg';
        await SupabaseService.client.storage.from('group_avatar').remove([
          oldPath,
        ]);
      }

      await SupabaseService.client
          .from('conversations')
          .update({'group_avatar_url': null})
          .eq('id', widget.conversationId);

      await _loadGroupData();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Group icon removed')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            toUserFriendlyErrorMessage(
              e,
              fallback: 'Failed to remove group icon. Please try again.',
            ),
          ),
        ),
      );
    }
  }

  Future<void> _exitGroup(BuildContext context, Color dangerColor) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Group'),
        content: const Text('Are you sure you want to exit this group?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: dangerColor),
            child: const Text('Exit'),
          ),
        ],
      ),
    );

    if (confirmed == true && _currentUserId != null) {
      try {
        await _chatService.leaveGroupConversation(widget.conversationId);

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You have left the group')),
        );
        context.pop();
        context.pop();
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              toUserFriendlyErrorMessage(
                e,
                fallback: 'Failed to exit group. Please try again.',
              ),
            ),
          ),
        );
      }
    }
  }

  Future<void> _removeMember(
    BuildContext context,
    String userId,
    String memberName,
    Color dangerColor,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Member'),
        content: Text(
          'Are you sure you want to remove $memberName from this group?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: dangerColor),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _chatService.removeGroupMember(
          conversationId: widget.conversationId,
          memberUserId: userId,
        );

        await _loadGroupData();

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$memberName removed from group')),
        );
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              toUserFriendlyErrorMessage(
                e,
                fallback: 'Failed to remove member. Please try again.',
              ),
            ),
          ),
        );
      }
    }
  }

  Future<void> _toggleAdminStatus(
    BuildContext context,
    String userId,
    String memberName,
    bool isCurrentlyAdmin,
    Color accentColor,
  ) async {
    final newRole = isCurrentlyAdmin ? 'member' : 'admin';
    final action = isCurrentlyAdmin
        ? 'dismiss $memberName as admin'
        : 'make $memberName a group admin';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isCurrentlyAdmin ? 'Dismiss Admin' : 'Make Admin'),
        content: Text('Are you sure you want to $action?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: accentColor),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await SupabaseService.client
            .from('conversation_members')
            .update({'role': newRole})
            .eq('conversation_id', widget.conversationId)
            .eq('user_id', userId);

        await _loadGroupData();

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isCurrentlyAdmin
                  ? '$memberName is now a member'
                  : '$memberName is now an admin',
            ),
          ),
        );
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              toUserFriendlyErrorMessage(
                e,
                fallback: 'Failed to update role. Please try again.',
              ),
            ),
          ),
        );
      }
    }
  }

  Widget _buildFallbackAvatar(Color groupColor) {
    return Container(
      width: 38.w,
      height: 38.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: groupColor.withValues(alpha: 0.2),
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.people_rounded,
          size: 19.w,
          color: groupColor.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  String _mapInviteStatusLabel(String status) {
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

  String _formatInviteTimestamp(String timestamp, {required String prefix}) {
    try {
      final dateTime = DateTime.parse(timestamp).toLocal();
      final now = DateTime.now();
      final dateOnly = DateTime(dateTime.year, dateTime.month, dateTime.day);
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));
      final timeText = DateFormat('h:mm a').format(dateTime);

      if (dateOnly == today) {
        return '$prefix today at $timeText';
      }
      if (dateOnly == tomorrow) {
        return '$prefix tomorrow at $timeText';
      }

      final dateText = DateFormat('dd MMM yyyy').format(dateTime);
      return '$prefix on $dateText at $timeText';
    } catch (_) {
      return '$prefix soon';
    }
  }

  Future<void> _loadPendingInvites() async {
    try {
      final invites = await _chatService.getGroupInvitesForConversation(
        widget.conversationId,
      );
      if (!mounted) return;
      setState(() {
        _pendingInvites = invites;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            toUserFriendlyErrorMessage(
              e,
              fallback: 'Failed to load invitations. Please try again.',
            ),
          ),
        ),
      );
    }
  }

  Future<void> _revokeInvite(
    BuildContext context,
    String inviteId,
    String inviteeName,
    Color dangerColor,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Revoke Invitation'),
        content: Text(
          'Are you sure you want to revoke the invitation for $inviteeName?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: dangerColor),
            child: const Text('Revoke'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _chatService.revokeGroupInvite(inviteId);
      await _loadPendingInvites();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invitation revoked for $inviteeName')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            toUserFriendlyErrorMessage(
              e,
              fallback: 'Failed to revoke invitation. Please try again.',
            ),
          ),
        ),
      );
    }
  }

  Future<void> _resendInvite(
    BuildContext context,
    String conversationId,
    String inviteeId,
    String inviteeName,
    Color accentColor,
  ) async {
    try {
      await _chatService.resendGroupInvite(conversationId, inviteeId);
      await _loadPendingInvites();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invitation resent to $inviteeName')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            toUserFriendlyErrorMessage(
              e,
              fallback: 'Failed to resend invitation. Please try again.',
            ),
          ),
        ),
      );
    }
  }

  Future<void> _showInviteLinkSheet(BuildContext context) async {
    try {
      final result = await _chatService.generateGroupInviteLink(
        widget.conversationId,
      );

      if (!context.mounted) return;

      final link = result['link'] as String? ?? '';
      final groupName = result['group_name'] as String? ?? _groupName;
      final expiresAtRaw = result['expires_at'] as String?;
      String expiresText = '30 days';
      if (expiresAtRaw != null) {
        try {
          final dt = DateTime.parse(expiresAtRaw).toLocal();
          expiresText = DateFormat('dd MMM yyyy, h:mm a').format(dt);
        } catch (_) {}
      }

      await showModalBottomSheet<void>(
        context: context,
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (sheetContext) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Group Invite',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    groupName,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Link valid till $expiresText',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(sheetContext).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(sheetContext)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(
                      link,
                      style: GoogleFonts.inter(fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await Share.share('Join $groupName on MyItihas: $link');
                      },
                      child: const Text('Share Invite Link'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: link));
                        if (!sheetContext.mounted) return;
                        ScaffoldMessenger.of(sheetContext).showSnackBar(
                          const SnackBar(content: Text('Invite link copied')),
                        );
                      },
                      child: const Text('Copy Link'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            toUserFriendlyErrorMessage(
              e,
              fallback: 'Failed to generate invite link. Please try again.',
            ),
          ),
        ),
      );
    }
  }
}
