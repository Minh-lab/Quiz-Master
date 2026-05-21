import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/data/models/exam.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/data/models/question.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/data/services/exam_service/exam_service.dart';

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
    final examModel = ExamModel.fromFireStore(
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
        return ExamModel.fromFireStore(doc.data(), doc.id, []);
      }).toList();
      // print(examList);
      return Right(examList);
    } catch (e) {
      print(e);
      return Left(e);
    }
  }

  @override
  @override
  Future<Either<dynamic, dynamic>> getExamsDetail({
    required String examId,
    required String subjectId,
  }) async {
    try {
      print('getExamsDetail');
      final examDoc = await firestore.collection('exams').doc(examId).get();
      if (!examDoc.exists) return Left(Exception('Exam not found'));

      final examData = examDoc.data()!;
      List<QuestionModel> questionsList = [];

      if (examData.containsKey('questions') && examData['questions'] is List) {
        final List<dynamic> rawQuestions = examData['questions'];
        questionsList = rawQuestions
            .map(
              (q) => QuestionModel.fromJson(
                Map<String, dynamic>.from(q),
                q['id'] ?? '',
              ),
            )
            .toList();
      } else {
        // Tương thích ngược: Đọc từ Subcollection cũ
        final listExamDetail = await firestore
            .collection('exams')
            .doc(examId)
            .collection('questions')
            .orderBy('order', descending: false)
            .get();
        questionsList = listExamDetail.docs
            .map((doc) => QuestionModel.fromJson(doc.data(), doc.id))
            .toList();
      }

      // Sắp xếp lại tăng dần theo 'order'
      questionsList.sort((a, b) => a.order.compareTo(b.order));

      return Right(questionsList);
    } catch (e) {
      return Left(e);
    }
  }


}
