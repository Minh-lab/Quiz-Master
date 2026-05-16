import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_colors.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/widgets/item.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/widgets/menu.dart';

class SubmitExamDialog extends StatelessWidget {
  final int totalQuestions = 50;
  final int answeredQuestions = 40;
  final String timeLeft = '03:02';
  VoidCallback? onSubmit;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Container(
                  width: 64,
                  height: 64,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.warning.withValues(alpha: 0.15),
                  ),
                  child: Icon(
                    size: 40,
                    Icons.warning,
                    color: AppColors.warning,
                  ),
                ),
                Text('Xác nhận nộp bài', style: AppTypography.headlineLarge()),
                (answeredQuestions < totalQuestions)
                    ? RichText(
                        text: TextSpan(
                          // text: 'Câu hỏi chưa nộp: ',
                          style: AppTypography.headlineSmall().copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: 'Bạn vẫn còn ',
                              style: AppTypography.bodyMedium(),
                            ),
                            TextSpan(
                              text: '${totalQuestions - answeredQuestions}',
                              style: AppTypography.bodyMedium(
                                color: AppColors.primary,
                              ).copyWith(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: ' câu chưa nộp',
                              style: AppTypography.bodyMedium(),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Sau khi nộp bài: ',
                            style: AppTypography.headlineSmall(),
                            // textAlign: TextAlign.,
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,

                              decoration: BoxDecoration(
                                color: Color(0XFF64748B).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.lock_outlined, size: 16),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Không thể thay đổi đáp án',
                              style: AppTypography.bodyMedium(),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,

                              decoration: BoxDecoration(
                                color: Color(0XFF64748B).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(CupertinoIcons.shield, size: 16),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Hệ thống sẽ chấm điểm ngay',
                              style: AppTypography.bodyMedium(),
                            ),
                          ],
                        ),
                        SizedBox(height: 32),
                        Text(
                          'Bạn có chắc muốn nộp bài',
                          style: AppTypography.headlineMedium(),
                        ),
                        SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            // color: AppColors.primary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Item(
                                icons: Icon(
                                  Icons.check_rounded,
                                  color: AppColors.borderCorrect,
                                ),
                                label: 'Đã làm',
                                numberAnswered: answeredQuestions,
                                timeLeft: timeLeft,
                                backgroundColor: AppColors.borderCorrect
                                    .withValues(alpha: 0.4),
                              ),
                              Item(
                                icons: Icon(
                                  Icons.radio_button_unchecked_rounded,
                                  color: AppColors.borderWrong,
                                ),
                                label: 'Chưa làm',
                                numberAnswered: answeredQuestions,
                                timeLeft: timeLeft,
                                backgroundColor: AppColors.borderWrong
                                    .withValues(alpha: 0.4),
                              ),
                              Item(
                                icons: Icon(
                                  Icons.timelapse_outlined,
                                  color: AppColors.primary,
                                ),
                                label: 'Thời gian',
                                numberAnswered: answeredQuestions,
                                timeLeft: timeLeft,
                                backgroundColor: AppColors.primary.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: Color(0XFF2563EB),
                                    width: 2,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },

                                child: Text(
                                  'LÀM TIẾP',
                                  textAlign: TextAlign.center,
                                  style: AppTypography.headlineSmall().copyWith(
                                    color: Color(0XFF2563EB),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: AppColors.borderWrong,
                                  side: BorderSide(
                                    color: AppColors.borderWrong,
                                  ),
                                ),
                                onPressed: () {},

                                child: Text(
                                  'NỘP BÀI',
                                  style: AppTypography.headlineSmall().copyWith(
                                    color: AppColors.background,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
