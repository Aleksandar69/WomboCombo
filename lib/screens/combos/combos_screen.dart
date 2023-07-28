import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import 'package:wombocombo/providers/theme_provider.dart';
import 'package:wombocombo/providers/user_provider.dart';
import 'package:wombocombo/screens/combos/training_levels.dart';
import 'package:wombocombo/widgets/timer/build_buttons.dart';
import 'package:wombocombo/widgets/timer/build_timer.dart';

class CombosScreen extends StatefulWidget {
  static const routeName = '/combos';
  @override
  State<CombosScreen> createState() => _CombosScreenState();
}

class _CombosScreenState extends State<CombosScreen> {
  late int currentLevel;
  late String combo;
  late String videoUrl;
  late String videoId;
  var isLoading;
  var currentUserId;
  var currentUserMaxLvl;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final countdownTimerStuff =
        ModalRoute.of(context)!.settings.arguments as List;

    currentLevel = countdownTimerStuff[0] as int;
    combo = countdownTimerStuff[1] as String;
    videoUrl = countdownTimerStuff[2] as String;
    videoId = countdownTimerStuff[3] as String;
    currentUserId = countdownTimerStuff[4] as String;
    currentUserMaxLvl = countdownTimerStuff[5] as int;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey<String>('home_page'),
      appBar: AppBar(
        title: Text(' Level ${currentLevel.toString()}'),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacementNamed(context, TrainingLevel.routeName);
          return false;
        },
        child: Column(
          children: [
            Expanded(
              child: _FighterVideoRemote(videoUrl, combo, currentLevel, videoId,
                  currentUserId, currentUserMaxLvl),
            ),
          ],
        ),
      ),
    );
  }
}

class _FighterVideoRemote extends StatefulWidget {
  String videoUrl;
  String combo;
  int level;
  String videoId;
  String userId;
  int currentUserMaxLvl;
  _FighterVideoRemote(this.videoUrl, this.combo, this.level, this.videoId,
      this.userId, this.currentUserMaxLvl);
  @override
  _FighterVideoRemoteState createState() => _FighterVideoRemoteState();
}

class _FighterVideoRemoteState extends State<_FighterVideoRemote> {
  late VideoPlayerController _controller;
  late UserProvider userProvider = Provider.of<UserProvider>(context);
  late ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
  var isLoading = true;

  @override
  void initState() {
    super.initState();

    playerSetSource();
    Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        isLoading = false;
      });
      timer.cancel();
    });
    _controller = VideoPlayerController.network(
      widget.videoUrl,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.play();
    _controller.initialize();
  }

  String previousScreen = 'fromHomeScreen';
  var started = false;
  var maxSeconds = 180;
  late int secs = maxSeconds;
  int initialCountdownMax = 3;
  late int initialCountdown = initialCountdownMax;
  String currentTerm = 'none';

  Timer? timer;
  var isRunning = false;

  final playerBeep = AudioPlayer();
  final playerRing = AudioPlayer();
  final playerTenSecs = AudioPlayer();

  void playerSetSource() async {
    await playerBeep.setSource(AssetSource('sounds/beep-0.mp3'));
    await playerRing.setSource(AssetSource('sounds/bell.mp3'));
    await playerTenSecs.setSource(AssetSource('sounds/10secsremaining.mp3'));
  }

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

  void resetTimer() {
    setState(() {
      started = false;
      secs = maxSeconds;
      initialCountdown = initialCountdownMax;
    });
    stopTimer();
  }

  void resetAndStartTimer() {
    setState(() {
      started = false;
      secs = maxSeconds;
      initialCountdown = initialCountdownMax;
    });
    startTimer();
  }

  void stopBeeps() async {
    await playerBeep.stop();
    await playerRing.stop();
    await playerTenSecs.stop();
  }

  void stopTimer({bool reset = false, resetAndStart = false}) {
    stopBeeps();
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
      if (!started) {
        if (initialCountdown > 0) {
          playBeep();
          setState(() => initialCountdown--);
        } else {
          playBell();
          setState(() {
            started = true;
          });
        }
      } else if (secs > 0 && started) {
        if (secs == 10) {
          playTenSecsSound();
        } else if (secs <= 3 && secs > 0) {
          playBeep();
        }
        setState(() => secs = secs - 1);
      } else {
        playBell();
        setState(() => started = false);
        stopTimer(reset: false);
        if (widget.level == widget.currentUserMaxLvl) {
          userProvider.updateUserInfo(
              widget.userId, {'currentMaxLevel': widget.level + 1});
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  var comboMapping = {
    '1': 'Jab',
    'b21': 'Jab body',
    '2': 'Cross',
    'b2': 'Cross body',
    '3': 'Left hook',
    'b3': 'Left hook body',
    '3j': 'Jumping left hook',
    '4': 'Right hook',
    'b4': 'Right hook body',
    '5': 'Left uppercut',
    '6': 'Right uppercut',
  };

  @override
  Widget build(BuildContext context) {
    var numbersSplit = widget.combo.split('-');
    List wordsFromNums = [];
    for (var i = 0; i < numbersSplit.length; i++) {
      wordsFromNums.add(comboMapping[numbersSplit[i]]);
    }
    var wordsFromNumbsString;
    wordsFromNumbsString = wordsFromNums.join('->');
    return SingleChildScrollView(
      child: WillPopScope(
        onWillPop: () async {
          stopTimer();
          Navigator.pop(context);
          return false;
        },
        child: isLoading
            ? SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Please wait while the animation loads"),
                    ],
                  ),
                ),
              )
            : Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                  Text(wordsFromNumbsString),
                  SizedBox(height: 40),
                  themeProvider.darkTheme
                      ? buildTimer(
                          previousScreen,
                          started,
                          secs,
                          maxSeconds,
                          initialCountdown,
                          currentTerm,
                          initialCountdownMax,
                          Color(0xff90E0EF),
                          Color.fromARGB(255, 41, 62, 218),
                          Color.fromARGB(255, 180, 207, 242))
                      : buildTimer(
                          previousScreen,
                          started,
                          secs,
                          maxSeconds,
                          initialCountdown,
                          currentTerm,
                          initialCountdownMax,
                          Color(0xff90E0EF),
                          Color.fromARGB(255, 223, 235, 237),
                          Color(0xff023E8A)),
                  SizedBox(height: 10),
                  buildButtons(timer, secs, maxSeconds, null, stopTimer,
                      startTimer, previousScreen, null, isRunning, resetTimer),
                  SizedBox(height: 5),
                ],
              ),
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller})
      : super(key: key);

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topLeft,
          child: PopupMenuButton<Duration>(
            initialValue: controller.value.captionOffset,
            tooltip: 'Caption Offset',
            onSelected: (Duration delay) {
              controller.setCaptionOffset(delay);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<Duration>>[
                for (final Duration offsetDuration in _exampleCaptionOffsets)
                  PopupMenuItem<Duration>(
                    value: offsetDuration,
                    child: Text('${offsetDuration.inMilliseconds}ms'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}
