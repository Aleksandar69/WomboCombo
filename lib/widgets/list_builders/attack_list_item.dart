import 'package:flutter/material.dart';
import 'package:wombocombo/models/boxing_attack.dart';

class AttackListItem extends StatelessWidget {
  AttackListItem({required this.boxingAttack});

  final BoxingAttack boxingAttack;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 175,
              alignment: Alignment.center,
              child: Text(
                boxingAttack.attackName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Container(alignment: Alignment.center, child: Icon(Icons.forward)),
            Container(
              padding: EdgeInsets.only(right: 50),
              child: Text(
                boxingAttack.correspondingNumber.toString(),
              ),
            ),
            ElevatedButton(onPressed: () {}, child: Text("View"))
          ],
        ),
      ),
    );
  }
}
