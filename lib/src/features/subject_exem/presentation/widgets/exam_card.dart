import 'package:flutter/material.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_colors.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/core/widgets/app_container.dart';

class ExamCard extends StatelessWidget {
  final String title;
  final int numberExam;
  final Color? color;
  final Widget image;
  final VoidCallback? onTap;

  const ExamCard({
    super.key,
    required this.title,
    required this.numberExam,
    required this.image,
    this.color,
    this.onTap
    
  });

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: EdgeInsets.zero, // Padding is handled by inner widget for InkWell effect
      child: Material(
        elevation: 0.0,
        // color: Colors.transparent, // Allow AppContainer background to show
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color ?? AppColors.success.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: image,
                ),
                const Spacer(),
                Text(
                  title,
                  style: AppTypography.headlineSmall(color: AppColors.textPrimary),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '$numberExam+ đề thi',
                  style: AppTypography.labelMedium(color: AppColors.textSecondary).copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
