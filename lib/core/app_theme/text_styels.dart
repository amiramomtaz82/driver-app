// lib/core/theme/app_text_styles.dart
import 'package:flutter/material.dart';

abstract final class AppTextStyles {
  AppTextStyles._();

  // Screen Main Headings (e.g., "Welcome!!", "Thank you!!", Screen Headers)
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
  );

  // Card headers, Dialog titles, Order numbers (e.g., "#123456", "LOGOUT")
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // Section labels (e.g., "Pickup address", "User address", "Order details")
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  // Input Field Values, Radio Titles, Order Item Names
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  // Subtitles, descriptions, address snippets
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  // Status badges & Indicators (e.g., "Accepted", "Completed", "Cancelled")
  static const TextStyle statusBadge = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  // Field Floating Labels
  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  // Placeholders & hints inside TextFields
  static const TextStyle hint = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  // Main primary CTA buttons ("Continue", "Accept", "Arrived at Pickup point")
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // Mini captions, timestamps, order counts ("Wed, 03 Sep 2024, 11:00 AM", version)
  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
  );

  // Validation/Error text below input borders
  static const TextStyle error = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
}