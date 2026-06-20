import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:peblo_ai_story_buddy/core/core.dart';
import 'package:peblo_ai_story_buddy/theme/theme.dart';

/// A card housing the story text that slowly floats vertically.
class FloatingStoryCard extends StatelessWidget {
  const FloatingStoryCard({
    super.key,
    required this.title,
    required this.text,
  });

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: AppTextStyles.storyTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              text,
              style: AppTextStyles.storyText,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .moveY(
          begin: 0,
          end: -6,
          duration: 2000.ms,
          curve: Curves.easeInOut,
        );
  }
}
