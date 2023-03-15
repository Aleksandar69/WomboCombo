import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wombocombo/providers/auth_provider.dart';

class MainDrawer extends StatelessWidget {
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
            Navigator.of(context).pushReplacementNamed('/home-screen');
          }),
          Divider(),
          buildListTile('Profile', Icons.person, () {
            Navigator.of(context).pushReplacementNamed('/profile');
          }),
          Divider(),
          buildListTile('Log Out', Icons.logout, () {
            Provider.of<AuthProvider>(context, listen: false).logOut();
          }),
          Divider(),
        ],
      ),
    );
  }
}
