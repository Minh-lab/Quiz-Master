import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_mater_apllication/app/di/injection_container.dart';
import 'package:quiz_mater_apllication/src/core/router/go_router_adapter.dart';
import 'package:quiz_mater_apllication/src/core/widgets/intro_screen.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/pages/sign_in/signin_screen.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/pages/sign_up.dart/sign_up_screen.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/entity/exam.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_exam_detail/exam_detail_bloc.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_exam_detail/exam_detail_event.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_exam_detail/exam_detail_state.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/pages/exam_detail_screen.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/pages/list_exam_screen.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/home/home_screen.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/subjects/bloc/subject_bloc.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/subjects/bloc/subject_event.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/subjects/pages/exem_subject_screen.dart';

class AppRouter {
  static const String subjectById = '/subject/:subjectId';
  static const String home = '/home';
  static const String intro = '/intro';
  static const String exam = '/exam';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot_password';

  static const String examById = '/subject/:subjectId/exam/:examId';

  static String subjectDetail(String subjectId) => '/subject/$subjectId';

  static String exambyIdDetail(String subjectId, String examId) =>
      '/subject/$subjectId/exam/$examId';

  static final router = GoRouter(
    initialLocation: AppRouter.signin,

    // refreshListenable: GoRouterAdapter(),
    routes: [
      /// INTRO
      GoRoute(
        path: AppRouter.intro,
        builder: (context, state) => const IntroScreen(),
      ),
      GoRoute(
        path: AppRouter.signup,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRouter.signin,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<AuthBloc>(),
          child: const SignInScreen(),
        ),
      ),

      /// EXAM DETAIL
      GoRoute(
        path: AppRouter.examById,
        builder: (context, state) {
          final String subjectId = state.pathParameters['subjectId']!;

          final String examId = state.pathParameters['examId']!;
          final exam = state.extra as ExamEntity;
          return BlocProvider(
            create: (context) => sl<ExamDetailBloc>()
              ..add(FetchExamDetailEvent(examId: examId, subjectId: subjectId)),
            child: ExamDetailScreen(
              subjectId: subjectId,
              examId: examId,
              title: exam.title,
              duration: exam.duration,
            ),
          );
        },
      ),

      /// BOTTOM NAVIGATION
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeScreen(navigationShell: navigationShell);
        },

        branches: [
          /// BRANCH 1
          StatefulShellBranch(
            routes: [
              /// EXAM
              GoRoute(
                path: AppRouter.exam,
                builder: (context, state) => BlocProvider(
                  create: (context) =>
                      sl<SubjectBloc>()..add(FetchSubjectEvent()),
                  child: const ExemSubjectScreen(),
                ),
              ),

              /// SUBJECT DETAIL
              GoRoute(
                path: AppRouter.subjectById,
                builder: (context, state) {
                  final subjectId = state.pathParameters['subjectId']!;

                  return ListExam(subjectId: subjectId);
                },
              ),
            ],
          ),

          /// BRANCH 2
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouter.home,
                builder: (context, state) => BlocProvider(
                  create: (context) {
                    return sl<SubjectBloc>()..add(FetchSubjectEvent());
                  },
                  child: const ExemSubjectScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
