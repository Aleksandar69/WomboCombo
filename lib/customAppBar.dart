import 'package:flutter/material.dart.';

PreferredSizeWidget customAppBar(title, themeProvider) {
  return AppBar(
    title: Text(title),
    actions: [
      IconButton(
        onPressed: () {
          themeProvider.darkTheme = !themeProvider.darkTheme;
        },
        icon: themeProvider.darkTheme == true
            ? Icon(Icons.dark_mode)
            : Icon(Icons.light_mode),
      )
    ],
  );
}
