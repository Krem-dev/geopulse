import 'package:flutter/material.dart';
import '../../../core/theme/appColors.dart';
import '../../../core/theme/appSpacing.dart';
import '../atoms/iconButton.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool showBackButton;
  final Widget? centerWidget;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;

  const CustomAppBar({
    Key? key,
    this.title,
    this.onBackPressed,
    this.actions,
    this.showBackButton = true,
    this.centerWidget,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null ? Text(title!) : null,
      centerTitle: centerWidget != null,
      leading: showBackButton
          ? IconButtonWidget(
              icon: Icons.arrow_back,
              onPressed: onBackPressed ?? () => Navigator.pop(context),
              color: foregroundColor ?? Colors.white,
            )
          : null,
      actions: actions,
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor ?? Colors.white,
      elevation: elevation,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentLocation;
  final VoidCallback onLocationTap;
  final VoidCallback onNotificationTap;
  final int notificationCount;

  const HomeAppBar({
    Key? key,
    required this.currentLocation,
    required this.onLocationTap,
    required this.onNotificationTap,
    this.notificationCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.white.withOpacity(0.9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(Icons.public, size: 22, color: AppColors.primary),
          ),
          SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'GeoPulse',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                  height: 1.2,
                ),
              ),
              Text(
                'Local News',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  color: Colors.white.withOpacity(0.8),
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        GestureDetector(
          onTap: onLocationTap,
          child: Container(
            margin: EdgeInsets.only(right: AppSpacing.sm),
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.white),
                SizedBox(width: 4),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 100),
                  child: Text(
                    currentLocation,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.white),
              ],
            ),
          ),
        ),
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.notifications_none, size: 24),
              onPressed: onNotificationTap,
              color: Colors.white,
            ),
            if (notificationCount > 0)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.5),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  constraints: BoxConstraints(minWidth: 18, minHeight: 18),
                  child: Text(
                    notificationCount > 9 ? '9+' : '$notificationCount',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(width: AppSpacing.xs),
      ],
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}
