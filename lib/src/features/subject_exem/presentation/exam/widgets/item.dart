import 'package:flutter/material.dart';
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
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
        spacing: 5,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.surfaceContainerHigh,
              border: Border.all(
                color: backgroundColor ?? colorScheme.primary,
                width: 2,
              ),
            ),
            child: Center(child: icons),
          ),
          Text(
            '$label',
            style: AppTypography.bodyMedium().copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            softWrap: true,
          ),
          Text(
            '$numberAnswered',
            style: AppTypography.headlineSmall(color: colorScheme.onSurface),
          ),
        ],
    );
  }
}
