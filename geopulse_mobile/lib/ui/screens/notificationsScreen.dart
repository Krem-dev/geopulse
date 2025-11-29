import 'package:flutter/material.dart';
import '../../core/theme/appColors.dart';
import '../../core/theme/appSpacing.dart';
import '../../core/theme/appTypography.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.neutralDark : AppColors.gray50,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.neutralDark : Colors.white,
        elevation: 0,
        title: Text(
          'Notifications',
          style: AppTypography.headlineMedium.copyWith(
            fontSize: 20,
            color: isDark ? Colors.white : AppColors.gray900,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : AppColors.gray900),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Mark all read'),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.md),
        children: [
          _buildSectionHeader('Today', isDark),
          _buildNotificationItem(
            title: 'Heavy Rain Alert',
            body: 'Severe thunderstorm warning for your area until 8:00 PM.',
            time: '10 min ago',
            type: 'alert',
            isUnread: true,
            isDark: isDark,
          ),
          _buildNotificationItem(
            title: 'New Restaurant Opening',
            body: 'The "Green Garden" just opened 0.5km from you.',
            time: '2 hours ago',
            type: 'local',
            isUnread: true,
            isDark: isDark,
          ),
          
          SizedBox(height: AppSpacing.lg),
          _buildSectionHeader('Yesterday', isDark),
          _buildNotificationItem(
            title: 'Traffic Congestion Cleared',
            body: 'Traffic on Highway 101 has returned to normal speeds.',
            time: '1 day ago',
            type: 'traffic',
            isUnread: false,
            isDark: isDark,
          ),
          _buildNotificationItem(
            title: 'Weekend Event Guide',
            body: 'Check out the top 5 events happening near you this weekend.',
            time: '1 day ago',
            type: 'event',
            isUnread: false,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.xs),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.gray400 : AppColors.gray600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String body,
    required String time,
    required String type,
    required bool isUnread,
    required bool isDark,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isUnread
            ? (isDark ? AppColors.primary.withOpacity(0.1) : AppColors.primary.withOpacity(0.05))
            : (isDark ? AppColors.gray800 : Colors.white),
        borderRadius: BorderRadius.circular(12),
        border: isUnread
            ? Border.all(color: AppColors.primary.withOpacity(0.2))
            : null,
        boxShadow: isUnread ? [] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTypeIcon(type),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
                          color: isDark ? Colors.white : AppColors.gray900,
                        ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.gray300 : AppColors.gray700,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.gray500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeIcon(String type) {
    IconData icon;
    Color color;

    switch (type) {
      case 'alert':
        icon = Icons.warning_amber_rounded;
        color = AppColors.error;
        break;
      case 'traffic':
        icon = Icons.traffic_rounded;
        color = AppColors.warning;
        break;
      case 'local':
        icon = Icons.store_mall_directory_rounded;
        color = AppColors.success;
        break;
      case 'event':
        icon = Icons.event_rounded;
        color = AppColors.secondary;
        break;
      default:
        icon = Icons.notifications_rounded;
        color = AppColors.primary;
    }

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
