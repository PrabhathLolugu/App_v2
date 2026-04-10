import 'package:flutter/material.dart';
import 'package:myitihas/core/widgets/voice_input/voice_input_button.dart';
import 'package:sizer/sizer.dart';

class FormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String? prefixText;
  final int? maxLength;
  final int maxLines;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixWidget;
  final String? helperText;

  const FormFieldWidget({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.prefixText,
    this.maxLength,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.suffixWidget,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          maxLength: maxLength,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefixText,
            prefixStyle: theme.textTheme.bodyLarge,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                VoiceInputButton(
                  controller: controller,
                  compact: true,
                ),
                if (suffixWidget != null)
                  Padding(
                    padding: EdgeInsets.all(3.w),
                    child: suffixWidget,
                  ),
              ],
            ),
            counterText: maxLength != null
                ? '${controller.text.length}/$maxLength'
                : null,
            counterStyle: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            helperText: helperText,
            helperStyle: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ),
      ],
    );
  }
}
