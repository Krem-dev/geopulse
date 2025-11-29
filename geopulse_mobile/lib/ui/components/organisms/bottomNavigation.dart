import 'package:flutter/material.dart';
import '../../../core/theme/appColors.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavItem> items;

  const CustomBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.gray900 : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.gray800 : AppColors.gray200,
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        items: items.map((item) => item.toBottomNavBarItem()).toList(),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: isDark ? AppColors.gray600 : AppColors.gray500,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
        elevation: 0,
        iconSize: 24,
      ),
    );
  }
}

class BottomNavItem {
  final IconData icon;
  final String label;
  final IconData? activeIcon;

  BottomNavItem({
    required this.icon,
    required this.label,
    this.activeIcon,
  });

  BottomNavigationBarItem toBottomNavBarItem() {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      activeIcon: activeIcon != null ? Icon(activeIcon) : null,
      label: label,
    );
  }
}
