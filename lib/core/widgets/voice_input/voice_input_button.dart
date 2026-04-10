import 'package:flutter/material.dart';
import 'package:myitihas/core/widgets/voice_input/microphone_permission_helper.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// A mic icon button that starts speech-to-text and appends the result
/// to the given [controller]. Use as suffixIcon in TextField decoration.
class VoiceInputButton extends StatefulWidget {
  final TextEditingController controller;

  /// Optional: append text to existing or replace. Default appends with space.
  final bool append;

  /// Called when speech result is received (for custom handling).
  /// If null, text is appended to [controller].
  final void Function(String text)? onResult;

  /// Called on error (e.g. permission denied).
  final void Function(String message)? onError;

  /// When true, uses smaller icon and padding for dense/compact fields.
  final bool compact;

  const VoiceInputButton({
    super.key,
    required this.controller,
    this.append = true,
    this.onResult,
    this.onError,
    this.compact = false,
  });

  @override
  State<VoiceInputButton> createState() => _VoiceInputButtonState();
}

class _VoiceInputButtonState extends State<VoiceInputButton>
    with SingleTickerProviderStateMixin {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _isInitialized = false;
  String _latestRecognizedWords = '';
  late AnimationController _pulseController;
  late Animation<double> _breathe;

  void _syncPulseAnimation() {
    if (_isListening) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController
        ..stop()
        ..reset();
    }
  }

  void _resetListeningUi() {
    if (!mounted) return;
    setState(() => _isListening = false);
    _syncPulseAnimation();
  }

  void _applyRecognizedText(String text) {
    final normalized = text.trim();
    if (normalized.isEmpty) return;

    if (widget.onResult != null) {
      widget.onResult!(normalized);
      return;
    }

    final ctrl = widget.controller;
    final current = ctrl.text;
    final prefix = widget.append && current.isNotEmpty ? '$current ' : '';
    ctrl.text = '$prefix$normalized';
    ctrl.selection = TextSelection.collapsed(offset: ctrl.text.length);
  }

  void _flushPendingSpeech() {
    if (_latestRecognizedWords.isEmpty) return;
    _applyRecognizedText(_latestRecognizedWords);
    _latestRecognizedWords = '';
  }

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    );
    _breathe = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _speech.stop();
    super.dispose();
  }

  Future<void> _startListening() async {
    if (_isListening) {
      await _speech.stop();
      _flushPendingSpeech();
      _resetListeningUi();
      return;
    }

    final micOk = await ensureMicrophonePermission(context);
    if (!micOk) {
      widget.onError?.call('Microphone permission denied');
      if (!mounted) return;
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;

    if (!_isInitialized) {
      _isInitialized = await _speech.initialize(
        onError: (e) {
          widget.onError?.call(e.errorMsg);
          _flushPendingSpeech();
          _resetListeningUi();
        },
        finalTimeout: const Duration(seconds: 4),
        onStatus: (s) {
          if (s == 'done' || s == 'notListening' || s == 'paused') {
            _flushPendingSpeech();
            _resetListeningUi();
          }
        },
      );
      if (!_isInitialized) {
        widget.onError?.call('Speech recognition not available');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                Translations.of(context).voice.speechRecognitionNotAvailable,
              ),
            ),
          );
        }
        return;
      }
    }

    if (!mounted) return;
    setState(() => _isListening = true);
    _syncPulseAnimation();

    await _speech.listen(
      onResult: (result) {
        if (result.recognizedWords.isNotEmpty) {
          _latestRecognizedWords = result.recognizedWords.trim();
        }
        if (result.finalResult) {
          _flushPendingSpeech();
        }
      },
      listenFor: const Duration(seconds: 45),
      pauseFor: const Duration(seconds: 20),
      listenOptions: stt.SpeechListenOptions(
        listenMode: stt.ListenMode.dictation,
        partialResults: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final iconSize = widget.compact ? 18.0 : 20.0;
    final padding = widget.compact ? 4.0 : 6.0;
    final minSize = widget.compact ? 44.0 : 48.0;
    final box = iconSize + 14;

    return IconButton(
      onPressed: _startListening,
      icon: AnimatedBuilder(
        animation: _breathe,
        builder: (context, child) {
          final t = _isListening ? _breathe.value : 0.0;
          final opacity = _isListening ? 0.62 + 0.28 * t : 1.0;
          final scale = _isListening ? 0.96 + 0.04 * t : 1.0;

          return SizedBox(
            width: box,
            height: box,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                if (_isListening)
                  CustomPaint(
                    size: Size(box, box),
                    painter: _ListeningRingPainter(
                      progress: t,
                      color: colorScheme.primary,
                    ),
                  ),
                Opacity(
                  opacity: opacity,
                  child: Transform.scale(
                    scale: scale,
                    child: Icon(
                      _isListening ? Icons.mic_rounded : Icons.mic_none_outlined,
                      color: _isListening
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      size: iconSize,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      tooltip: _isListening ? 'Stop listening' : 'Voice input',
      padding: EdgeInsets.all(padding),
      constraints: BoxConstraints(minWidth: minSize, minHeight: minSize),
      style: widget.compact
          ? IconButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            )
          : null,
    );
  }
}

/// Subtle expanding ring while the mic is active.
class _ListeningRingPainter extends CustomPainter {
  _ListeningRingPainter({
    required this.progress,
    required this.color,
  });

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final base = size.shortestSide * 0.28;

    for (var i = 0; i < 2; i++) {
      final phase = (progress + i * 0.5) % 1.0;
      final radius = base + phase * (size.shortestSide * 0.22);
      final opacity = (1 - phase) * 0.22;
      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ListeningRingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
