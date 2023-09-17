import 'package:flutter/material.dart.';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:provider/provider.dart';
import 'package:wombocombo/providers/auth_provider.dart';
import 'package:wombocombo/providers/theme_provider.dart';
import 'package:wombocombo/providers/user_provider.dart';
import 'package:wombocombo/screens/home_screen.dart';
import 'package:wombocombo/screens/profile/profile_screen.dart';
import 'package:wombocombo/widgets/leaderboard/leaderboard_item.dart';

class LeaderboardScreen extends StatefulWidget {
  static const routeName = '/leaderboard';

  @override
  State<LeaderboardScreen> createState() => LeaderboardScreenState();
}

class LeaderboardScreenState extends State<LeaderboardScreen> {
  var users;
  TextEditingController _search = TextEditingController();
  late final UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);
  late final AuthProvider authProvider =
      Provider.of<AuthProvider>(context, listen: false);

  var isSearchTerm = false;

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
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
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  controller: _search,
                  onFieldSubmitted: (value) {
                    setState(() {
                      value == "" ? isSearchTerm = false : isSearchTerm = true;
                    });
                  },
                  decoration: InputDecoration(
                      focusColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.person_outline_rounded,
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
                          color: themeProvider.darkTheme
                              ? Colors.white
                              : Colors.black)),
                  textInputAction: TextInputAction.search,
                ),
              ),
            ),
            Expanded(
              child: FirestoreListView<Map<String, dynamic>>(
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
                  }),
            )
          ],
        ),
      ),
    );
  }
}
