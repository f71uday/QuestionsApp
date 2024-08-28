import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_theme/json_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static String? themePreferenceKey = dotenv.env['IS_MODE_DARK'];
  ThemeData currentTheme = ThemeData.light();

  ThemeProvider() {
    _loadThemePreference();
  }

  void toggleTheme(bool isDarkMode) async {
    ThemeData? lightTheme = await _loadThemeFromAssets(isDark: true);
    ThemeData? darkTheme = await _loadThemeFromAssets(isDark: false);
    currentTheme = isDarkMode ? darkTheme : lightTheme;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(themePreferenceKey!, isDarkMode);
  }

  void _loadThemePreference() async {
    ThemeData? lightTheme = await _loadThemeFromAssets(isDark: true);
    ThemeData? darkTheme = await _loadThemeFromAssets(isDark: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool(themePreferenceKey!) ?? false;
    currentTheme = isDarkMode ? darkTheme : lightTheme;
    notifyListeners();
  }

  Future<ThemeData> _loadThemeFromAssets({required bool isDark}) async {
    final themeStr = await rootBundle.loadString(
        isDark ? 'assets/dark_theme.json' : 'assets/light_theme.json');
    final themeJson = jsonDecode(themeStr);
    return ThemeDecoder.decodeThemeData(themeJson)!;
  }
}
