import 'package:dartz/dartz.dart';

import 'package:quiz_mater_apllication/src/features/saved_exam/domain/entities/saved_exam_entity.dart';
import 'package:quiz_mater_apllication/src/features/saved_exam/domain/repositories/saved_exam_repository.dart';

class SaveExamUseCase {
  final SavedExamRepository repository;

  SaveExamUseCase(this.repository);

  Future<Either<String, void>> call(String uid, SavedExamEntity exam) {
    return repository.saveExam(uid, exam);
  }
}

class RemoveSavedExamUseCase {
  final SavedExamRepository repository;

  RemoveSavedExamUseCase(this.repository);

  Future<Either<String, void>> call(String uid, String examId) {
    return repository.removeSavedExam(uid, examId);
  }
}

class CheckExamSavedUseCase {
  final SavedExamRepository repository;

  CheckExamSavedUseCase(this.repository);

  Future<Either<String, bool>> call(String uid, String examId) {
    return repository.checkExamSaved(uid, examId);
  }
}

class GetSavedExamsUseCase {
  final SavedExamRepository repository;

  GetSavedExamsUseCase(this.repository);

  Future<Either<String, List<SavedExamEntity>>> call(String uid) {
    return repository.getSavedExams(uid);
  }
}
