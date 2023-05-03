import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wombocombo/screens/friend_screens/friend_list.dart';
import 'package:wombocombo/screens/leaderboard/leaderboard_screen.dart';
import 'package:wombocombo/screens/recording/start_recording_screen.dart';
import 'package:wombocombo/widgets/main_drawer.dart';
import 'combos/training_levels.dart';
import 'package:wombocombo/screens/think_on_your_feet/choose_martial_art_screen.dart';
import 'package:wombocombo/screens/make_your_combo/make_your_combo_screen.dart';
import 'package:wombocombo/screens/countdown_timer/set_timer_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var menuItems = [
    'Think on your feet',
    'Make your own workout',
    'Get your combos up',
    'Timer',
    'Instructions'
  ];
  var user2CurrentUser;
  var isLoading = true;
  List friendRequests = [];

  getFriendNotif() async {
    var currentUser = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('friendList')
        .where('user2', isEqualTo: currentUser!.uid)
        .get()
        .then((value) {
      user2CurrentUser = value;
      setState(() {
        isLoading = true;
      });
    });

    for (var user in user2CurrentUser!.docs) {
      if (user['status'] == 0) {
        friendRequests.add(user['user1']);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getFriendNotif();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activities"),
        // leading: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: GestureDetector(
        //     onTap: () {
        //       Navigator.of(context).pushNamed(EditProfileScreen.routeName);
        //     },
        //     child: Material(
        //       shape: CircleBorder(),
        //     ),
        //   ),
        // ),
      ),
      drawer: MainDrawer(),
      body: Container(
          child: SingleChildScrollView(
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
              onTap: () => Navigator.of(context)
                  .pushNamed(MakeYourComboScreen.routeName),
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
              onTap: () {
                FirebaseFirestore.instance
                    .collection('test')
                    .snapshots()
                    .listen((data) {
                  print(data.docs[0]['one']);
                });
                Navigator.of(context).pushNamed(TrainingLevel.routeName);
              },
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
            GestureDetector(
              onTap: () =>
                  Navigator.of(context).pushNamed(StartRecording.routeName),
              child: Container(
                height: 100,
                child: Card(
                  child: Center(
                    child: Text(
                      'Record your session',
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () =>
                  Navigator.of(context).pushNamed(LeaderboardScreen.routeName),
              child: Container(
                height: 100,
                child: Card(
                  child: Center(
                    child: Text(
                      'Leaderboard',
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(FriendList.routeName,
                  arguments: [friendRequests.length]),
              child: Container(
                height: 100,
                child: Card(
                  child: Center(
                    child: Text(
                      'Friend List ${friendRequests.length}',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
