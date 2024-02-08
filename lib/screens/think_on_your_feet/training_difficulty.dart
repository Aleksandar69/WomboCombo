import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:wombocombo/providers/auth_provider.dart';
import 'package:wombocombo/providers/user_provider.dart';
import 'package:wombocombo/screens/countdown_timer/set_timer_screen.dart';

class TrainingDiff extends StatefulWidget {
  static const routeName = 'training-diff';

  const TrainingDiff({Key? key}) : super(key: key);

  @override
  State<TrainingDiff> createState() => _TrainingDiffState();
}

class _TrainingDiffState extends State<TrainingDiff> {
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();
  final GlobalKey _five = GlobalKey();
  var selectedMartialArt;

  late final AuthProvider authProvider =
      Provider.of<AuthProvider>(context, listen: false);
  late final UserProvider userProvider =
      Provider.of<UserProvider>(context, listen: false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var args = ModalRoute.of(context)!.settings.arguments as List;
    selectedMartialArt = args[0];
    var firstTimeDifficulty = args[1];
    if (firstTimeDifficulty) {
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          ShowCaseWidget.of(showcaseContext)
              .startShowCase([_one, _two, _three, _four, _five]));
    }
  }

  late BuildContext showcaseContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Difficulty')),
        body: ShowCaseWidget(
          blurValue: 1,
          disableBarrierInteraction: true,
          builder: Builder(builder: (context) {
            showcaseContext = context;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context)
                      .pushNamed(SetTimeScreen.routeName, arguments: [
                    'fromQuickCombos',
                    'Beginner',
                    selectedMartialArt
                  ]),
                  child: Showcase.withWidget(
                    container: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 250,
                          child: Text(
                              "Please select beginner dificulty if you're new to martrial arts",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 15)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              ShowCaseWidget.of(showcaseContext).next();
                            },
                            child: Text('Okay')),
                      ],
                    ),
                    height: 250,
                    width: 250,
                    key: _two,
                    child: Card(
                      elevation: 5,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 151, 227, 239)),
                        height: 100,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          'Beginner',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Showcase.withWidget(
                  container: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 250,
                        child: Text(
                            "Hey there! Welcome to your first think quick training session",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 15)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            ShowCaseWidget.of(showcaseContext).next();
                          },
                          child: Text('Hi')),
                    ],
                  ),
                  height: 250,
                  width: 250,
                  key: _one,
                  child: SizedBox(
                    height: 0,
                    width: 0,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context)
                      .pushNamed(SetTimeScreen.routeName, arguments: [
                    'fromQuickCombos',
                    'Intermediate',
                    selectedMartialArt
                  ]),
                  child: Showcase.withWidget(
                    container: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 250,
                          child: Text(
                              "If you're experienced, Intermediate difficulty is a good place to start",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 15)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              await userProvider.updateUserInfo(
                                  authProvider.userId!,
                                  {'firstTimeChoosingDifficulty': false});
                              ShowCaseWidget.of(showcaseContext).next();
                            },
                            child: Text('Got it')),
                      ],
                    ),
                    height: 250,
                    width: 250,
                    key: _three,
                    child: Card(
                      elevation: 5,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 102, 208, 224)),
                        height: 100,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          'Intermediate',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context)
                      .pushNamed(SetTimeScreen.routeName, arguments: [
                    'fromQuickCombos',
                    'Advanced',
                    selectedMartialArt
                  ]),
                  child: Card(
                    elevation: 5,
                    child: Container(
                      decoration: BoxDecoration(color: Color(0xff00B4D8)),
                      alignment: Alignment.center,
                      height: 100,
                      width: double.infinity,
                      child: Text(
                        'Advanced',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context)
                      .pushNamed(SetTimeScreen.routeName, arguments: [
                    'fromQuickCombos',
                    'Expert',
                    selectedMartialArt
                  ]),
                  child: Card(
                    elevation: 5,
                    child: Container(
                      decoration: BoxDecoration(color: Color(0xff0077B6)),
                      alignment: Alignment.center,
                      height: 100,
                      width: double.infinity,
                      child: Text(
                        'Expert',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context)
                      .pushNamed(SetTimeScreen.routeName, arguments: [
                    'fromQuickCombos',
                    'Master',
                    selectedMartialArt
                  ]),
                  child: Card(
                    elevation: 5,
                    child: Container(
                      decoration: BoxDecoration(color: Color(0xff023E8A)),
                      alignment: Alignment.center,
                      height: 100,
                      width: double.infinity,
                      child: Text(
                        'Master',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ));
  }
}
