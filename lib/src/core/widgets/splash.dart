import 'package:flutter/material.dart';
import 'package:quiz_mater_apllication/src/core/constants/AppAssets/app_asset.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});
  @override
  Widget build(BuildContext context) {
    // return
    return Scaffold(
      body: Center(child: Image.asset(AppAsset.splashImage, fit: BoxFit.cover)),
    );
  }
}
