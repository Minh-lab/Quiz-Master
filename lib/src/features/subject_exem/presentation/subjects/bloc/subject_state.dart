import 'package:equatable/equatable.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/entity/subject.dart';

// 1. Class cha nên extends Equatable để hỗ trợ so sánh trạng thái
abstract class SubjectState extends Equatable {
  const SubjectState();

  @override
  List<Object?> get props => [];
}

class SubjectInitial extends SubjectState {}

class SubjectLoading extends SubjectState {}

class SubjectLoaded extends SubjectState {
  final List<SubjectEntity>? subjects;


  const SubjectLoaded({this.subjects});

  @override
  List<Object?> get props => [subjects];
  SubjectLoaded copyWith({List<SubjectEntity>? subjects}) =>
      SubjectLoaded(subjects: subjects);
}

class SubjectError extends SubjectState {
  final String messageError;

  const SubjectError({required this.messageError});

  @override
  List<Object?> get props => [messageError];
}
