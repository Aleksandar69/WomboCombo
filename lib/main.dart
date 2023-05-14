import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wombocombo/providers/custom_combo_provider.dart';
import 'package:wombocombo/screens/chat/chat_screen.dart';
import 'package:wombocombo/screens/combos/training_levels.dart';
import 'package:wombocombo/screens/countdown_timer/countdown_timer.dart';
import 'package:wombocombo/screens/friend_screens/friend_list.dart';
import 'package:wombocombo/screens/friend_screens/friend_requests.dart';
import 'package:wombocombo/screens/leaderboard/leaderboard_screen.dart';
import 'package:wombocombo/screens/make_your_combo/saved_combos_screen.dart';
import 'package:wombocombo/screens/profile/edit_profile_screen.dart';
import 'package:wombocombo/screens/profile/profile_screen.dart';
import 'package:wombocombo/screens/profile/videos/saved_video.dart';
import 'package:wombocombo/screens/profile/videos/saved_videos.dart';
import 'package:wombocombo/screens/recording/start_recording_screen.dart';
import 'package:wombocombo/screens/think_on_your_feet/choose_martial_art_screen.dart';
import 'package:wombocombo/screens/combos/combos_screen.dart';
import 'package:wombocombo/screens/home_screen.dart';
import 'package:wombocombo/screens/make_your_combo/make_your_combo_screen.dart';
import 'package:wombocombo/screens/think_on_your_feet/boxing_mapping.dart';
import 'package:wombocombo/screens/think_on_your_feet/kickboxing_mapping.dart';
import 'package:wombocombo/screens/think_on_your_feet/muay_thai_mapping.dart';
import 'package:wombocombo/screens/think_on_your_feet/quick_combos_screen.dart';
import 'package:wombocombo/screens/countdown_timer/set_timer_screen.dart';
import 'package:wombocombo/screens/think_on_your_feet/training_difficulty.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/auth/auth_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var firebaseMessaging = FirebaseMessaging.instance;
  final fcmToken = await firebaseMessaging.getToken();
  print('token $fcmToken');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CustomComboProvider(),
        ),
      ],
      child: MaterialApp(
          title: 'Flutter Chat',
          theme: ThemeData(
            primarySwatch: Colors.pink,
            backgroundColor: Colors.pink,
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink)
                .copyWith(secondary: Colors.purple),
            buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.pink,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          home: StreamBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return HomeScreen();
              }
              return AuthScreen();
            },
            stream: FirebaseAuth.instance.authStateChanges(),
          ),
          routes: {
            QuickCombosScreen.routeName: (context) => QuickCombosScreen(),
            SetTimeScreen.routeName: (context) => SetTimeScreen(),
            CombosScreen.routeName: (context) => CombosScreen(),
            MakeYourComboScreen.routeName: (context) => MakeYourComboScreen(),
            CountdownTimer.routeName: (context) => CountdownTimer(),
            ChooseMartialArt.routeName: (context) => ChooseMartialArt(),
            BoxingMapping.routeName: (context) => BoxingMapping(),
            MuayThaiMapping.routeName: (context) => MuayThaiMapping(),
            KickBoxingMapping.routeName: (context) => KickBoxingMapping(),
            TrainingDiff.routeName: (context) => TrainingDiff(),
            TrainingLevel.routeName: (context) => TrainingLevel(),
            SavedCombos.routeName: (context) => SavedCombos(),
            HomeScreen.routeName: (context) => HomeScreen(),
            EditProfileScreen.routeName: (context) => EditProfileScreen(),
            ProfileScreen.routeName: (context) => ProfileScreen(),
            StartRecording.routeName: (context) => StartRecording(),
            LeaderboardScreen.routeName: (context) => LeaderboardScreen(),
            SavedVideos.routeName: (context) => SavedVideos(),
            SavedVideo.routeName: (context) => SavedVideo(),
            FriendList.routeName: (context) => FriendList(),
            FriendRequests.routeName: (context) => FriendRequests(),
            ChatScreen.routeName: (context) => ChatScreen(),
          }),
    );
  }
}
