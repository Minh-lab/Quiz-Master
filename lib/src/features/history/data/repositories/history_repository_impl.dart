import 'package:dartz/dartz.dart';
import 'package:quiz_mater_apllication/src/features/history/data/datasources/history_remote_data_source.dart';
import 'package:quiz_mater_apllication/src/features/history/data/models/exam_history_model.dart';
import 'package:quiz_mater_apllication/src/features/history/domain/entities/exam_history_entity.dart';
import 'package:quiz_mater_apllication/src/features/history/domain/repositories/history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryRemoteDataSource remoteDataSource;

  HistoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<ExamHistoryEntity>>> getHistoryByUser() async {
    try {
      final models = await remoteDataSource.getHistoryByUser();
      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> deleteHistory(String historyId) async {
    try {
      await remoteDataSource.deleteHistory(historyId);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> deleteMultipleHistory(List<String> historyIds) async {
    try {
      await remoteDataSource.deleteMultipleHistory(historyIds);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> saveExamHistory(ExamHistoryEntity history) async {
    try {
      final model = ExamHistoryModel.fromEntity(history);
      await remoteDataSource.saveExamHistory(model);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
