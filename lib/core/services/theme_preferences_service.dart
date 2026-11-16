import 'package:shared_preferences/shared_preferences.dart';

// Handles saving and retrieving the user's theme preference.
class ThemePreferencesService {
  // Key used to identify the saved theme preference.
  static const _key = 'theme_mode';

  // Retrieves the previously saved theme mode.
  Future<String?> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  // Saves the selected theme mode as a string.
  Future<void> setThemeMode(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, value);
  }
}