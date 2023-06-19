import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:wombocombo/screens/friend_list/friend_list_screen.dart';
import 'package:wombocombo/screens/profile/profile_screen.dart';
import 'package:wombocombo/providers/auth_provider.dart';
import 'package:wombocombo/providers/friends_providers.dart';
import 'package:wombocombo/providers/user_provider.dart';

class FriendRequests extends StatefulWidget {
  static const routeName = '/friend-req';
  const FriendRequests({Key? key}) : super(key: key);

  @override
  State<FriendRequests> createState() => _FriendRequestsState();
}

class _FriendRequestsState extends State<FriendRequests> {
  late final AuthProvider authProvider =
      Provider.of<AuthProvider>(context, listen: false);
  late final FriendsProvider friendProvider =
      Provider.of<FriendsProvider>(context, listen: false);
  late final UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);
  var isLoading = true;
  var user2CurrentUser;
  List friendRequestUser = [];
  List friendRequestData = [];

  void declineFriendRequest(id) {
    friendProvider.deleteFriend(id);
  }

  void acceptFriendRequest(id) {
    friendProvider.updateFriend(id, {'status': 1});
  }

  void getFriendRequests() async {
    var currentUserId = authProvider.userId;
    setState(() {
      isLoading = true;
    });
    user2CurrentUser = await friendProvider.getFriendFilterTwoEquals(
        'user2', currentUserId, 'status', 0);

    for (var user in user2CurrentUser!.docs) {
      friendRequestUser.add({
        "user": user['user1'],
        "id": user.id,
      });
    }
    for (var friend in friendRequestUser) {
      var currentFriend = await userProvider.getUser(friend['user']);
      friendRequestData.add(currentFriend);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getFriendRequests();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushReplacementNamed(FriendList.routeName);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Friend Requests'),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: ListView.builder(
                    shrinkWrap: true,
                    reverse: false,
                    itemCount: friendRequestData?.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed(
                          ProfileScreen.routeName,
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
                              friendRequestData[index]['username'],
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            subtitle: Text(friendRequestData[index]
                                    ['userPoints']
                                .toString()),
                            trailing: SizedBox(
                              width: 130,
                              child: Row(
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      acceptFriendRequest(
                                          friendRequestUser[index]['id']);
                                      setState(() {
                                        friendRequestData.removeAt(index);
                                      });

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Friend request accepted'),
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.check_outlined,
                                        color: Colors.green),
                                    label: Text(''),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      declineFriendRequest(
                                          friendRequestUser[index]['id']);

                                      setState(() {
                                        friendRequestData.removeAt(index);
                                      });

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Friend request removed'),
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.close_outlined,
                                        color: Colors.red),
                                    label: Text(''),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
      ),
    );
  }
}
