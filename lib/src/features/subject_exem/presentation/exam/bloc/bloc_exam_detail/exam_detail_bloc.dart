import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_exam_detail/exam_detail_event.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_exam_detail/exam_detail_state.dart';

class ExamDetailBloc extends Bloc<ExamDetailEvent, ExamDetailState> {
  ExamDetailBloc() : super(ExamDetailInitial()) {
    on<FetchExamDetailEvent>;
  }

  Future<void> _onFetchExamDetail(
    FetchExamDetailEvent event,
    Emitter<ExamDetailState> emit,
  ) async {
    emit(ExamDetailLoading());
    // try{

    // }
  }
}
