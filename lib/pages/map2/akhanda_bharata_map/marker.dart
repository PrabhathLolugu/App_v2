import 'package:flutter/material.dart';

class OmMarkerWidget extends StatelessWidget {
  final Color borderColor;
  final Color iconColor;

  const OmMarkerWidget({
    super.key,
    required this.borderColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: borderColor, width: 3),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.self_improvement, // replace with Om SVG if needed
          size: 36,
          color: iconColor,
        ),
      ),
    );
  }
}
