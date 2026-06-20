import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:peblo_ai_story_buddy/features/quiz/domain/models/quiz_model.dart';

part 'quiz_state.freezed.dart';

/// Represents all possible states of the quiz feature.
@freezed
class QuizState with _$QuizState {
  /// Quiz has not been attempted yet.
  const factory QuizState.initial() = QuizInitial;

  /// Quiz data is being loaded.
  const factory QuizState.loading() = QuizLoading;

  /// Quiz is ready for interaction — shows question & options.
  const factory QuizState.ready({
    required QuizModel quiz,
    String? selectedOption,
    @Default(false) bool isCorrect,
    @Default(false) bool isAnswered,
  }) = QuizReady;

  /// Quiz completed with correct answer.
  const factory QuizState.success({
    required QuizModel quiz,
    required String selectedOption,
  }) = QuizSuccess;

  /// An error occurred loading the quiz.
  const factory QuizState.error({required String message}) = QuizError;
}
