import 'package:flutter/material.dart';

import '../repositories/strikes_repo.dart';

class StrikesProvider with ChangeNotifier {
  getStrike(arg1) async {
    return await StrikesRepository().getStrike(arg1);
  }
}
