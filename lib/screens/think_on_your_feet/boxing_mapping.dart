import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:wombocombo/models/boxing_attack.dart';
import 'package:wombocombo/providers/boxing_mapping_provider.dart';
import 'package:wombocombo/screens/countdown_timer/set_timer_screen.dart';
import 'package:wombocombo/screens/think_on_your_feet/training_difficulty.dart';
import 'package:wombocombo/widgets/list_builders/attack_list_item.dart';
import './training_difficulty.dart';

class BoxingMapping extends StatefulWidget {
  static const routeName = '/boxing-mapping';

  @override
  State<BoxingMapping> createState() => _BoxingMappingState();
}

class _BoxingMappingState extends State<BoxingMapping> {
  late List<BoxingAttack> _boxingAttacks = [
    BoxingAttack('jab', 'assets/images/jab.png', '1'),
    BoxingAttack('jab body', 'assets/images/jabBody.png', 'b1'),
    BoxingAttack('cross', 'assets/images/cross.png', '2'),
    BoxingAttack('cross body', 'assets/images/crossBody.png', 'b2'),
    BoxingAttack('left hook', 'assets/images/leftHook.png', '3'),
    BoxingAttack('left hook body', 'assets/images/leftUppercutBody.png', 'b3'),
    BoxingAttack('right hook', 'assets/images/rightHook.png', '4'),
    BoxingAttack(
        'right hook body', 'assets/images/rightUppercutBody.png', 'b4'),
    BoxingAttack('left uppercut', 'assets/images/leftupperreal.png', '5'),
    BoxingAttack(
        'left uppercut body', 'assets/images/leftUppercutBody.png', 'b5'),
    BoxingAttack('right uppercut', 'assets/images/leftUppercutBody.png', '6'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Punches mapping')),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        extendedPadding: EdgeInsets.all(25),
        elevation: 12,
        onPressed: () {
          Navigator.of(context).pushNamed(TrainingDiff.routeName);
        },
        label: const Text('Next'),
        icon: const Icon(Icons.play_arrow),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return AttackListItem(boxingAttack: _boxingAttacks[index]);
        },
        itemCount: _boxingAttacks.length,
      ),
    );
  }
}
