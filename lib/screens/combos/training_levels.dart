import 'package:flutter/material.dart';
import 'package:wombocombo/screens/combos/combos_screen.dart';
import 'package:wombocombo/screens/countdown_timer/set_timer_screen.dart';

class TrainingLevel extends StatelessWidget {
  static const routeName = 'training-level';

  const TrainingLevel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(CombosScreen.routeName,
                arguments: ['Level 1', 'assets/videos/movie_008.mp4']),
            child: Card(
              elevation: 5,
              child: Container(
                height: 100,
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  'Level 1',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(CombosScreen.routeName,
                arguments: ['Level 2', 'assets/videos/movie_005.mp4']),
            child: Card(
              elevation: 5,
              child: Container(
                alignment: Alignment.center,
                height: 100,
                width: double.infinity,
                child: Text(
                  'Level 2',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(CombosScreen.routeName,
                arguments: ['Level 3', 'assets/videos/movie_007.mp4']),
            child: Card(
              elevation: 5,
              child: Container(
                alignment: Alignment.center,
                height: 100,
                width: double.infinity,
                child: Text(
                  'Level 3',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(CombosScreen.routeName,
                arguments: ['Level 4', 'assets/videos/movie_002.mp4']),
            child: Card(
              elevation: 5,
              child: Container(
                alignment: Alignment.center,
                height: 100,
                width: double.infinity,
                child: Text(
                  'Level 4',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
