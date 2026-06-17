import 'package:dartz/dartz.dart';
import 'package:quiz_mater_apllication/src/features/history/domain/entities/exam_history_entity.dart';
import 'package:quiz_mater_apllication/src/features/history/domain/repositories/history_repository.dart';

class SaveExamHistoryUseCase {
  final HistoryRepository repository;

  SaveExamHistoryUseCase(this.repository);

  Future<Either<String, void>> call(ExamHistoryEntity history) {
    return repository.saveExamHistory(history);
  }
}
