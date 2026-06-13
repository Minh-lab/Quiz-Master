import 'package:flutter/material.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/core/widgets/app_appbar.dart';

class LearningStatisticsScreen extends StatelessWidget {
  const LearningStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppbar(title: 'Thống kê học tập'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tổng quan', style: AppTypography.headlineMedium()),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStatCard(context, '12', 'Bài đã làm', Icons.assignment)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard(context, '450', 'Câu đã làm', Icons.question_answer)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildStatCard(context, '85%', 'Tỷ lệ đúng', Icons.percent)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard(context, '12h', 'Thời gian học', Icons.timer)),
              ],
            ),
            const SizedBox(height: 32),
            Text('Thống kê theo môn', style: AppTypography.headlineMedium()),
            const SizedBox(height: 16),
            _buildSubjectProgress(context, 'Toán học', 0.8),
            const SizedBox(height: 12),
            _buildSubjectProgress(context, 'Vật lý', 0.6),
            const SizedBox(height: 12),
            _buildSubjectProgress(context, 'Hóa học', 0.4),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 12),
          Text(value, style: AppTypography.headlineLarge().copyWith(color: Theme.of(context).colorScheme.primary)),
          const SizedBox(height: 4),
          Text(label, style: AppTypography.bodyMedium().copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _buildSubjectProgress(BuildContext context, String subject, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(subject, style: AppTypography.bodyLarge()),
            Text('${(progress * 100).toInt()}%', style: AppTypography.labelLarge()),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          color: Theme.of(context).colorScheme.primary,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
