import 'dart:ui';

import 'package:flutter/material.dart';

abstract class Styles {
  //colors
  static const Color whiteColor = Color(0xffffffff);
  static const Color blackColor = Color(0xff0000000);
  static const Color orangeColor = Colors.orange;
  static const Color redColor = Colors.red;
  static const Color darkRedColor = Color(0xFFB71C1C);

  static const Color purpleColor = Color(0xff5E498A);

  static const Color darkThemeColor = Color(0xff33333E);

  static const Color grayColor = Color(0xff797979);

  static const Color greyColorLight = Color(0xffd7d7d7);

  static const Color settingsBackground = Color(0xffefeff4);

  static const Color settingsGroupSubtitle = Color(0xff777777);

  static const Color iconBlue = Color(0xff0000ff);
  static const Color transparent = Colors.transparent;
  static const Color iconGold = Color(0xffdba800);
  static const Color bottomBarSelectedColor = Color(0xff5e4989);

  //Strings
  static const TextStyle defaultTextStyle = TextStyle(
    color: Styles.purpleColor,
    fontSize: 20.0,
  );
  static const TextStyle defaultTextStyleBlack = TextStyle(
    color: Styles.blackColor,
    fontSize: 20.0,
  );
  static const TextStyle defaultTextStyleGRey = TextStyle(
    color: Styles.grayColor,
    fontSize: 20.0,
  );
  static const TextStyle smallTextStyleGRey = TextStyle(
    color: Styles.grayColor,
    fontSize: 16.0,
  );
  static const TextStyle smallTextStyle = TextStyle(
    color: Styles.purpleColor,
    fontSize: 16.0,
  );
  static const TextStyle smallTextStyleWhite = TextStyle(
    color: Styles.whiteColor,
    fontSize: 16.0,
  );
  static const TextStyle smallTextStyleBlack = TextStyle(
    color: Styles.blackColor,
    fontSize: 16.0,
  );
  static const TextStyle defaultButtonTextStyle =
      TextStyle(color: Styles.whiteColor, fontSize: 20);

  static const TextStyle profileTextStyleBlack = TextStyle(
    color: Styles.blackColor,
    fontSize: 20.0,
  );

  static const TextStyle defaultTextStyleWhite = TextStyle(
    color: Styles.whiteColor,
    fontSize: 20.0,
  );
  static const TextStyle messageRecipientTextStyle = TextStyle(
      color: Styles.blackColor, fontSize: 16.0, fontWeight: FontWeight.bold);

  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
        bodyMedium: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
        bodySmall: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
        headlineLarge: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
        headlineMedium: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
        headlineSmall: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
        displayLarge: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
        displayMedium: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
        displaySmall: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
        labelLarge: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
        labelMedium: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
        labelSmall: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
        titleSmall: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
        titleMedium: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
        titleLarge: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
      ),
      primarySwatch: Colors.blue,
      primaryColor: isDarkTheme ? Colors.white : Colors.black,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: isDarkTheme
            ? Color.fromARGB(255, 145, 231, 243)
            : Color.fromARGB(255, 18, 37, 69),
        secondary: Color.fromARGB(255, 0, 88, 203),
        background: isDarkTheme == true
            ? Color.fromARGB(255, 32, 62, 93)
            : Color(0xffCBDCF8),
      ),
      elevatedButtonTheme: isDarkTheme
          ? ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                  Color.fromARGB(255, 51, 134, 131),
                ),
              ),
            )
          : ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                  Color.fromARGB(255, 69, 116, 204),
                ),
              ),
            ),

      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          labelStyle:
              TextStyle(color: isDarkTheme ? Colors.white : Colors.black),
          hintStyle: TextStyle(
            color: isDarkTheme ? Colors.white : Colors.black,
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
      iconTheme: IconThemeData(
        color: isDarkTheme ? Colors.white : Colors.black,
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor:
            MaterialStatePropertyAll(isDarkTheme ? Colors.black : Colors.white),
        fillColor:
            MaterialStatePropertyAll(isDarkTheme ? Colors.white : Colors.black),
      ),
      inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
        color: isDarkTheme
            ? Color.fromARGB(255, 165, 222, 229)
            : Color.fromARGB(255, 18, 37, 69),
      )),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          iconColor: MaterialStatePropertyAll(isDarkTheme
              ? Color.fromARGB(255, 203, 230, 246)
              : Color.fromARGB(255, 18, 37, 69)),
        ),
      ),
      indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
      hintColor:
          isDarkTheme ? Color(0xff280C0B) : Color.fromARGB(255, 116, 106, 183),
      highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
      hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
      focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      cardColor:
          isDarkTheme ? Color(0xff023E8A) : Color.fromARGB(255, 203, 230, 246),
      canvasColor: isDarkTheme == true
          ? Color.fromARGB(255, 32, 62, 93)
          : Color(0xffCBDCF8),
      // buttonTheme: Theme.of(context).buttonTheme.copyWith(
      //     colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      appBarTheme: AppBarTheme(
        iconTheme:
            IconThemeData(color: isDarkTheme ? Colors.white : Colors.black),
        color: isDarkTheme
            ? Color.fromARGB(255, 18, 37, 69)
            : Color.fromARGB(255, 203, 230, 246),
        titleTextStyle: TextStyle(
            color: isDarkTheme ? Colors.white : Colors.black, fontSize: 20),
        toolbarTextStyle: isDarkTheme
            ? TextStyle(color: Colors.white, fontSize: 20)
            : TextStyle(color: Colors.black, fontSize: 20),
        actionsIconTheme: isDarkTheme
            ? IconThemeData(color: Colors.white)
            : IconThemeData(color: Colors.black),
      ),
      floatingActionButtonTheme: isDarkTheme
          ? FloatingActionButtonThemeData(
              foregroundColor: Colors.white,
              backgroundColor: Color.fromARGB(255, 71, 162, 159),
              extendedTextStyle: TextStyle(color: Colors.black),
            )
          : FloatingActionButtonThemeData(
              foregroundColor: Colors.white,
              backgroundColor: Color.fromARGB(255, 36, 89, 188),
              extendedTextStyle: TextStyle(color: Colors.white),
            ),
    );
  }
}
