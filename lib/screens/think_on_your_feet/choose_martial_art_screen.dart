import 'package:flutter/material.dart.';
import 'package:provider/provider.dart';
import 'package:wombocombo/models/boxing_attack.dart';
import 'package:wombocombo/providers/boxing_attacks_list_provider.dart';
import 'package:wombocombo/screens/think_on_your_feet/boxing_mapping.dart';
import 'package:wombocombo/screens/think_on_your_feet/kickboxing_mapping.dart';
import 'package:wombocombo/screens/think_on_your_feet/muay_thai_mapping.dart';

class ChooseMartialArt extends StatelessWidget {
  static const routeName = '/choose-martialart';

  var _attacksBeginner = [
    '2 4 3',
    '1 2 3',
    '1 1 5',
    '1 1 2',
    '1 6 4',
  ];

  var _attacksIntermediate = [
    '2 4 3',
    '1 2 3 4',
    '1 1 5 6',
    '1 1 2',
    '1 6 4 3',
  ];

  var _attacksAdvanced = [
    '2 4 3 3',
    '1 2 3 4 1',
    '1 1 5 6 2 ',
    '1 1 2 3',
    '1 6 4 3 3'
  ];

  var _attacksNightmare = [
    '2 4 3 3 3',
    '1 2 3 4 1 2',
    '1 1 5 6 2 2',
    '1 1 2 3 1',
    '1 6 4 3 3 4'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('text'),
      ),
      body: Container(
          height: 600,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context)
                    .pushNamed(KickBoxingMapping.routeName),
                child: Container(
                  height: 100,
                  child: Card(
                    child: Center(
                      child: Text('Kickboxing'),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () =>
                    Navigator.of(context).pushNamed(BoxingMapping.routeName),
                child: Container(
                  height: 100,
                  child: Card(
                    child: Center(
                      child: Text('Boxing'),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () =>
                    Navigator.of(context).pushNamed(MuayThaiMapping.routeName),
                child: Container(
                  height: 100,
                  child: Card(
                    child: Center(
                      child: Text(
                        'Muay Thai',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
