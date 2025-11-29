import 'package:flutter/material.dart';
import '../../../core/theme/appColors.dart';
import '../../../core/theme/appSpacing.dart';
import '../../../core/theme/appTypography.dart';
import '../atoms/primaryButton.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;
  final Color? iconColor;

  const EmptyState({
    Key? key,
    required this.icon,
    required this.title,
    required this.message,
    this.buttonLabel,
    this.onButtonPressed,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: (iconColor ?? AppColors.gray400).withOpacity(0.4),
            ),
            SizedBox(height: AppSpacing.xl),
            Text(
              title,
              style: AppTypography.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.gray600,
              ),
              textAlign: TextAlign.center,
            ),
            if (buttonLabel != null && onButtonPressed != null) ...[
              SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: buttonLabel!,
                onPressed: onButtonPressed!,
                width: 200,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ErrorState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;
  final IconData icon;

  const ErrorState({
    Key? key,
    this.title = 'Something Went Wrong',
    this.message = 'Please try again later',
    required this.onRetry,
    this.icon = Icons.error_outline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: icon,
      title: title,
      message: message,
      buttonLabel: 'Retry',
      onButtonPressed: onRetry,
      iconColor: AppColors.error,
    );
  }
}
