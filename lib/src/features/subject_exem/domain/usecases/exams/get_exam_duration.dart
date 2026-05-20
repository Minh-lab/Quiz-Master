import 'package:dartz/dartz.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/repository/exam_repository.dart';

class GetExamDurationUsecase {
  final IExamRepository repository;
  GetExamDurationUsecase({required this.repository});

  Future<Either> call(String examId) => repository.GetExamDuration(examId);
}
