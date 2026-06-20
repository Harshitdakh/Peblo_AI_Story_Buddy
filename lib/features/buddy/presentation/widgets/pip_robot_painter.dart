import 'package:flutter/material.dart';
import 'package:peblo_ai_story_buddy/theme/app_colors.dart';

/// A custom painter that draws a cute customizable AI Robot Buddy named Pip.
///
/// Painting procedurally avoids dependencies on asset loading and permits
/// smooth, scalable rendering.
class PipRobotPainter extends CustomPainter {
  const PipRobotPainter({
    required this.eyeSizeMultiplier,
    required this.mouthWidthMultiplier,
    required this.antennaScale,
    required this.bodyColor,
    required this.showSmile,
    required this.showOshapeMouth,
    required this.showSadMouth,
  });

  final double eyeSizeMultiplier;
  final double mouthWidthMultiplier;
  final double antennaScale;
  final Color bodyColor;
  final bool showSmile;
  final bool showOshapeMouth;
  final bool showSadMouth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final width = size.width;
    final height = size.height;

    // Head dimensions
    final headWidth = width * 0.75;
    final headHeight = height * 0.55;
    final headRect = Rect.fromCenter(
      center: center.translate(0, 10),
      width: headWidth,
      height: headHeight,
    );

    // Antenna & glowing bulb
    final antennaPaint = Paint()
      ..color = AppColors.textSecondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final bulbPaint = Paint()
      ..color = AppColors.secondary
      ..style = PaintingStyle.fill;

    // Bulb glow overlay
    final glowPaint = Paint()
      ..color = AppColors.secondary.withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final antennaStart = Offset(center.dx, headRect.top + 2);
    final antennaEnd = Offset(center.dx, headRect.top - 25 * antennaScale);

    canvas.drawLine(antennaStart, antennaEnd, antennaPaint);
    canvas.drawCircle(antennaEnd, 10 * antennaScale, glowPaint);
    canvas.drawCircle(antennaEnd, 7 * antennaScale, bulbPaint);

    // Robot ears/bolts
    final boltPaint = Paint()
      ..color = AppColors.textHint
      ..style = PaintingStyle.fill;

    final leftBolt = Rect.fromLTWH(headRect.left - 10, headRect.top + headHeight * 0.35, 10, 20);
    final rightBolt = Rect.fromLTWH(headRect.right, headRect.top + headHeight * 0.35, 10, 20);
    canvas.drawRRect(RRect.fromRectAndRadius(leftBolt, const Radius.circular(4)), boltPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(rightBolt, const Radius.circular(4)), boltPaint);

    // Head body
    final headPaint = Paint()
      ..color = bodyColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = AppColors.textPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    final headRRect = RRect.fromRectAndRadius(headRect, const Radius.circular(28));
    canvas.drawRRect(headRRect, headPaint);
    canvas.drawRRect(headRRect, borderPaint);

    // Screen visor inside head
    final visorPaint = Paint()
      ..color = const Color(0xFF1E1E24)
      ..style = PaintingStyle.fill;

    final visorRect = Rect.fromCenter(
      center: center.translate(0, -5),
      width: headWidth * 0.85,
      height: headHeight * 0.65,
    );
    final visorRRect = RRect.fromRectAndRadius(visorRect, const Radius.circular(20));
    canvas.drawRRect(visorRRect, visorPaint);
    canvas.drawRRect(visorRRect, borderPaint..strokeWidth = 4);

    // Eyes
    final leftEyeCenter = Offset(visorRect.center.dx - visorRect.width * 0.25, visorRect.center.dy - 5);
    final rightEyeCenter = Offset(visorRect.center.dx + visorRect.width * 0.25, visorRect.center.dy - 5);
    final eyeRadius = 14.0 * eyeSizeMultiplier;

    final eyePaint = Paint()
      ..color = AppColors.secondary
      ..style = PaintingStyle.fill;

    final eyeGlowPaint = Paint()
      ..color = AppColors.secondary.withOpacity(0.4)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    // Draw Left Eye
    canvas.drawCircle(leftEyeCenter, eyeRadius, eyeGlowPaint);
    canvas.drawCircle(leftEyeCenter, eyeRadius * 0.8, eyePaint);

    // Draw Right Eye
    canvas.drawCircle(rightEyeCenter, eyeRadius, eyeGlowPaint);
    canvas.drawCircle(rightEyeCenter, eyeRadius * 0.8, eyePaint);

    // Eye highlights (Cute Sparkles)
    final highlightPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(leftEyeCenter.translate(-eyeRadius * 0.2, -eyeRadius * 0.2), eyeRadius * 0.2, highlightPaint);
    canvas.drawCircle(rightEyeCenter.translate(-eyeRadius * 0.2, -eyeRadius * 0.2), eyeRadius * 0.2, highlightPaint);

    // Cheek blush (Cute!)
    final blushPaint = Paint()
      ..color = Colors.redAccent.withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawCircle(leftEyeCenter.translate(-10, 15), 10, blushPaint);
    canvas.drawCircle(rightEyeCenter.translate(10, 15), 10, blushPaint);

    // Mouth
    final mouthPaint = Paint()
      ..color = AppColors.secondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final mouthCenter = Offset(visorRect.center.dx, visorRect.bottom - visorRect.height * 0.25);

    if (showSmile) {
      // Happy smiley mouth
      final mouthPath = Path();
      final width = 24.0 * mouthWidthMultiplier;
      mouthPath.moveTo(mouthCenter.dx - width / 2, mouthCenter.dy - 3);
      mouthPath.quadraticBezierTo(
        mouthCenter.dx,
        mouthCenter.dy + 8,
        mouthCenter.dx + width / 2,
        mouthCenter.dy - 3,
      );
      canvas.drawPath(mouthPath, mouthPaint);
    } else if (showOshapeMouth) {
      // Singing / speaking mouth
      final speakMouthPaint = Paint()
        ..color = AppColors.secondary
        ..style = PaintingStyle.fill;
      canvas.drawCircle(mouthCenter, 6.0 * mouthWidthMultiplier, speakMouthPaint);
    } else if (showSadMouth) {
      // Disappointed / sad mouth
      final mouthPath = Path();
      final width = 20.0;
      mouthPath.moveTo(mouthCenter.dx - width / 2, mouthCenter.dy + 4);
      mouthPath.quadraticBezierTo(
        mouthCenter.dx,
        mouthCenter.dy - 2,
        mouthCenter.dx + width / 2,
        mouthCenter.dy + 4,
      );
      canvas.drawPath(mouthPath, mouthPaint);
    } else {
      // Normal flat line mouth
      canvas.drawLine(
        Offset(mouthCenter.dx - 10, mouthCenter.dy),
        Offset(mouthCenter.dx + 10, mouthCenter.dy),
        mouthPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant PipRobotPainter oldDelegate) {
    return oldDelegate.eyeSizeMultiplier != eyeSizeMultiplier ||
        oldDelegate.mouthWidthMultiplier != mouthWidthMultiplier ||
        oldDelegate.antennaScale != antennaScale ||
        oldDelegate.bodyColor != bodyColor ||
        oldDelegate.showSmile != showSmile ||
        oldDelegate.showOshapeMouth != showOshapeMouth ||
        oldDelegate.showSadMouth != showSadMouth;
  }
}
