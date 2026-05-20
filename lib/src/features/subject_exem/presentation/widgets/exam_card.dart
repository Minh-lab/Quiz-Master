import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_mater_apllication/src/core/constants/AppAssets/app_asset.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_colors.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/core/widgets/app_container.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    // TODO: implement build

    return AppContainer(
      color: AppColors.background,
      width: double.infinity,
      // height: 200,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      // height: 200,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //   // width: 50,
          //   // height: 100,
          //   child: SvgPicture.asset(
          //     AppAssetIcon.engIcon,
          //     width: 60,
          //     height: 60,
          //     colorFilter: ColorFilter.mode(
          //       AppColors.borderSelected.withValues(alpha: 0.7),
          //       BlendMode.srcIn,
          //     ),
          //   ),
          // ),
          SizedBox(width: 16),
          Expanded(child: _detailExam()),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Text('Độ Khó'),
              // Text('Khó'),
              SizedBox(height: 50),
              AppContainer(
                color: AppColors.borderSelected.withValues(alpha: 0.7),
                width: 100,
                height: 36,
                child: ElevatedButton(
                  onPressed: onTap,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // spacing: 5,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon(
                      //   Icons.edit_outlined,
                      //   color: Colors.white.withValues(alpha: 0.8),

                      // ),
                      Text(
                        'Thi thử',
                        style: AppTypography.bodyMedium().copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailExam() {
    return Container(
      // width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(title, style: AppTypography.headlineSmall(), softWrap: true),

          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Row(
                children: [
                  Icon(Icons.question_answer_outlined),
                  Text('$numberQuestion câu'),
                ],
              ),
              SizedBox(width: 10),

              Row(
                children: [
                  Icon(Icons.timer_outlined),
                  Text('$time phút'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
