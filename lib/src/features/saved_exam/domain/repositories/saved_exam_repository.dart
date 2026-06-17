import 'package:dartz/dartz.dart';

import 'package:quiz_mater_apllication/src/features/saved_exam/domain/entities/saved_exam_entity.dart';

abstract class SavedExamRepository {
  Future<Either<String, void>> saveExam(String uid, SavedExamEntity exam);
  Future<Either<String, void>> removeSavedExam(String uid, String examId);
  Future<Either<String, bool>> checkExamSaved(String uid, String examId);
  Future<Either<String, List<SavedExamEntity>>> getSavedExams(String uid);
}
