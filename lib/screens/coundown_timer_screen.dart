import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

class CountdownTimerScreen extends StatefulWidget {
  static const routeName = '/timer';

  // int _hours;
  // int _minutes;
  // int _seconds;
  // int _rounds;

  // CountdownTimerScreen(
  //   @required this._hours,
  //   @required this._minutes,
  //   @required this._seconds,
  //   @required this._rounds,
  // );

  @override
  State<CountdownTimerScreen> createState() => _CountdownTimerScreenState();
}

class _CountdownTimerScreenState extends State<CountdownTimerScreen> {
  Timer? countdownTimer;
  Duration myDuration = Duration(seconds: 180);

  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  // Step 4
  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  // Step 5
  void resetTimer() {
    stopTimer();
    setState(
      () => myDuration = Duration(
        seconds: 180,
      ),
    );
  }

  @override
  void dispose() {
    countdownTimer!.cancel();
    super.dispose();
  }

  @override
  didChangeDependencies() {
    final countdownTImerStuff =
        ModalRoute.of(context)!.settings.arguments as List;
    final hrs = countdownTImerStuff[0];
    final mnts = countdownTImerStuff[1];
    final scnds = countdownTImerStuff[2];
    final rnds = countdownTImerStuff[3];
    final totalDuration = scnds + (mnts*60) + (hrs*3600);
    myDuration = Duration(seconds: scnds);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  // Step 6
  void setCountDown() {
    final reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final hours = strDigits(myDuration.inHours.remainder(24));
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            // Step 8
            Text(
              '$hours:$minutes:$seconds',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 50),
            ),
            SizedBox(height: 20),
            // Step 9
            ElevatedButton(
              onPressed: startTimer,
              child: Text(
                'Start',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            // Step 10
            ElevatedButton(
              onPressed: () {
                if (countdownTimer == null || countdownTimer!.isActive) {
                  stopTimer();
                }
              },
              child: Text(
                'Stop',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            // Step 11
            ElevatedButton(
                onPressed: () {
                  resetTimer();
                },
                child: Text(
                  'Reset',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
