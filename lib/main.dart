import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wombocombo/providers/boxing_attacks_provider.dart';
import 'package:wombocombo/screens/martial_art_attack_mapping/choose_martial_art_screen.dart';
import 'package:wombocombo/screens/combos/combos_screen.dart';
import 'package:wombocombo/screens/home_screen.dart';
import 'package:wombocombo/screens/make_your_combo/make_your_combo_screen.dart';
import 'package:wombocombo/screens/martial_art_attack_mapping/boxing_mapping.dart';
import 'package:wombocombo/screens/martial_art_attack_mapping/kickboxing_mapping.dart';
import 'package:wombocombo/screens/martial_art_attack_mapping/muay_thai_mapping.dart';
import 'package:wombocombo/screens/martial_art_attack_mapping/quick_combos_screen.dart';
import 'package:wombocombo/screens/countdown_timer/set_timer_screen.dart';
import 'package:wombocombo/screens/countdown_timer/timer_new.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => BoxingAttacksProvider(),
          ),
        ],
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: HomeScreen(),
            routes: {
              QuickCombosScreen.routeName: (context) => QuickCombosScreen(),
              SetTimeScreen.routeName: (context) => SetTimeScreen(),
              CombosScreen.routeName: (context) => CombosScreen(),
              MakeYourComboScreen.routeName: (context) => MakeYourComboScreen(),
              TimerNew.routeName: (context) => TimerNew(),
              ChooseMartialArt.routeName: (context) => ChooseMartialArt(),
              BoxingMapping.routeName: (context) => BoxingMapping(),
              MuayThaiMapping.routeName: (context) => MuayThaiMapping(),
              KickBoxingMapping.routeName: (context) => KickBoxingMapping(),
            }));
  }
}
