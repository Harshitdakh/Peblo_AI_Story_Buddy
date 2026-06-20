/// App-wide constant values.
///
/// Centralising constants eliminates magic numbers and ensures consistency.
abstract final class AppConstants {
  // ── Story ──────────────────────────────────────────────────────────────────
  static const String storyTitle = "Pip and the Whispering Woods";

  static const String storyText =
      "Once upon a time, a clever little robot named Pip lost his shiny blue "
      "gear in the Whispering Woods. The tall silver trees hummed and whispered "
      "secrets to the wind. Pip blinked his big round eyes and listened very "
      "carefully. A friendly firefly named Fern zoomed out of the shadows and "
      "said, 'Follow the glowing mushrooms, Pip — they will lead you home!' "
      "Pip thanked Fern with a happy beep and skipped along the shimmering trail. "
      "Deep inside the woods, resting on a mossy rock, was the shiny blue gear "
      "— sparkling like a tiny star. Pip cheered, clicked the gear back into "
      "place, and danced all the way back to his cosy little workshop. "
      "And every night after that, Pip left a lantern on the windowsill "
      "for Fern, his forever friend.";

  // ── TTS ───────────────────────────────────────────────────────────────────
  static const double ttsDefaultRate = 0.45;
  static const double ttsDefaultPitch = 1.1;
  static const double ttsDefaultVolume = 1.0;

  // ── Animation durations ───────────────────────────────────────────────────
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animNormal = Duration(milliseconds: 400);
  static const Duration animSlow = Duration(milliseconds: 700);
  static const Duration animVerySlow = Duration(milliseconds: 1200);

  static const Duration quizRevealDelay = Duration(milliseconds: 600);
  static const Duration buddyBounceInterval = Duration(milliseconds: 900);
  static const Duration waveCycle = Duration(milliseconds: 800);

  // ── Spacing ───────────────────────────────────────────────────────────────
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;
  static const double spacingXxl = 48;

  // ── Radius ────────────────────────────────────────────────────────────────
  static const double radiusSm = 12;
  static const double radiusMd = 20;
  static const double radiusLg = 28;
  static const double radiusXl = 40;
  static const double radiusCircle = 999;

  // ── Touch targets ─────────────────────────────────────────────────────────
  static const double minTouchTarget = 48;

  // ── Confetti ──────────────────────────────────────────────────────────────
  static const double confettiBlastForce = 0.6;
  static const int confettiParticleCount = 30;

  // ── Sound wave bars ───────────────────────────────────────────────────────
  static const int soundWaveBarCount = 7;
  static const double soundWaveMinHeight = 8;
  static const double soundWaveMaxHeight = 40;

  // ── Asset paths ───────────────────────────────────────────────────────────
  static const String quizJsonPath = 'assets/json/quiz.json';
}
