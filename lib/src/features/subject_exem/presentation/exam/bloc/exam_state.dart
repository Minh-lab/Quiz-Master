import 'package:equatable/equatable.dart';

enum ExamStatus { initial, loading, loaded, error, submitted }

class ExamState extends Equatable {
  final ExamStatus status;
  // TODO: Add ExamEntity exam; khi tạo xong Domain
  final Map<int, int> selectedAnswers;
  final String timeLeft;
  final String? errorMessage;

  const ExamState({
    this.status = ExamStatus.initial,
    this.selectedAnswers = const {},
    this.timeLeft = '00:00',
    this.errorMessage,
  });

  ExamState copyWith({
    ExamStatus? status,
    Map<int, int>? selectedAnswers,
    String? timeLeft,
    String? errorMessage,
  }) {
    return ExamState(
      status: status ?? this.status,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      timeLeft: timeLeft ?? this.timeLeft,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedAnswers,
        timeLeft,
        errorMessage,
      ];
}
