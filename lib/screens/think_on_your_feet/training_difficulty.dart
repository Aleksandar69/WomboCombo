import 'package:flutter/material.dart';
import 'package:wombocombo/screens/countdown_timer/set_timer_screen.dart';

class TrainingDiff extends StatelessWidget {
  static const routeName = 'training-diff';

  const TrainingDiff({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Difficulty')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
                SetTimeScreen.routeName,
                arguments: ['fromQuickCombos', 'Beginner']),
            child: Card(
              elevation: 5,
              child: Container(
                decoration: BoxDecoration(color: Color(0xff90E0EF)),
                height: 100,
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  'Beginner',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
                SetTimeScreen.routeName,
                arguments: ['fromQuickCombos', 'Intermediate']),
            child: Card(
              elevation: 5,
              child: Container(
                decoration: BoxDecoration(color: Color(0xff00B4D8)),
                alignment: Alignment.center,
                height: 100,
                width: double.infinity,
                child: Text(
                  'Intermediate',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
                SetTimeScreen.routeName,
                arguments: ['fromQuickCombos', 'Advanced']),
            child: Card(
              elevation: 5,
              child: Container(
                decoration: BoxDecoration(color: Color(0xff0077B6)),
                alignment: Alignment.center,
                height: 100,
                width: double.infinity,
                child: Text(
                  'Advanced',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
                SetTimeScreen.routeName,
                arguments: ['fromQuickCombos', 'Nightmare']),
            child: Card(
              elevation: 5,
              child: Container(
                decoration: BoxDecoration(color: Color(0xff023E8A)),
                alignment: Alignment.center,
                height: 100,
                width: double.infinity,
                child: Text(
                  'Nightmare',
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
