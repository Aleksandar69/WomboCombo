import 'dart:async';

import 'package:flutter/material.dart.';
import 'package:provider/provider.dart';
import 'package:wombocombo/helpers/snackbar_helper.dart';
import 'package:wombocombo/providers/auth_provider.dart';
import 'package:wombocombo/providers/friends_providers.dart';
import 'package:wombocombo/providers/messages_provider.dart';
import 'package:wombocombo/providers/user_provider.dart';
import 'package:wombocombo/screens/chat/chat_screen.dart';
import 'package:wombocombo/screens/friend_list/friend_requests_screen.dart';
import 'package:wombocombo/screens/home_screen.dart';
import 'package:wombocombo/screens/leaderboard/leaderboard_screen.dart';
import 'package:wombocombo/screens/profile/profile_screen.dart';

class FriendList extends StatefulWidget {
  static const routeName = '/friend-list';
  const FriendList({Key? key}) : super(key: key);

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  late final AuthProvider authProvider =
      Provider.of<AuthProvider>(context, listen: false);
  late final FriendsProvider friendProvider =
      Provider.of<FriendsProvider>(context, listen: false);
  late final UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);
  late final MessagesProvider messagesProvider =
      Provider.of<MessagesProvider>(context, listen: false);
  var currentUserId;
  var user1CurrentUser;
  var user2CurrentUser;
  var isLoading = true;
  List friendsMerged = [];
  List friendListUser1 = [];
  List friendListUser2 = [];
  List friendData = [];
  List friendRequests = [];
  var fetchedFriendsRequests;
  var groupChatId;
  List messages = [];
  var friendsAndMessages = {};

  getFriendList() async {
    currentUserId = authProvider.userId;
    setState(() {
      isLoading = true;
    });

    user1CurrentUser = await friendProvider.getFriendFilterTwoEquals(
        'user1', currentUserId, 'status', 1);
    user2CurrentUser = await friendProvider.getFriendFilterTwoEquals(
        'user2', currentUserId, 'status', 1);

    friendListUser1 = user1CurrentUser.docs as List;
    friendListUser2 = user2CurrentUser.docs as List;

    fetchedFriendsRequests = await friendProvider.getFriendFilterTwoEquals(
        'user2', currentUserId, 'status', 0);

    for (var friend in friendListUser1) {
      friendsMerged.add({'friend': friend['user2'], 'friendListId': friend.id});
    }

    for (var friend in friendListUser2) {
      friendsMerged.add({'friend': friend['user1'], 'friendListId': friend.id});
    }

    for (var user in fetchedFriendsRequests!.docs) {
      friendRequests.add(user['user1']);
    }

    for (var friendEntry in friendsMerged) {
      var currentFriend = await userProvider.getUser(friendEntry['friend']);
      friendData.add(currentFriend);
    }
    int noOfMessages = 0;

    for (var i = 0; i < friendData.length; i++) {
      var friendId = friendData[i].id;
      if (currentUserId.hashCode <= friendId.hashCode) {
        groupChatId = '${currentUserId}-${friendId}';
      } else {
        groupChatId = '${friendId}-${currentUserId}';
      }
      var message = await messagesProvider.getMessagesForReceiver(
          groupChatId, currentUserId);
      noOfMessages = message.size;
      messages.add(noOfMessages);
    }

    setState(() {
      isLoading = false;
    });
  }

  void _delete(String id, int index) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Please Confirm',
                style: TextStyle(color: Colors.white)),
            content: const Text('Remove user from friend list?',
                style: TextStyle(color: Colors.white)),
            backgroundColor: Color(0xff4285F4),
            actions: [
              TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xff0E1D36))),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:
                      const Text('No', style: TextStyle(color: Colors.white))),
              TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xff0E1D36))),
                  onPressed: () {
                    friendProvider.deleteFriend(id);
                    Navigator.of(context).pop();
                    setState(() {
                      friendData.removeAt(index);
                      friendsMerged.removeAt(index);
                    });
                    SnackbarHelper.showSnackbarSuccess(
                        context, '', 'User succesfully removed');
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          );
        });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getFriendList();
  }

  @override
  Widget build(BuildContext context) {
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
                                      child: Text(
                                        'Go to Leaderboard',
                                        style: TextStyle(
                                            color: Colors.blue.shade500,
                                            decoration:
                                                TextDecoration.underline),
                                      )),
                            ],
                          ),
                          Center(
                            child: Text(
                                'No friends yet, go to the leaderboard to send a request!'),
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
                                            backgroundImage: NetworkImage(
                                                friendData[index]["image_url"]),
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
                                          subtitle: Text(
                                              messages[index].toString() +
                                                  " new messages"),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                  icon: Icon(
                                                    Icons.messenger_outline,
                                                    color: Colors.blue,
                                                  ),
                                                  color: Theme.of(context)
                                                      .errorColor,
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                      ChatScreen.routeName,
                                                      arguments: [
                                                        friendData[index]
                                                            ['username'],
                                                        friendData[index]
                                                            ['image_url'],
                                                        friendData[index].id
                                                      ],
                                                    );
                                                    setState(() {
                                                      messages[index] = 0;
                                                    });
                                                  }),
                                              IconButton(
                                                  onPressed: () {
                                                    _delete(
                                                        friendsMerged[index]
                                                            ['friendListId'],
                                                        index);
                                                  },
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  )),
                                            ],
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
