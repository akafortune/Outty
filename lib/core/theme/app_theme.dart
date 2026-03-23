import 'package:flutter/material.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

class AppTheme {
  static ThemeData lightTheme = getLightTheme();
  static ThemeData darkTheme = getDarkTheme();

  static ThemeData getTheme(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark
        ? darkTheme
        : lightTheme;
  }
}
