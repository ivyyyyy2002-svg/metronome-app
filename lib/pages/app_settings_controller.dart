import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Controller class for managing app-wide settings such as theme mode and language
enum AppLanguage { system, english, chinese }

class AppSettingsController extends ChangeNotifier {
  static const String _themeModeKey = 'theme_mode';
  static const String _languageKey = 'app_language';

  ThemeMode _themeMode = ThemeMode.system;
  AppLanguage _language = AppLanguage.system;

  ThemeMode get themeMode => _themeMode;
  AppLanguage get language => _language;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    final savedThemeMode = prefs.getString(_themeModeKey);
    final savedLanguage = prefs.getString(_languageKey);

    _themeMode = _parseThemeMode(savedThemeMode);
    _language = _parseLanguage(savedLanguage);

    notifyListeners();
  }

  // Sets the theme mode and saves it to persistent storage.
  Future<void> setThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, themeMode.name);

    notifyListeners();
  }

  // Sets the app language and saves it to persistent storage.
  Future<void> setLanguage(AppLanguage language) async {
    _language = language;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language.name);

    notifyListeners();
  }

  // Parses a string value to determine the corresponding ThemeMode,
  // defaulting to system if unrecognized.
  ThemeMode _parseThemeMode(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  // Parses a string value to determine the corresponding AppLanguage,
  // defaulting to system if unrecognized.
  AppLanguage _parseLanguage(String? value) {
    switch (value) {
      case 'english':
        return AppLanguage.english;
      case 'chinese':
        return AppLanguage.chinese;
      case 'system':
      default:
        return AppLanguage.system;
    }
  }
}
