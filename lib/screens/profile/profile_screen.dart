import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wombocombo/helpers/snackbar_helper.dart';
import 'package:wombocombo/models/friend_status.dart';
import 'package:wombocombo/models/user.dart';
import 'package:wombocombo/providers/auth_provider.dart';
import 'package:wombocombo/providers/friends_providers.dart';
import 'package:wombocombo/providers/user_provider.dart';
import 'package:wombocombo/screens/chat/chat_screen.dart';
import 'package:wombocombo/screens/profile/edit_profile_screen.dart';
import 'package:wombocombo/screens/profile/videos/saved_videos.dart';
import '../../widgets/profile/profile_list_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final UserProvider userProvider = Provider.of<UserProvider>(context);
  late final AuthProvider authProvider = Provider.of<AuthProvider>(context);
  late final FriendsProvider friendProvider =
      Provider.of<FriendsProvider>(context, listen: false);
  var userId;
  var isCurrentUser = true;
  var userDataDb;
  late User user;
  var userPoints;
  var currentUserId;
  var isLoading = true;
  File? newImage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final args = ModalRoute.of(context)!.settings.arguments as List;
      userId = args[0];
      if (args.length > 1) {
        newImage = args[1];
      }
    }
    getUser();
    checkIfUserIsAddedAsFriend();
    userId == currentUserId ? isCurrentUser = true : isCurrentUser = false;
  }

  var currentUser;

  void getUser() async {
    currentUserId = authProvider.userId;
    setState(() {
      isLoading = true;
    });

    currentUser = await userProvider.getUser(currentUserId);

    userId == null
        ? userDataDb = await userProvider.getUser(currentUserId)
        : userDataDb = await userProvider.getUser(userId);
    user = User(
        userDataDb['username'],
        userDataDb['email'],
        null,
        userDataDb['image_url'],
        userDataDb['userPoints'],
        userDataDb['currentMaxLevelB'],
        userDataDb['currentMaxLevelKb'],
        null);

    setState(() {
      isLoading = false;
    });
  }

  var user1CurrentUser;
  var user2CurrentUser;
  bool isAlreadyFriendRequested = false;
  bool isAlreadyFriend = false;

  void checkIfUserIsAddedAsFriend() async {
    setState(() {
      isLoading = true;
    });
    user1CurrentUser = await friendProvider.getFriendFilterTwoEquals(
        'user1', currentUserId, 'user2', userId);

    user2CurrentUser = await friendProvider.getFriendFilterTwoEquals(
        'user2', currentUserId, 'user1', userId);

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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
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
                          backgroundImage: newImage == null
                              ? NetworkImage(user.profileImageURL!)
                              : FileImage(newImage!) as ImageProvider,
                          radius: 50,
                        ),
                        SizedBox(height: 10),
                        Text(
                          user.username!,
                          style: TextStyle(
                              fontSize: 27, fontWeight: FontWeight.bold),
                        ),
                        if (isCurrentUser)
                          TextButton.icon(
                            icon: Icon(Icons.edit),
                            onPressed: () async {
                              var result = await Navigator.of(context)
                                      .pushNamed(EditProfileScreen.routeName)
                                  as User;

                              setState(() {
                                user.username = result.username;
                                user.email = result.username;
                                user.profileImageURL = result.profileImageURL;
                              });
                            },
                            label: Text('Edit Profile'),
                          ),
                        SizedBox(height: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                'Earned Points',
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(user.userPoints.toString(),
                                  style: TextStyle(
                                    fontSize: 24,
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      'Boxing Level',
                                      style: TextStyle(
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(user.levelReachedB.toString(),
                                        style: TextStyle(
                                          fontSize: 24,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Column(
                                children: [
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text('Kickboxing Level',
                                        style: TextStyle(fontSize: 24)),
                                  ),
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(user.levelReachedKb.toString(),
                                        style: TextStyle(
                                          fontSize: 24,
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        GestureDetector(
                          child: ProfileListItem(
                            icon: Icons.camera_roll_outlined,
                            text: 'Videos',
                          ),
                          onTap: () => Navigator.of(context).pushNamed(
                              SavedVideos.routeName,
                              arguments: [userId]),
                        ),
                        if (!isCurrentUser)
                          !isAlreadyFriendRequested
                              ? GestureDetector(
                                  child: ProfileListItem(
                                    icon: Icons.add,
                                    text: 'Add Friend',
                                  ),
                                  onTap: () {
                                    friendProvider.addFriend(FriendStatus(
                                        currentUserId,
                                        userId,
                                        0,
                                        currentUser['username'],
                                        user.username!));
                                    setState(() {
                                      isAlreadyFriendRequested = true;
                                    });

                                    SnackbarHelper.showSnackbarSuccess(
                                      context,
                                      'User friend request successfully sent',
                                      'Friend request sent',
                                    );
                                  })
                              : GestureDetector(
                                  child: ProfileListItem(
                                      icon: Icons.add,
                                      text: 'Add Friend',
                                      isFriendAdded: true),
                                  onTap: () {}),
                        if (isAlreadyFriend)
                          GestureDetector(
                            child: ProfileListItem(
                              icon: Icons.messenger_outline_sharp,
                              text: 'Send Message',
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                ChatScreen.routeName,
                                arguments: [
                                  user.username,
                                  user.profileImageURL,
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
      ),
    );
  }
}
