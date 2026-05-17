abstract class ExamEvent {}

class LoadExamEvent extends ExamEvent {
  final String examId;
  LoadExamEvent({required this.examId});
}

class SelectAnswerEvent extends ExamEvent {
  final int questionIndex;
  final int answerIndex;
  SelectAnswerEvent(this.questionIndex, this.answerIndex);
}

class SubmitExamEvent extends ExamEvent {}

class TickTimerEvent extends ExamEvent {}
