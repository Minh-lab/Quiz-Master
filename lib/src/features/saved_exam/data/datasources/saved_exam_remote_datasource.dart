import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_mater_apllication/src/features/saved_exam/data/models/saved_exam_model.dart';

abstract class SavedExamRemoteDataSource {
  Future<void> saveExam(String uid, SavedExamModel exam);
  Future<void> removeSavedExam(String uid, String examId);
  Future<bool> checkExamSaved(String uid, String examId);
  Future<List<SavedExamModel>> getSavedExams(String uid);
}

class SavedExamRemoteDataSourceImpl implements SavedExamRemoteDataSource {
  final FirebaseFirestore firestore;

  SavedExamRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> saveExam(String uid, SavedExamModel exam) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('saved_exams')
        .doc(exam.examId)
        .set(exam.toFirestore());
  }

  @override
  Future<void> removeSavedExam(String uid, String examId) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('saved_exams')
        .doc(examId)
        .delete();
  }

  @override
  Future<bool> checkExamSaved(String uid, String examId) async {
    final doc = await firestore
        .collection('users')
        .doc(uid)
        .collection('saved_exams')
        .doc(examId)
        .get();
    return doc.exists;
  }

  @override
  Future<List<SavedExamModel>> getSavedExams(String uid) async {
    final snapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection('saved_exams')
        .orderBy('savedAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => SavedExamModel.fromFirestore(doc))
        .toList();
  }
  
}
