import 'package:chatapp/themes/dark_theme.dart';
import 'package:chatapp/themes/light_theme.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _selectedTheme = lightTheme;

  ThemeData get getTheme => _selectedTheme;

  bool get isDarkTheme => _selectedTheme == darkTheme;

  void setTheme(ThemeData theme) {
    _selectedTheme = theme;
    notifyListeners();
  }

  void toggleTheme() {
    _selectedTheme = _selectedTheme == darkTheme ? lightTheme : darkTheme;
    notifyListeners();
  }
}
