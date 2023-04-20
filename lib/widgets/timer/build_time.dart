import 'package:flutter/material.dart';

Widget buildTime(secs, previousScreen, started, initialCountdown, currentTerm) {
  final time = secs;
  if (previousScreen == 'fromHomeScreen') {
    if (time == 0) {
      return Icon(Icons.done, color: Colors.green, size: 112);
    } else {
      return started
          ? Text(
              '${secs}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 80,
              ),
            )
          : Text(
              '${initialCountdown}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 80,
              ),
            );
    }
  } else {
    if (time == 0) {
      return Icon(Icons.done, color: Colors.green, size: 112);
    } else {
      return Text(
        currentTerm,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 80,
        ),
      );
    }
  }
}
