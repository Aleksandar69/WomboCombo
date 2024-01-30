import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../repositories/combos_repository.dart';

class CombosProvider with ChangeNotifier {
  CombosRepository combosRepository = CombosRepository();

  Stream<QuerySnapshot> getBoxingCombosStream() {
    return combosRepository.getBoxingCombosStream();
  }

  Stream<QuerySnapshot> getKickboxingCombosStream() {
    return combosRepository.getKickboxingCombosStream();
  }

  getCombo(combos) {
    return combosRepository.getCombo(combos);
  }

  getOneStrikeCombos() async {
    return combosRepository.getOneStrikeCombos();
  }
}
