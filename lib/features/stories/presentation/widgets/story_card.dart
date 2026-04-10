import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myitihas/config/theme/gradient_extension.dart';
import 'package:myitihas/core/cache/widgets/story_image.dart';
import 'package:myitihas/features/stories/domain/entities/story.dart';
import 'package:myitihas/i18n/strings.g.dart';

/// Formats raw story content for card excerpt: strip HTML, collapse whitespace.
String _formatStoryExcerpt(String raw, {int maxLength = 180}) {
  if (raw.trim().isEmpty) return '';
  // Strip HTML-like tags and decode common entities
  String text = raw
      .replaceAll(RegExp(r'<[^>]*>'), ' ')
      .replaceAll(RegExp(r'&nbsp;'), ' ')
      .replaceAll(RegExp(r'&amp;'), '&')
      .replaceAll(RegExp(r'&lt;'), '<')
      .replaceAll(RegExp(r'&gt;'), '>')
      .replaceAll(RegExp(r'&quot;'), '"');
  // Collapse multiple spaces/newlines into single space
  text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (text.length <= maxLength) return text;
  final truncated = text.substring(0, maxLength);
  final lastSpace = truncated.lastIndexOf(' ');
  if (lastSpace > maxLength ~/ 2) {
    return '${truncated.substring(0, lastSpace)}…';
  }
  return '$truncated…';
}

class StoryCard extends StatefulWidget {
  final Story story;
  final VoidCallback onTap;
  final VoidCallback? onFavorite;
  final VoidCallback? onShare;

  const StoryCard({
    super.key,
    required this.story,
    required this.onTap,
    this.onFavorite,
    this.onShare,
  });

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _hasImage =>
      widget.story.imageUrl != null && widget.story.imageUrl!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);
    final gradients = theme.extension<GradientExtension>();
    final isDark = theme.brightness == Brightness.dark;

    final excerpt = _formatStoryExcerpt(widget.story.story);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        child: ScaleTransition(
          scale: _scale,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                widget.onTap();
              },
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? theme.colorScheme.surfaceContainerHigh.withValues(
                          alpha: 0.7,
                        )
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.08),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withValues(
                        alpha: isDark ? 0.15 : 0.06,
                      ),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                    BoxShadow(
                      color:
                          (gradients?.primaryButtonGradient as LinearGradient?)
                              ?.colors
                              .first
                              .withValues(alpha: 0.03) ??
                          theme.primaryColor.withValues(alpha: 0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Hero image or gradient header
                    _buildHeader(context, theme, isDark),

                    // Content
                    Padding(
                      padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 18.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title row with favorite and share
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.story.title.trim(),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.3,
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (widget.onFavorite != null) ...[
                                SizedBox(width: 6.w),
                                _FavoriteButton(
                                  isFavorite: widget.story.isFavorite,
                                  onTap: () {
                                    HapticFeedback.selectionClick();
                                    widget.onFavorite!();
                                  },
                                  theme: theme,
                                ),
                              ],
                              if (widget.onShare != null) ...[
                                SizedBox(width: 2.w),
                                IconButton(
                                  icon: Icon(
                                    Icons.send_rounded,
                                    size: 20.sp,
                                    color: theme.colorScheme.primary,
                                  ),
                                  onPressed: () {
                                    HapticFeedback.selectionClick();
                                    widget.onShare!();
                                  },
                                  tooltip: t.stories.readMore,
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(
                                    minWidth: 36.w,
                                    minHeight: 36.w,
                                  ),
                                ),
                              ],
                            ],
                          ),

                          SizedBox(height: 12.h),

                          // Scripture and attribute chips
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: [
                              _ScriptureChip(
                                scripture: widget.story.scripture,
                                theme: theme,
                                gradient: gradients?.primaryButtonGradient,
                              ),
                              if (widget.story.attributes.storyType.isNotEmpty)
                                _SmallChip(
                                  icon: Icons.auto_stories_rounded,
                                  label: widget.story.attributes.storyType,
                                  theme: theme,
                                ),
                              if (widget.story.attributes.theme.isNotEmpty)
                                _SmallChip(
                                  icon: Icons.palette_outlined,
                                  label: widget.story.attributes.theme,
                                  theme: theme,
                                ),
                            ],
                          ),

                          if (excerpt.isNotEmpty) ...[
                            SizedBox(height: 14.h),
                            Text(
                              excerpt,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.5,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],

                          SizedBox(height: 16.h),

                          // Stats and Read more
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (widget.story.views > 0 ||
                                  widget.story.likes > 0)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (widget.story.views > 0) ...[
                                      Icon(
                                        Icons.visibility_outlined,
                                        size: 14.sp,
                                        color: theme.colorScheme.outline,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        _formatCount(widget.story.views),
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              color: theme.colorScheme.outline,
                                            ),
                                      ),
                                      SizedBox(width: 12.w),
                                    ],
                                    if (widget.story.likes > 0) ...[
                                      Icon(
                                        Icons.favorite_outline,
                                        size: 14.sp,
                                        color: theme.colorScheme.outline,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        _formatCount(widget.story.likes),
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              color: theme.colorScheme.outline,
                                            ),
                                      ),
                                    ],
                                  ],
                                )
                              else
                                const SizedBox.shrink(),
                              _ReadMorePill(
                                label: t.stories.readMore,
                                onTap: widget.onTap,
                                theme: theme,
                                gradient: gradients?.primaryButtonGradient,
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
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, bool isDark) {
    const double headerHeight = 160;

    if (_hasImage) {
      return SizedBox(
        height: headerHeight.h,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            StoryImage(
              imageUrl: widget.story.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: headerHeight.h,
              memCacheWidth: 600,
              memCacheHeight: 320,
              placeholder: (context) => Container(
                height: headerHeight.h,
                color: theme.colorScheme.surfaceContainerHighest,
              ),
              errorWidget: (_, __) =>
                  _buildPlaceholderHeader(theme, headerHeight),
            ),
            // Gradient overlay for text legibility
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.5),
                  ],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
            if (widget.story.isFeatured)
              Positioned(
                top: 12.h,
                left: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withValues(alpha: 0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    Translations.of(context).stories.featured,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return _buildPlaceholderHeader(theme, headerHeight);
  }

  Widget _buildPlaceholderHeader(ThemeData theme, double height) {
    final gradients = theme.extension<GradientExtension>();
    final gradient = gradients?.primaryButtonGradient as LinearGradient?;
    final colors =
        gradient?.colors ??
        [
          theme.colorScheme.primary.withValues(alpha: 0.6),
          theme.colorScheme.secondary,
        ];

    return Container(
      height: height.h,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors.map((c) => c.withValues(alpha: 0.85)).toList(),
        ),
      ),
      child: Center(
        child: Icon(
          Icons.auto_stories_rounded,
          size: 48.sp,
          color: Colors.white.withValues(alpha: 0.9),
        ),
      ),
    );
  }

  String _formatCount(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }
}

class _FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;
  final ThemeData theme;

  const _FavoriteButton({
    required this.isFavorite,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Icon(
            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            size: 22.sp,
            color: isFavorite
                ? theme.colorScheme.error
                : theme.colorScheme.outline,
          ),
        ),
      ),
    );
  }
}

class _ScriptureChip extends StatelessWidget {
  final String scripture;
  final ThemeData theme;
  final Gradient? gradient;

  const _ScriptureChip({
    required this.scripture,
    required this.theme,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final isGradient = gradient != null;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        gradient: isGradient ? gradient : null,
        color: isGradient
            ? null
            : theme.colorScheme.primaryContainer.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        scripture,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: isGradient
              ? Colors.white
              : theme.colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

class _SmallChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final ThemeData theme;

  const _SmallChip({
    required this.icon,
    required this.label,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: theme.colorScheme.outline),
          SizedBox(width: 4.w),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ReadMorePill extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final ThemeData theme;
  final Gradient? gradient;

  const _ReadMorePill({
    required this.label,
    required this.onTap,
    required this.theme,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final hasGradient = gradient != null;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            gradient: hasGradient ? gradient : null,
            color: hasGradient ? null : theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: hasGradient
                ? [
                    BoxShadow(
                      color:
                          (theme
                                      .extension<GradientExtension>()
                                      ?.primaryButtonGradient
                                  as LinearGradient?)
                              ?.colors
                              .first
                              .withValues(alpha: 0.35) ??
                          theme.primaryColor.withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: hasGradient
                      ? Colors.white
                      : theme.colorScheme.onPrimaryContainer,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.arrow_forward_rounded,
                size: 16.sp,
                color: hasGradient
                    ? Colors.white
                    : theme.colorScheme.onPrimaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
