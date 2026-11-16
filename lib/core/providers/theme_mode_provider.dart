import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_recommendation_app/core/services/theme_preferences_service.dart';

// Provides the service responsible for saving and retrieving theme preferences.
final themePreferencesServiceProvider = Provider<ThemePreferencesService>((ref) {
  return ThemePreferencesService();
});

// Manages the app's theme mode and makes its state accessible through RiverPod
final themeModeControllerProvider =
    NotifierProvider<ThemeModeController, ThemeMode>(ThemeModeController.new);

// Controls theme mode changes and keeps the saved preference synchronized.
class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    // Loads the saved theme preference when the controller initializes.
    _loadSavedThemeMode();
    return ThemeMode.system;
  }
 
  // Retrieves the saved theme preference and updates the state.
  Future<void> _loadSavedThemeMode() async {
    final service = ref.read(themePreferencesServiceProvider);
    final saved = await service.getThemeMode();
    if (saved != null) {
      state = _fromString(saved);
    }
  }

  // Updates the current theme and saves the user's preference.
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final service = ref.read(themePreferencesServiceProvider);
    await service.setThemeMode(_toString(mode));
  }

  // Converts ThemeMode into a string for storage.
  String _toString(ThemeMode mode) => switch (mode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      };

  // Converts the stored string back into a ThemeMode.
  ThemeMode _fromString(String value) => switch (value) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
}