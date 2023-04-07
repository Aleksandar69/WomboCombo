import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wombocombo/providers/auth_provider.dart';
import 'package:wombocombo/screens/home_screen.dart';
import 'package:wombocombo/screens/profile/profile_screen.dart';
import 'package:wombocombo/screens/profile/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainDrawer extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  void logOut() async {
    await _auth.signOut();
  }

  Widget buildListTile(String title, IconData icon, VoidCallback tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Friend!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          buildListTile('Menu', Icons.home, () {
            Navigator.of(context).pushNamed(HomeScreen.routeName);
          }),
          Divider(),
          buildListTile('Profile', Icons.person, () {
            Navigator.of(context).pushNamed(ProfileScreen.routeName);
          }),
          Divider(),
          buildListTile('Log Out', Icons.logout, () {
            logOut();
          }),
          Divider(),
        ],
      ),
    );
  }
}
