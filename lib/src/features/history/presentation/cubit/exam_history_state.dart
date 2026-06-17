import 'package:equatable/equatable.dart';
import 'package:quiz_mater_apllication/src/features/history/domain/entities/exam_history_entity.dart';

abstract class ExamHistoryState extends Equatable {
  const ExamHistoryState();

  @override
  List<Object?> get props => [];
}

class ExamHistoryInitial extends ExamHistoryState {}

class ExamHistoryLoading extends ExamHistoryState {}

class ExamHistoryLoaded extends ExamHistoryState {
  final List<ExamHistoryEntity> histories;

  const ExamHistoryLoaded({required this.histories});

  @override
  List<Object?> get props => [histories];
}

class ExamHistoryEmpty extends ExamHistoryState {}

class ExamHistoryError extends ExamHistoryState {
  final String message;

  const ExamHistoryError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ExamHistoryDeleting extends ExamHistoryState {
  final List<ExamHistoryEntity> currentHistories;

  const ExamHistoryDeleting({required this.currentHistories});

  @override
  List<Object?> get props => [currentHistories];
}

class ExamHistoryDeleteSuccess extends ExamHistoryState {
  final List<ExamHistoryEntity> currentHistories;

  const ExamHistoryDeleteSuccess({required this.currentHistories});

  @override
  List<Object?> get props => [currentHistories];
}
