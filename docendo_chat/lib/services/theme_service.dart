import 'package:docendo_chat/screens/themes_screen.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModel extends PropertyChangeNotifier<String> {
  ThemeData _currentTheme = ThemeData.from(
      colorScheme: const ColorScheme.light(
    primary: Color(0xFF66A6AD),
    secondary: Color(0xFF07575B),
    background: Color.fromARGB(255, 235, 246, 255),
    onBackground: Colors.white,
  ));

  ThemeModel() {
    _getCurrentTheme();
  }

  _getCurrentTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final nameofCurrentTheme = prefs.getString('currentTheme');
    debugPrint(nameofCurrentTheme);
    if (nameofCurrentTheme == null) {
      _currentTheme = ThemeData.from(
          colorScheme: const ColorScheme.light(
        primary: Color(0xFF66A6AD),
        secondary: Color(0xFF07575B),
        background: Color.fromARGB(255, 235, 246, 255),
        onBackground: Colors.white,
      ));
      notifyListeners('currentTheme');
      return;
    }
    int currentThemeIndex = names.indexOf(nameofCurrentTheme.toString());
    _currentTheme =
        ThemeData.from(colorScheme: colorSchemes[currentThemeIndex]);
    notifyListeners('currentTheme');
  }

  ThemeData get currentTheme => _currentTheme;
  set currentTheme(ThemeData newTheme) {
    _currentTheme = newTheme;
    notifyListeners('currentTheme');
  }
}

ThemeModel themeModel = ThemeModel();
