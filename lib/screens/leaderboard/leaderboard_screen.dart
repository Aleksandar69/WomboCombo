import 'package:flutter/material.dart.';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:provider/provider.dart';
import 'package:wombocombo/models/user.dart';
import 'package:wombocombo/providers/auth_provider.dart';
import 'package:wombocombo/providers/dark_mode_notifier.dart';
import 'package:wombocombo/providers/theme_provider.dart';
import 'package:wombocombo/providers/user_provider.dart';
import 'package:wombocombo/screens/home_screen.dart';
import 'package:wombocombo/screens/profile/profile_screen.dart';
import 'package:wombocombo/widgets/leaderboard/leaderboard_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as r;

class LeaderboardScreen extends StatefulWidget {
  static const routeName = '/leaderboard';

  @override
  State<LeaderboardScreen> createState() => LeaderboardScreenState();
}

class LeaderboardScreenState extends State<LeaderboardScreen> {
  var users;
  TextEditingController _searchController = TextEditingController();
  late final UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);
  late final AuthProvider authProvider =
      Provider.of<AuthProvider>(context, listen: false);

  List<DocumentSnapshot> allLoadedUsers = [];
  List<DocumentSnapshot> filteredUsers = [];

  List searchControllerResult = [];
  late User user;

  var isSearchTerm = false;
  var query;

  @override
  void initState() {
    super.initState();
    query = userProvider.getAllUsers('userPoints', true);

    query.snapshots().listen((snapshot) {
      setState(() {
        allLoadedUsers = snapshot.docs;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Leaderboard'),
        ),
        body: Column(
          children: [
            Form(
              child: r.Consumer(builder: (ctx, ref, child) {
                var darkMode = ref.watch(darkModeProvider);
                return Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        filteredUsers = allLoadedUsers
                            .where((item) => item['username'].contains(value))
                            .toList();
                        setState(() {
                          isSearchTerm = true;
                        });

                        if (_searchController.text == '') {
                          setState(() {
                            isSearchTerm = false;
                          });
                        }
                      });
                    },
                    decoration: InputDecoration(
                        focusColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 1.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        fillColor: Colors.grey,
                        hintText: "Search",
                        hintStyle: TextStyle(
                            color: darkMode ? Colors.white : Colors.black)),
                    textInputAction: TextInputAction.search,
                  ),
                );
              }),
            ),
            Expanded(
              child: !isSearchTerm
                  ? FirestoreListView<Map<String, dynamic>>(
                      query: userProvider.getAllUsersWithOrderAndLimit(
                          'userPoints', true, 10),
                      itemBuilder: (context, snapshot) {
                        Map<String, dynamic> userDocs = snapshot.data();
                        return GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(
                            ProfileScreen.routeName,
                            arguments: [snapshot.id],
                          ),
                          child: LeaderboardItem(
                              userDocs['username'],
                              userDocs['userPoints'],
                              userDocs['image_url'],
                              snapshot.id,
                              snapshot.id == authProvider.userId),
                        );
                      })
                  : ListView.builder(
                      shrinkWrap: true,
                      reverse: false,
                      itemCount: filteredUsers?.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(
                            ProfileScreen.routeName,
                            arguments: [filteredUsers[index].id],
                          ),
                          child: LeaderboardItem(
                              filteredUsers[index]['username'],
                              filteredUsers[index]['userPoints'],
                              filteredUsers[index]['image_url'],
                              filteredUsers[index].id,
                              filteredUsers[index].id == authProvider.userId),
                        );
                      }),
            )
          ],
        ),
      ),
    );
  }
}
