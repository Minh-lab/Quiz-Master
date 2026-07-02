import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_mater_apllication/app/di/injection_container.dart';
import 'package:quiz_mater_apllication/firebase_options.dart';
import 'package:quiz_mater_apllication/src/core/router/app_router.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_theme.dart';
import 'package:quiz_mater_apllication/src/core/widgets/intro_screen.dart';
import 'package:quiz_mater_apllication/src/core/widgets/splash.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/data/services/exam_service/exam_service_iml.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/usecases/exams/get_exams_by_subject_usecase.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_exam_detail/exam_detail_bloc.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_list_exam/exam_bloc.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/subjects/pages/exem_subject_screen.dart';
import 'package:quiz_mater_apllication/src/core/theme/bloc/theme_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await init();
  testData();
  runApp(MyApp());
}

void testData() async {
  Either data = await ExamServiceIml().getExamsBySubject('math');
  data.fold((failure) => print(failure.message), (exams) => print(exams));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ExamBloc>()),
        BlocProvider.value(value: sl<AuthBloc>()),
        BlocProvider(create: (context) => sl<ThemeCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'Flutter Demo',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
