import 'package:flutter/material.dart.';
import 'package:provider/provider.dart';
import 'package:wombocombo/models/custom_combo.dart';
import 'package:wombocombo/providers/custom_combo_provider.dart';
import 'package:wombocombo/providers/theme_provider.dart';
import 'package:wombocombo/screens/countdown_timer/set_timer_screen.dart';
import 'package:wombocombo/screens/make_your_combo/saved_combos_screen.dart';
import 'package:intl/intl.dart';

enum currentNumberOfCombos { one, two, three, four }

class MakeYourComboScreen extends StatefulWidget {
  static const routeName = '/combo-maker';

  List<String> list = <String>[
    ' ',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    'b1',
    'b2',
    'b3',
    'b4',
    'b5',
    'b6'
  ];

  @override
  State<MakeYourComboScreen> createState() => _MakeYourComboScreenState();
}

class _MakeYourComboScreenState extends State<MakeYourComboScreen> {
  var customComboProvider;
  var comboName;

  late String dropdownValueOneOne;
  late String dropdownValueOneTwo;
  late String dropdownValueOneThree;
  late String dropdownValueOneFour;
  late String dropdownValueOneFive;

  late String dropdownValueTwoOne;
  late String dropdownValueTwoTwo;
  late String dropdownValueTwoThree;
  late String dropdownValueTwoFour;
  late String dropdownValueTwoFive;

  late String dropdownValueThreeOne;
  late String dropdownValueThreeTwo;
  late String dropdownValueThreeThree;
  late String dropdownValueThreeFour;
  late String dropdownValueThreeFive;

  late String dropdownValueFourOne;
  late String dropdownValueFourTwo;
  late String dropdownValueFourThree;
  late String dropdownValueFourFour;
  late String dropdownValueFourFive;

  late String dropdownValueFiveOne;
  late String dropdownValueFiveTwo;
  late String dropdownValueFiveThree;
  late String dropdownValueFiveFour;
  late String dropdownValueFiveFive;

  late String dropdownValueSixOne;
  late String dropdownValueSixTwo;
  late String dropdownValueSixThree;
  late String dropdownValueSixFour;
  late String dropdownValueSixFive;

  List combos1 = [];
  String combos1Str = '';
  List combos2 = [];
  String combos2Str = '';
  List combos3 = [];
  String combos3Str = '';
  List combos4 = [];
  String combos4Str = '';
  List combos5 = [];
  String combos5Str = '';
  List combos6 = [];
  String combos6Str = '';

  List combosCombined = [];

  final _formKey = GlobalKey<FormState>();

  bool secondRowActivated = false;
  bool thirdRowActivated = false;
  bool fourthRowActivated = false;
  bool fifthRowActivated = false;
  bool sixsthRowActivated = false;
  bool seventhRowActivated = false;
  bool isChecked = false;

  List savedComboList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<CustomComboProvider>(context, listen: false).fetchAttacks();

    if (ModalRoute.of(context)!.settings.arguments != null) {
      final savedCustomCombo =
          ModalRoute.of(context)!.settings.arguments as CustomCombo;

      savedComboList = savedCustomCombo.getAttacks.split('|');
      var savedComboListLength = savedComboList.length;

      if (savedComboListLength > 0) {
        if (savedComboListLength >= 1 &&
            savedComboList.asMap()[0] != null &&
            savedComboList.asMap()[0].toString().isNotEmpty) {
          var attacksList = savedComboList.asMap()[0].split(' ');
          var attacksLength = attacksList.length;

          dropdownValueOneOne =
              attacksLength >= 1 ? attacksList[0] : widget.list.first;

          dropdownValueOneTwo =
              attacksLength >= 2 ? attacksList[1] : widget.list.first;

          dropdownValueOneThree =
              attacksLength >= 3 ? attacksList[2] : widget.list.first;

          dropdownValueOneFour =
              attacksLength >= 4 ? attacksList[3] : widget.list.first;

          dropdownValueOneFive =
              attacksLength >= 5 ? attacksList[4] : widget.list.first;
        }

        if (savedComboListLength >= 2 &&
            savedComboList.asMap()[1] != null &&
            savedComboList.asMap()[1].toString().isNotEmpty) {
          secondRowActivated = true;

          var attacksList = savedComboList.asMap()[1].split(' ');
          var attacksLength = attacksList.length;
          dropdownValueTwoOne =
              attacksLength >= 1 ? attacksList[0] : widget.list.first;
          dropdownValueTwoTwo =
              attacksLength >= 2 ? attacksList[1] : widget.list.first;
          dropdownValueTwoThree =
              attacksLength >= 3 ? attacksList[2] : widget.list.first;
          dropdownValueTwoFour =
              attacksLength >= 4 ? attacksList[3] : widget.list.first;
          dropdownValueTwoFive =
              attacksLength >= 5 ? attacksList[4] : widget.list.first;
        }

        if (savedComboListLength >= 3 &&
            savedComboList.asMap()[2] != null &&
            savedComboList.asMap()[2].toString().isNotEmpty) {
          thirdRowActivated = true;

          var attacksList = savedComboList.asMap()[2].split(' ');
          var attacksLength = attacksList.length;

          dropdownValueThreeOne =
              attacksLength >= 1 ? attacksList[0] : widget.list.first;

          dropdownValueThreeTwo =
              attacksLength >= 2 ? attacksList[1] : widget.list.first;

          dropdownValueThreeThree =
              attacksLength >= 3 ? attacksList[2] : widget.list.first;

          dropdownValueThreeFour =
              attacksLength >= 4 ? attacksList[3] : widget.list.first;

          dropdownValueThreeFive =
              attacksLength >= 5 ? attacksList[4] : widget.list.first;
        }

        if (savedComboListLength >= 4 &&
            savedComboList.asMap()[3] != null &&
            savedComboList.asMap()[3].toString().isNotEmpty) {
          fourthRowActivated = true;

          var attacksList = savedComboList.asMap()[3].split(' ');
          var attacksLength = attacksList.length;
          dropdownValueFourOne =
              attacksLength >= 1 ? attacksList[0] : widget.list.first;

          dropdownValueFourTwo =
              attacksLength >= 2 ? attacksList[1] : widget.list.first;

          dropdownValueFourThree =
              attacksLength >= 3 ? attacksList[2] : widget.list.first;

          dropdownValueFourFour =
              attacksLength >= 4 ? attacksList[3] : widget.list.first;

          dropdownValueFourFive =
              attacksLength >= 5 ? attacksList[4] : widget.list.first;
        }
        if (savedComboListLength >= 5 &&
            savedComboList.asMap()[4] != null &&
            savedComboList.asMap()[4].toString().isNotEmpty) {
          fifthRowActivated = true;

          var attacksList = savedComboList.asMap()[4].split(' ');
          var attacksLength = attacksList.length;
          dropdownValueFiveOne =
              attacksLength >= 1 ? attacksList[0] : widget.list.first;

          dropdownValueFiveTwo =
              attacksLength >= 2 ? attacksList[1] : widget.list.first;

          dropdownValueFiveThree =
              attacksLength >= 3 ? attacksList[2] : widget.list.first;

          dropdownValueFiveFour =
              attacksLength >= 4 ? attacksList[3] : widget.list.first;

          dropdownValueFiveFive =
              attacksLength >= 5 ? attacksList[4] : widget.list.first;
        }

        if (savedComboListLength >= 6 &&
            savedComboList.asMap()[5] != null &&
            savedComboList.asMap()[5].toString().isNotEmpty) {
          sixsthRowActivated = true;

          var attacksList = savedComboList.asMap()[5].split(' ');
          var attacksLength = attacksList.length;
          dropdownValueSixOne =
              attacksLength >= 1 ? attacksList[0] : widget.list.first;

          dropdownValueSixTwo =
              attacksLength >= 2 ? attacksList[1] : widget.list.first;

          dropdownValueSixThree =
              attacksLength >= 3 ? attacksList[2] : widget.list.first;

          dropdownValueSixFour =
              attacksLength >= 4 ? attacksList[3] : widget.list.first;

          dropdownValueSixFive =
              attacksLength >= 5 ? attacksList[4] : widget.list.first;
        }
      }
    }
  }

  void _startAddingCombo(BuildContext ctx) {
    if (isChecked)
      showModalBottomSheet(
          context: ctx,
          builder: (_) {
            return Padding(
              padding: EdgeInsets.only(
                  top: 8,
                  left: 8,
                  right: 8,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
              child: Row(
                children: [
                  Container(
                    width: 300,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        label: Center(
                          child: Text('Workout Name'),
                        ),
                      ),
                      onChanged: (value) {
                        comboName = value;
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      combos1.clear();
                      combos1.add(dropdownValueOneOne);
                      combos1.add(dropdownValueOneTwo);
                      combos1.add(dropdownValueOneThree);
                      combos1.add(dropdownValueOneFour);
                      combos1.add(dropdownValueOneFive);
                      combos1Str = combos1.join(' ').trim();

                      combos2.clear();
                      combos2.add(dropdownValueTwoOne);
                      combos2.add(dropdownValueTwoTwo);
                      combos2.add(dropdownValueTwoThree);
                      combos2.add(dropdownValueTwoFour);
                      combos2.add(dropdownValueTwoFive);
                      combos2Str = combos2.join(' ').trim();

                      combos3.clear();
                      combos3.add(dropdownValueThreeOne);
                      combos3.add(dropdownValueThreeTwo);
                      combos3.add(dropdownValueThreeThree);
                      combos3.add(dropdownValueThreeFour);
                      combos3.add(dropdownValueThreeFive);
                      combos3Str = combos3.join(' ').trim();

                      combos4.clear();
                      combos4.add(dropdownValueFourOne);
                      combos4.add(dropdownValueFourTwo);
                      combos4.add(dropdownValueFourThree);
                      combos4.add(dropdownValueFourFour);
                      combos4.add(dropdownValueFourFive);
                      combos4Str = combos4.join(' ').trim();

                      combos5.clear();
                      combos5.add(dropdownValueFiveOne);
                      combos5.add(dropdownValueFiveTwo);
                      combos5.add(dropdownValueFiveThree);
                      combos5.add(dropdownValueFiveFour);
                      combos5.add(dropdownValueFiveFive);
                      combos5Str = combos5.join(' ').trim();

                      combos6.clear();
                      combos6.add(dropdownValueSixOne);
                      combos6.add(dropdownValueSixTwo);
                      combos6.add(dropdownValueSixThree);
                      combos6.add(dropdownValueSixFour);
                      combos6.add(dropdownValueSixFive);
                      combos6Str = combos6.join(' ').trim();

                      combosCombined.clear();
                      combosCombined.add(combos1Str);
                      if (secondRowActivated) {
                        combosCombined.add(combos2Str);
                      }
                      if (thirdRowActivated) {
                        combosCombined.add(combos3Str);
                      }
                      if (fourthRowActivated) {
                        combosCombined.add(combos4Str);
                      }
                      if (fifthRowActivated) {
                        combosCombined.add(combos5Str);
                      }
                      if (sixsthRowActivated) {
                        combosCombined.add(combos6Str);
                      }

                      var splitCombos = combosCombined.join('|');
                      if (isChecked) {
                        customComboProvider
                            .addCombo(CustomCombo(comboName, splitCombos));
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Combo Saved'),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      );

                      Navigator.pop(ctx);
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            );
            return Text('error');
          });
  }

  late ThemeProvider darkThemeProvider;
  @override
  void initState() {
    super.initState();
    customComboProvider =
        Provider.of<CustomComboProvider>(context, listen: false);
    darkThemeProvider = Provider.of<ThemeProvider>(context, listen: false);

    customComboProvider.fetchAttacks();

    if (!(savedComboList.length > 0)) {
      dropdownValueOneOne = widget.list.first;
      dropdownValueOneTwo = widget.list.first;
      dropdownValueOneThree = widget.list.first;
      dropdownValueOneFour = widget.list.first;
      dropdownValueOneFive = widget.list.first;

      dropdownValueTwoOne = widget.list.first;
      dropdownValueTwoTwo = widget.list.first;
      dropdownValueTwoThree = widget.list.first;
      dropdownValueTwoFour = widget.list.first;
      dropdownValueTwoFive = widget.list.first;

      dropdownValueThreeOne = widget.list.first;
      dropdownValueThreeTwo = widget.list.first;
      dropdownValueThreeThree = widget.list.first;
      dropdownValueThreeFour = widget.list.first;
      dropdownValueThreeFive = widget.list.first;

      dropdownValueFourOne = widget.list.first;
      dropdownValueFourTwo = widget.list.first;
      dropdownValueFourThree = widget.list.first;
      dropdownValueFourFour = widget.list.first;
      dropdownValueFourFive = widget.list.first;

      dropdownValueFiveOne = widget.list.first;
      dropdownValueFiveTwo = widget.list.first;
      dropdownValueFiveThree = widget.list.first;
      dropdownValueFiveFour = widget.list.first;
      dropdownValueFiveFive = widget.list.first;

      dropdownValueSixOne = widget.list.first;
      dropdownValueSixTwo = widget.list.first;
      dropdownValueSixThree = widget.list.first;
      dropdownValueSixFour = widget.list.first;
      dropdownValueSixFive = widget.list.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FloatingActionButton.extended(
              heroTag: 'one',
              onPressed: () {
                Navigator.of(context).pushNamed(SavedCombos.routeName);
              },
              label: Text('Saved Combos'),
              backgroundColor: Colors.black,
            ),
            FloatingActionButton.extended(
              backgroundColor: Colors.black,
              extendedPadding: EdgeInsets.all(25),
              elevation: 12,
              onPressed: () {
                combos1.clear();
                combos1.add(dropdownValueOneOne);
                combos1.add(dropdownValueOneTwo);
                combos1.add(dropdownValueOneThree);
                combos1.add(dropdownValueOneFour);
                combos1.add(dropdownValueOneFive);
                combos1Str = combos1.join(' ').trim();

                combos2.clear();
                combos2.add(dropdownValueTwoOne);
                combos2.add(dropdownValueTwoTwo);
                combos2.add(dropdownValueTwoThree);
                combos2.add(dropdownValueTwoFour);
                combos2.add(dropdownValueTwoFive);
                combos2Str = combos2.join(' ').trim();

                combos3.clear();
                combos3.add(dropdownValueThreeOne);
                combos3.add(dropdownValueThreeTwo);
                combos3.add(dropdownValueThreeThree);
                combos3.add(dropdownValueThreeFour);
                combos3.add(dropdownValueThreeFive);
                combos3Str = combos3.join(' ').trim();

                combos4.clear();
                combos4.add(dropdownValueFourOne);
                combos4.add(dropdownValueFourTwo);
                combos4.add(dropdownValueFourThree);
                combos4.add(dropdownValueFourFour);
                combos4.add(dropdownValueFourFive);
                combos4Str = combos4.join(' ').trim();

                combos5.clear();
                combos5.add(dropdownValueFiveOne);
                combos5.add(dropdownValueFiveTwo);
                combos5.add(dropdownValueFiveThree);
                combos5.add(dropdownValueFiveFour);
                combos5.add(dropdownValueFiveFive);
                combos5Str = combos5.join(' ').trim();

                combos6.clear();
                combos6.add(dropdownValueSixOne);
                combos6.add(dropdownValueSixTwo);
                combos6.add(dropdownValueSixThree);
                combos6.add(dropdownValueSixFour);
                combos6.add(dropdownValueSixFive);
                combos6Str = combos6.join(' ').trim();

                combosCombined.clear();
                combosCombined.add(combos1Str);
                if (secondRowActivated) {
                  combosCombined.add(combos2Str);
                }
                if (thirdRowActivated) {
                  combosCombined.add(combos3Str);
                }
                if (fourthRowActivated) {
                  combosCombined.add(combos4Str);
                }
                if (fifthRowActivated) {
                  combosCombined.add(combos5Str);
                }
                if (sixsthRowActivated) {
                  combosCombined.add(combos6Str);
                }
                Navigator.of(context).pushNamed(SetTimeScreen.routeName,
                    arguments: ['fromMakeYourComboScreen', combosCombined]);
              },
              label: const Text('Next'),
              icon: const Icon(Icons.play_arrow),
              heroTag: 'two',
            ),
          ],
        ),
        appBar: AppBar(
          title: Text('Custom Combo'),
        ),
        body: Column(
          children: [
            Container(margin: EdgeInsets.only(top: 10), child: Text('Combos:')),
            Row(
              children: [
                attackDropdownItem(dropdownValueOneOne, '1-1'),
                attackDropdownItem(dropdownValueOneTwo, '1-2'),
                attackDropdownItem(dropdownValueOneThree, '1-3'),
                attackDropdownItem(dropdownValueOneFour, '1-4'),
                attackDropdownItem(dropdownValueOneFive, '1-5'),
              ],
            ),
            if (secondRowActivated)
              Row(
                children: [
                  attackDropdownItem(dropdownValueTwoOne, '2-1'),
                  attackDropdownItem(dropdownValueTwoTwo, '2-2'),
                  attackDropdownItem(dropdownValueTwoThree, '2-3'),
                  attackDropdownItem(dropdownValueTwoFour, '2-4'),
                  attackDropdownItem(dropdownValueTwoFive, '2-5'),
                ],
              ),
            if (thirdRowActivated)
              Row(
                children: [
                  attackDropdownItem(dropdownValueThreeOne, '3-1'),
                  attackDropdownItem(dropdownValueThreeTwo, '3-2'),
                  attackDropdownItem(dropdownValueThreeThree, '3-3'),
                  attackDropdownItem(dropdownValueThreeFour, '3-4'),
                  attackDropdownItem(dropdownValueThreeFive, '3-5'),
                ],
              ),
            if (fourthRowActivated)
              Row(
                children: [
                  attackDropdownItem(dropdownValueFourOne, '4-1'),
                  attackDropdownItem(dropdownValueFourTwo, '4-2'),
                  attackDropdownItem(dropdownValueFourThree, '4-3'),
                  attackDropdownItem(dropdownValueFourFour, '4-4'),
                  attackDropdownItem(dropdownValueFourFive, '4-5'),
                ],
              ),
            if (fifthRowActivated)
              Row(
                children: [
                  attackDropdownItem(dropdownValueFiveOne, '5-1'),
                  attackDropdownItem(dropdownValueFiveTwo, '5-2'),
                  attackDropdownItem(dropdownValueFiveThree, '5-3'),
                  attackDropdownItem(dropdownValueFiveFour, '5-4'),
                  attackDropdownItem(dropdownValueFiveFive, '5-5'),
                ],
              ),
            if (sixsthRowActivated)
              Row(
                children: [
                  attackDropdownItem(dropdownValueSixOne, '6-1'),
                  attackDropdownItem(dropdownValueSixTwo, '6-2'),
                  attackDropdownItem(dropdownValueSixThree, '6-3'),
                  attackDropdownItem(dropdownValueSixFour, '6-4'),
                  attackDropdownItem(dropdownValueSixFive, '6-5'),
                ],
              ),
            if (!sixsthRowActivated)
              TextButton.icon(
                style: ButtonStyle(
                  alignment: Alignment.center,
                ),
                label: Text(''),
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    if (!secondRowActivated) {
                      secondRowActivated = true;
                    } else if (!thirdRowActivated) {
                      thirdRowActivated = true;
                    } else if (!fourthRowActivated) {
                      fourthRowActivated = true;
                    } else if (!fifthRowActivated) {
                      fifthRowActivated = true;
                    } else if (!sixsthRowActivated) {
                      sixsthRowActivated = true;
                    }
                  });
                },
              ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('Save Combo'),
              Checkbox(
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                  _startAddingCombo(context);
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Container attackDropdownItem(
      String dropdownValue, String currentDropdownValue) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: FormField<String>(
        builder: (FormFieldState<String> state) {
          return DropdownButton<String>(
            icon: Icon(Icons.arrow_drop_down,
                color:
                    darkThemeProvider.darkTheme ? Colors.white : Colors.black),
            value: dropdownValue,
            elevation: 16,
            underline: Container(
              height: 2,
              color: darkThemeProvider.darkTheme ? Colors.white : Colors.black,
            ),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                if (currentDropdownValue == '1-1') {
                  dropdownValueOneOne = value!;
                } else if (currentDropdownValue == '1-2') {
                  dropdownValueOneTwo = value!;
                } else if (currentDropdownValue == '1-3') {
                  dropdownValueOneThree = value!;
                } else if (currentDropdownValue == '1-4') {
                  dropdownValueOneFour = value!;
                } else if (currentDropdownValue == '1-5') {
                  dropdownValueOneFive = value!;
                } else if (currentDropdownValue == '2-1') {
                  dropdownValueTwoOne = value!;
                } else if (currentDropdownValue == '2-2') {
                  dropdownValueTwoTwo = value!;
                } else if (currentDropdownValue == '2-3') {
                  dropdownValueTwoThree = value!;
                } else if (currentDropdownValue == '2-4') {
                  dropdownValueTwoFour = value!;
                } else if (currentDropdownValue == '2-5') {
                  dropdownValueTwoFive = value!;
                } else if (currentDropdownValue == '3-1') {
                  dropdownValueThreeOne = value!;
                } else if (currentDropdownValue == '3-2') {
                  dropdownValueThreeTwo = value!;
                } else if (currentDropdownValue == '3-3') {
                  dropdownValueThreeThree = value!;
                } else if (currentDropdownValue == '3-4') {
                  dropdownValueThreeFour = value!;
                } else if (currentDropdownValue == '3-5') {
                  dropdownValueThreeFive = value!;
                } else if (currentDropdownValue == '4-1') {
                  dropdownValueFourOne = value!;
                } else if (currentDropdownValue == '4-2') {
                  dropdownValueFourTwo = value!;
                } else if (currentDropdownValue == '4-3') {
                  dropdownValueFourThree = value!;
                } else if (currentDropdownValue == '4-4') {
                  dropdownValueFourFour = value!;
                } else if (currentDropdownValue == '4-5') {
                  dropdownValueFourFive = value!;
                } else if (currentDropdownValue == '5-1') {
                  dropdownValueFiveOne = value!;
                } else if (currentDropdownValue == '5-2') {
                  dropdownValueFiveTwo = value!;
                } else if (currentDropdownValue == '5-3') {
                  dropdownValueFiveThree = value!;
                } else if (currentDropdownValue == '5-4') {
                  dropdownValueFiveFour = value!;
                } else if (currentDropdownValue == '5-5') {
                  dropdownValueFiveFive = value!;
                } else if (currentDropdownValue == '6-1') {
                  dropdownValueSixOne = value!;
                } else if (currentDropdownValue == '6-2') {
                  dropdownValueSixTwo = value!;
                } else if (currentDropdownValue == '6-3') {
                  dropdownValueSixThree = value!;
                } else if (currentDropdownValue == '6-4') {
                  dropdownValueSixFour = value!;
                } else if (currentDropdownValue == '6-5') {
                  dropdownValueSixFive = value!;
                }
              });
            },
            items: widget.list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
