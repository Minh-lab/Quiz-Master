import 'package:flutter/material.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_theme.dart';
import 'package:quiz_mater_apllication/src/core/widgets/splash.dart';

class Exam {
  final String name;
  final double score;
  const Exam({required this.name, required this.score});
}

void main() {
  runApp(const MyApp());
  Exam exem1 = const Exam(name: 'Math', score: 100);
  Exam exem2 = const Exam(name: 'Math', score: 100);
  print(exem1.hashCode);
  print(exem2.hashCode);
  print(exem1 == exem2);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      home: const Splash(),
    );
  }
}
