import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peblo_ai_story_buddy/features/buddy/domain/enums/buddy_mood.dart';
import 'package:peblo_ai_story_buddy/features/buddy/presentation/controllers/buddy_controller.dart';
import 'package:peblo_ai_story_buddy/features/buddy/presentation/widgets/pip_robot_painter.dart';
import 'package:peblo_ai_story_buddy/theme/app_colors.dart';

/// A rich, reactive custom AI Buddy Widget.
///
/// This widget uses [flutter_animate] and [RepaintBoundary] to ensure high performance
/// (60 FPS) animations without lagging the rest of the application.
class BuddyWidget extends ConsumerStatefulWidget {
  const BuddyWidget({super.key});

  @override
  ConsumerState<BuddyWidget> createState() => _BuddyWidgetState();
}

class _BuddyWidgetState extends ConsumerState<BuddyWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Color _getBodyColor(BuddyMood mood) {
    switch (mood) {
      case BuddyMood.idle:
        return AppColors.buddyIdle;
      case BuddyMood.speaking:
        return AppColors.buddySpeaking;
      case BuddyMood.happy:
        return AppColors.buddyHappy;
      case BuddyMood.sad:
        return AppColors.buddySad;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mood = ref.watch(buddyMoodProvider);

    // Dynamic scale and bounce offset derived from mood and ticker
    Widget child = RepaintBoundary(
      child: AnimatedBuilder(
        animation: _animController,
        builder: (context, child) {
          double scaleY = 1.0;
          double scaleX = 1.0;
          double bounceY = 0.0;
          double antennaScale = 1.0;
          double eyeMultiplier = 1.0;
          double mouthWidth = 1.0;

          switch (mood) {
            case BuddyMood.idle:
              // Gentle breath stretch animation
              scaleY = 1.0 + (_animController.value * 0.04);
              scaleX = 1.0 - (_animController.value * 0.02);
              antennaScale = 1.0 + (_animController.value * 0.08);
              break;
            case BuddyMood.speaking:
              // Faster talking mouth size pulsing + vertical bobbing
              scaleY = 1.0 - (_animController.value * 0.03);
              bounceY = _animController.value * -6.0;
              mouthWidth = 0.8 + (_animController.value * 0.5);
              break;
            case BuddyMood.happy:
              // Energetic excitement jump up-and-down
              bounceY = _animController.value * -20.0;
              scaleY = 1.0 + (_animController.value * 0.05);
              eyeMultiplier = 1.2;
              break;
            case BuddyMood.sad:
              // Slightly deflated scale, looking tired or sad
              scaleY = 0.94;
              scaleX = 1.04;
              antennaScale = 0.8;
              eyeMultiplier = 0.85;
              break;
          }

          return Transform.translate(
            offset: Offset(0, bounceY),
            child: Transform.scale(
              scaleX: scaleX,
              scaleY: scaleY,
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 140,
                height: 140,
                child: CustomPaint(
                  painter: PipRobotPainter(
                    eyeSizeMultiplier: eyeMultiplier,
                    mouthWidthMultiplier: mouthWidth,
                    antennaScale: antennaScale,
                    bodyColor: _getBodyColor(mood),
                    showSmile: mood.isHappy || mood.isIdle,
                    showOshapeMouth: mood.isSpeaking,
                    showSadMouth: mood.isSad,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    // Apply conditional outer animations like Shake for Sad state
    if (mood.isSad) {
      child = child
          .animate(onPlay: (controller) => controller.repeat(max: 3))
          .shake(hz: 8, curve: Curves.easeInOutCubic, amount: 6);
    }

    return Semantics(
      label: 'Pip, your cute AI Robot Buddy helper. Currently in ${mood.name} mode.',
      child: child,
    );
  }
}
