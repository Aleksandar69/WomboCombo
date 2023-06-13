import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CombosProvider with ChangeNotifier {
  Stream<QuerySnapshot> getCombosStream() {
    return FirebaseFirestore.instance
        .collection('combos')
        .orderBy('level')
        .snapshots();
  }
}
