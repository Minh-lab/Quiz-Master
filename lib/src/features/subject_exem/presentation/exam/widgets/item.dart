import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_colors.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';

class Item extends StatelessWidget {
  final Widget icons;
  final String label;
  final int numberAnswered;
  final String timeLeft;
  final Color? backgroundColor;

  const Item({
    Key? key,
    required this.icons,
    required this.label,
    required this.numberAnswered,
    required this.timeLeft,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        spacing: 5,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: BoxBorder.all(
                color: backgroundColor ?? AppColors.primary.withValues(alpha: 0.4),
                width: 2,
              ),
            ),
            child: Center(child: icons),
          ),
          Text(
            '$label',
            style: AppTypography.bodyMedium().copyWith(
              color: AppColors.navInactive,
            ),
            softWrap: true,
          ),
          Text('$numberAnswered', style: AppTypography.headlineSmall()),
        ],
      ),
    );
  }
}
