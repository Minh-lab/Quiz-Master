import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_colors.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';

class SubmitExamDialog extends StatelessWidget {
  final int totalQuestions;
  final int answeredQuestions;
  final String timeLeft;
  final VoidCallback? onSubmit;

  const SubmitExamDialog({
    super.key,
    required this.totalQuestions,
    required this.answeredQuestions,
    required this.timeLeft,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final unansweredQuestions = totalQuestions - answeredQuestions;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final successColor = isDark ? AppColors.darkSuccess : AppColors.success;
    final successBg = isDark ? AppColors.darkSuccessBackground : AppColors.successBackground;
    final errorColor = isDark ? AppColors.darkError : AppColors.error;
    final errorBg = isDark ? AppColors.darkErrorBackground : AppColors.errorBackground;
    final warningColor = isDark ? AppColors.darkWarning : AppColors.warning;
    final warningBg = isDark ? AppColors.darkWarningBackground : AppColors.warningBackground;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: colorScheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primaryContainer,
                  ),
                  child: Icon(
                    Icons.assignment_turned_in_rounded,
                    size: 36,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Xác nhận nộp bài',
                textAlign: TextAlign.center,
                style: AppTypography.headlineLarge().copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context: context,
                      icon: Icons.check_circle_rounded,
                      iconColor: successColor,
                      value: '$answeredQuestions',
                      label: 'Đã làm',
                      bgColor: successBg,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context: context,
                      icon: Icons.error_rounded,
                      iconColor: errorColor,
                      value: '$unansweredQuestions',
                      label: 'Chưa làm',
                      bgColor: errorBg,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context: context,
                      icon: Icons.timer_rounded,
                      iconColor: colorScheme.primary,
                      value: timeLeft,
                      label: 'Thời gian',
                      bgColor: colorScheme.primaryContainer,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (unansweredQuestions > 0)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: warningBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: warningColor),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: warningColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Bạn còn $unansweredQuestions câu hỏi chưa hoàn thành. Hãy kiểm tra lại!',
                          style: AppTypography.bodyMedium().copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              _buildNoteItem(
                context: context,
                icon: Icons.lock_outline_rounded,
                text: 'Không thể thay đổi đáp án sau khi nộp.',
              ),
              const SizedBox(height: 12),
              _buildNoteItem(
                context: context,
                icon: CupertinoIcons.shield_lefthalf_fill,
                text: 'Hệ thống sẽ chấm điểm và lưu kết quả ngay lập tức.',
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: colorScheme.surfaceContainerHigh,
                        side: BorderSide(color: colorScheme.outline),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'LÀM TIẾP',
                        style: AppTypography.labelLarge().copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onSubmit?.call();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'NỘP BÀI',
                        style: AppTypography.labelLarge().copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
    required Color bgColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withValues(alpha: 0.55)),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTypography.headlineMedium().copyWith(
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.labelSmall().copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNoteItem({
    required BuildContext context,
    required IconData icon,
    required String text,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodyMedium().copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
