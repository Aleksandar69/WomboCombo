import 'dart:async';

import 'package:flutter/material.dart.';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wombocombo/screens/chat/chat_screen.dart';
import 'package:wombocombo/screens/friend_list/friend_requests_screen.dart';
import 'package:wombocombo/screens/home_screen.dart';
import 'package:wombocombo/screens/leaderboard/leaderboard_screen.dart';
import 'package:wombocombo/screens/profile/profile_screen.dart';
import 'package:wombocombo/widgets/chat/new_message.dart';
import 'package:wombocombo/widgets/leaderboard/leaderboard_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendList extends StatefulWidget {
  static const routeName = '/friend-list';
  const FriendList({Key? key}) : super(key: key);

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  var currentUser;
  var user1CurrentUser;
  var user2CurrentUser;
  var isLoading = true;
  List friendsMerged = [];
  List friendData = [];
  List friendRequests = [];

  getFriendList() async {
    currentUser = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('friendList')
        .where('user1', isEqualTo: currentUser.uid)
        .get()
        .then((value) {
      user1CurrentUser = value;
      setState(() {
        isLoading = true;
      });
    });
    await FirebaseFirestore.instance
        .collection('friendList')
        .where('user2', isEqualTo: currentUser.uid)
        .get()
        .then((value) {
      user2CurrentUser = value;
      setState(() {
        isLoading = true;
      });
    });

    for (var user in user1CurrentUser!.docs) {
      if (user['status'] == 1 && user['user2'] != currentUser.uid) {
        friendsMerged.add(user['user2']);
      }
    }
    for (var user in user2CurrentUser!.docs) {
      if (user['status'] == 1 && user['user1'] != currentUser.uid) {
        friendsMerged.add(user['user1']);
      }
    }

    for (var user in user2CurrentUser!.docs) {
      if (user['status'] == 0) {
        friendRequests.add(user['user1']);
      }
    }

    for (var friend in friendsMerged) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(friend)
          .get()
          .then((value) {
        friendData.add(value);
        setState(() {
          isLoading = true;
        });
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getFriendList();
  }

  @override
  Widget build(BuildContext context) {
    var fireStoreFetch;

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Friend List'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: friendData.length == 0
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            isLoading
                ? Center(child: CircularProgressIndicator())
                : friendData.length == 0
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                friendRequests.length == 1
                                    ? '${friendRequests.length} Friend request'
                                    : '${friendRequests.length} Friend requests',
                              ),
                              friendRequests.length > 0
                                  ? TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                            FriendRequests.routeName);
                                      },
                                      child: Text('View'))
                                  : TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                            LeaderboardScreen.routeName);
                                      },
                                      child: Text('Go to Leaderboard')),
                            ],
                          ),
                          Center(
                            child: Text(
                                'No friends yet, go to leaderboard to send a request!'),
                          ),
                        ],
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  friendRequests.length == 1
                                      ? '${friendRequests.length} Friend request'
                                      : '${friendRequests.length} Friend requests',
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed(FriendRequests.routeName);
                                    },
                                    child: Text('View'))
                              ],
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                reverse: false,
                                itemCount: friendData?.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                      onTap: () =>
                                          Navigator.of(context).pushNamed(
                                            ProfileScreen.routeName,
                                            arguments: [friendData[index].id],
                                          ),
                                      child: Card(
                                        elevation: 5,
                                        margin: EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal: 2,
                                        ),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            radius: 30,
                                            child: Padding(
                                              padding: EdgeInsets.all(2),
                                            ),
                                          ),
                                          title: Text(
                                            friendData[index]['username'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          subtitle: Text(friendData[index]
                                                  ['userPoints']
                                              .toString()),
                                          trailing: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  360
                                              ? TextButton.icon(
                                                  label: Text('Send Message'),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                    ChatScreen.routeName,
                                                    arguments: [
                                                      friendData[index]
                                                          ['username'],
                                                      friendData[index]
                                                          ['image_url'],
                                                      friendData[index].id,
                                                    ],
                                                  ),
                                                  icon: Icon(
                                                      Icons.messenger_outline),
                                                )
                                              : IconButton(
                                                  icon: Icon(
                                                      Icons.messenger_outline),
                                                  color: Theme.of(context)
                                                      .errorColor,
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                    ChatScreen.routeName,
                                                    arguments: [
                                                      friendData[index]
                                                          ['username'],
                                                      friendData[index]
                                                          ['image_url'],
                                                      friendData[index].id,
                                                    ],
                                                  ),
                                                ),
                                        ),
                                      ));
                                }),
                          ],
                        ),
                      )
          ],
        ),
      ),
    );
  }
}
