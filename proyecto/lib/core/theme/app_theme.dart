import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.yellowHighlight,
        primary: AppColors.yellowDefault,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
          letterSpacing: -0.4,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.yellowDefault,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          side: const BorderSide(color: AppColors.cardBorder),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
    );

    final baseTextTheme = GoogleFonts.interTextTheme(base.textTheme);
    TextStyle? w600(TextStyle? style) => style?.copyWith(fontWeight: FontWeight.w600);

    return base.copyWith(
      textTheme: baseTextTheme.copyWith(
        displayLarge: w600(baseTextTheme.displayLarge),
        displayMedium: w600(baseTextTheme.displayMedium),
        displaySmall: w600(baseTextTheme.displaySmall),
        headlineLarge: w600(baseTextTheme.headlineLarge),
        headlineMedium: w600(baseTextTheme.headlineMedium),
        headlineSmall: w600(baseTextTheme.headlineSmall),
        titleLarge: w600(baseTextTheme.titleLarge),
        titleMedium: w600(baseTextTheme.titleMedium),
        titleSmall: w600(baseTextTheme.titleSmall),
        bodyLarge: w600(baseTextTheme.bodyLarge),
        bodyMedium: w600(baseTextTheme.bodyMedium),
        bodySmall: w600(baseTextTheme.bodySmall),
        labelLarge: w600(baseTextTheme.labelLarge),
        labelMedium: w600(baseTextTheme.labelMedium),
        labelSmall: w600(baseTextTheme.labelSmall),
      ),
    );
  }

  static ThemeData get darkTheme => lightTheme;
}
