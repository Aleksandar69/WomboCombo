import 'package:flutter/material.dart';
import 'package:wheel_chooser/wheel_chooser.dart';
import './timer_new.dart';

class SetTimeScreen extends StatefulWidget {
  static const routeName = '/settimer';

  @override
  State<SetTimeScreen> createState() => _SetTimeScreenState();
}

class _SetTimeScreenState extends State<SetTimeScreen> {
  final _secondsController = FixedExtentScrollController(initialItem: 0);
  final _minutesController = FixedExtentScrollController(initialItem: 1);
  final _restControllerSec = FixedExtentScrollController(initialItem: 30);
  final _restControllerMin = FixedExtentScrollController(initialItem: 0);
  final _roundsController = FixedExtentScrollController(initialItem: 3);

  late final previousScreen;
  late String difficultyLevel = 'Beginner';
  late List customCombos = [];

  @override
  void didChangeDependencies() {
    var previousArgs;
    if (ModalRoute.of(context)!.settings.arguments is List) {
      previousArgs = ModalRoute.of(context)!.settings.arguments as List;
    } else if (ModalRoute.of(context)!.settings.arguments is String) {
      previousArgs = ModalRoute.of(context)!.settings.arguments as String;
    }

    if (previousArgs is List) {
      previousScreen = previousArgs[0] as String;
      if (previousScreen == 'fromQuickCombos') {
        difficultyLevel = previousArgs[1] as String;
      } else if (previousScreen == 'fromMakeYourComboScreen') {
        var combos = previousArgs[1] as List;
        customCombos = List.from(combos);
        for (var combo in customCombos) {}
      }
    } else {
      previousScreen = previousArgs;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text(
              'Round duration:',
              style: TextStyle(fontSize: 25),
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
                        maxValue: 59,
                        listHeight: 200,
                        minValue: 0,
                        step: 1,
                        unSelectTextStyle: TextStyle(color: Colors.grey),
                        controller: _minutesController,
                      ),
                      Text('Min'),
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
                        maxValue: 59,
                        listHeight: 200,
                        minValue: 0,
                        step: 1,
                        unSelectTextStyle: TextStyle(color: Colors.grey),
                        controller: _secondsController,
                      ),
                      Text('Sec'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: Text(
              'Rest duration:',
              style: TextStyle(fontSize: 25),
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
                        listHeight: 200,
                        minValue: 0,
                        step: 1,
                        unSelectTextStyle: TextStyle(color: Colors.grey),
                        controller: _restControllerMin,
                      ),
                      Text('Min'),
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
                        listHeight: 200,
                        minValue: 0,
                        step: 1,
                        unSelectTextStyle: TextStyle(color: Colors.grey),
                        controller: _restControllerSec,
                      ),
                      Text('Sec'),
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
                    listHeight: 200,
                    minValue: 0,
                    step: 1,
                    unSelectTextStyle: TextStyle(color: Colors.grey),
                    controller: _roundsController,
                  ),
                  Text('Rounds'),
                ],
              ),
            ),
          ),
          RawMaterialButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(TimerNew.routeName, arguments: [
              _minutesController.selectedItem,
              _secondsController.selectedItem,
              _restControllerMin.selectedItem,
              _restControllerSec.selectedItem,
              _roundsController.selectedItem,
              previousScreen,
              difficultyLevel,
              customCombos
            ]),
            elevation: 2.0,
            fillColor: Colors.white,
            child: Icon(
              Icons.play_arrow,
              size: 35.0,
            ),
            padding: EdgeInsets.all(15.0),
            shape: CircleBorder(),
          )
        ],
      ),
    );
  }
}
