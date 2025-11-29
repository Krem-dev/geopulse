import 'package:flutter/material.dart';
import '../../../core/theme/appSpacing.dart';

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isEnabled;
  final double? width;
  final IconData? icon;

  const SecondaryButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isEnabled = true,
    this.width,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 48,
      child: OutlinedButton(
        onPressed: isEnabled ? onPressed : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              SizedBox(width: AppSpacing.sm),
            ],
            Text(label),
          ],
        ),
      ),
    );
  }
}
