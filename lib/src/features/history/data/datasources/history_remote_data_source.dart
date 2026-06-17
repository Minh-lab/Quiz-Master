import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_mater_apllication/src/features/history/data/models/exam_history_model.dart';

abstract class HistoryRemoteDataSource {
  Future<List<ExamHistoryModel>> getHistoryByUser();
  Future<void> deleteHistory(String historyId);
  Future<void> deleteMultipleHistory(List<String> historyIds);
  Future<void> saveExamHistory(ExamHistoryModel historyModel);
}

class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Người dùng chưa đăng nhập');
    return user.uid;
  }

  @override
  Future<List<ExamHistoryModel>> getHistoryByUser() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(_uid)
          .collection('exam_history')
          .orderBy('submittedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => ExamHistoryModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi tải lịch sử: $e');
    }
  }

  @override
  Future<void> deleteHistory(String historyId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('exam_history')
          .doc(historyId)
          .delete();
    } catch (e) {
      throw Exception('Lỗi khi xóa lịch sử: $e');
    }
  }

  @override
  Future<void> deleteMultipleHistory(List<String> historyIds) async {
    try {
      final batch = _firestore.batch();
      final collectionRef = _firestore
          .collection('users')
          .doc(_uid)
          .collection('exam_history');

      for (var id in historyIds) {
        batch.delete(collectionRef.doc(id));
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Lỗi khi xóa nhiều lịch sử: $e');
    }
  }

  @override
  Future<void> saveExamHistory(ExamHistoryModel historyModel) async {
    try {
      final collectionRef = _firestore
          .collection('users')
          .doc(_uid)
          .collection('exam_history');
      
      // Nếu có id rồi thì dùng, chưa có thì tạo mới
      if (historyModel.id.isNotEmpty) {
        await collectionRef.doc(historyModel.id).set(historyModel.toJson());
      } else {
        await collectionRef.add(historyModel.toJson());
      }
    } catch (e) {
      throw Exception('Lỗi khi lưu lịch sử: $e');
    }
  }
}
