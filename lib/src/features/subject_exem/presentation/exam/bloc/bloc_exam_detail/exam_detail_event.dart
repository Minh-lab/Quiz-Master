import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_list_exam/exam_event.dart';

abstract class ExamDetailEvent {}

class FetchExamDetailEvent extends ExamDetailEvent {
  final String examId;
  final String subjectId;
  FetchExamDetailEvent({required this.examId, required this.subjectId});
}

class SelectAnswerEvent extends ExamDetailEvent {
  final int questionIndex;
  final int? answerIndex;
  SelectAnswerEvent({required this.questionIndex, required this.answerIndex});
}

class ChangeQuestionEvent extends ExamDetailEvent {
  final int newIndex;
  ChangeQuestionEvent({required this.newIndex});
}

class TickTimerEvent extends ExamDetailEvent {}

class SubmitEvent extends ExamDetailEvent {}
