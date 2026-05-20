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
          // Tránh NoSuchMethodError nếu đối tượng lỗi không có trường 'message'
          final errorMessage = l is Exception 
              ? l.toString() 
              : (l?.toString() ?? 'Lỗi không xác định khi tải đề thi');
          emit(ExamDetailError(messageError: errorMessage));
        },
        (r) {
          emit(ExamDetailLoaded(questions: r));
        },
      );
    } catch (e) {
      print('❌ LỖI TẠI EXAM_DETAIL_BLOC: $e');
      emit(ExamDetailError(messageError: e.toString()));
    }
  }

  void _onSelectAnswers(
    SelectAnswerEvent event,
    Emitter<ExamDetailState> emit,
  ) {
    if (state is ExamDetailLoaded) {
      final currentState = state as ExamDetailLoaded;
      final updateSelectedAnswers = Map<int, dynamic>.from(
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
