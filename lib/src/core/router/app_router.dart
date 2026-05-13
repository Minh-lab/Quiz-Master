import 'package:go_router/go_router.dart';
import 'package:quiz_mater_apllication/src/core/widgets/intro_screen.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/exam_detail_screen.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/list_exam.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/home/home_screen.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/pages/exem_subject_screen.dart';

class AppRouter {
  static const String subject = '/subject/:subjectId';
  static const String home = '/home';
  static const String intro = '/intro';
  static const String exam = '/exam';

  static const String examById = '/subject/:subjectId/exam/:examId';

  static String subjectDetail(String subjectId) => '/subject/$subjectId';

  static String exambyIdDetail(String subjectId, String examId) =>
      '/subject/$subjectId/exam/$examId';

  static final router = GoRouter(
    initialLocation: AppRouter.intro,

    routes: [
      /// INTRO
      GoRoute(
        path: AppRouter.intro,
        builder: (context, state) => const IntroScreen(),
      ),

      /// EXAM DETAIL
      GoRoute(
        path: AppRouter.examById,
        builder: (context, state) {
          final subjectId = state.pathParameters['subjectId']!;

          final examId = state.pathParameters['examId']!;

          return ExamDetailScreen(subjectId: subjectId, examId: examId);
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
                builder: (context, state) => const ExemSubjectScreen(),
              ),

              /// SUBJECT DETAIL
              GoRoute(
                path: AppRouter.subject,
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
                builder: (context, state) => const ExemSubjectScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
