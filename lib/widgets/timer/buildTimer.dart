// import 'package:flutter/material.dart';

// class BuildTimer extends StatelessWidget {
//   var started;
//   var secs;
//   var maxSeconds;
//   var initialCountdown;
//   var initialCountdownMax;
//   BuildTimer(
//     this.started,
//     this.secs,
//     this.maxSeconds,
//     this.initialCountdown,
//     this.initialCountdownMax,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 200,
//       height: 200,
//       child: Stack(
//         fit: StackFit.expand,
//         children: started
//             ? [
//                 CircularProgressIndicator(
//                   value: secs / (maxSeconds - 3), // 1 - seconds / maxSeconds
//                   valueColor: AlwaysStoppedAnimation(Colors.white),
//                   strokeWidth: 12,
//                   backgroundColor: Colors.green,
//                 ),
//                 Center(child: buildTime()),
//               ]
//             : [
//                 CircularProgressIndicator(
//                   value: initialCountdown /
//                       initialCountdownMax, // 1 - seconds / maxSeconds
//                   valueColor: AlwaysStoppedAnimation(Colors.white),
//                   strokeWidth: 12,
//                   backgroundColor: Colors.green,
//                 ),
//                 Center(child: buildTime()),
//               ],
//       ),
//     );
//   }
// }
