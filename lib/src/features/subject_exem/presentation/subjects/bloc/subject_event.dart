abstract class SubjectEvent {}

class FetchSubjectEvent extends SubjectEvent {}
class GetCountExamSubjectEvent extends SubjectEvent {
  final String subjectId;
  GetCountExamSubjectEvent({required this.subjectId});
}
