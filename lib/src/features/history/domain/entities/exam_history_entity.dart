import 'package:equatable/equatable.dart';

class ExamHistoryEntity extends Equatable {
  final String id;
  final String uid;
  final String examId;
  final String examTitle;
  final String subjectId;
  final String subjectName;
  final double score;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final int skippedAnswers;
  final double accuracy;
  final int duration; // Thời gian tối đa của bài thi (giây)
  final int timeSpent; // Thời gian đã làm (giây)
  final DateTime submittedAt;

  const ExamHistoryEntity({
    required this.id,
    required this.uid,
    required this.examId,
    required this.examTitle,
    required this.subjectId,
    required this.subjectName,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.skippedAnswers,
    required this.accuracy,
    required this.duration,
    required this.timeSpent,
    required this.submittedAt,
  });

  @override
  List<Object?> get props => [
        id,
        uid,
        examId,
        examTitle,
        subjectId,
        subjectName,
        score,
        totalQuestions,
        correctAnswers,
        wrongAnswers,
        skippedAnswers,
        accuracy,
        duration,
        timeSpent,
        submittedAt,
      ];
}
