// import 'package:flutter/cupertino.dart';
// import 'package:quiz_mater_apllication/src/core/widgets/app_appbar.dart';

// class AppBar extends StatelessWidget {
//   final String title;
//   final int duration;

//   const AppBar({Key? key, required this.title, required this.duration});
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return PreferredSize(
//       preferredSize: const Size.fromHeight(70),
//       child: AppAppbar(
//         title: 'Đề thi ${title} ',
//         actions: _timeCountdown(duration: 90),
//       ),
//     );
//   }

//   String formatRemainingTime(int totalSeconds) {
//     if (totalSeconds < 0) return '00:00';

//     final int hours = totalSeconds ~/ 3600;
//     final int minutes = (totalSeconds % 3600) ~/ 60;
//     final int seconds = totalSeconds % 60;

//     final String minutesStr = minutes.toString().padLeft(2, '0');
//     final String secondsStr = seconds.toString().padLeft(2, '0');

//     if (hours > 0) {
//       final String hoursStr = hours.toString().padLeft(2, '0');
//       return '$hoursStr:$minutesStr:$secondsStr'; // Trả về định dạng HH:MM:SS nếu thi trên 1 tiếng
//     }
//     return '$minutesStr:$secondsStr'; // Trả về định dạng MM:SS nếu dưới 1 tiếng
//   }
// }
