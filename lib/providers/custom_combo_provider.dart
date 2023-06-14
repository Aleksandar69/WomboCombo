import 'package:flutter/material.dart.';
import 'package:wombocombo/models/custom_combo.dart';
import '../helpers/custom_combo_db_helper.dart';
import '../repositories/custom_combo_repository.dart';

class CustomComboProvider with ChangeNotifier {
  CustomComboRepository comboRepository = CustomComboRepository();
  List<CustomCombo> _combos = [];

  List<CustomCombo> get combos {
    return [..._combos];
  }

  void addCombo(customCombo) {
    comboRepository.addCombo(customCombo);
    notifyListeners();
  }

  Future<void> dropTable() async {
    await comboRepository.dropTable();
  }

  Future<void> fetchAttacks() async {
    final dataList = await comboRepository.fetchAttacks();

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
