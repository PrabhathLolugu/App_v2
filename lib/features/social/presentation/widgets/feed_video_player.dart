import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myitihas/core/widgets/image_loading_placeholder/image_loading_placeholder.dart';
import 'package:video_player/video_player.dart';

class FeedVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String? thumbnailUrl;
  final bool isVisible;
  final bool startMuted;
  final bool showPersistentMuteBadge;
  final VoidCallback? onDoubleTap;
  final void Function(bool visible)? onControlsVisibilityChanged;

  const FeedVideoPlayer({
    super.key,
    required this.videoUrl,
    this.thumbnailUrl,
    this.isVisible = true,
    this.startMuted = false,
    this.showPersistentMuteBadge = false,
    this.onDoubleTap,
    this.onControlsVisibilityChanged,
  });

  @override
  State<FeedVideoPlayer> createState() => _FeedVideoPlayerState();
}

class _FeedVideoPlayerState extends State<FeedVideoPlayer>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _showControls = false;
  bool _isMuted = false;
  bool _hasError = false;
  Timer? _hideControlsTimer;
  Timer? _pendingTapTimer;
  DateTime? _pointerDownTime;
  DateTime? _lastTapUpTime;
  bool _showLikeAnimation = false;
  bool _wasPlayingBeforeHold = false;
  bool? _lastPlayingState;
  bool? _lastBufferingState;
  bool? _lastErrorState;
  static const _doubleTapWindow = Duration(milliseconds: 280);
  static const _maxTapDuration = Duration(milliseconds: 350);

  late AnimationController _likeAnimationController;
  late Animation<double> _likeScaleAnimation;
  late Animation<double> _likeFadeAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _isMuted = widget.startMuted;
    _initializeAnimations();
    _initializePlayer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onControlsVisibilityChanged?.call(_showControls);
    });
  }

  void _initializeAnimations() {
    _likeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _likeScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.2,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_likeAnimationController);

    _likeFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _likeAnimationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  Future<void> _initializePlayer() async {
    if (widget.videoUrl.isEmpty) {
      setState(() => _hasError = true);
      return;
    }

    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );

      await _controller!.initialize();
      _controller!.setLooping(true);
      _controller!.setVolume(_isMuted ? 0.0 : 1.0);

      _controller!.addListener(_onPlayerStateChanged);

      if (mounted) {
        _lastPlayingState = false;
        setState(() => _isInitialized = true);

        if (widget.isVisible) {
          _controller!.play();
          _lastPlayingState = true;
          _startHideControlsTimer();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _hasError = true);
      }
    }
  }

  void _onPlayerStateChanged() {
    if (!mounted || _controller == null) return;
    final value = _controller!.value;
    final playing = value.isPlaying;
    final buffering = value.isBuffering;
    final hasError = value.hasError;

    final shouldRebuild =
        (_lastPlayingState != playing) ||
        (_lastBufferingState != buffering) ||
        (_lastErrorState != hasError);

    if (!shouldRebuild) return;

    _lastPlayingState = playing;
    _lastBufferingState = buffering;
    _lastErrorState = hasError;

    if (hasError) {
      _hasError = true;
    }

    if (!playing) _cancelHideControlsTimer();
    setState(() {});
  }

  @override
  void didUpdateWidget(FeedVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_controller != null) {
      if (!widget.isVisible) {
        _controller!.pause();
        _lastPlayingState = false;
        _cancelHideControlsTimer();
        _cancelPendingTap();
      } else if (widget.isVisible != oldWidget.isVisible) {
        _controller!.play();
        _lastPlayingState = true;
        _startHideControlsTimer();
      }
    }

    if (widget.videoUrl != oldWidget.videoUrl) {
      _disposeController();
      _hasError = false;
      _showControls = false;
      _initializePlayer();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null) return;
    switch (state) {
      case AppLifecycleState.resumed:
        if (widget.isVisible && _isInitialized) {
          _controller!.play();
          _lastPlayingState = true;
          _startHideControlsTimer();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _controller!.pause();
        _lastPlayingState = false;
        _cancelHideControlsTimer();
        _cancelPendingTap();
        break;
    }
  }

  @override
  void deactivate() {
    _controller?.pause();
    _lastPlayingState = false;
    _cancelHideControlsTimer();
    _cancelPendingTap();
    super.deactivate();
  }

  @override
  void activate() {
    super.activate();
    if (_controller != null && _isInitialized && widget.isVisible) {
      _controller!.play();
      _lastPlayingState = true;
      _startHideControlsTimer();
    }
  }

  void _disposeController() {
    _controller?.removeListener(_onPlayerStateChanged);
    _controller?.dispose();
    _controller = null;
    _isInitialized = false;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cancelHideControlsTimer();
    _cancelPendingTap();
    _likeAnimationController.dispose();
    _disposeController();
    super.dispose();
  }

  void _cancelPendingTap() {
    _pendingTapTimer?.cancel();
    _pendingTapTimer = null;
  }

  void _togglePlayPause() {
    if (_controller == null || !widget.isVisible) return;

    HapticFeedback.selectionClick();
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        _cancelHideControlsTimer();
      } else {
        _controller!.play();
        _startHideControlsTimer();
      }
    });
  }

  void _toggleMute() {
    if (_controller == null) return;

    HapticFeedback.selectionClick();
    setState(() {
      _isMuted = !_isMuted;
      _controller!.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  void _showControlsTemporarily() {
    setState(() => _showControls = true);
    widget.onControlsVisibilityChanged?.call(true);
    // Only auto-hide controls when video is playing; when paused keep controls visible
    if (_controller?.value.isPlaying ?? false) {
      _startHideControlsTimer();
    }
  }

  void _startHideControlsTimer() {
    _cancelHideControlsTimer();
    if (_controller?.value.isPlaying ?? false) {
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        if (mounted && (_controller?.value.isPlaying ?? false)) {
          setState(() {
            _showControls = false;
          });
          widget.onControlsVisibilityChanged?.call(false);
        }
      });
    }
  }

  void _cancelHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = null;
  }

  void _onPointerDown(PointerDownEvent event) {
    _pointerDownTime = DateTime.now();
  }

  void _onPointerUp(PointerUpEvent event) {
    // When playback controls are visible, we let their dedicated tap handlers
    // (like the central play/pause button) manage taps to avoid double toggling.
    if (_showControls) {
      _pointerDownTime = null;
      return;
    }

    final down = _pointerDownTime;
    _pointerDownTime = null;
    if (down == null || _controller == null) return;
    final pressDuration = DateTime.now().difference(down);
    if (pressDuration > _maxTapDuration) return;

    final now = DateTime.now();
    final isSecondTap =
        _lastTapUpTime != null &&
        now.difference(_lastTapUpTime!) < _doubleTapWindow;

    _lastTapUpTime = now;

    if (isSecondTap) {
      _cancelPendingTap();
      _togglePlayPause();
      _handleDoubleTap();
    } else {
      _togglePlayPause();
      _showControlsTemporarily();
      _pendingTapTimer = Timer(_doubleTapWindow, () {
        _pendingTapTimer = null;
      });
    }
  }

  void _handleDoubleTap() {
    HapticFeedback.mediumImpact();
    widget.onDoubleTap?.call();

    setState(() => _showLikeAnimation = true);
    _likeAnimationController.forward(from: 0.0).then((_) {
      if (mounted) {
        setState(() => _showLikeAnimation = false);
      }
    });
  }

  void _handleLongPressStart(LongPressStartDetails details) {
    if (_controller == null) return;
    _wasPlayingBeforeHold = _controller!.value.isPlaying;
    if (_wasPlayingBeforeHold) {
      _cancelHideControlsTimer();
      _controller!.pause();
      HapticFeedback.lightImpact();
      if (mounted) {
        setState(() => _showControls = true);
        widget.onControlsVisibilityChanged?.call(true);
      }
    }
  }

  void _handleLongPressEnd(LongPressEndDetails details) {
    if (_controller == null) return;
    if (_wasPlayingBeforeHold && widget.isVisible) {
      _controller!.play();
      _startHideControlsTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTabletUp = MediaQuery.sizeOf(context).width >= 600;
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      behavior: HitTestBehavior.opaque,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPressStart: _handleLongPressStart,
        onLongPressEnd: _handleLongPressEnd,
        child: Container(
          color: Colors.black,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildVideoContent(),

              if (_isInitialized && _controller!.value.isBuffering)
                _buildBufferingIndicator(),

              if (_showControls && _isInitialized) _buildControlsOverlay(),

              if (_showControls && _isInitialized)
                Positioned(
                  top: isTabletUp ? 90.0 : 100.h,
                  right: isTabletUp ? 20.0 : 16.w,
                  child: _buildMuteButton(),
                ),

              if (widget.showPersistentMuteBadge && _isInitialized)
                Positioned(
                  top: isTabletUp ? 10.0 : 6.h,
                  right: isTabletUp ? 16.0 : 5.w,
                  child: _buildPersistentMuteBadge(),
                ),

              if (_isInitialized)
                if (_showLikeAnimation) _buildLikeAnimation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoContent() {
    if (_hasError) {
      return _buildErrorState();
    }

    if (!_isInitialized) {
      return _buildLoadingState();
    }

    return Center(
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: _controller!.value.size.width,
          height: _controller!.value.size.height,
          child: VideoPlayer(_controller!),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (widget.thumbnailUrl != null && widget.thumbnailUrl!.isNotEmpty)
            Image.network(
              widget.thumbnailUrl!,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const ImageLoadingPlaceholder();
              },
              errorBuilder: (_, _, _) => Container(color: Colors.grey[900]),
            ),
          Center(
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
              child: CircularProgressIndicator(
                color: colorScheme.onSurface,
                strokeWidth: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: Colors.grey[900],
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: colorScheme.error),
            SizedBox(height: 12.h),
            Text(
              'Failed to load video',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBufferingIndicator() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          shape: BoxShape.circle,
        ),
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
      ),
    );
  }

  Widget _buildControlsOverlay() {
    final isPlaying = _controller?.value.isPlaying ?? false;

    return AnimatedOpacity(
      opacity: _showControls ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.35),
              Colors.transparent,
              Colors.black.withValues(alpha: 0.5),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              _togglePlayPause();
              _showControlsTemporarily();
            },
            child: AnimatedScale(
              scale: _showControls ? 1.0 : 0.92,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(
                        begin: 0.9,
                        end: 1.0,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  key: ValueKey<bool>(isPlaying),
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 50.sp,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMuteButton() {
    return GestureDetector(
      onTap: _toggleMute,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Icon(
          _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
          color: Colors.white,
          size: 22.sp,
        ),
      ),
    );
  }

  Widget _buildLikeAnimation() {
    return Center(
      child: AnimatedBuilder(
        animation: _likeAnimationController,
        builder: (context, child) {
          return Opacity(
            opacity: _likeFadeAnimation.value,
            child: Transform.scale(
              scale: _likeScaleAnimation.value,
              child: Icon(Icons.favorite, color: Colors.red, size: 120.sp),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPersistentMuteBadge() {
    return GestureDetector(
      onTap: _toggleMute,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
              color: Colors.white,
              size: 16.sp,
            ),
            SizedBox(width: 5.w),
            Text(
              _isMuted ? 'Muted' : 'Sound on',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
