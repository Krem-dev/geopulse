import 'package:flutter/material.dart';
import '../../../core/theme/appColors.dart';
import '../../../core/theme/appSpacing.dart';
import '../../../core/theme/appTypography.dart';

class NewsCard extends StatelessWidget {
  final String headline;
  final String source;
  final String timeAgo;
  final String distance;
  final String category;
  final Color categoryColor;
  final String? imageUrl;
  final VoidCallback onTap;

  const NewsCard({
    Key? key,
    required this.headline,
    required this.source,
    required this.timeAgo,
    required this.distance,
    required this.category,
    required this.categoryColor,
    this.imageUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isDark ? AppColors.gray800 : AppColors.gray200,
                width: 1,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        category.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: categoryColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      headline,
                      style: AppTypography.bodyMedium.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                        color: isDark ? Colors.white : AppColors.gray900,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Text(
                          source,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.gray500 : AppColors.gray600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.gray600 : AppColors.gray400,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Text(
                          timeAgo,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.gray500 : AppColors.gray600,
                          ),
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.gray600 : AppColors.gray400,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 2),
                        Text(
                          distance,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.md),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.gray800 : AppColors.gray100,
                  ),
                  child: Image.network(
                    'https://picsum.photos/200/200?random=$hashCode',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholder(isDark),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(bool isDark) {
    return Center(
      child: Icon(
        Icons.image_outlined,
        size: 32,
        color: isDark ? AppColors.gray700 : AppColors.gray300,
      ),
    );
  }
}
