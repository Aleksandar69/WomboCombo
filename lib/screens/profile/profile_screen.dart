import 'package:flutter/material.dart';
import 'package:wombocombo/screens/profile/edit_profile_screen.dart';
import 'package:wombocombo/screens/profile/videos/saved_videos.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
            ),
            SizedBox(height: 10),
            Text(
              'alestoj',
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              icon: Icon(Icons.edit),
              onPressed: () =>
                  Navigator.of(context).pushNamed(EditProfileScreen.routeName),
              label: Text('Edit Profile'),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      'Earned Points',
                      style: TextStyle(
                        fontSize: 27,
                      ),
                    ),
                    Text('5',
                        style: TextStyle(
                          fontSize: 27,
                        )),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    Text('Highest streak', style: TextStyle(fontSize: 27)),
                    Text('5',
                        style: TextStyle(
                          fontSize: 27,
                        )),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 100,
            ),
            Container(
              width: double.infinity,
              height: 70,
              child: Card(
                child: Text(
                  'My combos',
                  style: TextStyle(fontSize: 35),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              child: Container(
                height: 80,
                width: double.infinity,
                child: Card(
                  child: Text(
                    'My videos',
                    style: TextStyle(fontSize: 35),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              onTap: () =>
                  Navigator.of(context).pushNamed(SavedVideos.routeName),
            ),
          ],
        ),
      ),
    );
  }
}
