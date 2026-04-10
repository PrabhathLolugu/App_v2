import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/features/home/domain/entities/quote.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:shimmer/shimmer.dart';

/// Beautiful glassmorphic Quote of the Day card with micro-interactions
class QuoteCard extends StatefulWidget {
  final Quote? quote;
  final bool isLoading;
  final VoidCallback? onShare;
  final VoidCallback? onCopy;

  const QuoteCard({
    super.key,
    this.quote,
    this.isLoading = false,
    this.onShare,
    this.onCopy,
  });

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _quoteMarkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _quoteMarkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    if (!widget.isLoading && widget.quote != null) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(QuoteCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isLoading && widget.quote != null && oldWidget.quote == null) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gradients = theme.extension<GradientExtension>();
    final t = Translations.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (widget.isLoading) {
      return _buildShimmer(context, isDark);
    }

    if (widget.quote == null) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(scale: _scaleAnimation, child: child),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          colorScheme.primary.withValues(alpha: 0.15),
                          colorScheme.secondary.withValues(alpha: 0.1),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.9),
                          Colors.white.withValues(alpha: 0.7),
                        ],
                ),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color:
                      gradients?.glassBorder ??
                      colorScheme.primary.withValues(alpha: 0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Decorative gradient orb
                  Positioned(
                    top: -30.h,
                    right: -30.w,
                    child: Container(
                      width: 120.w,
                      height: 120.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            colorScheme.primary.withValues(alpha: 0.3),
                            colorScheme.primary.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header row with title and actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ScaleTransition(
                                  scale: _quoteMarkAnimation,
                                  child: ShaderMask(
                                    shaderCallback: (bounds) =>
                                        (gradients?.primaryButtonGradient ??
                                                const LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Color(0xFF44009F),
                                                    Color(0xFF0088FF),
                                                  ],
                                                ))
                                            .createShader(bounds),
                                    child: Icon(
                                      Icons.format_quote_rounded,
                                      size: 28.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  t.homeScreen.quoteOfTheDay,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.7,
                                    ),
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                _ActionButton(
                                  icon: FaIcon(
                                    FontAwesomeIcons.copy,
                                    size: 18.sp,
                                    color: colorScheme.primary,
                                  ),
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    widget.onCopy?.call();
                                  },
                                  tooltip: t.homeScreen.copyQuote,
                                ),
                                SizedBox(width: 8.w),
                                _ActionButton(
                                  icon: FaIcon(
                                    FontAwesomeIcons.shareNodes,
                                    size: 18.sp,
                                    color: colorScheme.primary,
                                  ),
                                  onTap: () {
                                    HapticFeedback.mediumImpact();
                                    widget.onShare?.call();
                                  },
                                  tooltip: t.homeScreen.shareQuote,
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 16.h),

                        // Quote text
                        Text(
                          '"${widget.quote!.text}"',
                          style: GoogleFonts.merriweather(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            color: colorScheme.onSurface,
                            height: 1.6,
                          ),
                        ),

                        SizedBox(height: 16.h),

                        // Attribution
                        Row(
                          children: [
                            Container(
                              width: 40.w,
                              height: 2.h,
                              decoration: BoxDecoration(
                                gradient: gradients?.primaryButtonGradient,
                                borderRadius: BorderRadius.circular(1.r),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                widget.quote!.attribution,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
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

  Widget _buildShimmer(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final baseColor = isDark
        ? colorScheme.surfaceContainerHigh
        : colorScheme.surfaceContainerLow;
    final highlightColor = isDark
        ? colorScheme.surfaceContainerLow
        : colorScheme.surfaceContainerHighest;
    final shimmerGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: isDark
          ? [
              colorScheme.primaryContainer.withValues(alpha: 0.32),
              colorScheme.secondaryContainer.withValues(alpha: 0.26),
              colorScheme.tertiaryContainer.withValues(alpha: 0.22),
            ]
          : [
              colorScheme.primaryContainer.withValues(alpha: 0.24),
              colorScheme.secondaryContainer.withValues(alpha: 0.2),
              colorScheme.tertiaryContainer.withValues(alpha: 0.16),
            ],
    );
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          height: 180.h,
          decoration: BoxDecoration(
            gradient: shimmerGradient,
            borderRadius: BorderRadius.circular(24.r),
          ),
        ),
      ),
    );
  }
}

/// Small circular action button with scale animation
class _ActionButton extends StatefulWidget {
  final Widget icon;
  final VoidCallback onTap;
  final String tooltip;

  const _ActionButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
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
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: Tooltip(
        message: widget.tooltip,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: widget.icon,
          ),
        ),
      ),
    );
  }
}
