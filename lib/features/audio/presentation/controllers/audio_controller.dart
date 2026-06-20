import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peblo_ai_story_buddy/features/audio/data/services/flutter_tts_service.dart';
import 'package:peblo_ai_story_buddy/features/audio/domain/enums/audio_state.dart';
import 'package:peblo_ai_story_buddy/features/audio/domain/services/tts_service.dart';

/// Provides the active [TTSService] implementation.
///
/// To switch to [ElevenLabsTTSService], change the return value here — every
/// consumer is automatically updated by Riverpod.
final ttsServiceProvider = Provider<TTSService>((ref) {
  final service = FlutterTTSService();
  // Dispose when the provider is destroyed (e.g., when the scope is removed).
  ref.onDispose(service.dispose);
  return service;
});

/// [AudioController] manages the full TTS lifecycle and exposes [AudioState]
/// to the UI via a [StateNotifier].
///
/// Business logic is completely isolated here — no TTS code touches widgets.
///
/// Riverpod [StateNotifierProvider] ensures:
/// - Only widgets that observe [audioControllerProvider] rebuild on state change.
/// - State is scoped and garbage-collected when no longer observed.
final audioControllerProvider =
    StateNotifierProvider<AudioController, AudioState>((ref) {
  final service = ref.watch(ttsServiceProvider);
  return AudioController(service);
});

class AudioController extends StateNotifier<AudioState> {
  AudioController(this._service) : super(AudioState.idle) {
    _setupCallbacks();
  }

  final TTSService _service;

  void _setupCallbacks() {
    _service.onStart(() {
      if (mounted) state = AudioState.speaking;
    });

    _service.onComplete(() {
      if (mounted) state = AudioState.completed;
    });

    _service.onError((error) {
      if (mounted) state = AudioState.error;
    });
  }

  /// Start reading the story aloud.
  ///
  /// Transitions: idle → preparing → speaking → completed | error
  Future<void> readStory(String text) async {
    if (state.isActive) return; // Guard: already playing

    try {
      state = AudioState.preparing;
      await _service.init();
      await _service.speak(text);
    } catch (e) {
      if (mounted) state = AudioState.error;
    }
  }

  /// Stop playback and return to [AudioState.idle].
  Future<void> stop() async {
    await _service.stop();
    if (mounted) state = AudioState.idle;
  }

  /// Retry after error.
  Future<void> retry(String text) async {
    if (mounted) state = AudioState.idle;
    await readStory(text);
  }

  /// Reset to idle state (e.g., user navigates away and returns).
  void reset() {
    if (mounted) state = AudioState.idle;
  }
}
