import 'dart:async';
import 'dart:math';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:wombocombo/helpers/snackbar_helper.dart';
import 'package:wombocombo/providers/auth_provider.dart';
import 'package:wombocombo/providers/user_provider.dart';
import 'package:wombocombo/widgets/timer/build_buttons.dart';
import '../../widgets/gradient.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../widgets/timer/build_timer.dart';
import '../../utils/combinations.dart';
import 'package:showcaseview/showcaseview.dart';

import 'package:wakelock/wakelock.dart';

class CountdownTimer extends StatefulWidget {
  static const routeName = '/countown-timer';
  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

enum TtsState { playing, stopped, paused, continued }

class _CountdownTimerState extends State<CountdownTimer>
    with WidgetsBindingObserver {
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();
  final GlobalKey _five = GlobalKey();

  var currentAttacks = [];
  var currentUserId;
  late final AuthProvider authProvider =
      Provider.of<AuthProvider>(context, listen: false);
  late final UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);

  late FlutterTts flutterTts;
  String? language = 'en_US';
  String? engine = 'com.google.android.tts';
  double volume = 0.5;
  double pitch = 1.0;

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
  var selectedMartialArt;

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
    userProvider.updateUserInfo(currentUserId, {'userPoints': userPoints});
  }

  void getUser() async {
    currentUserId = authProvider.userId;

    user = await userProvider.getUser(currentUserId);

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
    final rnds = args[4] + 1;
    previousScreen = args[5] as String;
    trainingLevel = args[6] as String;
    customCombos = args[7] as List;
    if (args[8] != null) {
      selectedMartialArt = args[8] as String;
    }

    if (previousScreen == 'fromMakeYourComboScreen') {
      currentAttacks = List.from(customCombos);
    }

    if (trainingLevel == 'Beginner' &&
        previousScreen == 'fromQuickCombos' &&
        selectedMartialArt == 'boxing') {
      currentAttacks = Combinations.beginnerBoxing;
    } else if (trainingLevel == 'Intermediate' &&
        previousScreen == 'fromQuickCombos' &&
        selectedMartialArt == 'boxing') {
      currentAttacks = Combinations.intermediateBoxing;
      // currentAttacks = [
      //   '1, 1, 2, 3',
      //   '1, 2, b3, 4',
      //   '2, 3, 6, 3',
      //   '3, b3, 3, 2'
      // ];
    } else if (trainingLevel == 'Advanced' &&
        previousScreen == 'fromQuickCombos' &&
        selectedMartialArt == 'boxing') {
      //currentAttacks = ['1, 1, 2, 3, 6, 3, b4, 3', '1, 3, 2, b3, 4, 3, 6, 3'];

      currentAttacks = Combinations.advancedBoxing;
    } else if (trainingLevel == 'Nightmare' &&
        previousScreen == 'fromQuickCombos' &&
        selectedMartialArt == 'boxing') {
      currentAttacks = Combinations.nightmareBoxing;
    } else if (trainingLevel == 'Beginner' &&
        previousScreen == 'fromQuickCombos' &&
        selectedMartialArt == 'kickboxing') {
      currentAttacks = Combinations.beginnerKickBoxing;
    } else if (trainingLevel == 'Intermediate' &&
        previousScreen == 'fromQuickCombos' &&
        selectedMartialArt == 'kickboxing') {
      currentAttacks = Combinations.intermediateKickboxing;
      //currentAttacks = [
      //   '1, 1, 2, Front Mid Kick',
      //   '1, 2, 3, Rear Low Kick',
      //   '1, b1, 1, Rear Rear Mid Kick',
      // ];
    } else if (trainingLevel == 'Advanced' &&
        previousScreen == 'fromQuickCombos' &&
        selectedMartialArt == 'kickboxing') {
      currentAttacks = Combinations.advancedKickboxing;
    } else if (trainingLevel == 'Nightmare' &&
        previousScreen == 'fromQuickCombos' &&
        selectedMartialArt == 'kickboxing') {
      currentAttacks = Combinations.nightmareKickboxing;
    }

    restTimeMax = restSecs + (restMins * 60);
    final totalDuration = scnds + (mnts * 60);
    maxRounds = rnds;
    maxSeconds = totalDuration;
    secs = maxSeconds;
    rounds = maxRounds;
    playerSetSource();
    //startTimer();

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
  void initState() {
    super.initState();
    setState(() {
      Wakelock.enable();
    });
    playerSetSource();
    initTts();
    WidgetsBinding.instance.addObserver(this);
    getUser();
    startShowCase();
  }

  startShowCase() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ShowCaseWidget.of(showcaseContext)
          .startShowCase([_one, _two, _three, _four, _five]);
    });
  }

  initTts() async {
    flutterTts = FlutterTts();
    await flutterTts.setLanguage(language!);
    await flutterTts.setEngine(engine!);
    await flutterTts.setSpeechRate(0.5);

    List<dynamic> voices = await flutterTts.getVoices;

    for (var voice in voices) {
      if (voice["name"] == "en-gb-x-gbb-network") {
        flutterTts.setVoice({"name": "en-gb-x-gbb-network", "locale": "en-GB"});
      }
    }

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
        initialCountdownMax = 3;
        initialCountdown = initialCountdownMax;
      } else {
        initialCountdown = restTimeMax;
      }
      print('coundtown max : $initialCountdownMax');
      print('rest max : $restTimeMax');
      print('real countdown max : $initialCountdown');

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
    _stop();
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
                previousScreen == 'fromMakeYourComboScreen') &&
            secs >= 5) {
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
          _stop();
          var totalPts;
          if (previousScreen == 'fromQuickCombos') {
            if (trainingLevel == 'Beginner' && maxSeconds >= 60) {
              totalPts = 1 + maxRounds;
            } else if (trainingLevel == 'Beginner' && maxSeconds < 60) {
              totalPts = 1;
            } else if (trainingLevel == 'Intermediate' && maxSeconds >= 60) {
              totalPts = 2 + maxRounds;
            } else if (trainingLevel == 'Intermediate' && maxSeconds < 60) {
              totalPts = 2;
            } else if (trainingLevel == 'Advanced' && maxSeconds >= 60) {
              totalPts = 3 + maxRounds;
            } else if (trainingLevel == 'Advanced' && maxSeconds < 60) {
              totalPts = 3;
            } else if (trainingLevel == 'Nightmare' && maxSeconds >= 60) {
              totalPts = 5 + maxRounds;
            } else if (trainingLevel == 'Nightmare' && maxSeconds < 60) {
              totalPts = 5;
            }
            pointsEarnedText = '+$totalPts WomboCombo Points';
            setUserPoints(currentPoints + totalPts);
          } else if (previousScreen == 'fromMakeYourComboScreen') {
            if (maxSeconds >= 60) {
              totalPts = 1 + maxRounds;
            } else if (maxSeconds < 60) {
              totalPts = 1;
            }
          }
          if (previousScreen == 'fromQuickCombos' ||
              previousScreen == 'fromMakeYourComboScreen') {
            if (totalPts == 1) {
              SnackbarHelper.showSnackbarSuccess(
                  context, "You've earned ${totalPts} point", "Good job!");
            } else {
              SnackbarHelper.showSnackbarSuccess(
                  context, "You've earned ${totalPts} points", "Good job!");
            }
          }
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
    timerAttacks?.cancel();
  }

  Timer? timerAttacks;

  void startSpeakTimer() async {
    futureTimerHasEnded = false;

    if (previousScreen == 'fromMakeYourComboScreen') {
      timerAttacks = Timer.periodic(Duration(milliseconds: 7300), (_) async {
        var rng = Random();
        await flutterTts.setSpeechRate(0.5);
        var currentTerms =
            currentAttacks[rng.nextInt(currentAttacks.length)].toString();
        currentTerm = currentTerms;
        _speak();
        futureTimerHasEnded = true;
        timerAttacks?.cancel();
      });
    } else if (trainingLevel == 'Beginner' &&
        previousScreen == 'fromQuickCombos') {
      timerAttacks = Timer.periodic(
          Duration(seconds: selectedMartialArt == "boxing" ? 5 : 5), (_) async {
        selectedMartialArt == "boxing"
            ? await flutterTts.setSpeechRate(0.6)
            : await flutterTts.setSpeechRate(0.6);

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
      timerAttacks = Timer.periodic(
          Duration(milliseconds: selectedMartialArt == "boxing" ? 6000 : 7000),
          (_) async {
        var rng = Random();
        var currentTerms =
            currentAttacks[rng.nextInt(currentAttacks.length)].toString();
        currentTerm = currentTerms;
        selectedMartialArt == "boxing"
            ? await flutterTts.setSpeechRate(0.5)
            : await flutterTts.setSpeechRate(0.5);

        _speak();
        futureTimerHasEnded = true;
        timerAttacks?.cancel();
      });
    } else if (trainingLevel == 'Advanced' &&
        previousScreen == 'fromQuickCombos') {
      timerAttacks = Timer.periodic(
          Duration(milliseconds: selectedMartialArt == "boxing" ? 6300 : 8200),
          (_) async {
        var rng = Random();
        var currentTerms =
            currentAttacks[rng.nextInt(currentAttacks.length)].toString();
        currentTerm = currentTerms;
        selectedMartialArt == "boxing"
            ? await flutterTts.setSpeechRate(0.45)
            : await flutterTts.setSpeechRate(0.35);
        _speak();
        futureTimerHasEnded = true;
        timerAttacks?.cancel();
      });
    } else if (trainingLevel == 'Nightmare' &&
        previousScreen == 'fromQuickCombos') {
      timerAttacks = Timer.periodic(
          Duration(milliseconds: selectedMartialArt == "boxing" ? 7500 : 9400),
          (_) async {
        var rng = Random();
        var currentTerms =
            currentAttacks[rng.nextInt(currentAttacks.length)].toString();
        currentTerm = currentTerms;
        selectedMartialArt == "boxing"
            ? await flutterTts.setSpeechRate(0.45)
            : await flutterTts.setSpeechRate(0.35);
        _speak();
        futureTimerHasEnded = true;
        timerAttacks?.cancel();
      });
    }
  }

  late BuildContext showcaseContext;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: WillPopScope(
          onWillPop: () async {
            stopBeeps();
            stopTimer();
            _stop();
            Navigator.of(context).pop();
            return false;
          },
          child: GradientWidget(
            child: ShowCaseWidget(
              blurValue: 1,
              disableBarrierInteraction: true,
              builder: Builder(builder: (context) {
                showcaseContext = context;
                return Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Text(
                          'Round $currentRound',
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                      ),
                      Showcase.withWidget(
                        blurValue: 1,
                        key: _three,
                        container: Column(
                          children: [
                            Container(
                              width: 300,
                              child: Text(
                                'Listen to the combinations and repeat them in real time',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  ShowCaseWidget.of(context).next();
                                },
                                child: Text('Will do')),
                          ],
                        ),
                        height: 20,
                        width: 200,
                        child: SizedBox(
                          height: 0,
                        ),
                      ),
                      Showcase.withWidget(
                        blurValue: 1,
                        key: _two,
                        container: Column(
                          children: [
                            Container(
                              width: 300,
                              child: Text(
                                'When the timer starts, leave your phone where you can hear it, or use your headphones',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  ShowCaseWidget.of(context).next();
                                  stopTimer();
                                },
                                child: Text('Okay, if I must...')),
                          ],
                        ),
                        height: 300,
                        width: 300,
                        child: SizedBox(
                          height: 0,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            stopTimer();
                            ShowCaseWidget.of(context).startShowCase(
                                [_one, _two, _three, _four, _five]);
                          },
                          child: Text('asd')),
                      buildTimer(
                          previousScreen,
                          started,
                          secs,
                          maxSeconds,
                          initialCountdown,
                          currentTerm,
                          initialCountdownMax,
                          Colors.white,
                          Colors.green,
                          Colors.white,
                          context),
                      Showcase.withWidget(
                        blurValue: 1,
                        key: _one,
                        container: Column(
                          children: [
                            Container(
                              width: 300,
                              child: Text(
                                "Hey There! We'll let you get back to your training in a second, we promise!",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  ShowCaseWidget.of(showcaseContext).next();
                                  stopTimer();
                                },
                                child: Text('Hurry up')),
                          ],
                        ),
                        height: 300,
                        width: 300,
                        child: SizedBox(
                          height: 0,
                        ),
                      ),
                      Showcase.withWidget(
                        blurValue: 1,
                        key: _four,
                        container: Column(
                          children: [
                            Container(
                              width: 300,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: [
                                  TextSpan(
                                      text:
                                          'When you finish your training session, you will earn',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: ' WomboCombo',
                                      style: TextStyle(
                                          color: Colors.amber,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          ' points based on the difficulty and training duration!',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold))
                                ]),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  ShowCaseWidget.of(context).next();
                                  startTimer();
                                },
                                child: Text('Let me train already!')),
                          ],
                        ),
                        height: 20,
                        width: 300,
                        child: SizedBox(
                          height: 0,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1),
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
                          resetTimer,
                          'countdownTimer',
                          _one,
                          context),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      );
}
