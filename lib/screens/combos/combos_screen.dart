import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import 'package:wombocombo/widgets/timer/build_buttons.dart';
import 'package:wombocombo/widgets/timer/build_timer.dart';

class CombosScreen extends StatefulWidget {
  static const routeName = '/combos';
  @override
  State<CombosScreen> createState() => _CombosScreenState();
}

class _CombosScreenState extends State<CombosScreen> {
  late VideoPlayerController _controller;
  late String currentLevel;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/movie_008.mp4');
    _controller.setLooping(true);
    _controller.play();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final countdownTimerStuff =
        ModalRoute.of(context)!.settings.arguments as List;

    currentLevel = countdownTimerStuff[0] as String;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey<String>('home_page'),
      appBar: AppBar(
        title: Text(currentLevel),
        actions: <Widget>[],
      ),
      body: _ButterFlyAssetVideo(),
    );
  }
}

class _ButterFlyAssetVideo extends StatefulWidget {
  @override
  _ButterFlyAssetVideoState createState() => _ButterFlyAssetVideoState();
}

class _ButterFlyAssetVideoState extends State<_ButterFlyAssetVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/movie_008.mp4');

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String previousScreen = 'fromHomeScreen';
  var started = false;
  var maxSeconds = 11;
  late int secs = maxSeconds;
  int initialCountdownMax = 3;
  late int initialCountdown = initialCountdownMax;
  String currentTerm = 'none';

  Timer? timer;
  var isRunning = false;

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
      if (!started) {
        print('secs: $secs');
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
          Text('Jab - Cross - Lef Hook'),
          SizedBox(height: 40),
          buildTimer(previousScreen, started, secs, maxSeconds,
              initialCountdown, currentTerm, initialCountdownMax),
          SizedBox(height: 10),
          buildButtons(timer, secs, maxSeconds, null, stopTimer, startTimer,
              previousScreen, null, isRunning, resetTimer),
        ],
      ),
    );
  }
}
