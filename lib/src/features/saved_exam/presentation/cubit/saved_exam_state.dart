import 'package:equatable/equatable.dart';
import 'package:quiz_mater_apllication/src/features/saved_exam/domain/entities/saved_exam_entity.dart';

class SavedExamState extends Equatable {
  final bool isLoading;
  final List<SavedExamEntity> exams;
  final Set<String> savedExamIds;
  final String? error;
  final String? message;
  final String? lastActionExamId;

  const SavedExamState({
    this.isLoading = false,
    this.exams = const [],
    this.savedExamIds = const {},
    this.error,
    this.message,
    this.lastActionExamId,
  });

  SavedExamState copyWith({
    bool? isLoading,
    List<SavedExamEntity>? exams,
    Set<String>? savedExamIds,
    String? error,
    String? message,
    String? lastActionExamId,
    bool clearMessage = false,
  }) {
    return SavedExamState(
      isLoading: isLoading ?? this.isLoading,
      exams: exams ?? this.exams,
      savedExamIds: savedExamIds ?? this.savedExamIds,
      error: error,
      message: clearMessage ? null : (message ?? this.message),
      lastActionExamId: clearMessage ? null : (lastActionExamId ?? this.lastActionExamId),
    );
  }

  @override
  List<Object?> get props => [isLoading, exams, savedExamIds, error, message, lastActionExamId];
}
