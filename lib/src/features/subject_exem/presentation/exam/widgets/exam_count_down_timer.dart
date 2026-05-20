import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_colors.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';

class ExamCountdownTimer extends StatefulWidget {
  final int durationMinutes; // Thời lượng đề thi (ví dụ: 90 phút)
  final VoidCallback
  onTimeComplete; // Callback kích hoạt tự động nộp bài khi hết giờ
  final Function(int remainingSeconds)
  onTick; // Callback cập nhật số giây còn lại cho màn hình cha

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
    // 1. Quy đổi thời gian từ Phút sang Giây
    _remainingSeconds = ValueNotifier<int>(widget.durationMinutes * 60);

    // 2. Bắt đầu bộ đếm ngược từng giây
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds.value > 0) {
        _remainingSeconds.value--;
        widget.onTick(
          _remainingSeconds.value,
        ); // Đồng bộ số giây còn lại về màn hình cha
      } else {
        _timer?.cancel();
        widget.onTimeComplete(); // Kích hoạt sự kiện hết giờ
      }
    });
  }

  // Hàm định dạng chữ số thời gian hiển thị
  String _formatDisplay(int seconds) {
    final int mins = seconds ~/ 60;
    final int secs = seconds % 60;
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
    // 🌟 CHỈ REBUILD duy nhất khu vực này mỗi giây nhờ ValueListenableBuilder!
    return ValueListenableBuilder<int>(
      valueListenable: _remainingSeconds,
      builder: (context, remainingSecs, child) {
        final bool isUrgent =
            remainingSecs < 300; // Đổi sang màu đỏ cảnh báo nếu dưới 5 phút

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isUrgent
                ? AppColors.error.withOpacity(0.1)
                : AppColors.surfaceVariant.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isUrgent ? AppColors.error : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.access_time_filled_rounded,
                color: isUrgent ? AppColors.error : Colors.white,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                _formatDisplay(remainingSecs),
                style: AppTypography.headlineSmall().copyWith(
                  color: isUrgent ? AppColors.error : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFeatures: const [
                    FontFeature.tabularFigures(),
                  ], // Giữ cố định kích thước chữ số không bị lệch giật khi đếm
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
