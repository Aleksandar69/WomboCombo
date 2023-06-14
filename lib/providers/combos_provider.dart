import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../repositories/combos_repository.dart';

class CombosProvider with ChangeNotifier {
  CombosRepository combosRepository = CombosRepository();

  Stream<QuerySnapshot> getCombosStream() {
    return combosRepository.getCombosStream();
  }
}
