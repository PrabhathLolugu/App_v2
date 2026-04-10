import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myitihas/i18n/strings.g.dart';

/// Quick action button data
class QuickAction {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final List<Color>? gradientColors;

  const QuickAction({
    required this.label,
    required this.icon,
    required this.onTap,
    this.gradientColors,
  });
}

/// Section displaying quick action buttons with engaging animations
class QuickActionsSection extends StatelessWidget {
  final VoidCallback onGenerateStory;
  final VoidCallback onChatWithKrishna;
  final VoidCallback onMyActivity;

  const QuickActionsSection({
    super.key,
    required this.onGenerateStory,
    required this.onChatWithKrishna,
    required this.onMyActivity,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    final actions = [
      QuickAction(
        label: t.homeScreen.generateStory,
        icon: Icons.auto_awesome_sharp,
        onTap: onGenerateStory,
        gradientColors: const [Color(0xFF8B5CF6), Color(0xFFEF4444)],
      ),
      QuickAction(
        label: t.homeScreen.chatWithKrishna,
        icon: Icons.chat_bubble_rounded,
        onTap: onChatWithKrishna,
        gradientColors: const [Color(0xFF3B82F6), Color(0xFF06B6D4)],
      ),
      QuickAction(
        label: t.homeScreen.myActivity,
        icon: Icons.history_rounded,
        onTap: onMyActivity,
        gradientColors: const [Color(0xFFF59E0B), Color(0xFFEF4444)],
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: actions
            .map(
              (action) => Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: _QuickActionCard(action: action),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

/// Individual quick action card with scale and glow animations
class _QuickActionCard extends StatefulWidget {
  final QuickAction action;

  const _QuickActionCard({required this.action});

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  // ignore: unused_field
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.action.onTap();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final gradientColors =
        widget.action.gradientColors ??
        [colorScheme.primary, colorScheme.secondary];

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                ),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: gradientColors.first.withValues(
                      alpha: 0.3 + (_glowAnimation.value * 0.2),
                    ),
                    blurRadius: 12 + (_glowAnimation.value * 8),
                    offset: Offset(0, 6 + (_glowAnimation.value * 2)),
                  ),
                ],
              ),
              child: child,
            ),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with subtle animation
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(widget.action.icon, size: 24.sp, color: Colors.white),
            ),

            SizedBox(height: 10.h),

            // Label
            Text(
              widget.action.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
