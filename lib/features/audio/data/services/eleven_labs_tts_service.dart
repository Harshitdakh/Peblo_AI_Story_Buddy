import 'package:peblo_ai_story_buddy/features/audio/domain/services/tts_service.dart';

/// Stub implementation of [TTSService] backed by the ElevenLabs REST API.
///
/// This file is intentionally left as a stub so the architecture is in place
/// for future production integration.  Swapping to this implementation
/// requires only a provider binding change — no widget code changes needed.
///
/// To activate:
///   1. Add `dio` or `http` package.
///   2. Implement [speak] to POST to `https://api.elevenlabs.io/v1/text-to-speech/{voiceId}`.
///   3. Stream the audio response through `audioplayers` or `just_audio`.
///   4. Update the Riverpod provider to inject [ElevenLabsTTSService].
class ElevenLabsTTSService implements TTSService {
  ElevenLabsTTSService({
    required String apiKey,
    required String voiceId,
  })  : _apiKey = apiKey,
        _voiceId = voiceId;

  final String _apiKey;
  final String _voiceId;

  void Function()? _onStartCallback;
  void Function()? _onCompleteCallback;
  void Function(String)? _onErrorCallback;

  @override
  Future<void> init() async {
    // TODO(engineer): Validate API key against ElevenLabs /user endpoint.
    // Ensure _apiKey and _voiceId are set from secure storage.
    assert(
      _apiKey.isNotEmpty && _voiceId.isNotEmpty,
      'ElevenLabs API key and voice ID must not be empty',
    );
  }

  @override
  Future<void> speak(String text) async {
    // TODO(engineer): Implement:
    //   POST https://api.elevenlabs.io/v1/text-to-speech/$_voiceId/stream
    //   Headers: xi-api-key: $_apiKey
    //   Body: { "text": text, "model_id": "eleven_multilingual_v2" }
    //   Stream audio bytes → decode → play via audioplayers
    _onStartCallback?.call();
    await Future<void>.delayed(const Duration(seconds: 2)); // placeholder
    _onCompleteCallback?.call();
  }

  @override
  Future<void> stop() async {
    // TODO(engineer): Cancel in-flight HTTP request and flush audio buffer.
  }

  @override
  Future<void> setRate(double rate) async {
    // ElevenLabs controls speech speed via stability/similarity_boost params.
  }

  @override
  Future<void> setPitch(double pitch) async {
    // ElevenLabs does not expose pitch directly; use voice settings.
  }

  @override
  Future<void> setVolume(double volume) async {
    // Control via local audio player volume.
  }

  @override
  void onStart(void Function() callback) => _onStartCallback = callback;

  @override
  void onComplete(void Function() callback) => _onCompleteCallback = callback;

  @override
  void onError(void Function(String error) callback) =>
      _onErrorCallback = callback;

  @override
  Future<void> dispose() async {
    // TODO(engineer): Cancel subscriptions and release audio player.
  }
}
