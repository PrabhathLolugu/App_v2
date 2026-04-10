import 'package:flutter/material.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/utils/constants.dart';
import 'package:sizer/sizer.dart';

class ProfileActionButtonsWidget extends StatelessWidget {
  final VoidCallback onEditProfile;

  const ProfileActionButtonsWidget({super.key, required this.onEditProfile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Container(
        height: 5.5.h,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark
              ? DarkColors.messageUserGradient
              : LightColors.messageUserGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: onEditProfile,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          icon: Icon(Icons.edit, color: Colors.white, size: 19.sp),
          label: Text(
            Translations.of(context).social.editProfile.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
