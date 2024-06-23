import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:provider/provider.dart';
import 'package:wheel_chooser/wheel_chooser.dart';
import 'package:wombocombo/providers/auth_provider.dart';
import 'package:wombocombo/providers/combos_provider.dart';
import 'package:wombocombo/providers/dark_mode_notifier.dart';
import 'package:wombocombo/providers/theme_provider.dart';
import 'package:wombocombo/providers/user_provider.dart';
import 'countdown_timer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as r;
import 'package:just_audio/just_audio.dart';

class SetTimeScreen extends StatefulWidget {
  static const routeName = '/settimer';

  @override
  State<SetTimeScreen> createState() => _SetTimeScreenState();
}

class _SetTimeScreenState extends State<SetTimeScreen> {
  final _secondsController = FixedExtentScrollController(initialItem: 0);
  final _minutesController = FixedExtentScrollController(initialItem: 3);
  final _restControllerSec = FixedExtentScrollController(initialItem: 30);
  final _restControllerMin = FixedExtentScrollController(initialItem: 0);
  final _roundsController = FixedExtentScrollController(initialItem: 3);

  late final AuthProvider authProvider =
      Provider.of<AuthProvider>(context, listen: false);
  late final UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);
  final CombosProvider combosProvider = CombosProvider();
  var isLoading = false;

  var user;

  void getUser() async {
    user = await userProvider.getUser(authProvider.userId);
  }

  var currentCombosDifficulty;
  @override
  void initState() {
    super.initState();
    getUser();
  }

  var previousScreen;
  String difficultyLevel = 'none';
  late List customCombos = [];
  String selectedMartialArt = 'none';
  var oneStrikeComboB;
  var twoSrikesComboB;
  var threeStrikesComboB;
  var fourStrikesComboB;
  var fiveStrikesComboB;
  var sixStrikesComboB;
  var oneStrikeComboKb;
  var twoSrikesCombosKb;
  var threeStrikesCombosKb;
  var fourStrikesCombosKb;
  var fiveStrikesCombosKb;
  var sixStrikesCombosKb;
  var fourStrikesCombosKbWords;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      isLoading = true;
    });

    var previousArgs;
    if (ModalRoute.of(context)!.settings.arguments is List) {
      previousArgs = ModalRoute.of(context)!.settings.arguments as List;
    } else if (ModalRoute.of(context)!.settings.arguments is String) {
      previousArgs = ModalRoute.of(context)!.settings.arguments as String;
    }

    if (previousArgs is List) {
      previousScreen = previousArgs[0] as String;
      if (previousArgs.asMap().containsKey(2) && previousArgs[2] != null) {
        selectedMartialArt = previousArgs[2] as String;
      }
      if (previousScreen == 'fromQuickCombos') {
        difficultyLevel = previousArgs[1] as String;
      } else if (previousScreen == 'fromMakeYourComboScreen') {
        var combos = previousArgs[1] as List;
        customCombos = List.from(combos);
      }
    } else {
      previousScreen = previousArgs;
    }
    if (difficultyLevel != 'none') {
      currentCombosDifficulty = difficultyLevel.toLowerCase() +
          selectedMartialArt[0].toUpperCase() +
          selectedMartialArt.substring(1);
    }
    getCombosList();
  }

  getCombosList() async {
    oneStrikeComboB = await combosProvider.getCombo('oneStrikeBoxing');
    twoSrikesComboB = await combosProvider.getCombo('twoStrikesBoxing');
    threeStrikesComboB = await combosProvider.getCombo('threeStrikesBoxing');
    fourStrikesComboB = await combosProvider.getCombo('fourStirkesBoxing');
    fiveStrikesComboB = await combosProvider.getCombo('fiveStrikesBoxing');
    sixStrikesComboB = await combosProvider.getCombo('sixStrikesBoxing');
    oneStrikeComboKb = await combosProvider.getCombo('oneStrikeKb');
    twoSrikesCombosKb = await combosProvider.getCombo('twoStrikesKb');
    threeStrikesCombosKb = await combosProvider.getCombo('threeStrikesKb');
    fourStrikesCombosKb = await combosProvider.getCombo('fourStrikesKb');
    fiveStrikesCombosKb = await combosProvider.getCombo('fiveStrikesKb');
    sixStrikesCombosKb = await combosProvider.getCombo('sixStrikesKb');
    fourStrikesCombosKbWords =
        await combosProvider.getCombo('fourStrikesKbWords');
    setState(() {
      isLoading = false;
    });
  }

  var isFirstTimeShowcase;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Timer'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Center(
                  child: Text(
                    'Round duration:',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (previousScreen == 'fromQuickCombos')
                              AbsorbPointer(
                                absorbing: true,
                                child: WheelChooser.integer(
                                  selectTextStyle:
                                      TextStyle(color: Colors.grey),
                                  listWidth: 80,
                                  magnification: 2,
                                  onValueChanged: (i) => print(i),
                                  maxValue: 59,
                                  listHeight: 170,
                                  minValue: 0,
                                  step: 1,
                                  unSelectTextStyle:
                                      TextStyle(color: Colors.grey),
                                  controller: _minutesController,
                                ),
                              )
                            else
                              WheelChooser.integer(
                                listWidth: 80,
                                magnification: 2,
                                onValueChanged: (i) => print(i),
                                maxValue: 59,
                                listHeight: 170,
                                minValue: 0,
                                step: 1,
                                unSelectTextStyle:
                                    TextStyle(color: Colors.grey),
                                controller: _minutesController,
                              ),
                            Text(
                              'Min',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: previousScreen == 'fromQuickCombos'
                                      ? Colors.grey : Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (previousScreen == 'fromQuickCombos')
                              AbsorbPointer(
                                absorbing: true,
                                child: WheelChooser.integer(
                                  selectTextStyle:
                                      TextStyle(color: Colors.grey),
                                  listWidth: 80,
                                  magnification: 2,
                                  onValueChanged: (i) => print(i),
                                  maxValue: 59,
                                  listHeight: 170,
                                  minValue: 0,
                                  step: 1,
                                  unSelectTextStyle:
                                      TextStyle(color: Colors.grey),
                                  controller: _secondsController,
                                ),
                              )
                            else
                              WheelChooser.integer(
                                listWidth: 80,
                                magnification: 2,
                                onValueChanged: (i) => print(i),
                                maxValue: 59,
                                listHeight: 170,
                                minValue: 0,
                                step: 1,
                                unSelectTextStyle:
                                    TextStyle(color: Colors.grey),
                                controller: _secondsController,
                              ),
                            Text(
                              'Sec',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: previousScreen == 'fromQuickCombos'
                                      ? Colors.grey
                                      : Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Text(
                    'Rest duration:',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            WheelChooser.integer(
                              listWidth: 80,
                              magnification: 2,
                              onValueChanged: (i) => print(i),
                              maxValue: 20,
                              listHeight: 170,
                              minValue: 0,
                              step: 1,
                              unSelectTextStyle: TextStyle(color: Colors.grey),
                              controller: _restControllerMin,
                            ),
                            Text(
                              'Min',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            WheelChooser.integer(
                              listWidth: 80,
                              magnification: 2,
                              onValueChanged: (i) => print(i),
                              maxValue: 99,
                              listHeight: 170,
                              minValue: 0,
                              step: 1,
                              unSelectTextStyle: TextStyle(color: Colors.grey),
                              controller: _restControllerSec,
                            ),
                            Text(
                              'Sec',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        WheelChooser.integer(
                          listWidth: 80,
                          magnification: 2,
                          onValueChanged: (i) => print(i),
                          maxValue: 99,
                          listHeight: 170,
                          minValue: 1,
                          step: 1,
                          unSelectTextStyle: TextStyle(color: Colors.grey),
                          controller: _roundsController,
                        ),
                        Text(
                          'Rounds',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                r.Consumer(builder: (context, ref, child) {
                  var darkMode = ref.watch(darkModeProvider);
                  return RawMaterialButton(
                    onPressed: () {
                      if (_minutesController.selectedItem <= 0 &&
                          _secondsController.selectedItem < 15) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'A round must be at least 15 seconds long'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      if (_restControllerMin.selectedItem <= 0 &&
                          _restControllerSec.selectedItem < 5) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Rest timer must be at least 5 seconds long'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      if (isFirstTimeShowcase == null) {
                        Navigator.of(context)
                            .pushNamed(CountdownTimer.routeName, arguments: [
                          _minutesController.selectedItem,
                          _secondsController.selectedItem,
                          _restControllerMin.selectedItem,
                          _restControllerSec.selectedItem,
                          _roundsController.selectedItem,
                          previousScreen,
                          difficultyLevel,
                          customCombos,
                          selectedMartialArt,
                          user['firstTimeThinkQuick'],
                          oneStrikeComboB,
                          twoSrikesComboB,
                          threeStrikesComboB,
                          fourStrikesComboB,
                          fiveStrikesComboB,
                          sixStrikesComboB,
                          oneStrikeComboKb,
                          twoSrikesCombosKb,
                          threeStrikesCombosKb,
                          fourStrikesCombosKb,
                          fiveStrikesCombosKb,
                          sixStrikesCombosKb,
                          fourStrikesCombosKbWords
                        ]);
                      } else {
                        Navigator.of(context)
                            .pushNamed(CountdownTimer.routeName, arguments: [
                          _minutesController.selectedItem,
                          _secondsController.selectedItem,
                          _restControllerMin.selectedItem,
                          _restControllerSec.selectedItem,
                          _roundsController.selectedItem,
                          previousScreen,
                          difficultyLevel,
                          customCombos,
                          selectedMartialArt,
                          isFirstTimeShowcase,
                          oneStrikeComboB,
                          twoSrikesComboB,
                          threeStrikesComboB,
                          fourStrikesComboB,
                          fiveStrikesComboB,
                          sixStrikesComboB,
                          oneStrikeComboKb,
                          twoSrikesCombosKb,
                          threeStrikesCombosKb,
                          fourStrikesCombosKb,
                          fiveStrikesCombosKb,
                          sixStrikesCombosKb,
                          fourStrikesCombosKbWords
                        ]);
                      }

                      setState(() {
                        isFirstTimeShowcase = false;
                      });
                    },
                    elevation: 2.0,
                    fillColor: darkMode
                        ? Color.fromARGB(255, 71, 162, 159)
                        : Color.fromARGB(255, 36, 89, 188),
                    textStyle: TextStyle(color: Colors.white),
                    child: Icon(
                      Icons.play_arrow,
                      size: 70.0,
                    ),
                    padding: EdgeInsets.all(10.0),
                    shape: CircleBorder(),
                  );
                }),
                SizedBox(
                  height: 8,
                )
              ],
            ),
    );
  }
}
