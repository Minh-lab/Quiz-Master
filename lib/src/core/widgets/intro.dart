import 'package:flutter/material.dart';
import 'package:quiz_mater_apllication/src/core/constants/AppAssets/app_asset.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_theme.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/core/widgets/app_button.dart';

class Intro extends StatelessWidget {
  const Intro({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarIntro(
        Image.asset(AppAsset.topSplash2Image, fit: BoxFit.cover),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          children: [
            SizedBox(height: 50),
            _titleIntro('Edu Hub'),
            SizedBox(height: 30),

            _contentIntro(
              "Edu Hub là ứng dụng luyện đề thi miễn phí dành cho các bạn học sinh THPT Sự hài lòng của bạn là niềm vui của tôi, Xin cảm ơn!",
            ),
            Expanded(child: SizedBox()),
            AppButton(title: 'Tiếp tục', onPressed: () {}),
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
