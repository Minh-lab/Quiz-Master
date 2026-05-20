import 'package:dartz/dartz.dart';

abstract class ExamService {
  Future<Either> getExams(String examId);
  Future<Either> getExamsDetail({
    required String examId,
    required String subjectId,
  });
  Future<Either> getExamsBySubject(String subjectId);
  Future<Either> GetExamDuration(String examId);
}
