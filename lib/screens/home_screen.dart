import 'package:flutter/material.dart';
import 'combos/training_levels.dart';
import 'package:wombocombo/screens/think_on_your_feet/choose_martial_art_screen.dart';
import 'package:wombocombo/screens/combos/combos_screen.dart';
import 'package:wombocombo/screens/make_your_combo/make_your_combo_screen.dart';
import 'package:wombocombo/screens/think_on_your_feet/quick_combos_screen.dart';
import 'package:wombocombo/screens/countdown_timer/set_timer_screen.dart';
import 'package:wombocombo/screens/countdown_timer/timer_new.dart';
import 'package:wombocombo/screens/think_on_your_feet/training_difficulty.dart';

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
      appBar: AppBar(
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
                    Navigator.of(context).pushNamed(ChooseMartialArt.routeName),
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
                onTap: () {},
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
                    Navigator.of(context).pushNamed(TrainingLevel.routeName),
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
                onTap: () => Navigator.of(context).pushNamed(
                    SetTimeScreen.routeName,
                    arguments: 'fromHomeScreen'),
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
