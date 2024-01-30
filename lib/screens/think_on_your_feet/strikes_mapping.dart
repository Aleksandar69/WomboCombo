import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:wombocombo/models/strike.dart';
import 'package:wombocombo/providers/auth_provider.dart';
import 'package:wombocombo/providers/user_provider.dart';
import 'package:wombocombo/screens/countdown_timer/set_timer_screen.dart';
import 'package:wombocombo/screens/think_on_your_feet/training_difficulty.dart';
import 'package:wombocombo/widgets/list_builders/attack_list_item.dart';
import './training_difficulty.dart';

class StrikesMapping extends StatefulWidget {
  static const routeName = '/boxing-mapping';

  @override
  State<StrikesMapping> createState() => _StrikesMappingState();
}

class _StrikesMappingState extends State<StrikesMapping> {
  late List<Strike> _boxingAttacks = [
    Strike('1', 'Jab', '1'),
    Strike('b1', 'Jab Body', 'b1'),
    Strike('2', 'Cross', '2'),
    Strike('b2', 'Cross Body', 'b2'),
    Strike('3', 'Left Hook', '3'),
    Strike('b3', 'Left Hook Body', 'b3'),
    Strike('4', 'Right Hook', '4'),
    Strike('b4', 'Right Hook Body', 'b4'),
    Strike('5', 'Left Uppercut', '5'),
    Strike('6', 'Right Uppercut', '6'),
  ];

  late List<Strike> _kickBoxingAttacks = [
    Strike('1', 'Jab', '1'),
    Strike('b1', 'Jab Body', 'b1'),
    Strike('2', 'Cross', '2'),
    Strike('b2', 'Cross Body', 'b2'),
    Strike('3', 'Left Hook', '3'),
    Strike('b3', 'Left Hook Body', 'b3'),
    Strike('4', 'Right Hook', '4'),
    Strike('b4', 'Right Hook Body', 'b4'),
    Strike('5', 'Left Uppercut', '5'),
    Strike('6', 'Right Uppercut', '6'),
    Strike('flk', 'Front Low Kick', 'Front Low Kick'),
    Strike('fmk', 'Front Middle Kick', 'Front Middle Kick'),
    Strike('fhk', 'Front High Kick', 'Front High Kick'),
    Strike('rhk', 'Rear Low Kick', 'Rear Low Kick'),
    Strike('rmk', 'Rear Middle Kick', 'Rear Middle Kick'),
    Strike('rhk', 'Rear High Kick', 'Rear High Kick'),
    Strike('ft', 'Front Teep', 'Front Teep'),
    Strike('rt', 'Rear Teep', 'Rear Teep'),
    Strike('fk', 'Front Knee', 'Front Knee'),
    Strike('rk', 'Rear Knee', 'Rear Knee')
  ];

  var currentlyChosenMartialArt;
  late final UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);
  late final AuthProvider authProvider =
      Provider.of<AuthProvider>(context, listen: false);
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var args = ModalRoute.of(context)!.settings.arguments as List;
    currentlyChosenMartialArt = args[0];
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  var user;

  void getUser() async {
    user = await userProvider.getUser(authProvider.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Strikes')),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        extendedPadding: EdgeInsets.all(25),
        elevation: 12,
        onPressed: () {
          Navigator.of(context).pushNamed(TrainingDiff.routeName, arguments: [
            currentlyChosenMartialArt,
            user['firstTimeChoosingDifficulty']
          ]);
        },
        label: const Text('Next'),
        icon: const Icon(Icons.play_arrow),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return currentlyChosenMartialArt == 'boxing'
              ? AttackListItem(strike: _boxingAttacks[index])
              : AttackListItem(strike: _kickBoxingAttacks[index]);
        },
        itemCount: currentlyChosenMartialArt == 'boxing'
            ? _boxingAttacks.length
            : _kickBoxingAttacks.length,
      ),
    );
  }
}
