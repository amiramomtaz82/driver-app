// lib/core/theme/app_theme.dart
import 'package:driver_app/core/app_theme/text_styels.dart';
import 'package:flutter/material.dart';
import 'custom_colors.dart';

abstract final class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => _buildTheme(
    brightness: Brightness.light,
    colors: CustomColors.light,
  );

  static ThemeData get darkTheme => _buildTheme(
    brightness: Brightness.dark,
    colors: CustomColors.dark,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required CustomColors colors,
  }) {
    // Shared input border template to eliminate code repetition
    final baseInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      gapPadding: 5,
    );

    final colorScheme = ColorScheme.fromSeed(
      seedColor: colors.primary,
      brightness: brightness,
      surface: colors.background,
      error: colors.error,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.background,
      extensions: [colors],

      // Common AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: TextTheme(
        headlineLarge: AppTextStyles.headlineLarge.copyWith(color: colors.textPrimary),
        titleMedium: AppTextStyles.titleMedium.copyWith(color: colors.textPrimary),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: colors.textPrimary),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: colors.darkGrey),
        labelSmall: AppTextStyles.labelSmall.copyWith(color: colors.darkGrey),
      ),
      ///--------------- Text Field -------------------///
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        filled: true,
        fillColor: colors.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colors.darkGrey,
        ),
        floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
          final isError = states.contains(WidgetState.error);
          return TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isError ? colors.error : colors.darkGrey,
          );
        }),
        hintStyle: TextStyle(
          fontSize: 14,
          color: colors.hint,
        ),
        errorStyle: TextStyle(
          fontSize: 12,
          color: colors.error,
        ),
        border: baseInputBorder.copyWith(
          borderSide: BorderSide(color: colors.border, width: 1.2),
        ),
        enabledBorder: baseInputBorder.copyWith(
          borderSide: BorderSide(color: colors.border, width: 1.2),
        ),
        focusedBorder: baseInputBorder.copyWith(
          borderSide: BorderSide(color: colors.border, width: 1.5),
        ),
        errorBorder: baseInputBorder.copyWith(
          borderSide: BorderSide(color: colors.error, width: 1.2),
        ),
        focusedErrorBorder: baseInputBorder.copyWith(
          borderSide: BorderSide(color: colors.error, width: 1.5),
        ),
      ),

      ///------------------ Snack Bar -------------------///
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.primary,
        contentTextStyle: TextStyle(
          color: colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actionTextColor: colors.white,
      ),

      ///---------------- Elevated Button ------------------------///
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.white,
          disabledBackgroundColor: colors.darkGrey,
          disabledForegroundColor: colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      ///------------------- Navigation Bar ---------------------///
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.white,
        elevation: 0,
        height: 70,
        indicatorColor: Colors.transparent,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: isSelected ? colors.primary : colors.darkGrey,
            size: 24,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colors.primary,
            );
          }
          return TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: colors.darkGrey,
          );
        }),
      ),
    );
  }
}