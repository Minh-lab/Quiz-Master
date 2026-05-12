import 'package:flutter/material.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_colors.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_theme.dart';

class AppContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding; // Nên dùng kiểu này thay vì double
  const AppContainer({
    Key? key,
    this.height,
    this.width,
    required this.child,
    this.padding,
    this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColors.surface.withValues(alpha: 0.8), //
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: AppTheme.radiusLG,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
