import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wombocombo/screens/combos_screen.dart';
import 'package:wombocombo/screens/coundown_timer_new.dart';
import 'package:wombocombo/screens/home_screen.dart';
import 'package:wombocombo/screens/make_your_combo_screen.dart';
import 'package:wombocombo/screens/quick_combos_screen.dart';
import 'package:wombocombo/screens/coundown_timer_screen.dart';
import 'package:wombocombo/screens/set_timer_screen.dart';
import 'package:wombocombo/screens/timer_new.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
        routes: {
          QuickCombosScreen.routeName: (context) => QuickCombosScreen(),
          SetTimeScreen.routeName: (context) => SetTimeScreen(),
          CountdownTimerScreen.routeName: (context) => CountdownTimerScreen(),
          CombosScreen.routeName: (context) => CombosScreen(),
          MakeYourComboScreen.routeName: (context) => MakeYourComboScreen(),
          TimerNew.routeName: (context) => TimerNew(),
          CountdownTimerNew.routeName: (context) => CountdownTimerNew(),
        });
  }
}