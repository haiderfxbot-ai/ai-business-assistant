import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _autoReplyEnabled = true;
  bool _urduSupportEnabled = true;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get autoReplyEnabled => _autoReplyEnabled;
  bool get urduSupportEnabled => _urduSupportEnabled;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = prefs.getBool('darkMode') == true ? ThemeMode.dark : ThemeMode.light;
    _autoReplyEnabled = prefs.getBool('autoReply') ?? true;
    _urduSupportEnabled = prefs.getBool('urduSupport') ?? true;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', isDarkMode);
    notifyListeners();
  }

  Future<void> setAutoReply(bool value) async {
    _autoReplyEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('autoReply', value);
    notifyListeners();
  }

  Future<void> setUrduSupport(bool value) async {
    _urduSupportEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('urduSupport', value);
    notifyListeners();
  }
}
