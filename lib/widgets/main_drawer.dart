import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wombocombo/providers/auth_provider.dart';
import 'package:wombocombo/providers/theme_provider.dart';
import 'package:wombocombo/screens/home_screen.dart';
import 'package:wombocombo/screens/profile/profile_screen.dart';

class MainDrawer extends StatelessWidget {
  final String currentUserId;
  MainDrawer(this.currentUserId);
  Widget buildListTile(
      String title, IconData icon, VoidCallback tapHandler, themeProvider) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
        color: themeProvider.darkTheme
            ? Colors.orange.shade400
            : Colors.orange.shade700,
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
    final themeProvider = Provider.of<ThemeProvider>(context);
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
          }, themeProvider),
          Divider(),
          buildListTile('Profile', Icons.person, () {
            Navigator.of(context)
                .pushNamed(ProfileScreen.routeName, arguments: [currentUserId]);
          }, themeProvider),
          Divider(),
          buildListTile('Log Out', Icons.logout, () {
            authProvider.logOut();
            //Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
          }, themeProvider),
          Divider(),
        ],
      ),
    );
  }
}
