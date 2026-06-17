import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_mater_apllication/src/features/saved_exam/domain/entities/saved_exam_entity.dart';
import 'package:quiz_mater_apllication/src/features/saved_exam/domain/usecases/saved_exam_usecases.dart';
import 'package:quiz_mater_apllication/src/features/saved_exam/presentation/cubit/saved_exam_state.dart';

class SavedExamCubit extends Cubit<SavedExamState> {
  final GetSavedExamsUseCase getSavedExamsUseCase;
  final SaveExamUseCase saveExamUseCase;
  final RemoveSavedExamUseCase removeSavedExamUseCase;
  final CheckExamSavedUseCase checkExamSavedUseCase;

  SavedExamCubit({
    required this.getSavedExamsUseCase,
    required this.saveExamUseCase,
    required this.removeSavedExamUseCase,
    required this.checkExamSavedUseCase,
  }) : super(const SavedExamState());

  Future<void> loadSavedExams() async {
    emit(state.copyWith(isLoading: true));
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Bạn cần đăng nhập để xem đề đã lưu.',
      ));
      return;
    }

    final result = await getSavedExamsUseCase(uid);

    result.fold(
      (errorMessage) => emit(state.copyWith(
        isLoading: false,
        error: errorMessage,
      )),
      (exams) {
        final savedIds = exams.map((e) => e.examId).toSet();
        // Update both the list and the set of IDs
        // Merge with existing IDs just in case, or just replace
        emit(state.copyWith(
          isLoading: false,
          exams: exams,
          savedExamIds: savedIds,
        ));
      },
    );
  }

  Future<void> checkSavedStatus(String examId) async {
    // If we already know it's saved from the set, no need to check
    if (state.savedExamIds.contains(examId)) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final result = await checkExamSavedUseCase(uid, examId);
    result.fold(
      (errorMessage) {}, // Silent error for check
      (isSaved) {
        if (isSaved) {
          final newIds = Set<String>.from(state.savedExamIds)..add(examId);
          emit(state.copyWith(savedExamIds: newIds));
        }
      },
    );
  }

  Future<void> toggleSaveExam({
    required String examId,
    required String title,
    required String subjectId,
    required int duration,
    required int totalQuestions,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      emit(state.copyWith(error: 'Vui lòng đăng nhập để lưu đề thi.'));
      return;
    }

    final currentlySaved = state.savedExamIds.contains(examId);
    
    // Optimistic update
    final newIds = Set<String>.from(state.savedExamIds);
    List<SavedExamEntity> newExams = List.from(state.exams);

    if (currentlySaved) {
      newIds.remove(examId);
      newExams.removeWhere((e) => e.examId == examId);
      emit(state.copyWith(
        savedExamIds: newIds,
        exams: newExams,
        message: 'Đã bỏ lưu đề thi',
        lastActionExamId: examId,
      ));
      // Clear message immediately so it doesn't show again
      emit(state.copyWith(clearMessage: true));

      final result = await removeSavedExamUseCase(uid, examId);
      result.fold(
        (errorMessage) {
          // Rollback
          newIds.add(examId);
          // Load lại danh sách đầy đủ vì khó thêm lại đúng vị trí và entity
          emit(state.copyWith(savedExamIds: newIds, error: errorMessage));
          loadSavedExams();
        },
        (_) {},
      );
    } else {
      newIds.add(examId);
      final newExam = SavedExamEntity(
        examId: examId,
        title: title,
        subjectId: subjectId,
        duration: duration,
        totalQuestions: totalQuestions,
        savedAt: DateTime.now(),
      );
      newExams.insert(0, newExam);

      emit(state.copyWith(
        savedExamIds: newIds,
        exams: newExams,
        message: 'Đã lưu đề thi',
        lastActionExamId: examId,
      ));
      emit(state.copyWith(clearMessage: true));

      final result = await saveExamUseCase(uid, newExam);
      result.fold(
        (errorMessage) {
          // Rollback
          newIds.remove(examId);
          newExams.removeWhere((e) => e.examId == examId);
          emit(state.copyWith(
            savedExamIds: newIds,
            exams: newExams,
            error: errorMessage,
          ));
        },
        (_) {},
      );
    }
  }

  Future<void> removeExam(String examId) async {
    // This is called from the SavedExamsScreen specifically, so we can just use toggleSaveExam
    // But since we don't have the full details there sometimes, wait, we do.
    // Actually, if we just want to remove, we can write a simpler method.
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final newIds = Set<String>.from(state.savedExamIds)..remove(examId);
    final newExams = List<SavedExamEntity>.from(state.exams)..removeWhere((e) => e.examId == examId);
    
    emit(state.copyWith(savedExamIds: newIds, exams: newExams));

    final result = await removeSavedExamUseCase(uid, examId);
    result.fold(
      (errorMessage) {
        emit(state.copyWith(error: errorMessage));
        loadSavedExams(); // Rollback by loading from remote
      },
      (_) {},
    );
  }
}
