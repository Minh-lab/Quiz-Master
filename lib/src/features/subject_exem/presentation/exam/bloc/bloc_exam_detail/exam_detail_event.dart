import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_list_exam/exam_event.dart';

abstract class ExamDetailEvent {}

class FetchExamDetailEvent extends ExamDetailEvent {
  final String examId;
  final String subjectId;
  FetchExamDetailEvent({required this.examId, required this.subjectId});
}

class TickTimerEvent extends ExamDetailEvent {}

class SubmitEvent extends ExamDetailEvent {}
