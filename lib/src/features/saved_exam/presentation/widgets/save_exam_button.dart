import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_mater_apllication/app/di/injection_container.dart';
import 'package:quiz_mater_apllication/src/features/saved_exam/presentation/cubit/saved_exam_cubit.dart';
import 'package:quiz_mater_apllication/src/features/saved_exam/presentation/cubit/saved_exam_state.dart';

class SaveExamButton extends StatelessWidget {
  final String examId;
  final String title;
  final String subjectId;
  final int duration;
  final int totalQuestions;

  const SaveExamButton({
    super.key,
    required this.examId,
    required this.title,
    required this.subjectId,
    required this.duration,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    // sl<SavedExamCubit>() is a singleton now
    final cubit = sl<SavedExamCubit>();
    // Check status if it hasn't been loaded
    cubit.checkSavedStatus(examId);

    return BlocProvider.value(
      value: cubit,
      child: BlocConsumer<SavedExamCubit, SavedExamState>(
        listenWhen: (previous, current) {
          return previous.message != current.message && 
                 current.message != null && 
                 current.lastActionExamId == examId;
        },
        listener: (context, state) {
          if (state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message!)),
            );
          }
        },
        builder: (context, state) {
          final isSaved = state.savedExamIds.contains(examId);

          return IconButton(
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_outline,
            ),
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              context.read<SavedExamCubit>().toggleSaveExam(
                    examId: examId,
                    title: title,
                    subjectId: subjectId,
                    duration: duration,
                    totalQuestions: totalQuestions,
                  );
            },
          );
        },
      ),
    );
  }
}
