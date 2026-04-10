import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/core/di/injection_container.dart';
import 'package:myitihas/core/widgets/profile_avatar/profile_avatar.dart';
import 'package:myitihas/models/conversation.dart';
import 'package:myitihas/services/chat_service.dart';
import 'package:myitihas/services/profile_service.dart';
import 'package:myitihas/services/supabase_service.dart';
import 'package:myitihas/utils/constants.dart';
import 'package:sizer/sizer.dart';

/// Bottom sheet to select a conversation (DM or group) to share content to.
/// Returns the selected conversationId or null if dismissed.
class ShareToConversationSheet extends StatefulWidget {
  final Function(String conversationId) onSelect;
  final String title;
  final String subtitle;

  const ShareToConversationSheet({
    super.key,
    required this.onSelect,
    this.title = 'Share to',
    this.subtitle = 'Choose a chat or group',
  });

  static Future<String?> show(BuildContext context) async {
    String? result;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ShareToConversationSheet(
        onSelect: (id) {
          result = id;
          Navigator.of(ctx).pop();
        },
      ),
    );
    return result;
  }

  @override
  State<ShareToConversationSheet> createState() =>
      _ShareToConversationSheetState();
}

class _ShareToConversationSheetState extends State<ShareToConversationSheet> {
  final ChatService _chatService = getIt<ChatService>();
  final ProfileService _profileService = getIt<ProfileService>();

  List<Conversation> _conversations = [];
  List<Conversation> _filteredConversations = [];
  final Map<String, Map<String, dynamic>> _userProfiles = {};
  bool _isLoading = true;
  String? _currentUserId;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentUserId = SupabaseService.client.auth.currentUser?.id;
    _loadConversations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadConversations() async {
    setState(() => _isLoading = true);
    try {
      final conversations = await _chatService.getMyConversations();
      for (final conversation in conversations) {
        if (!conversation.isGroup) {
          try {
            final otherUserId = await _getOtherUserId(conversation.id);
            if (otherUserId != null) {
              _userProfiles[conversation.id] =
                  await _profileService.getProfileById(otherUserId);
            }
          } catch (_) {}
        }
      }
      setState(() {
        _conversations = conversations;
        _filteredConversations = conversations;
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  Future<String?> _getOtherUserId(String conversationId) async {
    try {
      final response = await SupabaseService.client
          .from('conversation_members')
          .select('user_id')
          .eq('conversation_id', conversationId)
          .neq('user_id', _currentUserId!);
      if (response.isNotEmpty) {
        return response.first['user_id'] as String;
      }
    } catch (_) {}
    return null;
  }

  void _filterConversations(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredConversations = _conversations;
      } else {
        final q = query.toLowerCase();
        _filteredConversations = _conversations.where((c) {
          final title = c.isGroup
              ? c.title
              : (_userProfiles[c.id]?['full_name'] as String? ?? c.title);
          return title.toLowerCase().contains(q);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final gradients = theme.extension<GradientExtension>();
    final colorScheme = theme.colorScheme;
    final textColor = isDark ? DarkColors.textPrimary : LightColors.textPrimary;
    final subTextColor =
        isDark ? DarkColors.textSecondary : LightColors.textSecondary;
    final accentColor =
        isDark ? DarkColors.accentPrimary : LightColors.accentPrimary;
    final glassBg = gradients?.glassCardBackground ??
        (isDark ? DarkColors.glassBg : LightColors.glassBg);
    final glassBorder = gradients?.glassCardBorder ??
        (isDark ? DarkColors.glassBorder : LightColors.glassBorder);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 78.h,
          decoration: BoxDecoration(
            gradient: isDark
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      (gradients?.glassBackground ?? DarkColors.glassBg)
                          .withValues(alpha: 0.95),
                      const Color(0xFF0F172A).withValues(alpha: 0.98),
                    ],
                  )
                : LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.97),
                      colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    ],
                  ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(color: glassBorder.withValues(alpha: 0.8), width: 1),
              left: BorderSide(color: glassBorder.withValues(alpha: 0.3), width: 1),
              right: BorderSide(color: glassBorder.withValues(alpha: 0.3), width: 1),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 1.5.h, 5.w, 0),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: subTextColor.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.share_rounded, size: 22.sp, color: accentColor),
                        ),
                        SizedBox(width: 3.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: GoogleFonts.inter(
                                color: textColor,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                              ),
                            ),
                            SizedBox(height: 0.2.h),
                            Text(
                              widget.subtitle,
                              style: GoogleFonts.inter(
                                color: subTextColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      decoration: BoxDecoration(
                        color: glassBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: glassBorder, width: 1),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _filterConversations,
                        style: GoogleFonts.inter(
                          color: textColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search chats or groups...',
                          hintStyle: GoogleFonts.inter(color: subTextColor, fontSize: 14.sp),
                          prefixIcon: Icon(Icons.search_rounded, color: subTextColor, size: 22.sp),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.6.h,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 1.5.h),
              Expanded(
                child: _isLoading
                    ? Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                      )
                    : _filteredConversations.isEmpty
                        ? Center(
                            child: Text(
                              _searchController.text.isEmpty
                                  ? 'No chats yet'
                                  : 'No results',
                              style: GoogleFonts.inter(
                                color: subTextColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 3.h),
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            itemCount: _filteredConversations.length,
                            itemBuilder: (context, index) {
                              final c = _filteredConversations[index];
                              final isGroup = c.isGroup;
                              final title = isGroup
                                  ? c.title
                                  : (_userProfiles[c.id]?['full_name']
                                          as String? ??
                                      c.title);
                              final avatarUrl = isGroup
                                  ? c.avatarUrl
                                  : (_userProfiles[c.id]?['avatar_url']
                                      as String?);
                              final otherUserId =
                                  _userProfiles[c.id]?['id'] as String?;
                              return Padding(
                                padding: EdgeInsets.only(bottom: 1.2.h),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => widget.onSelect(c.id),
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 3.w,
                                        vertical: 1.2.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: glassBg.withValues(alpha: 0.6),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: glassBorder.withValues(alpha: 0.5),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          ProfileAvatar(
                                            avatarUrl: avatarUrl,
                                            displayName: title,
                                            radius: 7.w,
                                            userId: isGroup ? null : otherUserId,
                                            backgroundColor: isDark
                                                ? DarkColors.glassBg
                                                : LightColors.glassBg,
                                            isGroup: isGroup,
                                          ),
                                          SizedBox(width: 4.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  title,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: textColor,
                                                  ),
                                                ),
                                                if (isGroup)
                                                  Text(
                                                    'Group',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 12.sp,
                                                      color: subTextColor,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.send_rounded,
                                            size: 20.sp,
                                            color: accentColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
