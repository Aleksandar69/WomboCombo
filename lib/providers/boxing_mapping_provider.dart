import 'package:flutter/material.dart.';
import 'package:wombocombo/models/boxing_attack.dart';
import '../helpers/boxing_db_helper.dart';
import 'package:wombocombo/repositories/boxing_mapping_repository.dart';

class BoxingMappingProvider with ChangeNotifier {
  BoxingMappingProvider boxingMappingProvider = BoxingMappingProvider();
  List<BoxingAttack> _attacks = [];

  late List<BoxingAttack> _boxingAttacks = [
    BoxingAttack('jab', 'assets/images/jab.png', '1'),
    BoxingAttack('jab body', 'assets/images/jabBody.png', '1b'),
    BoxingAttack('cross', 'assets/images/cross.png', '2'),
    BoxingAttack('cross body', 'assets/images/crossBody.png', '2b'),
    BoxingAttack('left hook', 'assets/images/leftHook.png', '3'),
    BoxingAttack('left hook body', 'assets/images/leftUppercutBody.png', '3b'),
    BoxingAttack('right hook', 'assets/images/rightHook.png', '4'),
    BoxingAttack(
        'right hook body', 'assets/images/rightUppercutBody.png', '4b'),
    BoxingAttack('left uppercut', 'assets/images/leftupperreal.png', '5'),
    BoxingAttack(
        'left uppercut body', 'assets/images/leftUppercutBody.png', '5b'),
    BoxingAttack('right uppercut', 'assets/images/leftUppercutBody.png', '6'),
  ];

  List<BoxingAttack> get attacks {
    return [..._attacks];
  }

  void initAttacks() {
    boxingMappingProvider.initAttacks();
  }

  fetchAttacks() async {
    final dataList = await boxingMappingProvider.fetchAttacks();
    _attacks = dataList
        .map(
          (attack) => BoxingAttack(
            attack['attackName'],
            attack['attackImage'],
            attack['correspondingNumber'],
          ),
        )
        .toList();
    notifyListeners();
  }
}
