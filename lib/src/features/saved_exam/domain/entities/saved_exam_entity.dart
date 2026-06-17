import 'package:equatable/equatable.dart';

class SavedExamEntity extends Equatable {
  final String examId;
  final String title;
  final String subjectId;
  final int duration;
  final int totalQuestions;
  final DateTime savedAt;

  const SavedExamEntity({
    required this.examId,
    required this.title,
    required this.subjectId,
    required this.duration,
    required this.totalQuestions,
    required this.savedAt,
  });

  @override
  List<Object?> get props => [
        examId,
        title,
        subjectId,
        duration,
        totalQuestions,
        savedAt,
      ];
}
