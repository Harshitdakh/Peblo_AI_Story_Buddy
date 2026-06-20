# Peblo AI Story Buddy — Children's Interactive Book & Quiz Application

An enterprise-ready, production-grade Flutter application crafted for children to read, listen, and play quizzes. Built as the Peblo Internship Challenge submission.

## Architecture

This application employs **Feature-First Architecture** combined with **Clean Architecture** patterns:
- **Presentation Layer**: Exposes UI components, styles, controllers, and states. Excludes any direct business logic.
- **Domain Layer**: Houses data models, interfaces/contracts, and business enums.
- **Data Layer**: Concrete implementations (TTS package integration, Asset repositories).

```
lib/
├── core/                         # Constants, context extensions, haptic utilities
├── features/
│   ├── audio/                    # TTS Contract, flutter_tts service, controllers
│   ├── buddy/                    # custom painter & interactive animation states
│   ├── quiz/                     # quiz serializable models, repository & controller
│   └── story/                    # primary story configuration layout Screen
├── routes/                       # named route configuration using go_router
├── shared/                       # reusable global components (floating cards, wave indicators)
├── theme/                        # design colors & custom font styling
└── main.dart
```

### Key Architectural decisions:
- **Riverpod for State Management**: Selected for its compile-time safety, unidirectional data flow, and capability to watch granular selectors (minimizing rebuilds).
- **TTS Service Abstraction Layer**: Swapping from the default `flutter_tts` package to high-fidelity cloud voices (e.g. ElevenLabs API) is achieved via `TTSService` interface bindings in `audio_controller.dart`.
- **Offline First**: Offline parsing is backed completely via packaged JSON assets.
- **60 FPS Performance**: Isolated repaint boundaries (`RepaintBoundary`) partition heavy canvas paints (`PipRobotPainter`) or repeating wave animations to limit context-wide redraw triggers.

---

## Technical Specifications

### Data-Driven Quiz Rendering
The quiz layout uses a `ListView.builder` combined with JSON dynamic option parsing to support variable option counts (2 to 6 options) without hardcoded size configurations.

### Transition Flow: Audio → Quiz
1. TTS begins speaking (Audio state: `speaking`).
2. When the speaker completes reading (Audio state: `completed`), an event listener triggers `quizController.loadQuiz()`.
3. The quiz container is revealed via a combined Fade, Scale, and Slide-Up animation.

### Build and Generation Commands

```bash
# Clean project build cache
flutter clean

# Fetch project dependencies
flutter pub get

# Execute test suite
flutter test

# Generate production APK bundle
flutter build apk --release
```

---

## AI Usage Disclosure

This codebase, folder structure, unit tests, custom painters, and animations were co-developed with an AI coding assistant (Gemini/Claude) using precise technical architecture guidelines for child-friendly production design.
