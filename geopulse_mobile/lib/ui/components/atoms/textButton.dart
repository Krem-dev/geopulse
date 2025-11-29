import 'package:flutter/material.dart';
import '../../../core/theme/appColors.dart';

class TextButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isEnabled;
  final Color? color;

  const TextButtonWidget({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isEnabled = true,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isEnabled ? onPressed : null,
      child: Text(
        label,
        style: TextStyle(color: color ?? AppColors.primary),
      ),
    );
  }
}
