// lib/core/theme/app_text_styles.dart
import 'package:flutter/material.dart';

abstract final class AppTextStyles {
  AppTextStyles._();

  // Screen Titles (e.g., "Welcome!!", "Login", "Your application has been submitted!")
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
  );

  // Section titles & Dialog headers (e.g., "LOGOUT", "Vehicle info")
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // Regular Body (e.g., Subtitles, Descriptions, Profile Items)
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  // Input Field Values & Radio options (e.g., entered text, "Male", "Female")
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  // Floating Labels on TextFields
  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  // Placeholders / Hints
  static const TextStyle hint = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  // Button text ("Continue", "Login", "Update")
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // Small links & helpers (e.g., "Forgot password?", "Change", App Version)
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  // Error hints below text fields
  static const TextStyle error = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
}