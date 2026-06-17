import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_mater_apllication/src/features/saved_exam/domain/entities/saved_exam_entity.dart';

class SavedExamModel extends SavedExamEntity {
  const SavedExamModel({
    required super.examId,
    required super.title,
    required super.subjectId,
    required super.duration,
    required super.totalQuestions,
    required super.savedAt,
  });

  factory SavedExamModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SavedExamModel(
      examId: data['examId'] ?? '',
      title: data['title'] ?? 'Chưa cập nhật',
      subjectId: data['subjectId'] ?? '',
      duration: data['duration'] ?? 0,
      totalQuestions: data['totalQuestions'] ?? 0,
      savedAt: (data['savedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'examId': examId,
      'title': title,
      'subjectId': subjectId,
      'duration': duration,
      'totalQuestions': totalQuestions,
      'savedAt': Timestamp.fromDate(savedAt),
    };
  }

  factory SavedExamModel.fromEntity(SavedExamEntity entity) {
    return SavedExamModel(
      examId: entity.examId,
      title: entity.title,
      subjectId: entity.subjectId,
      duration: entity.duration,
      totalQuestions: entity.totalQuestions,
      savedAt: entity.savedAt,
    );
  }
}
