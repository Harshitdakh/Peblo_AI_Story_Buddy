/// Represents the lifecycle of text-to-speech playback.
///
/// Each state drives a distinct UI presentation:
/// - [idle]      → show the "Read Me A Story" button
/// - [preparing] → show circular loader (engine initialising)
/// - [speaking]  → show animated sound wave
/// - [completed] → show success indicator
/// - [error]     → show child-friendly retry card
enum AudioState {
  idle,
  preparing,
  speaking,
  completed,
  error;

  bool get isIdle => this == AudioState.idle;
  bool get isPreparing => this == AudioState.preparing;
  bool get isSpeaking => this == AudioState.speaking;
  bool get isCompleted => this == AudioState.completed;
  bool get isError => this == AudioState.error;

  /// Whether the TTS engine is actively running.
  bool get isActive => isPreparing || isSpeaking;
}
