import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myitihas/core/presentation/bloc/connectivity_bloc.dart';
import 'package:myitihas/core/presentation/bloc/connectivity_state.dart';

/// A button that automatically disables when offline and shows a helpful message.
///
/// When offline, the button appears with greyscale styling and reduced opacity.
/// Tapping it will show a SnackBar explaining why it's unavailable.
///
/// Example usage:
/// ```dart
/// OfflineAwareButton(
///   onPressed: () => context.read<MyBloc>().add(MyEvent()),
///   child: Text('Submit'),
/// )
/// ```
class OfflineAwareButton extends StatelessWidget {
  /// Callback when button is pressed (only works when online)
  final VoidCallback? onPressed;

  /// The button's child widget (typically Text)
  final Widget child;

  /// Message shown in SnackBar when tapped while offline
  final String offlineMessage;

  /// Optional style customization (merged with offline styling when offline)
  final ButtonStyle? style;

  const OfflineAwareButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.offlineMessage = 'Not available offline',
    this.style,
  });

  void _showOfflineSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(offlineMessage),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (context, state) {
        final isOnline = state is ConnectivityOnline;

        // Merge offline styling with provided style
        ButtonStyle effectiveStyle = style ?? const ButtonStyle();

        if (!isOnline) {
          effectiveStyle = effectiveStyle.copyWith(
            backgroundColor: WidgetStateProperty.all(
              Colors.grey.withValues(alpha: 0.5),
            ),
            foregroundColor: WidgetStateProperty.all(
              Colors.grey.shade700,
            ),
          );
        }

        return ElevatedButton(
          onPressed: isOnline
              ? onPressed
              : (onPressed != null ? () => _showOfflineSnackBar(context) : null),
          style: effectiveStyle,
          child: Opacity(
            opacity: isOnline ? 1.0 : 0.5,
            child: child,
          ),
        );
      },
    );
  }
}
