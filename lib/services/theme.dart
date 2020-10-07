import 'package:flutter/material.dart';

enum MyTheme { Light, Dark }

class ThemeNotifier extends ChangeNotifier {
  static List<ThemeData> themes = [
    ThemeData(
      primarySwatch: Colors.lightBlue,
      fontFamily: 'Nunito',
      brightness: Brightness.light,
      primaryColor: Colors.white,
    ),
    ThemeData(
      primarySwatch: Colors.lightBlue,
      fontFamily: 'Nunito',
      brightness: Brightness.dark,
      primaryColor: Colors.black,
    ),
  ];

  MyTheme _current = MyTheme.Light;
  ThemeData _currentTheme = themes[0];

  set currentTheme(theme) {
    if (theme != null) {
      _current = theme;
      _currentTheme = _current == MyTheme.Light ? themes[0] : themes[1];
      notifyListeners();
    }
  }

  get myTheme => _current;

  get currentTheme => _currentTheme;

  void switchTheme() => _current == MyTheme.Light
      ? currentTheme = MyTheme.Dark
      : currentTheme = MyTheme.Light;
}
