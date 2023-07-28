import 'package:flutter/material.dart';

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool hasNavigation;
  final bool isFriendAdded;

  const ProfileListItem({
    required this.icon,
    required this.text,
    this.hasNavigation = true,
    this.isFriendAdded = false,
  });

  @override
  Widget build(BuildContext context) {
    return !isFriendAdded
        ? Container(
            height: 55,
            margin: EdgeInsets.symmetric(
              horizontal: 10,
            ).copyWith(
              bottom: 20,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey.shade300,
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  this.icon,
                  size: 25,
                ),
                SizedBox(width: 15),
                Text(this.text, style: TextStyle(color: Colors.black)),
                Spacer(),
                if (this.hasNavigation)
                  Icon(
                    Icons.arrow_right,
                    size: 25,
                  ),
              ],
            ),
          )
        : Container(
            height: 55,
            margin: EdgeInsets.symmetric(
              horizontal: 10,
            ).copyWith(
              bottom: 20,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey.shade100,
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  this.icon,
                  size: 25,
                  color: Colors.grey.shade300,
                ),
                SizedBox(width: 15),
                Text(
                  this.text,
                  style: TextStyle(color: Colors.grey.shade300),
                ),
                Spacer(),
                if (this.hasNavigation)
                  Icon(
                    Icons.arrow_right,
                    size: 25,
                    color: Colors.grey.shade300,
                  ),
              ],
            ),
          );
  }
}
