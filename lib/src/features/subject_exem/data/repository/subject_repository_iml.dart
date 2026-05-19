import 'package:dartz/dartz.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/data/services/subject_service/subject_service.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/repository/subject_repository.dart';

class SubjectRepositoryIml implements ISubjectRepository {
  SubjectService subjectService;

  SubjectRepositoryIml({required this.subjectService});
  @override
  Future<Either<dynamic, dynamic>> getSubjects() async {
    // TODO: implement getSubjects
    return await subjectService.getSubjects();
  }

}
