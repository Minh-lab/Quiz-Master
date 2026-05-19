import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/data/models/exam.dart';

import 'package:quiz_mater_apllication/src/features/subject_exem/data/models/subject.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/data/services/subject_service/subject_service.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/entity/exam.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/entity/subject.dart';

class SubjectServiceIml implements SubjectService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<Either<dynamic, dynamic>> getSubjects() async {
    // TODO: implement getSubjects
    try {
      final subjectDoc = await firestore
          .collection('subjects')
          .orderBy('order')
          .get();
      final List<SubjectEntity> subjectsList = [];
      for (var doc in subjectDoc.docs) {
        final data = doc.data();
        data['id'] = doc.id;

        // 3. Đếm số lượng đề thi (Nên dùng AggregateQuery để tiết kiệm băng thông)
        // Lưu ý: aggregate count chỉ trả về con số, không tải toàn bộ document đề thi về
        final countQuery = await firestore
            .collection('exams')
            .where('subjectId', isEqualTo: doc.id)
            .count()
            .get();

        data['count_exams'] = countQuery.count ?? 0;

        subjectsList.add(SubjectModel.fromFireStore(data).toEntity());
      }

      return Right(subjectsList);
    } catch (e) {
      print('error $e');
      return Left(e);
    }
  }
}
