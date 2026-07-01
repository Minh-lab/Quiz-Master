import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_mater_apllication/app/di/injection_container.dart';
import 'package:quiz_mater_apllication/src/core/router/go_router_adapter.dart';
import 'package:quiz_mater_apllication/src/core/widgets/intro_screen.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_state.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/pages/sign_in/signin_screen.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/pages/sign_up.dart/sign_up_screen.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/sign_in/sign_in_cubit.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/sign_up/sign_up_cubit.dart';
import 'package:quiz_mater_apllication/src/features/profile/presentation/pages/profile.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/entity/exam.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_exam_detail/exam_detail_bloc.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_exam_detail/exam_detail_event.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/timer_cubit/timer_cubit.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/pages/exam_detail_screen.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/pages/list_exam_screen.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/home/home_screen.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/subjects/bloc/subject_bloc.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/subjects/bloc/subject_event.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/subjects/pages/exem_subject_screen.dart';
import 'package:quiz_mater_apllication/src/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:quiz_mater_apllication/src/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:quiz_mater_apllication/src/features/profile/presentation/pages/change_password_screen.dart';
import 'package:quiz_mater_apllication/src/features/profile/presentation/cubit/change_password_cubit/change_password_cubit.dart';
import 'package:quiz_mater_apllication/src/features/history/presentation/pages/exam_history_screen.dart';
import 'package:quiz_mater_apllication/src/features/history/presentation/cubit/exam_history_cubit.dart';
// import 'package:quiz_mater_apllication/src/features/profile/presentation/pages/wrong_answers_screen.dart';
import 'package:quiz_mater_apllication/src/features/saved_exam/presentation/pages/saved_exams_screen.dart';
import 'package:quiz_mater_apllication/src/features/profile/presentation/pages/learning_statistics_screen.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/presentation/pages/chat_history_screen.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/presentation/cubit/chat_history_cubit.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/presentation/pages/chatbot_screen.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/presentation/cubit/chatbot_cubit.dart';

class AppRouter {
  static final AuthBloc authBloc = sl<AuthBloc>();
  static const String subjectById = '/subject/:subjectId';
  static const String home = '/home';
  static const String intro = '/intro';
  static const String profile = '/profile';
  static const String profileEdit = '/profile/edit';
  static const String profileChangePassword = '/profile/change-password';
  static const String profileExamHistory = '/profile/exam-history';
  static const String profileSavedExams = '/profile/saved-exams';
  static const String profileLearningStatistics =
      '/profile/learning-statistics';
  static const String chatbot = '/chatbot';
  static const String chatbotDetail = '/chatbot/detail';
  static const String exam = '/exam';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot_password';

  static const String examById = '/subject/:subjectId/exam/:examId';

  static String subjectDetail(String subjectId) => '/subject/$subjectId';

  static String exambyIdDetail(String subjectId, String examId) =>
      '/subject/$subjectId/exam/$examId';

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRouter.home,

    refreshListenable: GoRouterAdapter(authBloc.stream),
    redirect: (context, state) {
      final authState = AppRouter.authBloc.state;
      final isSignedInUser = authState is AuthSuccess;
      final isAuthPage =
          state.uri.path == AppRouter.signin ||
          state.uri.path == AppRouter.signup;
      final isProfilePage = state.uri.path == AppRouter.profile ||
          state.uri.path.startsWith('${AppRouter.profile}/');
      if (!isSignedInUser && isProfilePage) {
        return AppRouter.signin;
      }
      log(isSignedInUser.toString());
      log(isAuthPage.toString());
      if (isSignedInUser && isAuthPage) {
        log('Go to Home');
        return AppRouter.home;
      }

      return null;
    },
    routes: [
      /// INTRO
      GoRoute(
        path: AppRouter.intro,
        builder: (context, state) => const IntroScreen(),
      ),
      GoRoute(
        path: AppRouter.signup,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<SignUpCubit>(),
          child: const SignUpScreen(),
        ),
      ),
      GoRoute(
        path: AppRouter.signin,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<SignInCubit>(),
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
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => sl<ExamDetailBloc>()
                  ..add(FetchExamDetailEvent(examId: examId, subjectId: subjectId)),
              ),
              BlocProvider(
                create: (context) => TimerCubit(),
              ),
            ],
            child: ExamDetailScreen(
              subjectId: subjectId,
              examId: examId,
              title: exam.title,
              duration: exam.duration,
            ),
          );
        },
      ),

      /// SUBJECT DETAIL (FULL SCREEN)
      GoRoute(
        path: AppRouter.subjectById,
        builder: (context, state) {
          final subjectId = state.pathParameters['subjectId']!;
          return ListExam(subjectId: subjectId);
        },
      ),

      /// PROFILE SUB-ROUTES (FULL SCREEN)
      GoRoute(
        path: AppRouter.profileEdit,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<ProfileCubit>(),
          child: const EditProfileScreen(),
        ),
      ),
      GoRoute(
        path: AppRouter.profileChangePassword,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<ChangePasswordCubit>(),
          child: const ChangePasswordScreen(),
        ),
      ),
      GoRoute(
        path: AppRouter.profileExamHistory,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<ExamHistoryCubit>(),
          child: const ExamHistoryScreen(),
        ),
      ),
      GoRoute(
        path: AppRouter.profileSavedExams,
        builder: (context, state) => const SavedExamsScreen(),
      ),
      GoRoute(
        path: AppRouter.profileLearningStatistics,
        builder: (context, state) => const LearningStatisticsScreen(),
      ),

      GoRoute(
        path: AppRouter.chatbotDetail,
        builder: (context, state) {
          final sessionId = state.uri.queryParameters['sessionId'];
          return BlocProvider(
            create: (context) => sl<ChatbotCubit>(),
            child: ChatbotScreen(sessionId: sessionId),
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
                path: AppRouter.home,
                builder: (context, state) => BlocProvider(
                  create: (context) =>
                      sl<SubjectBloc>()..add(FetchSubjectEvent()),
                  child: const ExemSubjectScreen(),
                ),
              ),
            ],
          ),

          // / BRANCH 2
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouter.chatbot,
                builder: (context, state) {
                  return BlocProvider(
                    create: (context) => sl<ChatHistoryCubit>(),
                    child: const ChatHistoryScreen(),
                  );
                },
              ),
            ],
          ),

          // / BRANCH 3
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRouter.profile,
                builder: (context, state) {
                  // final user = state.extra as UserEntity;
                  return ProfileScreen();
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
