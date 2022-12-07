import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/round_button.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class CountdownTimerNew extends StatefulWidget {
  static const routeName = 'countdown-timer-new';
  @override
  _CountdownTimerNewState createState() => _CountdownTimerNewState();
}

class _CountdownTimerNewState extends State<CountdownTimerNew>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController initialCountdownController;
  Timer? timer;

  final playerBeep = AudioPlayer();
  final playerRing = AudioPlayer();

  bool isPlaying = false;
  bool initialCountdownStarted = false;

  void playerSetSource() async {
    await playerBeep.setSource(AssetSource('sounds/beep-0.mp3'));
    await playerRing.setSource(AssetSource('sounds/bell.mp3'));
  }

  void stopBeeps() async {
    await playerBeep.stop();
    await playerRing.stop();
  }

  void playBell() async {
    return await playerBeep.play(AssetSource('sounds/bell.mp3'), volume: 1);
  }

  void playBeep() async {
    return await playerBeep.play(AssetSource('sounds/beep-0.mp3'), volume: 1);
  }

  String get countText {
    if (initialCountdownController.isAnimating || !initialCountdownStarted) {
      Duration count = initialCountdownController.duration! *
          initialCountdownController.value;
      if (initialCountdownController.isDismissed) {
        return '${initialCountdownController.duration!.inHours}:${(initialCountdownController.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(initialCountdownController.duration!.inSeconds % 60).toString().padLeft(2, '0')}';
      } else {
        return '${count.inHours}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
      }
    } else {
      Duration count = controller.duration! * controller.value;
      if (controller.isDismissed) {
        return '${controller.duration!.inHours}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}';
      } else {
        return '${count.inHours}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
      }
    }
  }

  double progress = 1.0;
  double initCountdownProgress = 1.0;

  void notify() {
    if (countText == '0:00:00') {
      FlutterRingtonePlayer.playNotification();
    }
  }

  // void play() {
  //   if (countText == '0:00:03' ||
  //       countText == ('0:00:02') ||
  //       countText == ('0:00:01') ||
  //       countText == ('0:00:00')) {
  //     playBeep();
  //   }
  //   // if (initCountdownProgress == 3.0 ||
  //   //     initCountdownProgress == 2.0 ||
  //   //     initCountdownProgress == 1.0 ||
  //   //     initCountdownProgress == 0.0) {
  //   //   playBeep();
  //   // }
  // }

  void startCountdown() {
    initialCountdownController.reverse(
        from: initialCountdownController.value == 0
            ? 1.0
            : initialCountdownController.value);
    controller.reverse(from: controller.value == 0 ? 1.0 : controller.value);
    setState(() {
      isPlaying = true;
      initialCountdownStarted = true;
    });
  }

  void pauseCountdown() {
    controller.stop();
    initialCountdownController.stop();
    setState(() {
      isPlaying = false;
    });
  }

  void stopCountdown() {
    initialCountdownController.reset();
    controller.reset();
    setState(() {
      initialCountdownStarted = false;
      isPlaying = false;
    });
  }

  @override
  void initState() {
    super.initState();
    playerSetSource();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 60),
    );

    controller.addListener(() {
      notify();
      if (controller.isAnimating) {
        setState(() {
          progress = controller.value;
        });
      } else {
        setState(() {
          progress = 1.0;
          isPlaying = false;
        });
      }
    });

    initialCountdownController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    initialCountdownController.addListener(() {
      //  play();
      if (initialCountdownController.isAnimating) {
        setState(() {
          initCountdownProgress = initialCountdownController.value;
        });
      } else {
        setState(() {
          initCountdownProgress = 1.0;
          isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5fbff),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                initialCountdownController.isAnimating
                    ? SizedBox(
                        width: 300,
                        height: 300,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.grey.shade300,
                          value: initCountdownProgress,
                          strokeWidth: 6,
                        ),
                      )
                    : SizedBox(
                        width: 300,
                        height: 300,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.grey.shade300,
                          value: progress,
                          strokeWidth: 6,
                        ),
                      ),
                GestureDetector(
                  onTap: () {
                    if (controller.isDismissed) {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          height: 300,
                          child: CupertinoTimerPicker(
                            initialTimerDuration: controller.duration!,
                            onTimerDurationChanged: (time) {
                              setState(() {
                                controller.duration = time;
                              });
                            },
                          ),
                        ),
                      );
                    }
                  },
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) => Text(
                      countText,
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (controller.isAnimating) {
                      pauseCountdown();
                    } else {
                      startCountdown();
                    }
                  },
                  child: RoundButton(
                    icon: isPlaying == true ? Icons.pause : Icons.play_arrow,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    stopCountdown();
                  },
                  child: RoundButton(
                    icon: Icons.stop,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
