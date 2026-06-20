/// Represents the visual mood and animation state of the AI Buddy character.
///
/// Driven directly by app interaction:
/// - [idle]      → bouncy breathing (while waiting for action)
/// - [speaking]  → speaking mouth wiggle + bounce (while TTS is active)
/// - [happy]     → celebrating jumping + happy face (on correct answer)
/// - [sad]       → head shake/droop + disappointed face (on incorrect answer)
enum BuddyMood {
  idle,
  speaking,
  happy,
  sad;

  bool get isIdle => this == BuddyMood.idle;
  bool get isSpeaking => this == BuddyMood.speaking;
  bool get isHappy => this == BuddyMood.happy;
  bool get isSad => this == BuddyMood.sad;
}
