import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

Widget buildTime(secs, previousScreen, started, initialCountdown, currentTerm,
    color, context) {
  if (previousScreen == 'fromHomeScreen') {
    if (secs == 0) {
      return Icon(Icons.done, color: Colors.green, size: 112);
    } else {
      return started
          ? Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 0.6,
              alignment: Alignment.center,
              child: AutoSizeText(
                '${secs}',
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                minFontSize: 100,
                maxFontSize: 150,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 0.6,
              alignment: Alignment.center,
              child: AutoSizeText(
                '${initialCountdown}',
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                minFontSize: 100,
                maxFontSize: 150,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            );
    }
  } else if (previousScreen == 'fromCombosScreen') {
    if (secs == 0) {
      return Icon(Icons.done, color: Colors.green, size: 112);
    } else {
      return started
          ? Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.3,
              alignment: Alignment.center,
              child: AutoSizeText(
                '${secs}',
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                minFontSize: 60,
                maxFontSize: 90,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.3,
              alignment: Alignment.center,
              child: AutoSizeText(
                '${initialCountdown}',
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                minFontSize: 60,
                maxFontSize: 90,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            );
    }
  } else {
    if (secs == 0) {
      return Icon(Icons.done, color: Colors.green, size: 112);
    } else {
      return Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: AutoSizeText(
              currentTerm,
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
              minFontSize: 40,
              maxFontSize: 50,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
      );
    }
  }
}
