import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import 'package:wombocombo/helpers/snackbar_helper.dart';
import 'package:wombocombo/providers/auth_provider.dart';
import 'package:wombocombo/providers/dark_mode_notifier.dart';
import 'package:wombocombo/providers/user_provider.dart';
import 'package:wombocombo/widgets/timer/build_buttons.dart';
import 'package:wombocombo/widgets/timer/build_timer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as r;
import 'dart:ui' as ui;
import 'package:after_layout/after_layout.dart';
import '../../widgets/buttons/timer_button.dart';
import 'package:showcaseview/showcaseview.dart';

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
  var isLoading = true;
  var currentUserId;
  var currentUserMaxLvl;
  var currentMartialArt;

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
    currentMartialArt = countdownTimerStuff[6] as String;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      key: const ValueKey<String>('home_page'),
      appBar: orientation
          ? AppBar(
              title: Text(' Level ${currentLevel.toString()}'),
            )
          : null,
      body: ShowCaseWidget(
        blurValue: 1,
        disableBarrierInteraction: true,
        builder: Builder(
          builder: (context) => Column(
            children: [
              Expanded(
                child: _FighterVideoRemote(
                    videoUrl,
                    combo,
                    currentLevel,
                    videoId,
                    currentUserId,
                    currentUserMaxLvl,
                    currentMartialArt),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

OverlayEntry _getEntry(context) {
  late OverlayEntry entry;
  String previousScreen = 'fromCombosScreen';
  var started = false;
  var maxSeconds = 180;
  late int secs = maxSeconds;
  int initialCountdownMax = 3;
  late int initialCountdown = initialCountdownMax;
  String currentTerm = 'none';
  var darkMode = true;
  var currentStage = 1;

  entry = OverlayEntry(
    opaque: false,
    maintainState: true,
    builder: (_) => BackdropFilter(
      filter: ui.ImageFilter.blur(
        sigmaX: 4,
        sigmaY: 4,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (currentStage == 1)
              Container(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio:
                      _FighterVideoRemoteState._controller.value.aspectRatio,
                  child: VideoPlayer(_FighterVideoRemoteState._controller),
                ),
              ),
            if (currentStage == 1)
              Text(
                _FighterVideoRemoteState.wordsFromNumbsString,
                textAlign: TextAlign.center,
              ),
            SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.40,
              height: MediaQuery.of(context).size.width * 0.40,
              child: Stack(fit: StackFit.expand, children: [
                CircularProgressIndicator(
                  color: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  value: initialCountdown /
                      initialCountdownMax, // 1 - seconds / maxSeconds
                  strokeWidth: 12,
                ),
                Center(),
              ]),
            ),
            Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: MediaQuery.of(context).size.width * 0.18,
                      child: RawMaterialButton(
                        onPressed: () {},
                        elevation: 2.0,
                        shape: CircleBorder(eccentricity: 0.4),
                        fillColor: Colors.transparent,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: ButtonWidget(
                    previousScreen: "fromCombosScreen",
                    text: 'Reset',
                    backgroundColor: Colors.transparent,
                    color: Colors.transparent,
                    onClicked: () {},
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    ),
  );
  return entry;
}

class _FighterVideoRemote extends StatefulWidget {
  String videoUrl;
  String combo;
  int level;
  String videoId;
  String userId;
  int currentUserMaxLvl;
  String currentMartialArt;
  _FighterVideoRemote(
    this.videoUrl,
    this.combo,
    this.level,
    this.videoId,
    this.userId,
    this.currentUserMaxLvl,
    this.currentMartialArt,
  );
  @override
  _FighterVideoRemoteState createState() => _FighterVideoRemoteState();
}

class _FighterVideoRemoteState extends State<_FighterVideoRemote>
    with AfterLayoutMixin<_FighterVideoRemote> {
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();
  final GlobalKey _five = GlobalKey();

  static late VideoPlayerController _controller;
  late UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);
  var isLoading = true;
  var isLevelCompleted = false;
  _loadAndPlay() async {
    playerSetSource();
    _controller = VideoPlayerController.network(
      widget.videoUrl,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _controller.addListener(() {
      setState(() {});
    });
    _controller.initialize();
    _controller.setLooping(true);

    await Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      }); // Prints after 1 second.
    });

    _controller.play();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    //await Future.delayed(Duration(milliseconds: 1000));
    //Overlay.of(context).insert(_getEntry(context));
  }
  var user;
  @override
  void initState() {
    super.initState();

    getUser().then((_) {
      Future.delayed(const Duration(seconds: 1), () {
        if (user["firstTimeCombosScreen"]) {
          ShowCaseWidget.of(context)
              .startShowCase([_one, _two, _three, _four, _five]);
        }
      });
    });
    _loadAndPlay();
  }

  Future<void> getUser() async {
    user = await userProvider.getUser(widget.userId);
  }

  String previousScreen = 'fromCombosScreen';
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
    await playerRing.setSourceAsset('sounds/bell.mp3');
    await playerTenSecs.setSource(AssetSource('sounds/10secsremaining.mp3'));
  }

  playBell() async {
    return await playerRing.play(AssetSource('sounds/bell.mp3'), volume: 1);
  }

  playBeep() async {
    return await playerBeep.play(AssetSource('sounds/beep-0.mp3'), volume: 1);
  }

  playTenSecsSound() async {
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

  var isDelayed = false;
  startTimer({bool reset = false}) async {
    setState(() {
      Wakelock.enable();
    });
    setState(() {
      isRunning = true;
    });
    if (reset) {
      resetTimer();
    }
    timer = Timer.periodic(Duration(seconds: 1), (_) async {
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
      } else if (secs > 1 && started) {
        if (secs == 10) {
          playTenSecsSound();
        } else if (secs <= 4 && secs > 1 && secs != 0) {
          playBeep();
        }
        setState(() => secs = secs - 1);
      } else if (secs == 1) {
        playBell();
        secs = secs - 1;
      } else if (secs == 0 && isDelayed == false) {
        isDelayed = true;
      } else {
        isDelayed = false;
        // playBell();
        if (widget.level == widget.currentUserMaxLvl) {
          adjustPlayerLevel();
          isLevelCompleted = true;
        }
        setState(() => started = false);
        stopTimer(reset: false);
      }
    });
  }

  adjustPlayerLevel() async {
    if (widget.level == widget.currentUserMaxLvl) {
      widget.currentMartialArt == 'boxing'
          ? await userProvider.updateUserInfo(
              widget.userId, {'currentMaxLevelB': widget.level + 1})
          : await userProvider.updateUserInfo(
              widget.userId, {'currentMaxLevelKb': widget.level + 1});

      await SnackbarHelper.showSnackbarSuccess(
        context,
        'Level ${widget.level + 1} unlocked',
        'Good Job!',
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  var comboMapping = {
    '1': 'Jab',
    'b1': 'Jab Body',
    'j1': 'Leaping Jab',
    '1j': 'Leaping Jab',
    '2': 'Cross',
    'b2': 'Cross Body',
    '2b': 'Cross Body',
    '3': 'Left Hook',
    'b3': 'Left Hook Body',
    '3b': 'Left Hook Body',
    'j3': 'Leaping Left Hook',
    '3j': 'Leaping Left Hook',
    '4': 'Right Hook',
    'b4': 'Right Hook Body',
    '4b': 'Right Hook Body',
    '5': 'Left Uppercut',
    '5b': 'Left Uppercut Body',
    'b5': 'Left Uppercut Body',
    '6': 'Right Uppercut',
    '6b': 'Right Uppercut Body',
    'b6': 'Right Uppercut Body',
    'flk': 'Front Low Kick',
    'fmk': 'Front Middle Kick',
    'fhk': 'Front High Kick',
    'rlk': 'Rear Low Kick',
    'rmk': 'Rear Middle Kick',
    'rhk': 'Rear High Kick',
    'fpk': 'Front Push Kick',
    'rpk': 'Rear Push Kick',
    'tr': 'Turn Right',
    'tl': 'Turn Left',
    'sfr': 'Step Forward Right',
    'sfl': 'Step Forward Left',
    'sr': 'Step Right',
    'sl': 'Step Left',
    'p': 'Pause',
    'sb': 'Step Back',
    'el': 'Evade Left',
    'er': 'Evade Right',
  };
  static var wordsFromNumbsString;
  static var darkMode;

  @override
  Widget build(BuildContext context) {
    final orientation =
        MediaQuery.of(context).orientation == Orientation.portrait;
    var numbersSplit = widget.combo.split('-');
    List wordsFromNums = [];
    for (var i = 0; i < numbersSplit.length; i++) {
      wordsFromNums.add(comboMapping[numbersSplit[i]]);
    }
    wordsFromNumbsString = wordsFromNums.join('->');
    return SingleChildScrollView(
      child: WillPopScope(
        onWillPop: () async {
          stopTimer();
          if (widget.level == widget.currentUserMaxLvl && isLevelCompleted) {
            Navigator.pop(context, widget.level + 1);
          } else {
            Navigator.pop(context);
          }

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
            : r.Consumer(builder: (context, ref, child) {
                darkMode = ref.watch(darkModeProvider);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Showcase.withWidget(
                      container: Column(
                        children: [
                          Text('Watch Greg do the combo',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 15)),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                ShowCaseWidget.of(context).next();
                              },
                              child: Text('Alright')),
                        ],
                      ),
                      height: 150,
                      width: 150,
                      key: _two,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        height: orientation
                            ? null
                            : MediaQuery.of(context).size.height * 0.9,
                        width: orientation
                            ? null
                            : MediaQuery.of(context).size.width * 0.70,
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    ),
                    Showcase.withWidget(
                      container: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Are you ready to do some punching?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 15)),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                ShowCaseWidget.of(context).next();
                              },
                              child: Text('F*CK YEAH!')),
                        ],
                      ),
                      height: 190,
                      width: 192,
                      key: _one,
                      child: SizedBox(
                        height: 0,
                        width: 0,
                      ),
                    ),
                    Showcase.withWidget(
                      container: Column(
                        children: [
                          SizedBox(height: 10),
                          Container(
                            width: 200,
                            child: Text(
                              'Read the combo flow and try to memorize it',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 15),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                ShowCaseWidget.of(context).next();
                              },
                              child: Text('Okay',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 15))),
                        ],
                      ),
                      height: 130,
                      width: 150,
                      key: _three,
                      child: Text(
                        wordsFromNumbsString,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // ElevatedButton(
                    //     onPressed: () {
                    //       ShowCaseWidget.of(context).startShowCase(
                    //           [_one, _two, _three, _four, _five]);
                    //     },
                    //     child: Text('asd')),
                    SizedBox(height: 20),
                    darkMode
                        ? Showcase.withWidget(
                            targetBorderRadius: BorderRadius.circular(100),
                            targetPadding: EdgeInsets.all(10),
                            key: _five,
                            container: Column(
                              children: [
                                Container(
                                  width: 300,
                                  child: Text(
                                      'Repeat the combo for 3 minutes to unlock the next level',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 15)),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      ShowCaseWidget.of(context).next();
                                      await userProvider.updateUserInfo(
                                          widget.userId,
                                          {'firstTimeCombosScreen': false});
                                    },
                                    child: Text('Got it!')),
                              ],
                            ),
                            height: 200,
                            width: 300,
                            child: buildTimer(
                                previousScreen,
                                started,
                                secs,
                                maxSeconds,
                                initialCountdown,
                                currentTerm,
                                initialCountdownMax,
                                Color(0xff90E0EF),
                                Color.fromARGB(255, 41, 62, 218),
                                Color.fromARGB(255, 180, 207, 242),
                                null,
                                context),
                          )
                        : Showcase.withWidget(
                            targetBorderRadius: BorderRadius.circular(100),
                            targetPadding: EdgeInsets.all(10),
                            key: _five,
                            container: Column(
                              children: [
                                Container(
                                  width: 300,
                                  child: Text(
                                      'Repeat the combo for 3 minutes to unlock the next level. Shadowboxing or by using the boxing bag.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 15)),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      ShowCaseWidget.of(context).next();
                                      await userProvider.updateUserInfo(
                                          widget.userId,
                                          {'firstTimeCombosScreen': false});
                                    },
                                    child: Text('Got it!')),
                              ],
                            ),
                            height: 200,
                            width: 300,
                            child: buildTimer(
                                previousScreen,
                                started,
                                secs,
                                maxSeconds,
                                initialCountdown,
                                currentTerm,
                                initialCountdownMax,
                                Color(0xff90E0EF),
                                Color.fromARGB(255, 223, 235, 237),
                                Color(0xff023E8A),
                                null,
                                context),
                          ),
                    buildButtons(
                        timer,
                        secs,
                        maxSeconds,
                        null,
                        stopTimer,
                        startTimer,
                        previousScreen,
                        null,
                        isRunning,
                        resetTimer,
                        'combos',
                        _four,
                        context),
                    SizedBox(height: 5),
                  ],
                );
              }),
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
