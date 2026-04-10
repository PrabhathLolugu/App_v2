import 'package:flutter/material.dart';
import 'package:myitihas/core/widgets/profile_avatar/profile_avatar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

/// Reusable conversation tile widget that matches the chat list UI
class ConversationTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? avatarUrl;
  final bool isGroup;
  final String? userId;
  final VoidCallback onTap;
  final bool showDivider;
  final Widget? trailing;

  const ConversationTile({
    super.key,
    required this.title,
    this.subtitle,
    this.avatarUrl,
    this.isGroup = false,
    this.userId,
    required this.onTap,
    this.showDivider = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          if (showDivider)
            Divider(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          Container(
            margin: EdgeInsets.only(bottom: 0.5.h),
            padding: EdgeInsets.symmetric(vertical: 0.1.h, horizontal: 1.w),
            child: Row(
              children: [
                // Avatar
                _buildAvatar(context),
                SizedBox(width: 4.w),

                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 0.5.h),
                        Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Optional trailing widget
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ProfileAvatar(
      avatarUrl: avatarUrl,
      displayName: title,
      radius: 7.w,
      userId: isGroup ? null : userId,
      backgroundColor: colorScheme.surfaceContainerHigh,
      isGroup: isGroup,
    );
  }

}
