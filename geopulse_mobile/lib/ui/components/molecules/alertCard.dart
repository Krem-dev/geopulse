import 'package:flutter/material.dart';
import '../../../core/theme/appColors.dart';
import '../../../core/theme/appSpacing.dart';
import '../../../core/theme/appTypography.dart';

class AlertCard extends StatelessWidget {
  final String alertType;
  final String message;
  final String location;
  final String timeAgo;
  final Color borderColor;
  final IconData icon;
  final bool isUnread;
  final VoidCallback onTap;

  const AlertCard({
    Key? key,
    required this.alertType,
    required this.message,
    required this.location,
    required this.timeAgo,
    required this.borderColor,
    required this.icon,
    this.isUnread = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isUnread
              ? (isDark ? AppColors.gray800 : Colors.white)
              : (isDark ? AppColors.gray900 : AppColors.gray50),
          border: Border(
            left: BorderSide(color: borderColor, width: 4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: borderColor, size: 24),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          alertType,
                          style: AppTypography.titleMedium.copyWith(
                            color: borderColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    message,
                    style: AppTypography.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: AppColors.gray600),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        '$location • $timeAgo',
                        style: AppTypography.captionLarge,
                      ),
                    ],
                  ),
                ],
              ),
              if (isUnread)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
