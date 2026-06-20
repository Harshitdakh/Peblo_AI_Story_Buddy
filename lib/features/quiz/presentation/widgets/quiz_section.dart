import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peblo_ai_story_buddy/core/core.dart';
import 'package:peblo_ai_story_buddy/features/quiz/domain/states/quiz_state.dart';
import 'package:peblo_ai_story_buddy/features/quiz/presentation/controllers/quiz_controller.dart';
import 'package:peblo_ai_story_buddy/theme/theme.dart';

/// The QuizSection component containing option builders and correct/incorrect triggers.
class QuizSection extends ConsumerStatefulWidget {
  const QuizSection({super.key});

  @override
  ConsumerState<QuizSection> createState() => _QuizSectionState();
}

class _QuizSectionState extends ConsumerState<QuizSection> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizControllerProvider);

    // Listen to success states to play confetti
    ref.listen<QuizState>(quizControllerProvider, (previous, next) {
      if (next is QuizSuccess) {
        _confettiController.play();
        HapticUtils.success();
      } else if (next is QuizReady && next.isAnswered && !next.isCorrect) {
        HapticUtils.heavy();
      }
    });

    return Stack(
      alignment: Alignment.center,
      children: [
        // Confetti Canvas
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          colors: const [
            AppColors.primary,
            AppColors.secondary,
            AppColors.accent,
            AppColors.success,
          ],
        ),

        // Core Quiz Widget
        quizState.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (message) => Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              message,
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
          ),
          ready: (quiz, selectedOption, isCorrect, isAnswered) =>
              _buildQuizCard(quiz, selectedOption, isCorrect, isAnswered),
          success: (quiz, selectedOption) =>
              _buildSuccessCard(quiz, selectedOption),
        ),
      ],
    );
  }

  Widget _buildQuizCard(
    dynamic quiz,
    String? selectedOption,
    bool isCorrect,
    bool isAnswered,
  ) {
    // Determine outer style classes
    final isWrongAnswerSelected = isAnswered && !isCorrect;

    Widget cardContent = Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              quiz.question,
              style: AppTextStyles.quizQuestion,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: quiz.options.length,
              itemBuilder: (context, index) {
                final option = quiz.options[index] as String;
                final isThisSelected = selectedOption == option;

                Color tileColor = AppColors.surfaceVariant;
                Color textColor = AppColors.textPrimary;

                if (isThisSelected) {
                  tileColor = AppColors.error;
                  textColor = Colors.white;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: InkWell(
                    onTap: isAnswered
                        ? null
                        : () {
                            ref
                                .read(quizControllerProvider.notifier)
                                .selectAnswer(option);
                          },
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: tileColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isThisSelected
                              ? AppColors.error
                              : AppColors.primary.withOpacity(0.15),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        option,
                        style: AppTextStyles.quizOption.copyWith(color: textColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
            if (isWrongAnswerSelected) ...[
              const SizedBox(height: 8),
              Text(
                "Oops! Try again! 🤖",
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  ref.read(quizControllerProvider.notifier).retry();
                },
                child: const Text("Try Again"),
              ),
            ],
          ],
        ),
      ),
    );

    if (isWrongAnswerSelected) {
      cardContent = cardContent
          .animate()
          .shake(hz: 8, amount: 6, duration: const Duration(milliseconds: 400));
    }

    return cardContent
        .animate()
        .fade(duration: 400.ms)
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0))
        .slideY(begin: 0.1, end: 0);
  }

  Widget _buildSuccessCard(dynamic quiz, String selectedOption) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.success.withOpacity(0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.success, width: 3),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.success,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              "Awesome Job! 🌟",
              style: AppTextStyles.displayMedium.copyWith(color: AppColors.success),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "You answered '$selectedOption' which is absolutely correct! Pip is so proud of you!",
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(quizControllerProvider.notifier).reset();
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
              child: const Text("Play Again"),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fade(duration: 400.ms)
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0))
        .slideY(begin: 0.1, end: 0);
  }
}
