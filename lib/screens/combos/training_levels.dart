import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wombocombo/screens/combos/combos_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wombocombo/screens/home_screen.dart';

class TrainingLevel extends StatefulWidget {
  static const routeName = 'training-level';

  const TrainingLevel({Key? key}) : super(key: key);

  @override
  State<TrainingLevel> createState() => _TrainingLevelState();
}

var userId;

class _TrainingLevelState extends State<TrainingLevel> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero, () async {
      await getCurrentUserLevel();
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await getCurrentUserLevel();
    });
  }

  var currentUserData;
  var currentMaxLevel;
  getCurrentUserLevel() async {
    userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((value) {
      currentUserData = value;
    });
    setState(() {
      currentMaxLevel = currentUserData['currentMaxLevel'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        return false;
      },
      child: Scaffold(
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('combos')
              .orderBy('level')
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final comboDocs = snapshot.data!.docs as List;
            if (snapshot.hasData)
              return ListView.builder(
                itemCount: comboDocs.length,
                itemBuilder: (BuildContext context, int index) {
                  var currentLevel = comboDocs[index]['level'];
                  var combo = comboDocs[index]['name_numbers'];
                  var videoUrl = comboDocs[index]['video_url'];
                  var videoId = comboDocs[index].id;
                  if (currentMaxLevel - 1 >= index)
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      padding: EdgeInsets.all(10.0),
                      child: ListTile(
                        title: Text(
                          'Level $currentLevel',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '$combo',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(CombosScreen.routeName, arguments: [
                            currentLevel,
                            combo,
                            videoUrl,
                            videoId,
                            currentUserData.id
                          ]);
                        },
                      ),
                    );
                  else
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      padding: EdgeInsets.all(10.0),
                      child: ListTile(
                        title: Text(
                          'Level $currentLevel',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        subtitle: Text(
                          '$combo',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {},
                      ),
                    );
                },
              );
            else
              return Text('error');
          },
        ),
      ),
    );
  }
}
      //  Column(
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     GestureDetector(
      //       onTap: () => Navigator.of(context).pushNamed(CombosScreen.routeName,
      //           arguments: ['Level 1', 'assets/videos/movie_008.mp4']),
      //       child: Card(
      //         elevation: 5,
      //         child: Container(
      //           height: 100,
      //           width: double.infinity,
      //           alignment: Alignment.center,
      //           child: Text(
      //             'Level 1',
      //             style: Theme.of(context).textTheme.titleMedium,
      //           ),
      //         ),
      //       ),
      //     ),
      //     GestureDetector(
      //       onTap: () => Navigator.of(context).pushNamed(CombosScreen.routeName,
      //           arguments: ['Level 2', 'assets/videos/movie_005.mp4']),
      //       child: Card(
      //         elevation: 5,
      //         child: Container(
      //           alignment: Alignment.center,
      //           height: 100,
      //           width: double.infinity,
      //           child: Text(
      //             'Level 2',
      //             style: Theme.of(context).textTheme.titleMedium,
      //           ),
      //         ),
      //       ),
      //     ),
      //     GestureDetector(
      //       onTap: () => Navigator.of(context).pushNamed(CombosScreen.routeName,
      //           arguments: ['Level 3', 'assets/videos/movie_007.mp4']),
      //       child: Card(
      //         elevation: 5,
      //         child: Container(
      //           alignment: Alignment.center,
      //           height: 100,
      //           width: double.infinity,
      //           child: Text(
      //             'Level 3',
      //             style: Theme.of(context).textTheme.titleMedium,
      //           ),
      //         ),
      //       ),
      //     ),
      //     GestureDetector(
      //       onTap: () => Navigator.of(context).pushNamed(CombosScreen.routeName,
      //           arguments: ['Level 4', 'assets/videos/movie_002.mp4']),
      //       child: Card(
      //         elevation: 5,
      //         child: Container(
      //           alignment: Alignment.center,
      //           height: 100,
      //           width: double.infinity,
      //           child: Text(
      //             'Level 4',
      //             style: Theme.of(context).textTheme.titleMedium,
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
//     );
//   }
// }
