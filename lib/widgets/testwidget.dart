import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class OverLayIssue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Overlay.of(context).insert(_getEntry(context));
        },
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Text('0' * 10000),
        ],
      ),
    );
  }

  OverlayEntry _getEntry(context) {
    late OverlayEntry entry;

    entry = OverlayEntry(
      opaque: false,
      maintainState: true,
      builder: (_) => Positioned(
        left: 100,
        bottom: 100,
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.5,
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: 2,
            sigmaY: 2,
          ),
          child: Material(
            type: MaterialType.transparency,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 200,
                  height: 200,
                  color: Colors.red,
                  child: Text('Hello world'),
                ),
                ElevatedButton(
                  onPressed: () => entry.remove(),
                  child: Text('remove'),
                )
              ],
            ),
          ),
        ),
      ),
    );
    return entry;
  }
}
