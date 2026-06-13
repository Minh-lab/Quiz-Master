import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_colors.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';

class ExamCountdownTimer extends StatefulWidget {
  final int durationMinutes;
  final VoidCallback onTimeComplete;
  final Function(int remainingSeconds) onTick;

  const ExamCountdownTimer({
    super.key,
    required this.durationMinutes,
    required this.onTimeComplete,
    required this.onTick,
  });

  @override
  State<ExamCountdownTimer> createState() => _ExamCountdownTimerState();
}

class _ExamCountdownTimerState extends State<ExamCountdownTimer> {
  late final ValueNotifier<int> _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = ValueNotifier<int>(widget.durationMinutes * 60);
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds.value > 0) {
        _remainingSeconds.value--;
        widget.onTick(_remainingSeconds.value);
      } else {
        _timer?.cancel();
        widget.onTimeComplete();
      }
    });
  }

  String _formatDisplay(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _remainingSeconds.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _remainingSeconds,
      builder: (context, remainingSecs, child) {
        final colorScheme = Theme.of(context).colorScheme;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final isUrgent = remainingSecs < 300;
        final urgentColor = isDark ? AppColors.darkError : AppColors.error;
        final urgentBg =
            isDark ? AppColors.darkErrorBackground : AppColors.errorBackground;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isUrgent ? urgentBg : colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isUrgent ? urgentColor : colorScheme.outlineVariant,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.access_time_filled_rounded,
                color: isUrgent ? urgentColor : colorScheme.onSurface,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                _formatDisplay(remainingSecs),
                style: AppTypography.headlineSmall().copyWith(
                  color: isUrgent ? urgentColor : colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
