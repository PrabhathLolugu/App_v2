import 'package:flutter/material.dart';
import 'package:myitihas/pages/map2/widgets/custom_icon_widget.dart';

/// Floating action button for creating new discussions
class FloatingComposeButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const FloatingComposeButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      elevation: 4.0,
      icon: CustomIconWidget(
        iconName: 'edit',
        color: theme.colorScheme.onPrimary,
        size: 24,
      ),
      label: Text(
        'New Discussion',
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
