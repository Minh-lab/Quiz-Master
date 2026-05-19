import 'package:get_it/get_it.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/data/repository/exam_repository_iml.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/data/services/exam_service.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/data/services/exam_service_iml.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/repository/exam_repository.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/usecases/exams/get_exam_detail.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/usecases/exams/get_exams_by_subject_usecase.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_exam_detail/exam_detail_bloc.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_list_exam/exam_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => ExamBloc(getExamsBySubject: sl()));
  sl.registerFactory(() => ExamDetailBloc(getExamDetailUseCase: sl()));
  sl.registerLazySingleton<ExamService>(() => ExamServiceIml());
  sl.registerLazySingleton(() => GetExamsBySubjectUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetExamDetailUseCase(repository: sl()));
  sl.registerLazySingleton<IExamRepository>(
    () => ExamRepositoryIml(service: sl()),
  );
}
