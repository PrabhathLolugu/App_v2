import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ProfileBioWidget extends StatefulWidget {
  final String bio;

  const ProfileBioWidget({super.key, required this.bio});

  @override
  State<ProfileBioWidget> createState() => _ProfileBioWidgetState();
}

class _ProfileBioWidgetState extends State<ProfileBioWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bioLines = widget.bio.split('\n');
    final shouldShowExpand = bioLines.length > 3;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.bio,
            style: theme.textTheme.bodyLarge,
            maxLines: _isExpanded ? null : 3,
            overflow: _isExpanded
                ? TextOverflow.visible
                : TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          if (shouldShowExpand) ...[
            SizedBox(height: 0.5.h),
            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Text(
                _isExpanded ? 'Show less' : 'Show more',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
