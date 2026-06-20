import 'package:go_router/go_router.dart';
import 'package:peblo_ai_story_buddy/features/story/presentation/screens/story_screen.dart';

/// Application router.
///
/// [GoRouter] supports deep-link ready navigation and integrates cleanly with
/// Riverpod.  The instance is created once and reused.
final appRouter = GoRouter(
  initialLocation: AppRoutes.story,
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: AppRoutes.story,
      name: AppRoutes.storyName,
      builder: (context, state) => const StoryScreen(),
    ),
  ],
);

/// Route path constants — prevents typos at call sites.
abstract final class AppRoutes {
  static const String story = '/';
  static const String storyName = 'story';
}
