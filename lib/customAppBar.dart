import 'package:flutter/material.dart.';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wombocombo/providers/dark_mode_notifier.dart';

PreferredSizeWidget customAppBar(title) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(fontSize: 20),
    ),
    actions: [
      Consumer(builder: (context, ref, child) {
        var darkMode = ref.watch(darkModeProvider);

        return IconButton(
          onPressed: () {
            ref.read(darkModeProvider.notifier).toggle();
          },
          icon:
              darkMode == true ? Icon(Icons.dark_mode) : Icon(Icons.light_mode),
        );
      }),
    ],
  );
}
