import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myitihas/core/presentation/bloc/connectivity_bloc.dart';
import 'package:myitihas/core/presentation/bloc/connectivity_state.dart';

/// An icon button that automatically disables when offline and shows a helpful message.
///
/// When offline, the icon appears greyscale with reduced opacity.
/// Tapping it will show a SnackBar explaining why it's unavailable.
///
/// Ideal for action icons like like, comment, share, etc.
///
/// Example usage:
/// ```dart
/// OfflineAwareIconButton(
///   onPressed: () => context.read<PostBloc>().add(LikePost()),
///   icon: Icon(Icons.favorite),
///   color: Colors.red,
/// )
/// ```
class OfflineAwareIconButton extends StatelessWidget {
  /// Callback when button is pressed (only works when online)
  final VoidCallback? onPressed;

  /// The icon widget to display
  final Widget icon;

  /// Message shown in SnackBar when tapped while offline
  final String offlineMessage;

  /// Optional icon color (becomes grey when offline)
  final Color? color;

  /// Optional icon size
  final double? iconSize;

  const OfflineAwareIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.offlineMessage = 'Offline mode',
    this.color,
    this.iconSize,
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

        return IconButton(
          onPressed: isOnline
              ? onPressed
              : (onPressed != null ? () => _showOfflineSnackBar(context) : null),
          icon: Opacity(
            opacity: isOnline ? 1.0 : 0.5,
            child: icon,
          ),
          color: isOnline ? color : Colors.grey,
          iconSize: iconSize,
        );
      },
    );
  }
}
