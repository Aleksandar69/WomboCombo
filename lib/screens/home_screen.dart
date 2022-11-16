import 'package:flutter/material.dart';
import 'package:wombocombo/screens/combos_screen.dart';
import 'package:wombocombo/screens/make_your_combo_screen.dart';
import 'package:wombocombo/screens/quick_combos_screen.dart';
import 'package:wombocombo/screens/coundown_timer_screen.dart';
import 'package:wombocombo/screens/set_timer_screen.dart';
import 'package:wombocombo/screens/timer_new.dart';

class HomeScreen extends StatelessWidget {
  var menuItems = [
    'Think on your feet',
    'Make your own workout',
    'Get your combos up',
    'Timer',
    'Instructions'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('text'),
      ),
      body: Container(
          height: 600,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () =>
                    Navigator.of(context).pushNamed(QuickCombosScreen.routeName),
                child: Container(
                  height: 100,
                  child: Card(
                    child: Center(
                      child: Text('Think on your feet'),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () =>
                    Navigator.of(context).pushNamed(MakeYourComboScreen.routeName),
                child: Container(
                  height: 100,
                  child: Card(
                    child: Center(
                      child: Text('Make your own workout'),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () =>
                    Navigator.of(context).pushNamed(CombosScreen.routeName),
                child: Container(
                  height: 100,
                  child: Card(
                    child: Center(
                      child: Text(
                        'Get your combos up',
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () =>
                    Navigator.of(context).pushNamed(SetTimeScreen.routeName),
                child: Container(
                  height: 100,
                  child: Card(
                    child: Center(
                      child: Text(
                        'Timer',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
