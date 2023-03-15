import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wombocombo/providers/user_provider.dart';
import 'package:wombocombo/widgets/main_drawer.dart';
import 'combos/training_levels.dart';
import 'package:wombocombo/screens/think_on_your_feet/choose_martial_art_screen.dart';
import 'package:wombocombo/screens/make_your_combo/make_your_combo_screen.dart';
import 'package:wombocombo/screens/countdown_timer/set_timer_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home-screen';

  var menuItems = [
    'Think on your feet',
    'Make your own workout',
    'Get your combos up',
    'Timer',
    'Instructions'
  ];

  @override
  Widget build(BuildContext context) {
    void addUser() async {
      await Provider.of<UserProvider>(context, listen: false)
          .addUserInitially();
    }

    addUser();
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
            ],
          )),
    );
  }
}
