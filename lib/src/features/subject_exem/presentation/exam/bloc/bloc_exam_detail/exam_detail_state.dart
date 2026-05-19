import 'package:quiz_mater_apllication/src/features/subject_exem/domain/entity/question.dart';

abstract class ExamDetailState {}

class ExamDetailInitial extends ExamDetailState {}

class ExamDetailLoading extends ExamDetailState {}

class ExamDetailLoaded extends ExamDetailState {  
  final List<QuestionEntity> questions;
  final int currentIndex;
  final Map<int, int?>? selectedAnswers;

  ExamDetailLoaded({
    required this.questions,
    this.currentIndex = 0,
    this.selectedAnswers = const {},
  });

  ExamDetailLoaded copyWith({
    List<QuestionEntity>? questions,
    int? currentIndex,
    Map<int, int?>? selectedAnswers,
  }) {
    return ExamDetailLoaded(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
    );
  }
}

class ExamDetailError extends ExamDetailState {
  final String messageError;
  ExamDetailError({required this.messageError});
}
