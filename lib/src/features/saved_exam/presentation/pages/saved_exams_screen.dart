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
                    FilledButton(
                      onPressed: () {
                        context.go(AppRouter.home);
                      },
                      child: const Text('Khám phá đề thi'),
                    ),
                  ],
                ),
              );
            } else {
              final exams = state.exams;

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: exams.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final exam = exams[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(exam.title, style: AppTypography.bodyLarge()),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.timer_outlined, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Text('${exam.duration} phút', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                            const SizedBox(width: 16),
                            Icon(Icons.question_answer_outlined, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Text('${exam.totalQuestions} câu', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.bookmark),
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Bỏ lưu'),
                              content: const Text('Bạn có chắc muốn bỏ lưu đề thi này?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Huỷ'),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Đồng ý'),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true && context.mounted) {
                            context.read<SavedExamCubit>().removeExam(exam.examId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Đã bỏ lưu đề thi')),
                            );
                          }
                        },
                      ),
                      onTap: () {
                        // Chuyển sang màn hình chi tiết đề
                        final fakeExamEntity = ExamEntity(
                          id: exam.examId,
                          subjectId: exam.subjectId,
                          title: exam.title,
                          duration: exam.duration,
                          totalQuestions: exam.totalQuestions,
                          questions: const [],
                        );
                        context.push(
                          AppRouter.exambyIdDetail(exam.subjectId, exam.examId),
                          extra: fakeExamEntity,
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
