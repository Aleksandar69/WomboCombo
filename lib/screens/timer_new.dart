import 'dart:async';

import '../widgets/timer_button.dart';
import '../widgets/gradient.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class TimerNew extends StatefulWidget {
  static const routeName = 'timer-new';
  @override
  _TimerNewState createState() => _TimerNewState();
}

class _TimerNewState extends State<TimerNew> {
  static var maxSeconds = 60;
  late int secs = maxSeconds;
  Timer? timer;
  int maxRounds = 0;
  late int rounds = maxRounds;
  var currentRound = 1;
  int initialCountdownMax = 3;
  late int initialCountdown = initialCountdownMax;

  var started = false;
  final player = AudioPlayer();
  // late var firstBeep = getBeepOne();
  // late var secondBeep = getBeepTwo();
  // late var playBeepOneTest = playBeepOne();

  void playBell() async {
    return await player.play(AssetSource('sounds/bell.mp3'), volume: 1);
  }

  void playBeep() async {
    return await player.play(AssetSource('sounds/beep-0.mp3'), volume: 0.2);
  }


  @override
  void didChangeDependencies() {
    final countdownTimerStuff =
        ModalRoute.of(context)!.settings.arguments as List;
    final hrs = countdownTimerStuff[0];
    final mnts = countdownTimerStuff[1];
    final scnds = countdownTimerStuff[2];
    final rnds = countdownTimerStuff[3];
    final totalDuration = scnds + (mnts * 60) + (hrs * 3600) + 3;
    maxRounds = rnds;
    maxSeconds = totalDuration;
    secs = maxSeconds;
    rounds = maxRounds;
    startTimer();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  void resetTimer() {
    setState(() {
      currentRound = 1;
      rounds = maxRounds;
      started = false;
      initialCountdown = initialCountdownMax;
      secs = maxSeconds;
    });
    stopTimer();
  }

  void resetAndStartTimer() {
    setState(() {
      started = false;
      initialCountdown = initialCountdownMax;
      secs = maxSeconds;
    });
    startTimer();
  }

  void stopTimer({bool reset = false, resetAndStart = false}) {
    setState(() => timer?.cancel());
    if (reset) {
      resetTimer();
    }
    if (resetAndStart) {
      resetAndStartTimer();
    }
  }

  void startTimer({bool reset = false}) {
    if (reset) {
      resetTimer();
    }

    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (started == false) {
        if (initialCountdown > 0) {
          playBeep();
          setState(() => initialCountdown--);
        } else {
          setState(() => started = true);
        }
      }
      if (secs > 0) {
        var initialBeep = maxSeconds-3;
        if (secs == initialBeep) {
          playBell();
        }
        setState(() => secs = secs - 1);
      } else {
        if (rounds > 0) {
          setState(() => rounds--);
          setState(() => currentRound++);
          stopTimer(resetAndStart: true);
        } else {
          setState(() => started = false);
          stopTimer(reset: false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: GradientWidget(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Round $currentRound',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                SizedBox(height: 40),
                buildTimer(),
                const SizedBox(height: 80),
                buildButtons(),
              ],
            ),
          ),
        ),
      );

  Widget buildButtons() {
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = secs == maxSeconds || secs == 0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 12),
            isRunning || !isCompleted
                ? RawMaterialButton(
                    onPressed: () {
                      if (isRunning) {
                        stopTimer(reset: false);
                      } else {
                        startTimer(reset: false);
                      }
                    },
                    elevation: 2.0,
                    fillColor: Colors.white,
                    child: !isRunning
                        ? Icon(
                            Icons.play_arrow,
                            size: 55.0,
                          )
                        : Icon(
                            Icons.pause,
                            size: 55.0,
                          ),
                    padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                  )
                : RawMaterialButton(
                    onPressed: () {
                      if (isRunning) {
                        stopTimer(reset: false);
                      } else {
                        startTimer(reset: true);
                      }
                    },
                    elevation: 2.0,
                    fillColor: Colors.white,
                    child: !isRunning
                        ? Icon(
                            Icons.play_arrow,
                            size: 55.0,
                          )
                        : Icon(
                            Icons.pause,
                            size: 55.0,
                          ),
                    padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                  ),
          ],
        ),
        const SizedBox(
          width: 12,
          height: 12,
        ),
        ButtonWidget(
          text: 'Reset',
          color: Colors.black,
          backgroundColor: Colors.white,
          onClicked: () {
            resetTimer();
          },
        ),
      ],
    );
  }

  Widget buildTimer() => SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          fit: StackFit.expand,
          children: started
              ? [
                  CircularProgressIndicator(
                    value: secs / (maxSeconds - 3), // 1 - seconds / maxSeconds
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                    strokeWidth: 12,
                    backgroundColor: Colors.green,
                  ),
                  Center(child: buildTime()),
                ]
              : [
                  CircularProgressIndicator(
                    value: initialCountdown /
                        initialCountdownMax, // 1 - seconds / maxSeconds
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                    strokeWidth: 12,
                    backgroundColor: Colors.green,
                  ),
                  Center(child: buildTime()),
                ],
        ),
      );

  Widget buildTime() {
    final time = secs;
    if (time == 0) {
      return Icon(Icons.done, color: Colors.green, size: 112);
    } else {
      return started
          ? Text(
              '${secs}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 80,
              ),
            )
          : Text(
              '${initialCountdown}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 80,
              ),
            );
    }
  }
}
