import 'package:wombocombo/models/boxing_attack.dart';
import '../helpers/boxing_db_helper.dart';

class BoxingMappingRepo {
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

  void initAttacks() {
    BoxingDBHelper.drop();
    _boxingAttacks.forEach(
      (attack) => BoxingDBHelper.insert(
        'boxing_attacks',
        {
          'attackName': attack.attackName,
          'attackImage': attack.attackImage,
          'correspondingNumber': attack.correspondingNumber
        },
      ),
    );
  }

  fetchAttacks() async {
    return await BoxingDBHelper.getData('boxing_attacks');
  }
}
