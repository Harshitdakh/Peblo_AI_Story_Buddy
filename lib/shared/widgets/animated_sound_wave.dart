import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:peblo_ai_story_buddy/core/core.dart';
import 'package:peblo_ai_story_buddy/theme/app_colors.dart';

/// An animated sound wave indicator showing audio speech active.
///
/// Builds 7 variable-height bars that cycle infinitely using standard [AnimatedBuilder].
/// Wrap inside [RepaintBoundary] for performance isolation.
class AnimatedSoundWave extends StatefulWidget {
  const AnimatedSoundWave({super.key});

  @override
  State<AnimatedSoundWave> createState() => _AnimatedSoundWaveState();
}

class _AnimatedSoundWaveState extends State<AnimatedSoundWave>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppConstants.waveCycle,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 1.5),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                AppConstants.soundWaveBarCount,
                (index) {
                  // Phase offsets to make wave look natural
                  final offset = (index / AppConstants.soundWaveBarCount) * 2 * 3.14159;
                  final sineVal = (index % 2 == 0)
                      ? math.sin(_controller.value * 2 * 3.14159 + offset)
                      : math.sin(_controller.value * 2 * 3.14159 - offset);

                  final normalized = (sineVal + 1) / 2; // 0.0 to 1.0
                  final height = AppConstants.soundWaveMinHeight +
                      normalized * (AppConstants.soundWaveMaxHeight - AppConstants.soundWaveMinHeight);

                  return Container(
                    width: 5,
                    height: height,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
