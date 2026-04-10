import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedGreeting extends StatefulWidget {
  final String greeting;
  final String userName;

  const AnimatedGreeting({
    super.key,
    required this.greeting,
    required this.userName,
  });

  @override
  State<AnimatedGreeting> createState() => _AnimatedGreetingState();
}

class _AnimatedGreetingState extends State<AnimatedGreeting>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  
  String _currentText = "";
  bool _isNamaste = false;
  Timer? _typeTimer;
  Timer? _cycleTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _startCycle();
  }

  @override
  void didUpdateWidget(AnimatedGreeting oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.greeting != widget.greeting) {
      // If the time-based greeting changed (e.g. morning to afternoon), restart if currently showing it
      if (!_isNamaste) {
        _startCycle();
      }
    }
  }

  void _startCycle() {
    _typeTimer?.cancel();
    _cycleTimer?.cancel();
    _controller.forward();
    _typeText(_isNamaste ? "Namasthe" : widget.greeting);
  }

  void _typeText(String target) {
    _currentText = "";
    int index = 0;
    _typeTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (index < target.length) {
        setState(() {
          _currentText += target[index];
        });
        index++;
      } else {
        timer.cancel();
        // Pause for 3 seconds after finishing typing
        _cycleTimer = Timer(const Duration(seconds: 3), () {
          _flip();
        });
      }
    });
  }

  void _flip() async {
    await _controller.reverse();
    if (mounted) {
      setState(() {
        _isNamaste = !_isNamaste;
      });
      _controller.forward();
      _typeText(_isNamaste ? "Namasthe" : widget.greeting);
    }
  }

  @override
  void dispose() {
    _typeTimer?.cancel();
    _cycleTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeTransition(
          opacity: _opacityAnimation,
          child: Text(
            _currentText,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}
