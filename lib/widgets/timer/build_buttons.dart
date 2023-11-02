import 'package:flutter/material.dart';
import 'package:wombocombo/providers/dark_mode_notifier.dart';
import '../../widgets/buttons/timer_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as r;

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
    context) {
  final isActive = timer == null ? false : timer!.isActive;
  final isCompleted = secs == 0;

  return r.Consumer(builder: (context, ref, child) {
    var darkMode = ref.watch(darkModeProvider);

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
                    timerAttacks?.cancel();
                    stopTimer(reset: false);
                  } else if (!isActive && !isCompleted) {
                    startTimer(reset: false);
                    if (previousScreen == 'fromQuickCombos') {
                      startSpeakTimer();
                    }
                  } else if (isCompleted && !isActive) {
                    startTimer(reset: true);
                    if (previousScreen == 'fromQuickCombos') {
                      startSpeakTimer();
                    }
                  }
                },
                elevation: 2.0,
                fillColor: fromScreen == 'coundownTimer'
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
            )
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.08,
          child: ButtonWidget(
            text: 'Reset',
            color: Colors.white,
            backgroundColor: fromScreen == 'coundownTimer'
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
