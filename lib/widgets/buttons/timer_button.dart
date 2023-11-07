import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onClicked;
  final String previousScreen;

  const ButtonWidget({
    required this.previousScreen,
    Key? key,
    required this.text,
    this.color = Colors.white,
    this.backgroundColor = Colors.black,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: backgroundColor,
          padding: previousScreen != 'fromCombosScreen'
              ? EdgeInsets.symmetric(horizontal: 32, vertical: 16)
              : EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
        child: Text(
          text,
          style: previousScreen != 'fromCombosScreen'
              ? TextStyle(fontSize: 20, color: color)
              : TextStyle(fontSize: 18, color: color),
        ),
        onPressed: onClicked,
      );
}
