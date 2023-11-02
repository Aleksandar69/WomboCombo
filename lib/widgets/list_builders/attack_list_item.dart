import 'package:flutter/material.dart';
import 'package:wombocombo/models/strike.dart';
import '../../screens/think_on_your_feet/strike_animation.dart';

class AttackListItem extends StatelessWidget {
  AttackListItem({required this.strike});

  final Strike strike;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 5,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                alignment: Alignment.center,
                child: Text(
                  strike.attackName,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  alignment: Alignment.center,
                  child: Icon(Icons.forward)),
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(right: 15),
                child: Text(
                  strike.correspondingNumber,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(StrikeAnimation.routeName,
                          arguments: strike.id);
                    },
                    child: Text("View")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
