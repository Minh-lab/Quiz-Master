import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_mater_apllication/app/di/injection_container.dart';
import 'package:quiz_mater_apllication/src/core/constants/AppAssets/app_asset.dart';
import 'package:quiz_mater_apllication/src/core/router/app_router.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_colors.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/core/widgets/app_container.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/data/services/exam_service/exam_service.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/domain/entity/subject.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_list_exam/exam_bloc.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/exam/bloc/bloc_list_exam/exam_event.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/subjects/bloc/subject_bloc.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/subjects/bloc/subject_event.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/subjects/bloc/subject_state.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/widgets/subject_card.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/widgets/menu.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/widgets/top_banner.dart';

class ExemSubjectScreen extends StatelessWidget {
  const ExemSubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: TopBanner(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const MenuCard(),
              // const SizedBox(height: 32),
              _headingExam(context),
              const SizedBox(height: 16),
        
              BlocBuilder<SubjectBloc, SubjectState>(
                builder: (context, state) {
                  if (state is SubjectLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is SubjectLoaded) {
                    final List<SubjectEntity> subjects = state.subjects!;
        
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: subjects.length,
                      itemBuilder: (context, index) {
                      
                        final subject = subjects[index];
                        print(subject.iconName);
        
                        var color = getThemeColor(subject.themeColor);
                        var iconPath = getIconPath(subject.iconName);
                        // print(color);
                        // print(iconPath);
        
                        final isDark =
                            Theme.of(context).brightness == Brightness.dark;
                        final colorScheme = Theme.of(context).colorScheme;
                        final subjectTint = isDark
                            ? Color.lerp(
                                colorScheme.surfaceContainerHigh,
                                color,
                                0.55,
                              )!
                            : Color.lerp(colorScheme.surface, color, 0.16)!;
                        final iconColor = isDark
                            ? Color.lerp(color, Colors.white, 0.62)!
                            : color;
                        final shouldTintIcon = _isMonochromeIcon(
                          subject.iconName,
                        );

                        return SubjectCard(
                          title: subject.name,
                          numberExam:
                              subjects[index].countExams, // Thay đổi số lượng bài thi ở đây
                          color: subjectTint,
                          image: shouldTintIcon
                              ? ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    iconColor,
                                    BlendMode.srcIn,
                                  ),
                                  child: SvgPicture.asset(
                                    iconPath,
                                    width: 40,
                                    height: 40,
                                  ),
                                )
                              : SvgPicture.asset(
                                  iconPath,
                                  width: 40,
                                  height: 40,
                                ),
                          onTap: () {
                            context.read<ExamBloc>().add(
                              FetchExamPreviewEvent(subjectId: subject.id),
                            );
                            context.push(AppRouter.subjectDetail(subject.id));
                          },
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isMonochromeIcon(String iconName) {
    switch (iconName) {
      case 'biologyIcon':
      case 'englishIcon':
      case 'geographyIcon':
      case 'historyIcon':
        return true;
      default:
        return false;
    }
  }

  Widget _headingExam(BuildContext context) {
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
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Ôn theo môn học',
              style: AppTypography.headlineMedium(color: Theme.of(context).colorScheme.onSurface),
            ),
          ],
        ),
        InkWell(
          onTap: () {

          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Xem tất cả',
                  style: AppTypography.labelMedium(color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  String getIconPath(String iconName) {
    switch (iconName) {
      case 'mathIcon':
        return AppAssetIcon.mathIcon;
      case 'physicsIcon':
        return AppAssetIcon.atomColorIcon; // Vật Lý
      case 'chemistryIcon':
        return AppAssetIcon.chemistryIcon; // Hóa học
      case 'biologyIcon':
        return AppAssetIcon.biologyIcon; // Sinh học (tạm dùng ovalIcon)
      case 'historyIcon':
        return AppAssetIcon.clockIcon; // Lịch sử (tạm dùng clockIcon)
      case 'geographyIcon':
        return AppAssetIcon.geographyIcon; // Địa lý (tạm dùng newMoonIcon)
      case 'englishIcon':
        return AppAssetIcon.englishIcon; // Tiếng Anh
      default:
        return AppAssetIcon.bookopenIcon; // Mặc định
    }
  }

  Color getThemeColor(String colorName) {
    switch (colorName) {
      case 'primary':
      case 'primaryLight':
        return AppColors.primary;
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      case 'green':
      case 'success':
        return AppColors.success;
      case 'warning':
        return AppColors.warning;
      case 'teal':
        return Colors.teal;
      case 'error':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }
}
