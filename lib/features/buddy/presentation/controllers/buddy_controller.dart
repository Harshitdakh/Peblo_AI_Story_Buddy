import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peblo_ai_story_buddy/features/audio/domain/enums/audio_state.dart';
import 'package:peblo_ai_story_buddy/features/audio/presentation/controllers/audio_controller.dart';
import 'package:peblo_ai_story_buddy/features/buddy/domain/enums/buddy_mood.dart';
import 'package:peblo_ai_story_buddy/features/quiz/presentation/controllers/quiz_controller.dart';

/// State provider for the AI Buddy character.
///
/// Automatically derives the buddy's mood based on the status of both
/// [audioControllerProvider] and [quizControllerProvider] using Riverpod state linking.
final buddyMoodProvider = Provider<BuddyMood>((ref) {
  final audioState = ref.watch(audioControllerProvider);
  final isWrong = ref.watch(wrongAnswerProvider);
  final isCorrect = ref.watch(quizSuccessProvider);

  if (isCorrect) {
    return BuddyMood.happy;
  }
  if (isWrong) {
    return BuddyMood.sad;
  }
  if (audioState == AudioState.speaking) {
    return BuddyMood.speaking;
  }
  return BuddyMood.idle;
});
