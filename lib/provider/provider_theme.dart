import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkMode = false;

  ThemeProvider(this.isDarkMode);

  void toggleTheme(bool value) {
    isDarkMode = value;
    notifyListeners();

    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('isDarkMode', value);
    });
  }
}
