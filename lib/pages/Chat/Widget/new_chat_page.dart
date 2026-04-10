// ignore_for_file: avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/errors/exceptions.dart';
import 'package:myitihas/core/network/network_info.dart';
import 'package:myitihas/core/utils/app_error_message.dart';
import 'package:myitihas/core/widgets/voice_input/voice_input_button.dart';
import 'package:myitihas/services/chat_service.dart';
import 'package:myitihas/services/follow_service.dart';
import 'package:myitihas/services/profile_service.dart';
import 'package:myitihas/services/user_block_service.dart';
import 'package:myitihas/utils/constants.dart';
import 'package:sizer/sizer.dart';

class NewChatPage extends StatefulWidget {
  const NewChatPage({super.key});

  @override
  State<NewChatPage> createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  final ProfileService _profileService = getIt<ProfileService>();
  final ChatService _chatService = getIt<ChatService>();
  final UserBlockService _blockService = getIt<UserBlockService>();
  final FollowService _followService = getIt<FollowService>();
  final NetworkInfo _networkInfo = getIt<NetworkInfo>();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _filteredUsers = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      setState(() {
        _errorMessage = kConnectToInternetMessage;
        _isLoading = false;
      });
      return;
    }

    try {
      final users = await _profileService.fetchPublicProfiles(
        limit: 100,
        offset: 0,
      );
      Set<String> blockedMe = {};
      try {
        blockedMe = (await _blockService.getUsersWhoBlockedMe()).toSet();
      } catch (_) {}
      final blockedByMe = <String>{};
      try {
        blockedByMe.addAll(await _blockService.getBlockedUsers());
      } catch (_) {}
      final filtered = users.where((u) {
        final id = u['id'] as String?;
        if (id == null) return false;
        if (blockedMe.contains(id) || blockedByMe.contains(id)) return false;
        return true;
      }).toList();

      setState(() {
        _allUsers = filtered;
        _filteredUsers = filtered;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = toUserFriendlyErrorMessage(
          e,
          fallback: 'Unable to load users right now.',
        );
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _filteredUsers = _allUsers;
      });
    } else {
      setState(() {
        _filteredUsers = _allUsers.where((user) {
          final username = (user['username'] ?? '').toLowerCase();
          final fullName = (user['full_name'] ?? '').toLowerCase();
          return username.contains(query) || fullName.contains(query);
        }).toList();
      });
    }
  }

  //
  // BUILD

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(6.h),
        child: _buildAppBar(context, isDark),
      ),
      body: _buildBody(context, isDark),
    );
  }

  //
  // APP BAR

  Widget _buildAppBar(BuildContext context, bool isDark) {
    final textColor = isDark ? DarkColors.textPrimary : LightColors.textPrimary;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF121212) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white12 : Colors.black12,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: textColor),
              onPressed: () => context.pop(),
            ),
            Expanded(
              child: Text(
                "New Chat",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //
  // BODY

  Widget _buildBody(BuildContext context, bool isDark) {
    return Container(
      decoration: _buildBackgroundGradient(context, isDark),
      child: Column(
        children: [
          _buildSearchBar(isDark),
          _buildNewGroupOption(context, isDark),
          _buildUsersList(isDark),
        ],
      ),
    );
  }

  //
  // BACKGROUND

  BoxDecoration _buildBackgroundGradient(BuildContext context, bool isDark) {
    return BoxDecoration(
      color: isDark ? const Color(0xFF0F0F0F) : Colors.white,
    );
  }

  //
  // SEARCH BAR

  Widget _buildSearchBar(bool isDark) {
    final textColor = isDark ? DarkColors.textPrimary : LightColors.textPrimary;
    final secondaryTextColor = isDark
        ? DarkColors.textSecondary
        : LightColors.textSecondary;
    final inputBg = isDark ? DarkColors.inputBg : LightColors.inputBg;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: inputBg,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isDark ? DarkColors.glassBorder : LightColors.glassBorder,
          ),
        ),
        child: TextField(
          controller: _searchController,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            hintText: "Search name or number",
            suffixIcon: VoiceInputButton(
              controller: _searchController,
              compact: true,
            ),
            hintStyle: TextStyle(color: secondaryTextColor),
            prefixIcon: Icon(Icons.search, color: secondaryTextColor),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
          ),
        ),
      ),
    );
  }

  //
  // NEW GROUP OPTION

  Widget _buildNewGroupOption(BuildContext context, bool isDark) {
    final textColor = isDark ? DarkColors.textPrimary : LightColors.textPrimary;
    final secondaryTextColor = isDark
        ? DarkColors.textSecondary
        : LightColors.textSecondary;
    final accentColor = isDark
        ? DarkColors.accentPrimary
        : LightColors.accentPrimary;
    final tileBg = isDark ? DarkColors.glassBg : LightColors.cardBg;
    final tileBorder = isDark
        ? DarkColors.glassBorder
        : LightColors.glassBorder;
    final tileTitleColor = isDark ? Colors.white : Colors.black87;
    final tileSubtitleColor = isDark
      ? Colors.white.withValues(alpha: 0.72)
      : Colors.black.withValues(alpha: 0.66);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: tileBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: tileBorder),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: accentColor,
                child: Icon(Icons.group_add, color: Colors.white),
              ),
              title: Text(
                "New group",
                style: TextStyle(
                  color: tileTitleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Create a group with multiple people',
                style: TextStyle(color: tileSubtitleColor),
              ),
              onTap: () => context.push('/new-group'),
            ),
          ),
        ),
        Divider(color: secondaryTextColor.withValues(alpha: 0.2)),
      ],
    );
  }

  //
  // USERS LIST

  Widget _buildUsersList(bool isDark) {
    final textColor = isDark ? DarkColors.textPrimary : LightColors.textPrimary;
    final secondaryTextColor = isDark
        ? DarkColors.textSecondary
        : LightColors.textSecondary;
    final accentColor = isDark
        ? DarkColors.accentPrimary
        : LightColors.accentPrimary;

    if (_isLoading) {
      return Expanded(
        child: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: secondaryTextColor),
              SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: TextStyle(color: secondaryTextColor, fontSize: 14.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadUsers,
                style: ElevatedButton.styleFrom(backgroundColor: accentColor),
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_filteredUsers.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people_outline, size: 48, color: secondaryTextColor),
              SizedBox(height: 16),
              Text(
                _searchController.text.isEmpty
                    ? 'No users found'
                    : 'No users match your search',
                style: TextStyle(color: secondaryTextColor, fontSize: 14.sp),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView(
        children: [
          _buildSectionTitle("People on MyItihas", secondaryTextColor),
          ..._filteredUsers.map(
            (user) => _buildUserTile(user, textColor, accentColor, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  //
  // USER TILE

  Widget _buildUserTile(
    Map<String, dynamic> user,
    Color textColor,
    Color accentColor,
    bool isDark,
  ) {
    final userId = user['id'] as String;
    final username = user['username'] as String?;
    final fullName = user['full_name'] as String?;
    final avatarUrl = user['avatar_url'] as String?;

    final displayName = fullName ?? username ?? 'Unknown User';
    final subtitle = username != null && fullName != null ? '@$username' : null;
    final tileBg = isDark ? DarkColors.glassBg : LightColors.cardBg;
    final tileBorder = isDark
        ? DarkColors.glassBorder
        : LightColors.glassBorder;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: tileBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: tileBorder),
        ),
        child: ListTile(
          leading: _buildAvatarLeading(displayName, avatarUrl, accentColor),
          title: Text(
            displayName,
            style: TextStyle(
              fontSize: 15.sp,
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: textColor.withValues(alpha: 0.6),
                  ),
                )
              : null,
          onTap: () async {
            final isConnected = await _networkInfo.isConnected;
            if (!mounted) return;
            if (!isConnected) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text(kConnectToInternetMessage)),
              );
              return;
            }
            try {
              final directConvId = await _chatService
                  .getOrCreateDirectDMIfAllowed(userId);
              if (!mounted) return;
              if (directConvId != null) {
                context.push(
                  '/chat_detail',
                  extra: {
                    'conversationId': directConvId,
                    'userId': userId,
                    'name': displayName,
                    'avatarUrl': avatarUrl,
                    'isGroup': false,
                  },
                );
                return;
              }

              final incoming = await _chatService.getIncomingMessageRequest(
                userId,
              );
              if (!mounted) return;
              if (incoming != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'You have a request from this user. Open Requests to accept.',
                    ),
                  ),
                );
                context.push('/chat-requests');
                return;
              }
              final sent = await _chatService.getSentMessageRequest(userId);
              if (!mounted) return;
              if (sent != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Request sent. Waiting for them to accept.'),
                  ),
                );
                return;
              }

              // Not mutual followers and no existing request, show confirmation popup
              _showMessageRequestConfirmation(
                context: context,
                userId: userId,
                displayName: displayName,
                avatarUrl: avatarUrl,
              );
            } on AuthException catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(e.message)));
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      toUserFriendlyErrorMessage(
                        e,
                        fallback: 'Unable to send request right now.',
                      ),
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }

  /// Avatar with fixed square constraint and ClipOval so circles are not distorted.
  Widget _buildAvatarLeading(
    String displayName,
    String? avatarUrl,
    Color accentColor,
  ) {
    const double size = 44;
    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: avatarUrl != null && avatarUrl.trim().isNotEmpty
            ? CachedNetworkImage(
                imageUrl: avatarUrl,
                width: size,
                height: size,
                fit: BoxFit.cover,
                placeholder: (_, __) => _placeholderAvatar(size, accentColor),
                errorWidget: (_, __, ___) =>
                    _placeholderAvatar(size, accentColor),
              )
            : _placeholderAvatar(size, accentColor),
      ),
    );
  }

  Widget _placeholderAvatar(double size, Color accentColor) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.25),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person_rounded,
        size: size * 0.5,
        color: accentColor.withValues(alpha: 0.8),
      ),
    );
  }

  void _showMessageRequestConfirmation({
    required BuildContext context,
    required String userId,
    required String displayName,
    String? avatarUrl,
  }) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark
        ? DarkColors.accentPrimary
        : LightColors.accentPrimary;

    bool isFollowing = false;
    try {
      isFollowing = await _followService.isFollowing(userId);
    } catch (_) {}

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? DarkColors.glassBg : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        padding: EdgeInsets.fromLTRB(
          24,
          12,
          24,
          MediaQuery.of(context).padding.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color:
                    (isDark
                            ? DarkColors.textSecondary
                            : LightColors.textSecondary)
                        .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Send Message Request?",
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? DarkColors.textPrimary
                    : LightColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "You need to send a request to $displayName because you aren't mutual followers yet.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: isDark
                    ? DarkColors.textSecondary
                    : LightColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    if (!isFollowing) {
                      await _followService.followUser(userId);
                      print('[NewChatPage] Auto-followed user $userId');
                    }
                    final directConvId = await _chatService.sendMessageRequest(
                      userId,
                    );
                    if (mounted) {
                      if (directConvId != null) {
                        this.context.push(
                          '/chat_detail',
                          extra: {
                            'conversationId': directConvId,
                            'userId': userId,
                            'name': displayName,
                            'avatarUrl': avatarUrl,
                            'isGroup': false,
                          },
                        );
                      } else {
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Request sent. Waiting for them to accept.',
                            ),
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        SnackBar(content: Text(toUserFriendlyErrorMessage(e))),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isFollowing ? "Send Request" : "Follow & Send Request",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: isDark
                        ? DarkColors.textSecondary
                        : LightColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
