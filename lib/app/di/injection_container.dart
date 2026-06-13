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
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/sign_in/sign_in_cubit.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/sign_up/sign_up_cubit.dart';
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
  sl.registerFactory(() => SignUpCubit(signupWithEmailUsecase: sl()));
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
}
