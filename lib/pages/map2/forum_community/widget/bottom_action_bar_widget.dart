import 'package:flutter/material.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:sizer/sizer.dart';

/// Bottom action bar with chat rooms and start discussion buttons
class BottomActionBarWidget extends StatelessWidget {
  final VoidCallback onStartDiscussion;

  const BottomActionBarWidget({super.key, required this.onStartDiscussion});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = context.t;

    return Container(
      padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 1.5.h, bottom: 0.5.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outline, width: 1.0),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 5.5.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF121212),
            border: Border.all(
              color: Colors.white24,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: onStartDiscussion,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            icon: Icon(Icons.edit, color: Colors.white, size: 19.sp),
            label: Text(
              t.map.discussions.newDiscussionCta,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
