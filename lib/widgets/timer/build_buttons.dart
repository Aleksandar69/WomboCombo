  import 'package:flutter/material.dart';
import '../../widgets/buttons/timer_button.dart';


Widget buildButtons(timer, secs, maxSeconds, timerAttacks, stopTimer, startTimer,previousScreen, startSpeakTimer, isRunning, resetTimer) {
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
                        timerAttacks?.cancel();
                        stopTimer(reset: false);
                      } else {
                        startTimer(reset: false);
                        if (previousScreen == 'fromQuickCombos') {
                          startSpeakTimer();
                        }
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
                        timerAttacks?.cancel();
                      } else {
                        startTimer();
                        startSpeakTimer();
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
      ],
    );
  }