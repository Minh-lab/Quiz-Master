import 'package:quiz_mater_apllication/src/features/subject_exem/domain/entity/exam.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/entity/exam_submission.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/repository/exam_repository.dart';

class ExamRepositoryIml extends IExamRepository {
  @override
  Future<ExamSubmissionEntity> calculateScore(
    ExamEntity exam,
    Map<int, int> answers,
  ) {
    // TODO: implement calculateScore
    throw UnimplementedError();
  }

  @override
  Future<void> getExamsDetail(String examId) {
    // TODO: implement getExamsDetail
    throw UnimplementedError();
  }
}
