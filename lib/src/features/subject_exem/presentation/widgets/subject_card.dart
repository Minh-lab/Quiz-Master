import 'package:flutter/material.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/core/widgets/app_container.dart';

class SubjectCard extends StatelessWidget {
  final String title;
  final int numberExam;
  final Color? color;
  final Widget? image;
  final VoidCallback? onTap;

  const SubjectCard({
    super.key,
    required this.title,
    required this.numberExam,
    this.image,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppContainer(
      padding: EdgeInsets
          .zero, // Padding is handled by inner widget for InkWell effect
      child: Material(
        elevation: 0.0,
        color: Colors.transparent,
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
                    color: color ?? colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: image,
                ),
                const Spacer(),
                Text(
                  title,
                  style: AppTypography.headlineSmall(
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '$numberExam+ đề thi',
                  style: AppTypography.labelMedium(
                    color: colorScheme.onSurfaceVariant,
                  ).copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
