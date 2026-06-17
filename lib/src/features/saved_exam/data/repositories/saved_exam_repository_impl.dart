import 'package:dartz/dartz.dart';

import 'package:quiz_mater_apllication/src/features/saved_exam/data/datasources/saved_exam_remote_datasource.dart';
import 'package:quiz_mater_apllication/src/features/saved_exam/data/models/saved_exam_model.dart';
import 'package:quiz_mater_apllication/src/features/saved_exam/domain/entities/saved_exam_entity.dart';
import 'package:quiz_mater_apllication/src/features/saved_exam/domain/repositories/saved_exam_repository.dart';

class SavedExamRepositoryImpl implements SavedExamRepository {
  final SavedExamRemoteDataSource remoteDataSource;

  SavedExamRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, void>> saveExam(String uid, SavedExamEntity exam) async {
    try {
      final model = SavedExamModel.fromEntity(exam);
      await remoteDataSource.saveExam(uid, model);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> removeSavedExam(String uid, String examId) async {
    try {
      await remoteDataSource.removeSavedExam(uid, examId);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> checkExamSaved(String uid, String examId) async {
    try {
      final isSaved = await remoteDataSource.checkExamSaved(uid, examId);
      return Right(isSaved);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<SavedExamEntity>>> getSavedExams(String uid) async {
    try {
      final models = await remoteDataSource.getSavedExams(uid);
      return Right(models);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
