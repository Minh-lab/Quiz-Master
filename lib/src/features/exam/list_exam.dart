import 'package:flutter/material.dart';
import 'package:quiz_mater_apllication/src/core/widgets/app_appbar.dart';

class ListExam extends StatelessWidget {
  final String subjectId;
  const ListExam({Key? key, required this.subjectId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppAppbar(title: 'Luyện đề môn $subjectId'),
    );
  }



}
