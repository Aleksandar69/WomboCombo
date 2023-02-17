import 'dart:io';
import 'package:flutter/material.dart';

class CustomCombo {
  final String comboName;
  final String attacks;

  String get getAttacks {
    return attacks;
  }

  CustomCombo(
    this.comboName,
    this.attacks,
  );
}
