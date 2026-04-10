import 'package:flutter/material.dart';
import 'package:myitihas/profile/widget/custom_image_widget.dart';

import 'package:myitihas/pages/map2/widgets/custom_icon_widget.dart';
import 'package:sizer/sizer.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String profileImage;
  final String profileImageSemanticLabel;
  final String displayName;
  final bool isVerified;
  final VoidCallback onProfileImageTap;

  const ProfileHeaderWidget({
    super.key,
    required this.profileImage,
    required this.profileImageSemanticLabel,
    required this.displayName,
    required this.isVerified,
    required this.onProfileImageTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        GestureDetector(
          onTap: onProfileImageTap,
          child: Hero(
            tag: 'profile_image',
            child: Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: theme.colorScheme.primary, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipOval(
                child: CustomImageWidget(
                  imageUrl: profileImage,
                  width: 30.w,
                  height: 30.w,
                  fit: BoxFit.cover,
                  semanticLabel: profileImageSemanticLabel,
                  useAvatarPlaceholder: true,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 1.5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              displayName,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (isVerified) ...[
              SizedBox(width: 1.w),
              CustomIconWidget(
                iconName: 'verified',
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
