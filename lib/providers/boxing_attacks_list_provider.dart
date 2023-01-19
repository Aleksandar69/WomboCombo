import 'package:flutter/material.dart.';
import 'package:wombocombo/models/boxing_attack.dart';
import '../helpers/db_helper.dart';

class BoxingAttacksListProvider with ChangeNotifier {
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
    BoxingAttack('right uppercut', 'assets/images/leftUppercutBody.png', '6b'),
    BoxingAttack('right uppercut', 'assets/images/leftUppercutBody.png', '9b'),
    BoxingAttack('right uppercut', 'assets/images/leftUppercutBody.png', '8b'),
    BoxingAttack('right uppercut', 'assets/images/leftUppercutBody.png', '7b'),
    BoxingAttack('right uppercut', 'assets/images/leftUppercutBody.png', '11b'),
    BoxingAttack('right uppercut', 'assets/images/leftUppercutBody.png', '12b'),
    BoxingAttack('right uppercut', 'assets/images/leftUppercutBody.png', '13b'),
  ];

  List<BoxingAttack> get attacks {
    print('getAttacks');
    return [..._attacks];
  }

  void initAttacks() {
    DBHelper.drop();
    _boxingAttacks.forEach(
      (attack) => DBHelper.insert(
        'boxing_attacks',
        {
          'attackName': attack.attackName,
          'attackImage': attack.attackImage,
          'correspondingNumber': attack.correspondingNumber
        },
      ),
    );
  }

  Future<void> fetchAttacks() async {
    final dataList = await DBHelper.getData('boxing_attacks');
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
