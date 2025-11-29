import 'package:flutter/material.dart';
import '../../../core/theme/appColors.dart';
import '../../../core/theme/appSpacing.dart';
import '../../../core/theme/appTypography.dart';

class LocationCard extends StatelessWidget {
  final String locationName;
  final String address;
  final String? distance;
  final bool isSelected;
  final VoidCallback onTap;
  final String? nickname;
  final bool isCurrentLocation;

  const LocationCard({
    Key? key,
    required this.locationName,
    required this.address,
    this.distance,
    required this.isSelected,
    required this.onTap,
    this.nickname,
    this.isCurrentLocation = false,
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
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.gray300,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? (isDark ? AppColors.gray900 : AppColors.primary.withOpacity(0.05))
              : (isDark ? AppColors.gray800 : Colors.white),
        ),
        child: Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: isSelected,
              onChanged: (_) => onTap(),
              activeColor: AppColors.primary,
            ),
            SizedBox(width: AppSpacing.md),
            Icon(
              isCurrentLocation ? Icons.my_location : Icons.location_on,
              color: AppColors.primary,
              size: 20,
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locationName,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    address,
                    style: AppTypography.captionLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (distance != null) ...[
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      distance!,
                      style: AppTypography.captionLarge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
