import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quiz_mater_apllication/src/core/constants/AppAssets/app_asset.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_colors.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/entity/exam.dart';

class ListExamDialog extends StatelessWidget {
  final ExamEntity exam;
  final VoidCallback? onConfirm;

  const ListExamDialog({Key? key, required this.exam, required this.onConfirm})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppAssetIcon.examDetailPopup,
              // width: 60,
              // height: 60,
            ),
            SizedBox(height: 16),
            Text('Bắt đầu thi thử', style: AppTypography.headlineMedium()),
            Text(
              '${exam.title}',
              style: AppTypography.bodyLarge(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            _buildDetail(),
            SizedBox(height: 24),
            _buildWarning('Sau khi bắt đầu, thời gian sẽ được tính ngay!'),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildButtonAction(
                    label: 'Để sau',
                    onTap: () => Navigator.pop(context),
                    isConfirm: false,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildButtonAction(
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
    );
  }

  Widget _buildDetail() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.primary.withValues(alpha: 0.09),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.description_outlined, color: AppColors.primary),
              SizedBox(width: 8),
              Text('Số câu hỏi:', style: AppTypography.bodyMedium()),
              Expanded(child: SizedBox()),
              Text(
                '${exam.questions.length} câu',
                style: AppTypography.bodyLarge().copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.access_time_outlined, color: AppColors.primary),
              SizedBox(width: 8),
              Text('Thời gian làm bài:', style: AppTypography.bodyMedium()),
              Expanded(child: SizedBox()),
              Text(
                '${exam.duration} phút',
                style: AppTypography.bodyLarge().copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWarning(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.warning.withValues(alpha: 0.09),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: AppColors.warning),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodyMedium(),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonAction({
    required String label,
    required VoidCallback onTap,
    required isConfirm,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: isConfirm ? AppColors.primary : Colors.white,
      ),
      child: Center(
        child: Text(
          label,
          style: AppTypography.headlineSmall().copyWith(
            color: isConfirm ? Colors.white : AppColors.primary,
            fontWeight: FontWeight.w600
          ),
        ),
      ),
    );
  }
}
