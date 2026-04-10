import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myitihas/core/widgets/voice_input/microphone_permission_helper.dart';
import 'package:myitihas/features/story_generator/domain/entities/story_prompt.dart';
import 'package:myitihas/features/story_generator/presentation/bloc/story_generator_bloc.dart';

/// Raw prompt input view with fading hint suggestions and a premium mic experience
class RawPromptView extends StatefulWidget {
  final StoryPrompt prompt;
  final ValueChanged<String> onPromptChanged;
  final VoidCallback onScriptureTap;
  final VoidCallback onStoryTypeTap;
  final VoidCallback onThemeTap;
  final VoidCallback onMainCharacterTap;
  final VoidCallback onSettingTap;
  final FocusNode? focusNode;

  const RawPromptView({
    super.key,
    required this.prompt,
    required this.onPromptChanged,
    required this.onScriptureTap,
    required this.onStoryTypeTap,
    required this.onThemeTap,
    required this.onMainCharacterTap,
    required this.onSettingTap,
    this.focusNode,
  });

  @override
  State<RawPromptView> createState() => _RawPromptViewState();
}

class _RawPromptViewState extends State<RawPromptView>
    with TickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _ownsFocusNode = false;

  final List<String> _hints = [
    'Tell me a story about Krishna teaching Arjuna...',
    'Write an epic tale of a warrior seeking redemption...',
    'Create a story about the wisdom of the ancient sages...',
    'Narrate the journey of a devoted seeker of truth...',
    'Share the legend of a divine intervention...',
  ];
  int _currentHintIndex = 0;
  Timer? _hintTimer;
  bool _showOptions = false;

  // Mic wave animation
  late AnimationController _waveAnim;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.prompt.rawPrompt);
    _ownsFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    _startHintRotation();

    _waveAnim = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  void _onFocusChange() => setState(() {});

  @override
  void didUpdateWidget(RawPromptView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.prompt.rawPrompt != _controller.text) {
      _controller.text = widget.prompt.rawPrompt ?? '';
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (_ownsFocusNode) _focusNode.dispose();
    _controller.dispose();
    _hintTimer?.cancel();
    _waveAnim.dispose();
    super.dispose();
  }

  void _startHintRotation() {
    _hintTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted) {
        setState(
            () => _currentHintIndex = (_currentHintIndex + 1) % _hints.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Main text input card ─────────────────────────────────────────
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: isDark
                ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: _focusNode.hasFocus
                  ? colorScheme.primary.withValues(alpha: 0.5)
                  : colorScheme.outlineVariant.withValues(alpha: 0.2),
              width: _focusNode.hasFocus ? 1.8 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _focusNode.hasFocus
                    ? colorScheme.primary.withValues(alpha: 0.1)
                    : colorScheme.shadow.withValues(alpha: 0.05),
                blurRadius: _focusNode.hasFocus ? 18 : 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 14.w, 0),
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
                      child: Icon(Icons.edit_note_rounded,
                          color: colorScheme.primary, size: 18.sp),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Story Idea',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.primary,
                            ),
                          ),
                          Text(
                            'Type freely or use the mic',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.65),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10.h),

              // Text field with animated hint
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Stack(
                  children: [
                    if (_controller.text.isEmpty)
                      Padding(
                        padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          switchInCurve: Curves.easeOut,
                          switchOutCurve: Curves.easeIn,
                          transitionBuilder: (child, anim) => FadeTransition(
                            opacity: anim,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.06),
                                end: Offset.zero,
                              ).animate(anim),
                              child: child,
                            ),
                          ),
                          child: Text(
                            _hints[_currentHintIndex],
                            key: ValueKey(_currentHintIndex),
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontStyle: FontStyle.italic,
                              color: colorScheme.onSurface
                                  .withValues(alpha: 0.35),
                              height: 1.6,
                            ),
                          ),
                        ),
                      ),
                    TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      maxLines: 6,
                      minLines: 4,
                      textAlign: TextAlign.justify,
                      onChanged: widget.onPromptChanged,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontFamily: 'Georgia',
                        color: colorScheme.onSurface,
                        height: 1.65,
                        letterSpacing: 0.1,
                      ),
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        hintText: '',
                        contentPadding: EdgeInsets.all(12.w),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 4.h),
              Divider(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.15),
                  height: 1),

              // Optional options toggle
              InkWell(
                onTap: () => setState(() => _showOptions = !_showOptions),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(14.w),
                  child: Row(
                    children: [
                      Icon(Icons.tune_rounded,
                          size: 16.sp,
                          color: colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.7)),
                      SizedBox(width: 8.w),
                      Text(
                        'Optional: add context tags',
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          color: colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.75),
                        ),
                      ),
                      const Spacer(),
                      AnimatedRotation(
                        turns: _showOptions ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(Icons.keyboard_arrow_down,
                            color: colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.6)),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: _buildOptionalOptions(context),
                crossFadeState: _showOptions
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 280),
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // ── Premium Mic Card ─────────────────────────────────────────────
        BlocBuilder<StoryGeneratorBloc, StoryGeneratorState>(
          buildWhen: (a, b) =>
              a.isListening != b.isListening ||
              a.partialVoiceResult != b.partialVoiceResult,
          builder: (context, state) {
            return _PremiumMicCard(
              isListening: state.isListening,
              partialText: state.partialVoiceResult,
              waveAnim: _waveAnim,
              onTap: () async {
                HapticFeedback.mediumImpact();
                if (!state.isListening) {
                  final ok = await ensureMicrophonePermission(context);
                  if (!ok || !context.mounted) return;
                }
                if (!context.mounted) return;
                context
                    .read<StoryGeneratorBloc>()
                    .add(const StoryGeneratorEvent.toggleVoiceInput());
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildOptionalOptions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final chips = [
      _OptChip(
          label: widget.prompt.scripture ?? 'Scripture',
          isSelected: widget.prompt.scripture != null,
          onTap: widget.onScriptureTap,
          icon: Icons.menu_book_rounded,
          colorScheme: colorScheme,
          index: 0),
      _OptChip(
          label: widget.prompt.storyType ?? 'Story Type',
          isSelected: widget.prompt.storyType != null,
          onTap: widget.onStoryTypeTap,
          icon: Icons.category_rounded,
          colorScheme: colorScheme,
          index: 1),
      _OptChip(
          label: widget.prompt.theme ?? 'Theme',
          isSelected: widget.prompt.theme != null,
          onTap: widget.onThemeTap,
          icon: Icons.palette_rounded,
          colorScheme: colorScheme,
          index: 2),
      _OptChip(
          label: widget.prompt.mainCharacter ?? 'Character',
          isSelected: widget.prompt.mainCharacter != null,
          onTap: widget.onMainCharacterTap,
          icon: Icons.person_rounded,
          colorScheme: colorScheme,
          index: 3),
      _OptChip(
          label: widget.prompt.setting ?? 'Setting',
          isSelected: widget.prompt.setting != null,
          onTap: widget.onSettingTap,
          icon: Icons.landscape_rounded,
          colorScheme: colorScheme,
          index: 4),
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
      child: Wrap(spacing: 8.w, runSpacing: 8.h, children: chips),
    );
  }
}

// ── Premium Mic Card ──────────────────────────────────────────────────────────
class _PremiumMicCard extends StatelessWidget {
  final bool isListening;
  final String? partialText;
  final AnimationController waveAnim;
  final VoidCallback onTap;

  const _PremiumMicCard({
    required this.isListening,
    required this.partialText,
    required this.waveAnim,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: isListening
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    c.primary,
                    c.primary.withValues(alpha: 0.85),
                    c.secondary.withValues(alpha: 0.9),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          c.surfaceContainerHighest.withValues(alpha: 0.4),
                          c.surfaceContainerHighest.withValues(alpha: 0.25),
                        ]
                      : [
                          c.primaryContainer.withValues(alpha: 0.35),
                          c.secondaryContainer.withValues(alpha: 0.2),
                        ],
                ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isListening
                ? c.primary.withValues(alpha: 0.4)
                : c.outlineVariant.withValues(alpha: 0.2),
            width: isListening ? 1.5 : 1,
          ),
          boxShadow: isListening
              ? [
                  BoxShadow(
                    color: c.primary.withValues(alpha: 0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: c.shadow.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Mic button with wave rings
            SizedBox(
              width: 68.w,
              height: 68.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Animated wave rings (only when listening)
                  if (isListening) ...[
                    _WaveRing(anim: waveAnim, delay: 0.0, c: c),
                    _WaveRing(anim: waveAnim, delay: 0.33, c: c),
                    _WaveRing(anim: waveAnim, delay: 0.66, c: c),
                  ],
                  // Core circle
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 56.w,
                    height: 56.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isListening
                            ? [
                                Colors.white.withValues(alpha: 0.25),
                                Colors.white.withValues(alpha: 0.1),
                              ]
                            : [
                                c.primary.withValues(alpha: 0.15),
                                c.primary.withValues(alpha: 0.08),
                              ],
                      ),
                      border: Border.all(
                        color: isListening
                            ? Colors.white.withValues(alpha: 0.35)
                            : c.primary.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                      boxShadow: isListening
                          ? [
                              BoxShadow(
                                color:
                                    Colors.white.withValues(alpha: 0.15),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      isListening ? Icons.stop_rounded : Icons.mic_rounded,
                      size: 26.sp,
                      color: isListening ? Colors.white : c.primary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            // Text area
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isListening ? 'Listening…' : 'Voice Input',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: isListening ? Colors.white : c.onSurface,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isListening && partialText != null && partialText!.isNotEmpty
                        ? Text(
                            partialText!,
                            key: const ValueKey('partial'),
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.white.withValues(alpha: 0.9),
                              fontStyle: FontStyle.italic,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        : Text(
                            isListening
                                ? 'Speak your story idea clearly…'
                                : 'Tap to dictate your story idea',
                            key: ValueKey(isListening),
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: isListening
                                  ? Colors.white.withValues(alpha: 0.75)
                                  : c.onSurfaceVariant
                                      .withValues(alpha: 0.7),
                              height: 1.4,
                            ),
                          ),
                  ),
                  SizedBox(height: 8.h),
                  // Status pill
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: isListening
                          ? Colors.white.withValues(alpha: 0.2)
                          : c.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isListening
                            ? Colors.white.withValues(alpha: 0.3)
                            : c.primary.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isListening)
                          _BlinkingDot(color: Colors.white)
                        else
                          Icon(Icons.touch_app_rounded,
                              size: 12.sp, color: c.primary),
                        SizedBox(width: 5.w),
                        Text(
                          isListening ? 'Recording' : 'Tap to start',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: isListening
                                ? Colors.white
                                : c.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Animated wave ring around the mic ─────────────────────────────────────────
class _WaveRing extends StatelessWidget {
  final AnimationController anim;
  final double delay;
  final ColorScheme c;

  const _WaveRing({required this.anim, required this.delay, required this.c});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: anim,
      builder: (_, __) {
        final t = ((anim.value + delay) % 1.0);
        final size = 56.0 + t * 28.0;
        final opacity = (1.0 - t) * 0.5;
        return Container(
          width: size.w,
          height: size.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: opacity),
              width: 1.5,
            ),
          ),
        );
      },
    );
  }
}

// ── Blinking red dot for recording indicator ──────────────────────────────────
class _BlinkingDot extends StatefulWidget {
  final Color color;
  const _BlinkingDot({required this.color});

  @override
  State<_BlinkingDot> createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<_BlinkingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _ctrl,
      child: Container(
        width: 8.w,
        height: 8.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color,
          boxShadow: [
            BoxShadow(
                color: widget.color.withValues(alpha: 0.5),
                blurRadius: 6,
                spreadRadius: 1),
          ],
        ),
      ),
    );
  }
}

// ── Optional tag chips in raw mode ────────────────────────────────────────────
class _OptChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData icon;
  final ColorScheme colorScheme;
  final int index;

  const _OptChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.icon,
    required this.colorScheme,
    required this.index,
  });

  @override
  State<_OptChip> createState() => _OptChipState();
}

class _OptChipState extends State<_OptChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);
    _scale = Tween(begin: 1.0, end: 0.94)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.colorScheme;
    final sel = widget.isSelected;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 220 + widget.index * 40),
      curve: Curves.easeOut,
      builder: (ctx, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(0, 6 * (1 - v)), child: child),
      ),
      child: GestureDetector(
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
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              gradient: sel
                  ? LinearGradient(
                      colors: [c.primary, c.primary.withValues(alpha: 0.8)])
                  : null,
              color: sel ? null : c.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: sel
                    ? c.primary.withValues(alpha: 0.5)
                    : c.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(sel ? Icons.check_circle_rounded : widget.icon,
                    size: 14.sp,
                    color: sel ? c.onPrimary : c.onSurfaceVariant),
                SizedBox(width: 6.w),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w600,
                    color: sel ? c.onPrimary : c.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
