import 'package:flutter/material.dart.';
import 'package:wombocombo/models/custom_combo.dart';
import '../helpers/custom_combo_db_helper.dart';

class CustomComboProvider with ChangeNotifier {
  List<CustomCombo> _combos = [];

  List<CustomCombo> get combos {
    return [..._combos];
  }

  void addCombo(customCombo) {
    CustomComboDBhelper.insert(
      'custom_combos',
      {
        'comboName': customCombo.comboName,
        'attacks': customCombo.attacks,
      },
    );
    notifyListeners();
  }

  Future<void> dropTable() async {
    await CustomComboDBhelper.drop();
  }

  Future<void> fetchAttacks() async {
    final dataList = await CustomComboDBhelper.getData('custom_combos');
    _combos = dataList
        .map(
          (attack) => CustomCombo(
            attack['comboName'],
            attack['attacks'],
          ),
        )
        .toList();
    notifyListeners();
  }
}
