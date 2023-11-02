import 'package:flutter/material.dart';
import 'package:wombocombo/screens/countdown_timer/set_timer_screen.dart';

class TrainingDiff extends StatefulWidget {
  static const routeName = 'training-diff';

  const TrainingDiff({Key? key}) : super(key: key);

  @override
  State<TrainingDiff> createState() => _TrainingDiffState();
}

class _TrainingDiffState extends State<TrainingDiff> {
  var selectedMartialArt;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var args = ModalRoute.of(context)!.settings.arguments as List;
    selectedMartialArt = args[0];
  }

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
                arguments: ['fromQuickCombos', 'Beginner', selectedMartialArt]),
            child: Card(
              elevation: 5,
              child: Container(
                decoration:
                    BoxDecoration(color: Color.fromARGB(255, 116, 213, 228)),
                height: 100,
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  'Beginner',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context)
                .pushNamed(SetTimeScreen.routeName, arguments: [
              'fromQuickCombos',
              'Intermediate',
              selectedMartialArt
            ]),
            child: Card(
              elevation: 5,
              child: Container(
                decoration: BoxDecoration(color: Color(0xff00B4D8)),
                alignment: Alignment.center,
                height: 100,
                width: double.infinity,
                child: Text(
                  'Intermediate',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
                SetTimeScreen.routeName,
                arguments: ['fromQuickCombos', 'Advanced', selectedMartialArt]),
            child: Card(
              elevation: 5,
              child: Container(
                decoration: BoxDecoration(color: Color(0xff0077B6)),
                alignment: Alignment.center,
                height: 100,
                width: double.infinity,
                child: Text(
                  'Advanced',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context)
                .pushNamed(SetTimeScreen.routeName, arguments: [
              'fromQuickCombos',
              'Nightmare',
              selectedMartialArt
            ]),
            child: Card(
              elevation: 5,
              child: Container(
                decoration: BoxDecoration(color: Color(0xff023E8A)),
                alignment: Alignment.center,
                height: 100,
                width: double.infinity,
                child: Text(
                  'Nightmare',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
