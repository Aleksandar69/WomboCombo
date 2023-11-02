import 'package:cloud_firestore/cloud_firestore.dart';

class CombosRepository {
  Stream<QuerySnapshot> getBoxingCombosStream() {
    return FirebaseFirestore.instance
        .collection('combos')
        .orderBy('level')
        .snapshots();
  }

  Stream<QuerySnapshot> getKickboxingCombosStream() {
    return FirebaseFirestore.instance
        .collection('cobmoskb')
        .orderBy('level')
        .snapshots();
  }
}
