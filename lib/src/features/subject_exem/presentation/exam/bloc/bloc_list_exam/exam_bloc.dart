import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/usecases/exams/get_exams_by_subject_usecase.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_list_exam/exam_event.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_list_exam/exam_state.dart';

class ExamBloc extends Bloc<ExamEvent, ExamState> {
  GetExamsBySubjectUsecase getExamsBySubject;
  ExamBloc({required this.getExamsBySubject}) : super(ExamInitial()) {
    on<FetchExamPreviewEvent>(_onFetchExamsPreview);
  }

  Future<void> _onFetchExamsPreview(
    FetchExamPreviewEvent event,
    Emitter<ExamState> emit,
  ) async {
    emit(ExamLoading());
    Either result = await getExamsBySubject.call(params: event.subjectId);
    result.fold((failure) => emit(ExamError(messageError: failure.toString())), (
      exams,
    ) {
      // print('oke');
      emit(ExamLoaded(exams: exams));
    });
  }
}
