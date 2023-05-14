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
  late String currentLevel;
  late String currentVideo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final countdownTimerStuff =
        ModalRoute.of(context)!.settings.arguments as List;

    currentLevel = countdownTimerStuff[0] as String;
    currentVideo = countdownTimerStuff[1] as String;
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
          title: Text(currentLevel),
          actions: <Widget>[],
        ),
        body: Column(
          children: [
            Expanded(child: _FighterVideoRemote()),
            Container(height: 100, width: 100, child: Text('asd')),
          ],
        ));
  }
}

class _FighterVideoLocal extends StatefulWidget {
  @override
  _FighterVideoLocalState createState() => _FighterVideoLocalState();

  String videolocation;
  _FighterVideoLocal(this.videolocation);
}

class _FighterVideoLocalState extends State<_FighterVideoLocal> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videolocation);

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

class _FighterVideoRemote extends StatefulWidget {
  @override
  _FighterVideoRemoteState createState() => _FighterVideoRemoteState();
}

class _FighterVideoRemoteState extends State<_FighterVideoRemote> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://firebasestorage.googleapis.com/v0/b/wombocomboservice.appspot.com/o/1-2-3b-3.mp4?alt=media&token=edccbe5a-d29d-45b9-98e0-db9070b5850f',
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.play();
    _controller.initialize();
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(_controller),
                ],
              ),
            ),
          ),
        ],
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
