import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wombocombo/screens/profile/profile_screen.dart';
import 'package:wombocombo/widgets/leaderboard/leaderboard_item.dart';

class FriendRequests extends StatefulWidget {
  static const routeName = '/friend-req';
  const FriendRequests({Key? key}) : super(key: key);

  @override
  State<FriendRequests> createState() => _FriendRequestsState();
}

class _FriendRequestsState extends State<FriendRequests> {
  var isLoading = true;
  var user2CurrentUser;
  List friendRequestUser = [];
  List friendRequestData = [];

  void declineFriendRequest(id) {
    FirebaseFirestore.instance.collection('friendList').doc(id).delete();
  }

  void acceptFriendRequest(id) {
    FirebaseFirestore.instance
        .collection('friendList')
        .doc(id)
        .update({'status': 1});
  }

  void getFriendRequests() async {
    var currentUser = FirebaseAuth.instance.currentUser;

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
        friendRequestUser.add({
          "user": user['user1'],
          "id": user.id,
        });
      }
    }
    //getAllFriendData();

    for (var friend in friendRequestUser) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(friend['user'])
          .get()
          .then((value) {
        friendRequestData.add(value);
      });
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
    return Scaffold(
      appBar: AppBar(
        title: Text('aaa'),
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
                          subtitle: Text(friendRequestData[index]['userPoints']
                              .toString()),
                          trailing: SizedBox(
                            width: 200,
                            child: Row(
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    acceptFriendRequest(
                                        friendRequestUser[index]['id']);
                                  },
                                  icon: Icon(Icons.check_outlined,
                                      color: Colors.green),
                                  label: Text(''),
                                ),
                                TextButton.icon(
                                  onPressed: () {
                                    acceptFriendRequest(
                                        friendRequestUser[index]['id']);
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
    );
  }
}
