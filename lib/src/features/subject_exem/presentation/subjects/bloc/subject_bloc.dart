import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/usecases/subjects/get_subject.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/subjects/bloc/subject_event.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/subjects/bloc/subject_state.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  GetSubjectUsecase getSubjectUsecase;
  SubjectBloc({
    required this.getSubjectUsecase,
  }) : super(SubjectInitial()) {
    on<FetchSubjectEvent>(_fetchSubjectEvent);
  }

  Future<void> _fetchSubjectEvent(
    FetchSubjectEvent event,
    Emitter<SubjectState> emit,
  ) async {
    emit(SubjectLoading());
    final result = await getSubjectUsecase.call();
    result.fold(
      (l) {
        emit(SubjectError(messageError: l.toString()));
      },
      (r) {
        emit(SubjectLoaded(subjects: r));
      },
    );
  }

  
}
