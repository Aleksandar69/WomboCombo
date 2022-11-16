import 'package:flutter/material.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

class CombosScreen extends StatefulWidget {
  static const routeName = '/combos';
  @override
  State<CombosScreen> createState() => _CombosScreenState();
}

class _CombosScreenState extends State<CombosScreen> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: WheelChooser.integer(
            isInfinite: true,
            onValueChanged: (i) => print(i),
            maxValue: 60,
            minValue: 1,
            step: 2,
            unSelectTextStyle: TextStyle(color: Colors.grey),
            initValue: 3,
          ),
        ),
        Flexible(
          child: WheelChooser.integer(
            isInfinite: true,
            onValueChanged: (i) => print(i),
            maxValue: 60,
            minValue: 0,
            step: 2,
            unSelectTextStyle: TextStyle(color: Colors.grey),
            initValue: 0,
          ),
        ),
        Flexible(
          child: WheelChooser.integer(
            isInfinite: true,
            magnification: 1,
            perspective: 0.008,
            squeeze: 0.7,
            onValueChanged: (i) => print(i),
            maxValue: 60,
            minValue: 0,
            step: 2,
            unSelectTextStyle: TextStyle(color: Colors.grey),
            initValue: 0,
          ),
        ),
      ],
    );
  }
}
