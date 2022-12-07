import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:wombocombo/models/boxing_attack.dart';
import 'package:wombocombo/providers/boxing_attacks_provider.dart';
import 'package:wombocombo/widgets/list_builders/attack_list_item_row.dart';

class BoxingMapping extends StatefulWidget {
  static const routeName = '/boxing-mapping';

  @override
  State<BoxingMapping> createState() => _BoxingMappingState();
}

class _BoxingMappingState extends State<BoxingMapping> {
  // final List<BoxingAttack> boxingAttacks = [
  @override
  Widget build(BuildContext context) {
    final attacks =
        Provider.of<BoxingAttacksProvider>(context, listen: false).attacks;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        extendedPadding: EdgeInsets.all(100),
        elevation: 12,
        onPressed: () {
          
        },
        label: const Text('Start'),
        icon: const Icon(Icons.play_arrow),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return AttackListItemRow(boxingAttack: attacks[index]);
        },
        itemCount: attacks.length,
      ),
    );
  }
}
