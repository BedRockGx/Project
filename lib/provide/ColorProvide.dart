import 'package:flutter/material.dart';

class ThemeProvide with ChangeNotifier {
  int _themeIndex = 0;

  int get value => _themeIndex;

  ThemeProvide();

  void setTheme(int index) async {
    _themeIndex = index;
    notifyListeners();
  }

}
