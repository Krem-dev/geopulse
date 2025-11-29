import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF123876);
  static const primaryDark = Color(0xFF0D2454);
  static const primaryLight = Color(0xFF1E5BA8);

  static const secondary = Color(0xFF4A7BA7);
  static const secondaryDark = Color(0xFF2F5580);
  static const secondaryLight = Color(0xFF6B9FBF);

  static const accent = Color(0xFF0D7377);
  static const accentDark = Color(0xFF055A66);
  static const accentLight = Color(0xFF14A085);

  static const neutralDark = Color(0xFF1E1E1E);
  static const neutralLight = Color(0xFFFAFBFC);

  static const success = Color(0xFF34A853);
  static const warning = Color(0xFFFBBC04);
  static const error = Color(0xFFEA4335);

  static const gray900 = Color(0xFF212121);
  static const gray800 = Color(0xFF424242);
  static const gray700 = Color(0xFF616161);
  static const gray600 = Color(0xFF757575);
  static const gray500 = Color(0xFF9E9E9E);
  static const gray400 = Color(0xFFBDBDBD);
  static const gray300 = Color(0xFFE0E0E0);
  static const gray200 = Color(0xFFEEEEEE);
  static const gray100 = Color(0xFFF5F5F5);
  static const gray50 = Color(0xFFFAFAFA);
  
  static const white = Color(0xFFFFFFFF);
}

class AppColorsLight {
  static const background = Color(0xFFFAFBFC);
  static const surface = Colors.white;
  static const surfaceVariant = AppColors.gray100;
  static const primaryText = AppColors.neutralDark;
  static const secondaryText = AppColors.gray600;
  static const tertiaryText = AppColors.gray500;
  static const disabledText = AppColors.gray400;
  static const border = AppColors.gray300;
  static const divider = AppColors.gray200;
}

class AppColorsDark {
  static const background = Color(0xFF121212);
  static const surface = AppColors.neutralDark;
  static const surfaceVariant = Color(0xFF2C2C2C);
  static const primaryText = Color.fromARGB(242, 255, 255, 255);
  static const secondaryText = Color.fromARGB(179, 255, 255, 255);
  static const tertiaryText = Color.fromARGB(128, 255, 255, 255);
  static const disabledText = Color.fromARGB(77, 255, 255, 255);
  static const border = Color.fromARGB(31, 255, 255, 255);
  static const divider = Color.fromARGB(20, 255, 255, 255);
}
