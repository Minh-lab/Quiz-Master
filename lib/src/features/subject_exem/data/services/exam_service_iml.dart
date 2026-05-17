import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/data/models/exam.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/data/models/question.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/data/services/exam_service.dart';

class ExamServiceIml extends ExamService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Future<Either<dynamic, dynamic>> getExams(String examId) async {
    // TODO: implement getExams
    final examDoc = await firestore.collection('exams').doc(examId).get();
    final questionsQuery = await firestore
        .collection('exams')
        .doc(examId)
        .collection('questions')
        .get();
    final questionsList = questionsQuery.docs
        .map((doc) => QuestionModel.fromJson(doc.data(), doc.id))
        .toList();
    final examModel = ExamModel.fromJson(
      examDoc.data()!,
      examDoc.id,
      questionsList,
    );

    return Right(examModel);
  }

  @override
  Future<Either<dynamic, dynamic>> getExamsBySubject(String subjectId) async {
    try {
      final examDoc = await firestore
          .collection('exams')
          .where('subjectId', isEqualTo: subjectId)
          .get();
      final List<ExamModel> examList = examDoc.docs.map((doc) {
        return ExamModel.fromJson(doc.data(), doc.id, []);
      }).toList();
      print(examList);
      return Right(examList);
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<dynamic, dynamic>> getExamsDetail({
    required String examId,
    required String subjectId,
  }) async {
    // TODO: implement getExamsDetail
    try {
      final examDoc = await firestore.collection('exams').doc(examId).get();
      final listExamDetail = await firestore
          .collection('exams')
          .doc(examId)
          .collection('questions')
          .get();
      final questionsList = listExamDetail.docs
          .map((doc) => QuestionModel.fromJson(doc.data(), doc.id))
          .toList();
      final examModel = ExamModel.fromJson(
        examDoc.data()!,
        examDoc.id,
        questionsList,
      );
      return Right(examModel);
    } catch (e) {
      return Left(e);
    }
  }
}
