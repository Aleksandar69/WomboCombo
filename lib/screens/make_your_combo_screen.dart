import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

class MakeYourComboScreen extends StatefulWidget {
  static const routeName = '/combo-maker';

  @override
  State<MakeYourComboScreen> createState() => _MakeYourComboScreenState();
}

class _MakeYourComboScreenState extends State<MakeYourComboScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Make your combo Screen'),
    );
  }
}