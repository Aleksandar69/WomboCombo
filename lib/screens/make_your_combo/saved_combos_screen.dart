import 'package:flutter/material.dart.';
import 'package:provider/provider.dart';
import 'package:wombocombo/models/custom_combo.dart';
import 'package:wombocombo/providers/custom_combo_provider.dart';
import '../../widgets/list_builders/custom_combo_item.dart';

class SavedCombos extends StatelessWidget {
  var customComboProvider;
  static const routeName = '/savedCombos';

  @override
  Widget build(BuildContext context) {
    Provider.of<CustomComboProvider>(context, listen: false).fetchAttacks();
    var customComboProvider =
        Provider.of<CustomComboProvider>(context, listen: true);
    List combos = customComboProvider.combos;

    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Combos'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return CustomComboListItem(combos[index]);
        },
        itemCount: combos.length,
      ),
    );
  }
}
