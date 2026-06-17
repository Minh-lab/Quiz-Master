import 'package:dartz/dartz.dart';
import 'package:quiz_mater_apllication/src/features/history/domain/entities/exam_history_entity.dart';
import 'package:quiz_mater_apllication/src/features/history/domain/repositories/history_repository.dart';

class GetExamHistoryUseCase {
  final HistoryRepository repository;

  GetExamHistoryUseCase(this.repository);

  Future<Either<String, List<ExamHistoryEntity>>> call() {
    return repository.getHistoryByUser();
  }
}
