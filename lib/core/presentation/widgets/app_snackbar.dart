import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralized, styled snackbars for consistent error/success messaging.
///
/// Use these instead of creating raw [SnackBar]s across screens so that
/// all feedback follows the same visual language.
class AppSnackBar {
  const AppSnackBar._();

  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        _buildSnackBar(
          context,
          message: message,
          icon: Icons.error_outline,
          backgroundColor: Theme.of(context).colorScheme.error,
          iconColor: Theme.of(context).colorScheme.onError,
          duration: duration,
        ),
      );
  }

  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    final colorScheme = Theme.of(context).colorScheme;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        _buildSnackBar(
          context,
          message: message,
          icon: Icons.check_circle,
          backgroundColor: Colors.green,
          iconColor: colorScheme.onPrimary,
          duration: duration,
        ),
      );
  }

  static SnackBar _buildSnackBar(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required Duration duration,
  }) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyMedium?.copyWith(
      color: Colors.white,
      fontSize: 14.sp,
    );

    return SnackBar(
      content: Row(
        children: [
          Icon(icon, color: iconColor, size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              message,
              style: textStyle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      duration: duration,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
    );
  }
}

