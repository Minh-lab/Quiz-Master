import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quiz_mater_apllication/src/core/constants/AppAssets/app_asset.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_colors.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/entity/exam.dart';

class ListExamDialog extends StatelessWidget {
  final ExamEntity exam;
  final VoidCallback? onConfirm;

  const ListExamDialog({super.key, required this.exam, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(AppAssetIcon.examDetailPopup),
              const SizedBox(height: 16),
              Text(
                'Bắt đầu thi thử',
                style: AppTypography.headlineMedium(
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                exam.title,
                style: AppTypography.bodyLarge(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildDetail(context),
              const SizedBox(height: 24),
              _buildWarning(
                context,
                'Sau khi bắt đầu, thời gian sẽ được tính ngay!',
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildButtonAction(
                      context: context,
                      label: 'Để sau',
                      onTap: () => Navigator.pop(context),
                      isConfirm: false,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildButtonAction(
                      context: context,
                      label: 'Bắt đầu',
                      onTap: onConfirm ?? () {},
                      isConfirm: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: colorScheme.primaryContainer,
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.45)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDetailRow(
            context: context,
            icon: Icons.description_outlined,
            label: 'Số câu hỏi:',
            value: '${exam.totalQuestions} câu',
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            context: context,
            icon: Icons.access_time_outlined,
            label: 'Thời gian làm bài:',
            value: '${exam.duration} phút',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, color: colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodyMedium().copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: AppTypography.bodyLarge().copyWith(
            color: colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildWarning(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final warningColor = isDark ? AppColors.darkWarning : AppColors.warning;
    final warningBg = isDark ? AppColors.darkWarningBackground : AppColors.warningBackground;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: warningBg,
        border: Border.all(color: warningColor),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: warningColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodyMedium().copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonAction({
    required BuildContext context,
    required String label,
    required VoidCallback onTap,
    required bool isConfirm,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return isConfirm
        ? FilledButton(onPressed: onTap, child: Text(label))
        : OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              backgroundColor: colorScheme.surfaceContainerHigh,
              side: BorderSide(color: colorScheme.outline),
            ),
            child: Text(
              label,
              style: AppTypography.headlineSmall().copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
  }
}
