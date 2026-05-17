import 'package:quiz_mater_apllication/src/features/subject_exem/domain/entity/exam.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/entity/exam_submission.dart';

abstract class IExamRepository {
  Future<void> getExamsDetail(String examId);
  Future<ExamSubmissionEntity> calculateScore(
    ExamEntity exam,
    Map<int, int> answers,
  );
}
