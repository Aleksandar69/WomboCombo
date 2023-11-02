import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:wombocombo/screens/combos/combos_screen.dart';
import 'package:wombocombo/screens/combos/training_levels.dart';

class ChooseMartialArtCombos extends StatelessWidget {
  static const routeName = '/choosemartialart';
  const ChooseMartialArtCombos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Martial Art')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context)
                .pushNamed(TrainingLevel.routeName, arguments: ['boxing']),
            child: Card(
              elevation: 5,
              child: Container(
                decoration: BoxDecoration(color: Colors.blue.shade900),
                height: 100,
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  'Boxing',
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
                .pushNamed(TrainingLevel.routeName, arguments: ['kickboxing']),
            child: Card(
              elevation: 5,
              child: Container(
                decoration: BoxDecoration(color: Colors.blue.shade900),
                alignment: Alignment.center,
                height: 100,
                width: double.infinity,
                child: Text(
                  'Kickboxing',
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
