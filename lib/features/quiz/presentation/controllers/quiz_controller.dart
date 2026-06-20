import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peblo_ai_story_buddy/features/quiz/data/repositories/quiz_repository.dart';
import 'package:peblo_ai_story_buddy/features/quiz/domain/models/quiz_model.dart';
import 'package:peblo_ai_story_buddy/features/quiz/domain/states/quiz_state.dart';

/// Provides the quiz repository singleton.
final quizRepositoryProvider = Provider<QuizRepository>(
  (_) => AssetQuizRepository(),
);

/// [QuizController] manages the full quiz lifecycle.
///
/// Riverpod [StateNotifierProvider]:
/// - Isolates all business logic from widgets.
/// - Granular [select] projections prevent unnecessary rebuilds.
/// - [AsyncValue] for loading/error handled via [QuizState] union type.
final quizControllerProvider =
    StateNotifierProvider<QuizController, QuizState>((ref) {
  final repo = ref.watch(quizRepositoryProvider);
  return QuizController(repo);
});

class QuizController extends StateNotifier<QuizState> {
  QuizController(this._repository) : super(const QuizState.initial());

  final QuizRepository _repository;

  /// Load quiz data from the repository.
  Future<void> loadQuiz() async {
    if (state is QuizLoading) return;
    state = const QuizState.loading();
    try {
      final quiz = await _repository.loadQuiz();
      state = QuizState.ready(quiz: quiz);
    } catch (e) {
      state = QuizState.error(
        message: 'Oops! Something went wrong loading the quiz. 🤖',
      );
    }
  }

  /// Process the user's answer selection.
  ///
  /// Transitions: ready → ready(answered) → success | ready(wrong)
  void selectAnswer(String option) {
    final current = state;
    if (current is! QuizReady) return;
    if (current.isAnswered) return; // Prevent double-tap

    final isCorrect = option == current.quiz.answer;

    if (isCorrect) {
      state = QuizState.success(
        quiz: current.quiz,
        selectedOption: option,
      );
    } else {
      // Wrong answer: mark as answered but not correct — allows retry.
      state = current.copyWith(
        selectedOption: option,
        isCorrect: false,
        isAnswered: true,
      );
    }
  }

  /// Allow the user to retry after a wrong answer.
  void retry() {
    final current = state;
    if (current is! QuizReady) return;
    state = QuizState.ready(quiz: current.quiz);
  }

  /// Reset quiz back to initial state.
  void reset() => state = const QuizState.initial();
}

// ── Convenience selectors ────────────────────────────────────────────────────
// Using selectors prevents widgets from rebuilding unless their specific
// slice of state changes.

/// True only when a wrong answer was just selected.
final wrongAnswerProvider = Provider<bool>((ref) {
  final state = ref.watch(quizControllerProvider);
  if (state is QuizReady) {
    return state.isAnswered && !state.isCorrect;
  }
  return false;
});

/// True only when the correct answer has been selected.
final quizSuccessProvider = Provider<bool>((ref) {
  return ref.watch(quizControllerProvider) is QuizSuccess;
});

/// The current quiz model, or null when not loaded.
final currentQuizProvider = Provider<QuizModel?>((ref) {
  final state = ref.watch(quizControllerProvider);
  return state.maybeMap(
    ready: (r) => r.quiz,
    success: (s) => s.quiz,
    orElse: () => null,
  );
});
