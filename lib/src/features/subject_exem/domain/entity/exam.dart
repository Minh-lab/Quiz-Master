import 'package:equatable/equatable.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/entity/exam_submission.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/entity/question.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/repository/exam_repository.dart';

class ExamEntity extends Equatable {
  final String id;
  final String subjectId;
  final String title;
  final int duration;
  final int totalQuestions;
  final List<QuestionEntity> questions;

  const ExamEntity({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.duration,
    required this.totalQuestions,
    required this.questions,
  });

  ExamEntity clone() {
    return ExamEntity(
      id: id,
      subjectId: subjectId,
      title: title,
      duration: duration,
      totalQuestions: totalQuestions,
      questions: questions,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    subjectId,
    title,
    duration,
    totalQuestions,
    questions,
  ];
}
