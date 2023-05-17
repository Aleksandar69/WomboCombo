import 'package:flutter/material.dart';
import 'package:wombocombo/screens/chat/chat_screen.dart';
import 'package:wombocombo/screens/profile/edit_profile_screen.dart';
import 'package:wombocombo/screens/profile/videos/saved_videos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userId;
  var isCurrentUser = true;
  var imgUrl;
  var user;
  var username;
  var userPoints;
  var currentUser;
  var isLoading = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final args = ModalRoute.of(context)!.settings.arguments as List;
      userId = args[0];
    }
    getUser();
    checkIfUserIsAddedAsFriend();
  }

  var currentUserUsername;
  var currentUserUserImg;
  var currentUser2;

  void getUser() async {
    currentUser = FirebaseAuth.instance.currentUser;

    userId == null
        ? await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .get()
            .then((value) {
            user = value;
            setState(() {
              isLoading = true;
            });
          })
        : await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get()
            .then((value) {
            user = value;
            setState(() {
              isLoading = true;
            });
          });

    setState(() {
      isLoading = false;
    });
  }

  var user1CurrentUser;
  var user2CurrentUser;
  bool isAlreadyFriendRequested = false;
  bool isAlreadyFriend = false;

  void checkIfUserIsAddedAsFriend() async {
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
      if (user['user2'] == userId) {
        isAlreadyFriendRequested = true;
        if (user['status'] == 1) {
          isAlreadyFriend = true;
        }
      }
    }

    for (var user in user2CurrentUser!.docs) {
      if (user['user1'] == userId) {
        isAlreadyFriendRequested = true;
        if (user['status'] == 1) {
          isAlreadyFriend = true;
        }
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 20),
                      CircleAvatar(
                        radius: 50,
                      ),
                      SizedBox(height: 10),
                      Text(
                        user['username'],
                        style: TextStyle(
                            fontSize: 27, fontWeight: FontWeight.bold),
                      ),
                      if (isCurrentUser)
                        TextButton.icon(
                          icon: Icon(Icons.edit),
                          onPressed: () => Navigator.of(context)
                              .pushNamed(EditProfileScreen.routeName),
                          label: Text('Edit Profile'),
                        ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Earned Points',
                                style: TextStyle(
                                  fontSize: 27,
                                ),
                              ),
                              Text(user['userPoints'].toString(),
                                  style: TextStyle(
                                    fontSize: 27,
                                  )),
                            ],
                          ),
                          SizedBox(width: 20),
                          Column(
                            children: [
                              Text('Level Reached',
                                  style: TextStyle(fontSize: 27)),
                              Text(user['currentMaxLevel'].toString(),
                                  style: TextStyle(
                                    fontSize: 27,
                                  )),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      // Container(
                      //   width: double.infinity,
                      //   height: 70,
                      //   child: Card(
                      //     child: Text(
                      //       'Combos',
                      //       style: TextStyle(fontSize: 35),
                      //       textAlign: TextAlign.center,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        child: Container(
                          height: 80,
                          width: double.infinity,
                          child: Card(
                            child: Text(
                              'Videos',
                              style: TextStyle(fontSize: 35),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        onTap: () => Navigator.of(context).pushNamed(
                            SavedVideos.routeName,
                            arguments: [userId]),
                      ),
                      if (!isCurrentUser)
                        SizedBox(
                          height: 30,
                        ),
                      if (userId != null)
                        !isAlreadyFriendRequested
                            ? GestureDetector(
                                child: Container(
                                  height: 80,
                                  width: double.infinity,
                                  child: Card(
                                    child: Text(
                                      'Add Friend',
                                      style: TextStyle(fontSize: 35),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  FirebaseFirestore.instance
                                      .collection('friendList')
                                      .add({
                                    'user1': currentUser.uid,
                                    'user2': userId,
                                    'status': 0
                                  });

                                  setState(() {
                                    isAlreadyFriendRequested = true;
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Friend request sent'),
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                    ),
                                  );
                                })
                            : GestureDetector(
                                child: Container(
                                  height: 80,
                                  width: double.infinity,
                                  child: Card(
                                    child: Text(
                                      'Add Friend',
                                      style: TextStyle(
                                          fontSize: 35, color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                onTap: () {}),
                      if (isAlreadyFriend)
                        GestureDetector(
                          child: Container(
                            height: 80,
                            width: double.infinity,
                            child: Card(
                              child: Text(
                                'Send Message',
                                style: TextStyle(fontSize: 35),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              ChatScreen.routeName,
                              arguments: [
                                username,
                                imgUrl,
                                userId,
                              ],
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
