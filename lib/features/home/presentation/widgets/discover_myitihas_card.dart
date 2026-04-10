import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/i18n/strings.g.dart';

const _kHasSeenDiscoverKey = 'has_seen_home_discover';

/// Dismissible welcome card for first-time users with quick action buttons.
class DiscoverMyItihasCard extends StatefulWidget {
  final Future<bool> Function() hasSeenDiscover;
  final Future<void> Function() markDiscoverSeen;

  const DiscoverMyItihasCard({
    super.key,
    required this.hasSeenDiscover,
    required this.markDiscoverSeen,
  });

  @override
  State<DiscoverMyItihasCard> createState() => _DiscoverMyItihasCardState();
  static const hasSeenKey = _kHasSeenDiscoverKey;
}

class _DiscoverMyItihasCardState extends State<DiscoverMyItihasCard> {
  // Session-only flag: true after user dismisses this card in the current app run.
  static bool _dismissedForCurrentSession = false;

  bool _showCard = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkSeen();
  }

  Future<void> _checkSeen() async {
    final seen = await widget.hasSeenDiscover();
    if (mounted) {
      setState(() {
        _isLoading = false;
        _showCard = !seen && !_dismissedForCurrentSession;
      });
    }
  }

  Future<void> _handleUserDismiss() async {
    if (!mounted) return;

    HapticFeedback.selectionClick();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final sheetTheme = Theme.of(context);
        final sheetColorScheme = sheetTheme.colorScheme;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            20.w,
            16.h,
            20.w,
            16.h + MediaQuery.paddingOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: sheetColorScheme.outlineVariant
                        .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                t.homeScreen.discoverDismissTitle,
                style: sheetTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                t.homeScreen.discoverDismissMessage,
                style: sheetTheme.textTheme.bodyMedium?.copyWith(
                  color: sheetColorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(t.homeScreen.yesRemindMe),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(t.homeScreen.noDontShowAgain),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (!mounted) return;

    // If the user explicitly chooses "No, don't show again", we mark it as seen
    if (result == false) {
      await widget.markDiscoverSeen();
    }

    _dismissedForCurrentSession = true;
    setState(() => _showCard = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || !_showCard) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gradients = theme.extension<GradientExtension>();
    final isDark = theme.brightness == Brightness.dark;

    return Dismissible(
      key: const ValueKey('discover_card'),
      direction: DismissDirection.up,
      confirmDismiss: (_) async {
        await _handleUserDismiss();
        // We handle hiding the card ourselves after the sheet.
        return false;
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          colorScheme.primaryContainer.withValues(alpha: 0.4),
                          colorScheme.secondaryContainer.withValues(alpha: 0.25),
                        ]
                      : [
                          colorScheme.primaryContainer.withValues(alpha: 0.6),
                          colorScheme.secondaryContainer.withValues(alpha: 0.4),
                        ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: (gradients?.electricGlow ?? colorScheme.primary)
                      .withValues(alpha: 0.4),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (gradients?.electricGlow ?? colorScheme.primary)
                        .withValues(alpha: 0.15),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.auto_awesome_rounded,
                              size: 28.sp,
                              color: colorScheme.primary,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            t.homeScreen.discoverCardTitle,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          size: 22.sp,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () {
                          _handleUserDismiss();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    t.homeScreen.discoverCardSubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      _ActionChip(
                        icon: Icons.explore_rounded,
                        label: t.homeScreen.exploreSacredSites,
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          context.go('/home?tab=3');
                        },
                        colorScheme: colorScheme,
                      ),
                      _ActionChip(
                        icon: Icons.auto_stories_rounded,
                        label: t.homeScreen.generateStory,
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          context.push('/story-generator');
                        },
                        colorScheme: colorScheme,
                      ),
                      _ActionChip(
                        icon: Icons.chat_bubble_rounded,
                        label: t.homeScreen.chatWithKrishna,
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          context.push('/chatbot');
                        },
                        colorScheme: colorScheme,
                      ),
                      _ActionChip(
                        icon: Icons.menu_book_rounded,
                        label: t.homeScreen.readStories,
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          context.push('/home/stories');
                        },
                        colorScheme: colorScheme,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    t.homeScreen.swipeToDismiss,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
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

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: colorScheme.surface.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18.sp, color: colorScheme.primary),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
