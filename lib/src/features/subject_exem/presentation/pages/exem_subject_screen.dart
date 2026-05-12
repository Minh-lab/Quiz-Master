import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_mater_apllication/src/core/constants/AppAssets/app_asset.dart';
import 'package:quiz_mater_apllication/src/core/router/app_router.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_colors.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/core/widgets/app_container.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/widgets/exam_card.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/widgets/menu.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExemSubjectScreen extends StatelessWidget {
  const ExemSubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _topBanner('Nguyen Van A', 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MenuCard(),
            const SizedBox(height: 32),
            _headingExam(),
            const SizedBox(height: 16),
            GridView.count(
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ExamCard(
                  title: 'Tiếng Anh',
                  numberExam: 10,
                  color: AppColors.primaryLight.withValues(alpha: 0.15),
                  image: SvgPicture.asset(
                    AppAssetIcon.engIcon,
                    width: 40,
                    height: 40,
                  ),
                  onTap: () => context.push(AppRouter.subjectDetail('1')),
                ),
                ExamCard(
                  title: 'Vật Lý',
                  numberExam: 10,
                  color: AppColors.success.withValues(alpha: 0.15),
                  image: SvgPicture.asset(
                    AppAssetIcon.atomColorIcon,
                    width: 40,
                    height: 40,
                  ),
                ),
                ExamCard(
                  title: 'Toán Học',
                  numberExam: 10,
                  color: AppColors.warning.withValues(alpha: 0.15),
                  image: SvgPicture.asset(
                    AppAssetIcon.mathIcon,
                    width: 40,
                    height: 40,
                  ),
                ),
                ExamCard(
                  title: 'Hóa Học',
                  numberExam: 10,
                  color: AppColors.error.withValues(alpha: 0.15),
                  image: SvgPicture.asset(
                    AppAssetIcon.chemistryIcon,
                    width: 40,
                    height: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _headingExam() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 5,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Ôn theo môn học',
              style: AppTypography.headlineMedium(color: AppColors.textPrimary),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            // TODO: Navigate to All Subjects
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Xem tất cả',
                  style: AppTypography.labelMedium(color: AppColors.primary),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.primary,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget _topBanner(String fullName, int streak) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120),
      child: Container(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 20),
        decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Xin chào!',
                          style: AppTypography.headlineSmall(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.waving_hand_rounded,
                          color: Colors.amber,
                          size: 22,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      fullName,
                      style: AppTypography.headlineLarge(color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppAssetIcon.fireIcon,
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        Colors.red,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$streak',
                      style: AppTypography.headlineSmall(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
