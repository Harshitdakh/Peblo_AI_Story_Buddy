import 'package:flutter/material.dart';

/// Peblo brand colour palette — every hex value in one place.
/// Performance: all are compile-time [Color] constants → zero runtime allocation.
abstract final class AppColors {
  // ── Brand ──────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFFFF7A00);
  static const Color primaryLight = Color(0xFFFF9A40);
  static const Color primaryDark = Color(0xFFCC6200);

  static const Color secondary = Color(0xFFFFD93D);
  static const Color secondaryLight = Color(0xFFFFE97D);
  static const Color secondaryDark = Color(0xFFCCAD00);

  static const Color accent = Color(0xFF4ECDC4);
  static const Color accentLight = Color(0xFF80DDD6);
  static const Color accentDark = Color(0xFF35A99E);

  // ── Surface ────────────────────────────────────────────────────────────────
  static const Color background = Color(0xFFFFF8E7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFFFF0C8);
  static const Color cardBackground = Color(0xFFFFFDF5);

  // ── Semantic ───────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFEF9A9A);
  static const Color warning = Color(0xFFFF9800);

  // ── Text ───────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textHint = Color(0xFFAAAAAA);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // ── Misc ───────────────────────────────────────────────────────────────────
  static const Color shadow = Color(0x1A000000);
  static const Color divider = Color(0xFFEEEEEE);
  static const Color overlayLight = Color(0x33FFFFFF);
  static const Color overlayDark = Color(0x33000000);
  static const Color transparent = Colors.transparent;

  // ── Buddy states ───────────────────────────────────────────────────────────
  static const Color buddyIdle = Color(0xFF4ECDC4);
  static const Color buddySpeaking = Color(0xFFFF7A00);
  static const Color buddyHappy = Color(0xFF4CAF50);
  static const Color buddySad = Color(0xFF78909C);
}
