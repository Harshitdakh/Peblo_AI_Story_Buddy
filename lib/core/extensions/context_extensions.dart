import 'package:flutter/material.dart';

/// Context extensions for responsive sizing without [MediaQuery] boilerplate.
extension ContextX on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  bool get isTablet => screenWidth >= 600;
  bool get isSmallPhone => screenWidth < 360;
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}

/// Num extensions for responsive values based on screen size.
extension NumX on num {
  /// Returns responsive value scaled to screen width fraction.
  double responsiveWidth(BuildContext context) =>
      (this / 375) * MediaQuery.sizeOf(context).width;
}
