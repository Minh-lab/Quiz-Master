import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimerCubit extends Cubit<int> {
  Timer? _timer;
  DateTime? _endTime;

  TimerCubit() : super(-1); // -1 nghĩa là chưa bắt đầu

  void startTimer(int durationInMinutes) {
    _endTime = DateTime.now().add(Duration(minutes: durationInMinutes));
    final initialSeconds = durationInMinutes * 60;
    emit(initialSeconds);
    
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  void _tick(Timer timer) {
    if (_endTime == null) return;
    
    final now = DateTime.now();
    final remaining = _endTime!.difference(now).inSeconds;
    
    if (remaining <= 0) {
      timer.cancel();
      emit(0);
    } else {
      emit(remaining);
    }
  }

  void onAppResumed() {
    if (_endTime != null) {
      final now = DateTime.now();
      if (_endTime!.isAfter(now)) {
        // App mở lại và thời gian vẫn còn -> Khởi động lại luồng timer
        _timer?.cancel();
        _timer = Timer.periodic(const Duration(seconds: 1), _tick);
        _tick(_timer!);
      } else {
        // App mở lại và đã lố giờ -> Ép về 0
        _timer?.cancel();
        emit(0);
      }
    }
  }

  void stopTimer() {
    _timer?.cancel();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
