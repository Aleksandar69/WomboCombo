import 'dart:async';
import 'dart:math';

import 'package:flutter_tts/flutter_tts.dart';

import '../../widgets/buttons/timer_button.dart';
import '../../widgets/gradient.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:wakelock/wakelock.dart';

class TimerNew extends StatefulWidget {
  static const routeName = 'timer-new';
  @override
  _TimerNewState createState() => _TimerNewState();
}

enum TtsState { playing, stopped, paused, continued }

class _TimerNewState extends State<TimerNew> with WidgetsBindingObserver {
  var terms = ['2 4 3', '1 2 3 4', '1 1 5'];
  late FlutterTts flutterTts;
  String? language = 'en_US';
  String? engine = 'com.google.android.tts';
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;

  static var maxSeconds = 60;
  late int secs = maxSeconds;
  Timer? timer;
  Timer? timerSpeak;

  int maxRounds = 0;
  late int rounds = maxRounds;
  var currentRound = 1;
  int initialCountdownMax = 3;
  late int initialCountdown = initialCountdownMax;
  late final previousScreen;
  TtsState ttsState = TtsState.stopped;
  var futureTimerHasEnded = true;
  late int restTimeMax;
  late int restTime = restTimeMax;
  bool isInitialRun = true;

  var currentTerm = 'READY';

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  var isRunning = false;

  var started = false;
  final playerBeep = AudioPlayer();
  final playerRing = AudioPlayer();
  final playerTenSecs = AudioPlayer();

  void playBell() async {
    return await playerRing.play(AssetSource('sounds/bell.mp3'), volume: 1);
  }

  void playBeep() async {
    return await playerBeep.play(AssetSource('sounds/beep-0.mp3'), volume: 1);
  }

  void playTenSecsSound() async {
    return await playerTenSecs.play(AssetSource('sounds/10secsremaining.mp3'),
        volume: 1);
  }

  void playerSetSource() async {
    await playerBeep.setSource(AssetSource('sounds/beep-0.mp3'));
    await playerRing.setSource(AssetSource('sounds/bell.mp3'));
    await playerTenSecs.setSource(AssetSource('sounds/10secsremaining.mp3'));
  }

  void stopBeeps() async {
    await playerBeep.stop();
    await playerRing.stop();
    await playerTenSecs.stop();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      Wakelock.enable();
    });
    final countdownTimerStuff =
        ModalRoute.of(context)!.settings.arguments as List;
    final hrs = countdownTimerStuff[0];
    final mnts = countdownTimerStuff[1];
    final scnds = countdownTimerStuff[2];
    final rnds = countdownTimerStuff[3];
    previousScreen = countdownTimerStuff[4] as String;

    restTimeMax = countdownTimerStuff[5];
    final totalDuration = scnds + (mnts * 60) + (hrs * 3600);
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
    timerAttacks?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      timerAttacks?.cancel();
      stopBeeps();
      stopTimer();
    } else if (state == AppLifecycleState.resumed) {
    } else if (state == AppLifecycleState.paused) {
      timerAttacks?.cancel();
      stopBeeps();
      stopTimer();
    } else if (state == AppLifecycleState.detached) {
      timerAttacks?.cancel();
      stopBeeps();
      stopTimer();
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      Wakelock.enable();
    });
    playerSetSource();
    initTts();
    WidgetsBinding.instance.addObserver(this);
  }

  initTts() async {
    flutterTts = FlutterTts();
    await flutterTts.setLanguage(language!);
    await flutterTts.setEngine(engine!);

    _setAwaitOptions();

    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setPauseHandler(() {
      setState(() {
        ttsState = TtsState.paused;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  void resetTimer() {
    setState(() {
      currentTerm = 'READY';
      isInitialRun = true;
      currentRound = 1;
      rounds = maxRounds;
      started = false;
      if (isInitialRun) {
        initialCountdown = initialCountdownMax;
      } else {
        initialCountdown = restTimeMax;
      }
      secs = maxSeconds;
    });
    stopTimer();
    timerAttacks?.cancel();
    _stop();
  }

  void resetAndStartTimer() {
    setState(() {
      currentTerm = 'READY';
      started = false;
      if (isInitialRun) {
        initialCountdown = initialCountdownMax;
      } else {
        initialCountdown = restTimeMax;
      }
      secs = maxSeconds;
    });
    _stop();
    timerAttacks?.cancel();
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
      Wakelock.enable();
    });
    setState(() {
      isRunning = true;
    });
    if (reset) {
      resetTimer();
    }
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (!started && isInitialRun) {
        print('secs: $secs');
        if (initialCountdown > 0) {
          timerAttacks?.cancel();
          futureTimerHasEnded = true;
          playBeep();
          setState(() => initialCountdown--);
        } else {
          playBell();
          setState(() {
            started = true;
            isInitialRun = false;
          });
        }
      } else if (!started && !isInitialRun) {
        timerAttacks?.cancel();
        initialCountdownMax = restTimeMax;
        initialCountdown = restTime;

        if (initialCountdown > 3) {
          setState(() {
            restTime--;
            initialCountdown = restTime;
          });
        } else if (initialCountdown > 0 && initialCountdown <= 3) {
          timerAttacks?.cancel();
          futureTimerHasEnded = true;
          playBeep();
          setState(() {
            restTime--;
            initialCountdown = restTime;
          });
        } else if (initialCountdown == 0) {
          playBell();
          setState(() {
            restTime = restTimeMax;
            started = true;
            isInitialRun = false;
          });
        }
      } else if (secs > 0) {
        if (secs == 10) {
          playTenSecsSound();
        } else if (secs <= 3 && secs > 0) {
          playBeep();
        }
        if (maxSeconds - secs == 1) {
          timerAttacks?.cancel();
          futureTimerHasEnded = true;
        }
        if (secs == maxSeconds) {
          timerAttacks?.cancel();
          futureTimerHasEnded = true;
        }
        if (secs < maxSeconds &&
            futureTimerHasEnded == true &&
            previousScreen == 'fromQuickCombos') {
          startSpeakTimer();
        }
        setState(() => secs = secs - 1);
      } else {
        playBell();
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

  Future _speak() async {
    await flutterTts.speak(currentTerm);
  }

  Future _stop() async {
    await flutterTts.stop();
  }

  Timer? timerAttacks;

  void startSpeakTimer() {
    futureTimerHasEnded = false;

    timerAttacks = Timer.periodic(Duration(seconds: 3), (_) {
      var rng = Random();
      var currentTerms = terms[rng.nextInt(2)].toString();
      currentTerm = currentTerms;
      _speak();
      futureTimerHasEnded = true;
      timerAttacks?.cancel();
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
                        timerAttacks?.cancel();
                        stopTimer(reset: false);
                      } else {
                        startTimer(reset: false);
                        if (previousScreen == 'fromQuickCombos') {
                          startSpeakTimer();
                        }
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
                        timerAttacks?.cancel();
                      } else {
                        startTimer();
                        startSpeakTimer();
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

  Widget buildTimer() {
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
    } else {
      return started
          ? Column(
              children: [
                Center(child: buildTime()),
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
              Center(child: buildTime()),
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

  Widget buildTime() {
    final time = secs;
    if (previousScreen == 'fromHomeScreen') {
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
    } else if (previousScreen == 'fromQuickCombos') {
      return Text(
        currentTerm,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 80,
        ),
      );
    } else {
      return Text(
        'test2',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 80,
        ),
      );
    }
  }
}
