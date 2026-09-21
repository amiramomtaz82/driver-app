import 'package:flutter/material.dart';
import 'app_colors.dart';


@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.primary,
    required this.secondary,
    required this.error,
    required this.success,
    required this.black,
    required this.white,
    required this.grey,
    required this.darkGrey,
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.divider,
    required this.hint,
  });

  final Color primary;
  final Color secondary;
  final Color error;
  final Color success;
  final Color black;
  final Color white;
  final Color grey;
  final Color darkGrey;
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color divider;
  final Color hint;

  static const light = CustomColors(
    primary: AppColors.pink,
    secondary: AppColors.darkGrey,
    error: AppColors.error,
    success: AppColors.success,
    black: AppColors.black,
    white: AppColors.white,
    grey: AppColors.grey,
    darkGrey: AppColors.darkGrey,
    background: AppColors.white,
    surface: AppColors.lightGrey,
    textPrimary: AppColors.black,
    textSecondary: AppColors.white,
    border: AppColors.borderBlack,
    divider: AppColors.dividerGrey,
    hint: AppColors.grey,
  );

  static const dark = CustomColors(
    primary: AppColors.darkPink,
    secondary: AppColors.grey,
    error: AppColors.error,
    success: AppColors.success,
    black: AppColors.black,
    white: AppColors.white,
    grey: AppColors.grey,
    darkGrey: AppColors.darkGrey,
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    textPrimary: AppColors.white,
    textSecondary: AppColors.grey,
    border: AppColors.darkBorder,
    divider: AppColors.darkDivider,
    hint: AppColors.darkGrey,
  );

  @override
  CustomColors copyWith({
    Color? primary,
    Color? secondary,
    Color? error,
    Color? success,
    Color? black,
    Color? white,
    Color? grey,
    Color? darkGrey,
    Color? background,
    Color? surface,
    Color? textPrimary,
    Color? textSecondary,
    Color? border,
    Color? divider,
    Color? hint,
  }) {
    return CustomColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      error: error ?? this.error,
      success: success ?? this.success,
      black: black ?? this.black,
      white: white ?? this.white,
      grey: grey ?? this.grey,
      darkGrey: darkGrey ?? this.darkGrey,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      hint: hint ?? this.hint,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
      black: Color.lerp(black, other.black, t)!,
      white: Color.lerp(white, other.white, t)!,
      grey: Color.lerp(grey, other.grey, t)!,
      darkGrey: Color.lerp(darkGrey, other.darkGrey, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      hint: Color.lerp(hint, other.hint, t)!,
    );
  }
}