import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myitihas/features/story_generator/presentation/bloc/story_generator_bloc.dart';
import 'package:myitihas/i18n/strings.g.dart';

/// Pool of exemplar prompts - 3 are randomly selected per overlay open
const List<String> _exemplarPrompts = [
  'Tell me a story about Krishna',
  'Share a tale from the Ramayana',
  'Generate a story from the Mahabharata',
  'Narrate the legend of Hanuman and his devotion',
  'Create a story about Arjuna and the Bhagavad Gita',
  'Write about the wisdom of ancient sages',
  'Tell me about Shiva and Parvati',
  'Share a story of devotion and surrender',
  'Generate a tale from the Puranas',
  'Narrate the journey of a spiritual seeker',
  'Tell me about the avatars of Vishnu',
  'Create a story about the festival of Diwali',
  'Write about the teachings of the Upanishads',
  'Share a tale of courage from Indian scriptures',
  'Generate a story about the Ganga river',
  'Narrate the legend of Durga and Mahishasura',
  'Tell me about the sage Valmiki',
  'Create a story about yoga and meditation',
  'Write about the chariot of the sun god',
  'Share a tale from the Panchatantra',
];

/// Voice input overlay with tappable example prompts, keyboard switch, and listening animation.
/// [onSwitchToKeyboard] closes overlay and focuses the raw prompt text field when provided.
class VoiceInputOverlay extends StatefulWidget {
  final VoidCallback? onSwitchToKeyboard;

  const VoiceInputOverlay({super.key, this.onSwitchToKeyboard});

  @override
  State<VoiceInputOverlay> createState() => _VoiceInputOverlayState();
}

class _VoiceInputOverlayState extends State<VoiceInputOverlay> {
  late List<String> _displayPrompts;
  final Random _rng = Random();

  void _pickRandomPrompts() {
    final shuffled = List<String>.from(_exemplarPrompts)..shuffle(_rng);
    _displayPrompts = shuffled.take(3).toList();
  }

  @override
  void initState() {
    super.initState();
    _pickRandomPrompts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoryGeneratorBloc, StoryGeneratorState>(
      listenWhen: (a, b) => a.isListening != b.isListening,
      listener: (context, state) {
        if (state.isListening) {
          setState(() => _pickRandomPrompts());
        }
      },
      buildWhen: (a, b) => a.isListening != b.isListening || a.partialVoiceResult != b.partialVoiceResult,
      builder: (context, state) {
        if (!state.isListening) return const SizedBox.shrink();

        void close() {
          context.read<StoryGeneratorBloc>().add(
            const StoryGeneratorEvent.toggleVoiceInput(),
          );
        }

        void applyExamplePrompt(String text) {
          HapticFeedback.selectionClick();
          context.read<StoryGeneratorBloc>().add(
            StoryGeneratorEvent.updateRawPrompt(text: text),
          );
          close();
        }

        void switchToKeyboard() {
          HapticFeedback.selectionClick();
          close();
          widget.onSwitchToKeyboard?.call();
        }

        final hasPartial = (state.partialVoiceResult ?? '').trim().isNotEmpty;

        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              // Dim + blur backdrop (tap to close)
              GestureDetector(
                onTap: close,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black.withOpacity(0.70),
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),

              // Foreground content
              SafeArea(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: _GlassCard(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 20.h),

                            // Header (logo placeholder + app name)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              Container(
                                width: 30.w,
                                height: 30.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.25),
                                  ),
                                  color: Colors.white.withOpacity(0.06),
                                ),
                                child: Icon(
                                  Icons.auto_stories_rounded,
                                  color: Colors.white.withOpacity(0.9),
                                  size: 15.sp,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'myitihas',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.92),
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.4,
                                ),
                              ),
                              ],
                            ),

                            SizedBox(height: 16.h),

                            Text(
                              'Tell your story aloud',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.95),
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                                height: 1.25,
                                letterSpacing: 0.2,
                              ),
                            ),

                            SizedBox(height: 24.h),

                            // Tappable example prompts (3 random per open)
                            ..._displayPrompts.map(
                              (text) => ExamplePrompt(
                                text: text,
                                onTap: () => applyExamplePrompt(text),
                              ),
                            ),

                            SizedBox(height: 28.h),

                            // Mic button with glow and listening animation
                            _MicButtonWithRings(onTap: close),

                            SizedBox(height: 16.h),

                            // Partial text / Listening with subtle highlight
                            Padding(
                            padding: EdgeInsets.symmetric(horizontal: 26.w),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, 0.05),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                );
                              },
                              child: hasPartial
                                  ? _PartialResultText(
                                      key: const ValueKey('partial'),
                                      text: state.partialVoiceResult!.trim(),
                                    )
                                  : Text(
                                      'Listening...',
                                      key: const ValueKey('listening'),
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.60),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ),
                            ),

                            SizedBox(height: 10.h),

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 22.w),
                              child: Text(
                                Translations.of(context).voice.storyVoiceListeningHint,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.48),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 1.35,
                                ),
                              ),
                            ),

                            SizedBox(height: 20.h),

                            // Bottom bar (keyboard + label + close)
                            Padding(
                            padding: EdgeInsets.only(
                              left: 14.w,
                              right: 14.w,
                              bottom: 14.h,
                            ),
                              child: Row(
                                children: [
                                  _BottomIconButton(
                                  icon: Icons.keyboard_rounded,
                                  onTap: switchToKeyboard,
                                  visibility: true,
                                    tooltip: 'Switch to keyboard',
                                  ),
                                  const Spacer(),
                                  Text(
                                    'Tap to talk',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.75),
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  _BottomIconButton(
                                    icon: Icons.close_rounded,
                                    onTap: close,
                                    tooltip: 'Close',
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Animated text for partial voice result with typing highlight effect
class _PartialResultText extends StatefulWidget {
  final String text;

  const _PartialResultText({super.key, required this.text});

  @override
  State<_PartialResultText> createState() => _PartialResultTextState();
}

class _PartialResultTextState extends State<_PartialResultText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (context, child) {
        return DefaultTextStyle(
          style: TextStyle(
            color: Colors.white.withOpacity(0.95 * _opacity.value),
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            height: 1.25,
          ),
          textAlign: TextAlign.center,
          child: child!,
        );
      },
      child: Text(widget.text),
    );
  }
}

/// Frosted glass container (rounded, subtle border, inner gradient)
class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(maxWidth: 420.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26.r),
            border: Border.all(color: Colors.white.withOpacity(0.10), width: 1),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.10),
                Colors.white.withOpacity(0.04),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.45),
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Mic button with animated concentric circles when listening
class _MicButtonWithRings extends StatefulWidget {
  final VoidCallback onTap;

  const _MicButtonWithRings({required this.onTap});

  @override
  State<_MicButtonWithRings> createState() => _MicButtonWithRingsState();
}

class _MicButtonWithRingsState extends State<_MicButtonWithRings>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120.w,
      height: 120.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated concentric circles
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: Size(120.w, 120.w),
                painter: _ListeningRingsPainter(
                  progress: _controller.value,
                  baseRadius: 43.w,
                  ringSpread: 30.w,
                ),
              );
            },
          ),
          // Mic button
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.85, end: 1.0),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeInOut,
            builder: (context, t, child) {
              return Transform.scale(scale: t, child: child);
            },
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                width: 86.w,
                height: 86.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2AA7FF), // cyan-blue
                      Color(0xFF8A2BE2), // purple
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2AA7FF).withOpacity(0.35),
                      blurRadius: 28,
                      spreadRadius: 6,
                    ),
                    BoxShadow(
                      color: const Color(0xFF8A2BE2).withOpacity(0.25),
                      blurRadius: 28,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.mic_rounded,
                    color: Colors.white,
                    size: 38.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListeningRingsPainter extends CustomPainter {
  final double progress;
  final double baseRadius;
  final double ringSpread;

  _ListeningRingsPainter({
    required this.progress,
    required this.baseRadius,
    required this.ringSpread,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 3; i++) {
      final delayedProgress = (progress + i * 0.33) % 1.0;
      final radius = baseRadius + delayedProgress * ringSpread;
      final opacity = (1 - delayedProgress) * 0.25;
      final paint = Paint()
        ..color = Colors.white.withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ListeningRingsPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.baseRadius != baseRadius ||
      oldDelegate.ringSpread != ringSpread;
}

class _BottomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool visibility;
  final String? tooltip;

  const _BottomIconButton({
    required this.icon,
    required this.onTap,
    this.visibility = true,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final child = GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42.w,
        height: 42.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: visibility
                ? Colors.white.withOpacity(0.12)
                : Colors.transparent,
          ),
          color: visibility
              ? Colors.white.withOpacity(0.06)
              : Colors.transparent,
        ),
        child: Icon(
          icon,
          color: visibility
              ? Colors.white.withOpacity(0.75)
              : Colors.transparent,
          size: 20.sp,
        ),
      ),
    );
    if (tooltip != null && visibility) {
      return Tooltip(message: tooltip!, child: child);
    }
    return child;
  }
}

/// Tappable example prompt with scale and fade animation on tap
class ExamplePrompt extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;

  const ExamplePrompt({super.key, required this.text, this.onTap});

  @override
  State<ExamplePrompt> createState() => _ExamplePromptState();
}

class _ExamplePromptState extends State<ExamplePrompt>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _opacity = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _controller.forward();

  void _onTapUp(TapUpDetails _) {
    _controller.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    final child = Container(
      margin: EdgeInsets.symmetric(vertical: 7.h, horizontal: 18.w),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.14)),
        borderRadius: BorderRadius.circular(18.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.92),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 10.w),
          Icon(
            Icons.chevron_right_rounded,
            color: Colors.white.withOpacity(0.55),
            size: 18.sp,
          ),
        ],
      ),
    );

    if (widget.onTap == null) return child;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Transform.scale(
            scale: _scale.value,
            child: Opacity(
              opacity: _opacity.value,
              child: child,
            ),
          );
        },
      ),
    );
  }
}
