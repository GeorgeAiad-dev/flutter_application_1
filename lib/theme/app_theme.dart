import 'package:flutter/material.dart';

class AppColors {
  // الخلفيات والبطاقات
  static const Color background = Color(
    0xFFF6F6FA,
  ); // Off-white مائل للبنفسجي الفاتح
  static const Color cardBackground = Colors.white;
  static const Color secondaryFill = Color(
    0xFFECEEF8,
  ); // خلفية الأزرار الثانوية والمربعات الصغيرة

  // اللون الأساسي (Deep Teal)
  static const Color primaryTeal = Color(0xFF0E6B63);
  static const Color primaryTealLight = Color(0xFFE2F1EF);

  // النصوص
  static const Color textDark = Color(0xFF14171A);
  static const Color textGrey = Color(0xFF6E7681);

  // الحالات (Active / Expired / Cancelled)
  static const Color activeGreenBg = Color(0xFFE3F7EA);
  static const Color activeGreenText = Color(0xFF15803D);
  static const Color borderLight = Color(0xFFE6E8EF);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryTeal,
        primary: AppColors.primaryTeal,
        surface: AppColors.cardBackground,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textDark,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: AppColors.textDark),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryTeal,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
