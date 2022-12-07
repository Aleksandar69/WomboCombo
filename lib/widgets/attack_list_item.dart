import 'package:flutter/material.dart';
import 'package:wombocombo/models/boxing_attack.dart';

class AttackListItem extends StatelessWidget {
  AttackListItem({required this.boxingAttack});

  final BoxingAttack boxingAttack;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            child: Container(
              child: FittedBox(
                child: Text('\$${boxingAttack.attackImage}'),
              ),
            ),
          ),
          title: Row(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 50, right: 50),
                child: Text(
                  boxingAttack.attackName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Container(
                  alignment: Alignment.center, child: Icon(Icons.forward)),
            ],
          ),
          trailing: Container(
            padding: EdgeInsets.only(right: 50),
            child: Text(
              boxingAttack.correspondingNumber.toString(),
            ),
          )),
    );
  }
}
