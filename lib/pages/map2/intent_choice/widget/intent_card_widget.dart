import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/pages/map2/widgets/custom_icon_widget.dart';
import 'package:sizer/sizer.dart';

/// Premium intent card used for sacred, custom, fabric and craft options.
class IntentCardWidget extends StatefulWidget {
  final Map<String, dynamic> intent;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool showSelectionIndicator;

  const IntentCardWidget({
    super.key,
    required this.intent,
    required this.isSelected,
    required this.onTap,
    this.onLongPress,
    this.showSelectionIndicator = false,
  });

  @override
  State<IntentCardWidget> createState() => _IntentCardWidgetState();
}

class _IntentCardWidgetState extends State<IntentCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradients = theme.extension<GradientExtension>();
    final intentColor = Color(widget.intent['color'] as int);
    final badge = widget.intent['badge']?.toString();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final glassBg =
        gradients?.glassCardBackground ??
        (isDark
        ? const Color(0xFF0F172A).withValues(alpha: 0.5)
            : const Color(0xFFFFFFFF).withValues(alpha: 0.75));
    final glassBorder =
        gradients?.glassCardBorder ??
        theme.colorScheme.primary.withValues(alpha: 0.15);

    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: glassBg.withValues(alpha: isDark ? 0.55 : 0.82),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: widget.isSelected
                      ? intentColor.withValues(alpha: 0.8)
                      : glassBorder,
                  width: widget.isSelected ? 1.5 : 1.0,
                ),
              ),
              child: Stack(
                fit: StackFit.loose,
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: isDark ? 0.03 : 0.02),
                            Colors.black.withValues(
                              alpha: isDark ? 0.14 : 0.06,
                            ),
                            Colors.black.withValues(
                              alpha: isDark ? 0.35 : 0.14,
                            ),
                          ],
                          stops: const [0.0, 0.52, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(4.w, 2.2.h, 4.w, 2.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 15.w,
                          height: 15.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                intentColor.withValues(alpha: 0.28),
                                intentColor.withValues(alpha: 0.1),
                              ],
                            ),
                            border: Border.all(
                              color: intentColor.withValues(alpha: 0.35),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: widget.intent['icon'] as String,
                              color: intentColor,
                              size: 28,
                            ),
                          ),
                        ),

                        SizedBox(width: 4.w),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (badge != null) ...[
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.6.w,
                                    vertical: 0.4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: intentColor.withValues(alpha: 0.14),
                                    border: Border.all(
                                      color: intentColor.withValues(alpha: 0.35),
                                    ),
                                  ),
                                  child: Text(
                                    badge,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: intentColor,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 0.8.h),
                              ],
                              Text(
                                widget.intent['name'] as String,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                widget.intent['description'] as String,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 3.w),

                        widget.showSelectionIndicator
                            ? AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 8.w,
                                height: 8.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.isSelected
                                      ? intentColor
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: widget.isSelected
                                        ? intentColor
                                        : theme.dividerColor,
                                    width: 2,
                                  ),
                                ),
                                child: widget.isSelected
                                    ? Center(
                                        child: CustomIconWidget(
                                          iconName: 'check',
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      )
                                    : null,
                              )
                            : Container(
                                margin: EdgeInsets.only(top: 1.h),
                                width: 9.w,
                                height: 9.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: intentColor.withValues(alpha: 0.14),
                                  border: Border.all(
                                    color: intentColor.withValues(alpha: 0.35),
                                  ),
                                ),
                                child: Center(
                                  child: CustomIconWidget(
                                    iconName: 'arrow_forward',
                                    color: intentColor,
                                    size: 16,
                                  ),
                                ),
                              ),
                      ],
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
