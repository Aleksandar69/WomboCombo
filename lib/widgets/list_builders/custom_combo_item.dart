import 'package:flutter/material.dart';
import 'package:wombocombo/models/boxing_attack.dart';
import 'package:wombocombo/screens/make_your_combo/make_your_combo_screen.dart';
import '../../models/custom_combo.dart';

class CustomComboListItem extends StatelessWidget {
  CustomComboListItem(this.customCombo);

  late CustomCombo customCombo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed(MakeYourComboScreen.routeName, arguments: customCombo),
      child: Card(
        elevation: 5,
        child: Container(
          width: 175,
          height: 50,
          alignment: Alignment.center,
          child: Text(
            customCombo.comboName,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}
