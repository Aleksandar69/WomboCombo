import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:wombocombo/providers/auth_provider.dart';
import 'package:wombocombo/providers/friends_providers.dart';
import 'package:wombocombo/providers/messages_provider.dart';
import 'package:wombocombo/providers/theme_provider.dart';
import 'package:wombocombo/providers/user_provider.dart';
import 'package:wombocombo/widgets/main_drawer.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import '../widgets/grid_dashboard.dart';
import '../customAppBar.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late final AuthProvider authProvider =
      Provider.of<AuthProvider>(context, listen: false);
  late final FriendsProvider friendsProvider =
      Provider.of<FriendsProvider>(context, listen: false);
  late final UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);
  late final MessagesProvider messagesProvider =
      Provider.of<MessagesProvider>(context, listen: false);
  var currentUserId;
  var user2CurrentUser;
  var isLoading = true;
  List friendRequests = [];
  var allFriendRequests = [];
  var currentUserData;
  var messages;
  int numberOfUnreadMess = 0;

  getFriendNotif() async {
    currentUserId = authProvider.userId;

    var user2CurrentUser = await friendsProvider.getFriendFilterTwoEquals(
        'user2', currentUserId, 'status', 0);

    friendRequests = user2CurrentUser!.docs as List;
    setState(() {
      isLoading = false;
    });
  }

  getUnreadMess() async {
    messages = await messagesProvider.getAllMessagesForReceiver(currentUserId);

    numberOfUnreadMess = messages.size;
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
    getUnreadMess();
  }

  void registerNotification() {
    firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showNotification(message.notification!);
      }
      return;
    });

    firebaseMessaging.getToken().then((token) {
      if (token != null) {
        userProvider.updateUserInfo(currentUserId, {'pushToken': token});
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
      'com.aleksandar.wombocombo',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: customAppBar("Home"),
      drawer: MainDrawer(currentUserId),
      body: Column(
        children: [
          GridDashboard(currentUserId, friendRequests, numberOfUnreadMess),
        ],
      ),
    );
  }
}
