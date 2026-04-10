import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myitihas/features/story_generator/domain/entities/story_prompt.dart';

/// Interactive prompt view – the prompt reads as a proper justified paragraph
/// with tappable inline chip placeholders for each option.
class InteractivePromptView extends StatelessWidget {
  final StoryPrompt prompt;
  final VoidCallback onScriptureTap;
  final VoidCallback onStoryTypeTap;
  final VoidCallback onThemeTap;
  final VoidCallback onMainCharacterTap;
  final VoidCallback onSettingTap;
  final VoidCallback onRandomize;
  final VoidCallback? onSpeakOptions;
  final bool isLoading;

  const InteractivePromptView({
    super.key,
    required this.prompt,
    required this.onScriptureTap,
    required this.onStoryTypeTap,
    required this.onThemeTap,
    required this.onMainCharacterTap,
    required this.onSettingTap,
    required this.onRandomize,
    this.onSpeakOptions,
    this.isLoading = false,
  });

  int get _selectedCount {
    int count = 0;
    if (prompt.scripture != null) count++;
    if (prompt.storyType != null) count++;
    if (prompt.theme != null) count++;
    if (prompt.mainCharacter != null) count++;
    if (prompt.setting != null) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allDone = _selectedCount == 5;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: allDone
              ? colorScheme.primary.withValues(alpha: 0.35)
              : colorScheme.outlineVariant.withValues(alpha: 0.2),
          width: allDone ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: allDone
                ? colorScheme.primary.withValues(alpha: 0.08)
                : colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header row ──────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 12.w, 0),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary.withValues(alpha: 0.12),
                        colorScheme.secondary.withValues(alpha: 0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.auto_stories,
                    color: colorScheme.primary,
                    size: 18.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Story Prompt',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                        ),
                      ),
                      Text(
                        '$_selectedCount of 5 selected',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: allDone
                              ? colorScheme.primary.withValues(alpha: 0.7)
                              : colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.6),
                          fontWeight: allDone
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onSpeakOptions != null) ...[
                  _SpeakOptionsChip(onTap: onSpeakOptions!),
                  SizedBox(width: 8.w),
                ],
                _RandomizeButton(onTap: onRandomize, isLoading: isLoading),
              ],
            ),
          ),

          // ── Progress bar ─────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 4.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 3.h,
                child: LinearProgressIndicator(
                  value: _selectedCount / 5.0,
                  backgroundColor:
                      colorScheme.outlineVariant.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    allDone
                        ? colorScheme.primary
                        : colorScheme.primary.withValues(alpha: 0.55),
                  ),
                ),
              ),
            ),
          ),

          // ── Justified prompt paragraph ────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 18.h),
            child: _JustifiedPromptParagraph(
              prompt: prompt,
              onScriptureTap: onScriptureTap,
              onStoryTypeTap: onStoryTypeTap,
              onThemeTap: onThemeTap,
              onMainCharacterTap: onMainCharacterTap,
              onSettingTap: onSettingTap,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Justified paragraph that uses WidgetSpan for inline chips ─────────────────
class _JustifiedPromptParagraph extends StatelessWidget {
  final StoryPrompt prompt;
  final VoidCallback onScriptureTap;
  final VoidCallback onStoryTypeTap;
  final VoidCallback onThemeTap;
  final VoidCallback onMainCharacterTap;
  final VoidCallback onSettingTap;

  const _JustifiedPromptParagraph({
    required this.prompt,
    required this.onScriptureTap,
    required this.onStoryTypeTap,
    required this.onThemeTap,
    required this.onMainCharacterTap,
    required this.onSettingTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseStyle = TextStyle(
      fontSize: 14.5.sp,
      height: 1.9,
      color: colorScheme.onSurface.withValues(alpha: 0.85),
      fontFamily: 'Georgia',
      letterSpacing: 0.1,
    );

    return Text.rich(
      textAlign: TextAlign.justify,
      TextSpan(
        style: baseStyle,
        children: [
          const TextSpan(text: 'Generate me a story from '),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: _InlineChip(
              label: prompt.scripture ?? 'scripture',
              isSelected: prompt.scripture != null,
              icon: Icons.menu_book_rounded,
              onTap: onScriptureTap,
            ),
          ),
          const TextSpan(text: ' with the story type being '),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: _InlineChip(
              label: prompt.storyType ?? 'story type',
              isSelected: prompt.storyType != null,
              icon: Icons.category_rounded,
              onTap: onStoryTypeTap,
            ),
          ),
          const TextSpan(text: '. The theme should revolve around '),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: _InlineChip(
              label: prompt.theme ?? 'theme',
              isSelected: prompt.theme != null,
              icon: Icons.palette_rounded,
              onTap: onThemeTap,
            ),
          ),
          const TextSpan(text: ', with the main character being a '),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: _InlineChip(
              label: prompt.mainCharacter ?? 'main character',
              isSelected: prompt.mainCharacter != null,
              icon: Icons.person_rounded,
              onTap: onMainCharacterTap,
            ),
          ),
          const TextSpan(text: ', set in '),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: _InlineChip(
              label: prompt.setting ?? 'setting',
              isSelected: prompt.setting != null,
              icon: Icons.landscape_rounded,
              onTap: onSettingTap,
            ),
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }
}

class _InlineChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final IconData icon;
  final VoidCallback onTap;

  const _InlineChip({
    required this.label,
    required this.isSelected,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_InlineChip> createState() => _InlineChipState();
}

class _InlineChipState extends State<_InlineChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 110),
      vsync: this,
    );
    _scale = Tween(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final sel = widget.isSelected;

    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) => _ctrl.reverse(),
      onTapCancel: () => _ctrl.reverse(),
      onTap: () {
        HapticFeedback.selectionClick();
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
          margin: EdgeInsets.symmetric(horizontal: 1.w),
          decoration: BoxDecoration(
            gradient: sel
                ? LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withValues(alpha: 0.82),
                    ],
                  )
                : null,
            color: sel
                ? null
                : colorScheme.primary.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: sel
                  ? colorScheme.primary.withValues(alpha: 0.6)
                  : colorScheme.primary.withValues(alpha: 0.25),
              width: sel ? 1.5 : 1,
            ),
            boxShadow: sel
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.22),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 11.sp,
                color: sel
                    ? colorScheme.onPrimary
                    : colorScheme.primary,
              ),
              SizedBox(width: 5.w),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: sel ? colorScheme.onPrimary : colorScheme.primary,
                  letterSpacing: 0.1,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                sel ? Icons.check_rounded : Icons.keyboard_arrow_down_rounded,
                size: 12.sp,
                color: sel
                    ? colorScheme.onPrimary.withValues(alpha: 0.85)
                    : colorScheme.primary.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Speak options chip ────────────────────────────────────────────────────────
class _SpeakOptionsChip extends StatelessWidget {
  final VoidCallback onTap;
  const _SpeakOptionsChip({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              c.primary.withValues(alpha: 0.2),
              c.secondary.withValues(alpha: 0.15),
            ],
          ),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: c.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.mic_rounded, size: 14.sp, color: c.primary),
            SizedBox(width: 6.w),
            Text(
              'Speak',
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: c.primary),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Randomize button ──────────────────────────────────────────────────────────
class _RandomizeButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isLoading;
  const _RandomizeButton({required this.onTap, this.isLoading = false});

  @override
  State<_RandomizeButton> createState() => _RandomizeButtonState();
}

class _RandomizeButtonState extends State<_RandomizeButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleCtrl;
  late AnimationController _rotateCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    _scaleAnim = Tween(begin: 1.0, end: 0.92)
        .animate(CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeInOut));
    _rotateCtrl = AnimationController(
        duration: const Duration(milliseconds: 420), vsync: this);
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    _rotateCtrl.dispose();
    super.dispose();
  }

  void _onTap() {
    if (widget.isLoading) return;
    HapticFeedback.mediumImpact();
    _scaleCtrl.forward().then((_) => _scaleCtrl.reverse());
    _rotateCtrl.forward(from: 0).then((_) => _rotateCtrl.reset());
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _scaleCtrl,
        builder: (_, child) =>
            Transform.scale(scale: _scaleAnim.value, child: child),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                c.secondaryContainer,
                c.secondaryContainer.withValues(alpha: 0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                  color: c.shadow.withValues(alpha: 0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.isLoading)
                SizedBox(
                  width: 16.sp,
                  height: 16.sp,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: c.onSecondaryContainer),
                )
              else
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: _rotateCtrl, curve: Curves.easeOutBack),
                  ),
                  child: Icon(Icons.casino_rounded,
                      size: 16.sp, color: c.onSecondaryContainer),
                ),
              SizedBox(width: 6.w),
              Text('Random',
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: c.onSecondaryContainer)),
            ],
          ),
        ),
      ),
    );
  }
}
