import 'package:flutter/material.dart';
import 'package:wombocombo/providers/dark_mode_notifier.dart';
import '../../widgets/buttons/timer_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as r;
import 'package:showcaseview/showcaseview.dart';

Widget buildButtons(
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
    fromScreen,
    globalKey,
    context) {
  final isActive = timer == null ? false : timer!.isActive;
  final isCompleted = secs == 0;

  return r.Consumer(builder: (context, ref, child) {
    var darkMode = ref.watch(darkModeProvider);

    if (previousScreen == 'fromCombosScreen')
      return Column(
        children: [
          SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Showcase.withWidget(
                targetBorderRadius: BorderRadius.circular(35),
                key: globalKey,
                height: 60,
                width: 60,
                container: Column(
                  children: [
                    Text('Click play'),
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
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.09,
                  width: MediaQuery.of(context).size.width * 0.18,
                  child: RawMaterialButton(
                    onPressed: () {
                      if (isActive) {
                        // ShowCaseWidget.of(context).startShowCase([globalKey]);
                        timerAttacks?.cancel();
                        stopTimer(reset: false);
                      } else if (!isActive && !isCompleted) {
                        //  ShowCaseWidget.of(context).startShowCase([globalKey]);
                        startTimer(reset: false);
                        if (previousScreen == 'fromQuickCombos') {
                          startSpeakTimer();
                        }
                      } else if (isCompleted && !isActive) {
                        // ShowCaseWidget.of(context).startShowCase([globalKey]);
                        startTimer(reset: true);
                        if (previousScreen == 'fromQuickCombos') {
                          startSpeakTimer();
                        }
                      }
                    },
                    elevation: 2.0,
                    fillColor: fromScreen == 'countdownTimer'
                        ? darkMode
                            ? Colors.blue.shade400
                            : Colors.blue.shade700
                        : Color.fromARGB(255, 0, 195, 130),
                    child: !isActive || isCompleted
                        ? Icon(Icons.play_arrow,
                            size: 45.0, color: Colors.white)
                        : Icon(Icons.pause, size: 45.0, color: Colors.white),
                    shape: CircleBorder(eccentricity: 0.4),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: ButtonWidget(
              previousScreen: "fromCombosScreen",
              text: 'Reset',
              color: Colors.white,
              backgroundColor: fromScreen == 'countdownTimer'
                  ? darkMode
                      ? Colors.blue.shade400
                      : Colors.blue.shade700
                  : Color.fromARGB(255, 0, 195, 130),
              onClicked: () {
                resetTimer();
              },
            ),
          ),
        ],
      );
    else
      return Column(
        children: [
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.12,
                child: RawMaterialButton(
                  onPressed: () {
                    if (isActive) {
                      //   ShowCaseWidget.of(context).startShowCase([globalKey]);
                      timerAttacks?.cancel();
                      stopTimer(reset: false);
                    } else if (!isActive && !isCompleted) {
                      // ShowCaseWidget.of(context).startShowCase([globalKey]);
                      startTimer(reset: false);
                      if (previousScreen == 'fromQuickCombos') {
                        startSpeakTimer();
                      }
                    } else if (isCompleted && !isActive) {
                      //ShowCaseWidget.of(context).startShowCase([globalKey]);
                      startTimer(reset: true);
                      if (previousScreen == 'fromQuickCombos') {
                        startSpeakTimer();
                      }
                    }
                  },
                  elevation: 2.0,
                  fillColor: fromScreen == 'countdownTimer'
                      ? darkMode
                          ? Colors.blue.shade400
                          : Colors.blue.shade700
                      : Color.fromARGB(255, 0, 195, 130),
                  child: !isActive || isCompleted
                      ? Icon(Icons.play_arrow, size: 55.0, color: Colors.white)
                      : Icon(Icons.pause, size: 55.0, color: Colors.white),
                  padding: EdgeInsets.all(15.0),
                  shape: CircleBorder(),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.08,
            child: ButtonWidget(
              previousScreen: "notFromCombosScreen",
              text: 'Reset',
              color: Colors.white,
              backgroundColor: fromScreen == 'countdownTimer'
                  ? darkMode
                      ? Colors.blue.shade400
                      : Colors.blue.shade700
                  : Color.fromARGB(255, 0, 195, 130),
              onClicked: () {
                resetTimer();
              },
            ),
          ),
        ],
      );
  });
}
