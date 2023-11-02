import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wombocombo/providers/theme_provider.dart';
import 'package:wombocombo/screens/combos/training_levels.dart';
import 'package:wombocombo/screens/countdown_timer/set_timer_screen.dart';
import 'package:wombocombo/screens/faq/faq_screen.dart';
import 'package:wombocombo/screens/friend_list/friend_list_screen.dart';
import 'package:wombocombo/screens/leaderboard/leaderboard_screen.dart';
import 'package:wombocombo/screens/make_your_combo/make_your_combo_screen.dart';
import 'package:wombocombo/screens/recording/start_recording_screen.dart';
import 'package:wombocombo/screens/think_on_your_feet/strikes_mapping.dart';
import 'package:wombocombo/screens/think_on_your_feet/choose_martial_art_screen.dart';
import '../presentation/custom_icons_icons.dart';
import '../screens/combos/choose_martial_art.dart';

class GridDashboard extends StatelessWidget {
  var userId;
  int newMessages;
  List friendRequests;
  GridDashboard(this.userId, this.friendRequests, this.newMessages);

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
    subtitle: "Let your friends rate your skills",
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
  Items item8 = new Items(
    title: "FAQ",
    subtitle: "Questions and Answers",
    img: Icons.question_mark_outlined,
  );
  @override
  Widget build(BuildContext context) {
    List<Items> myMenuItems = [
      item1,
      item2,
      item3,
      item4,
      item5,
      item6,
      item7,
      item8
    ];
    return Flexible(
      child: Consumer<ThemeNotifier>(builder: (context, value, child) {
        return GridView.count(
            childAspectRatio: 1.0,
            padding: EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 12),
            crossAxisCount: 2,
            crossAxisSpacing: 9,
            mainAxisSpacing: 9,
            children: myMenuItems.map((data) {
              return GestureDetector(
                onTap: () {
                  if (data.title == 'Combos') {
                    Navigator.of(context).pushNamed(
                        ChooseMartialArtCombos.routeName,
                        arguments: userId);
                  } else if (data.title == 'Think Quick') {
                    Navigator.of(context).pushNamed(ChooseMartialArt.routeName);
                  } else if (data.title == "Customize Combos") {
                    Navigator.of(context)
                        .pushNamed(MakeYourComboScreen.routeName);
                  } else if (data.title == "Timer") {
                    Navigator.of(context).pushNamed(SetTimeScreen.routeName,
                        arguments: 'fromHomeScreen');
                  } else if (data.title == "Record Your Session") {
                    Navigator.of(context).pushNamed(StartRecording.routeName);
                  } else if (data.title == "Leaderboard") {
                    Navigator.of(context)
                        .pushNamed(LeaderboardScreen.routeName);
                  } else if (data.title == "Friend List") {
                    Navigator.of(context).pushNamed(FriendList.routeName,
                        arguments: [friendRequests.length]);
                  } else if (data.title == "FAQ") {
                    Navigator.of(context).pushNamed(
                      FAQScreen.routeName,
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: value.isDarkTheme
                          ? Color(0xff023E8A)
                          : Color.fromARGB(255, 36, 101, 187),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Image.asset(
                      //   data.img,
                      //   width: 42,
                      // ),
                      Icon(
                        data.img,
                        size: 30,
                        color: Colors.amber.shade800,
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Text(
                        data.title,
                        style: TextStyle(
                            color: Colors.yellow.shade200,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(data.subtitle,
                          style: TextStyle(
                              color: Colors.yellow.shade100,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                      SizedBox(
                        height: 8,
                      ),
                      if (friendRequests.length != 0 ||
                          newMessages != 0 && data.title == "Friend List")
                        Center(
                            child: ClipOval(
                          child: Container(
                            color: Colors.red,
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              "${friendRequests.length + newMessages}",
                            ),
                          ),
                        ))
                    ],
                  ),
                ),
              );
            }).toList());
      }),
    );
  }
}

class Items {
  String title;
  String subtitle;
  IconData img;
  Items({required this.title, required this.subtitle, required this.img});
}
