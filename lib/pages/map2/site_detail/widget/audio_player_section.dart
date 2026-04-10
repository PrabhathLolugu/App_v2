import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:myitihas/pages/map2/app_theme.dart';
import 'package:myitihas/pages/map2/widgets/custom_icon_widget.dart';
import 'package:sizer/sizer.dart';

/// A single narration block with a heading and spoken body content.
class AudioNarrationSection {
  final String heading;
  final String body;

  const AudioNarrationSection({required this.heading, required this.body});

  bool get hasContent => heading.trim().isNotEmpty && body.trim().isNotEmpty;
}

/// Audio player for sacred soundscapes and section narration.
class AudioPlayerSection extends StatefulWidget {
  final String audioTitle;
  final List<AudioNarrationSection> sections;
  final String preferredLocale;

  const AudioPlayerSection({
    super.key,
    required this.audioTitle,
    required this.sections,
    this.preferredLocale = 'en-IN',
  });

  @override
  State<AudioPlayerSection> createState() => _AudioPlayerSectionState();
}

class _AudioPlayerSectionState extends State<AudioPlayerSection> {
  final FlutterTts _tts = FlutterTts();

  bool _isReady = false;
  bool _isPlaying = false;
  bool _isPaused = false;
  bool _isScrubbing = false;

  double _progress = 0.0;
  double _volume = 0.7;
  int _currentOffset = 0;
  int _speakStartOffset = 0;
  bool _pauseRequested = false;
  String? _error;
  late String _narrationText;

  @override
  void initState() {
    super.initState();
    _narrationText = _buildNarrationText();
    _initializeTts();
  }

  @override
  void didUpdateWidget(covariant AudioPlayerSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    final localeChanged = oldWidget.preferredLocale != widget.preferredLocale;
    final sectionsChanged = oldWidget.sections != widget.sections;
    if (!localeChanged && !sectionsChanged) {
      return;
    }

    _narrationText = _buildNarrationText();
    _resetProgress();

    if (localeChanged) {
      _applyPreferredVoice();
    }
    if (_isPlaying || _isPaused) {
      _stopPlayback(resetToStart: true);
    }
  }

  Future<void> _initializeTts() async {
    try {
      await _tts.setVolume(_volume);
      await _tts.setSpeechRate(0.44);
      await _tts.setPitch(1.0);
      await _tts.awaitSpeakCompletion(true);

      await _applyPreferredVoice();

      _tts.setStartHandler(() {
        if (!mounted) return;
        setState(() {
          _isPlaying = true;
          _isPaused = false;
          _error = null;
        });
      });

      _tts.setProgressHandler((text, start, end, word) {
        if (!mounted || _narrationText.isEmpty || _isScrubbing) return;
        final absolute = (_speakStartOffset + end).clamp(
          0,
          _narrationText.length,
        );
        setState(() {
          _currentOffset = absolute;
          _progress = absolute / _narrationText.length;
        });
      });

      _tts.setCompletionHandler(() {
        if (!mounted) return;
        setState(() {
          _isPlaying = false;
          _isPaused = false;
          _currentOffset = 0;
          _progress = 0;
        });
      });

      _tts.setCancelHandler(() {
        if (!mounted) return;
        if (_pauseRequested) {
          _pauseRequested = false;
          setState(() {
            _isPlaying = false;
            _isPaused = true;
          });
          return;
        }
        setState(() {
          _isPlaying = false;
          _isPaused = false;
        });
      });

      if (!mounted) return;
      setState(() {
        _isReady = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Audio narration is unavailable on this device.';
      });
    }
  }

  Future<void> _applyPreferredVoice() async {
    final fallbackLocale = 'en-IN';
    final preferred = widget.preferredLocale.trim().isEmpty
        ? fallbackLocale
        : widget.preferredLocale;
    try {
      await _tts.setLanguage(preferred);

      final voices = await _tts.getVoices;
      if (voices is! List) {
        return;
      }

      Map<dynamic, dynamic>? selected;
      for (final voice in voices) {
        if (voice is! Map) continue;
        final locale = (voice['locale'] ?? '').toString().toLowerCase();
        final name = (voice['name'] ?? '').toString().toLowerCase();
        if (locale.startsWith(preferred.toLowerCase())) {
          selected = voice;
          break;
        }
        if (selected == null &&
            (locale.contains('-in') || name.contains('india'))) {
          selected = voice;
        }
      }

      if (selected != null) {
        await _tts.setVoice({
          'name': selected['name'],
          'locale': selected['locale'],
        });
      }
    } catch (_) {
      await _tts.setLanguage(fallbackLocale);
    }
  }

  String _buildNarrationText() {
    final buffer = StringBuffer();
    final cleanedTitle = _cleanForSpeech(widget.audioTitle);
    if (cleanedTitle.isNotEmpty) {
      buffer.writeln('Sacred site overview: $cleanedTitle.');
      buffer.writeln();
    }

    for (final section in widget.sections.where(
      (section) => section.hasContent,
    )) {
      final heading = _cleanForSpeech(section.heading);
      final body = _cleanForSpeech(section.body);
      if (heading.isEmpty || body.isEmpty) continue;
      buffer.writeln('$heading.');
      buffer.writeln(body);
      buffer.writeln();
    }

    final text = buffer.toString().trim();
    return text.isEmpty ? 'No narration available for this site.' : text;
  }

  String _cleanForSpeech(String text) {
    return text
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'[#*_`>\[\]]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(' - ', '. ')
        .trim();
  }

  Future<void> _togglePlayPause() async {
    if (!_isReady || _narrationText.trim().isEmpty) {
      return;
    }

    if (_isPlaying) {
      _pauseRequested = true;
      await _tts.stop();
      return;
    }

    await _speakFromOffset(_currentOffset);
  }

  Future<void> _speakFromOffset(int offset) async {
    if (_narrationText.isEmpty) return;
    final clampedOffset = offset.clamp(0, _narrationText.length);
    final remaining = _narrationText.substring(clampedOffset);
    if (remaining.trim().isEmpty) {
      _resetProgress();
      return;
    }

    _speakStartOffset = clampedOffset;
    _currentOffset = clampedOffset;
    _pauseRequested = false;
    await _tts.setVolume(_volume);
    await _tts.speak(remaining);
  }

  Future<void> _seekTo(double value) async {
    if (_narrationText.isEmpty) return;
    final clamped = value.clamp(0.0, 1.0);
    final nextOffset = (clamped * _narrationText.length).round();

    setState(() {
      _progress = clamped;
      _currentOffset = nextOffset;
      _isScrubbing = false;
    });

    if (_isPlaying) {
      await _tts.stop();
      await _speakFromOffset(nextOffset);
    }
  }

  Future<void> _restartNarration() async {
    await _stopPlayback(resetToStart: true);
    await _speakFromOffset(0);
  }

  Future<void> _stopPlayback({required bool resetToStart}) async {
    _pauseRequested = false;
    await _tts.stop();
    if (!mounted) return;
    setState(() {
      _isPlaying = false;
      _isPaused = false;
      if (resetToStart) {
        _resetProgress();
      }
    });
  }

  void _resetProgress() {
    _currentOffset = 0;
    _progress = 0;
  }

  int _estimateDurationSeconds(String text, {int wordsPerMinute = 145}) {
    if (text.trim().isEmpty || wordsPerMinute <= 0) return 0;
    final words = text.trim().split(RegExp(r'\s+')).length;
    return ((words / wordsPerMinute) * 60).ceil();
  }

  String _formatDuration(double seconds) {
    final duration = Duration(seconds: seconds.toInt());
    final minutes = duration.inMinutes;
    final secs = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalSeconds = _estimateDurationSeconds(_narrationText);
    final currentSeconds = (totalSeconds * _progress).clamp(
      0.0,
      totalSeconds.toDouble(),
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor, width: 1.0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.map.sacredSoundscape,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppTheme.accentPink,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            widget.audioTitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          if (_error != null) ...[
            SizedBox(height: 1.h),
            Text(
              _error!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
          SizedBox(height: 2.h),

          // Narration progress
          SliderTheme(
            data: theme.sliderTheme,
            child: Slider(
              value: _progress,
              min: 0.0,
              max: 1.0,
              onChangeStart: (_) {
                setState(() {
                  _isScrubbing = true;
                });
              },
              onChanged: (value) {
                setState(() => _progress = value);
              },
              onChangeEnd: (value) {
                _seekTo(value);
              },
            ),
          ),

          // Time labels
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(currentSeconds),
                  style: theme.textTheme.labelSmall,
                ),
                Text(
                  _formatDuration(totalSeconds.toDouble()),
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Volume control
              CustomIconWidget(
                iconName: _volume > 0 ? 'volume_up' : 'volume_off',
                color: theme.colorScheme.onSurface,
                size: 24,
              ),
              SizedBox(width: 2.w),
              SizedBox(
                width: 30.w,
                child: SliderTheme(
                  data: theme.sliderTheme,
                  child: Slider(
                    value: _volume,
                    min: 0.0,
                    max: 1.0,
                    onChanged: (value) {
                      setState(() {
                        _volume = value;
                      });
                      _tts.setVolume(value);
                    },
                  ),
                ),
              ),
              SizedBox(width: 4.w),

              // Restart button
              IconButton(
                icon: Icon(
                  Icons.restart_alt_rounded,
                  color: theme.colorScheme.onSurface,
                ),
                tooltip: 'Restart narration',
                onPressed: _isReady ? _restartNarration : null,
              ),

              // Play/Pause button
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.accentPink,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: CustomIconWidget(
                    iconName: _isPlaying ? 'pause' : 'play_arrow',
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: _isReady ? _togglePlayPause : null,
                ),
              ),
            ],
          ),
          SizedBox(height: 0.5.h),
          Text(
            _isPlaying
                ? 'Narrating in Indian accent'
                : (_isPaused ? 'Paused narration' : 'Ready to narrate'),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
