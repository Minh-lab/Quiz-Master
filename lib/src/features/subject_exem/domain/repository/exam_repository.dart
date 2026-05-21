import 'package:dartz/dartz.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/entity/exam.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/entity/exam_submission.dart';

abstract class IExamRepository {
  Future<Either> getExams();
  Future<Either> getExamsBySubject(String subjectId);
  Future<Either> getExamsDetail({
    required String examId,
    required String subjectId,
  });
  Future<ExamSubmissionEntity> calculateScore(
    ExamEntity exam,
    Map<int, int> answers,
  );

}
