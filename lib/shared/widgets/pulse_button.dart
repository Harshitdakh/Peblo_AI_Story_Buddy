import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:peblo_ai_story_buddy/core/core.dart';
import 'package:peblo_ai_story_buddy/theme/theme.dart';

/// A button that animates with a pulse effect.
class PulseButton extends StatelessWidget {
  const PulseButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
  });

  final VoidCallback onPressed;
  final Widget child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        HapticUtils.medium();
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary,
        minimumSize: const Size(240, 60),
      ),
      child: child,
    )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scale(
          begin: const Offset(1.0, 1.0),
          end: const Offset(1.04, 1.04),
          duration: 1000.ms,
          curve: Curves.easeInOut,
        );
  }
}
