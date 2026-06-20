/// Abstract TTS service contract.
///
/// This abstraction decouples the feature layer from concrete TTS
/// implementations.  Swapping from [FlutterTTSService] to
/// [ElevenLabsTTSService] (or any cloud provider) requires only changing the
/// Riverpod provider binding — zero widget changes.
///
/// SOLID: Dependency Inversion Principle — high-level modules depend on this
/// abstraction, not on concrete implementations.
abstract class TTSService {
  /// Initialise the TTS engine.  Must be called before [speak].
  Future<void> init();

  /// Speak [text] aloud.  Resolves when speech is completed or errors.
  Future<void> speak(String text);

  /// Stop any in-progress speech immediately.
  Future<void> stop();

  /// Set speech rate (0.0–1.0).
  Future<void> setRate(double rate);

  /// Set pitch (0.5–2.0).
  Future<void> setPitch(double pitch);

  /// Set volume (0.0–1.0).
  Future<void> setVolume(double volume);

  /// Register a callback invoked when speech starts.
  void onStart(void Function() callback);

  /// Register a callback invoked when speech completes.
  void onComplete(void Function() callback);

  /// Register a callback invoked when an error occurs.
  void onError(void Function(String error) callback);

  /// Release any resources held by the engine.
  Future<void> dispose();
}
