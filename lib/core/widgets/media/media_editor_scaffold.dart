import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shared scaffold for rich media editing (photo & video).
/// Provides:
/// - Premium top app bar with title and close / reset / done actions
/// - Dark, content-focused background
/// - SafeArea handling for bottom tool rails and sliders
/// - Optional secondary header under the app bar
class MediaEditorScaffold extends StatelessWidget {
  const MediaEditorScaffold({
    super.key,
    required this.title,
    required this.body,
    required this.bottomBar,
    this.subtitle,
    this.onClose,
    this.onDone,
    this.onReset,
    this.isSaving = false,
    this.isDoneEnabled = true,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onClose;
  final VoidCallback? onDone;
  final VoidCallback? onReset;
  final bool isSaving;

  /// Controls whether the "Done" action is enabled.
  /// When false, the button remains visible but disabled for clearer affordance.
  final bool isDoneEnabled;

  /// Main content area. Typically the media preview + any per-tool UI.
  final Widget body;

  /// Bottom tool rail area. Typically sliders, trim handles, and tool chips.
  final Widget bottomBar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.9),
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            HapticFeedback.selectionClick();
            onClose?.call();
          },
        ),
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.1,
                    color: Colors.white,
                  ) ??
                  TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.1,
                    color: Colors.white,
                  ),
            ),
            if (subtitle != null)
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color:
                        Colors.white.withValues(alpha: isDark ? 0.8 : 0.9),
                    height: 1.2,
                  ),
                ),
              ),
          ],
        ),
        actions: [
          if (onReset != null)
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                onReset!.call();
              },
              child: Text(
                'Reset',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ),
          if (onDone != null)
            Padding(
              padding: EdgeInsets.only(right: 4.w),
              child: TextButton(
                onPressed: (isSaving || !isDoneEnabled)
                    ? null
                    : () {
                        HapticFeedback.mediumImpact();
                        onDone!.call();
                      },
                child: isSaving
                    ? SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.primary,
                        ),
                      )
                    : Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: isDoneEnabled
                              ? colorScheme.primary
                              : colorScheme.primary.withValues(alpha: 0.4),
                        ),
                      ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Content-focused preview area with subtle vignette.
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: isDark ? 0.96 : 0.94),
                      Colors.black.withValues(alpha: 0.96),
                    ],
                  ),
                ),
                child: body,
              ),
            ),
            // Elevated bottom tools section.
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF05060A).withValues(alpha: 0.96),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(22.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 24,
                    offset: const Offset(0, -8),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
              child: SafeArea(
                top: false,
                minimum: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                child: bottomBar,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

