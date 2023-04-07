import 'package:flutter/material.dart';
import 'package:wombocombo/models/user.dart';

class LeaderboardItem extends StatelessWidget {
  User user;

  LeaderboardItem(this.user);

  @override
  Widget build(BuildContext context) {
    return Card(
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
          'Steve-o',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text('355 points'),
        trailing: MediaQuery.of(context).size.width > 360
            ? TextButton.icon(
                label: Text('Add Friend'),
                onPressed: () {},
                icon: Icon(Icons.add),
              )
            : IconButton(
                icon: Icon(Icons.add),
                color: Theme.of(context).errorColor,
                onPressed: () {},
              ),
      ),
    );
  }
}
