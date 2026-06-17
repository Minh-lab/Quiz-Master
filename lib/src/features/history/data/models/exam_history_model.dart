import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_mater_apllication/src/features/history/domain/entities/exam_history_entity.dart';

class ExamHistoryModel extends ExamHistoryEntity {
  const ExamHistoryModel({
    required super.id,
    required super.uid,
    required super.examId,
    required super.examTitle,
    required super.subjectId,
    required super.subjectName,
    required super.score,
    required super.totalQuestions,
    required super.correctAnswers,
    required super.wrongAnswers,
    required super.skippedAnswers,
    required super.accuracy,
    required super.duration,
    required super.timeSpent,
    required super.submittedAt,
  });

  factory ExamHistoryModel.fromJson(Map<String, dynamic> json, String id) {
    return ExamHistoryModel(
      id: id,
      uid: json['uid'] ?? '',
      examId: json['examId'] ?? '',
      examTitle: json['examTitle'] ?? '',
      subjectId: json['subjectId'] ?? '',
      subjectName: json['subjectName'] ?? '',
      score: (json['score'] ?? 0).toDouble(),
      totalQuestions: json['totalQuestions'] ?? 0,
      correctAnswers: json['correctAnswers'] ?? 0,
      wrongAnswers: json['wrongAnswers'] ?? 0,
      skippedAnswers: json['skippedAnswers'] ?? 0,
      accuracy: (json['accuracy'] ?? 0).toDouble(),
      duration: json['duration'] ?? 0,
      timeSpent: json['timeSpent'] ?? 0,
      submittedAt: (json['submittedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'examId': examId,
      'examTitle': examTitle,
      'subjectId': subjectId,
      'subjectName': subjectName,
      'score': score,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'wrongAnswers': wrongAnswers,
      'skippedAnswers': skippedAnswers,
      'accuracy': accuracy,
      'duration': duration,
      'timeSpent': timeSpent,
      'submittedAt': Timestamp.fromDate(submittedAt),
    };
  }

  ExamHistoryEntity toEntity() {
    return ExamHistoryEntity(
      id: id,
      uid: uid,
      examId: examId,
      examTitle: examTitle,
      subjectId: subjectId,
      subjectName: subjectName,
      score: score,
      totalQuestions: totalQuestions,
      correctAnswers: correctAnswers,
      wrongAnswers: wrongAnswers,
      skippedAnswers: skippedAnswers,
      accuracy: accuracy,
      duration: duration,
      timeSpent: timeSpent,
      submittedAt: submittedAt,
    );
  }

  factory ExamHistoryModel.fromEntity(ExamHistoryEntity entity) {
    return ExamHistoryModel(
      id: entity.id,
      uid: entity.uid,
      examId: entity.examId,
      examTitle: entity.examTitle,
      subjectId: entity.subjectId,
      subjectName: entity.subjectName,
      score: entity.score,
      totalQuestions: entity.totalQuestions,
      correctAnswers: entity.correctAnswers,
      wrongAnswers: entity.wrongAnswers,
      skippedAnswers: entity.skippedAnswers,
      accuracy: entity.accuracy,
      duration: entity.duration,
      timeSpent: entity.timeSpent,
      submittedAt: entity.submittedAt,
    );
  }
}
