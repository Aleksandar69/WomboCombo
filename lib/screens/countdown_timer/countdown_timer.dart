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
import 'package:showcaseview/showcaseview.dart';
import 'package:just_audio/just_audio.dart' as A;

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

  static var maxSeconds = 180;
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
  var isLoading = true;

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

  final playerBeep2 = A.AudioPlayer();
  final playerRing2 = A.AudioPlayer();
  final playerTenSecs2 = A.AudioPlayer();

  var user;
  var currentPoints;

  void playBell() async {
    //return await playerRing.play(AssetSource('sounds/bell.mp3'), volume: 0.15);
    playerRing2.seek(Duration.zero);
    return await playerRing2.play();
  }

  void playBeep() async {
    // return await playerBeep.play(AssetSource('sounds/beep-0.mp3'),
    //     volume: 0.15);
    playerBeep2.seek(Duration.zero);
    return await playerBeep2.play();
  }

  void playTenSecsSound() async {
    // return await playerTenSecs.play(AssetSource('sounds/10secsremaining.mp3'),
    //     volume: 1);

    playerTenSecs2.seek(Duration.zero);
    return await playerTenSecs2.play();
  }

  void playerSetSource() async {
    await playerBeep.setSource(AssetSource('sounds/beep-0.mp3'));
    await playerRing.setSource(AssetSource('sounds/bell.mp3'));
    await playerTenSecs.setSource(AssetSource('sounds/10secsremaining.mp3'));

    await playerBeep2.setAsset('assets/sounds/beep-0.mp3');
    await playerRing2.setAsset('assets/sounds/bell.mp3');
    await playerTenSecs2.setAsset('assets/sounds/10secsremaining.mp3');
    playerBeep2.setVolume(0.2);
    playerRing2.setVolume(0.2);
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

  var oneStrikeCombosB;
  var twoStrikesCombosB;
  var threeStrikesCombosB;
  var fourStrikesCombosB;
  var fiveStrikesCombosB;
  var sixStrikesCombosB;
  var oneStrikeComboKb;
  var twoStrikeCombosKb;
  var threeStrikeCombosKb;
  var fourStrikeCombosKb;
  var fiveStrikeCombosKb;
  var sixStrikeCombosKb;
  var fourStrikesCombosKbWords;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      Wakelock.enable();
    });
    final args = ModalRoute.of(context)!.settings.arguments as List;
    playerSetSource();

    final mnts = args[0];
    final scnds = args[1];
    final restMins = args[2];
    final restSecs = args[3];
    final rnds = args[4] + 1;
    // final mnts = 0;
    // final scnds = 10;
    // final restMins = 0;
    // final restSecs = 10;
    // final rnds = 2;
    previousScreen = args[5] as String;
    trainingLevel = args[6] as String;
    customCombos = args[7] as List;
    if (args[8] != null) {
      selectedMartialArt = args[8] as String;
    }
    var showShowcase = args[9];
    oneStrikeCombosB = (args[10]['combos'] as String).split("| ");
    twoStrikesCombosB = (args[11]['combos'] as String).split("| ");
    threeStrikesCombosB = (args[12]['combos'] as String).split("| ");
    fourStrikesCombosB = (args[13]['combos'] as String).split("| ");
    fiveStrikesCombosB = (args[14]['combos'] as String).split("| ");
    sixStrikesCombosB = (args[15]['combos'] as String).split("| ");
    oneStrikeComboKb = (args[16]['combos'] as String).split("| ");
    twoStrikeCombosKb = (args[17]['combos'] as String).split("| ");
    threeStrikeCombosKb = (args[18]['combos'] as String).split("| ");
    fourStrikeCombosKb = (args[19]['combos'] as String).split("| ");
    fiveStrikeCombosKb = (args[20]['combos'] as String).split("| ");
    sixStrikeCombosKb = (args[21]['combos'] as String).split("| ");
    fourStrikesCombosKbWords = (args[22]['combos'] as String).split("| ");

    if (showShowcase) {
      startShowCase();
    }

    if (previousScreen == 'fromMakeYourComboScreen') {
      currentAttacks = List.from(customCombos);
      var test = 'asd';
    }
    if (previousScreen == 'fromQuickCombos' && selectedMartialArt == 'boxing') {
      currentAttacks = oneStrikeCombosB;
    } else if (previousScreen == 'fromQuickCombos' &&
        selectedMartialArt == 'kickboxing') {
      currentAttacks = oneStrikeComboKb;
    }

    restTimeMax = restSecs + (restMins * 60);
    final totalDuration = scnds + (mnts * 60);
    maxRounds = rnds;
    maxSeconds = totalDuration;
    secs = maxSeconds;
    rounds = maxRounds;
    if (!showShowcase) {
      startTimer();
    }
    Future.delayed(Duration(seconds: 1));
    isLoading = false;
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
    await flutterTts.setPitch(1.5);
    await flutterTts.setVolume(0.5);

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

      ;
      ;
      secs = maxSeconds;
    });
    stopTimer();
    timerAttacks?.cancel();
    _stop();
  }

  void resetAndStartTimer() {
    setState(() {
      currentTerm = 'REST';
      currentTermChanged = true;
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

  bool currentTermChanged = false;
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
        if (currentTermChanged) {
          currentTerm = 'READY';
        }
        currentTermChanged = false;
        if (selectedMartialArt == "boxing") {
          if (futureTimerHasEnded == true &&
              (previousScreen == 'fromQuickCombos')) {
            if (trainingLevel == 'Beginner') {
              if (secs <= 60 && secs > 8) {
                currentAttacks = twoStrikesCombosB;
                startSpeakTimer(5000);
              } else if (secs <= 90 && secs > 8) {
                currentAttacks = twoStrikesCombosB;
                startSpeakTimer(5200);
              } else if (secs < 130 && secs > 8) {
                currentAttacks = oneStrikeCombosB;
                startSpeakTimer(3450);
              } else if (secs < maxSeconds && secs > 8) {
                currentAttacks = oneStrikeCombosB;
                startSpeakTimer(3700);
              }
            } else if (trainingLevel == 'Intermediate') {
              if (currentRound == 1) {
                if (secs <= 40 && secs > 8) {
                  currentAttacks = threeStrikesCombosB;
                  startSpeakTimer(5200);
                } else if (secs <= 80 && secs > 8) {
                  currentAttacks = threeStrikesCombosB;
                  startSpeakTimer(5400);
                } else if (secs < 130 && secs > 8) {
                  startSpeakTimer(4800);
                  currentAttacks = twoStrikesCombosB;
                } else if (secs < maxSeconds && secs > 8) {
                  startSpeakTimer(3550);
                  currentAttacks = oneStrikeCombosB;
                }
              } else {
                if (secs <= 60 && secs > 8) {
                  currentAttacks = threeStrikesCombosB;
                  startSpeakTimer(5200);
                } else if (secs <= 110 && secs > 8) {
                  currentAttacks = threeStrikesCombosB;
                  startSpeakTimer(5400);
                } else if (secs < 155 && secs > 8) {
                  startSpeakTimer(4800);
                  currentAttacks = twoStrikesCombosB;
                } else if (secs < maxSeconds && secs > 8) {
                  startSpeakTimer(3550);
                  currentAttacks = oneStrikeCombosB;
                }
              }
            } else if (trainingLevel == 'Advanced') {
              if (secs <= 40 && secs > 8) {
                currentAttacks = fourStrikesCombosB;
                startSpeakTimer(5400);
              } else if (secs <= 85 && secs > 8) {
                currentAttacks = fourStrikesCombosB;
                startSpeakTimer(5650);
              } else if (secs <= 130 && secs > 8) {
                currentAttacks = threeStrikesCombosB;
                startSpeakTimer(5100);
              } else if (secs <= 157 && secs > 8) {
                currentAttacks = twoStrikesCombosB;
                startSpeakTimer(4500);
              } else if (secs < maxSeconds && secs > 8) {
                currentAttacks = oneStrikeCombosB;
                startSpeakTimer(3450);
              }
            } else if (trainingLevel == 'Expert') {
              if (secs <= 45 && secs > 8) {
                setState(() {
                  currentAttacks = fiveStrikesCombosB;
                });
                startSpeakTimer(6700);
              } else if (secs <= 65 && secs > 8) {
                setState(() {
                  currentAttacks = fiveStrikesCombosB;
                });
                startSpeakTimer(7000);
              } else if (secs <= 90 && secs > 8) {
                currentAttacks = fourStrikesCombosB;
                startSpeakTimer(5300);
              } else if (secs <= 105 && secs > 8) {
                currentAttacks = fourStrikesCombosB;
                startSpeakTimer(5550);
              } else if (secs <= 130 && secs > 8) {
                currentAttacks = threeStrikesCombosB;
                startSpeakTimer(5100);
              } else if (secs <= 157 && secs > 8) {
                currentAttacks = twoStrikesCombosB;
                startSpeakTimer(4500);
              } else if (secs < maxSeconds && secs > 8) {
                currentAttacks = oneStrikeCombosB;
                startSpeakTimer(3450);
              }
            } else if (trainingLevel == 'Master') {
              if (secs <= 57 && secs > 8) {
                currentAttacks = sixStrikesCombosB;
                startSpeakTimer(8000);
              } else if (secs <= 82 && secs > 8) {
                currentAttacks = fiveStrikesCombosB;
                startSpeakTimer(6850);
              } else if (secs <= 100 && secs > 8) {
                currentAttacks = fourStrikesCombosB;
                startSpeakTimer(5450);
              } else if (secs <= 135 && secs > 8) {
                currentAttacks = threeStrikesCombosB;
                startSpeakTimer(5100);
              } else if (secs <= 165 && secs > 8) {
                currentAttacks = twoStrikesCombosB;
                startSpeakTimer(4500);
              } else if (secs < maxSeconds && secs > 8) {
                currentAttacks = oneStrikeCombosB;
                startSpeakTimer(3450);
              }
            }
          }
        } else if (selectedMartialArt == "kickboxing") {
          if (futureTimerHasEnded == true &&
              (previousScreen == 'fromQuickCombos')) {
            if (trainingLevel == 'Beginner') {
              if (secs <= 60 && secs > 8) {
                currentAttacks = twoStrikeCombosKb;
                startSpeakTimer(6200);
              } else if (secs <= 90 && secs > 8) {
                currentAttacks = twoStrikeCombosKb;
                startSpeakTimer(6400);
              } else if (secs < 130 && secs > 8) {
                currentAttacks = oneStrikeComboKb;
                startSpeakTimer(4450);
              } else if (secs < maxSeconds && secs > 8) {
                currentAttacks = oneStrikeComboKb;
                startSpeakTimer(4700);
              }
            } else if (trainingLevel == 'Intermediate') {
              if (currentRound == 1) {
                if (secs <= 40 && secs > 8) {
                  currentAttacks = threeStrikeCombosKb;
                  startSpeakTimer(6000);
                } else if (secs <= 80 && secs > 8) {
                  currentAttacks = threeStrikeCombosKb;
                  startSpeakTimer(6200);
                } else if (secs < 130 && secs > 8) {
                  startSpeakTimer(5350);
                  currentAttacks = twoStrikeCombosKb;
                } else if (secs < maxSeconds && secs > 8) {
                  startSpeakTimer(3950);
                  currentAttacks = oneStrikeComboKb;
                }
              } else {
                if (secs <= 60 && secs > 8) {
                  currentAttacks = threeStrikeCombosKb;
                  startSpeakTimer(5900);
                } else if (secs <= 110 && secs > 8) {
                  currentAttacks = threeStrikeCombosKb;
                  startSpeakTimer(6100);
                } else if (secs < 155 && secs > 8) {
                  startSpeakTimer(5250);
                  currentAttacks = twoStrikeCombosKb;
                } else if (secs < maxSeconds && secs > 8) {
                  startSpeakTimer(3850);
                  currentAttacks = oneStrikeComboKb;
                }
              }
            } else if (trainingLevel == 'Advanced') {
              if (secs <= 40 && secs > 8) {
                currentAttacks = fourStrikeCombosKb;
                startSpeakTimer(6450);
              } else if (secs <= 85 && secs > 8) {
                currentAttacks = fourStrikeCombosKb;
                startSpeakTimer(6700);
              } else if (secs <= 130 && secs > 8) {
                currentAttacks = threeStrikeCombosKb;
                startSpeakTimer(5800);
              } else if (secs <= 157 && secs > 8) {
                currentAttacks = twoStrikeCombosKb;
                startSpeakTimer(5000);
              } else if (secs < maxSeconds && secs > 8) {
                currentAttacks = oneStrikeComboKb;
                startSpeakTimer(3850);
              }
            } else if (trainingLevel == 'Expert') {
              if (secs <= 45 && secs > 8) {
                setState(() {
                  currentAttacks = fiveStrikeCombosKb;
                });
                startSpeakTimer(7500);
              } else if (secs <= 65 && secs > 8) {
                setState(() {
                  currentAttacks = fiveStrikeCombosKb;
                });
                startSpeakTimer(7800);
              } else if (secs <= 90 && secs > 8) {
                currentAttacks = fourStrikeCombosKb;
                startSpeakTimer(6350);
              } else if (secs <= 105 && secs > 8) {
                currentAttacks = fourStrikeCombosKb;
                startSpeakTimer(6450);
              } else if (secs <= 130 && secs > 8) {
                currentAttacks = threeStrikeCombosKb;
                startSpeakTimer(5700);
              } else if (secs <= 157 && secs > 8) {
                currentAttacks = twoStrikeCombosKb;
                startSpeakTimer(4900);
              } else if (secs < maxSeconds && secs > 8) {
                currentAttacks = oneStrikeComboKb;
                startSpeakTimer(3800);
              }
            } else if (trainingLevel == 'Master') {
              if (secs <= 57 && secs > 8) {
                currentAttacks = sixStrikeCombosKb;
                startSpeakTimer(7800);
              } else if (secs <= 82 && secs > 8) {
                currentAttacks = fiveStrikeCombosKb;
                startSpeakTimer(7300);
              } else if (secs <= 100 && secs > 8) {
                currentAttacks = fourStrikeCombosKb;
                startSpeakTimer(6000);
              } else if (secs <= 135 && secs > 8) {
                currentAttacks = threeStrikeCombosKb;
                startSpeakTimer(5400);
              } else if (secs <= 165 && secs > 8) {
                currentAttacks = twoStrikeCombosKb;
                startSpeakTimer(4600);
              } else if (secs < maxSeconds && secs > 8) {
                currentAttacks = oneStrikeComboKb;
                startSpeakTimer(3450);
              }
            }
          }
        }
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
          startSpeakTimer(9000);
          print('in the conditional custom');
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
            if (trainingLevel == 'Beginner') {
              totalPts = maxRounds;
            } else if (trainingLevel == 'Intermediate') {
              totalPts = maxRounds * 2;
            } else if (trainingLevel == 'Advanced') {
              totalPts = maxRounds * 3;
            } else if (trainingLevel == 'Expert') {
              totalPts = maxRounds * 5;
            } else if (trainingLevel == 'Master') {
              totalPts = maxRounds * 6;
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
    timerAttacks?.cancel();
    await flutterTts.stop();
  }

  Timer? timerAttacks;

  void startSpeakTimer(duration) async {
    futureTimerHasEnded = false;
    List<String> currentTermSplit;
    if (currentTerm != 'READY') {
      currentTermSplit = currentTerm.split(',');
    } else {
      currentTermSplit = ['1', '2', '3', '4'];
    }
    var comboLength = currentTermSplit.length;
    var isKb = currentTerm.contains('Kick');
    var milliseconds = 5000;
    if (isKb) {
      switch (comboLength) {
        case 1:
          milliseconds = 3800;
          break;
        case 2:
          milliseconds = 4900;
          break;
        case 3:
          milliseconds = 5700;

          break;
        case 4:
          milliseconds = 6450;

          break;
        case 5:
          milliseconds = 4900;

          break;
        case 6:
          milliseconds = 7800;

          break;
        case 7:
          milliseconds = 8300;
          break;
        default:
          milliseconds = 6000;
      }
    } else {
      switch (comboLength) {
        case 1:
          milliseconds = 3500;
          break;
        case 2:
          milliseconds = 4600;
          break;
        case 3:
          milliseconds = 5250;

          break;
        case 4:
          milliseconds = 6000;

          break;
        case 5:
          milliseconds = 4600;

          break;
        case 6:
          milliseconds = 7500;

          break;
        case 7:
          milliseconds = 8000;
          break;
        default:
          milliseconds = 6000;
      }
    }
    if (previousScreen == 'fromMakeYourComboScreen') {
      timerAttacks =
          Timer.periodic(Duration(milliseconds: milliseconds), (_) async {
        var rng = Random();
        await flutterTts.setSpeechRate(0.5);
        var currentTerms =
            currentAttacks[rng.nextInt(currentAttacks.length)].toString();
        setState(
          () {
            currentTerm = currentTerms;
          },
        );
        _speak();
        futureTimerHasEnded = true;
        timerAttacks?.cancel();
      });
    } else if (trainingLevel == 'Beginner' &&
        previousScreen == 'fromQuickCombos') {
      timerAttacks =
          Timer.periodic(Duration(milliseconds: duration), (_) async {
        // selectedMartialArt == "boxing"
        //     ? await flutterTts.setSpeechRate(0.4)
        //     : await flutterTts.setSpeechRate(0.4);

        var rng = Random();
        var currentTerms =
            currentAttacks[rng.nextInt(currentAttacks.length)].toString();
        setState(
          () {
            currentTerm = currentTerms;
          },
        );
        _speak();
        futureTimerHasEnded = true;
        timerAttacks?.cancel();
      });
    } else if (trainingLevel == 'Easy' && previousScreen == 'fromQuickCombos') {
      timerAttacks =
          Timer.periodic(Duration(milliseconds: duration), (_) async {
        // selectedMartialArt == "boxing"
        //     ? await flutterTts.setSpeechRate(0.6)
        //     : await flutterTts.setSpeechRate(0.6);

        var rng = Random();
        var currentTerms =
            currentAttacks[rng.nextInt(currentAttacks.length)].toString();
        setState(
          () {
            currentTerm = currentTerms;
          },
        );
        _speak();
        futureTimerHasEnded = true;
        timerAttacks?.cancel();
      });
    } else if (trainingLevel == 'Intermediate' &&
        previousScreen == 'fromQuickCombos') {
      timerAttacks =
          Timer.periodic(Duration(milliseconds: duration), (_) async {
        var rng = Random();
        var currentTerms =
            currentAttacks[rng.nextInt(currentAttacks.length)].toString();
        setState(
          () {
            currentTerm = currentTerms;
          },
        );
        // selectedMartialArt == "boxing"
        //     ? await flutterTts.setSpeechRate(0.5)
        //     : await flutterTts.setSpeechRate(0.5);

        _speak();
        futureTimerHasEnded = true;
        timerAttacks?.cancel();
      });
    } else if (trainingLevel == 'Advanced' &&
        previousScreen == 'fromQuickCombos') {
      timerAttacks =
          Timer.periodic(Duration(milliseconds: duration), (_) async {
        var rng = Random();
        var currentTerms =
            currentAttacks[rng.nextInt(currentAttacks.length)].toString();
        setState(
          () {
            currentTerm = currentTerms;
          },
        );
        // selectedMartialArt == "boxing"
        //     ? await flutterTts.setSpeechRate(0.45)
        //     : await flutterTts.setSpeechRate(0.35);
        _speak();

        futureTimerHasEnded = true;
        timerAttacks?.cancel();
      });
    } else if (trainingLevel == 'Expert' &&
        previousScreen == 'fromQuickCombos') {
      timerAttacks =
          Timer.periodic(Duration(milliseconds: duration), (_) async {
        var rng = Random();
        var currentTerms =
            currentAttacks[rng.nextInt(currentAttacks.length)].toString();
        setState(
          () {
            currentTerm = currentTerms;
          },
        );
        // selectedMartialArt == "boxing"
        //     ? await flutterTts.setSpeechRate(0.45)
        //     : await flutterTts.setSpeechRate(0.35);
        _speak();
        futureTimerHasEnded = true;
        timerAttacks?.cancel();
      });
    } else if (trainingLevel == 'Master' &&
        previousScreen == 'fromQuickCombos') {
      timerAttacks =
          Timer.periodic(Duration(milliseconds: duration), (_) async {
        var rng = Random();
        var currentTerms =
            currentAttacks[rng.nextInt(currentAttacks.length)].toString();
        setState(
          () {
            currentTerm = currentTerms;
          },
        );
        // selectedMartialArt == "boxing"
        //     ? await flutterTts.setSpeechRate(0.45)
        //     : await flutterTts.setSpeechRate(0.35);
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
                                'Listen to the combinations and repeat them in real time by shadoboxing or by using the boxing bag',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 17),
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
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 17)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  ShowCaseWidget.of(context).next();
                                  stopTimer();
                                },
                                child: Text('Sounds good')),
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
                          rounds,
                          context),
                      Showcase.withWidget(
                        blurValue: 1,
                        key: _one,
                        container: Column(
                          children: [
                            Container(
                              width: 300,
                              child: Text("Let's get that combo speed up!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 17)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  ShowCaseWidget.of(showcaseContext).next();
                                  stopTimer();
                                },
                                child: Text('Yes!')),
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
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 17)),
                                  TextSpan(
                                      text: ' WomboCombo',
                                      style: TextStyle(
                                          color: Colors.amber,
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          ' points based on the difficulty and training duration!',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 17))
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
                                  userProvider.updateUserInfo(currentUserId,
                                      {'firstTimeThinkQuick': false});
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
