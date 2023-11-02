import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:wombocombo/helpers/snackbar_helper.dart';
import 'package:wombocombo/models/friend_status.dart';
import 'package:wombocombo/providers/auth_provider.dart';
import 'package:wombocombo/providers/friends_providers.dart';
import 'package:wombocombo/providers/user_provider.dart';
import 'package:wombocombo/screens/combos/training_levels.dart';
import '../../widgets/profile/profile_list_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardItem extends StatefulWidget {
  String userName;
  int userPoints;
  var imgUrl;
  String userId;
  bool isCurrentUser;

  LeaderboardItem(this.userName, this.userPoints, this.imgUrl, this.userId,
      this.isCurrentUser);

  @override
  State<LeaderboardItem> createState() => _LeaderboardItemState();
}

class _LeaderboardItemState extends State<LeaderboardItem> {
  late final AuthProvider authProvider =
      Provider.of<AuthProvider>(context, listen: false);
  late final FriendsProvider friendProvider =
      Provider.of<FriendsProvider>(context, listen: false);
  late final UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);

  var user1CurrentUser;
  var user2CurrentUser;
  bool isAlreadyFriendRequested = false;
  bool isAlreadyFriend = false;
  var currentUserId;
  var currentUser;
  var addedUser;

  @override
  void initState() {
    super.initState();
    checkIfUserIsAddedAsFriend();
    getUserProfiles();
  }

  void getUserProfiles() async {
    currentUser = await userProvider.getUser(currentUserId);
    addedUser = await userProvider.getUser(widget.userId);
  }

  void checkIfUserIsAddedAsFriend() async {
    currentUserId = authProvider.userId;

    user1CurrentUser = await friendProvider.getFriendFilterTwoEquals(
        'user1', currentUserId, 'user2', widget.userId);

    user2CurrentUser = await friendProvider.getFriendFilterTwoEquals(
        'user2', currentUserId, 'user1', widget.userId);

    for (var user in user1CurrentUser!.docs) {
      if (user['user2'] == widget.userId) {
        setState(() {
          isAlreadyFriendRequested = true;
        });
        if (user['status'] == 1) {
          isAlreadyFriend = true;
        }
      }
    }

    for (var user in user2CurrentUser!.docs) {
      if (user['user1'] == widget.userId) {
        setState(() {
          isAlreadyFriendRequested = true;
        });
        if (user['status'] == 1) {
          isAlreadyFriend = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 2,
      ),
      child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.imgUrl),
            radius: 30,
            child: Padding(
              padding: EdgeInsets.all(2),
            ),
          ),
          title: Text(
            widget.userName,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(widget.userPoints.toString()),
          trailing: !widget.isCurrentUser
              ? !isAlreadyFriendRequested
                  ? TextButton.icon(
                      label: Text('Add Friend'),
                      onPressed: () {
                        friendProvider.addFriend(FriendStatus(
                            currentUserId,
                            widget.userId,
                            0,
                            currentUser['username'],
                            addedUser['username']));
                        setState(() {
                          isAlreadyFriendRequested = true;
                        });

                        SnackbarHelper.showSnackbarSuccess(
                          context,
                          'User friend request successfully sent',
                          'Friend request sent',
                        );
                      },
                      icon: Icon(Icons.add),
                    )
                  : TextButton.icon(
                      style: ButtonStyle(
                          iconColor: MaterialStateColor.resolveWith(
                              (states) => Colors.grey.shade500)),
                      label: Text(
                        'Add Friend',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                      onPressed: () {
                        SnackbarHelper.showSnackbarError(
                          context,
                          'Friend request already sent',
                          'Error',
                        );
                      },
                      icon: Icon(Icons.add),
                    )
              : null),
    );
  }
}
