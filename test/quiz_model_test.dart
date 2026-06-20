import 'package:flutter_test/flutter_test.dart';
import 'package:peblo_ai_story_buddy/features/quiz/domain/models/quiz_model.dart';

void main() {
  group('QuizModel Tests', () {
    test('QuizModel parsing from JSON map works correctly', () {
      final jsonMap = {
        "question": "What colour was Pip the Robot's lost gear?",
        "options": ["Red", "Green", "Blue", "Yellow"],
        "answer": "Blue"
      };

      final quiz = QuizModel.fromJson(jsonMap);

      expect(quiz.question, equals("What colour was Pip the Robot's lost gear?"));
      expect(quiz.options, containsAllInOrder(["Red", "Green", "Blue", "Yellow"]));
      expect(quiz.answer, equals("Blue"));
    });

    test('QuizModel data driven options rendering compatibility check', () {
      final jsonMap = {
        "question": "Choose a number",
        "options": ["1", "2", "3", "4", "5", "6"],
        "answer": "3"
      };

      final quiz = QuizModel.fromJson(jsonMap);
      expect(quiz.options.length, equals(6));
    });
  });
}
