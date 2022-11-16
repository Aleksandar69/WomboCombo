import 'package:flutter/material.dart';

class GradientWidget extends StatelessWidget {
  final Widget child;

  const GradientWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF000000),
              Color(0xFFD50000),
              Color(0xFFB71C1c),
              Color(0xFF000000),
              Color(0xFF000000),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: child,
      );

      
}