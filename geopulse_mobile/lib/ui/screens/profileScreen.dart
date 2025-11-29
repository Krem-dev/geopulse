import 'package:flutter/material.dart';
import '../../core/theme/appColors.dart';
import '../../core/theme/appSpacing.dart';
import '../../core/theme/appTypography.dart';
import '../components/organisms/customAppBar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.neutralDark : AppColors.gray50,
      appBar: CustomAppBar(
        title: 'Profile',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: isDark ? AppColors.gray900 : Colors.white,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  Text(
                    'Guest User',
                    style: AppTypography.headlineMedium.copyWith(
                      color: isDark ? Colors.white : AppColors.gray900,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'Brooklyn, NY',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.gray600,
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStat('12', 'Saved', isDark),
                      _buildStat('45', 'Read', isDark),
                      _buildStat('3', 'Locations', isDark),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            _buildSection(
              title: 'Quick Actions',
              items: [
                _buildMenuItem(
                  icon: Icons.location_on_outlined,
                  title: 'Saved Locations',
                  onTap: () {},
                  isDark: isDark,
                ),
                _buildMenuItem(
                  icon: Icons.bookmark_outline,
                  title: 'Bookmarks',
                  onTap: () => Navigator.pushNamed(context, '/saved'),
                  isDark: isDark,
                ),
              ],
              isDark: isDark,
            ),
            SizedBox(height: AppSpacing.lg),
            _buildSection(
              title: 'Settings',
              items: [
                _buildMenuItem(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  trailing: Switch(
                    value: isDark,
                    onChanged: (value) {},
                    activeColor: AppColors.primary,
                  ),
                  isDark: isDark,
                ),
              ],
              isDark: isDark,
            ),
            SizedBox(height: AppSpacing.lg),
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.gray600,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/signup'),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.lg),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.gray900,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.gray600,
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> items,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.gray900 : Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.gray600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    required bool isDark,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDark ? AppColors.gray400 : AppColors.gray700,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : AppColors.gray900,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.gray600,
              ),
            )
          : null,
      trailing: trailing ?? Icon(Icons.chevron_right, color: AppColors.gray400),
      onTap: onTap,
    );
  }
}
