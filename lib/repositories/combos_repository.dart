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

  getCombo(combos) async {
    var fetchedCombos;
    await FirebaseFirestore.instance
        .collection('thinkQuickCombos')
        .doc(combos)
        .get()
        .then((value) {
      fetchedCombos = value;
    });
    return fetchedCombos;
  }

  getOneStrikeCombos() async {
    var fetchedCombos;
    await FirebaseFirestore.instance
        .collection('thinkQuickCombos')
        .doc("warmupBoxing1")
        .get()
        .then((value) {
      fetchedCombos = value;
    });
    return fetchedCombos;
  }
}
