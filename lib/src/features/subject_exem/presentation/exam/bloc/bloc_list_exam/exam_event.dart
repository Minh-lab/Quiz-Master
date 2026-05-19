abstract class ExamEvent {}

class FetchExamPreviewEvent extends ExamEvent {
  final String subjectId;
  FetchExamPreviewEvent({required this.subjectId});
}

// class FetchExamDetailEvent extends ExamEvent {
//   final String examId;
//   FetchExamDetailEvent({required this.examId});
// }

class SelectAnswerEvent extends ExamEvent {
  final int questionIndex;
  final int answerIndex;
  SelectAnswerEvent(this.questionIndex, this.answerIndex);
}

class SubmitExamEvent extends ExamEvent {}

class TickTimerEvent extends ExamEvent {}
