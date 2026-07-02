import 'package:flutter/material.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/core/widgets/app_container.dart';

class ExamCard extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final String numberQuestion;
  final String time;
  final Widget? trailing;

  const ExamCard({
    super.key,
    required this.title,
    required this.numberQuestion,
    required this.time,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppContainer(
      color: colorScheme.surfaceContainer,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hàng 1: Tiêu đề đề thi
          Text(
            title,
            style: AppTypography.headlineSmall().copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),

          // Hàng 2: Metadata (Số câu, Thời gian)
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.question_answer_outlined,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$numberQuestion câu',
                    style: AppTypography.bodyMedium().copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$time phút',
                    style: AppTypography.bodyMedium().copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Hàng 3: Action Row
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: onTap,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                    child: Text(
                      'Thi thử',
                      style: AppTypography.bodyMedium().copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              if (trailing != null) ...[trailing!, const SizedBox(width: 12)],
            ],
          ),
        ],
      ),
    );
  }
}
