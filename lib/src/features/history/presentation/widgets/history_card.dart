import 'package:flutter/material.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_colors.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/features/history/domain/entities/exam_history_entity.dart';

class HistoryCard extends StatelessWidget {
  final ExamHistoryEntity history;
  final bool isDeleting;
  final VoidCallback onDelete;
  final VoidCallback onViewDetail;

  const HistoryCard({
    super.key,
    required this.history,
    required this.isDeleting,
    required this.onDelete,
    required this.onViewDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Title & Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    history.examTitle,
                    style: AppTypography.bodyMedium().copyWith(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                HistoryScoreBadge(score: history.score),
              ],
            ),
            const SizedBox(height: 8),
            // Row 2: Subject
            Text(
              'Môn học: ${history.subjectName}',
              style: AppTypography.bodyMedium().copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            // Row 3: Metadata
            HistoryMetadataRow(history: history),
            const SizedBox(height: 20),
            // Row 5: Actions
            HistoryActionRow(
              isDeleting: isDeleting,
              onDelete: onDelete,
              onViewDetail: onViewDetail,
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryScoreBadge extends StatelessWidget {
  final double score;
  const HistoryScoreBadge({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${score.toStringAsFixed(1)} điểm',
        style: AppTypography.labelLarge().copyWith(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class HistoryMetadataRow extends StatelessWidget {
  final ExamHistoryEntity history;
  const HistoryMetadataRow({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final onSurfaceVariant = Theme.of(context).colorScheme.onSurfaceVariant;
    final date = history.submittedAt;
    final dateString = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    final timeString = '${history.timeSpent ~/ 60}p ${history.timeSpent % 60}s';

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _buildItem(Icons.access_time_rounded, timeString, onSurfaceVariant),
        _buildItem(Icons.fact_check_outlined, '${history.correctAnswers}/${history.totalQuestions}', onSurfaceVariant),
        _buildItem(Icons.calendar_today_rounded, dateString, onSurfaceVariant),
      ],
    );
  }

  Widget _buildItem(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(text, style: AppTypography.bodyMedium().copyWith(color: color)),
      ],
    );
  }
}

class HistoryActionRow extends StatelessWidget {
  final bool isDeleting;
  final VoidCallback onDelete;
  final VoidCallback onViewDetail;

  const HistoryActionRow({
    super.key,
    required this.isDeleting,
    required this.onDelete,
    required this.onViewDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: FilledButton(
            onPressed: onViewDetail,
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text('Xem chi tiết', style: AppTypography.labelMedium()),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 1,
          child: OutlinedButton.icon(
            onPressed: isDeleting ? null : onDelete,
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
              side: BorderSide(color: Theme.of(context).colorScheme.error.withValues(alpha: 0.5)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            icon: isDeleting 
                ? const SizedBox(
                    width: 16, height: 16, 
                    child: CircularProgressIndicator(strokeWidth: 2)
                  )
                : const Icon(Icons.delete_outline, size: 18),
            label: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('Xóa', style: AppTypography.labelMedium())
            ),
          ),
        ),
      ],
    );
  }
}
