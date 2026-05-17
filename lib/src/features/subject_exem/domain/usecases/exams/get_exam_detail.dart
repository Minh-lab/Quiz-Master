import 'package:dartz/dartz.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/repository/exam_repository.dart';

class GetExamDetailUseCase {
  IExamRepository repository;
  GetExamDetailUseCase({required this.repository});

  Future<Either> call({
    required String examId,
    required String subjectId,
  }) async {
    return await repository.getExamsDetail(
      examId: examId,
      subjectId: subjectId,
    );
  }
}
