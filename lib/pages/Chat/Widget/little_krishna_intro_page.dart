import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/utils/constants.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:sizer/sizer.dart';

/// Modern introductory page for Little Krishna – describes the chatbot
/// as a mental health companion and explains its features.
class LittleKrishnaIntroPage extends StatelessWidget {
  const LittleKrishnaIntroPage({super.key});

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

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF050810),
                    Color(0xFF0F172A),
                    Color(0xFF0A1628),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                )
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.primaryContainer.withValues(alpha: 0.3),
                    colorScheme.surface,
                  ],
                ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with close
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: Icon(
                        Icons.close_rounded,
                        color: textColor,
                        size: 26,
                      ),
                    ),
                    Text(
                      t.chat.about,
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: subTextColor,
                      ),
                    ),
                    SizedBox(width: 48),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Column(
                    children: [
                      SizedBox(height: 2.h),
                      // Avatar with glow
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withValues(alpha: 0.35),
                              blurRadius: 32,
                              spreadRadius: 4,
                            ),
                            BoxShadow(
                              color: (isDark
                                      ? DarkColors.accentSecondary
                                      : LightColors.accentSecondary)
                                  .withValues(alpha: 0.2),
                              blurRadius: 24,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 22.w,
                          backgroundColor: Colors.transparent,
                          backgroundImage: const AssetImage(
                            'assets/images/littlekrishna.png',
                          ),
                        ),
                      ),
                      SizedBox(height: 2.5.h),
                      Text(
                        t.chat.littleKrishnaName,
                        style: GoogleFonts.inter(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            color: Colors.green.shade400,
                            size: 20.sp,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            t.chat.yourFriendlyCompanion,
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: subTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),

                      // Features
                      _FeatureRow(
                        icon: Icons.psychology_rounded,
                        title: t.chat.mentalHealthSupport,
                        subtitle: t.chat.mentalHealthSupportSubtitle,
                        isDark: isDark,
                        accentColor: accentColor,
                      ),
                      SizedBox(height: 1.8.h),
                      _FeatureRow(
                        icon: Icons.favorite_rounded,
                        title: t.chat.friendlyCompanion,
                        subtitle: t.chat.friendlyCompanionSubtitle,
                        isDark: isDark,
                        accentColor: accentColor,
                      ),
                      SizedBox(height: 1.8.h),
                      _FeatureRow(
                        icon: Icons.lightbulb_rounded,
                        title: t.chat.storiesAndWisdom,
                        subtitle: t.chat.storiesAndWisdomSubtitle,
                        isDark: isDark,
                        accentColor: accentColor,
                      ),
                      SizedBox(height: 1.8.h),
                      _FeatureRow(
                        icon: Icons.chat_bubble_rounded,
                        title: t.chat.askAnything,
                        subtitle: t.chat.askAnythingSubtitle,
                        isDark: isDark,
                        accentColor: accentColor,
                      ),
                      SizedBox(height: 4.h),

                      // CTA
                      SizedBox(
                        width: double.infinity,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              context.pop();
                              const ChatbotRoute().push(context);
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 1.8.h),
                              decoration: BoxDecoration(
                                gradient: gradients?.primaryButtonGradient ??
                                    LinearGradient(
                                      colors: isDark
                                          ? [
                                              DarkColors.messageUserBgStart,
                                              DarkColors.messageUserBgEnd,
                                            ]
                                          : [
                                              LightColors.messageUserBgStart,
                                              LightColors.messageUserBgEnd,
                                            ],
                                    ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: accentColor.withValues(alpha: 0.35),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.chat_rounded,
                                    color: Colors.white,
                                    size: 22.sp,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    t.chat.startChatting,
                                    style: GoogleFonts.inter(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 1.5.h),
                      TextButton(
                        onPressed: () => context.go('/home?tab=1'),
                        child: Text(
                          t.chat.maybeLater,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: subTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 3.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;
  final Color accentColor;

  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? DarkColors.textPrimary : LightColors.textPrimary;
    final subTextColor =
        isDark ? DarkColors.textSecondary : LightColors.textSecondary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: accentColor, size: 22.sp),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              SizedBox(height: 0.3.h),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: subTextColor,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
