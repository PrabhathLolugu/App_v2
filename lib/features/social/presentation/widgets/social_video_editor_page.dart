import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myitihas/core/widgets/media/media_editor_scaffold.dart';
import 'package:myitihas/i18n/strings.g.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:video_player/video_player.dart';
import 'package:video_trimmer/video_trimmer.dart';

/// Max duration for post videos (seconds).
const int kPostVideoMaxDurationSeconds = 30;

/// Result of editing a video for a post (trim, speed, overlay, etc.).
class SocialVideoEditorResult {
  const SocialVideoEditorResult({
    required this.file,
    required this.durationSeconds,
    this.overlayText,
    this.startSeconds,
    this.endSeconds,
    this.playbackSpeed = 1.0,
    this.coverPath,
  });

  final File file;
  final int durationSeconds;
  final String? overlayText;
  final double? startSeconds;
  final double? endSeconds;
  final double playbackSpeed;
  final String? coverPath;
}

/// Full-screen professional video editor (Reels/TikTok-style).
/// Custom trim (any length up to 30s), optional caption. Exports via video_trimmer.
class SocialVideoEditorPage extends StatefulWidget {
  const SocialVideoEditorPage({
    super.key,
    required this.videoFile,
  });

  final File videoFile;

  static Future<SocialVideoEditorResult?> open(
    BuildContext context,
    File videoFile,
  ) async {
    return Navigator.of(context).push<SocialVideoEditorResult>(
      MaterialPageRoute<SocialVideoEditorResult>(
        builder: (context) => SocialVideoEditorPage(videoFile: videoFile),
      ),
    );
  }

  @override
  State<SocialVideoEditorPage> createState() => _SocialVideoEditorPageState();
}

class _SocialVideoEditorPageState extends State<SocialVideoEditorPage> {
  VideoPlayerController? _controller;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;
  double _totalSeconds = 0;
  double _currentPositionSeconds = 0;

  /// Trim range 0..1 (start, end).
  double _startNorm = 0;
  double _endNorm = 1;
  final TextEditingController _overlayTextController = TextEditingController();
  bool _isPlaying = false;

  double get _startSec => _startNorm * _totalSeconds;
  double get _endSec => _endNorm * _totalSeconds;
  double get _trimDurationSec =>
      (_endSec - _startSec).clamp(0.1, kPostVideoMaxDurationSeconds.toDouble());
  int get _durationSeconds => _trimDurationSec.round();

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  Future<void> _loadVideo() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      _controller = VideoPlayerController.file(widget.videoFile);
      await _controller!.initialize();
      if (!mounted) return;
      _totalSeconds =
          _controller!.value.duration.inMilliseconds / 1000.0;
      if (_totalSeconds > kPostVideoMaxDurationSeconds) {
        _endNorm = (kPostVideoMaxDurationSeconds / _totalSeconds).clamp(0.0, 1.0);
      }
      setState(() => _isLoading = false);
      _controller!.addListener(_onPositionUpdate);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = t.social.createPost.failedTrim;
        });
      }
    }
  }

  void _onPositionUpdate() {
    if (!mounted || _controller == null) return;
    final pos = _controller!.value.position.inMilliseconds / 1000.0;
    if (_currentPositionSeconds != pos) {
      setState(() {
        _currentPositionSeconds = pos.clamp(0, _totalSeconds);
      });
    }
    if (_isPlaying && pos >= _endSec - 0.1) {
      _controller!.pause();
      _controller!.seekTo(Duration(milliseconds: (_startSec * 1000).round()));
      setState(() => _isPlaying = false);
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onPositionUpdate);
    _controller?.dispose();
    _overlayTextController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller == null) return;
    if (_controller!.value.isPlaying) {
      _controller!.pause();
      setState(() => _isPlaying = false);
    } else {
      // If we're past the selected trim end, restart from trim start.
      final currentPosSec =
          _controller!.value.position.inMilliseconds / 1000.0;
      final startMillis = (_startSec * 1000).round();
      if (currentPosSec >= _endSec - 0.05 || currentPosSec < _startSec) {
        _controller!.seekTo(Duration(milliseconds: startMillis));
        _currentPositionSeconds = _startSec;
      }
      _controller!.play();
      setState(() => _isPlaying = true);
    }
  }

  void _enforceMaxSpan() {
    final maxSec = kPostVideoMaxDurationSeconds.toDouble();
    if (_totalSeconds <= 0) return;
    double start = _startNorm * _totalSeconds;
    double end = _endNorm * _totalSeconds;
    if (end < start) {
      final t = start;
      start = end;
      end = t;
    }
    if (end - start > maxSec) end = start + maxSec;
    if (end > _totalSeconds) end = _totalSeconds;
    if (start < 0) start = 0;
    setState(() {
      _startNorm = start / _totalSeconds;
      _endNorm = end / _totalSeconds;
    });
  }

  Future<File?> _exportVideo() async {
    final trimmer = Trimmer();
    try {
      await trimmer.loadVideo(videoFile: widget.videoFile);
      final completer = Completer<String?>();
      trimmer.saveTrimmedVideo(
        startValue: _startSec,
        endValue: _endSec,
        onSave: (path) {
          if (!completer.isCompleted) completer.complete(path);
        },
      );
      final path = await completer.future;
      if (path == null || path.isEmpty) return null;
      final source = File(path);
      if (!source.existsSync()) return null;
      const int kMaxUploadBytes = 52428800;
      if (await source.length() > kMaxUploadBytes) return null;
      final dir = await getTemporaryDirectory();
      final outPath = p.join(
        dir.path,
        'post_edited_${DateTime.now().millisecondsSinceEpoch}.mp4',
      );
      final outFile = File(outPath);
      await outFile.writeAsBytes(await source.readAsBytes());
      return outFile;
    } finally {
      trimmer.dispose();
    }
  }

  Future<void> _confirmEdit() async {
    if (_durationSeconds < 1) return;
    HapticFeedback.mediumImpact();
    setState(() => _isSaving = true);
    File? outFile;
    try {
      outFile = await _exportVideo();
    } catch (_) {
      outFile = null;
    }
    if (!mounted) return;
    setState(() => _isSaving = false);
    if (outFile != null) {
      Navigator.of(context).pop(
        SocialVideoEditorResult(
          file: outFile,
          durationSeconds: _durationSeconds,
          overlayText: _overlayTextController.text.trim().isEmpty
              ? null
              : _overlayTextController.text.trim(),
          startSeconds: _startSec,
          endSeconds: _endSec,
          playbackSpeed: 1.0,
        ),
      );
    } else {
      setState(() => _errorMessage = t.social.createPost.failedTrim);
    }
  }

  String _formatSec(double s) {
    final m = (s ~/ 60).remainder(60);
    final sec = (s % 60).round();
    return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_isLoading) {
      return MediaEditorScaffold(
        title: t.social.createPost.editVideo,
        subtitle: t.social.createPost.trimmingVideo,
        onClose: () => Navigator.of(context).pop(),
        isSaving: true,
        body: Center(
          child: CircularProgressIndicator(color: colorScheme.onSurface),
        ),
        bottomBar: const SizedBox.shrink(),
      );
    }

    if (_errorMessage != null) {
      return MediaEditorScaffold(
        title: t.social.createPost.editVideo,
        subtitle: t.social.createPost.failedTrim,
        onClose: () => Navigator.of(context).pop(),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 48.sp,
                  color: colorScheme.error,
                ),
                SizedBox(height: 16.h),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomBar: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => setState(() => _errorMessage = null),
              child: Text(t.common.retry),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(t.common.ok),
            ),
          ],
        ),
      );
    }

    return MediaEditorScaffold(
      title: t.social.createPost.editVideo,
      subtitle: '${t.social.createPost.maxDuration} · ${t.social.createPost.videoEditOptions}',
      onClose: () => Navigator.of(context).pop(),
      onDone: _confirmEdit,
      isSaving: _isSaving,
      isDoneEnabled: _durationSeconds >= 1 && !_isSaving,
      body: Container(
        color: Colors.black,
        child: Center(
          child: AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: GestureDetector(
              onTap: _togglePlayPause,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  VideoPlayer(_controller!),
                  if (!_isPlaying)
                    Icon(
                      Icons.play_circle_filled_rounded,
                      size: 72.sp,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomBar: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_formatSec(_startSec)} – ${_formatSec(_endSec)} · ${_durationSeconds}s',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${_formatSec(_currentPositionSeconds)} / ${_formatSec(_totalSeconds)}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4.h,
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: 8.r,
                ),
                overlayShape: RoundSliderOverlayShape(
                  overlayRadius: 16.r,
                ),
                activeTrackColor: colorScheme.primary,
                inactiveTrackColor:
                    colorScheme.onSurfaceVariant.withValues(alpha: 0.25),
              ),
              child: RangeSlider(
                values: RangeValues(_startNorm, _endNorm),
                min: 0,
                max: 1,
                divisions: (_totalSeconds * 10).round().clamp(10, 300),
                labels: RangeLabels(
                  _formatSec(_startSec),
                  _formatSec(_endSec),
                ),
                onChanged: (v) {
                  setState(() {
                    _startNorm = v.start;
                    _endNorm = v.end;
                    _enforceMaxSpan();
                  });
                },
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                IconButton.filled(
                  onPressed: _togglePlayPause,
                  icon: Icon(
                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            TextField(
              controller: _overlayTextController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: t.social.createPost.videoEditorCaptionLabel,
                hintText: t.social.createPost.videoEditorCaptionHint,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _confirmEdit(),
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
