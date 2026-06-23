import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_mater_apllication/src/core/router/app_router.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/core/widgets/app_appbar.dart';
import 'package:quiz_mater_apllication/src/features/history/domain/entities/exam_history_entity.dart';
import 'package:quiz_mater_apllication/src/features/history/presentation/cubit/exam_history_cubit.dart';
import 'package:quiz_mater_apllication/src/features/history/presentation/cubit/exam_history_state.dart';
import 'package:quiz_mater_apllication/src/features/history/presentation/widgets/history_card.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/data/models/question.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/pages/exam_result_screen.dart';

class ExamHistoryScreen extends StatefulWidget {
  const ExamHistoryScreen({super.key});

  @override
  State<ExamHistoryScreen> createState() => _ExamHistoryScreenState();
}

class _ExamHistoryScreenState extends State<ExamHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ExamHistoryCubit>().fetchHistory();
  }

  Future<bool> _showDeleteConfirmDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xóa lịch sử?'),
          content: const Text('Bạn có chắc muốn xóa lịch sử làm bài này không? Hành động này không thể hoàn tác.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Xóa',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppbar(title: 'Lịch sử làm bài'),
      body: BlocConsumer<ExamHistoryCubit, ExamHistoryState>(
        listener: (context, state) {
          if (state is ExamHistoryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is ExamHistoryDeleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã xóa lịch sử làm bài')),
            );
          }
        },
        builder: (context, state) {
          if (state is ExamHistoryLoading || state is ExamHistoryInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ExamHistoryEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: 16),
                  Text(
                    'Bạn chưa làm bài thi nào.',
                    style: AppTypography.bodyMedium(),
                  ),
                  const SizedBox(height: 16),
                  // FilledButton(
                  //   onPressed: () {
                  //     // context.pop(); // Đóng màn hình hiện tại (nhánh Profile)
                  //     context.go(AppRouter.home); // Chuyển sang nhánh Home
                  //   },
                  //   child: const Text('Làm bài ngay'),
                  // ),
                ],
              ),
            );
          }

          List<ExamHistoryEntity> histories = [];
          if (state is ExamHistoryLoaded) {
            histories = state.histories;
          } else if (state is ExamHistoryDeleting) {
            histories = state.currentHistories;
          } else if (state is ExamHistoryDeleteSuccess) {
            histories = state.currentHistories;
          } else if (state is ExamHistoryError) {
            // Hiển thị lại nút thử lại khi lỗi fetch
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Đã xảy ra lỗi khi tải dữ liệu.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ExamHistoryCubit>().fetchHistory(),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<ExamHistoryCubit>().fetchHistory(),
            child: ListView.separated(
              // padding: const EdgeInsets.all(16),
              itemCount: histories.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final history = histories[index];
                final isDeleting = state is ExamHistoryDeleting;
                
                return HistoryCard(
                  history: history,
                  isDeleting: isDeleting,
                  onViewDetail: () {
                    if (history.questionsData != null && history.userAnswers != null) {
                      final questions = history.questionsData!
                          .map((q) => QuestionModel.fromJson(q as Map<String, dynamic>, q['id']))
                          .toList();
                      final userAnswers = history.userAnswers!.map(
                          (key, value) => MapEntry(int.parse(key), value));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExamResultScreen(
                            questions: questions,
                            userAnswers: userAnswers,
                            timeTakenInSeconds: history.timeSpent,
                            subjectId: history.subjectId,
                            examId: history.examId,
                            title: history.examTitle,
                            duration: history.duration ~/ 60,
                            isViewingHistory: true,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Dữ liệu chi tiết của bài thi cũ không được lưu')),
                      );
                    }
                  },
                  onDelete: () async {
                    final confirm = await _showDeleteConfirmDialog(context);
                    if (confirm && context.mounted) {
                      context.read<ExamHistoryCubit>().deleteHistory(history.id);
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
