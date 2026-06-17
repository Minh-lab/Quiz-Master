import 'package:dartz/dartz.dart';
import 'package:quiz_mater_apllication/src/features/history/domain/entities/exam_history_entity.dart';

abstract class HistoryRepository {
  Future<Either<String, List<ExamHistoryEntity>>> getHistoryByUser();
  Future<Either<String, void>> deleteHistory(String historyId);
  Future<Either<String, void>> deleteMultipleHistory(List<String> historyIds);
  Future<Either<String, void>> saveExamHistory(ExamHistoryEntity history);
}
