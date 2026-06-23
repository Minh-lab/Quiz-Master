import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_mater_apllication/src/core/router/app_router.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/features/saved_exam/domain/entities/saved_exam_entity.dart';
import 'package:quiz_mater_apllication/src/features/saved_exam/presentation/cubit/saved_exam_cubit.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/entity/exam.dart';

class SavedExamCard extends StatelessWidget {
  final SavedExamEntity exam;

  const SavedExamCard({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: InkWell(
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
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      exam.title,
                      style: AppTypography.bodyMedium().copyWith(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildUnsaveButton(context),
                ],
              ),
              const SizedBox(height: 12),
              _buildMetadata(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnsaveButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.bookmark),
      color: Theme.of(context).colorScheme.primary,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
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
    );
  }

  Widget _buildMetadata(BuildContext context) {
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurfaceVariant;
    
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.timer_outlined, size: 16, color: onSurfaceVariant),
            const SizedBox(width: 4),
            Text('${exam.duration} phút', style: AppTypography.bodyMedium().copyWith(color: onSurfaceVariant)),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.question_answer_outlined, size: 16, color: onSurfaceVariant),
            const SizedBox(width: 4),
            Text('${exam.totalQuestions} câu', style: AppTypography.bodyMedium().copyWith(color: onSurfaceVariant)),
          ],
        ),
      ],
    );
  }
}
