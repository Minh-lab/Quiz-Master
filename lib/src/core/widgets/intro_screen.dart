import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_mater_apllication/src/core/constants/AppAssets/app_asset.dart';
import 'package:quiz_mater_apllication/src/core/router/app_router.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_theme.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/core/widgets/app_button.dart';
import 'package:quiz_mater_apllication/src/core/widgets/app_container.dart';
import 'package:quiz_mater_apllication/src/features/subject_exem/presentation/subjects/pages/exem_subject_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarIntro(
        Image.asset(AppAssetImage.topSplash2Image, fit: BoxFit.cover),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMD),

        child: Column(
          children: [
            SizedBox(height: AppTheme.spacing3XL),
            _titleIntro('Edu Hub'),
            SizedBox(height: AppTheme.spacing3XL),

            _contentIntro(
              "Edu Hub là ứng dụng luyện đề thi miễn phí dành cho các bạn học sinh THPT Sự hài lòng của bạn là niềm vui của tôi, Xin cảm ơn!",
            ),
            Expanded(child: SizedBox()),
            AppButton(
              title: 'Tiếp tục',
              onPressed: () {
                context.push(AppRouter.exam);
              },
            ),
          ],
        ),
      ),
      // bottomNavigationBar: AppButton(title: 'Tiếp tục', onPressed: () {}),
    );
  }

  PreferredSize _appBarIntro(Image image) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(300),
      child: Container(child: image),
    );
  }

  Widget _titleIntro(String title) {
    return Text(title, style: AppTypography.displayLarge());
  }

  Widget _contentIntro(String content) {
    return Text(
      content,
      style: AppTypography.bodyLarge(),
      softWrap: true,
      textAlign: TextAlign.center,
    );
  }
}
