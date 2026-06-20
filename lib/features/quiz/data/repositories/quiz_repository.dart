import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:peblo_ai_story_buddy/core/core.dart';
import 'package:peblo_ai_story_buddy/features/quiz/domain/models/quiz_model.dart';

/// Repository responsible for loading and parsing quiz data.
///
/// Abstracted behind an interface so tests can inject a [MockQuizRepository].
abstract class QuizRepository {
  Future<QuizModel> loadQuiz();
}

/// Loads [QuizModel] from the bundled JSON asset.
///
/// Using [rootBundle] ensures the asset is loaded from the compiled APK,
/// working offline with zero network dependency.
class AssetQuizRepository implements QuizRepository {
  @override
  Future<QuizModel> loadQuiz() async {
    final jsonString =
        await rootBundle.loadString(AppConstants.quizJsonPath);
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return QuizModel.fromJson(json);
  }
}
