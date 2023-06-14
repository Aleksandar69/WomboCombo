import 'package:flutter/material.dart.';
import '../repositories/boxing_attacks_repository.dart';

class BoxingAttacksProvider with ChangeNotifier {
  BoxingAttacksRepo boxingAttacksRepo = BoxingAttacksRepo();

  List<String> get begginerAttacks {
    return boxingAttacksRepo.begginerAttacks;
  }

  List<String> get intermediateAttacks {
    return boxingAttacksRepo.intermediateAttacks;
  }

  List<String> get advancedAttacks {
    return boxingAttacksRepo.advancedAttacks;
  }

  List<String> get nightmareAttacks {
    return boxingAttacksRepo.nightmareAttacks;
  }
}
