import 'package:flutter/material.dart.';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wombocombo/models/user.dart';
import 'package:wombocombo/widgets/leaderboard/leaderboard_item.dart';

class LeaderboardScreen extends StatefulWidget {
  static const routeName = '/leaderboard';

  User user = User('asd', 'asd', 'asd');

  @override
  State<LeaderboardScreen> createState() => LeaderboardScreenState();
}

class LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('text'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final userDocs = snapshot.data!.docs;

            return ListView.builder(
                reverse: true,
                itemCount: userDocs?.length,
                itemBuilder: (context, index) {
                  return LeaderboardItem(widget.user);
                });
          }),
    );
  }
}
