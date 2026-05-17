import 'package:quiz_mater_apllication/src/features/subject_exem/domain/entity/question.dart';

class QuestionModel extends QuestionEntity {
  const QuestionModel({
    required super.id,
    required super.order,
    required super.content,
    super.imageUrl,
    required super.options,
    required super.correctAnswer,
    required super.score,
    super.explanation,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json, String documentId) {
    return QuestionModel(
      id: documentId,
      order: json['order'] as int? ?? 0,
      content: json['content'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      options: List<String>.from(json['options']) ?? [],
      correctAnswer: json['correctAnswer'] as int ?? 0,
      score: json['score'] as double ?? 0.0,
      explanation: json['explanation'] as String ?? '',
    );
  }
}
