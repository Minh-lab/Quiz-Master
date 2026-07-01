import 'package:get_it/get_it.dart';
import 'package:quiz_mater_apllication/src/features/auth/data/repositories/auth_repository_iml.dart';
import 'package:quiz_mater_apllication/src/features/auth/data/services/auth_service.dart';
import 'package:quiz_mater_apllication/src/features/auth/data/services/auth_service_imp.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/usecases/anonymous_sign_in.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/usecases/sign_out.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/usecases/signin_with_email.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/usecases/signin_with_google.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/usecases/signup_with_email.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/usecases/send_password_reset_email.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/sign_in/sign_in_cubit.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/sign_up/sign_up_cubit.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/forgot_password/forgot_password_cubit.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/domain/usecases/delete_chat_session_usecase.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/data/repository/exam_repository_iml.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/data/repository/subject_repository_iml.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/data/services/exam_service/exam_service.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/data/services/exam_service/exam_service_iml.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/data/services/subject_service/subject_service.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/data/services/subject_service/subject_service_imp.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/repository/exam_repository.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/repository/subject_repository.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/usecases/exams/get_exam_detail.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/usecases/exams/get_exams_by_subject_usecase.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/usecases/subjects/get_subject.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_exam_detail/exam_detail_bloc.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_list_exam/exam_bloc.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/subjects/bloc/subject_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_mater_apllication/src/core/theme/bloc/theme_cubit.dart';

// Profile DI
import 'package:quiz_mater_apllication/src/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:quiz_mater_apllication/src/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:quiz_mater_apllication/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:quiz_mater_apllication/src/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:quiz_mater_apllication/src/features/profile/presentation/cubit/profile_cubit.dart';

import 'package:quiz_mater_apllication/src/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:quiz_mater_apllication/src/features/profile/presentation/cubit/change_password_cubit/change_password_cubit.dart';

import 'package:quiz_mater_apllication/src/features/history/data/datasources/history_remote_data_source.dart';
import 'package:quiz_mater_apllication/src/features/history/data/repositories/history_repository_impl.dart';
import 'package:quiz_mater_apllication/src/features/history/domain/repositories/history_repository.dart';
import 'package:quiz_mater_apllication/src/features/history/domain/usecases/get_exam_history_usecase.dart';
import 'package:quiz_mater_apllication/src/features/history/domain/usecases/delete_exam_history_usecase.dart';
import 'package:quiz_mater_apllication/src/features/history/domain/usecases/save_exam_history_usecase.dart';
import 'package:quiz_mater_apllication/src/features/history/presentation/cubit/exam_history_cubit.dart';

// Saved Exam DI
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_mater_apllication/src/features/saved_exam/data/datasources/saved_exam_remote_datasource.dart';
import 'package:quiz_mater_apllication/src/features/saved_exam/data/repositories/saved_exam_repository_impl.dart';
import 'package:quiz_mater_apllication/src/features/saved_exam/domain/repositories/saved_exam_repository.dart';
import 'package:quiz_mater_apllication/src/features/saved_exam/domain/usecases/saved_exam_usecases.dart';
import 'package:quiz_mater_apllication/src/features/saved_exam/presentation/cubit/saved_exam_cubit.dart';

// Chatbot DI
import 'package:quiz_mater_apllication/src/features/chatbot/data/datasources/chatbot_remote_datasource.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/data/repositories/chatbot_repository_impl.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/domain/repositories/chatbot_repository.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/domain/usecases/create_chat_session_usecase.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/domain/usecases/get_chat_history_usecase.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/domain/usecases/get_sessions_usecase.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/domain/usecases/send_message_usecase.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/presentation/cubit/chat_history_cubit.dart';
import 'package:quiz_mater_apllication/src/features/chatbot/presentation/cubit/chatbot_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerFactory(() => ThemeCubit(prefs: sl()));

  sl.registerFactory(() => ExamBloc(getExamsBySubject: sl()));
  sl.registerFactory(() => ExamDetailBloc(getExamDetailUseCase: sl()));
  sl.registerFactory(() => SubjectBloc(getSubjectUsecase: sl()));
  sl.registerLazySingleton<ExamService>(() => ExamServiceIml());
  sl.registerLazySingleton<SubjectService>(() => SubjectServiceIml());
  sl.registerLazySingleton(() => GetExamsBySubjectUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetExamDetailUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetSubjectUsecase(repository: sl()));
  sl.registerLazySingleton<IExamRepository>(
    () => ExamRepositoryIml(service: sl()),
  );
  sl.registerLazySingleton<ISubjectRepository>(
    () => SubjectRepositoryIml(subjectService: sl()),
  );

  //Auth
  sl.registerFactory(
    () => SignInCubit(
      signinWithEmailUsecase: sl(),
      signinWithGoogleUsecase: sl(),
    ),
  );
  sl.registerFactory(
    () => SignUpCubit(
      signupWithEmailUsecase: sl(),
      signinWithGoogleUsecase: sl(),
    ),
  );
  
  sl.registerLazySingleton(() => SendPasswordResetEmailUseCase(sl()));
  sl.registerFactory(() => ForgotPasswordCubit(sl()));

  sl.registerLazySingleton(
    () => AuthBloc(
      // signinWithEmailUsecase: sl(),
      // signupWithEmailUsecase: sl(),
      signOutUsecase: sl(),
    ),
  );

  sl.registerLazySingleton<AuthService>(() => AuthServiceImpl());
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryIml(authService: sl()),
  );
  sl.registerLazySingleton(() => AnonymousSignInUsecase(repository: sl()));
  sl.registerLazySingleton(() => SignupWithEmailUsecase(repository: sl()));
  sl.registerLazySingleton(() => SigninWithEmailUsecase(repository: sl()));
  sl.registerLazySingleton(() => SignOutUsecase(repository: sl()));
  sl.registerLazySingleton(() => SigninWithGoogleUsecase(repository: sl()));

  // Profile
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerFactory(() => ProfileCubit(updateProfileUseCase: sl()));
  
  // Change Password
  sl.registerLazySingleton(() => ChangePasswordUseCase(sl()));
  sl.registerFactory(() => ChangePasswordCubit(changePasswordUseCase: sl()));

  // Exam History
  sl.registerLazySingleton<HistoryRemoteDataSource>(
    () => HistoryRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<HistoryRepository>(
    () => HistoryRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetExamHistoryUseCase(sl()));
  sl.registerLazySingleton(() => DeleteExamHistoryUseCase(sl()));
  sl.registerLazySingleton(() => SaveExamHistoryUseCase(sl()));
  sl.registerFactory(
    () => ExamHistoryCubit(
      getHistoryUseCase: sl(),
      deleteHistoryUseCase: sl(),
    ),
  );

  // Saved Exam
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<SavedExamRemoteDataSource>(
    () => SavedExamRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<SavedExamRepository>(
    () => SavedExamRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => SaveExamUseCase(sl()));
  sl.registerLazySingleton(() => RemoveSavedExamUseCase(sl()));
  sl.registerLazySingleton(() => CheckExamSavedUseCase(sl()));
  sl.registerLazySingleton(() => GetSavedExamsUseCase(sl()));
  sl.registerLazySingleton(
    () => SavedExamCubit(
      getSavedExamsUseCase: sl(),
      saveExamUseCase: sl(),
      removeSavedExamUseCase: sl(),
      checkExamSavedUseCase: sl(),
    ),
  );

  // Chatbot
  sl.registerLazySingleton<ChatbotRemoteDataSource>(
    () => ChatbotRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<ChatbotRepository>(
    () => ChatbotRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetSessionsUseCase(sl()));
  sl.registerLazySingleton(() => CreateChatSessionUseCase(sl()));
  sl.registerLazySingleton(() => GetChatHistoryUseCase(sl()));
  sl.registerLazySingleton(() => SendMessageUseCase(sl()));
  sl.registerLazySingleton(() => DeleteChatSessionUseCase(sl()));
  sl.registerFactory(() => ChatHistoryCubit(
    getSessionsUseCase: sl(),
    deleteChatSessionUseCase: sl(),
  ));
  sl.registerFactory(() => ChatbotCubit(
    getChatHistoryUseCase: sl(),
    createChatSessionUseCase: sl(),
    sendMessageUseCase: sl(),
  ));
}
