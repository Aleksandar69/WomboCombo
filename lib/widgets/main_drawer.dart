import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wombocombo/providers/auth_provider.dart';
import 'package:wombocombo/providers/dark_mode_notifier.dart';
import 'package:wombocombo/screens/auth/auth_screen.dart';
import 'package:wombocombo/screens/home_screen.dart';
import 'package:wombocombo/screens/profile/profile_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as r;

class MainDrawer extends StatelessWidget {
  final String currentUserId;
  MainDrawer(this.currentUserId);
  Widget buildListTile(String title, IconData icon, VoidCallback tapHandler) {
    return r.Consumer(
      builder: (context, ref, child) {
        var darkMode = ref.watch(darkModeProvider);

        return ListTile(
          leading: Icon(
            icon,
            size: 26,
            color: darkMode ? Colors.orange.shade400 : Colors.orange.shade700,
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    late final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('WomboCombo'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          buildListTile('Menu', Icons.home, () {
            Navigator.of(context).pushNamed(HomeScreen.routeName);
          }),
          Divider(),
          buildListTile('Profile', Icons.person, () {
            Navigator.of(context)
                .pushNamed(ProfileScreen.routeName, arguments: [currentUserId]);
          }),
          Divider(),
          buildListTile('Log Out', Icons.logout, () {
            authProvider.logOut();
            Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
          }),
          Divider(),
        ],
      ),
    );
  }
}
