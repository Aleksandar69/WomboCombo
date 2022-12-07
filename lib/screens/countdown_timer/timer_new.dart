import 'dart:async';

import '../../widgets/buttons/timer_button.dart';
import '../../widgets/gradient.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:is_lock_screen/is_lock_screen.dart';

class TimerNew extends StatefulWidget {
  static const routeName = 'timer-new';
  @override
  _TimerNewState createState() => _TimerNewState();
}

class _TimerNewState extends State<TimerNew> with WidgetsBindingObserver {
  static var maxSeconds = 60;
  late int secs = maxSeconds;
  Timer? timer;
  int maxRounds = 0;
  late int rounds = maxRounds;
  var currentRound = 1;
  int initialCountdownMax = 3;
  late int initialCountdown = initialCountdownMax;

  var isRunning = false;

  var started = false;
  final playerBeep = AudioPlayer();
  final playerRing = AudioPlayer();
  // late var firstBeep = getBeepOne();
  // late var secondBeep = getBeepTwo();
  // late var playBeepOneTest = playBeepOne();

  void playBell() async {
    return await playerBeep.play(AssetSource('sounds/bell.mp3'), volume: 1);
  }

  void playBeep() async {
    return await playerBeep.play(AssetSource('sounds/beep-0.mp3'), volume: 1);
  }

  void playerSetSource() async {
    await playerBeep.setSource(AssetSource('sounds/beep-0.mp3'));
    await playerRing.setSource(AssetSource('sounds/bell.mp3'));
  }

  void stopBeeps() async {
    await playerBeep.stop();
    await playerRing.stop();
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
    playerSetSource();
    startTimer();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    stopBeeps();
    stopTimer();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

//bool? result = await isLockScreen();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      stopBeeps();
      stopTimer();
    } else if (state == AppLifecycleState.resumed) {
      print('app resumed');
    } else if (state == AppLifecycleState.paused) {
      stopBeeps();
      stopTimer();
    } else if (state == AppLifecycleState.detached) {
      stopBeeps();
      stopTimer();
    }
  }

  @override
  void initState() {
    super.initState();
    playerSetSource();
    WidgetsBinding.instance.addObserver(this);
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
    setState(() {
      isRunning = false;
    });
    setState(() => timer?.cancel());
    if (reset) {
      resetTimer();
    }
    if (resetAndStart) {
      resetAndStartTimer();
    }
  }

  void startTimer({bool reset = false}) {
    setState(() {
      isRunning = true;
    });
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
        var initialBeep = maxSeconds - 3;
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
    final isActive = timer == null ? false : timer!.isActive;
    final isCompleted = secs == maxSeconds || secs == 0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 12),
            isActive || !isCompleted
                ? RawMaterialButton(
                    onPressed: () {
                      if (isActive) {
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
                      if (isActive) {
                        stopTimer(reset: false);
                      } else {
                        startTimer();
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
