import 'package:flutter/material.dart';

class AppTheme {
  static const appBarColorLight = Color(0xFF134B9F);
  static const accentColorLight = Color(0xFF13B9FF);
  static const accentColorDark = Color(0xFF07394f);
  static const primaryColorLight = Colors.blueAccent;
  static const primaryColorDark = Color(0xFF363f4d);
  ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColorLight,
      appBarTheme: const AppBarTheme(
        color: appBarColorLight,
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryColorLight,
        secondary: Color(0xFF134B9F),
        tertiary: Color.fromARGB(255, 109, 184, 246),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          primary: Colors.white,
          side: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColorLight,
      inputDecorationTheme: const InputDecorationTheme(
        floatingLabelStyle: TextStyle(color: Colors.white),
        hintStyle: TextStyle(color: Colors.white),
      ),
      appBarTheme: const AppBarTheme(
        color: Color(0xFF242424),
      ),
      colorScheme: const ColorScheme.dark(
        primary: Colors.white,
        secondary: accentColorDark,
        tertiary: primaryColorDark,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          primary: Colors.white,
          side: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
