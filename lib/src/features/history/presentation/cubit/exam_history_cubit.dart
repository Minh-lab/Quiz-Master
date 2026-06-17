import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_mater_apllication/src/features/history/domain/entities/exam_history_entity.dart';
import 'package:quiz_mater_apllication/src/features/history/domain/usecases/delete_exam_history_usecase.dart';
import 'package:quiz_mater_apllication/src/features/history/domain/usecases/get_exam_history_usecase.dart';
import 'exam_history_state.dart';

class ExamHistoryCubit extends Cubit<ExamHistoryState> {
  final GetExamHistoryUseCase getHistoryUseCase;
  final DeleteExamHistoryUseCase deleteHistoryUseCase;

  List<ExamHistoryEntity> _currentHistories = [];

  ExamHistoryCubit({
    required this.getHistoryUseCase,
    required this.deleteHistoryUseCase,
  }) : super(ExamHistoryInitial());

  Future<void> fetchHistory() async {
    emit(ExamHistoryLoading());
    final result = await getHistoryUseCase();

    result.fold(
      (error) => emit(ExamHistoryError(message: error)),
      (histories) {
        _currentHistories = histories;
        if (histories.isEmpty) {
          emit(ExamHistoryEmpty());
        } else {
          emit(ExamHistoryLoaded(histories: histories));
        }
      },
    );
  }

  Future<void> deleteHistory(String historyId) async {
    // Lưu lại trạng thái hiện tại
    final previousState = state;
    emit(ExamHistoryDeleting(currentHistories: _currentHistories));

    final result = await deleteHistoryUseCase(historyId);

    result.fold(
      (error) {
        // Phục hồi lại trạng thái cũ và báo lỗi
        emit(ExamHistoryError(message: error));
        if (previousState is ExamHistoryLoaded) {
          emit(ExamHistoryLoaded(histories: _currentHistories));
        }
      },
      (_) {
        // Cập nhật lại danh sách local
        _currentHistories.removeWhere((item) => item.id == historyId);
        emit(ExamHistoryDeleteSuccess(currentHistories: _currentHistories));
        
        if (_currentHistories.isEmpty) {
          emit(ExamHistoryEmpty());
        } else {
          emit(ExamHistoryLoaded(histories: _currentHistories));
        }
      },
    );
  }
}
