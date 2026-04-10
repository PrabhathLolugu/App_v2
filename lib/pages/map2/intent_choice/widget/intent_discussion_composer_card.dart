import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:myitihas/config/routes.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/pages/map2/forum_community/forum_discussion_launch_context.dart';
import 'package:sizer/sizer.dart';

class IntentDiscussionComposerCard extends StatelessWidget {
  const IntentDiscussionComposerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = context.t;
    final isDark = theme.brightness == Brightness.dark;

    final cardBackground = isDark
      ? const Color(0xFF121212).withValues(alpha: 0.9)
      : Colors.white.withValues(alpha: 0.95);
    final cardBorder = isDark ? Colors.white12 : Colors.black12;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: cardBackground,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: cardBorder, width: 1),
            ),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.map.discussions.intentCardTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 0.6.h),
                  Text(
                    t.map.discussions.intentCardSubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.74),
                    ),
                  ),
                  SizedBox(height: 1.4.h),
                  Container(
                    width: double.infinity,
                    height: 5.5.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF121212),
                      border: Border.all(color: Colors.white24, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ForumCommunityRoute(
                          siteId: 'general',
                          $extra: const ForumDiscussionLaunchContext(
                            openComposerOnLoad: true,
                          ),
                        ).push(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: Text(
                        t.map.discussions.intentCardCta,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
