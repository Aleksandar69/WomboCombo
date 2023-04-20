import 'package:flutter/material.dart';
import '../../widgets/timer/build_time.dart';
import 'dart:math';

Widget buildTimer(previousScreen, started, secs, maxSeconds, initialCountdown,
    currentTerm, initialCountdownMax) {
  if (previousScreen == 'fromHomeScreen') {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        fit: StackFit.expand,
        children: started
            ? [
                CircularProgressIndicator(
                  value: secs / (maxSeconds), // 1 - seconds / maxSeconds
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                  strokeWidth: 12,
                  backgroundColor: Colors.green,
                ),
                Center(
                    child: buildTime(secs, previousScreen, started,
                        initialCountdown, currentTerm)),
              ]
            : [
                CircularProgressIndicator(
                  value: initialCountdown /
                      initialCountdownMax, // 1 - seconds / maxSeconds
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                  strokeWidth: 12,
                  backgroundColor: Colors.green,
                ),
                Center(
                    child: buildTime(secs, previousScreen, started,
                        initialCountdown, currentTerm)),
              ],
      ),
    );
  } else {
    return started
        ? Column(
            children: [
              Center(
                  child: buildTime(secs, previousScreen, started,
                      initialCountdown, currentTerm)),
              Transform.rotate(
                angle: pi / 180 * 180,
                alignment: Alignment.center,
                child: LinearProgressIndicator(
                  value: secs / (maxSeconds), // 1 - seconds / maxSeconds
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          )
        : Column(children: [
            Center(
                child: buildTime(secs, previousScreen, started,
                    initialCountdown, currentTerm)),
            Transform.rotate(
              angle: pi / 180 * 180,
              alignment: Alignment.center,
              child: LinearProgressIndicator(
                value: initialCountdown /
                    initialCountdownMax, // 1 - seconds / maxSeconds
                valueColor: AlwaysStoppedAnimation(Colors.white),
                backgroundColor: Colors.green,
              ),
            ),
          ]);
  }
}
