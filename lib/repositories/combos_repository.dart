import 'package:cloud_firestore/cloud_firestore.dart';

class CombosRepository {
  Stream<QuerySnapshot> getCombosStream() {
    return FirebaseFirestore.instance
        .collection('combos')
        .orderBy('level')
        .snapshots();
  }
}
