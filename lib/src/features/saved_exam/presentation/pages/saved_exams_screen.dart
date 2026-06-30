import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_mater_apllication/app/di/injection_container.dart';
import 'package:quiz_mater_apllication/src/core/router/app_router.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/core/widgets/app_appbar.dart';
import 'package:quiz_mater_apllication/src/features/saved_exam/presentation/cubit/saved_exam_cubit.dart';
import 'package:quiz_mater_apllication/src/features/saved_exam/presentation/cubit/saved_exam_state.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/entity/exam.dart';
import 'package:quiz_mater_apllication/src/features/saved_exam/presentation/widgets/saved_exam_card.dart';

class SavedExamsScreen extends StatelessWidget {
  const SavedExamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<SavedExamCubit>()..loadSavedExams(),
      child: Scaffold(
        appBar: const AppAppbar(title: 'Đề đã lưu'),
        body: BlocBuilder<SavedExamCubit, SavedExamState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.error != null && state.exams.isEmpty) {
              return Center(
                child: Text(
                  state.error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              );
            } else if (state.exams.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_border,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Bạn chưa lưu đề thi nào.',
                      style: AppTypography.bodyMedium(),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: 
                        FilledButton(
                          onPressed: () {
                            context.go(AppRouter.home);
                          },
                          child: const Text('Khám phá đề thi'),
                        ),
                      
                    ),
                  ],
                ),
              );
            } else {
              final exams = state.exams;

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  itemCount: exams.length,
                  itemBuilder: (context, index) {
                    final exam = exams[index];
                    return SavedExamCard(exam: exam);
                  },
                );
            }
          },
        ),
      ),
    );
  }
}
