import 'dart:async';

import 'package:flutter/material.dart';

/// PascalCase examples aligned with app hashtag rules (letters and numbers).
const List<String> kDiscussionHashtagExamples = [
  'Kuchipudi',
  'Bharatanatyam',
  'Pulihora',
  'Varanasi',
  'MysoreSilk',
  'Navaratri',
];

/// Text field with `#` prefix and a cycling, animated hint (e.g. Kuchipudi, …).
class CyclingHashtagHintTextField extends StatefulWidget {
  const CyclingHashtagHintTextField({
    super.key,
    required this.controller,
    required this.hintIntro,
    required this.hintOutro,
    this.errorText,
    this.suffixIcon,
    this.textInputAction,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hintIntro;
  final String hintOutro;
  final String? errorText;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;

  @override
  State<CyclingHashtagHintTextField> createState() =>
      _CyclingHashtagHintTextFieldState();
}

class _CyclingHashtagHintTextFieldState extends State<CyclingHashtagHintTextField> {
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _timer = Timer.periodic(const Duration(milliseconds: 2800), (_) {
      if (!mounted) return;
      setState(() {
        _index = (_index + 1) % kDiscussionHashtagExamples.length;
      });
    });
  }

  void _onTextChanged() => setState(() {});

  @override
  void dispose() {
    _timer?.cancel();
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hintStyle =
        theme.inputDecorationTheme.hintStyle ??
        theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.55),
        );

    final showAnimatedHint =
        widget.controller.text.isEmpty && widget.errorText == null;

    final example = kDiscussionHashtagExamples[_index];
    final hintLine = '${widget.hintIntro}$example${widget.hintOutro}';

    return Stack(
      alignment: Alignment.centerLeft,
      clipBehavior: Clip.none,
      children: [
        TextField(
          controller: widget.controller,
          textInputAction: widget.textInputAction,
          onSubmitted: widget.onSubmitted,
          decoration: InputDecoration(
            errorText: widget.errorText,
            suffixIcon: widget.suffixIcon,
            prefixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(start: 8, end: 2),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: 1,
                heightFactor: 1,
                child: Text(
                  '#',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 28,
              minHeight: 48,
            ),
          ),
        ),
        if (showAnimatedHint)
          Positioned.fill(
            child: IgnorePointer(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 36,
                  end: 52,
                ),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 420),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      final slide = Tween<Offset>(
                        begin: const Offset(0, 0.1),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        ),
                      );
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: slide,
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      hintLine,
                      key: ValueKey<int>(_index),
                      style: hintStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
