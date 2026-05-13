import 'package:flutter/material.dart';
import 'package:quiz_mater_apllication/src/core/widgets/app_appbar.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/widgets/exam_card.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/widgets/subject_card.dart';

class ListExam extends StatelessWidget {
  final String subjectId;
  const ListExam({Key? key, required this.subjectId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar(title: 'Luyện đề môn $subjectId'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: ExamCard(
          title:
              'ĐỀ THI THPT QUỐC GIA MÔN TIẾNG ANH 2025',
          numberQuestion: '10',
          time: '10',
        ),
      ),
    );
  }
}
