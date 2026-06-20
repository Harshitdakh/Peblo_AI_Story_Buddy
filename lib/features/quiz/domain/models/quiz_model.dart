import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_model.freezed.dart';
part 'quiz_model.g.dart';

/// Immutable data model for a quiz question.
///
/// Uses [freezed] for value equality and [json_serializable] for JSON parsing.
/// Data-driven: [options] is a [List<String>] — the renderer supports any
/// count (2–6+) without code changes.
@freezed
class QuizModel with _$QuizModel {
  const factory QuizModel({
    required String question,
    required List<String> options,
    required String answer,
  }) = _QuizModel;

  factory QuizModel.fromJson(Map<String, dynamic> json) =>
      _$QuizModelFromJson(json);
}
