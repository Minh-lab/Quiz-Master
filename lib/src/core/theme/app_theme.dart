import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static const double spacingXS = 4;
  static const double spacingSM = 8;
  static const double spacingMD = 12;
  static const double spacingLG = 16;
  static const double spacingXL = 20;
  static const double spacingXXL = 24;
  static const double spacing3XL = 32;

  static const double radiusSM = 6;
  static const double radiusMD = 8;
  static const double radiusLG = 12;
  static const double radiusXL = 16;
  static const double radiusFull = 100;

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.primaryDark,
      onSecondary: AppColors.textOnPrimary,
      surface: AppColors.surface,
      surfaceContainerHighest: AppColors.surfaceContainerHigh,
      surfaceContainerHigh: AppColors.surfaceContainerHigh,
      surfaceContainer: AppColors.surfaceContainer,
      surfaceVariant: AppColors.surfaceVariant,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.border,
      outlineVariant: AppColors.borderSubtle,
      error: AppColors.error,
      onError: AppColors.textOnPrimary,
      errorContainer: AppColors.errorBackground,
      onErrorContainer: AppColors.error,
    );

    return _buildTheme(
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      appBarColor: AppColors.surface,
      cardColor: AppColors.surface,
      inputFillColor: AppColors.surface,
      dividerColor: AppColors.borderSubtle,
      shadowColor: Colors.black.withValues(alpha: 0.08),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.darkPrimary,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.darkPrimary,
      onPrimary: Color(0xFF062033),
      primaryContainer: AppColors.darkPrimaryContainer,
      onPrimaryContainer: AppColors.darkOnPrimaryContainer,
      secondary: AppColors.primaryLight,
      onSecondary: Color(0xFF062033),
      surface: AppColors.darkSurface,
      surfaceContainerHighest: AppColors.darkSurfaceContainerHigh,
      surfaceContainerHigh: AppColors.darkSurfaceContainerHigh,
      surfaceContainer: AppColors.darkSurfaceContainer,
      surfaceVariant: AppColors.darkSurfaceVariant,
      onSurface: AppColors.darkTextPrimary,
      onSurfaceVariant: AppColors.darkTextSecondary,
      outline: AppColors.darkBorder,
      outlineVariant: AppColors.darkBorderSubtle,
      error: AppColors.darkError,
      onError: Color(0xFF3B0D0A),
      errorContainer: AppColors.darkErrorBackground,
      onErrorContainer: AppColors.darkError,
    );

    return _buildTheme(
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarColor: AppColors.darkSurface,
      cardColor: AppColors.darkSurfaceContainer,
      inputFillColor: AppColors.darkSurfaceContainerHigh,
      dividerColor: AppColors.darkBorderSubtle,
      shadowColor: Colors.black.withValues(alpha: 0.35),
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required Color scaffoldBackgroundColor,
    required Color appBarColor,
    required Color cardColor,
    required Color inputFillColor,
    required Color dividerColor,
    required Color shadowColor,
  }) {
    final textTheme = GoogleFonts.mulishTextTheme(
      brightness == Brightness.dark
          ? ThemeData.dark().textTheme
          : ThemeData.light().textTheme,
    ).apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      canvasColor: scaffoldBackgroundColor,
      cardColor: cardColor,
      dividerColor: dividerColor,
      disabledColor: brightness == Brightness.dark
          ? AppColors.darkTextDisabled
          : AppColors.textDisabled,

      appBarTheme: AppBarTheme(
        backgroundColor: appBarColor,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.mulish(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.surfaceVariant,
          disabledForegroundColor: colorScheme.onSurfaceVariant,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSM),
          ),
          textStyle: GoogleFonts.mulish(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          elevation: 0,
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.surfaceVariant,
          disabledForegroundColor: colorScheme.onSurfaceVariant,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMD),
          ),
          textStyle: GoogleFonts.mulish(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSM),
          ),
          side: BorderSide(color: colorScheme.outline, width: 1.2),
          textStyle: GoogleFonts.mulish(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: GoogleFonts.mulish(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingLG,
          vertical: spacingMD,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        hintStyle: GoogleFonts.mulish(
          fontSize: 14,
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shadowColor: shadowColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          side: BorderSide(color: colorScheme.outlineVariant, width: 1),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: spacingXL,
          vertical: spacingSM,
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: appBarColor,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.mulish(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.mulish(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        elevation: brightness == Brightness.dark ? 0 : 8,
      ),

      dividerTheme: DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 1,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.primaryContainer,
        selectedColor: colorScheme.primary,
        labelStyle: GoogleFonts.mulish(
          fontSize: 12,
          color: colorScheme.onPrimaryContainer,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSM),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: GoogleFonts.mulish(
          fontSize: 14,
          color: colorScheme.onInverseSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMD),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: cardColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLG),
        ),
        titleTextStyle: GoogleFonts.mulish(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
        contentTextStyle: GoogleFonts.mulish(
          fontSize: 14,
          height: 1.4,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
