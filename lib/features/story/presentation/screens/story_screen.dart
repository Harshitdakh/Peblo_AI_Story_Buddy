import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peblo_ai_story_buddy/core/core.dart';
import 'package:peblo_ai_story_buddy/features/audio/domain/enums/audio_state.dart';
import 'package:peblo_ai_story_buddy/features/audio/presentation/controllers/audio_controller.dart';
import 'package:peblo_ai_story_buddy/features/buddy/presentation/widgets/buddy_widget.dart';
import 'package:peblo_ai_story_buddy/features/quiz/presentation/controllers/quiz_controller.dart';
import 'package:peblo_ai_story_buddy/features/quiz/presentation/widgets/quiz_section.dart';
import 'package:peblo_ai_story_buddy/shared/widgets/animated_sound_wave.dart';
import 'package:peblo_ai_story_buddy/shared/widgets/floating_story_card.dart';
import 'package:peblo_ai_story_buddy/shared/widgets/pulse_button.dart';
import 'package:peblo_ai_story_buddy/theme/theme.dart';

/// StoryScreen - The main viewport layout of the Peblo AI Story Buddy.
/// Supports scaling dynamically via LayoutBuilder to prevent overflow on tablets or small devices.
class StoryScreen extends ConsumerWidget {
  const StoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioControllerProvider);

    // Watch quiz visibility: automatically reveal quiz when TTS completes
    final showQuiz = audioState.isCompleted || ref.watch(quizControllerProvider) is! QuizInitial;

    // Trigger quiz loading when speech completes
    ref.listen<AudioState>(audioControllerProvider, (previous, next) {
      if (next == AudioState.completed) {
        ref.read(quizControllerProvider.notifier).loadQuiz();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Peblo Story Buddy"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth >= 600;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? AppConstants.spacingXl : AppConstants.spacingMd,
                vertical: AppConstants.spacingMd,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Buddy Character Widget
                  const SizedBox(height: 20),
                  const BuddyWidget(),
                  const SizedBox(height: 24),

                  // TTS Interactive controls
                  _buildAudioStatusIndicator(context, ref, audioState),
                  const SizedBox(height: 20),

                  // Floating Story Card
                  const FloatingStoryCard(
                    title: AppConstants.storyTitle,
                    text: AppConstants.storyText,
                  ),
                  const SizedBox(height: 20),

                  // Quiz Reveal
                  if (showQuiz) ...[
                    const QuizSection(),
                    const SizedBox(height: 40),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAudioStatusIndicator(
    BuildContext context,
    WidgetRef ref,
    AudioState state,
  ) {
    switch (state) {
      case AudioState.idle:
        return PulseButton(
          onPressed: () {
            ref.read(audioControllerProvider.notifier).readStory(AppConstants.storyText);
          },
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
              SizedBox(width: 8),
              Text("Read Me A Story"),
            ],
          ),
        );
      case AudioState.preparing:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              SizedBox(width: 12),
              Text(
                "Preparing Voice Engine...",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      case AudioState.speaking:
        return Column(
          children: [
            const AnimatedSoundWave(),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                ref.read(audioControllerProvider.notifier).stop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                minimumSize: const Size(120, 44),
              ),
              child: const Text("Stop Listening"),
            ),
          ],
        );
      case AudioState.completed:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.15),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_rounded, color: AppColors.success),
              SizedBox(width: 8),
              Text(
                "Story Completed!",
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.success),
              ),
            ],
          ),
        );
      case AudioState.error:
        return Card(
          color: AppColors.error.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.error, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  "Oh no! TTS playback failed. 🤖",
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.error),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    ref.read(audioControllerProvider.notifier).retry(AppConstants.storyText);
                  },
                  child: const Text("Retry Speaking"),
                ),
              ],
            ),
          ),
        );
    }
  }
}
