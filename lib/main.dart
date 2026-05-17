import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_mater_apllication/firebase_options.dart';
import 'package:quiz_mater_apllication/src/core/router/app_router.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_theme.dart';
import 'package:quiz_mater_apllication/src/core/widgets/intro_screen.dart';
import 'package:quiz_mater_apllication/src/core/widgets/splash.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/pages/exem_subject_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
    );
  }
}
