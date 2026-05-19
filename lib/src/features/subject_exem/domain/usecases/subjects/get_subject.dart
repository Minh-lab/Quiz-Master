import 'package:dartz/dartz.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/repository/subject_repository.dart';

class GetSubjectUsecase {
  ISubjectRepository repository;
  GetSubjectUsecase({required this.repository});

  Future<Either> call() async => await repository.getSubjects();
}
