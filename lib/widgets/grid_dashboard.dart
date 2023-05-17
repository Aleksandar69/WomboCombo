import 'package:flutter/material.dart';
import 'package:wombocombo/screens/combos/training_levels.dart';
import 'package:wombocombo/screens/countdown_timer/set_timer_screen.dart';
import 'package:wombocombo/screens/friend_screens/friend_list.dart';
import 'package:wombocombo/screens/leaderboard/leaderboard_screen.dart';
import 'package:wombocombo/screens/make_your_combo/make_your_combo_screen.dart';
import 'package:wombocombo/screens/recording/start_recording_screen.dart';
import 'package:wombocombo/screens/think_on_your_feet/boxing_mapping.dart';
import '../presentation/custom_icons_icons.dart';

class GridDashboard extends StatelessWidget {
  var userId;
  GridDashboard(this.userId);

  Items item1 = new Items(
    title: "Combos",
    subtitle: "Level up your combos",
    img: CustomIcons.helmet,
  );
  Items item2 = new Items(
    title: "Think Quick",
    subtitle: "Random combos for coordination",
    img: CustomIcons.fire_symbol,
  );
  Items item3 = new Items(
    title: "Customize Combos",
    subtitle: "Make your own custom combo",
    img: Icons.edit_square,
  );
  Items item4 = new Items(
    title: "Timer",
    subtitle: "Use a timer and freestyle",
    img: CustomIcons.stopwatch,
  );
  Items item5 = new Items(
    title: "Record Your Session",
    subtitle: "Film yourself and let your friends rate your skills",
    img: Icons.camera,
  );
  Items item6 = new Items(
    title: "Leaderboard",
    subtitle: "Top Gs",
    img: CustomIcons.crown,
  );
  Items item7 = new Items(
    title: "Friend List",
    subtitle: "See your friends and chat",
    img: CustomIcons.double_team,
  );

  @override
  Widget build(BuildContext context) {
    List<Items> myMenuItems = [item1, item2, item3, item4, item5, item6, item7];
    var color = 0xff453658;
    return Flexible(
      child: GridView.count(
          childAspectRatio: 1.0,
          padding: EdgeInsets.only(left: 16, right: 16),
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          children: myMenuItems.map((data) {
            return GestureDetector(
              onTap: () {
                if (data.title == 'Combos') {
                  // Navigator.of(context).pushNamed(TrainingLevel.routeName,
                  //     arguments: currentUser.uid);
                } else if (data.title == 'Think Quick') {
                  Navigator.of(context).pushNamed(BoxingMapping.routeName);
                } else if (data.title == "Customize Combos") {
                  Navigator.of(context)
                      .pushNamed(MakeYourComboScreen.routeName);
                } else if (data.title == "Timer") {
                  Navigator.of(context).pushNamed(SetTimeScreen.routeName,
                      arguments: 'fromHomeScreen');
                } else if (data.title == "Record Your Session") {
                  Navigator.of(context).pushNamed(StartRecording.routeName);
                } else if (data.title == "Leaderboard") {
                  Navigator.of(context).pushNamed(LeaderboardScreen.routeName);
                } else if (data.title == "Friend List") {
                  Navigator.of(context).pushNamed(FriendList.routeName);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Color(color),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Image.asset(
                    //   data.img,
                    //   width: 42,
                    // ),
                    Icon(data.img, size: 30),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      data.title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(data.subtitle,
                        style: TextStyle(
                            color: Colors.white38,
                            fontSize: 10,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            );
          }).toList()),
    );
  }
}

class Items {
  String title;
  String subtitle;
  IconData img;
  Items({required this.title, required this.subtitle, required this.img});
}
