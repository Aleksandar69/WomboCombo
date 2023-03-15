import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wombocombo/providers/auth_provider.dart';
import 'package:wombocombo/providers/boxing_attacks_list_provider.dart';
import 'package:wombocombo/providers/boxing_attacks_provider.dart';
import 'package:wombocombo/providers/custom_combo_provider.dart';
import 'package:wombocombo/providers/user_provider.dart';
import 'package:wombocombo/screens/auth/auth_screen.dart';
import 'package:wombocombo/screens/auth/splash_screen.dart';
import 'package:wombocombo/screens/combos/training_levels.dart';
import 'package:wombocombo/screens/make_your_combo/saved_combos_screen.dart';
import 'package:wombocombo/screens/profile/edit_profile_screen.dart';
import 'package:wombocombo/screens/think_on_your_feet/choose_martial_art_screen.dart';
import 'package:wombocombo/screens/combos/combos_screen.dart';
import 'package:wombocombo/screens/home_screen.dart';
import 'package:wombocombo/screens/make_your_combo/make_your_combo_screen.dart';
import 'package:wombocombo/screens/think_on_your_feet/boxing_mapping.dart';
import 'package:wombocombo/screens/think_on_your_feet/kickboxing_mapping.dart';
import 'package:wombocombo/screens/think_on_your_feet/muay_thai_mapping.dart';
import 'package:wombocombo/screens/think_on_your_feet/quick_combos_screen.dart';
import 'package:wombocombo/screens/countdown_timer/set_timer_screen.dart';
import 'package:wombocombo/screens/countdown_timer/timer_new.dart';
import 'package:wombocombo/screens/think_on_your_feet/training_difficulty.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AuthProvider(),
          ),
          ChangeNotifierProxyProvider<AuthProvider, UserProvider>(
            create: (_) => UserProvider('', '', ''),
            update: (ctx, auth, previousInfo) {
              return UserProvider(
                auth.token!,
                auth.userId!,
                auth.username!,
                auth.email!,
              );
            },
          ),
          ChangeNotifierProvider(
            create: (context) => BoxingAttacksListProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => BoxingAttacksProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => CustomComboProvider(),
          ),
        ],
        child: Consumer<AuthProvider>(
          builder: (context, authData, _) => MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: authData.isAuth
                  ? HomeScreen()
                  : FutureBuilder(
                      future: authData.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen()),
              routes: {
                QuickCombosScreen.routeName: (context) => QuickCombosScreen(),
                SetTimeScreen.routeName: (context) => SetTimeScreen(),
                CombosScreen.routeName: (context) => CombosScreen(),
                MakeYourComboScreen.routeName: (context) =>
                    MakeYourComboScreen(),
                TimerNew.routeName: (context) => TimerNew(),
                ChooseMartialArt.routeName: (context) => ChooseMartialArt(),
                BoxingMapping.routeName: (context) => BoxingMapping(),
                MuayThaiMapping.routeName: (context) => MuayThaiMapping(),
                KickBoxingMapping.routeName: (context) => KickBoxingMapping(),
                TrainingDiff.routeName: (context) => TrainingDiff(),
                TrainingLevel.routeName: (context) => TrainingLevel(),
                SavedCombos.routeName: (context) => SavedCombos(),
                HomeScreen.routeName: (context) => HomeScreen(),
                EditProfileScreen.routeName: (context) => EditProfileScreen()
              }),
        ));
  }
}
