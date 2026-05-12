import 'package:go_router/go_router.dart';
import 'package:quiz_mater_apllication/src/core/widgets/intro_screen.dart';
import 'package:quiz_mater_apllication/src/features/exam/list_exam.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/home/home_screen.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/pages/exem_subject_screen.dart';

class AppRouter {
  static const String subject = '/subject/:subjectId';
  static const String home = '/home';
  static const String intro = '/intro';
  static const String exam = '/exam';
  // static const String subjectRoute = '/subject';
  // static const String examRoute = '/exam';
  // static const String resultRoute = '/result';
  static String subjectDetail(String subjectId) => '/subject/$subjectId';


  static final router = GoRouter(
    initialLocation: AppRouter.intro,
    routes: [
      GoRoute(
        path: AppRouter.intro,
        builder: (context, state) => const IntroScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouter.exam,
                builder: (context, state) => const ExemSubjectScreen(),
              ),
              GoRoute(
                path: AppRouter.subject,
                builder: (context, state) {
                  final subjectId = state.pathParameters['subjectId']!;

                  return ListExam(subjectId: subjectId);
                },
              ),
            ],
          ),
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
