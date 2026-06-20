import 'package:flutter_tts/flutter_tts.dart';
import 'package:peblo_ai_story_buddy/features/audio/domain/services/tts_service.dart';

/// Concrete TTS implementation backed by the `flutter_tts` package.
///
/// Lifecycle:
///   1. [init] — configure language, rate, pitch, volume, callbacks
///   2. [speak] — start playback
///   3. [stop]  — cancel (e.g., when navigating away)
///   4. [dispose] — clean up native resources
///
/// Thread-safety: [FlutterTts] marshals calls to the platform thread
/// automatically; no additional locking is required here.
class FlutterTTSService implements TTSService {
  FlutterTTSService() : _tts = FlutterTts();

  final FlutterTts _tts;

  void Function()? _onStartCallback;
  void Function()? _onCompleteCallback;
  void Function(String)? _onErrorCallback;

  @override
  Future<void> init() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.1);
    await _tts.setVolume(1.0);
    await _tts.awaitSpeakCompletion(true);

    _tts.setStartHandler(() => _onStartCallback?.call());
    _tts.setCompletionHandler(() => _onCompleteCallback?.call());
    _tts.setErrorHandler((msg) => _onErrorCallback?.call(msg.toString()));
  }

  @override
  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  @override
  Future<void> stop() async {
    await _tts.stop();
  }

  @override
  Future<void> setRate(double rate) async {
    await _tts.setSpeechRate(rate);
  }

  @override
  Future<void> setPitch(double pitch) async {
    await _tts.setPitch(pitch);
  }

  @override
  Future<void> setVolume(double volume) async {
    await _tts.setVolume(volume);
  }

  @override
  void onStart(void Function() callback) {
    _onStartCallback = callback;
  }

  @override
  void onComplete(void Function() callback) {
    _onCompleteCallback = callback;
  }

  @override
  void onError(void Function(String error) callback) {
    _onErrorCallback = callback;
  }

  @override
  Future<void> dispose() async {
    await _tts.stop();
  }
}
