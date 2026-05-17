import 'package:quiz_mater_apllication/src/features/subject_exem/domain/entity/exam.dart';

abstract class ExamState {}

class ExamInitial extends ExamState {}

class ExamLoading extends ExamState {}

class ExamLoaded extends ExamState {
  final List<ExamEntity> exams;
  ExamLoaded({required this.exams});
}

class ExamError extends ExamState {
  String messageError;
  ExamError({required this.messageError});
}
