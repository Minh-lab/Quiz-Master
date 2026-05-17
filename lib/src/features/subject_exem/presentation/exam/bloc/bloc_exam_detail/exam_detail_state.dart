import 'package:quiz_mater_apllication/src/features/subject_exem/domain/entity/question.dart';

abstract class ExamDetailState {}

class ExamDetailInitial extends ExamDetailState {}

class ExamDetailLoading extends ExamDetailState {}

class ExamDetailLoaded extends ExamDetailState {
  final List<QuestionEntity> questions;
  ExamDetailLoaded({required this.questions});
}

class ExamDetailError extends ExamDetailState {
  final String messageError;
  ExamDetailError({required this.messageError});
}
