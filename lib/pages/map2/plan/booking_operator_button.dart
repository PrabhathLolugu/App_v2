import 'package:flutter/material.dart';
import 'package:myitihas/pages/map2/plan/booking_operator.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

/// A button widget for a single booking operator (e.g., IRCTC, MMT)
/// Shows operator name with green styling and opens deep link on tap
class BookingOperatorButton extends StatefulWidget {
  const BookingOperatorButton({
    super.key,
    required this.operator,
    this.onTap,
    this.fromLocation,
    this.toLocation,
    this.departDate,
    this.returnDate,
    this.compact = false,
  });

  final BookingOperator operator;
  final VoidCallback? onTap;
  final String? fromLocation;
  final String? toLocation;
  final String? departDate;
  final String? returnDate;
  final bool compact;

  @override
  State<BookingOperatorButton> createState() => _BookingOperatorButtonState();
}

class _BookingOperatorButtonState extends State<BookingOperatorButton> {
  bool _isLoading = false;

  Future<void> _openBooking() async {
    widget.onTap?.call();
    
    setState(() => _isLoading = true);

    try {
      final deepLink = widget.operator.generateDeepLink(
        from: widget.fromLocation,
        to: widget.toLocation,
        date: widget.departDate,
        returnDate: widget.returnDate,
      );

      final uri = Uri.parse(deepLink);

      // Android 11+ can report false in canLaunchUrl if package visibility is restricted.
      // Try launch directly first, then fall back to platform default mode.
      bool didLaunch = false;
      final canLaunch = await canLaunchUrl(uri);
      debugPrint(
        'Booking launch check for ${widget.operator.name}: canLaunch=$canLaunch, uri=$uri',
      );

      didLaunch = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!didLaunch) {
        didLaunch = await launchUrl(uri, mode: LaunchMode.platformDefault);
      }

      if (!didLaunch && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open ${widget.operator.name}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint('Booking launch error for ${widget.operator.name}: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening ${widget.operator.name}: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Green accent color for verified operators
    const greenAccent = Color(0xFF4CAF50);
    const greenLight = Color(0xFFE8F5E9);

    if (widget.compact) {
      return Tooltip(
        message: widget.operator.name,
        child: GestureDetector(
          onTap: _isLoading ? null : _openBooking,
          child: Container(
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              color: greenLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: greenAccent, width: 1.5),
            ),
            child: _isLoading
                ? SizedBox(
                    width: 20.sp,
                    height: 20.sp,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(greenAccent),
                    ),
                  )
                : Icon(
                    widget.operator.icon,
                    color: greenAccent,
                    size: 20.sp,
                  ),
          ),
        ),
      );
    }

    // Full button style
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _isLoading ? null : _openBooking,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 8.sp),
          decoration: BoxDecoration(
            color: greenLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: greenAccent, width: 1.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isLoading)
                SizedBox(
                  width: 16.sp,
                  height: 16.sp,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(greenAccent),
                  ),
                )
              else
                Icon(
                  widget.operator.icon,
                  color: greenAccent,
                  size: 18.sp,
                ),
              SizedBox(width: 8.sp),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.operator.name,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: greenAccent,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.operator.description != null) ...[
                      SizedBox(height: 2.sp),
                      Text(
                        widget.operator.description!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: greenAccent.withValues(alpha: 0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
