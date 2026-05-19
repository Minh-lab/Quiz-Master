import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/usecases/exams/get_exam_detail.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_exam_detail/exam_detail_event.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_exam_detail/exam_detail_state.dart';

class ExamDetailBloc extends Bloc<ExamDetailEvent, ExamDetailState> {
  GetExamDetailUseCase getExamDetailUseCase;
  ExamDetailBloc({required this.getExamDetailUseCase})
    : super(ExamDetailInitial()) {
    on<FetchExamDetailEvent>(_onFetchExamDetail);
    on<SelectAnswerEvent>(_onSelectAnswers); // TODO: implement event handler>
    on<ChangeQuestionEvent>(_onChangeQuestion);
  }

  Future<void> _onFetchExamDetail(
    FetchExamDetailEvent event,
    Emitter<ExamDetailState> emit,
  ) async {
    emit(ExamDetailLoading());
    try {
      final result = await getExamDetailUseCase.call(
        examId: event.examId,
        subjectId: event.subjectId,
      );
      result.fold(
        (l) {
          emit(ExamDetailError(messageError: l.message));
        },
        (r) {
          emit(ExamDetailLoaded(questions: r));
        },
      );
    } catch (e) {}
  }

  void _onSelectAnswers(
    SelectAnswerEvent event,
    Emitter<ExamDetailState> emit,
  ) {
    if (state is ExamDetailLoaded) {
      final currentState = state as ExamDetailLoaded;
      final updateSelectedAnswers = Map<int, int?>.from(
        currentState.selectedAnswers!,
      );
      updateSelectedAnswers[event.questionIndex] = event.answerIndex;
      print(updateSelectedAnswers);
      emit(currentState.copyWith(selectedAnswers: updateSelectedAnswers));
    }
  }

    void _onChangeQuestion(
      ChangeQuestionEvent event,
      Emitter<ExamDetailState> emit,
    ) {
      if (state is ExamDetailLoaded) {
        final currentState = state as ExamDetailLoaded;
        emit(currentState.copyWith(currentIndex: event.newIndex));
      }
    }
}
