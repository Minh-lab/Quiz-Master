import 'package:flutter/material.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_colors.dart';

class AppContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget child;
  final double? padding;

  const AppContainer({
    Key? key,
    this.height,
    this.width,
    required this.child,
    this.padding,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: width ?? 200,
      height: height ?? 100,
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.8), //
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
