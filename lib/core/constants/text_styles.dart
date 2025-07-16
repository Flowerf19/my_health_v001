import 'package:flutter/material.dart';

import 'colors.dart';

class AppTextStyles {
  // Headings
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
    height: 1.2,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
    height: 1.3,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
    height: 1.4,
  );

  static const TextStyle heading4 = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
    height: 1.4,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
    height: 1.3,
  );

  // Button Text
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: 'Inter',
    height: 1.4,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    fontFamily: 'Inter',
    height: 1.4,
  );

  // Caption
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    fontFamily: 'Poppins',
    height: 1.3,
  );

  static const TextStyle linkText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );
}
