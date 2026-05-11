import 'package:flutter/material.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/widgets/menu.dart';

class ExemSubjectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 100),
        child: SingleChildScrollView(
          child: Center(child: MenuCard()),
        ),
      ),
    );
  }
} 
