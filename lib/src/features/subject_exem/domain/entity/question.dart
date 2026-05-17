import 'package:equatable/equatable.dart';

class QuestionEntity extends Equatable {
  final String id;
  final int order;
  final String content;
  final String? imageUrl;
  final List<String> options;
  final int correctAnswer;
  final double score;
  final String? explanation;

  const QuestionEntity({
    required this.id,
    required this.order,
    required this.content,
    required this.imageUrl,
    required this.options,
    required this.correctAnswer,
    required this.score,
    required this.explanation,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    order,
    content,
    imageUrl,
    options,
    correctAnswer,
    score,
    explanation,
  ];
}
