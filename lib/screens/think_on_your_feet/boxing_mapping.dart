import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:wombocombo/models/boxing_attack.dart';
import 'package:wombocombo/providers/boxing_attacks_list_provider.dart';
import 'package:wombocombo/screens/countdown_timer/set_timer_screen.dart';
import 'package:wombocombo/screens/think_on_your_feet/training_difficulty.dart';
import 'package:wombocombo/widgets/list_builders/attack_list_item.dart';

class BoxingMapping extends StatefulWidget {
  static const routeName = '/boxing-mapping';

  @override
  State<BoxingMapping> createState() => _BoxingMappingState();
}

class _BoxingMappingState extends State<BoxingMapping> {
  @override
  Widget build(BuildContext context) {
    final attacks =
        Provider.of<BoxingAttacksListProvider>(context, listen: false).attacks;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
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
          return AttackListItem(boxingAttack: attacks[index]);
        },
        itemCount: attacks.length,
      ),
    );
  }
}
