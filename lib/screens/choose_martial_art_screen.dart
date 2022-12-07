import 'package:flutter/material.dart.';
import 'package:provider/provider.dart';
import 'package:wombocombo/models/boxing_attack.dart';
import 'package:wombocombo/providers/boxing_attacks_provider.dart';
import 'package:wombocombo/screens/martial_art_attack_mapping/boxing_mapping.dart';
import 'package:wombocombo/screens/martial_art_attack_mapping/kickboxing_mapping.dart';
import 'package:wombocombo/screens/martial_art_attack_mapping/muay_thai_mapping.dart';

class ChooseMartialArt extends StatelessWidget {
  static const routeName = '/choose-martialart';

  @override
  Widget build(BuildContext context) {
    Provider.of<BoxingAttacksProvider>(context, listen: false).initAttacks();
    Provider.of<BoxingAttacksProvider>(context, listen: false).fetchAttacks();
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
