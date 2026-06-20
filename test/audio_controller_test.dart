import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:peblo_ai_story_buddy/features/audio/domain/enums/audio_state.dart';
import 'package:peblo_ai_story_buddy/features/audio/domain/services/tts_service.dart';
import 'package:peblo_ai_story_buddy/features/audio/presentation/controllers/audio_controller.dart';

class MockTTSService extends Mock implements TTSService {}

void main() {
  late MockTTSService mockTTSService;
  late AudioController audioController;

  setUp(() {
    mockTTSService = MockTTSService();
    when(() => mockTTSService.onStart(any())).thenAnswer((_) {});
    when(() => mockTTSService.onComplete(any())).thenAnswer((_) {});
    when(() => mockTTSService.onError(any())).thenAnswer((_) {});
    audioController = AudioController(mockTTSService);
  });

  group('AudioController State Machine Tests', () {
    test('initial state is idle', () {
      expect(audioController.debugState, equals(AudioState.idle));
    });

    test('readStory triggers preparation status flow', () async {
      when(() => mockTTSService.init()).thenAnswer((_) async {});
      when(() => mockTTSService.speak(any())).thenAnswer((_) async {});

      final future = audioController.readStory("Test Story Content");

      expect(audioController.debugState, equals(AudioState.preparing));
      await future;
    });

    test('stop cancels speech and resets to idle state', () async {
      when(() => mockTTSService.stop()).thenAnswer((_) async {});
      await audioController.stop();
      expect(audioController.debugState, equals(AudioState.idle));
    });
  });
}
