import 'package:dartz/dartz.dart';
import 'package:quiz_mater_apllication/src/features/history/domain/repositories/history_repository.dart';

class DeleteExamHistoryUseCase {
  final HistoryRepository repository;

  DeleteExamHistoryUseCase(this.repository);

  Future<Either<String, void>> call(String historyId) {
    return repository.deleteHistory(historyId);
  }
}
