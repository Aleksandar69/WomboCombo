import 'dart:ui';

import 'package:flutter/material.dart';

abstract class Styles {
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

  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          headlineLarge: TextStyle(color: Colors.white),
          headlineMedium: TextStyle(color: Colors.white),
          headlineSmall: TextStyle(color: Colors.white),
          displayLarge: TextStyle(color: Colors.white),
          displayMedium: TextStyle(color: Colors.white),
          displaySmall: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
          labelMedium: TextStyle(color: Colors.white),
          labelSmall: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
        ),
        primarySwatch: Colors.blue,
        primaryColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Color.fromARGB(255, 145, 231, 243),
            secondary: Color.fromARGB(255, 0, 88, 203),
            background: Color.fromARGB(255, 32, 62, 93)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
              Color.fromARGB(255, 51, 134, 131),
            ),
          ),
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.white),
            hintStyle: TextStyle(
              color: Colors.white,
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        checkboxTheme: CheckboxThemeData(
          checkColor: MaterialStatePropertyAll(Colors.black),
          fillColor: MaterialStatePropertyAll(Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: Color.fromARGB(255, 165, 222, 229))),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            iconColor:
                MaterialStatePropertyAll(Color.fromARGB(255, 203, 230, 246)),
          ),
        ),
        indicatorColor: Color(0xff0E1D36),
        hintColor: Color(0xff280C0B),
        highlightColor: Color(0xff372901),
        hoverColor: Color(0xff3A3A3B),
        focusColor: Color(0xff0B2512),
        disabledColor: Colors.grey,
        cardColor: Color(0xff023E8A),
        canvasColor: Color.fromARGB(255, 32, 62, 93),
        // buttonTheme: Theme.of(context).buttonTheme.copyWith(
        //     colorScheme:ColorScheme.dark() : ColorScheme.light()),
        appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            color: Color.fromARGB(255, 18, 37, 69),
            titleTextStyle: TextStyle(color: Colors.white),
            toolbarTextStyle: TextStyle(color: Colors.white, fontSize: 20),
            actionsIconTheme: IconThemeData(color: Colors.white)),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: Color.fromARGB(255, 71, 162, 159),
          extendedTextStyle: TextStyle(color: Colors.black),
        ));
  }

  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: Colors.black,
        ),
        bodyMedium: TextStyle(
          color: Colors.black,
        ),
        bodySmall: TextStyle(
          color: Colors.black,
        ),
        headlineLarge: TextStyle(
          color: Colors.black,
        ),
        headlineMedium: TextStyle(
          color: Colors.black,
        ),
        headlineSmall: TextStyle(
          color: Colors.black,
        ),
        displayLarge: TextStyle(
          color: Colors.black,
        ),
        displayMedium: TextStyle(
          color: Colors.black,
        ),
        displaySmall: TextStyle(
          color: Colors.black,
        ),
        labelLarge: TextStyle(
          color: Colors.black,
        ),
        labelMedium: TextStyle(
          color: Colors.black,
        ),
        labelSmall: TextStyle(
          color: Colors.black,
        ),
        titleSmall: TextStyle(
          color: Colors.black,
        ),
        titleMedium: TextStyle(
          color: Colors.black,
        ),
        titleLarge: TextStyle(
          color: Colors.black,
        ),
      ),
      primarySwatch: Colors.blue,
      primaryColor: Colors.black,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Color.fromARGB(255, 18, 37, 69),
        secondary: Color.fromARGB(255, 0, 88, 203),
        background: Color(0xffCBDCF8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
            Color.fromARGB(255, 69, 116, 204),
          ),
        ),
      ),

      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.black),
          hintStyle: TextStyle(
            color: Colors.black,
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: MaterialStatePropertyAll(Colors.white),
        fillColor: MaterialStatePropertyAll(Colors.black),
      ),
      inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
        color: Color.fromARGB(255, 18, 37, 69),
      )),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          iconColor: MaterialStatePropertyAll(Color.fromARGB(255, 18, 37, 69)),
        ),
      ),
      indicatorColor: Color(0xffCBDCF8),
      hintColor: Color.fromARGB(255, 116, 106, 183),
      highlightColor: Color(0xffFCE192),
      hoverColor: Color(0xff4285F4),
      focusColor: Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      cardColor: Color.fromARGB(255, 203, 230, 246),
      canvasColor: Color(0xffCBDCF8),
      // buttonTheme: Theme.of(context).buttonTheme.copyWith(
      //     colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: Colors.black),
        color: Color.fromARGB(255, 203, 230, 246),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
        toolbarTextStyle: TextStyle(color: Colors.black, fontSize: 20),
        actionsIconTheme: IconThemeData(color: Colors.black),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 36, 89, 188),
        extendedTextStyle: TextStyle(color: Colors.white),
      ),
    );
  }
}
