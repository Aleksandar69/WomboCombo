import 'package:flutter/material.dart';
import '../../widgets/timer/build_time.dart';
import 'dart:math';

Widget buildTimer(previousScreen, started, secs, maxSeconds, initialCountdown,
    currentTerm, initialCountdownMax, color1, color2, color3, context) {
  if (previousScreen == 'fromHomeScreen') {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.width * 0.75,
      child: Stack(
        fit: StackFit.expand,
        children: started
            ? [
                CircularProgressIndicator(
                  value: secs / (maxSeconds), // 1 - seconds / maxSeconds
                  valueColor: AlwaysStoppedAnimation(color1),
                  strokeWidth: 12,
                  backgroundColor: color2,
                ),
                Center(
                    child: buildTime(secs, previousScreen, started,
                        initialCountdown, currentTerm, color3, context)),
              ]
            : [
                CircularProgressIndicator(
                  value: initialCountdown /
                      initialCountdownMax, // 1 - seconds / maxSeconds
                  valueColor: AlwaysStoppedAnimation(color1),
                  strokeWidth: 12,
                  backgroundColor: color2,
                ),
                Center(
                    child: buildTime(secs, previousScreen, started,
                        initialCountdown, currentTerm, color3, context)),
              ],
      ),
    );
  } else {
    return started
        ? Column(
            children: [
              Center(
                  child: buildTime(secs, previousScreen, started,
                      initialCountdown, currentTerm, color3, context)),
              Transform.rotate(
                angle: pi / 180 * 180,
                alignment: Alignment.center,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.005,
                  child: LinearProgressIndicator(
                    value: secs / (maxSeconds), // 1 - seconds / maxSeconds
                    valueColor: AlwaysStoppedAnimation(color1),
                    backgroundColor: color2,
                  ),
                ),
              ),
            ],
          )
        : Column(children: [
            Center(
                child: buildTime(secs, previousScreen, started,
                    initialCountdown, currentTerm, color3, context)),
            Transform.rotate(
              angle: pi / 180 * 180,
              alignment: Alignment.center,
              child: LinearProgressIndicator(
                value: initialCountdown /
                    initialCountdownMax, // 1 - seconds / maxSeconds
                valueColor: AlwaysStoppedAnimation(color1),
                backgroundColor: color2,
              ),
            ),
          ]);
  }
}
