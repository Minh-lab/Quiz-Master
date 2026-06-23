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
    required super.type,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json, String documentId) {
    //  Xử lý an toàn cho type (mặc định trắc nghiệm nhiều phương án)
    final type = json['type'] as String? ?? 'multiple_choice';

    // Xử lý dynamic correctAnswer tùy theo type câu hỏi
    dynamic parsedCorrectAnswer;
    final rawCorrect = json['correct_answer'] ?? json['correctAnswer'];

    if (type == 'true_false' && rawCorrect is Map) {
      parsedCorrectAnswer = Map<String, bool>.from(rawCorrect);
    } else {
      parsedCorrectAnswer = rawCorrect?.toString() ?? '';
    }

    return QuestionModel(
      id: documentId,
      order: json['order'] as int? ?? 0,
      content: json['content'] as String? ?? '',
      imageUrl: (json['image_url'] ?? json['imageUrl']) as String?,
      options: json['options'] != null ? List<String>.from(json['options']) : [],
      correctAnswer: parsedCorrectAnswer,
      score: (json['score'] as num?)?.toDouble() ?? 0.25,
      explanation: (json['explanation'] ?? '') as String?,
      type: type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order': order,
      'content': content,
      'imageUrl': imageUrl,
      'options': options,
      'correctAnswer': correctAnswer,
      'score': score,
      'explanation': explanation,
      'type': type,
    };
  }

  factory QuestionModel.fromEntity(QuestionEntity entity) {
    return QuestionModel(
      id: entity.id,
      order: entity.order,
      content: entity.content,
      imageUrl: entity.imageUrl,
      options: entity.options,
      correctAnswer: entity.correctAnswer,
      score: entity.score,
      explanation: entity.explanation,
      type: entity.type,
    );
  }
}
