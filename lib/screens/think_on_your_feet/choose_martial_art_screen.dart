import 'package:flutter/material.dart.';
import 'package:provider/provider.dart';
import 'package:wombocombo/models/strike.dart';
import 'package:wombocombo/screens/think_on_your_feet/strikes_mapping.dart';
import '../../widgets/testwidget.dart';

class ChooseMartialArt extends StatelessWidget {
  static const routeName = '/choose-martialart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Martial Art'),
      ),
      //body: OverLayIssue(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context)
                .pushNamed(StrikesMapping.routeName, arguments: ['boxing']),
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
                .pushNamed(StrikesMapping.routeName, arguments: ['kickboxing']),
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
