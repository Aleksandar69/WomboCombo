import 'dart:async';
import 'dart:math';

import 'package:flutter_tts/flutter_tts.dart';

import '../../widgets/buttons/timer_button.dart';
import '../../widgets/gradient.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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

  var currentTermToPrint = 'READY';

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  var isRunning = false;

  var started = false;
  final playerBeep = AudioPlayer();
  final playerRing = AudioPlayer();

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
    previousScreen = countdownTimerStuff[4] as String;
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
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setPauseHandler(() {
      setState(() {
        print("Paused");
        ttsState = TtsState.paused;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
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
    timerAttacks?.cancel();
    _stop();
  }

  void resetAndStartTimer() {
    setState(() {
      started = false;
      initialCountdown = initialCountdownMax;
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
      isRunning = true;
    });
    if (reset) {
      resetTimer();
    }
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      print('in timer 1');
      if (started == false) {
        if (initialCountdown > 0) {
          print('cd tz timer ended');
          timerAttacks?.cancel();
          futureTimerHasEnded = true;
          playBeep();
          setState(() => initialCountdown--);
        } else {
          setState(() => started = true);
        }

        if (maxSeconds - secs == 1) {
          print('cd tz timer ended');
          timerAttacks?.cancel();
          futureTimerHasEnded = true;
        }
      }
      if (secs > 0) {
        var initialBeep = maxSeconds - 3;
        if (secs == initialBeep) {
          print('cd tz timer ended');
          timerAttacks?.cancel();
          futureTimerHasEnded = true;
          playBell();
        }
        if (secs < initialBeep && futureTimerHasEnded == true) {
          print('tz timer called');
          startSpeakTimer();
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

  Future _speak() async {
    await flutterTts.speak(currentTermToPrint);
  }

  Future _stop() async {
    await flutterTts.stop();
  }

  Timer? timerAttacks;

  void startSpeakTimer() {
    // print('startspeakertimer before delayed: ' +
    //     currentTermToPrint +
    //     ' ' +
    //     DateTime.now().millisecondsSinceEpoch.toString());
    // Future.delayed(const Duration(seconds: 5), () {
    //   print('5 second has passed speak'); // Prints after 1 second.
    //   currentTermToPrint = currentTerms;
    //   _speak();
    //   print('startspeakertimer after delayed _speak(): ' +
    //       currentTermToPrint +
    //       ' ' +
    //       DateTime.now().millisecondsSinceEpoch.toString());
    //   futureTimerHasEnded = true;
    // });
    futureTimerHasEnded = false;
    print('tz in timer');
    timerAttacks = Timer.periodic(Duration(seconds: 5), (_) {
      print('tz timer started');
      var rng = Random();
      var currentTerms = terms[rng.nextInt(2)].toString();
      currentTermToPrint = currentTerms;
      _speak();
      futureTimerHasEnded = true;
      timerAttacks?.cancel();
      print('tz timer ended');
    });

    // timerAttacks = Timer(Duration(seconds: 5), () {
    //   currentTermToPrint = currentTerms;
    //   _speak();
    //   futureTimerHasEnded = true;
    // });
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
                        startSpeakTimer();
                        print('StartSpeak button');
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
                        startSpeakTimer();
                        print('StartSpeak button2');
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
        ButtonWidget(
          text: 'playSound',
          color: Colors.black,
          backgroundColor: Colors.white,
          onClicked: () {
            startSpeakTimer();
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
    } else {
      return started
          ? Column(
              children: [
                Center(child: buildTime()),
                Transform.rotate(
                  angle: pi / 180 * 180,
                  alignment: Alignment.center,
                  child: LinearProgressIndicator(
                    value: secs / (maxSeconds - 3), // 1 - seconds / maxSeconds
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
      return
          // AnimatedTextKit(
          //   animatedTexts: [
          //     FadeAnimatedText(currentTermToPrint,
          //         duration: Duration(seconds: 5),
          //         fadeOutBegin: 0.8,
          //         fadeInEnd: 0.4,
          //         textStyle: TextStyle(
          //           fontSize: 30,
          //           fontWeight: FontWeight.bold,
          //         )),
          //   ],
          //   pause: Duration(seconds: 5),
          //   onTap: () {},
          //   isRepeatingAnimation: true,
          // );
          Text(
        currentTermToPrint,
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
