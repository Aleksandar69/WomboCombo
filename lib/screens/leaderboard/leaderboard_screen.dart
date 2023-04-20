import 'package:flutter/material.dart.';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wombocombo/models/user.dart';
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

  var fireStoreFetch;
  var isSearchTerm = false;

  filterSeachedUser(term) {
    fireStoreFetch = FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: term)
        .orderBy('userPoints', descending: true)
        .limit(4)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('text'),
      ),
      body: Column(
        children: [
          Form(
            child: Container(
              width: 250,
              child: TextFormField(
                controller: _search,
                onFieldSubmitted: (value) {
                  setState(() {
                    fireStoreFetch = value;

                    value == "" ? isSearchTerm = false : isSearchTerm = true;
                  });
                  print('firstorefetch je $fireStoreFetch');
                },
                decoration: InputDecoration(
                  focusColor: Colors.white,
                  //add prefix icon
                  prefixIcon: Icon(
                    Icons.person_outline_rounded,
                    color: Colors.grey,
                  ),
                  errorText: "Error",
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
                ),
                textInputAction: TextInputAction.search,
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: !isSearchTerm
                  ? FirebaseFirestore.instance
                      .collection('users')
                      .orderBy('userPoints', descending: true)
                      .limit(4)
                      .snapshots()
                  : fireStoreFetch = FirebaseFirestore.instance
                      .collection('users')
                      .where('username', isEqualTo: fireStoreFetch)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final userDocs = snapshot.data!.docs;

                return userDocs?.length == 0
                    ? Center(
                        child: Text('No results found'),
                      )
                    : SingleChildScrollView(
                        child: ListView.builder(
                            shrinkWrap: true,
                            reverse: false,
                            itemCount: userDocs?.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => Navigator.of(context).pushNamed(
                                  ProfileScreen.routeName,
                                  arguments: [userDocs[index].id],
                                ),
                                child: LeaderboardItem(
                                  userDocs[index]['username'],
                                  userDocs[index]['userPoints'],
                                  userDocs[index]['image_url'],
                                ),
                              );
                            }),
                      );
              }),
        ],
      ),
    );
  }
}
