import 'package:flutter/material.dart.';
import 'package:wombocombo/models/custom_combo.dart';
import '../helpers/custom_combo_db_helper.dart';

class CustomComboRepository {
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
  }

  Future<void> dropTable() async {
    await CustomComboDBhelper.drop();
  }

  fetchAttacks() async {
    return await CustomComboDBhelper.getData('custom_combos');
  }
}
