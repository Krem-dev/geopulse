import 'package:flutter/material.dart';
import '../../../core/theme/appColors.dart';

class IconButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final double size;
  final bool isEnabled;
  final String? tooltip;

  const IconButtonWidget({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.size = 24,
    this.isEnabled = true,
    this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: size, color: color ?? AppColors.primary),
      onPressed: isEnabled ? onPressed : null,
      tooltip: tooltip,
      constraints: BoxConstraints(minWidth: 48, minHeight: 48),
      padding: EdgeInsets.zero,
    );
  }
}
