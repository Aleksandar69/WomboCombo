import 'package:flutter/material.dart';
import 'package:wombocombo/models/user.dart';

class LeaderboardItem extends StatelessWidget {
  var userName;
  int userPoints;
  var imgUrl;

  LeaderboardItem(this.userName, this.userPoints, this.imgUrl);

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
          userName,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(userPoints.toString()),
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
