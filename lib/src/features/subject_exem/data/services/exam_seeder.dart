import 'package:cloud_firestore/cloud_firestore.dart';

class ExamSeeder {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Chạy hàm này 1 lần duy nhất để tạo dữ liệu mẫu trên Firebase
  Future<void> seedDummyExam() async {
    try {
      // 1. Tạo Document cho Đề thi (Collection: exams)
      DocumentReference examRef = _firestore.collection('exams').doc('exam_toan_01');

      await examRef.set({
        'subjectId': 'math',
        'title': 'Đề thi thử THPT QG Môn Toán 2024',
        'duration': 90,
        'totalQuestions': 50,
        'status': 'published',
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('✅ Đã tạo thông tin đề thi thành công!');

      // 2. Tạo 50 câu hỏi mẫu (Sub-collection: questions nằm trong exam_toan_01)
      CollectionReference questionsRef = examRef.collection('questions');

      for (int i = 1; i <= 50; i++) {
        // Dùng batch hoặc gán từng câu
        await questionsRef.add({
          'order': i,
          'content': 'Đây là nội dung câu hỏi số $i. Giải phương trình x + $i = 0',
          'imageUrl': null,
          'options': [
            'A. x = $i',
            'B. x = -$i',
            'C. x = 0',
            'D. Vô nghiệm',
          ],
          'correctAnswer': 1, // Đáp án B đúng
          'score': 0.2,
          'explanation': 'Chuyển vế đổi dấu ta có x = -$i',
        });
      }

      print('✅ Đã tạo xong 50 câu hỏi mẫu!');
    } catch (e) {
      print('❌ Lỗi khi chèn dữ liệu: $e');
    }
  }
}
