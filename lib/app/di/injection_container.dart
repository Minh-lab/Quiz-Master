import 'package:get_it/get_it.dart';
import 'package:quiz_mater_apllication/src/features/auth/data/repositories/auth_repository_iml.dart';
import 'package:quiz_mater_apllication/src/features/auth/data/services/auth_service.dart';
import 'package:quiz_mater_apllication/src/features/auth/data/services/auth_service_imp.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/usecases/AnonymousSignInUsecase.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_bloc.dart';
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

final GetIt sl = GetIt.instance;

Future<void> init() async {
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

  
  sl.registerFactory(() => AuthBloc(anonymoussigninUsecase: sl()));
  sl.registerLazySingleton(() => AnonymoussigninUsecase(sl()));
  sl.registerLazySingleton<AuthService>(() => AuthServiceImpl());
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryIml(authService: sl()),
  );
}
