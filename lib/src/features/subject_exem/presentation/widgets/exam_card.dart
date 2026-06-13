import 'package:flutter/material.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/core/widgets/app_container.dart';

class ExamCard extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final String numberQuestion;
  final String time;

  const ExamCard({
    super.key,
    required this.title,
    required this.numberQuestion,
    required this.time,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppContainer(
      color: colorScheme.surfaceContainer,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _detailExam(context)),
          const SizedBox(width: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 46),
              SizedBox(
                width: 100,
                height: 38,
                child: FilledButton(
                  onPressed: onTap,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(100, 38),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Thi thử',
                    style: AppTypography.bodyMedium().copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailExam(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          title,
          style: AppTypography.headlineSmall().copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
          softWrap: true,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.question_answer_outlined,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  '$numberQuestion câu',
                  style: AppTypography.bodyMedium(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Row(
              children: [
                Icon(Icons.timer_outlined, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  '$time phút',
                  style: AppTypography.bodyMedium(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
