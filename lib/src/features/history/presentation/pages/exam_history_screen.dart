import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_mater_apllication/src/core/router/app_router.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/core/widgets/app_appbar.dart';
import 'package:quiz_mater_apllication/src/features/history/domain/entities/exam_history_entity.dart';
import 'package:quiz_mater_apllication/src/features/history/presentation/cubit/exam_history_cubit.dart';
import 'package:quiz_mater_apllication/src/features/history/presentation/cubit/exam_history_state.dart';

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
              padding: const EdgeInsets.all(16),
              itemCount: histories.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final history = histories[index];
                final isDeleting = state is ExamHistoryDeleting;
                
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                history.examTitle,
                                style: AppTypography.headlineSmall().copyWith(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${history.score.toStringAsFixed(1)} điểm',
                                style: AppTypography.labelLarge().copyWith(color: Theme.of(context).colorScheme.primary),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Môn: ${history.subjectName}',
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Text('${history.timeSpent ~/ 60}p ${history.timeSpent % 60}s', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                            const SizedBox(width: 16),
                            Icon(Icons.check_circle_outline, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Text('${history.correctAnswers}/${history.totalQuestions}', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                            const SizedBox(width: 16),
                            Icon(Icons.calendar_today, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Text('${history.submittedAt.day.toString().padLeft(2, '0')}/${history.submittedAt.month.toString().padLeft(2, '0')}/${history.submittedAt.year} ${history.submittedAt.hour.toString().padLeft(2, '0')}:${history.submittedAt.minute.toString().padLeft(2, '0')}', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text('Xem chi tiết'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              onPressed: isDeleting
                                  ? null
                                  : () async {
                                      final confirm = await _showDeleteConfirmDialog(context);
                                      if (confirm && context.mounted) {
                                        context.read<ExamHistoryCubit>().deleteHistory(history.id);
                                      }
                                    },
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
