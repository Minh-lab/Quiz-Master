import 'package:dartz/dartz.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/data/services/exam_service/exam_service.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/data/services/exam_service/exam_service_iml.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/entity/exam.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/entity/exam_submission.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/repository/exam_repository.dart';

class ExamRepositoryIml extends IExamRepository {
  ExamService service;
  ExamRepositoryIml({required this.service});
  @override
  Future<ExamSubmissionEntity> calculateScore(
    ExamEntity exam,
    Map<int, int> answers,
  ) {
    // TODO: implement calculateScore
    throw UnimplementedError();
  }

  @override
  Future<Either> getExamsDetail({
    required String examId,
    required String subjectId,
  }) {
    // TODO: implement getExamsDetail
    return ExamServiceIml().getExamsDetail(
      examId: examId,
      subjectId: subjectId,
    );
  }

  @override
  Future<Either<dynamic, dynamic>> getExams() async {
    // TODO: implement getExams
    return await ExamServiceIml().getExams('exam_toan_thptqg_2024');
  }

  @override
  Future<Either<dynamic, dynamic>> getExamsBySubject(String subjectId) {
    // TODO: implement getExamsBySubject
    return ExamServiceIml().getExamsBySubject(subjectId);
  }
}
