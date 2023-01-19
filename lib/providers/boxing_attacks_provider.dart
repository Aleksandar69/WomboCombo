import 'package:flutter/material.dart.';

class BoxingAttacksProvider with ChangeNotifier {
  var _attacksBeginner = [
    '2 4 3',
    '1 2 3',
    '1 1 5',
    '1 1 2',
    '1 6 4',
  ];

  var _attacksIntermediate = [
    '2 4 3',
    '1 2 3 4',
    '1 1 5 6',
    '1 1 2',
    '1 6 4 3',
  ];

  var _attacksAdvanced = [
    '2 4 3 3',
    '1 2 3 4 1',
    '1 1 5 6 2 ',
    '1 1 2 3',
    '1 6 4 3 3'
  ];

  var _attacksNightmare = [
    '2 4 3 3 3',
    '1 2 3 4 1 2',
    '1 1 5 6 2 2',
    '1 1 2 3 1',
    '1 6 4 3 3 4'
  ];

  List<String> get begginerAttacks {
    print('getAttacks');
    return [..._attacksBeginner];
  }

  List<String> get intermediateAttacks {
    print('getAttacks');
    return [..._attacksIntermediate];
  }

  List<String> get advancedAttacks {
    print('getAttacks');
    return [..._attacksAdvanced];
  }

  List<String> get nightmareAttacks {
    print('getAttacks');
    return [..._attacksNightmare];
  }

}
