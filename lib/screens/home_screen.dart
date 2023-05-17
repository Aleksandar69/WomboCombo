import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import './think_on_your_feet/boxing_mapping.dart';
import '../presentation/custom_icons_icons.dart';
import '../widgets/grid_dashboard.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var currentUser;

  // var menuItems = [
  //   'Think on your feet',
  //   'Make your own workout',
  //   'Get your combos up',
  //   'Timer',
  //   'Instructions'
  // ];
  var user2CurrentUser;
  var isLoading = true;
  List friendRequests = [];
  var currentUserData;

  getFriendNotif() async {
    currentUser = FirebaseAuth.instance.currentUser;

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
  void initState() {
    super.initState();
    registerNotification();
    configLocalNotification();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getFriendNotif();
  }

  void registerNotification() {
    firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage: $message');
      if (message.notification != null) {
        showNotification(message.notification!);
      }
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('push token: $token');
      if (token != null) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({'pushToken': token});
      }
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  void configLocalNotification() {
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(RemoteNotification remoteNotification) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.dfa.flutterchatdemo'
          : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    print(remoteNotification);

    await flutterLocalNotificationsPlugin.show(
      0,
      remoteNotification.title,
      remoteNotification.body,
      platformChannelSpecifics,
      payload: null,
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text("Activities"),
  //       // leading: Padding(
  //       //   padding: const EdgeInsets.all(8.0),
  //       //   child: GestureDetector(
  //       //     onTap: () {
  //       //       Navigator.of(context).pushNamed(EditProfileScreen.routeName);
  //       //     },
  //       //     child: Material(
  //       //       shape: CircleBorder(),
  //       //     ),
  //       //   ),
  //       // ),
  //     ),
  //     drawer: MainDrawer(),
  //     body: Container(
  //         child: SingleChildScrollView(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.stretch,
  //         children: [
  //           GestureDetector(
  //             onTap: () =>
  //                 Navigator.of(context).pushNamed(BoxingMapping.routeName),
  //             child: Container(
  //               height: 100,
  //               child: Card(
  //                 child: Center(
  //                   child: Text('Think on your feet'),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           GestureDetector(
  //             onTap: () => Navigator.of(context)
  //                 .pushNamed(MakeYourComboScreen.routeName),
  //             child: Container(
  //               height: 100,
  //               child: Card(
  //                 child: Center(
  //                   child: Text('Make your own workout'),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           GestureDetector(
  //             onTap: () {
  //               Navigator.of(context).pushNamed(TrainingLevel.routeName,
  //                   arguments: currentUser.uid);
  //             },
  //             child: Container(
  //               height: 100,
  //               child: Card(
  //                 child: Center(
  //                   child: Text(
  //                     'Get your combos up',
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           GestureDetector(
  //             onTap: () => Navigator.of(context).pushNamed(
  //                 SetTimeScreen.routeName,
  //                 arguments: 'fromHomeScreen'),
  //             child: Container(
  //               height: 100,
  //               child: Card(
  //                 child: Center(
  //                   child: Text(
  //                     'Timer',
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           GestureDetector(
  //             onTap: () =>
  //                 Navigator.of(context).pushNamed(StartRecording.routeName),
  //             child: Container(
  //               height: 100,
  //               child: Card(
  //                 child: Center(
  //                   child: Text(
  //                     'Record your session',
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           GestureDetector(
  //             onTap: () =>
  //                 Navigator.of(context).pushNamed(LeaderboardScreen.routeName),
  //             child: Container(
  //               height: 100,
  //               child: Card(
  //                 child: Center(
  //                   child: Text(
  //                     'Leaderboard',
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           GestureDetector(
  //             onTap: () => Navigator.of(context).pushNamed(FriendList.routeName,
  //                 arguments: [friendRequests.length]),
  //             child: Container(
  //               height: 100,
  //               child: Card(
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Center(
  //                       child: Text(
  //                         'Friend List ',
  //                       ),

  //                       //     Text.rich(TextSpan(//apply style to all
  //                       //         children: [
  //                       //   TextSpan(
  //                       //     text: 'Friend Requests ',
  //                       //   ),
  //                       //   TextSpan(
  //                       //       text: '${friendRequests.length}',
  //                       //       style: TextStyle(
  //                       //           fontSize: 12, backgroundColor: Colors.red))
  //                       // ]))
  //                     ),
  //                     if (friendRequests.length != 0)
  //                       Center(
  //                           child: ClipOval(
  //                         child: Container(
  //                           color: Colors.red,
  //                           padding: EdgeInsets.symmetric(horizontal: 6),
  //                           child: Text(
  //                             "${friendRequests.length}",
  //                           ),
  //                         ),
  //                       ))
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     )),
  //   );
  // }
  //}

//   final List<MenuItem> menuItems = [
//     MenuItem(icon: CustomIcons.helmet, label: 'Combos'),
//     MenuItem(icon: CustomIcons.fire_symbol, label: 'Think Quick Random Combos'),
//     MenuItem(icon: Icons.edit_square, label: 'Make Your Own Combos'),
//     MenuItem(icon: CustomIcons.stopwatch, label: 'Timer'),
//     MenuItem(icon: Icons.camera, label: 'Record Your Session'),
//     MenuItem(icon: CustomIcons.crown, label: 'Leaderboard'),
//     MenuItem(icon: CustomIcons.double_team, label: 'Friend List'),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Wombo Combo'),
//       ),
//       body: ListView.builder(
//         itemCount: menuItems.length,
//         itemBuilder: (BuildContext context, int index) {
//           return Container(
//             height: MediaQuery.of(context).size.height * 0.07,
//             child: ListTile(
//               leading: Icon(menuItems[index].icon, size: 30),
//               title: Text(
//                 menuItems[index].label,
//                 style: TextStyle(fontSize: 24),
//               ),
//               onTap: () {
//                 switch (index) {
//                   case 0:
//                     // Handle Home item tap
//                     break;
//                   case 1:
//                     // Handle Search item tap
//                     break;
//                   case 2:
//                     // Handle Favorites item tap
//                     break;
//                   case 3:
//                     // Handle Cart item tap
//                     break;
//                   case 4:
//                     // Handle Notifications item tap
//                     break;
//                   case 5:
//                     // Handle Settings item tap
//                     break;
//                   case 6:
//                     // Handle Logout item tap
//                     break;
//                 }
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class MenuItem {
//   final IconData icon;
//   final String label;

//   MenuItem({required this.icon, required this.label});
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wombo Combo'),
      ),
      body: Column(
        children: [
          GridDashboard(currentUser.uid),
        ],
      ),
    );
  }
}
