import 'package:equatable/equatable.dart';

class AttemptEntity extends Equatable {
  final String? id;
  final String userId;
  final String examId;
  final String subjectId;
  final String examTitle;
  final double score;
  final double part1Score;
  final double part2Score;
  final double part3Score;
  final int totalQuestions;
  final int answeredQuestionsCount;
  final int correctAnswersCount;
  final DateTime startedAt;
  final DateTime submittedAt;
  final int durationUsedSeconds;
  final Map<int, dynamic> answers;

  const AttemptEntity({
    this.id,
    required this.userId,
    required this.examId,
    required this.subjectId,
    required this.examTitle,
    required this.score,
    required this.part1Score,
    required this.part2Score,
    required this.part3Score,
    required this.totalQuestions,
    required this.answeredQuestionsCount,
    required this.correctAnswersCount,
    required this.startedAt,
    required this.submittedAt,
    required this.durationUsedSeconds,
    required this.answers,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        examId,
        subjectId,
        examTitle,
        score,
        part1Score,
        part2Score,
        part3Score,
        totalQuestions,
        answeredQuestionsCount,
        correctAnswersCount,
        startedAt,
        submittedAt,
        durationUsedSeconds,
        answers,
      ];
}
