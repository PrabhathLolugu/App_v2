import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myitihas/profile/widget/custom_image_widget.dart';

import 'package:myitihas/pages/map2/widgets/custom_icon_widget.dart';
import 'package:sizer/sizer.dart';

class ProfileImageSectionWidget extends StatelessWidget {
  final String? profileImagePath;
  final String? currentProfileImage;
  final String semanticLabel;
  final VoidCallback onChangePhoto;

  const ProfileImageSectionWidget({
    super.key,
    required this.profileImagePath,
    required this.currentProfileImage,
    required this.semanticLabel,
    required this.onChangePhoto,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.primary,
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: profileImagePath != null
                      ? Image.file(
                          File(profileImagePath!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: CustomIconWidget(
                                iconName: 'person',
                                color: theme.colorScheme.onSurfaceVariant,
                                size: 15.w,
                              ),
                            );
                          },
                        )
                      : currentProfileImage != null
                      ? CustomImageWidget(
                          imageUrl: currentProfileImage!,
                          width: 30.w,
                          height: 30.w,
                          fit: BoxFit.cover,
                          semanticLabel: semanticLabel,
                          useAvatarPlaceholder: true,
                        )
                      : Container(
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: CustomIconWidget(
                            iconName: 'person',
                            color: theme.colorScheme.onSurfaceVariant,
                            size: 15.w,
                          ),
                        ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onChangePhoto,
                  child: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'camera_alt',
                      color: Colors.white,
                      size: 5.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          TextButton(
            onPressed: onChangePhoto,
            child: Text(
              'Change Photo',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
