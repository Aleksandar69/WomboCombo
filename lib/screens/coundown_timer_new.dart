import 'dart:async';

import '../widgets/timer_button.dart';
import '../widgets/gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CountdownTimerNew extends StatefulWidget {
  static const routeName = 'countdown-timer-new';
  @override
  _CountdownTimerNewState createState() => _CountdownTimerNewState();
}

class _CountdownTimerNewState extends State<CountdownTimerNew> {
  static int maxSeconds = 60;
  static int maxRounds = 3;
  int seconds = maxSeconds;
  int rounds = maxRounds;
  int currentRound = 1;
  Timer? timer;

  @override
  void didChangeDependencies() {
    final countdownTimerStuff =
        ModalRoute.of(context)!.settings.arguments as List;
    final hrs = countdownTimerStuff[0];
    final mnts = countdownTimerStuff[1];
    final scnds = countdownTimerStuff[2];
    final rnds = countdownTimerStuff[3];
    final totalDuration = scnds + (mnts * 60) + (hrs * 3600);
    maxRounds = rnds+1;
    print('didchangedep' + rnds.toString());
    maxSeconds = totalDuration;
    seconds = maxSeconds;
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
      seconds = maxSeconds;
      rounds = maxRounds;
    });
  }

  void resetAndStartTimer() {
    setState(() {
      seconds = maxSeconds;
    });
    startTimer();
  }

  void startTimer({bool reset = false}) {
    if (reset) {
      resetTimer();
    }

    /// For real apps change Duration to --> seconds: 1
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (seconds > 0) {
        setState(() => seconds = seconds - 1);
        print('secinds: ' + seconds.toString());
      } else {
        if (rounds > 0) {
          setState(() => rounds = rounds - 1);
          print('rounds: ' + rounds.toString());
          setState(() => rounds = rounds - 1);
          print('rounds: ' + rounds.toString());
          setState(() => currentRound = currentRound + 1);
          stopTimer(resetAndStart: true);
        } else {
          print('In rounds else' + rounds.toString());
          stopTimer(reset: false);
        }
      }
    });
  }

  void stopTimer({bool reset = false, resetAndStart = false}) {
    if (reset) {
      resetTimer();
    }
    if (resetAndStart) {
      resetAndStartTimer();
    }

    setState(() => timer?.cancel());
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
    final isCompleted = seconds == maxSeconds || seconds == 0;

    return isRunning || !isCompleted
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                text: isRunning ? 'Pause' : 'Resume',
                onClicked: () {
                  if (isRunning) {
                    stopTimer(reset: false);
                  } else {
                    startTimer(reset: false);
                  }
                },
              ),
              const SizedBox(width: 12),
              ButtonWidget(
                text: 'Cancel',
                onClicked: stopTimer,
              ),
            ],
          )
        : ButtonWidget(
            text: 'Start Timer!',
            color: Colors.black,
            backgroundColor: Colors.white,
            onClicked: () {
              startTimer();
            },
          );
  }

  Widget buildTimer() => SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: seconds / maxSeconds, // 1 - seconds / maxSeconds
              valueColor: AlwaysStoppedAnimation(Colors.white),
              strokeWidth: 12,
              backgroundColor: Colors.greenAccent,
            ),
            Center(child: buildTime()),
          ],
        ),
      );

  Widget buildTime() {
    if (seconds == 0) {
      return Icon(Icons.done, color: Colors.greenAccent, size: 112);
    } else {
      return Text(
        '$seconds',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 80,
        ),
      );
    }
  }
}
