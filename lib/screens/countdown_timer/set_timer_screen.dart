import 'package:flutter/material.dart';
import 'package:wheel_chooser/wheel_chooser.dart';
import './timer_new.dart';

class SetTimeScreen extends StatefulWidget {
  static const routeName = '/settimer';

  @override
  State<SetTimeScreen> createState() => _SetTimeScreenState();
}

class _SetTimeScreenState extends State<SetTimeScreen> {
  final _secondsController = FixedExtentScrollController(initialItem: 1);
  final _minutesController = FixedExtentScrollController(initialItem: 0);
  final _hoursController = FixedExtentScrollController(initialItem: 0);
  final _roundsController = FixedExtentScrollController(initialItem: 2);
  late final previousScreen;

  @override
  void didChangeDependencies() {
    previousScreen =
        ModalRoute.of(context)!.settings.arguments as String;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text(
              'Timer:',
              style: TextStyle(fontSize: 45),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Flexible(
                  child: WheelChooser.integer(
                    magnification: 2,
                    listWidth: 80,
                    onValueChanged: (i) => print(i),
                    maxValue: 99,
                    minValue: 00,
                    listHeight: 400,
                    step: 1,
                    unSelectTextStyle: TextStyle(color: Colors.grey),
                    controller: _hoursController,
                  ),
                ),
              ),
              Container(
                child: Flexible(
                  child: WheelChooser.integer(
                    listWidth: 80,
                    magnification: 2,
                    onValueChanged: (i) => print(i),
                    maxValue: 59,
                    listHeight: 400,
                    minValue: 0,
                    step: 1,
                    unSelectTextStyle: TextStyle(color: Colors.grey),
                    controller: _minutesController,
                  ),
                ),
              ),
              Container(
                child: Flexible(
                  child: WheelChooser.integer(
                    listWidth: 80,
                    magnification: 2,
                    onValueChanged: (i) => print(i),
                    maxValue: 59,
                    listHeight: 400,
                    minValue: 0,
                    step: 1,
                    unSelectTextStyle: TextStyle(color: Colors.grey),
                    controller: _secondsController,
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: Text(
              'Rounds:',
              style: TextStyle(fontSize: 45),
            ),
          ),
          Container(
            child: Flexible(
              child: WheelChooser.integer(
                listWidth: 80,
                magnification: 2,
                onValueChanged: (i) => print(i),
                maxValue: 20,
                listHeight: 400,
                minValue: 1,
                step: 1,
                unSelectTextStyle: TextStyle(color: Colors.grey),
                controller: _roundsController,
              ),
            ),
          ),
          RawMaterialButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(TimerNew.routeName, arguments: [
              _hoursController.selectedItem,
              _minutesController.selectedItem,
              _secondsController.selectedItem,
              _roundsController.selectedItem,
              previousScreen
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
