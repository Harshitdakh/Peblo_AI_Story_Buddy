import 'package:flutter/services.dart';

/// Thin wrapper around [HapticFeedback] so the call site stays readable
/// and tests can mock it.
abstract final class HapticUtils {
  /// Light tap — used for option selections.
  static Future<void> light() => HapticFeedback.lightImpact();

  /// Medium tap — used for button presses.
  static Future<void> medium() => HapticFeedback.mediumImpact();

  /// Heavy tap — used for wrong answer shake.
  static Future<void> heavy() => HapticFeedback.heavyImpact();

  /// Success vibration pattern — used on correct answer.
  static Future<void> success() => HapticFeedback.vibrate();

  /// Selection click.
  static Future<void> selection() => HapticFeedback.selectionClick();
}
