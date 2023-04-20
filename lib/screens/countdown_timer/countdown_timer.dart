import 'dart:async';
import 'dart:math';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:wombocombo/widgets/timer/build_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/gradient.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../widgets/timer/build_timer.dart';

import 'package:wakelock/wakelock.dart';

class CountdownTimer extends StatefulWidget {
  static const routeName = '/countown-timer';
  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

enum TtsState { playing, stopped, paused, continued }

class _CountdownTimerState extends State<CountdownTimer>
    with WidgetsBindingObserver {
  var currentAttacks = [];
  var currentUser;

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
  late String trainingLevel;
  late List customCombos = [];
  var pointsEarnedText;

  late AnimationController _controller;

  List<String> attacks = [];

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

  var user;
  var currentPoints;

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

  void setUserPoints(userPoints) {
    currentUser = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .update({'userPoints': userPoints});
  }

  void getUser() async {
    currentUser = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get()
        .then((value) {
      user = value;
    });

    currentPoints = user['userPoints'];
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
    final args = ModalRoute.of(context)!.settings.arguments as List;
    final mnts = args[0];
    final scnds = args[1];
    final restMins = args[2];
    final restSecs = args[3];
    final rnds = args[4];
    previousScreen = args[5] as String;
    trainingLevel = args[6] as String;
    customCombos = args[7] as List;

    if (previousScreen == 'fromMakeYourComboScreen') {
      currentAttacks = List.from(customCombos);
    }

    if (trainingLevel == 'Beginner' && previousScreen == 'fromQuickCombos') {
      currentAttacks = [
        '2 4 3',
        '1 2 3',
        '1 1 5',
        '1 1 2',
        '1 6 4',
      ];
    } else if (trainingLevel == 'Intermediate' &&
        previousScreen == 'fromQuickCombos') {
      currentAttacks = [
        '2 4 3',
        '1 2 3 4',
        '1 1 5 6',
        '1 1 2',
        '1 6 4 3',
      ];
    } else if (trainingLevel == 'Advanced' &&
        previousScreen == 'fromQuickCombos') {
      currentAttacks = [
        '2 4 3 3',
        '1 2 3 4 1',
        '1 1 5 6 2 ',
        '1 1 2 3',
        '1 6 4 3 3'
      ];
    } else if (trainingLevel == 'Nightmare' &&
        previousScreen == 'fromQuickCombos') {
      currentAttacks = [
        '2 4 3 3 3',
        '1 2 3 4 1 2',
        '1 1 5 6 2 2',
        '1 1 2 3 1',
        '1 6 4 3 3 4'
      ];
    }

    restTimeMax = restSecs + (restMins * 60);
    final totalDuration = scnds + (mnts * 60);
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
    getUser();
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
            (previousScreen == 'fromQuickCombos' ||
                previousScreen == 'fromMakeYourComboScreen')) {
          startSpeakTimer();
        }
        setState(() => secs = secs - 1);
      } else {
        playBell();
        if (rounds > 1) {
          setState(() => rounds--);
          setState(() => currentRound++);
          stopTimer(resetAndStart: true);
        } else {
          var totalPts;
          if (trainingLevel == 'Beginner' &&
              previousScreen == 'fromQuickCombos' &&
              maxSeconds >= 60) {
            totalPts = 1 + rounds;
          } else if (trainingLevel == 'Beginner' &&
              previousScreen == 'fromQuickCombos' &&
              maxSeconds < 60) {
            totalPts = 1;
          } else if (trainingLevel == 'Intermediate' &&
              previousScreen == 'fromQuickCombos' &&
              maxSeconds >= 60) {
            totalPts = 2 + rounds;
          } else if (trainingLevel == 'Intermediate' &&
              previousScreen == 'fromQuickCombos' &&
              maxSeconds < 60) {
            totalPts = 2;
          } else if (trainingLevel == 'Advanced' &&
              previousScreen == 'fromQuickCombos' &&
              maxSeconds >= 60) {
            totalPts = 3 + rounds;
          } else if (trainingLevel == 'Advanced' &&
              previousScreen == 'fromQuickCombos' &&
              maxSeconds < 60) {
            totalPts = 3;
          } else if (trainingLevel == 'Nightmare' &&
              previousScreen == 'fromQuickCombos' &&
              maxSeconds >= 60) {
            totalPts = 5 + rounds;
          } else if (trainingLevel == 'Nightmare' &&
              previousScreen == 'fromQuickCombos' &&
              maxSeconds < 60) {
            totalPts = 5;
          }
          pointsEarnedText = '+$totalPts WomboCombo Points';
          setUserPoints(currentPoints + totalPts);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(pointsEarnedText),
            ),
          );
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(pointsEarnedText),
          //     duration: Duration(seconds: 2),
          //     behavior: SnackBarBehavior.floating,
          //     shape: RoundedRectangleBorder(
          //         borderRadius:
          //             BorderRadius.vertical(top: Radius.circular(10))),
          //     backgroundColor: Colors.grey[800],
          //     elevation: 0,
          //     margin: EdgeInsets.only(bottom: 70, left: 20, right: 20),
          //     animation: CurvedAnimation(
          //       parent: Tween<double>(begin: 0, end: 1).animate(_controller),
          //       curve: Curves.easeOut,
          //     ),
          //     action: SnackBarAction(
          //       label: 'close',
          //       textColor: Colors.white,
          //       onPressed: () {
          //         // Do something when the user presses the action button
          //       },
          //     ),
          //   ),
          // );
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

    if (previousScreen == 'fromMakeYourComboScreen') {
      timerAttacks = Timer.periodic(Duration(seconds: 5), (_) {
        var rng = Random();
        var currentTerms =
            currentAttacks[rng.nextInt(currentAttacks.length)].toString();
        currentTerm = currentTerms;
        _speak();
        futureTimerHasEnded = true;
        timerAttacks?.cancel();
      });
    } else if (trainingLevel == 'Beginner' &&
        previousScreen == 'fromQuickCombos') {
      timerAttacks = Timer.periodic(Duration(seconds: 5), (_) {
        var rng = Random();
        var currentTerms =
            currentAttacks[rng.nextInt(currentAttacks.length)].toString();
        currentTerm = currentTerms;
        _speak();
        futureTimerHasEnded = true;
        timerAttacks?.cancel();
      });
    } else if (trainingLevel == 'Intermediate' &&
        previousScreen == 'fromQuickCombos') {
      timerAttacks = Timer.periodic(Duration(seconds: 3), (_) {
        var rng = Random();
        var currentTerms =
            currentAttacks[rng.nextInt(currentAttacks.length)].toString();
        currentTerm = currentTerms;
        _speak();
        futureTimerHasEnded = true;
        timerAttacks?.cancel();
      });
    } else if (trainingLevel == 'Advanced' &&
        previousScreen == 'fromQuickCombos') {
      timerAttacks = Timer.periodic(Duration(milliseconds: 2500), (_) {
        var rng = Random();
        var currentTerms =
            currentAttacks[rng.nextInt(currentAttacks.length)].toString();
        currentTerm = currentTerms;
        _speak();
        futureTimerHasEnded = true;
        timerAttacks?.cancel();
      });
    } else if (trainingLevel == 'Nightmare' &&
        previousScreen == 'fromQuickCombos') {
      timerAttacks = Timer.periodic(Duration(seconds: 2), (_) {
        var rng = Random();
        var currentTerms =
            currentAttacks[rng.nextInt(currentAttacks.length)].toString();
        currentTerm = currentTerms;
        _speak();
        futureTimerHasEnded = true;
        timerAttacks?.cancel();
      });
    }
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
                buildTimer(previousScreen, started, secs, maxSeconds,
                    initialCountdown, currentTerm, initialCountdownMax),
                const SizedBox(height: 80),
                buildButtons(
                    timer,
                    secs,
                    maxSeconds,
                    timerAttacks,
                    stopTimer,
                    startTimer,
                    previousScreen,
                    startSpeakTimer,
                    isRunning,
                    resetTimer),
              ],
            ),
          ),
        ),
      );
}