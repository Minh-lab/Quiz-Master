import 'package:flutter/material.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.08),
            blurRadius: isDark ? 18 : 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}
