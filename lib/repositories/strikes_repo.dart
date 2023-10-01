import 'package:cloud_firestore/cloud_firestore.dart';

class StrikesRepository {
  getStrike(arg1) async {
    var fetchedStrike;
    await FirebaseFirestore.instance
        .collection('strikes')
        .doc(arg1)
        .get()
        .then((value) {
      fetchedStrike = value;
    });
    return fetchedStrike;
  }
}
