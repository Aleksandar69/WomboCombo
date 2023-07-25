import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wombocombo/providers/auth_provider.dart';
import 'package:wombocombo/providers/combos_provider.dart';
import 'package:wombocombo/providers/comments_provider.dart';
import 'package:wombocombo/providers/custom_combo_provider.dart';
import 'package:wombocombo/providers/friends_providers.dart';
import 'package:wombocombo/providers/messages_provider.dart';
import 'package:wombocombo/providers/storage_provider.dart';
import 'package:wombocombo/providers/user_provider.dart';
import 'package:wombocombo/providers/videos_provider.dart';
import 'package:wombocombo/screens/chat/chat_screen.dart';
import 'package:wombocombo/screens/combos/training_levels.dart';
import 'package:wombocombo/screens/countdown_timer/countdown_timer.dart';
import 'package:wombocombo/screens/faq/faq_screen.dart';
import 'package:wombocombo/screens/friend_list/friend_list_screen.dart';
import 'package:wombocombo/screens/friend_list/friend_requests_screen.dart';
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
import 'package:wombocombo/screens/countdown_timer/set_timer_screen.dart';
import 'package:wombocombo/screens/think_on_your_feet/training_difficulty.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wombocombo/widgets/recording/video_recorder.dart';
import 'screens/auth/auth_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
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
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FriendsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CombosProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => StorageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => VideosProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MessagesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CommentsProvider(),
        ),
      ],
      child: MaterialApp(
          title: 'WomboCombo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Color(0xff03045E),
              secondary: Color(0xff023E8A),
            ),
            primaryColor: Color(0xff023E8A),
            buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.yellow,
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
            FAQScreen.routeName: (context) => FAQScreen(),
            AuthScreen.routeName: (context) => AuthScreen(),
            VideoRecorder.routeName: (context) => VideoRecorder(),
          }),
    );
  }
}
