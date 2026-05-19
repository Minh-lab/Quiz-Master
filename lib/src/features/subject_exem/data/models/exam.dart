import 'package:quiz_mater_apllication/src/features/subject_exem/data/models/question.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/entity/exam.dart';

class ExamModel extends ExamEntity {
  ExamModel({
    required super.id,
    required super.subjectId,
    required super.title,
    required super.duration,
    required super.totalQuestions,
    required super.questions,
  });

  factory ExamModel.fromFireStore(
    Map<String, dynamic> json,
    String documentId,
    List<QuestionModel> questionList,
  ) => ExamModel(
    id: documentId,
    subjectId: json['subjectId']?.toString() ?? '',
    title: json['title']?.toString() ?? '',
    duration: (json['duration'] as num?)?.toInt() ?? 0,
    totalQuestions: (json['totalQuestions'] as num?)?.toInt() ?? 0,
    questions: questionList,
  );
}
